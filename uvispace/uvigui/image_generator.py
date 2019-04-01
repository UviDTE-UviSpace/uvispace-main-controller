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
logger = logging.getLogger('view.aux')


class ImageGenerator():

    def __init__(self):
        # logger
        self.logger = logging.getLogger('view.aux.aux')
        self.logger.info("image loger created")
        # load info to read images from camera
        self.cam_ips = self._load_ips()

        self.img_size = self._load_image_size()
        self.old_img_type = "BLACK"
        # By default black image without borders and without ugv
        self.img_type = "BLACK"
        self.border_visible = False
        self.ugv_visible = False

        # Load the UGV image (just once in the init)

        # Create a socket to read UGV locations
        # Open a subscribe socket to listen for position data
        self.pose_subscriber = zmq.Context.instance().socket(zmq.SUB)
        self.pose_subscriber.setsockopt_string(zmq.SUBSCRIBE, u"")
        self.pose_subscriber.setsockopt(zmq.CONFLATE, True)
        #self.pose_subscriber.connect("tcp://" + "192.168.0.51" + ":35000")
        self.pose_subscriber.connect("tcp://localhost:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_POSITION"))+1))


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
        self.logger.info("Cameras IPs loaded")
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
        self.logger.info("Cameras size loaded")
        return img_size

    def reconnect_cameras(self):

        if self.img_type == "BLACK":
            for i in range(4):
                self.receiver[i].close()
            self.logger.debug("Sockets closed")

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
                self.logger.info("Connected to camera '%s' ", i)
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
        self.logger.debug("Changed image type")
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
            #self.logger.debug("FPS: '%s'", 1.0 / (time.time() - start))

        # Add uvispace border if requested
        if self.border_visible:
            multi_image_np = self._draw_border(multi_image_np)

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
        # receive pose
        #print("antes recv json")
        pose = self.pose_subscriber.recv_json()
        """pose = {}
        pose = {
            'x': 360,
            'y': 280,
            'theta': 0
        }"""
        #print("pos function")
        x_mm = pose['x']
        self.logger.debug("posicion x: '%s'", x_mm)
        y_mm = pose['y']
        logger.debug("posicion y: '%s'", y_mm)
        x_pix = int((x_mm + 2000) * 1280 / 4000)
        y_pix = int((-y_mm + 1500) * 936 / 3000)

        angle = pose['theta'] + np.pi/2

        # triangle size
        height = 60
        width = 50

        # vertex coordinates before rotating
        x1 = x_pix
        y1 = y_pix - height / 2
        x2 = x_pix + width / 2
        y2 = y_pix + height / 2
        x3 = x_pix - width / 2
        y3 = y2

        # rotating
        x1r = (x1 - x_pix) * np.cos(angle) - (y1 - y_pix) * np.sin(
            angle) + x_pix
        y1r = -(x1 - x_pix) * np.sin(angle) - (y1 - y_pix) * np.cos(
            angle) + y_pix

        x2r = (x2 - x_pix) * np.cos(angle) - (y2 - y_pix) * np.sin(
            angle) + x_pix
        y2r = -(x2 - x_pix) * np.sin(angle) - (y2 - y_pix) * np.cos(
            angle) + y_pix

        x3r = (x3 - x_pix) * np.cos(angle) - (y3 - y_pix) * np.sin(
            angle) + x_pix
        y3r = -(x3 - x_pix) * np.sin(angle) - (y3 - y_pix) * np.cos(
            angle) + y_pix

        # casting to integer
        x1r = int(x1r)
        y1r = int(y1r)
        x2r = int(x2r)
        y2r = int(y2r)
        x3r = int(x3r)
        y3r = int(y3r)
        # drawing the lines on the image
        cv2.line(image, (x1r, y1r), (x2r, y2r), 255, 4)
        cv2.line(image, (x2r, y2r), (x3r, y3r), 255, 4)
        cv2.line(image, (x1r, y1r), (x3r, y3r), 255, 4)

        return image
