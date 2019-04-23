import math

from uvispace.uvirobot.common import UgvType
from uvispace.uvirobot.robot_model.environment import UgvEnv

class RobotModel():
    """
    This class implements a model with shared interface for all UGVs.
    It is used to simulate steps when simulated UGVs are used
    """
    def __init__(self, ugv_type):
        """
        :param str ugv_type: a string from UgvType (uvirobot.common).
        """
        self.ugv_type = ugv_type

        if self.ugv_type == UgvType.df_robot_baron4:
            self.differential=True
            pass
        else:
            self.differential=False
            pass
        self.env = UgvEnv( period=1/30, closed=False, differential_car=self.differential)

        # set a random location and orientation aroun (0,0)
        self.env.define_state(0, 0,math.pi/4)

    def step(self, motor_speed):
        m1 = motor_speed["m1"]
        m2 = motor_speed["m2"]

        # call step in the environment a get pose

        x , y, theta = self.env.step(simulation= True, m1 = m1, m2 = m2)

        pose = {}
        pose["x"] = x
        pose["y"] = y
        pose["theta"] = theta
        return pose
