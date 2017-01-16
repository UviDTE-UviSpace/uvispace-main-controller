#!/usr/bin/env python
#Standard libraries
import glob
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
Multithreading routine for controlling N external FPGAs with cameras.

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

    Parameters
    ----------
    triangles : dictionary
        Each element of the dictionary is a geometry.Triangle() object.
        It is a global variable for sharing the information of the 
        different triangles detected in the camera space. Each triangle
        has a UNIQUE key identifier.

    begin_event : threading.Event() object
        Synchronization variable that is set to True when the current 
        thread begins the main loop.

    end_event : threading.Event() object
        Synchronization variable that is set to True when the whole 
        system shall stop the execution of the main loop.

    condition : threading.Condition() object
        Synchronization variable for R/W operations on the shared 
        variables i.e. triangles and inborders.

    inborders : dictionary
        Each element indicates if the corresponding triangle is located
        in the borders region of current camera space. The UNIQUE key 
        identifiers have a univocal correspondence with the key 
        identifiers of triangles dictionary.

    name : string
        Name of the current camera thread.

    conf_file : string
        Relative path to the configuration file of the current camera.
    """
    def __init__(self, triangles, begin_event, end_event, condition,
                 inborders, reset_flag, name=None, conf_file=''):
        threading.Thread.__init__(self, name=name)
        self.image = []
        self.cycletime = 0.02
        #Initialize TCP/IP connection and start FPGA operation.
        self.camera = videosensor.camera_startup(conf_file)
        #Synchronization variables
        self.begin_event = begin_event
        self.end_event = end_event
        self.condition = condition
        #Global and local dictionary containing the detected triangles.
        self.triangles = triangles
        self._triangles = copy.copy(self.triangles)
        #Global and local flags indicating if the UGVs are in borders region.
        self.inborders = inborders
        self._inborders = copy.copy(self.inborders)
        #Global flag indicating if ROI tracker has to be reset.
        self.reset_flag = reset_flag
        self._reset_flag = copy.copy(self.reset_flag)

    def run(self):
        """Main routine of the CameraThread."""
        #Look for shapes in whole image and configure trackers.
        self.image, _ = videosensor.set_tracker(self.camera)
        self.begin_event.set()
        while not self.end_event.isSet():
            #Start the cycle timer
            cycle_start_time = time.time()
            #Sync operations. Read global variables and update local ones.
            self.condition.acquire()
            self._inborders.update(self.inborders)
            self._triangles.update(self.triangles)
            self._reset_flag.update(self.reset_flag)
            self.condition.release()
            #
            #Get CARTESIAN coordinates of the 8 contour points in tracker.
            #The code ONLY tracks the UGV with id=1.
            #
            try:
                locations = self.camera.get_register('ACTUAL_LOCATION')['1']
            except KeyError:
                #
                #Set a new tracker if the inborders flag is raised and
                #The corresponding tracker is empty (if KeyError).
                #
                if self._inborders['1']:
                    #Apply inverse homography and transform global to local.
                    self._triangles['1'].inverse_homography(self.camera._H)
                    self._triangles['1'].global2local(self.camera.offsets, K=4)
                    #get window and set tracker
                    self.image.triangles = [self._triangles['1']]
                    videosensor.set_tracker(self.camera, self.image)
                continue
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
            shapes = self.image.get_shapes(get_contours=False)
            #If triangles are detected, calculate coordinates.
            if len(shapes):
                self._triangles['1'] = shapes[0]
                #Obtain global cartesian coordinates with a scale ratio 4:1.
                self._triangles['1'].local2global(self.camera.offsets, K=4)
                self._triangles['1'].homography(self.camera._H)
            #If any triangle is detected, indicate it writing a None variable.
            else :
                self._triangles['1'] = None
            #Free the ROI tracker if corresponding flag was raised
            if self._reset_flag['1']:
                self.camera.set_register('FREE_TRACKER', '1')
                rospy.loginfo('{} TRACKER FREED'.format(self.name))
                self._reset_flag = {'1':False}
                self._triangles.pop('1', None)
            #Sync operations. Write to global variables.
            self.condition.acquire()
            self.reset_flag.update(self._reset_flag)
            self.triangles.update(self._triangles)
            self.condition.release()
            #Sleep the rest of the cycle
            while (time.time() - cycle_start_time < self.cycletime):
                pass
        rospy.logdebug('shutting down {}'.format(self.name))
        self.camera.disconnect_client()


class DataFusionThread(threading.Thread):
    """
    Thread for assessing obtained shapes and merging the information.
    
    Merge the shapes obtained by each CameraThread and stored in a 
    global variable.
    """
    def __init__(self, triangles, conditions, inborders, quadrant_limits,
                 begin_events, end_event, reset_flags, publisher,
                 name='Fusion Thread'):
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

        quadrant_limits : N-len list
            list containing N 4-len arrays. Each one of the sublists 
            contain the 4 points defining the working space of the 
            camera N.

        end_event : threading.Event
            Event object that is set to True when the UserThread detects
            an 'end program' order from the user.

        publisher : rospy.Publisher
            object for publishing pose values to a ROS topic that will 
            be read by other ROS nodes.

        reset_flags : N-len list
            list containing N dictionaries. Each dictionary entry is a 
            flag raised to True when a ROI tracker in specified FPGA 
            has to be reset.

        name : string
            name of the thread.
        """
        threading.Thread.__init__(self, name=name)
        self.publisher = publisher
        self.cycletime = 0.02
        self.quadrant_limits = quadrant_limits
        #Synchronization variables
        self.conditions = conditions
        self.begin_events = begin_events
        self.end_event = end_event
        #Shared lists. Can be accessed by other threads.
        self.triangles = triangles
        self.inborders = inborders
        self.reset_flags = reset_flags
        #Local lists. Can only be R/W by this thread.
        self._triangles = copy.copy(self.triangles) 
        self._inborders = copy.copy(self.inborders)
        self._reset_flags = copy.copy(self.reset_flags)

    def run(self):
        """Main routine of the DataFusionThread."""
        #Wait until all cameras are initialized
        for event in self.begin_events:
            event.wait()
        triangle = []
        while not self.end_event.isSet():
            #Start the cycle timer
            cycle_start_time = time.time()
            #Loop with N iterations, being N the number of camera threads.
            for index, condition in enumerate(self.conditions):
                #Threads synchronized instructions.
                condition.acquire()
                #Read shared variables and store in local ones
                self._triangles[index].update(self.triangles[index])
                self._reset_flags[index].update(self.reset_flags[index])
                condition.release()
                #
                #Evaluate if the triangle is in the borders regions.
                #
                if self._triangles[index]:
                    #Check that the element is not of None type.
                    if self._triangles[index]['1']:
                        triangle = self._triangles[index]['1']
                        #Evaluate if triangle is in borders region.
                        self._inborders[index]['1'] = triangle.in_borders(
                                                    self.quadrant_limits[index])
                    #If dictionary element is None, skip to next camera.
                    else:
                        continue
                #If the element is void, skip to next camera.
                else:
                    continue
                #
                #The following instructions will only be executed if a triangle
                #is detected in the scanned CameraThread (with id 'index').
                #
                #Check in the other quadrants if the triangle is in borders.
                #
                for index2, quadrant in enumerate(self.quadrant_limits):
                    #Do not run the function for the current quadrant.
                    if index2 == index:
                        continue
                    self._inborders[index2]['1'] = triangle.in_borders(
                                        self.quadrant_limits[index2])
                    #Update triangles[index2] if there is not any tracker
                    #initialized and UGV is within borders of the Camera.
                    if (self._inborders[index2]['1'] and not 
                                            self._triangles[index2]):
                        self._triangles[index2]['1'] = copy.copy(triangle)
                        self._reset_flag[index2]['1'] = False
                        rospy.loginfo("New triangle in Camera{}".format(
                                                index2+1))
                    #If the UGV is not in borders, but a tracker is set and is
                    #returning None values, it has to be reset.
                    elif (not self._inborders[index2]['1'] and
                                            self._triangles[index2]):
                        self._reset_flags[index2]['1'] = True
                        rospy.loginfo("Set reset_flag for Camera{}".format(
                                                index2+1))
                    #Sync operations. Write to global variables
                    self.conditions[index2].acquire()
                    self.triangles[index2].update(self._triangles[index2])
                    self.inborders[index2].update(self._inborders[index2])
                    self.reset_flags[index2].update(self._reset_flags[index2])
                    self.conditions[index2].release()
            ###Pending: merge the containt of every dictionary in triangle
            #
            #Scan for detected triangle and publish it.
            #
            for element in self._triangles:
                if element.has_key('1'):
                    if element['1'] is not None:
                        triangle = copy.copy(element['1'])
            if triangle:
                pose = triangle.get_pose()
                #Convert coordinates to meters.
                mpose = [pose[0]/1000, pose[1]/1000, pose[2]]
                rospy.logdebug("detected triangle at {}mm and {} radians."
                              "".format(pose[0:2], pose[2]))
                self.publisher.publish(Pose2D(mpose[0], mpose[1], mpose[2]))
