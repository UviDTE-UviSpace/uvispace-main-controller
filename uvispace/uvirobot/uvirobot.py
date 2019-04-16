import threading
from distutils.util import strtobool
import logging
import configparser
import zmq
import numpy as np

from uvispace.uvirobot.common import UgvType

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
        # real or simulated ugvs??
        self.simulated_ugvs = strtobool(configuration["Run"]["simulated_ugvs"])

        # load the ugv types
        self.ugv_types = []
        for id in self.ugv_ids:
            ugv_configuration = configparser.ConfigParser()
            ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(id)
            ugv_configuration.read(ugv_conf_file)
            ugv_type = ugv_configuration["Robot_chassis"]["ugv_type"]
            if ugv_type == UgvType.df_robot_baron4:
                self.ugv_types.append(UgvType.df_robot_baron4)
            elif ugv_type == UgvType.lego_42039:
                self.ugv_types.append(UgvType.lego_42039)
            else:
                logger.error("Unrecognized robot type:{}.".format(ugv_type))

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

        # create the sockets for reading the motor speed
        sockets = []
        for i in range(self.num_ugvs):
            pass

        # create the communication objects for each UGV
        if self.simulated_ugvs:
            ugv_messenger = []
            for id in self.ugv_ids:
                pass

        while not self._kill_thread.isSet():
            for i in range(self.num_ugvs):

                if self.simulated_ugvs:
                    pass
                else: # real UGVs
                    pass
                # read its socket to check if new speed setpoints are available

                # if new points are available send them to the real ugv

                # read battery once per second

                # publish battery
