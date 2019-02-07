#!/usr/bin/env python
"""Multithreading routine for controlling external FPGAs with cameras.

Options
-------

- -s / --save2file: The data collected by the cameras will be stored in
a spreadsheet and in a text file.

------------------------------------------------------------------------

The module creates several parallel threads, in order to optimize the
execution time, as it contains several instructions which require
waiting for external resources before continuing execution e.g. waiting
for the TCP/IP client to deliver FPGA registers information. Namely, 6
different threads are managed and indexed in a list called *threads*:

* 4 threads that run the 4 FGPAs initialization routines. Afterwards,
  endless loops continually request the UGVs' positions to each FPGA.
* Another thread that interacts with the user through keyboard. It reads
  input commands and performs corresponding actions.
* A final thread is in charge of merging the information obtained at
  each FPGA thread and obtain global UGVs' positions.

NOTE: The proper way to end the program is to press 'Q', as the terminal
prompt indicates during execution. If the Keyboard Interrupt is used
instead, it will probably corrupt the TCP/IP socket and the FPGAs will
have to be reset.
"""
# Standard libraries
import copy
import getopt
import glob
import logging
import os
import sys
import threading
import time
# Third party libraries
import numpy as np
import zmq
# Local libraries
from resources import dataprocessing
import kalmanfilter
import videosensor

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger('sensor')


class CameraThread(threading.Thread):
    """Child class of threading.Thread for capturing frames from a camera.

    The *run* method, where is specified the behavior when the *start*
    method is called, is overridden. At first, it loads the FPGA
    configuration. Then it enters an endless loop until *end_event*
    flag is raised. At each iteration, when possible, reads the FPGA
    register containing triangles location, processes the data and
    writes it to the global shared variable *triangles*.

    :param triangles: Dictionary where each element is an instance
     of *geometry.Triangle*. It is a global variable for sharing the
     information of different triangles detected in the camera space.
     Each triangle has a UNIQUE key identifier. It is used for
     writing and sending to other threads the triangle elements.

    :param camera_started: *threading.Event* object that is set to True
     when the FPGA is configured and the thread begins the main loop.

    :param end_execution: *threading.Event* object that is set to True
     when the execution has to end.

    :param camera_lock: *threading.Condition* object for synchronizing
     R/W operations on shared variables i.e. *triangles, inborders*.

    :param name: String that provides the name of the thread.

    :param conf_file: String containing the relative path to the
     configuration file of the camera.
    """

    def __init__(self, triangles, camera_started, end_execution,
                 camera_lock, name=None, conf_file=''):
        """Class constructor method."""
        threading.Thread.__init__(self, name=name)
        self.image = []
        self.cycletime = 0.02
        # Initialize TCP/IP connection and start FPGA operation.
        self.camera = videosensor.VideoSensor(conf_file)
        # Synchronization variables
        self.__camera_started = camera_started
        self.__end_execution = end_execution
        self.__camera_lock = camera_lock
        # Global and local dictionaries for writing the detected triangles.
        self.__triangles_shared = triangles
        self.__triangles = copy.copy(self.__triangles_shared)

    def run(self):
        """Main routine of the CameraThread."""
        self.__camera_started.set()
        while not self.__end_execution.isSet():
            # Start the cycle timer
            cycle_start_time = time.time()
            # Get triangles from camera
            # The code ONLY tracks the UGV with id=1
            triangles = self.camera.find_triangles()
            if len(triangles):
                self.__triangles["1"] = triangles[0]
                self.__triangles["1"].local2global(self.camera.offsets, K=4)
                self.__triangles["1"].homography(self.camera.h)
            else:
                self.__triangles["1"] = None
            # Sync operations. Write to global variables.
            self.__camera_lock.acquire()
            if "1" in self.__triangles:
                self.__triangles_shared.update(self.__triangles)
            else:
                self.__triangles_shared.clear()
            self.__camera_lock.release()
            # Sleep the rest of the cycle
            while (time.time() - cycle_start_time) < self.cycletime:
                pass

        self.camera.shutdown()
        logger.debug("Shutting down {}".format(self.name))


