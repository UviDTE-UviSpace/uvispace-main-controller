"""
Image Generator. This class reads 4 images from cameras and merges
them into one in QPixMap format (optimum for display in a Qt GUI).
It has the option to add a border for the observable area and add
a virtual UGV.
"""

import numpy as np
import cv2
import zmq
import configparser
from PyQt5.QtGui import QImage, QPixmap
from PIL import Image, ImageQt
import logging
import os

#fps metter
import time

# Create the application logger
logger = logging.getLogger('view')


class ImageGenerator():

    def __init__(self):
        # load info to read images from camera
        self.cam_ips = self._load_ips()
        self.img_size = self._load_image_size()
        self.old_img_type = "BLACK"
        # By default black image without borders and without ugv
        self.img_type = "BLACK"
        self.border_visible = False
        self.ugv_visible = False

        # Load the UGV image (just once in the init)
        self.ugv_image = Image.open('icons/UGV_image.jpg')

        # Create a socket to read UGV locations
        # Open a subscribe socket to listen for position data
        self.pose_subscriber = zmq.Context.instance().socket(zmq.SUB)
        self.pose_subscriber.setsockopt_string(zmq.SUBSCRIBE, u"")
        self.pose_subscriber.setsockopt(zmq.CONFLATE, True)
        self.pose_subscriber.connect("tcp://localhost:{}".format(
            int(35000)))
             #   int(os.environ.get("UVISPACE_BASE_PORT_POSITION"))))

    def _load_ips(self):
        """
        Load the cameras IPs from the .cfg files
        Uses the configparser lib to read .cfg files
        """
        cameras_IPs = []
        for i in range(1, 5):
            ipscam = configparser.ConfigParser()
            rel_path = '../uvisensor/resources/config/video_sensor' + str(i) + '.cfg'
            ipscam.read(rel_path)
            cameras_IPs.append(ipscam.get('VideoSensor', 'IP'))
        logger.info("Cameras IPs loaded")
        return cameras_IPs


    def _load_image_size(self):
        """
        Load the image size from a .cfg file. Because all the cameras have the same
        size, only reads one config file.
        It returns a list with image dimensions:  [img_width, img_height]
        """
        size = configparser.ConfigParser()
        rel_path = '../uvisensor/resources/config/video_sensor1.cfg'
        size.read(rel_path)
        img_size = [(size.getint('Camera', 'width')),
                    (size.getint('Camera', 'height'))]
        logger.info("Cameras size loaded")
        return img_size

    def reconnect_cameras(self):

        if self.img_type == "BLACK":
            for i in range(4):
                self.receiver[i].close()
            logger.debug("Sockets closed")

        # disconnect from old image type
        """ if self.img_type == "BLACK":
            #disconnect from BIN image port
            if self.old_img_type == "BIN":
                for i in range(4):
                    self.receiver[i].disconnect("tcp://" + self.cam_ips[i] +
                    ":33000")
                else: #disconnect from GRAY
                    self.receiver[i].disconnect("tcp://" + self.cam_ips[i] +
                    ":34000")"""

        # connect to new image type
        if self.img_type != "BLACK":
            self.receiver = []
            for i in range(4):
                self.receiver.append(zmq.Context.instance().socket(zmq.SUB))
                logger.info("Connected to camera '%s' ", i)
                if self.img_type == "BIN":
                    self.receiver[i].connect("tcp://" + self.cam_ips[i] +
                    ":33000")
                else:  # "GRAY" and "RGB"
                    self.receiver[i].connect("tcp://" + self.cam_ips[i] +
                    ":34000")
                self.receiver[i].setsockopt_string(zmq.SUBSCRIBE, u"")
                self.receiver[i].setsockopt(zmq.CONFLATE, True)

        # save the image type
        self.old_img_type = self.img_type

    def set_img_type(self, img_type="BLACK"):
        logger.debug("Changed image type")
        self.img_type = img_type
        self.reconnect_cameras()

    def set_border_visible(self, border_visible=False):
        self.border_visible = border_visible

    def set_ugv_visible(self, ugv_visible=False):
        self.ugv_visible = ugv_visible

    def get_image(self):
        # Gets the images from the cameras using the socket opened in
        # "reconnect_cameras". Then, stacks the images from the four cameras
        # Images are stacked using the given path, following
        # the physical setup of the cameras:
        #     Image2         Image1
        #
        #     Image3         Image4
        #
        # First, image1 and 2 are stack, then image 3 and 4.
        # Finally, the 4 images are joined

        if self.img_type == "BLACK":
            multi_image_np = np.zeros([self.img_size[1]*2, self.img_size[0]*2],
                                      dtype=np.uint8)
        else:
            image = []
            start = time.time()
            for i in range(4):
                message = self.receiver[i].recv()
                image.append(np.fromstring(message,
                             dtype=np.uint8).reshape((self.img_size[1],
                                                     self.img_size[0])))

            # Stack the array using concatenate, first stacks horizontally,
            # then, one on top of the other
            image12 = np.concatenate((image[2 - 1], image[1 - 1]), axis=1)
            image34 = np.concatenate((image[3 - 1], image[4 - 1]), axis=1)
            multi_image_np = np.concatenate((image12, image34), axis=0)

            #calculate fps
            #logger.debug("FPS: '%s'", 1.0 / (time.time() - start))

        # Add uvispace border if requested
        if self.border_visible:
            multi_image_np = self._draw_border(multi_image_np)

        # Transform from numpy to PIL image (better for adding the UGV)
        # TODO ----------MAKE THIS!!!!!!-----------#

        # Add ugv if requested
        if self.ugv_visible:
            multi_image_np = self._draw_ugv(multi_image_np)

        # Transform from PIL to QPixMap image
        # PIL permits numpy to QPixMap without errors (image mix)
        multi_image_pil = Image.fromarray(multi_image_np)
        qpixmap_multi_image = QImage(ImageQt.ImageQt(multi_image_pil))

        return qpixmap_multi_image

    def _draw_border(self, image):
        # draw the grid lines  (in opencv the coordinates system is different)
        # x axis as usual, from left to right
        # y axis from top to bottom
        # if image changes to rgb the 4th parameter should be changed to (r,g,b)
        # upper line
        cv2.line(image, (10, 10), (1270, 10), 255, 4)
        # lower line
        cv2.line(image, (10, 926), (1270, 926), 255, 4)
        # left line
        cv2.line(image, (10, 10), (10, 926), 255, 4)
        # right line
        cv2.line(image, (1270, 10), (1270, 926), 255, 4)
        # horizontal origin
        cv2.line(image, (640, 468), (740, 468), 255, 4)
        # vertical origin
        cv2.line(image, (640, 368), (640, 468), 255, 4)

        return image

    def _draw_ugv(self, image):
        """
        Draw the ugv
        :param image: numpy image
        :return: numpy image array
        """

        # read coordinates from real UGV
        pose = self.pose_subscriber.recv_json()

        dst_im = Image.fromarray(image)

        self.ugv_image = self.ugv_image.convert('RGBA')
        rot = self.ugv_image.rotate(pose['theta'], expand=1).resize(
                                                    self.ugv_image.size)
        dst_im.paste(rot, (pose['x']-int(self.ugv_image.size[0]/2),
                           pose['y']-int(self.ugv_image.size[1]/2)), rot)
        dst_im.convert('RGB')
        array_image = np.array(dst_im)
        # cv2.imwrite('save2.jpg', array_image)

        return array_image

