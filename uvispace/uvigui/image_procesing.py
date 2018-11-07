# image processing libraries
import numpy as np
import cv2
import zmq
import configparser
from  PyQt5.QtGui import QImage, QPixmap
import datetime
import sys

"""
    Images are treated as arrays in cv2. Therefore, they can be formated with the numpy library.
    Images are stacked using the given path:
    Image2         Image1
    
    Image3         Image4
    
    First, image1 and 2 are stack, then image 3 and 4.
    Finally, the 4 images are joined
"""


def loadips():
    """
        :param cameras_IPs: array where the cameras IP are stored
        Load the cameras IPs from the .cfg files
        Uses the configparser lib to read .cfg files
    """
    cameras_IPs = []
    for i in range(1, 5):
        ipscam = configparser.ConfigParser()
        rel_path = '../uvisensor/resources/config/video_sensor' + str(i) + '.cfg'
        ipscam.read(rel_path)
        print(ipscam.sections())

        cameras_IPs.append(ipscam.get('VideoSensor', 'IP'))

    print(cameras_IPs)
    return cameras_IPs


def load_image_size():
    """

    :param img_size: array where the iamge dimensions are stored
    :return:

    Load the image size from a .cfg file. Because all the cameras have the same size,
    only reads one config file
    """
    size = configparser.ConfigParser()
    rel_path = '../uvisensor/resources/config/video_sensor1.cfg'
    size.read(rel_path)
    img_size = [(size.getint('Camera', 'width')),
                (size.getint('Camera', 'height'))]
    return img_size



def image_stack(cameras_ips, img_size, img_type):
    """
    Loads the four images and stacks them. Also writes the stackes image
    :param widht:
    :param height:
    :param cameras_ips:
    :param img_size:
    :return:
    """
    # load the four images
    print(img_type)
    image1 = get_images(cameras_ips[0], img_type, img_size)
    image2 = get_images(cameras_ips[1], img_type, img_size)
    image3 = get_images(cameras_ips[2], img_type, img_size)
    image4 = get_images(cameras_ips[3], img_type, img_size)
    #image1 = cv2.cvtColor(cv2.imread('imagen1.jpg'), cv2.COLOR_RGB2GRAY)
    #image2 = cv2.cvtColor(cv2.imread('imagen2.jpg'), cv2.COLOR_RGB2GRAY)
    #image3 = cv2.cvtColor(cv2.imread('imagen3.jpg'), cv2.COLOR_RGB2GRAY)
    #image4 = cv2.cvtColor(cv2.imread('imagen4.jpg'), cv2.COLOR_RGB2GRAY)
    # Stack the matrix using concatenate
    output12 = np.concatenate((image2, image1), axis=1)  # apila las matrices 1 y 2
    output34 = np.concatenate((image3, image4), axis=1)  # apila las matrices 3 y 4
    output = np.concatenate((output12, output34), axis=0)  # resultante final
    #resized = cv2.resize(output, (widht, height), interpolation=cv2.INTER_AREA)
    cv2.imwrite('salida.jpg', output)  # saves the image as jpg
    # show the image
    #   cv2.imshow('Imagen', salida_red)
    #  cv2.waitKey(0)
    #  cv2.destroyAllWindows()


def get_images(cam_ip, img_type, img_size):
    """
    Get video streaming from the cameras. Access throug TCP/IP
    :param cam_ip: string with the IP
    :param img_type: string with the image type. It could be "BIN" or "GRAY"
    :param img_size: integer list with the height and the width of the image
    :return:
    """
    # Check the number of arguments passed to set resolution and img type

    receiver = zmq.Context.instance().socket(zmq.SUB)
    if img_type == "BIN":
        receiver.connect("tcp://" + cam_ip + ":33000")
    else:  # "GRAY" and "RGB"
        receiver.connect("tcp://" + cam_ip + ":34000")
    receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
    receiver.setsockopt(zmq.CONFLATE, True)

    message = receiver.recv()
    image = np.fromstring(message, dtype=np.uint8).reshape((img_size[1], img_size[0]))

    return image



