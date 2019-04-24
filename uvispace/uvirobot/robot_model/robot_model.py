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

        # set a random location and orientation near (0,0)
        self.pose = {'x':0, 'y':0, 'theta':math.pi/2}
        print('ubirobot:', self.pose)
        self.env.define_state(self.pose['x'], self.pose['y'],self.pose['theta'])

    def get_current_pose(self):
        return self.pose

    def step(self, motor_speed):
        m1 = motor_speed["m1"]
        m2 = motor_speed["m2"]

        print('ubirobot:',self.pose)

        # call step in the environment a get pose
        x , y, theta = self.env.step(simulation= True, m1 = m1, m2 = m2)

        self.pose = {'x':x, 'y':y, 'theta':theta}

        print('ubirobot:',self.pose)
        return self.pose
