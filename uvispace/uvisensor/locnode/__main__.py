import cv2
import time
import sys

from uvispace.uvisensor.locnode.locnode import LocalizationNode
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
    if len(sys.argv) == 3:
        num = int(sys.argv[1])
        if sys.argv[2] == "RGB":
            img_type = ImgType.RGB
        elif sys.argv[2] == "BIN":
            img_type = ImgType.BIN
        elif sys.argv[2] == "GRAY":
            img_type = ImgType.GRAY
        elif sys.argv[2] == "BLACK":
            img_type = ImgType.BLACK
        else:
            img_type = ImgType.RAND
    elif len(sys.argv) == 2:
        num  = int(sys.argv[1])
        img_type = ImgType.GRAY
    else:
        num  = 1
        img_type = ImgType.GRAY

    node = LocalizationNode(num - 1, triang_enabled = False)
    node.set_img_type(img_type)

    t1 = time.time()
    frame_rate_counter = 0
    frame_rate_counter_limit = 100
    while(True):
        r = False
        while not r:
            r, image = node.get_image()
            if not r:
                print("No image from node!")
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
