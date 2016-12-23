#!/usr/bin/env python
#Standard libraries
import glob
#import logging
import copy
import numpy as np
import threading
import time
import os
#ROS libraries
from geometry_msgs.msg import Pose2D
import rospy
#Local libraries
import imgprocessing
import videosensor
"""
Main routine for controlling N external FPGAs with a camera device.

The main routine initializes N+2 threads:

* The first thread interacts with the user through terminal. It reads
input commands, namely for finishing the program.
* N threads contain the N FGPAs initialization processes and endless 
loops are continually requesting the UGVs' positions to the FPGA.
* A final thread is in charge of merging the information obtained from
each FPGA.

------------------------
NOTE: The proper way to end the program is to press 'Q', as the terminal
prompt indicates during execution. Using the Keyboard Interrupt will 
probably corrupt the TCP/IP socket and the FPGAs will have to be reset.
"""

class CameraThread(threading.Thread):
    """
    Create a thread and a VideoSensor object. Capture frames when run.
    """
    def __init__(self, triangles, begin_event, end_event, condition,
                 inborders, name=None, conf_file=''):
        threading.Thread.__init__(self, name=name)
        #Initialize TCP/IP connection and FPGA operation.
        self.camera = videosensor.camera_startup(conf_file)
        #Dictionary containing the contours of detected triangles.
        self.triangles = triangles
        self._triangles = [None]
        #Synchronization variables
        self.begin_event = begin_event
        self.end_event = end_event
        self.condition = condition
        self.image = []
        #Flags for indicating if the UGVs are in borders region.
        self.inborders = inborders
        self._inborders = copy.copy(inborders)

    def run(self):
        #Locate shapes in whole image and configure trackers.
        self.image, _ = videosensor.set_tracker(self.camera)
        self.begin_event.set()
        while not self.end_event.isSet():
            #Get CARTESIAN coordinates of the 8 points of shape in tracker.
            #The code ONLY tracks one UGV with id=1.
            try:
                locations = self.camera.get_register('ACTUAL_LOCATION')['1']
            except KeyError:
                self._triangles = [None]
                continue
            self.condition.acquire()
            self._inborders = copy.copy(self.inborders)
            self.condition.notify()
            self.condition.release()
            #Scale the contours obtained according to the FPGA to image ratio.
            contours = np.array(locations) / self.camera._scale
            #Convert from Cartesian to Image coordinates
            tmp = np.copy(contours[:,0])
            contours[:,0] = contours[:,1]
            contours[:,1] = tmp
            self.image.contours = [contours]
            #Correct barrel distortion.
            self.image.correct_distortion()
            #Obtain 3 vertices from the contours
            self._triangles = self.image.get_shapes(get_contours=False)
            #If no triangles are detected, avoid coordinates calculation.
            if len(self._triangles):
                #Evaluate if all triangle vertices are inside image borders.
                vertices = self._triangles[0].vertices.astype(np.int)
                if all(self.image.borders[row, col] for row, col in vertices):
                    self._inborders['1'] = True
                else:
                    self._inborders['1'] = False
                #Obtain global cartesian coordinates with a scale ratio 4:1.
                self._triangles[0].get_local2global(self.camera.offsets, K=4)
                self._triangles[0].homography(self.camera._H)
            #Block the lock object until the pose is written to dictionary.
            self.condition.acquire()
            if len(self._triangles):
                self.triangles['1'] = self._triangles[0]
                self.inborders = copy.copy(self._inborders)
            self.condition.notify()
            self.condition.release()
        rospy.logdebug('shutting down {}'.format(self.name))
#        logging.debug('shutting down {}'.format(self.name))
        videosensor.camera_shutdown(self.camera)


