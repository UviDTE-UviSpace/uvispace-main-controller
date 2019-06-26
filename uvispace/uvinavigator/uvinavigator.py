import threading
from distutils.util import strtobool
import logging
import configparser
import zmq
import numpy as np
import time

from uvispace.uvinavigator.common import ControllerType
from uvispace.uvinavigator.controllers.linefollowers.neural_controller.neural_controller import NeuralController
from uvispace.uvinavigator.controllers.linefollowers.table_controller.table_controller import TableController

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("navigator")

class UviNavigator():
    """
    This class controls the movement of the UGVs in UviSpace. It receives
    trajectories through the trajectory_base socket, stores them and goes
    executing them. It reads the real location of UGVs through the position_base
    sockets and produces the UGV motor setpoint that are stored in the
    speed_base socket.
    """
    def __init__(self, threaded = False):
        """
        Initialices the uvinavigator class
        Params:
        - threaded = uvinavigator loop launches in other thread
        """
        self.threaded = threaded

        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)

        # get the max number of robots that can be used and their ids
        self.num_ugvs = int(configuration["UGVs"]["number_ugvs"])
        self.ugv_ids = list(map(int, configuration["UGVs"]["ugv_ids"].split(",")))
        # load the fps of the system at which positions are being updated
        self.fps = float(configuration["LocNodes"]["cameras_frame_rate"])
        self.period = 1/self.fps
        # load the ports for zmq socket communications
        self.speed_base_port = int(configuration["ZMQ_Sockets"]["speed_base"])
        self.position_base_port = int(configuration["ZMQ_Sockets"]["position_base"])
        self.trajectory_base_port = int(configuration["ZMQ_Sockets"]["trajectory_base"])
        # real or simulated ugvs??
        self.simulated_ugvs = strtobool(configuration["Run"]["simulated_ugvs"])
        # active ugvs
        self.active_ugvs = list(map(int, configuration["UGVs"]["active_ugvs"].split(",")))

        # load the controller type of each UGV
        self.controller_types = []
        for id in self.ugv_ids:
            ugv_configuration = configparser.ConfigParser()
            ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(id)
            ugv_configuration.read(ugv_conf_file)
            controller_type = ugv_configuration["Controller"]["controller_type"]
            if controller_type == ControllerType.neural_line_follower:
                self.controller_types.append(ControllerType.neural_line_follower)
            elif controller_type == ControllerType.tables_line_follower:
                self.controller_types.append(ControllerType.tables_line_follower)
            elif controller_type == ControllerType.fuzzy_point_to_point:
                self.controller_types.append(ControllerType.fuzzy_point_to_point)
            else:
                logger.error("Unrecognized controller type:{}.".format(controller_type))

        # if threaded mode is selected prepare elements to launch stream in
        # different thread
        self._kill_thread = threading.Event()
        self._kill_thread.clear()
        if self.threaded:
            self.thread = threading.Thread(target = self.loop)

    def start(self):
        """
        Starts an infinite loop that reads from the pose and trajectory
        socket of each UGV and writes in the speed socket of each UGV.
        """
        logger.info("Starting UviNavigator.")
        if self.threaded:
            self._kill_thread.clear()
            self.thread.start()
        else:
            self.loop()

    def stop(self):
        """
        It permits to stop the loop and finish the thread in threaded mode
        """
        logger.info("Stopping UviNavigator.")
        self._kill_thread.set()
        # wait until the thread finishes
        self.thread.join()

    def loop(self):

        # create the 3 sets of sockets
        trajectory_sockets = []
        pose_sockets = []
        motor_speed_sockets = []
        for i in range(self.num_ugvs):
            # socket to read trajectories (from gui or a console)
            trajectory_subscriber = zmq.Context.instance().socket(zmq.SUB)
            trajectory_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            trajectory_subscriber.setsockopt(zmq.CONFLATE, True)
            trajectory_subscriber.connect("tcp://localhost:{}".format(
                self.trajectory_base_port + i))
            trajectory_sockets.append(trajectory_subscriber)
            # socket to read robot pose (x, y and theta)
            pose_subscriber = zmq.Context.instance().socket(zmq.SUB)
            pose_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            pose_subscriber.setsockopt(zmq.CONFLATE, True)
            pose_subscriber.connect("tcp://localhost:{}".format(
                self.position_base_port + i))
            pose_sockets.append(pose_subscriber)
            # socket to publish speeds
            speed_publisher = zmq.Context.instance().socket(zmq.PUB)
            speed_publisher.sndhwm = 1
            speed_publisher.bind("tcp://*:{}".format(self.speed_base_port + i))
            motor_speed_sockets.append(speed_publisher)

        # Variable to store poses
        poses = [None]*self.num_ugvs

        # create the controller for each UGV
        self.controllers = []
        for i in range(self.num_ugvs):
            if self.controller_types[i] == ControllerType.neural_line_follower:
                self.controllers.append(NeuralController(self.ugv_ids[i]))

            elif self.controller_types[i] == ControllerType.tables_line_follower:
                self.controllers.append(TableController(self.ugv_ids[i]))

            elif self.controller_types[i] == ControllerType.fuzzy_point_to_point:
                # to be implemented
                pass
        debug=0
        t1 = time.time()
        while not self._kill_thread.isSet():
            for i in range(self.num_ugvs):
                # if this ugv is active (can move)
                if self.active_ugvs[i] == 1:
                    # check in case a new trajectory from trajectory socket
                    try:
                        #check for a message, this will not block
                        # if no message it leaves the try because zmq behaviour
                        trajectory = trajectory_sockets[i].recv_json(flags=zmq.NOBLOCK)
                        print("after1")
                        print('uvinavigator: trajectory received')

                        #calculate distance from first point of the trajectory to the vehicle
                        distance_trajec=np.sqrt((trajectory['x'][0]-poses[i]['x'])**2+(trajectory['y'][0]-poses[i]['y'])**2)

                        print('uvinavigator: distance:', distance_trajec)

                        if distance_trajec>0.07:
                            points=distance_trajec//0.05+2
                            x_appendize=np.linspace(poses[i]['x'],trajectory['x'][0]-0.005,points)
                            y_appendize=np.linspace(poses[i]['y'],trajectory['y'][0]-0.005,points)

                            trajectory['x']=np.concatenate((x_appendize, trajectory['x']))
                            trajectory['y']=np.concatenate((y_appendize, trajectory['y']))

                        # set the received trajectory as new trajectory
                        print("before")
                        debug = 1
                        print("after")

                        # print a message in logger
                        logger.debug("Starting a new trajectory with UGV {}".format(self.ugv_ids[i]))
                    except:
                        pass
                    if debug==1:
                        self.controllers[i].start_new_trajectory(trajectory)
                        debug=0

                    # read the pose socket to get the UGV current pose
                    try:
                        #check for a message, this will not block
                        # if no message it leaves the try because zmq behaviour
                        poses[i] = pose_sockets[i].recv_json(flags=zmq.NOBLOCK)
                        # if the UGV did not finished the trajectory yet
                        if self.controllers[i].isRunning():
                            # execute controller to get new motor setpoints
                            motors_speed = self.controllers[i].step(poses[i])
                            t2 = time.time()
                            fps=1/(t2-t1)
                            t1 = t2
                            print("speed={}, fps={}".format(motors_speed, fps))
                            # send the new motor speed setpoints to UGV
                            motor_speed_sockets[i].send_json(motors_speed)
                    except:
                        pass
