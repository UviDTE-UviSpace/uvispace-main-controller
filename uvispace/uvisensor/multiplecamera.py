#!/usr/bin/env python
#Standard libraries
import logging
import numpy as np
import threading
#Local libraries
import imgprocessing
import videosensor
"""
Main routine for controlling an external FPGA with a camera device.

The main routine initializes 2 thread:

* The first thread interacts with the user through terminal. It reads
input commands, namely for finishing the program.
* The second thread contains the FGPA initialization process and an
infinite loop is continually requesting the UGV position to the FPGA.

------------------------
NOTE: The proper way to end the program is to press 'Q', as the terminal
prompt indicates during execution. Using the Keyboard Interrupt will 
probably corrupt the TCP/IP socket and the FPGA will have to be reset.
"""
def input_task(begin_event, end_event):
    """Ask user for 'Quit' command and wait until answer is obtained."""
    begin_event.wait()
    while not end_event.isSet():
        i = raw_input("Press 'Q' to stop the script...")
        if i == 'Q':
            end_event.set()
            print 'end_event set to {}'.format(end_event.isSet())

def cam_task(begin_loop, end_loop, conf_file):
    """Initialize and request UGV position until program exit."""
    camera = videosensor.camera_startup(conf_file)
    try:
        #Check that camera is a valid type
        location = videosensor.set_tracker(camera)
    except AttributeError:
        end_loop.set()
        return
    finally:
        begin_loop.set()
    while not end_loop.isSet():
        #Get the 8 points of the robot 1 and convert them to an array
        try:
            location = camera.get_register('ACTUAL_LOCATION')['1']
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
    logging.debug('shutting down videosensor {}'.format(conf_file))
    videosensor.camera_shutdown(camera)


if __name__ == '__main__':
    logging.basicConfig(format=('%(asctime)s.%(msecs)03d '
                               '%(levelname)s %(threadName)-9s:%(message)s'), 
                        level=logging.DEBUG,
                        datefmt='%H:%M:%S',
                        filename='./log/main.log')
    log = logging.getLogger(__name__)
    logging.info("BEGINNING MAIN EXECUTION")
    #
    conf_files = []
    for i in range(1,5):
        conf_files.append('./resources/config/video_sensor{}.cfg'.format(i))
    begin_event = threading.Event()
    end_event = threading.Event()
    threads = [threading.Thread(target=input_task,
                                args=(begin_event, end_event))]
    for fname in conf_files:
        threads.append(threading.Thread(target=cam_task, 
                                        args=(begin_event, end_event, fname)))
    # start threads
    for thread in threads:
        thread.start()
    # wait for threads to end
    for thread in threads:
        thread.join()






