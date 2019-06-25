import configparser
import logging
import time
import numpy as np
import sys

from uvispace.uvinavigator.controllers.controller import Controller
from uvispace.uvinavigator.controllers.linefollowers.neural_controller.DQNagent import Agent
from uvispace.uvirobot.robot_model.environment import UgvEnv
from uvispace.uvirobot.common import UgvType
from uvispace.uvinavigator.controllers.linefollowers.neural_controller.resources.validation_csv.csv_generator import generator

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("navigator")


class TableController(Controller):
    """
    This class inherits all the functions shared by all controllers from
    Controller class and implements the specific functions for the Table
    Controller.
    """

    def __init__(self, ugv_id):

        # Initialize the father class
        Controller.__init__(self)
        self.ugv_id = ugv_id

        ugv_configuration = configparser.ConfigParser()
        ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(ugv_id)
        ugv_configuration.read(ugv_conf_file)
        ugv_type = ugv_configuration["Robot_chassis"]["ugv_type"]

        if ugv_type == UgvType.df_robot_baron4:
            self.differential = True
        elif ugv_type == UgvType.lego_42039:
            self.differential = False
        else:
            logger.error("Unrecognized robot type:{}.".format(ugv_type))

        self.agent_initialized = False

    def start_new_trajectory(self, trajectory):

        """ This function overwrites previous trajectories and makes the UGV
        to start executing the new one. """

        # overwrite previous trajectory with the new one

        Controller.start_new_trajectory(self, trajectory)
        self.num_points = len(self.trajectory['y'])

        # initialize table Agent (controller) with the first trajectory
        if not self.agent_initialized:   #  Que necesito pa iniciar o agente?
            self.agent_initialized = True
            self.state_size = 2
            self.action_size = 5 * 5
            self.NUM_DIV_ACTION = 9
            self.agent = Agent(self.state_size, self.action_size)  # REVISAR

            self.agent.load_model(
                'uvispace/uvinavigator/controllers/linefollowers/neural_controller/resources/neural_nets/ANN_ugv{}.h5'.format(self.ugv_id))

        # initialize an instance of UGV environment to help with calculations
        self.env = UgvEnv(self.trajectory['x'], self.trajectory['y'], 0,
                          self.NUM_DIV_ACTION, closed=False, differential_car=self.differential)  #  discrete_input = TRUE

        self.env.reset(self.trajectory['x'][0], self.trajectory['y'][0])

        # Vectors for validation study
        self.periods = []
        self.x = []
        self.y = []
        self.distance = []
        self.t1 = time.time()

    def step(self, pose):
        """
        This function generates the new action (UGV motor setpoints) for the
        current pose and trajectory calling the neural agent
        """

        # uncompress pose
        x = pose["x"]
        y = pose["y"]
        theta = pose["theta"]

        self.t2 = time.time()
        period = self.t2-self.t1
        self.t1 = self.t2

        self.env.define_state(x, y, theta)
        distance = self.env._distance_next()
        delta_theta = self.env._calc_delta_theta()
        index = self.env._get_index()

        self.periods.append(period)
        self.x.append(x)
        self.y.append(y)
        self.distance.append(distance)

        # print(pose)
        # print(index)

        # call the neural agent to get the new motor setpoints for the motors
        if index >= (self.num_points-1):
            # stop the UGV
            m1 = 128
            m2 = 128
            self.trajectory = []
            self.running = False
            gen = generator()
            gen.generate_csv([self.periods, self.x, self.y, self.distance])

        else:

            # call the table agent to get the new values of m1 and m2

            agent_state = self.agent.format_state([distance, delta_theta])
            print(distance*100, delta_theta*180/3.1415)
            action = self.agent.action(agent_state, training=False)

            m1, m2 = self.env._dediscretize_action(action)

        return {"m1": m1, "m2": m2}