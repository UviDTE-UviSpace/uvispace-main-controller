import threading
import numpy as np
import configparser
import zmq
import copy

class Camera():
    """
    Object representing an FPSoC camera. When the object is created
    the camera reads its configuration from the corresponding configuration
    file. Then, if threaded, launches a communication thread with the physical camera
    in the ceiling of the lab. When a new image arrives from the physical camera
    into the thread it is copied outside the thread to a class variable.
    Then when the creator of this object asks for an image the class variable is
    given so it takes zero time for the image to be retrieved from this object.
    If not threaded an image is retrieved from the physical camera when
    asked by the creator of this object. Use threaded when fusing
    this info with anotherone and use non-threaded when just accessing this
    camera, so the frame rate is the same of the real camera.
    """
    def __init__(self, cam_num, threaded = True, triang_enabled = True):
        """
        Initializes the Camera object
        Params:
        cam_num: camera number. used to find the correct config file
        threaded: True is threaded, False in non-threaded
        triang_enabled: if True gets also triangles from cameras
        """
        self.num = cam_num
        self._threaded = threaded
        self._triang_enabled = triang_enabled

        # Read camera constants from file
        self._read_config_file(self.num)

        # Initialize class variables
        self._img_type = "BLACK" #by default select black image
        self._img = np.zeros([self._height, self._width], dtype = np.uint8)
        self._triangles = []

        # prepare a socket to read triangles
        if self._triang_enabled:
            self.tri_subscriber = zmq.Context.instance().socket(zmq.SUB)
            self.tri_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            self.tri_subscriber.setsockopt(zmq.CONFLATE, True)
            self.tri_subscriber.connect("tcp://{}:{}".format(self.ip,
                                                        self._port_triang))

        # if threaded then prepare some variables
        if threaded:
            # Define locks to pass data from threads and class variables
            self._img_lock = threading.Lock()
            self._triangles_lock = threading.Lock()
            # Launch Threads to communicate with the camera
            self._thread_image = None
            self._thread_triangles = threading.Thread()
            # Mechanisms to stop the image thread
            self._image_thread_end = False
            # launch only triangles by default
            if self._triang_enabled:
                # Create reading loop
                self._thread_triangles.start(self._read_triangles_loop)

    def _read_config_file(self, cam_num):

        configuration = configparser.ConfigParser()
        file_root = "uvispace/uvisensor/camera/config/"
        configuration.read(file_root + "video_sensor{}.cfg".format(cam_num))

        # Read image size from file
        self._width = int(configuration.get("Camera", "width"))
        self._height = int(configuration.get("Camera", "height"))

        # Read ip address and ports
        self._ip = configuration.get("Comm", "ip")
        self._port = {}
        self._port ["BIN"] = int(configuration.get("Comm", "bin_img_port"))
        self._port ["GRAY"] = int(configuration.get("Comm", "gray_img_port"))
        self._port ["RGB"] = int(configuration.get("Comm", "rgb_img_port"))
        self._port_triang = int(configuration.get("Comm", "triangles_port"))

    def _read_image_loop(self, img_type):
        # Loop
        thread_end = False
        while not thread_end:
            #read image from real camera
            self._read_remote_image()
            # check if the thread needs to finish (to change image type)
            self._img_type_lock.acquire()
            if self._image_thread_end:
                thread_end = True
            self._img_type_lock.release()

    def _read_remote_image(self):
        """
        Read an image from the remote Camera and save it into the class variable
        self._img as a numpy array with the correct shape
        """
        if self._img_type != "BLACK":
            # read image from remote camera
            message = self.img_subscriber.recv()
            # convert it to a numpy array with correct shape
            if self._img_type == "RGB":
                shape = (self._height, self._width, 4)
                raw_array = np.fromstring(message, dtype=np.uint8).reshape(shape)
                image = np.zeros((self._height, self._width, 3), dtype=np.uint8)
                image[:,:,0] = raw_array[:,:,2]
                image[:,:,1] = raw_array[:,:,1]
                image[:,:,2] = raw_array[:,:,0]
                #img = raw_array[:, :, 0:3]
                #img = np.concatenate((img[:,:,2], img[:,:,1], img[:,:,0]), axis=2)
            elif self._img_type == "BIN" or self._img_type == "GRAY":
                image = np.fromstring(message, dtype=np.uint8).reshape((self._height, self._width))
            # save it to class variable (thread-safe)
            if self._threaded:
                self._img_lock.acquire()
                self._img = copy.deepcopy(image)
                self._img_lock.release()
            else:
                self._img = copy.copy(image)

    def set_img_type(self, img_type = "BLACK"):
        """
        Change image type. Possible types: BLACK, RAND, RGB, GRAY and BIN
        BLACK and RAND are autogenerated inside this object
        The rest involve communication with an external FPSoC camera
        """
        # stop image thread
        if (self._img_type == "RGB" or self._img_type == "BIN" or
            self._img_type == "GRAY"):

            # make thread to stop
            self._img_type_lock.acquire()
            self.image_thread_end = True
            self._img_type_lock.release()
            # wait the thread to finish
            self._thread_image.join()

            # stop the socket
            self.img_subscriber.close()

        # Create a new socket
        if (img_type == "RGB" or img_type == "BIN" or img_type == "GRAY"):
            self.img_subscriber = zmq.Context.instance().socket(zmq.SUB)
            self.img_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            self.img_subscriber.setsockopt(zmq.CONFLATE, True)
            self.img_subscriber.connect("tcp://{}:{}".format(self._ip,
                                    self.port[image_type]))

        # Launch a new thread
        if self._threaded:
            self._image_thread_end = False
            self._thread_image.start(self._read_image_loop)

        # Update the current image type
        self._img_type = img_type

    def get_image(self):

        if self._img_type == "RAND":
            img_return = np.random.randint(1000, 50000,
                         [self._height, self._width], dtype = np.uint16)
        else:
            if self._threaded:
                # in threaded mode self.image is automatically updated from thread
                self._img_lock.acquire()
                img_return = np.deepcopy(self._img)
                self._img_lock.release()
            else:
                # in non threaded mode we first need to read a new image from camera
                self._read_remote_image()
                img_return = self._img

        return img_return

    def _read_triangles_loop(self):
        # Loop
        while True:
            self._read_remote_triangles()

    def _read_remote_triangles():
        # read triangles
        recv_triangles = tri_subscriber.recv_json()
        # save it to class var outside the thread
        self._triangles_lock.acquire()
        self._triangles = copy.deepcopy(recv_triangles)
        self._triangles_lock.release()

    def get_triangles(self):

        if self._threaded:
            # in threaded mode self._triangles is auto updated from thread
            self._triangles_lock.acquire()
            triangles_return = np.deepcopy(self._triangles)
            self._triangles_lock.release()
        else:
            # in non threaded mode we first need to read triangles from camera
            self._read_remote_triangles()
            triangles_return = self._triangles

        return triangles_return
