import threading
from distutils.util import strtobool
import logging
import configparser
import zmq
import numpy as np

from uvispace.uvirobot.common import UgvType, UgvCommType
from uvispace.uvirobot.robot_model.robot_model import RobotModel

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("robot")

class UviRobot():
    """
    This class controls the communications with the UGVs in UviSpace.
    It listens the speed socket for each robot and sends through the
    correct UGV using the correct protocol (Zigbee or Wifi):
    """
    def __init__(self, threaded = False):
        """
        Initialices the uvirobot class
        Params:
        - threaded = uvirobot loop launches in other thread
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
        self.battery_port = int(configuration["ZMQ_Sockets"]["battery_base"])
        self.pose_port = int(configuration["ZMQ_Sockets"]["position_base"])
        # real or simulated ugvs??
        self.simulated_ugvs = strtobool(configuration["Run"]["simulated_ugvs"])
        # active ugvs
        self.active_ugvs = list(map(int, configuration["UGVs"]["active_ugvs"].split(",")))

        # load the ugv related info
        self.ugv_types = []
        self.ugv_comm_types = []
        self.ugv_comm_params = []
        for id in self.ugv_ids:
            ugv_configuration = configparser.ConfigParser()
            ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(id)
            ugv_configuration.read(ugv_conf_file)
            # ugv type
            ugv_type = ugv_configuration["Robot_chassis"]["ugv_type"]
            self.ugv_types.append(ugv_type)
            # ugv communication details
            ugv_comm_type = ugv_configuration["Communication"]["protocol_type"]
            self.ugv_comm_types.append(ugv_comm_type)
            ugv_comm_params = {}
            if ugv_comm_type == UgvCommType.wifi:
                ugv_comm_params["tcp_ip"] = ugv_configuration["Communication"]["tcp_ip"]
                ugv_comm_params["tcp_port"] = int(ugv_configuration["Communication"]["tcp_port"])
            elif ugv_comm_type == UgvCommType.zigbee:
                ugv_comm_params["baudrate"] = int(ugv_configuration["Communication"]["baudrate"])
                ugv_comm_params["serial_port"] = ugv_configuration["Communication"]["serial_port"]
            else:
                logger.error("Unrecognized communication type:{}.".format(ugv_comm_type))
            self.ugv_comm_params.append(ugv_comm_params)

        # if threaded mode is selected prepare elements to launch stream in
        # different thread
        self._kill_thread = threading.Event()
        self._kill_thread.clear()
        if self.threaded:
            self.thread = threading.Thread(target = self.loop)

    def start(self):
        """
        Starts an infinite loop that reads from speed socket and sends to the
        corresponding robot through Zigbee or Wifi
        """
        logger.info("Starting UviRobot.")
        if self.threaded:
            self._kill_thread.clear()
            self.thread.start()
        else:
            self.loop()

    def stop(self):
        """
        It permits to stop the loop and finish the thread in threaded mode
        """
        logger.info("Stopping UviRobot.")
        self._kill_thread.set()
        # wait until the thrad finishes
        self.thread.join()

    def loop(self):

        # create communication sockets
        motor_speed_sockets = []
        battery_sockets = []
        if self.simulated_ugvs:
            pose_sockets = []
        for i in range(self.num_ugvs):
            # create the sockets for reading the motor speed
            speed_subscriber = zmq.Context.instance().socket(zmq.SUB)
            speed_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            speed_subscriber.setsockopt(zmq.CONFLATE, True)
            speed_subscriber.connect("tcp://localhost:{}".format(
                self.speed_base_port + i))
            motor_speed_sockets.append(speed_subscriber)
            # create the sockets to share battery level
            battery_publisher = zmq.Context.instance().socket(zmq.PUB)
            battery_publisher.sndhwm = 1
            battery_publisher.bind("tcp://*:{}".format(self.battery_port + i))
            battery_sockets.append(battery_publisher)
            # if simulated ugvs create a socket to publish pose too
            if self.simulated_ugvs:
                pose_publisher = zmq.Context.instance().socket(zmq.PUB)
                pose_publisher.sndhwm = 1
                pose_publisher.bind("tcp://*:{}".format(self.pose_port + i))
                print("uvirobot: pose socket port for ugv {} = {}".format(i, self.pose_port + i))
                pose_sockets.append(pose_publisher)

        # Create extra objects depending on real or virtual ugvs
        if self.simulated_ugvs:
            # create a model of the robot to simulate its movement
            ugv_models = []
            for i in range(self.num_ugvs):
                ugv_models.append(RobotModel(self.ugv_types[i]))
            # obtain initial pose of the active ugvs
            poses = [None]*self.num_ugvs
            for i in range(self.num_ugvs):
                if self.active_ugvs[i] == 1:
                    poses[i] = ugv_models[i].get_current_pose()
        else:
            # create the communication objects for each UGV (if real ugvs are there)
            ugv_messenger = []
            for i in range(self.num_ugvs):
                try:
                    if ugv_comm_types[i] == UgvCommType.zigbee:
                        ugv_messenger = ZigBeeMessenger(
                                    port=self.ugv_comm_params["serial_port"],
                                    baudrate=self.ugv_comm_params["baudrate"])
                        ugv_messenger.SLAVE_ID = struct.pack('>B', self.ugv_ids[i])
                    elif ugv_comm_types[i] == UgvCommType.wifi:
                        ugv_messenger = WifiMessenger(
                                    TCP_IP = self.ugv_comm_params["tcp_ip"],
                                    TCP_PORT = self.ugv_comm_params["tcp_port"])
                except:
                    logger.info("Error when connecting with UGV with ID = {}".format(
                        self.ugv_ids[i]))
                    sys.exit()


        while not self._kill_thread.isSet():
            for i in range(self.num_ugvs):

                # read motor speed socket to check if new setpoints available
                try:
                    #check for a message, this will not block
                    # if no message it leaves the try because zmq behaviour
                    motors_speed = motor_speed_sockets[i].recv_json(flags=zmq.NOBLOCK)
                    # if new setpoints send to the UGV
                    if self.simulated_ugvs:
                        # with simulated ugvs generate a simulated movement
                        poses[i] = ugv_models[i].step(motors_speed)
                    else:
                        # with real ugvs just send to the motor speed to UGVs
                        messenger.move([motors_speed["m1"], motors_speed["m2"]])
                        logger.info('Sending M1: {} M2: {}'.format(
                            motors_speed["m1"],
                            motors_speed["m2"]))
                except:
                    pass

                # always send pose even if no motor speeds are sent to better
                # simulate uvisensor (send location even if robot is stopped)
                if self.simulated_ugvs:
                    if self.active_ugvs[i] == 1:
                        print("uvirobot:ugv {} pose = {} sent".format(i, poses[i]))
                        pose_sockets[i].send_json(poses[i])

                # read battery once per second

                # publish battery
