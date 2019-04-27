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

from uvispace.uvisensor.common import ImgType
# img_type = ImgType.RAND

class ImageGenerator():

    def __init__(self, num_ugvs):
        # logger
        self.logger = logging.getLogger('view.aux.aux')
        self.logger.info("image loger created")

        # By default black image without borders and without ugv
        self.img_type = ImgType.BLACK
        self.border_visible = False
        self.ugv_visible = False
        self.trajectory_visible = False
        self.selected_ugv = 0

        uvispace_config = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        uvispace_config.read(conf_file)

        node_config = configparser.ConfigParser()
        conf_file = "uvispace/uvisensor/locnode/config/node1.cfg"
        node_config.read(conf_file)

        node_array_width = int(uvispace_config["LocNodes"]["node_array_width"])
        node_array_height = int(
            uvispace_config["LocNodes"]["node_array_height"])
        single_image_width = int(node_config.get("Camera", "width"))
        single_image_height = int(node_config.get("Camera", "height"))
        self.width = single_image_width * node_array_width
        self.height = single_image_height * node_array_height

        # creates zmq socket to read image from multiframe
        multiframe_port = uvispace_config["ZMQ_Sockets"]["multi_img"]
        self.img_subscriber = zmq.Context.instance().socket(zmq.SUB)
        self.img_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
        self.img_subscriber.setsockopt(zmq.CONFLATE, True)
        self.img_subscriber.connect("tcp://localhost:{}".format(multiframe_port))

        uvisensor_config_port = uvispace_config["ZMQ_Sockets"]["uvisensor_config"]
        self.config_requester = zmq.Context.instance().socket(zmq.REQ)
        self.config_requester.connect(
            "tcp://localhost:{}".format(uvisensor_config_port))

        # create an object to store poses
        self.poses = [None]*num_ugvs

        # create objects to store real and desired trajectories of selected ugv
        self.real_trajectory = {"x":[], "y":[]}
        self.desired_trajectory = {"x":[], "y":[]}

        # set default image type
        uvisensor_config = {"img_type": self.img_type}
        logger.debug("Sending configuration to UviSensor...")
        self.config_requester.send_json(uvisensor_config)
        response = self.config_requester.recv_json()  # waits until response
        logger.debug("Configuration finished. Starting streaming...")

    def set_pose(self, ugv_number, pose):
        # update last pose (to be used to draw triangle)
        self.poses[ugv_number] = pose
        # add the pose to the pose history (to plot the trajectory)
        if len(self.real_trajectory["x"]) == 0:
            # if empty just add a point
            self.real_trajectory["x"].append(pose["x"])
            self.real_trajectory["y"].append(pose["y"])
        else:
            # if not empty add if the movement was significant (>1cm)
            if ((abs(pose["x"] - self.real_trajectory["x"][-1])>0.01) or
            (abs(pose["y"] - self.real_trajectory["y"][-1])>0.01)):
                self.real_trajectory["x"].append(pose["x"])
                self.real_trajectory["y"].append(pose["y"])

    def clean_real_trajectory(self):
        self.real_trajectory = {"x":[], "y":[]}

    def set_desired_trajectory(self, desired_trajectory):
        self.desired_trajectory = desired_trajectory

    def set_img_type(self, img_type):
        # changes the image type on the gui
        self.img_type = img_type
        uvisensor_config = {"img_type": img_type}
        logger.info("Sending configuration {} to UviSensor...".format(img_type))
        print(self.img_type)
        self.config_requester.send_json(uvisensor_config)
        response = self.config_requester.recv_json()  # waits until response
        logger.info("UviSensor configuration finished. Starting streaming...")

    def set_border_visible(self, border_visible=False):
        self.border_visible = border_visible

    def set_ugv_visible(self, ugv_visible=False):
        self.ugv_visible = ugv_visible

    def set_trajectory_visible(self, trajectory_visible=False):
        self.trajectory_visible = trajectory_visible

    def set_selected_ugv(self, ugv_selected=0):
        self.selected_ugv = ugv_selected

    def get_image(self):

        try:
            # Receive image from multiframe uvisensor
            message = self.img_subscriber.recv(flags=zmq.NOBLOCK)
            multi_image_np = np.fromstring(message, dtype=np.uint8).reshape(self.height,
                                                                            self.width)
            # Add uvispace border if requested
            if self.border_visible:
                multi_image_np = self._draw_border(multi_image_np)

            # Add ugv drawing if requested
            if self.ugv_visible:
                multi_image_np = self._draw_ugv(multi_image_np)

            # add trajectories if requested:
            if self.trajectory_visible:
                multi_image_np = self._draw_trajectories(multi_image_np)

            multi_image = Image.fromarray(multi_image_np)
            qpixmap_multi_image = QImage(ImageQt.ImageQt(multi_image))
            r = True
        except:
            qpixmap_multi_image = None
            r = False

        return r, qpixmap_multi_image

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
        # Now it takes the first vehicle by default
        # TODO do it multivehicle
        pose = self.poses[0]

        x_mm = pose['x']*1000
        y_mm = pose['y']*1000
        # translate uvispace pose to pixel representation
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

    def _draw_trajectories(self, image):
        # if a trajectory is loaded, draw
        # translate uvispace pose to pixel repersentation
        # x_pix = int((x_mm + 2000) * 1280 / 4000)
        # y_pix = int((-y_mm + 1500) * 936 / 3000)
        print(len(self.desired_trajectory))
        if len(self.desired_trajectory['x']) > 0:
            des_traj = list(self.desired_trajectory.values())
            des_traj = np.transpose(np.asarray(des_traj))
            print(des_traj)
            for i in range(len(des_traj)):
                des_traj[i][0] = int((des_traj[i][0] + 2000) * 1280 / 4000)
                des_traj[i][1] = int((des_traj[i][1] + 1500) * 936 / 3000)
            cv2.polylines(image, [des_traj], False, 255, 4)
        else:
            logger.warning("No desired trajectory loaded")
        # if real trajectory available
        print(self.real_trajectory)
        if len(self.real_trajectory['x']) > 1:
            real_traj = list(self.real_trajectory.values())
            real_traj = np.transpose(np.asarray(real_traj))
            print(real_traj)
            for i in range(len(real_traj)):
                real_traj[i][0] = int((real_traj[i][0] + 2000) * 1280 / 4000)
                real_traj[i][1] = int((real_traj[i][1] + 1500) * 936 / 3000)
            cv2.polylines(image, [real_traj], False, 120, 4)
        else:
            logger.warning("No real trajectory available")

        return image
