import threading
import numpy as np

# image types
BIN_IMG   = 0
GRAY_IMG  = 1
RGB_IMG   = 2
BLACK_IMG = 3

class Camera():
    def __init__(self, cam_num):

        # Read camera constants from file
        self._read_config_file(cam_num)

        # Initialize class variables
        self.img_type = BLACK_IMG
        self.img = np.zeros([self.width, self.height], data_type = np.uint8)
        self.triangles = []

        # Define locks to pass data from threads and class variables
        self.img_type_lock = threading.Lock()
        self.img_lock = threading.Lock()
        self.triangles_lock = threading.Lock()

        # Launch Threads to communicate with the cameras
        self.thread_read_image = threading.Thread()
        self.thread_read_triangles = threading.Thread()
        # launch only triangles by default
        self.thread_read_triangles.start(self._read_triangles)

    def _read_config_file(cam_num):
        # Read image size from file
        # self.width
        # self.height

        # Read ip address and ports
        # self.ip
        # self.port_bin
        # self.port_gray
        # self.port_rgb
        # self.port = [self.port_bin, self.port_gray, self.port_rgb]


    def _read_image(self, img_type):

        # Create zmq socket
        subscriber = zmq.Context.instance().socket(zmq.SUB)
        subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
        subscriber.setsockopt(zmq.CONFLATE, True)
        subscriber.connect("tcp://{}:{}".format(self.ip, self.port[img_type]))

        # Loop
        thread_end = False
        while not thread_end:
            # read image
            recv_img = subscriber.recv()
            # save it to class var outside the thread
            self.img_lock.acquire()
            self.img = recv_img
            self.img_lock.release()
            # check if the thread needs to finish (to change image type)
            self.img_type_lock.acquire()
            if self.image_thread_end:
                thread_end = True
            self.img_type_lock.release()

    def _read_triangles(self):

        # Create zmq socket
        subscriber = zmq.Context.instance().socket(zmq.SUB)
        subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
        subscriber.setsockopt(zmq.CONFLATE, True)
        subscriber.connect("tcp://{}:{}".format(self.ip, self.port[BLACK]))

        # Loop
        while True:
            # read triangles
            recv_triangles = subscriber.recv_json()
            # save it to class var outside the thread
            self.triangles_lock.acquire()
            self.triangles = recv_triangles
            self.triangles_lock.release()

    def set_img_type(self, image_type):

        # stop image threading
        if self.thread_read_image.is_alive():
            # make thread to stop
            self.img_type_lock.acquire()
            self.image_thread_end = True
            self.img_type_lock.release()
            # wait the thread to finish
            self.thread_read_image.join()

        # launch a new thread
        self.image_type = image_type
        self.image_thread_end = False
        if self.image_type != BLACK_IMG:
            self.thread_read_image.start(self._read_image, image_type)

    def pause_video(self):
        self.img_lock.acquire()
        img_lock.acquire()

    def resume_video(self):
        self.img_lock.release()

    def get_image(self):
        self.img_lock.acquire()
        img_return = np.copy(self.img)
        self.img_lock.release()
        return img_return
