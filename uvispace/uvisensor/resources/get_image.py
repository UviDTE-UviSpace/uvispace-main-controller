#!/usr/bin/env python
"""
Auxiliar module for obtaining an image from a Localization Node.

The localization node can be accessed through TCP/IP.
"""
import numpy as np
from scipy import misc

import zmq


def main():
    receiver = zmq.Context.instance().socket(zmq.SUB)
    receiver.connect("tcp://172.19.5.213:33000")
    receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
    receiver.setsockopt(zmq.CONFLATE, True)

    message = receiver.recv()
    image = np.fromstring(message, dtype=np.uint8).reshape((480, 640))
    misc.imsave("image.png", image)

if __name__ == '__main__':
    main()
