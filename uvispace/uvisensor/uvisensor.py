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
    - Locate vehicles and post their location in pose ZMQ sockets.
    """
    def __init__(self, enable_img = True, enable_triang = True, threaded = False):
        """
        Initialices the localization node array
        Params:
        - enable_img = enables images
        - enable_triang = enables triangles
        - threaded = uvisensor launches in other thread
        """

        self.enable_img = enable_img
        self.enable_triang = enable_triang
        self.threaded = threaded

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
        self.config_port = int(configuration["ZMQ_Sockets"]["uvisensor_config"])
        self.position_port_base = int(configuration["ZMQ_Sockets"]["position_base"])
        # real or simulated ugvs??
        self.simulated_ugvs = strtobool(configuration["Run"]["simulated_ugvs"])
        # row and column position of each localization node
        self.rows = list(map(int, configuration["LocNodes"]["rows"].split(",")))
        self.cols = list(map(int, configuration["LocNodes"]["cols"].split(",")))
        # number of ugvs
        self.num_ugvs = int(configuration["UGVs"]["number_ugvs"])

        # create the different nodes in the system:
        self.nodes = [None for i in range(self.number_nodes)]
        for num in range(self.number_nodes):
            self.nodes[num] = locnode.LocalizationNode(num,
                                        triang_enabled = self.enable_triang )
            self.nodes[num].set_img_type(ImgType.BLACK)

        # array that permits accessing the correct node using row and column
        self.node_array = [[None for i in range(self.node_array_width)]
                            for j in range(self.node_array_height)]
        for row in range(self.node_array_height):
            for col in range(self.node_array_width):
                # search the loc node number for that location
                for num in range(self.number_nodes):
                    if (self.rows[num] == row) and self.cols[num] == col:
                        self.node_array[row][col] = self.nodes[num]

        # dimensions of the image from one localization node
        self.locnode_width =  self.nodes[0].width
        self.locnode_height =  self.nodes[0].height
        # dimensions of the multi-image
        self.multiframe_width =  self.node_array_width * self.locnode_width
        self.multiframe_height =  self.node_array_height * self.locnode_height

        # if threaded mode is selected prepare elements to launch stream in
        # different thread
        self._kill_thread = threading.Event()
        self._kill_thread.clear()
        if self.threaded:
            self.thread = threading.Thread(target = self.acquisition_loop)

    def start_stream(self):
        """
        Starts publishing images and ugv locations in their respective sockets
        """
        logger.info("Starting UviSensor.")
        if self.threaded:
            self._kill_thread.clear()
            self.thread.start()
        else:
            self.acquisition_loop()

    def stop_stream(self):
        """
        It permits to stop the stream and finish the thread in threaded mode
        """
        logger.info("Stopping UviSensor.")
        self._kill_thread.set()
        # wait until the thread finishes
        self.thread.join()

    def acquisition_loop(self):

        # acquisition variables
        frames = [[None for i in range(self.node_array_width)]
                            for j in range(self.node_array_height)]
        frame_row = [None for i in range(self.node_array_width)]
        multiframe = np.zeros([self.multiframe_width, self.multiframe_height],
                    dtype = np.uint8)
        counter = 0

        if not self.simulated_ugvs:
            # create a list to store the triangles from each localization node
            triangles_cam = [[]]*self.number_nodes
            # # get initial triangles (wait until all localization nodes are checked)
            # for num in range(self.number_nodes):
            #     r = False
            #     while not r:
            #         r, tri = self.nodes[num].get_triangles()
            #     triangles_cam[num] = tri
            # # Create the pose calculator with this triangles
            # # pose_calculator = PoseCalculator()
            # # ugvs = pose_calculator.shapes_to_poses(triangles_cam)

        # publising sockets
        pose_publishers = []
        if not self.simulated_ugvs:
            for i in range(self.num_ugvs):
                pose_publisher = zmq.Context.instance().socket(zmq.PUB)
                pose_publisher.sndhwm = 1
                pose_publisher.bind("tcp://*:{}".format(self.position_port_base + i))
                pose_publishers.append(pose_publisher)
        multiframe_publisher = zmq.Context.instance().socket(zmq.PUB)
        multiframe_publisher.sndhwm = 1
        multiframe_publisher.bind("tcp://*:{}".format(self.multiframe_port))
        # socket to read requests for changing image configuration
        config_socket = zmq.Context().instance().socket(zmq.REP)
        config_socket.bind("tcp://*:{}".format(self.config_port))

        while not self._kill_thread.isSet():

            if self.enable_triang and not self.simulated_ugvs:

                # get triangles from cameras
                for num in range(self.number_nodes):
                    r, tri = self.nodes[num].get_triangles()
                    if r:
                        print(tri)
                        pose_publishers[0].send_json(tri[0])

            if self.enable_img:
                # check for a new command from GUI to change camera settings
                try:
                    #check for a message, this will not block
                    # if no message it leaves the try because zmq behaviour
                    config_dict = config_socket.recv_json(flags=zmq.NOBLOCK)
                    # change image type of all localization nodes
                    for i in range(self.number_nodes):
                        self.nodes[i].set_img_type(config_dict["img_type"])
                    config_socket.send_json("OK")
                except:
                    pass
                # get and send images from localization node at lower pace
                counter = counter + 1
                if counter >= (self.node_framerate//self.visualization_framerate):
                    # create the multiframe image
                    for row in range(self.node_array_height):
                        for col in range(self.node_array_width):
                            r, image = self.node_array[row][col].get_image()
                            if r:
                                frames[row][col]=image
                        #concatenate this row
                        frame_row[row] = np.concatenate(frames[row], axis=1)
                    # concatenate all rows in single image
                    multiframe = np.concatenate(frame_row, axis=0)

                    # send the multiimage
                    multiframe_publisher.send(multiframe)
