import cv2
import time
import sys

from uvispace.uvisensor.camera.camera import Camera

if __name__ == '__main__':

    if len(sys.argv) == 1:
        cam_num = 1
        img_type = "RAND"
    else:
        cam_num = int(sys.argv[1])
        img_type = sys.argv[2]


    cam = Camera(cam_num, threaded = False, triang_enabled = False)
    cam.set_img_type(img_type)

    t1 = time.time()
    frame_rate_counter = 0
    frame_rate_counter_limit = 100
    while(True):
        image = cam.get_image()
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
