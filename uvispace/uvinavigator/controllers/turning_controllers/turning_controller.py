import configparser
import logging
import math

from uvispace.uvinavigator.controllers.controller import Controller
from uvispace.uvinavigator.controllers.linefollowers.neural_controller.DQNagent import  Agent
from uvispace.uvirobot.robot_model.environment import UgvEnv
from uvispace.uvirobot.common import UgvType

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("navigator")

class NeuralController(Controller):
    """
    This class inherits all the functions shared by all controllers from
    Controller class and implements the specific functions for the Neural
    Controller.
    """
    def __init__(self, ugv_id):

        # Initialize the father class
        Controller.__init__(self)

        #define max 5º delta theta to go forward
        self.delta_theta_max=5*180/math.pi

        self.ugv_id=ugv_id

        ugv_configuration = configparser.ConfigParser()
        ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(ugv_id)
        ugv_configuration.read(ugv_conf_file)
        ugv_type = ugv_configuration["Robot_chassis"]["ugv_type"]
        if ugv_type == UgvType.df_robot_baron4:
            self.differential=True
        elif ugv_type == UgvType.lego_42039:
            self.differential=False
        else:
            logger.error("Unrecognized robot type:{}.".format(ugv_type))


    def start_new_trajectory(self, trajectory):
        """
        This function overwrites previous trajectories and makes the UGV
        to start executing the new one.
        """

        # overwrite previous trajectory with the new one

        Controller.start_new_trajectory(self, trajectory)
        self.num_points=len(self.trajectory['y'])

        # initialize an instance of UGV environment to help with calculations
        self.env = UgvEnv(self.trajectory['x'], self.trajectory['y'],0,
                     self.NUM_DIV_ACTION, closed=False, differential_car=self.differential)
        self.env.reset(self.trajectory['x'][0],self.trajectory['y'][0])



    def step(self, pose):
        """
        This function generates the new action (UGV motor setpoints) for the
        current pose and trajectory calling the neural agent
        """

        # uncompress pose
        x = pose["x"]
        y = pose["y"]
        theta = pose["theta"]

        self.env.define_state(x, y, theta)
        distance=self.env._distance_next()
        delta_theta= self.env._calc_delta_theta()

        #print(pose)
        #print(index)

        # If delta theta too high the vehicle turn to reduce it
        if delta_theta>self.delta_theta_max:
            # stop the UGV
            m1 = 64
            m2 = 192

        else:
            # otherwise the vehicle goes forward to the starting point


            m1= 192
            m2 = 192

        return {"m1": m1, "m2": m2}