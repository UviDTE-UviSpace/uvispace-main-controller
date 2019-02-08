# image processing libraries
import numpy as np
import cv2
import zmq
import configparser
from PyQt5.QtGui import QImage, QPixmap
from PIL import Image

"""
    Images are treated as arrays in cv2. Therefore, they can be formatted with 
    the numpy library.
    Images are stacked using the given path:
    Image2         Image1
    
    Image3         Image4
    
    First, image1 and 2 are stack, then image 3 and 4.
    Finally, the 4 images are joined
"""


def loadips():
    """
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
    :return:

    Load the image size from a .cfg file. Because all the cameras have the same
    size, only reads one config file
    """
    size = configparser.ConfigParser()
    rel_path = '../uvisensor/resources/config/video_sensor1.cfg'
    size.read(rel_path)
    img_size = [(size.getint('Camera', 'width')),
                (size.getint('Camera', 'height'))]
    return img_size


def image_stack(cameras_ips, img_size, img_type):
    """
    Loads the four images and stacks them. Also writes the stacked image

    :param cameras_ips:
    :param img_size:
    :param img_type:
    :return: numpy array with the four images stacked
    """
    # load the four images
    image_array = []
    for i in range(0, 4):
        image_array.append(get_images(cameras_ips[i], img_type, img_size))

    # Stack the array using concatenate, first stacks horizontally,
    # then, one on top of the other
    output12 = np.concatenate((image_array[2 - 1], image_array[1 - 1]), axis=1)
    output34 = np.concatenate((image_array[3 - 1], image_array[4 - 1]), axis=1)
    output = np.concatenate((output12, output34), axis=0)  # final image

    # cv2.imwrite('salida.jpg', output)  # saves the image as jpg

    return output


def get_images(cam_ip, img_type, img_size):
    """
    Get video streaming from the cameras. Access through TCP/IP
    :param cam_ip: string with the IP
    :param img_type: string with the image type. It could be "BIN", "GRAY" or "BLACK"
    :param img_size: integer list with the height and the width of the image
    :return: numpy array with the image
    """

    if img_type == "BLACK":
        # Create a black image
        image = np.zeros([img_size[1], img_size[0]], dtype=np.uint8)
    else:  # read images from cameras using pyzmq
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


def draw_grid(image):
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


def draw_ugv(image, coordinates):
    """
    Draw the ugv
    :param image: numpy image
    :param coordinates: array with the two coordinates
    :param delta: degrees of rotation of the agv
    :return: numpy image array
    """
    src_im = Image.open('icons/UGV_image.jpg')
    size = src_im.size

    dst_im = Image.fromarray(image)
    im = src_im.convert('RGBA')
    rot = im.rotate(coordinates[2], expand=1).resize(size)
    dst_im.paste(rot, (coordinates[0]-int(size[0]/2), coordinates[1]-int(size[1]/2)), rot)

    dst_im.convert('RGB')
    array_image = np.array(dst_im)
    # cv2.imwrite('save2.jpg', array_image)

    return array_image



