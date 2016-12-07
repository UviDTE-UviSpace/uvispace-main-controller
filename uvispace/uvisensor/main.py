#!/usr/bin/env python
#Standard libraries
import logging
import numpy as np
import signal
import sys
import time
from threading import Thread
#Local libraries
import imgprocessing
import videosensor
"""
Main routine for controlling the external FPGAs.
"""
def camera_startup(filename):
    """Bring up connection with camera and set up its configuration.
    
    Get an instance of the VideoSensor class and return it after doing
    initialization process.
    """
    #Instantiate VideoSensor class. The filename contains the configuration
    cam = videosensor.VideoSensor(filename)
    if not cam._connected:
        sys.exit('Unable to connect')
    cam.load_configuration()
    #DON'T KNOW WHY FOLLOWING 2 STATEMENTS ARE USED
    #Reset trackers?
    cam.set_register('FREE_ALL', '')
    #Select output = 4?
    cam.set_register('SYSTEM_OUTPUT', 4)
    conf = cam._client.write_command('CONFIGURE_CAMERA', True)
    return cam
    
def camera_shutdown(cam):
    """bring down connection with camera.
    
    disconnect function. If it is not called, the socket won't be able 
    to be reopened.
    """
    cam.set_register('SYSTEM_OUTPUT', 0)
    cam.disconnect_client()

def get_image(cam):
    """Get an image from input camera.
    
    it can be saved to a local file (optional).
    """
    screenshot = cam.capture_frame(gray=True, output_file='')
    image = imgprocessing.Image(screenshot)
    image.binarize(cam._params['red_thresholds'])
    image.get_shapes()
    return image
    
def set_tracker(camera, K=2):
    """Configure trackers according to detected triangles.
    
    Parameters
    ----------
    K : int
        scale coeficient of the cameras.
        
    Returns
    -------
    tracker : N-elements dictionary
        Contains the 8-coordinate points from N triangles. They 
        correspond with 2.
    """
    #Get an Image object with triangle shapes in it already segregated.
    image = get_image(camera)
    tracker = {}
    for triangle in image.triangles:
        triangle.get_pose()
        triangle.get_window()
        min_x = K * int(triangle.window[0,1])
        min_y = K * int(triangle.window[0,0])
        width = K * int(triangle.window[1,1]) - min_x
        height = K * int(triangle.window[1,0]) - min_y
        tracker = camera.configure_tracker(1, min_x, min_y, width, height)
    return tracker

def safe_quit():
    global interupted
    a = None
    # To use specific exit keyword, change to `while a != "example"`     
    while a != 'Q':
        a = raw_input("Press 'Q' for exit\n")
    print 'interrupting'
    interupted = True
        
def signal_handler(signal, frame):
    """Raises a flag when a keyboard interrupt is raised."""
    global interrupted
    interrupted = True

if __name__ == '__main__':
    logging.basicConfig(format=('%(asctime)s.%(msecs)03d '
                               '%(levelname)s:%(message)s'), 
                        level=logging.DEBUG,
                        datefmt='%H:%M:%S',
                        filename='./log/main.log')
    log = logging.getLogger(__name__)
    out_hdlr = logging.StreamHandler(sys.stdout)
    out_hdlr.setFormatter(logging.Formatter('%(asctime)s %(message)s'))
    out_hdlr.setLevel(logging.INFO)
    log.addHandler(out_hdlr)
    log.setLevel(logging.INFO)
    logging.info("BEGINNING MAIN EXECUTION")
    camera1 = camera_startup('./resources/config/video_sensor4.cfg')
    location = set_tracker(camera1)
    interrupted = False
    Thread(target=safe_quit).start()
    signal.signal(signal.SIGINT, signal_handler)
    while not interrupted:
        time.sleep(1)
        print 'trying. Interrupted is {}'.format(interrupted)
        #Get the 8 points of the robot 1 and convert them to an array
        try:
            location = camera1.get_register('ACTUAL_LOCATION')['1']
        except KeyError:
            continue
        location_array = [np.array(location)]
        image = imgprocessing.Image(contours=location_array)
        #Obtain 3 vertices from the contours
        image.get_shapes(get_contours=False)
        #If no triangles are detected, avoid next instructions.
        if len(image.triangles):
            image.triangles[0].get_pose()
            logging.debug("detected triangle with vertices at {}"
                          "".format(image.triangles[0].vertices))
    camera_shutdown(camera1)



