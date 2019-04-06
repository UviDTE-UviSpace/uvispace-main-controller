import cv2
import time
import sys
import configparser
import zmq
import numpy as np

from uvispace.uvisensor.uvisensor import UviSensor
from uvispace.uvisensor.common import ImgType

if __name__ == '__main__':
    """
    Plots the image type "img_type" from camera number "num".
    Examples:
    python -m uvispace.uvisensor.locnode
    python -m uvispace.uvisensor.locnode <num>
    python -m uvispace.uvisensor.locnode <num> <img_type>
    <num> = 1,2,3,4
    <img_type> = BIN, GRAY, RGB, BLACK, RAND
    """
    if len(sys.argv) == 2:
        if sys.argv[1] == "RGB":
            img_type = ImgType.RGB
        elif sys.argv[1] == "BIN":
            img_type = ImgType.BIN
        elif sys.argv[1] == "GRAY":
            img_type = ImgType.GRAY
        elif sys.argv[1] == "BLACK":
            img_type = ImgType.BLACK
        else:
            img_type = ImgType.RAND
    else:
        img_type = ImgType.GRAY

    # start the stream of multi-images throug zmq socket
    sensor = UviSensor(enable_img = True, enable_triang = False)
    width = sensor.multiframe_width
    height = sensor.multiframe_height

    sensor.start_stream() # starts stream in other thread

    # creates a zmq socket to read the multi images
    configuration = configparser.ConfigParser()
    conf_file = "uvispace/config.cfg"
    configuration.read(conf_file)
    multiframe_port = configuration["ZMQ_Sockets"]["multi_img"]
    img_subscriber = zmq.Context.instance().socket(zmq.SUB)
    img_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
    img_subscriber.setsockopt(zmq.CONFLATE, True)
    img_subscriber.connect("tcp://localhost:{}".format(multiframe_port))

    t1 = time.time()
    frame_rate_counter = 0
    frame_rate_counter_limit = 100
    while(True):
        # read image from remote node
        message = img_subscriber.recv()
        # convert it to a numpy array with correct shape
        if img_type == ImgType.RGB:
            shape = (height, width, 4)
            raw_array = np.fromstring(message, dtype=np.uint8).reshape(shape)
            image = np.zeros((height, width, 3), dtype=np.uint8)
            image[:,:,0] = raw_array[:,:,2]
            image[:,:,1] = raw_array[:,:,1]
            image[:,:,2] = raw_array[:,:,0]
        else:
            image = np.fromstring(message, dtype=np.uint8).reshape((height, width))
        cv2.imshow('stream', image)
        cv2.waitKey(1)
        #calculate framerate
        frame_rate_counter = frame_rate_counter + 1
        if frame_rate_counter == frame_rate_counter_limit:
            frame_rate_counter = 0
            t2 = time.time()
            frame_rate = frame_rate_counter_limit/(t2-t1)
            t1 = t2
            print("frame rate = {}".format(frame_rate))
