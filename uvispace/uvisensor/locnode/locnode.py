import threading
import numpy as np
import queue
import configparser
import logging
import zmq
import ast
import time

from uvispace.uvisensor.common import ImgType
from uvispace.uvisensor.locnode import geometry

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("sensor")

class LocalizationNode():
    """
    This class represents a localization node of UviSpace. It permits to
    read images and triangles from the node. It creates threads to
    communicate with the physical localization nodes so the
    communication with the physical device (FPSoC node in the ceiling
    of the lab) does not block when reading an image from this object.
    """
    def __init__(self, num, triang_enabled = True):
        """
        Initializes the localization node object.
        Params:
        num: is the localization node number starting from 0.
            num = 0 for node 1, num = 1 for node 2, etc.
            triang_enabled: if True gets also triangles from nodes
        """
        self.num = num
        self._triang_enabled = triang_enabled

        # Readconfiguration from file
        self._read_config_file(self.num)

        # Initialize class variables
        self._img_type = ImgType.BLACK #by default select black image
        self._img = np.zeros([self.height, self.width], dtype = np.uint8)
        self._triangles = []

        # prepare a socket to read triangles
        if self._triang_enabled:
            self.tri_subscriber = zmq.Context.instance().socket(zmq.SUB)
            self.tri_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            self.tri_subscriber.setsockopt(zmq.CONFLATE, True)
            self.tri_subscriber.connect("tcp://{}:{}".format(self._ip,
                                                        self._port_triang))

        # define triangles thread and launch it
        if self._triang_enabled:
            self._triang_queue = queue.Queue()
            self._thread_triangles = threading.Thread(
                target = self._read_triangles_loop)
            self._thread_triangles.start()

    def _read_config_file(self, num):

        configuration = configparser.ConfigParser()
        conf_file = "uvispace/uvisensor/locnode/config/node{}.cfg".format(num+1)
        configuration.read(conf_file)

        # Read image size from file
        self.width = int(configuration.get("Camera", "width"))
        self.height = int(configuration.get("Camera", "height"))

        # Read ip address and ports
        self._ip = configuration.get("Comm", "ip")
        self._port_bin = int(configuration.get("Comm", "bin_img_port"))
        self._port_gray = int(configuration.get("Comm", "gray_img_port"))
        self._port_rgb = int(configuration.get("Comm", "rgb_img_port"))
        self._port_triang = int(configuration.get("Comm", "triangles_port"))

        # Read parameters to convert from local to global coordinates
        quadrant = configuration.get("Misc", "quadrant")
        if quadrant == "1":
            self.offsets = [self.height, 0]
        elif quadrant == "2":
            self.offsets = [self.height, self.width]
        elif quadrant == "3":
            self.offsets = [0, self.width]
        elif quadrant == "4":
            self.offsets = [0, 0]

        # Store homography matrix (correct barrel distortion)
        raw_h = configuration.get("Misc", "H")
        tuple_format = ",".join(raw_h.split("\n"))
        array_format = ast.literal_eval(tuple_format)
        self.h = np.array(array_format)

    def _read_image_loop(self):
        # Loop
        while self._image_thread_active.isSet():
            #read image from physical localization node
            """
            Read an image from the remote Node and save it into the thread save
            queue
            """
            if self._img_type != ImgType.BLACK:
                # read image from remote node
                message = self.img_subscriber.recv()
                # convert it to a numpy array with correct shape
                if self._img_type == ImgType.RGB:
                    shape = (self.height, self.width, 4)
                    raw_array = np.fromstring(message, dtype=np.uint8).reshape(shape)
                    image = np.zeros((self.height, self.width, 3), dtype=np.uint8)
                    image[:,:,0] = raw_array[:,:,2]
                    image[:,:,1] = raw_array[:,:,1]
                    image[:,:,2] = raw_array[:,:,0]
                    #img = raw_array[:, :, 0:3]
                    #img = np.concatenate((img[:,:,2], img[:,:,1], img[:,:,0]), axis=2)
                elif self._img_type == ImgType.BIN or self._img_type == ImgType.GRAY:
                    image = np.fromstring(message, dtype=np.uint8).reshape((self.height, self.width))
                # save it to class variable (thread-safe)
                self._image_queue.put(image)

    def set_img_type(self, img_type = ImgType.BLACK):
        """
        Change image type. Possible types: BLACK, RAND, RGB, GRAY and BIN
        BLACK and RAND are autogenerated inside this object
        The rest involve communication with an external FPSoC loc node
        """

        logger.debug("Connecting to node {} (ip={}) with {} image type).".format(
            (self.num + 1), self._ip, img_type))

        # stop image thread
        if (self._img_type ==  ImgType.RGB or self._img_type ==  ImgType.BIN or
            self._img_type ==  ImgType.GRAY):
            # make thread to stop
            self._image_thread_active.clear()
            # wait the thread to finish
            self._thread_image.join()

            # stop the socket
            self.img_subscriber.close()

        # Create a new socket
        if (img_type ==  ImgType.RGB or img_type ==  ImgType.BIN or
        img_type ==  ImgType.GRAY):
            self.img_subscriber = zmq.Context.instance().socket(zmq.SUB)
            self.img_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            self.img_subscriber.setsockopt(zmq.CONFLATE, True)
            if img_type ==  ImgType.RGB:
                port = self._port_rgb
            elif img_type ==  ImgType.BIN:
                port = self._port_bin
            else:
                port = self._port_gray
            self.img_subscriber.connect("tcp://{}:{}".format(self._ip, port))
            # Launch a new thread
            self._image_queue = queue.Queue()
            self._image_thread_active = threading.Event()
            self._image_thread_active.set()
            self._thread_image = threading.Thread(target = self._read_image_loop)
            self._thread_image.start()

        # Update the current image type
        self._img_type = img_type

    def get_image(self):
        """
        Returns the last image from the localization node. For black and
        random image the image is autogenerated in this function.
        Returns:
            image_return = image from localization node.
            r = True if image is returned, False otherwise
        """
        img_return = None
        if self._img_type == ImgType.RAND:

            img_return = np.random.randint(0, 255,
                         [self.height, self.width], dtype = np.uint8)
            r = True
        elif self._img_type == ImgType.BLACK:
            img_return = np.zeros([self.height, self.width], dtype = np.uint8)
            r = True
        else:
            img_return = None
            r = False
            # return the last image in the queue
            try:
                while not self._image_queue.empty():
                    image = self._image_queue.get_nowait()
                    img_return = image
                    r = True
            except:
                pass
        return r, img_return

    def _read_triangles_loop(self):
        # Loop
        while True:
            # read triangles from device (wait in the function if no triangles)
            recv_triangles = self.tri_subscriber.recv_json()

            if len(recv_triangles)>0:
                # convert triangle coordinates from local to global and do
                # homography to pass pix to mm and correct lens distortion
                poses = []
                for i in range(len(recv_triangles)):
                    #print(recv_triangles[i])
                    triangle = geometry.Triangle(np.array(recv_triangles[i]))
                    triangle.local2global(self.offsets, K=4)
                    triangle.homography(self.h)
                    pose_tuple = triangle.get_pose()
                    # convert to dict and pass mm to m (all uvispace uses m and radians)
                    pose_dict = {   "x":float(pose_tuple[0]/1000.0),
                                    "y":float(pose_tuple[1]/1000.0),
                                    "theta":float(pose_tuple[2])}
                    poses.append(pose_dict)
                    #print(poses[i])

                # put triangles in the queue

                self._triang_queue.put(poses)

    def get_triangles(self):
        """
        Returns the last triangles from the localization node.
        Returns:
            triang_return = image from localization node.
            r = True if triangles are returned, False otherwise
        """
        triang_return = None
        r = False

        try:
            while not self._triang_queue.empty():
                #print("hola")
                triang_return = self._triang_queue.get_nowait()
                r = True
        except:
            pass

        return r, triang_return