class DataFusionThread(threading.Thread):
    """Child class of threading.Thread for merging and processing data.

    The *run* method, where is specified the behavior when the *start*
    method is called, is overridden. At first, it waits until all cameras
    are initialized. Then it enters an endless loop until the
    *end_event* flag is raised. At each iteration:

    - Check the triangles found by each *CameraThread*.
    - Merge the information obtained in all the cameras.

    :param triangles: READ ONLY List containing N dictionaries, where
     N is the number of Camera threads. Each dictionary element is the
     set of coordinates of an UGV inside the Nth camera.

    :param camera_locks: List containing N *threading.Condition* objects.
     They are used for synchronizing the *CameraThreads* and the
     *DataFusionThread* when doing R/W operations on shared variables.

    :param quadrant_limits: List containing N 4x2 arrays. Each array
     contains the 4 points defining the working space of the Nth camera.

    :param cameras_started: List of *threading.Event* objects that
     are set to True when the *CameraThread* has completed its camera
     initialization.

    :param end_execution: *threading.Event* object that is set to True when
     the *UserThread* detects an 'end' order from the user.

    :param save2file: *Boolean* that indicates if the position data is
     going to be saved into a file at the end of the execution.

    :param name: String containing the name of the current thread.
    """

    def __init__(self, triangles, camera_locks,
                 quadrant_limits, cameras_started, end_execution,
                 save2file=False, name='Fusion Thread'):
        """
        Class constructor method
        """
        threading.Thread.__init__(self, name=name)
        self.cycletime = 0.02
        self.quadrant_limits = quadrant_limits
        self.step = 0
        # Publishing socket instantiation.
        pose_publisher = zmq.Context.instance().socket(zmq.PUB)
        pose_publisher.bind("tcp://*:{}".format(
                int(os.environ.get("UVISPACE_BASE_PORT_POSITION")) + 1))
        # Open a subscribe socket and poller to listen for speed set points.
        speed_subscriber = zmq.Context.instance().socket(zmq.SUB)
        speed_subscriber.setsockopt_string(zmq.SUBSCRIBE, u"")
        speed_subscriber.setsockopt(zmq.CONFLATE, True)
        speed_subscriber.connect("tcp://localhost:{}".format(
                int(os.environ.get("UVISPACE_BASE_PORT_SPEED")) + 1))
        # Store sockets in dictionary
        self.poller = zmq.Poller()
        self.poller.register(speed_subscriber, zmq.POLLIN)
        self.sockets = {
            'pose_publisher': pose_publisher,
            'speed_subscriber': speed_subscriber,
        }
        # Synchronization variables
        self.__camera_locks = camera_locks
        self.__cameras_started = cameras_started
        self.__end_execution = end_execution
        # Shared lists. Can be accessed by other threads.
        self.__triangles_shared = triangles
        # Local lists. Can only be R/W by this thread.
        self.__triangles = copy.copy(self.__triangles_shared)
        # Array to save historic poses values. Initial values set to 0.
        self.data_hist = np.array([0., 0., 0., 0.]).reshape(1,4)
        # Variable containing the initial reference time.
        self.__start_time = 0
        # Kalman filter instance with 3 variables (x, y, theta)
        # and 2 inputs (linear and angular speeds).
        self.kalman = kalmanfilter.Kalman(var_dim=3, input_dim=2)
        # Set the process noise, calculated empirically. units = (mm, mm, rad)^2
        self.kalman.set_prediction_noise((3.5**2, 3.5**2, 0.015**2))
        # Boolean to save data in spreadsheet and file text.
        self.__save2file = save2file

    def run(self):
        """Main routine of the DataFusionThread."""
        # Wait until all cameras are initialized
        for event in self.__cameras_started:
            event.wait()
        # Set the reference time at this point.
        self.__start_time = time.time()
        triangle = []
        speeds = None
        publish_time = None
        while not self.__end_execution.isSet():
            # Start the cycle timer
            cycle_start_time = time.time()
            # Loop with N iterations, being N the number of camera threads.
            for index, lock in enumerate(self.__camera_locks):
                # Threads synchronized instructions.
                lock.acquire()
                # Read shared variables and store in local ones
                self.__triangles[index].update(
                        self.__triangles_shared[index])
                lock.release()

                # Evaluate if the triangle is in the borders regions.
                if self.__triangles[index]:
                    # Check that the element is not of None type.
                    if self.__triangles[index]['1']:
                        triangle = self.__triangles[index]['1']
                    # If dictionary element is None, skip to next camera.
                    else:
                        continue
                # If the element is void, skip to next camera.
                else:
                    continue

            # TODO merge the content of every dictionary in triangle
            # Calculate the time between iterations, for the Kalman prediction.
            if publish_time:
                delta_t = time.time() - publish_time
            else:
                delta_t = 0
            # Boolean for updating the Kalman measurement noise.
            detected_triangle = False
            # Scan for detected triangle and process it.
            for element in self.__triangles:
                if '1' in element:
                    if element['1'] is not None:
                        detected_triangle = True
                        triangle = copy.copy(element['1'])
            # The triangle is void at initialization, before it is detected for
            # the first time. If this is the case, ignore the rest of the loop.
            if not triangle:
                continue
            if speeds:
                inputs = np.array([speeds["linear"], speeds["angular"]])
                inputs = inputs.reshape(2,1)
                # Multiply the difference time by the number of steps that were
                # missed. This should be reflected as well in the noise.
                delta_t *= (1 + self.step - speeds['step'])
                self.kalman.set_prediction_noise((3.5**2, 3.5**2, 0.015**2))
            else:
                inputs = np.array([0, 0])
                delta_t = 0.02
                self.kalman.set_prediction_noise((1000**2, 1000**2, 2*np.pi**2))
            prediction, _ = self.kalman.predict(inputs, delta_t)
            # Increment the iterations counter.
            self.step += 1
            # Update the measured pose only if a triangle was detected.
            if detected_triangle:
                pose = triangle.get_pose()
                logger.info("Detected triangle at {}mm and {} radians."
                            "".format(pose[0:2], pose[2]))
                # Set the measurement noise to the cameras error, calculated
                # empirically.
                camera_noise = (50**2, 50**2, (2*np.pi/180)**2)
            # Set a very high measurement noise if the triangle is not detected.
            else:
                camera_noise = (1000**2, 1000**2, 2*np.pi**2)
            self.kalman.set_measurement_noise(camera_noise)
            # Time since first triangle, in milliseconds.
            diff_time = (time.time() - self.__start_time) * 1000
            # Temporary array to save time and pose in meters.
            new_data = np.array([diff_time, pose[0], pose[1],
                                 pose[2]]).astype(np.float64)
            # Matrix of floats to save data.
            self.data_hist = np.vstack((self.data_hist, new_data))
            pose_array = np.array(pose).reshape(3,1)
            new_state, _ = self.kalman.update(pose_array)
            pose_list = new_state.reshape(3).tolist()
            pose_msg = {'x': pose_list[0], 'y': pose_list[1],
                        'theta': pose_list[2], 'step': self.step}
            self.sockets['pose_publisher'].send_json(pose_msg)
            publish_time = time.time()
            logger.debug("Triangles at: {}".format(self.__triangles))
            # Allow to poll only during the remaining cycle time.
            polling_time = self.cycletime - (time.time()-cycle_start_time)
            # Subtract another amount of time for doing the other routines.
            logger.debug("polling {}s".format(polling_time))
            events = dict(self.poller.poll(polling_time))
            if (self.sockets['speed_subscriber'] in events
                    and events[self.sockets['speed_subscriber']] == zmq.POLLIN):
                speeds = self.sockets['speed_subscriber'].recv_json()
                logger.debug("Received new speed set point: {}".format(speeds))
            else:
                # Set speeds to None in order to ignore Kalman prediction step.
                speeds = None
                logger.debug("Not received any speed set point from navigator")
            # Sleep the rest of the cycle.
            while (time.time() - cycle_start_time) < self.cycletime:
                pass
        if self.__save2file:
            # Delete first row data (row of zeros).
            self.data_hist = self.data_hist[1:, :]
            # Save historic data containing poses and times.
            dataprocessing.process_data(self.data_hist, save_analyzed=True,
                                        save2master=True)
        # Cleanup resources
        for socket in self.sockets:
            self.sockets[socket].close()
        return


