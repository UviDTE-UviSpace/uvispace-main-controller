#!/usr/bin/env python
"""
Auxiliar module for streaming images from a Localization Node.

The localization node can be accessed through TCP/IP.
"""
import cv2
import numpy as np
import zmq
import datetime
import sys

IP_DEFAULT = "172.19.5.214"
IMG_WIDTH_DEFAULT = 640;
IMG_HEIGHT_DEFAULT = 468;
IMG_TYPE_DEFAULT = "GRAY";

def main():
    #Check the number of arguments passed to set resolution and img type
    if len(sys.argv)==1:
        IP_ADDRESS = IP_DEFAULT
        IMG_WIDTH = IMG_WIDTH_DEFAULT
        IMG_HEIGHT = IMG_HEIGHT_DEFAULT
        IMG_TYPE = IMG_TYPE_DEFAULT
    elif len(sys.argv)==3:
        IP_ADDRESS = IP_DEFAULT
        IMG_WIDTH = int(sys.argv[1])
        IMG_HEIGHT = int(sys.argv[2])
        IMG_TYPE = IMG_TYPE_DEFAULT
    elif len(sys.argv)==4:
        IP_ADDRESS = IP_DEFAULT
        IMG_WIDTH = int(sys.argv[1])
        IMG_HEIGHT = int(sys.argv[2])
        if sys.argv[3] == "BIN":
            IMG_TYPE = "BIN"
        else:
            IMG_TYPE = "GRAY"
    elif len(sys.argv)==5:
        IP_ADDRESS = sys.argv[1]
        IMG_WIDTH = int(sys.argv[2])
        IMG_HEIGHT = int(sys.argv[3])
        if sys.argv[4] == "BIN":
            IMG_TYPE = "BIN"
        else:
            IMG_TYPE = "GRAY"
    else:
        print 'This program gets video from triangle_detector_server running in camera node'
        print 'Default call gets 640x468 GRAY image from 172.19.5.214 server: '
        print '  python get_video_triangle_server.py'
        print 'Example getting custom resolution GRAY image from 172.19.5.214'
        print '  python get_video_triangle_server.py 1280 936'
        print 'Example getting custom resolution custom type image from 172.19.5.214:'
        print '  python get_video_triangle_server.py 1280 936 BIN'
        print 'Example also changing the IP address of the server'
        print '  python get_video_triangle_server.py 172.19.5.213 1280 936 BIN'
        return


    receiver = zmq.Context.instance().socket(zmq.SUB)
    if IMG_TYPE == "BIN":
        receiver.connect("tcp://"+IP_ADDRESS+":33000")
    else: #"GRAY"
        receiver.connect("tcp://"+IP_ADDRESS+":34000")
    receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
    receiver.setsockopt(zmq.CONFLATE, True)

    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    videowriter = cv2.VideoWriter('output.avi', fourcc, 6.0, (IMG_WIDTH, IMG_HEIGHT))

    t1 = datetime.datetime.now()
    for frame in range(1000):
        t1 = datetime.datetime.now()
        message = receiver.recv()
        image = np.fromstring(message, dtype=np.uint8).reshape((IMG_HEIGHT, IMG_WIDTH))
        cv2.imshow('stream', image)
        cv2.waitKey(1)
        #update frame rate and print
        t2 = datetime.datetime.now()
        loop_time = (t2 - t1).microseconds
        t1 = t2
        last_fps = 1000000 / loop_time
        print(last_fps)

if __name__ == '__main__':
    main()
