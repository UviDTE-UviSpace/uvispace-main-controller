import threading
from distutils.util import strtobool
import logging
import configparser
import zmq
import numpy as np

from uvispace.uvisensor.locnode import locnode
from uvispace.uvisensor.common import ImgType

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("sensor")

class UviSensor():
    """
    This class controls several localization nodes in some array arrangement.
    Localization nodes are used for:
    - Creating a multiimage (combining images from all nodes) and post it
      through a ZMQ socket for the GUI.
    - Locate vehicles and post their location in another ZMQ sockets.
    """
    def __init__(self, enable_img = True, enable_triang = True):
        """
        Initialices the localization node array
        Params:
        - enable_img = enables images
        - enable_triang = enables triangles
        - simulated_ugv = if False location is calculated from triangles
                          if True location is obtained from the
                          simulated_location_base sockets
        """

        self.enable_img = enable_img
        self.enable_triang = enable_triang

        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)

        # get desired  frame rates
        self.node_framerate = int(configuration["LocNodes"]["cameras_frame_rate"])
        self.visualization_framerate = int(configuration["GUI"]["visualization_fps"])
        # calculate number of nodes and arrangement
        self.number_nodes = int(configuration["LocNodes"]["number_nodes"])
        self.node_array_width = int(configuration["LocNodes"]["node_array_width"])
        self.node_array_height = int(configuration["LocNodes"]["node_array_height"])
        # sockets
        self.multiframe_port = int(configuration["ZMQ_Sockets"]["multi_img"])
        self.position_port = int(configuration["ZMQ_Sockets"]["position_base"])

        # real or simulated ugvs??
        self.simulated_ugvs = strtobool(configuration["Run"]["simulated_ugvs"])

        # create nodes using physical arrangement in the lab
        ###########################################
        #                    #                    #
        #   cam 2 (num = 1)  #   cam 1 (num = 0)  #
        #   array pos (0,0)  #   array pos (0,1)  #
        ###########################################
        #                    #                    #
        #   cam 3 (num = 2)  #   cam 4 (num = 3)  #
        #   array pos (1,0)  #   array pos (1,1)  #
        ###########################################

        # TODO: get col and row arrangement from uvispace config file
        arow = [0, 0, 1, 1]
        acol = [1, 0, 0, 1]
        self.node = [None]*self.number_nodes
        for num in range(self.number_nodes):
            self.node[num] = {}
            self.node[num]["device"] = locnode.LocalizationNode(num,
                                        triang_enabled = self.enable_triang )
            self.node[num]["device"].set_img_type(ImgType.BLACK)
            self.node[num]["row"] = arow[num]
            self.node[num]["col"] = acol[num]

        self.width =  self.node_array_width * self.node[0]["device"].width
        self.height =  self.node_array_height * self.node[0]["device"].height

        # define thread object
        self.thread = threading.Thread(target = self.acquisition_loop)

    def start_stream(self):
        """
        Starts new threads for publishing images and ugv locations in their
        respective sockets
        """
        logger.info("Starting Uvisensor.")
        self.thread.start() #launches run in a new thread

    def acquisition_loop(self):
        # acquisition variables
        triangle = [None]*self.number_nodes
        frame = [None]*self.number_nodes
        multiframe = np.zeros([self.height, self.width], dtype = np.uint8)
        print(multiframe.shape)
        counter = 0

        # publising sockets
        position_publisher = zmq.Context.instance().socket(zmq.PUB)
        position_publisher.sndhwm = 1
        position_publisher.bind("tcp://*:{}".format(self.position_port))
        multiframe_publisher = zmq.Context.instance().socket(zmq.PUB)
        multiframe_publisher.sndhwm = 1
        multiframe_publisher.bind("tcp://*:{}".format(self.multiframe_port))

        while(True):

            if self.enable_triang:
                # get triangles from cameras
                for num in range(self.number_nodes):
                    r, triangles = self.node[num]["device"].get_triangles()
                    if r:
                        triangles[num] = triangles
            # calculate location of UGVs for triangles

            # publish location

            if self.enable_img:
                # check for a new command from GUI to change camera settings

                # get and send images from localization node at lower pace
                counter = counter + 1
                if counter >= (self.node_framerate//self.visualization_framerate):
                    # read image from devices
                    for num in range(self.number_nodes):
                        r, image = self.node[num]["device"].get_image()
                        print(image.shape)
                        if r:
                            # if there is new image add it to multiimage
                            pix_col_first = self.node[num]["col"]*self.node[0]["device"].width
                            pix_col_last = (self.node[num]["col"]+1)*self.node[0]["device"].width
                            pix_row_first = self.node[num]["row"]*self.node[0]["device"].height
                            pix_row_last = (self.node[num]["row"]+1)*self.node[0]["device"].height
                            print("num={}cf={},cf={},cf={},cf={}".format(num,pix_col_first,pix_col_last,pix_row_first,pix_row_last))
                            multiframe[pix_row_first:pix_row_last, pix_col_first: pix_col_last] = image

                # send the multiimage
                multiframe_publisher.send(multiframe)