class UserThread(threading.Thread):
    """Child class of threading.Thread for interacting with user.

    The *run* method, where is specified the behaviour when the *start*
    method is called, is overridden. Ask the user for commands through
    keyboard.

    :param cameras_started: List with N *threading.Event* objects, where N
     is the number of Camera threads. Until the set up of every camera
     is finished, the user can not interact with this thread.

    :param end_execution: *threading.Event* object that is set to True when
     the *UserThread* detects an 'end' order from the user.
    """

    def __init__(self, cameras_started, end_execution, name='User Thread'):
        """Class constructor method."""
        threading.Thread.__init__(self, name=name)
        self.__cameras_started = cameras_started
        self.__end_execution = end_execution
        self.__cycletime = 0.5

    def run(self):
        """Main routine of the UserThread."""
        # Wait until all camera threads start.
        for event in self.__cameras_started:
            event.wait()
        logger.info("All cameras were initialized")
        while not self.__end_execution.isSet():
            # Start the cycle timer
            cycle_start_time = time.time()
            i = input("Press 'Q' to stop the script... ")
            if i in ("q", "Q"):
                self.__end_execution.set()
            # Sleep the rest of the cycle
            while (time.time() - cycle_start_time) < self.__cycletime:
                pass


def main():
    """Main routine for multiplecamera.py

    Read configuration files, initialize variables and set up threads.
    :return:
    """
    # Main routine
    save2file = False
    help_msg = "Usage: multiplecamera.py [-s | --save2file]"
    # This try/except clause forces to give the robot_id argument.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hs", ["save2file"])
    except getopt.GetoptError:
        print(help_msg)
        sys.exit()

    for opt, arg in opts:
        if opt == '-h':
            print(help_msg)
            sys.exit()
        if opt in ("-s", "--save2file"):
            save2file = True

    logger.info("BEGINNING MAIN EXECUTION")
    # Get the relative path to all the config files stored in /config folder.
    conf_files = glob.glob("./resources/config/*.cfg")
    conf_files.sort()
    threads = []
    # A Condition object for each camera thread execution.
    camera_locks = []
    # Shared variable for storing triangles. Writable only by CameraThreads.
    triangles_shared = [{}, {}, {}, {}]
    # A begin event for each camera will be created
    cameras_started = []
    end_execution = threading.Event()
    # New thread instantiation for each configuration file.
    for index, filename in enumerate(conf_files):
        camera_locks.append(threading.Condition())
        cameras_started.append(threading.Event())
        threads.append(CameraThread(triangles_shared[index],
                                    cameras_started[index],
                                    end_execution,
                                    camera_locks[index],
                                    'Camera{}'.format(index),
                                    filename))
    # List containing the points defining the space limits of each camera.
    quadrant_limits = []
    for camera_thread in threads:
        quadrant_limits.append(camera_thread.camera.limits)
    # Thread for merging the data obtained at every CameraThread.
    threads.append(DataFusionThread(triangles_shared,
                                    camera_locks,
                                    quadrant_limits,
                                    cameras_started,
                                    end_execution,
                                    save2file))
    # Thread for getting user input.
    threads.append(UserThread(cameras_started, end_execution))
    # start threads
    for thread in threads:
        thread.start()
    # wait for threads to end
    for thread in threads:
        thread.join()

    return


if __name__ == '__main__':
    main()