class DataFusionThread(threading.Thread):
    """
    Thread for assessing obtained shapes and merging the information.
    
    Merge the shapes obtained by each CameraThread and stored in a 
    global variable.
    """
    def __init__(self, triangles, conditions, inborders, end_event, 
                 publisher, name='Fusion Thread'):
        """
        Thread class constructor

        Parameters
        ----------
        triangles : N-len list
            List containing N dictionaries inside, where N is the number
            of Camera threads. Each dictionary entry are an UGV 
            contours' coordinates inside the Nth camera

        conditions : N-len list
            list containing N threading.Condition objects. This objects
            are used for synchronization between the each CameraThread 
            and the DataFusionThread when doing R/W operations on shared
            variables.

        inborders : N-len list
            list containing N dictionaries. Each dictionary entry 
            is a flag raised to True when the UGV is in the Nth borders
            region.

        end_event : threading.Event
            Event object that is set to True when the UserThread detects
            an 'end program' order from the user.

        publisher : rospy.Publisher
            object for publishing pose values to a ROS topic that will 
            be read by other ROS nodes.

        name : string
            name of the thread.
        """
        threading.Thread.__init__(self, name=name)
        self.conditions = conditions
        self.end_event = end_event
        self.publisher = publisher
        self.cycletime = 0.02
        #Shared lists. Can be written by other threads.
        self.triangles = triangles
        self.inborders = inborders
        #Local lists. Can only be R/W by this thread.
        self._triangles = copy.copy(self.triangles) 
        self._inborders = copy.copy(self.inborders)

    def run(self):
        while not self.end_event.isSet():
            #Start the cycle timer
            cycle_start_time = time.time()
            for index, condition in enumerate(self.conditions):
                #Threads synchronized instructions.
                condition.acquire()
                #Read shared variables and store in local lists
                self._triangles[index] = copy.copy(self.triangles[index])
                self._inborders[index] = copy.copy(self.inborders[index])
                #Read the global triangles coordinates at every camera thread.
                if self.triangles[index]:
                    triangle = self.triangles[index]['1']
                condition.release()
            ###Pending: merge the containt of every dictionary in triangle
            if self.triangles[index]:
                pose = triangle.get_pose()
                rospy.logdebug("detected triangle at {}mm and {} radians."
                              "".format(pose[0:2], pose[2]))
    #            logging.debug("detected triangle at {}mm and {} radians."
    #                          "".format(pose[0:2], pose[2]))
                self.publisher.publish(Pose2D(pose[0]/1000, pose[1]/1000,
                                              pose[2]))
            rospy.loginfo("{}".format(self.triangles))
            rospy.loginfo("{}".format(self.inborders))
            #Sleep the rest of the cycle
            while (time.time() - cycle_start_time < self.cycletime):
                pass


class UserThread(threading.Thread):
    """
    Thread for assessing obtained shapes and merging the information.
    
    Merge the shapes obtained by each CameraThread and stored in a 
    global variable.
    """
    def __init__(self, begin_events, end_event, 
                       name='User Thread', conf_file=''):
        """Inherit from threading.Thread and read event objects.
        
        begin_events is a list with N Event objects, where N is the 
        number of Camera threads started. Until the set up of every 
        camera is finished, the user can not interact with this thread.
        
        end_event indicates the end of the program.
        """
        threading.Thread.__init__(self, name=name)
        self.begin_events = begin_events
        self.end_event = end_event

    def run(self):
        #Wait until all camera threads start.
        for event in self.begin_events:
            event.wait()
        rospy.loginfo("All cameras were initialized")
#        logging.info("All cameras were initialized")
        while not self.end_event.isSet():
            i = raw_input("Press 'Q' to stop the script... ")
            if i == 'Q':
                self.end_event.set()


###Main routine.###
#Create logger, read configuration files, prepare variables and create threads.
if __name__ == '__main__':
    rospy.init_node('uvisensor')
    publisher = rospy.Publisher('/robot_1/pose2d', Pose2D, queue_size=1)
#    logging.basicConfig(format=('%(asctime)s.%(msecs)03d '
#                               '%(levelname)s (%(threadName)-9s):'
#                               '%(message)s'), 
#                        level=logging.DEBUG,
#                        datefmt='%H:%M:%S',
#                        filename='./log/main.log')
#    log = logging.getLogger(__name__)
    rospy.loginfo("BEGINNING MAIN EXECUTION")
#    logging.info("BEGINNING MAIN EXECUTION")
    #Get the relative path to all the config files stored in /config folder.
    conf_files = glob.glob("./resources/config/*.cfg")
    conf_files.sort()
    threads = []
    #A condition for each camera thread execution.
    conditions = []
    #Shared variable for storing coordinates of found triangles.
    #There is a dictionary in the list for each camera.
    triangles = [{}, {}, {}, {}]
    #Shared variable for storing the presence of UGVs in borders regions.
    inborders = [{'1':False}, {'1':False}, {'1':False}, {'1':False}]
    #A begin event for each camera will be created
    begin_events = []
    end_event = threading.Event()
    #New thread instantiation for each configuration file.
    for index, fname in enumerate(conf_files):
        conditions.append(threading.Condition())
        begin_events.append(threading.Event())
        threads.append(CameraThread(triangles[index], begin_events[index], 
                                    end_event, conditions[index], 
                                    inborders[index],
                                    'Camera{}'.format(index), fname))
    #Thread for getting user input.
    threads.append(UserThread(begin_events, end_event))
    #Thread for merging the data obtained at every CameraThread.
    threads.append(DataFusionThread(triangles, conditions, inborders,
                                    end_event, publisher))
    # start threads
    for thread in threads:
        thread.start()
    # wait for threads to end
    for thread in threads:
        thread.join()