#            rospy.loginfo("Triangles at: {}".format(self._triangles))
#            rospy.loginfo("Borders: {}".format(self._inborders))
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
        self.cycletime = 0.5

    def run(self):
        """Main routine of the UserThread."""
        #Wait until all camera threads start.
        for event in self.begin_events:
            event.wait()
        rospy.loginfo("All cameras were initialized")
        while not self.end_event.isSet():
            #Start the cycle timer
            cycle_start_time = time.time()
            i = raw_input("Press 'Q' to stop the script... ")
            if i == 'Q':
                self.end_event.set()
            #Sleep the rest of the cycle
            while (time.time() - cycle_start_time < self.cycletime):
                pass

###Main routine.###
#Read configuration files, initialize variables and set up threads.
if __name__ == '__main__':
    rospy.init_node('uvisensor')
    publisher = rospy.Publisher('/robot_1/pose2d', Pose2D, queue_size=1)
    rospy.loginfo("BEGINNING MAIN EXECUTION")
    #Get the relative path to all the config files stored in /config folder.
    conf_files = glob.glob("./resources/config/*.cfg")
    conf_files.sort()
    threads = []
    #A Condition object for each camera thread execution.
    conditions = []
    #Shared variable for storing coordinates of found triangles.
    #There is a dictionary in the list for each camera.
    triangles = [{}, {}, {}, {}]
    #Shared variable for storing the presence of UGVs in borders regions.
    inborders = [{'1':False}, {'1':False}, {'1':False}, {'1':False}]
    #Shared variable flags indicating ROI trackers reset orders.
    reset_flags = [{'1':False}, {'1':False}, {'1':False}, {'1':False}]
    #A begin event for each camera will be created
    begin_events = []
    end_event = threading.Event()
    #New thread instantiation for each configuration file.
    for index, fname in enumerate(conf_files):
        conditions.append(threading.Condition())
        begin_events.append(threading.Event())
        threads.append(CameraThread(triangles[index], begin_events[index], 
                                    end_event, conditions[index], 
                                    inborders[index], reset_flags[index],
                                    'Camera{}'.format(index), fname))
    #List containing the points defining the space limits of each camera.
    quadrant_limits = []
    for camera_thread in threads:
        quadrant_limits.append(camera_thread.camera._limits)
    #Thread for getting user input.
    threads.append(UserThread(begin_events, end_event))
    #Thread for merging the data obtained at every CameraThread.
    threads.append(DataFusionThread(triangles, conditions, inborders,
                                    quadrant_limits, begin_events, end_event, 
                                    reset_flags, publisher))
    # start threads
    for thread in threads:
        thread.start()
    # wait for threads to end
    for thread in threads:
        thread.join()






