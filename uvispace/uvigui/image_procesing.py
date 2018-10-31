# image processing libraries
import numpy as np
import cv2
import zmq
import datetime
import sys

"""
    Images are treated as arrays in cv2. Therefore, they can be formated with the numpy library.
    Images are stacked using the given path:
    Image1         Image2
    
    Image3         Image4
    
    First, image1 and 2 are stack, then image 3 and 4.
    Finally, the 4 images are joined
"""



def image_stack():
    # load the four images
    imagen1 = get_images(1, "BIN")
    imagen2 = imagen1
    imagen3 = imagen1
    imagen4 = imagen1

    #imagen2 = cv2.cvtColor(cv2.imread('imagen2.jpg'), cv2.COLOR_RGB2GRAY)
    #imagen3 = cv2.cvtColor(cv2.imread('imagen3.jpg'), cv2.COLOR_RGB2GRAY)
    #imagen4 = cv2.cvtColor(cv2.imread('imagen4.jpg'), cv2.COLOR_RGB2GRAY)
    # Stack the matrix using concatenate
    salida12 = np.concatenate((imagen1, imagen2), axis=1)  # apila las matrices 1 y 2
    salida34 = np.concatenate((imagen3, imagen4), axis=1)  # apila las matrices 3 y 4
    salida = np.concatenate((salida12, salida34), axis=0)  # resultante final

    # resize the image to fit the label
    salida_red = cv2.resize(salida, (640, 468))  # adjust the image to the label size
    cv2.imwrite('salida.jpg', salida_red)  # guarda el array de imagenes como jpg

    # muestra la imagen
    #   cv2.imshow('Imagen', salida_red)
    #  cv2.waitKey(0)
    #  cv2.destroyAllWindows()


# image properties //TODO load from cfg file
# copied directly from get-video-triangle
IP_ADDRESS = "192.168.0.12"
IMG_WIDTH = 640;
IMG_HEIGHT = 468;
IMG_TYPE_DEFAULT = "GRAY"


def get_images(cam_num, img_type):
    # copied directly from get-video-triangle, need to search for errors.
    # Originally writen in Python 2...Now is Python 3.6, could be some errors
    # Check the number of arguments passed to set resolution and img type


    receiver = zmq.Context.instance().socket(zmq.SUB)
    if img_type == "BIN":
        receiver.connect("tcp://" + IP_ADDRESS + ":33000")
    else:  # "GRAY" and "RGB"
        receiver.connect("tcp://" + IP_ADDRESS + ":34000")
    receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
    receiver.setsockopt(zmq.CONFLATE, True)

    message = receiver.recv()  # TODO error here, the programm freezes
    image = np.fromstring(message, dtype=np.uint8).reshape((IMG_HEIGHT, IMG_WIDTH))

    return image

