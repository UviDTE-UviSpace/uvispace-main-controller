#!/usr/bin/env python
"""This module contains the VideoSensor class.

The VideoSensor class allows to request the triangles found in a camera.
"""
# Standard libraries
import ast
import ConfigParser
import logging
import sys
# Third party libraries
import numpy as np
import zmq
# Local libraries
import geometry

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("sensor")


class VideoSensor:
    def __init__(self, configuration_file):
        # Obtain configuration
        configuration = ConfigParser.ConfigParser()
        configuration.read(configuration_file)
        # Store image dimension
        # FIXME [floonone-20171128] read parameters from config file
        self.__width = 640
        self.__height = 480
        # Store quadrant limits
        raw_limits = configuration.get("Misc", "limits")
        # Format the value in order to get a 3x3 array.
        tuple_format = ",".join(raw_limits.split("\n"))
        array_format = ast.literal_eval(tuple_format)
        self.limits = np.array(array_format)

        # Store camera offsets
        # Get the physical quadrant value
        quadrant = configuration.get("Misc", "quadrant")
        if quadrant == "1":
            offsets = [self.__height, 0]
        elif quadrant == "2":
            offsets = [self.__height, self.__width]
        elif quadrant == "3":
            offsets = [0, self.__width]
        elif quadrant == "4":
            offsets = [0, 0]
        # FIXME [floonone-20171128] this check should be done like this
        try:
            self.offsets = offsets
        except UnboundLocalError:
            raise AttributeError("Quadrant not valid: {}".format(quadrant))

        # Store homography matrix
        raw_h = configuration.get("Misc", "H")
        tuple_format = ",".join(raw_h.split("\n"))
        array_format = ast.literal_eval(tuple_format)
        self.h = np.array(array_format)

        # Store ip and port and open connection to camera
        self.__ip = configuration.get("VideoSensor", "ip")
        self.__port = int(configuration.get("VideoSensor", "port"))
        self.__socket = zmq.Context.instance().socket(zmq.SUB)
        self.__socket.connect("tcp://{}:{}".format(self.__ip, self.__port))
        self.__socket.setsockopt_string(zmq.SUBSCRIBE, u"")
        self.__socket.setsockopt(zmq.CONFLATE, True)

    def find_triangles(self):
        triangles = []
        # TODO [floonone-20171128] change to polling mode
        figures = self.__socket.recv_json()
        for figure in figures:
            triangle = geometry.Triangle(np.array(figure))
            triangles.append(triangle)
        return triangles
