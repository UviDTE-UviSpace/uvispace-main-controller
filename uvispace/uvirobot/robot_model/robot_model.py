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
            #self.env = differential
            pass
        else:
            #self.env = ackerman
            pass

        # set a random location and orientation aroun (0,0)
        # self.x =
        # self.y
        # self.theta

    def step(self, motor_speed):
        m1 = motor_speed["m1"]
        m2 = motor_speed["m2"]

        # call step in the environment a get pose

        pose = {}
        #pose["x"] =
        #pose["y"] =
        #pose["theta"] =
        return pose
