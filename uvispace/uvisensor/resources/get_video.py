#!/usr/bin/env python
"""
Auxiliar module for streaming images from a Localization Node.

The localization node can be accessed through TCP/IP.
"""
import cv2
import numpy as np
import zmq


def main():
    receiver = zmq.Context.instance().socket(zmq.SUB)
    #bin
    #receiver.connect("tcp://172.19.5.213:33000")
    #gray
    receiver.connect("tcp://172.19.5.213:33001")
    receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
    receiver.setsockopt(zmq.CONFLATE, True)

    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    videowriter = cv2.VideoWriter('output.avi', fourcc, 6.0, (640, 480))

    for frame in range(10000):
        message = receiver.recv()
        image = np.fromstring(message, dtype=np.uint8).reshape((480, 640))
        cv2.imshow('stream', image)
        cv2.waitKey(1)
        videowriter.write(image)


if __name__ == '__main__':
    main()
