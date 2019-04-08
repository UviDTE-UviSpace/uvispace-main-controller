import cv2
import time
import sys
import configparser
import zmq
import numpy as np
from os.path import realpath, dirname

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

from uvispace.uvisensor.uvisensor import UviSensor
from uvispace.uvisensor.common import ImgType

img_type = ImgType.RAND

if __name__ == '__main__':
    """
    This main reads from UviSensor socket the multiframe image and plots it.
    """

    # load configs
    uvispace_config = configparser.ConfigParser()
    conf_file = "uvispace/config.cfg"
    uvispace_config.read(conf_file)
    node_config = configparser.ConfigParser()
    conf_file = "uvispace/uvisensor/locnode/config/node1.cfg"
    node_config.read(conf_file)

    # creates zmq socket to configure the uvisensor
    multiframe_port = uvispace_config["ZMQ_Sockets"]["multi_img"]
    img_subscriber = zmq.Context.instance().socket(zmq.SUB)
    img_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
    img_subscriber.setsockopt(zmq.CONFLATE, True)
    img_subscriber.connect("tcp://localhost:{}".format(multiframe_port))

    # creates zmq sockets to read multiframe image from uvisensor
    uvisensor_config_port = uvispace_config["ZMQ_Sockets"]["uvisensor_config"]
    config_requester = zmq.Context.instance().socket(zmq.REQ)
    config_requester.connect("tcp://localhost:{}".format(uvisensor_config_port))

    # calculate image dimensions
    node_array_width = int(uvispace_config["LocNodes"]["node_array_width"])
    node_array_height = int(uvispace_config["LocNodes"]["node_array_height"])
    single_image_width = int(node_config.get("Camera", "width"))
    single_image_height = int(node_config.get("Camera", "height"))
    width = single_image_width * node_array_width
    height = single_image_height * node_array_height

    # set the image type in uvisensor
    uvisensor_config = {"img_type": img_type}
    print("Sending configuration to UviSensor...")
    config_requester.send_json(uvisensor_config)
    response = config_requester.recv_json() # waits until response
    print("Configuration finished. Starting streaming...")

    # show multiframe image from uvisensor and calculate frame rate
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
