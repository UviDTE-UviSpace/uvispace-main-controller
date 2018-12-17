#!/usr/bin/env python
"""
Auxiliar module for obtaining an image from a Localization Node.

The localization node can be accessed through TCP/IP.
"""
import numpy as np
from scipy import misc
import zmq

IMG_WIDTH = 640;
IMG_HEIGHT = 468;

def main():
    receiver = zmq.Context.instance().socket(zmq.SUB)
    #bin
    #receiver.connect("tcp://172.19.5.214:33000")
    #gray
    #receiver.connect("tcp://172.19.5.214:34000")
    #rgb
    receiver.connect("tcp://172.19.5.214:34000")

    receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
    receiver.setsockopt(zmq.CONFLATE, True)

    message = receiver.recv()
    #gray bin
    #image = np.fromstring(message, dtype=np.uint8).reshape((IMG_HEIGHT, IMG_WIDTH))
    #rgb
    shape = (IMG_HEIGHT, IMG_WIDTH, 4)
    raw_array = np.fromstring(message, dtype=np.uint8).reshape(shape)
    image = np.zeros((IMG_HEIGHT, IMG_WIDTH, 3), dtype=np.uint8)
    image[:,:,0] = raw_array[:,:,0]
    image[:,:,1] = raw_array[:,:,1]
    image[:,:,2] = raw_array[:,:,2]

    misc.imsave("image.png", image)

if __name__ == '__main__':
    main()
