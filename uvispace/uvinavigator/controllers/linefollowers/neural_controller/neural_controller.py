
from uvispace.uvinavigator.controllers.controller import Controller

class NeuralController(Controller):
    """
    This class inherits all the functions shared by all controllers from
    Controller class and implements the specific functions for the Neural
    Controller.
    """
    def __init__(self):

        # Initialize the father class
        Controller.__init__(self)

    def step(self, pose, delta_t):

        # uncompress pose if desired
        x = pose["x"]
        y = pose["y"]
        theta = pose["theta"]

        # call the neural agent to get the new motor setpoints for the motors
        if True: # change this to : if trajectory was finished
            # stop the UGV
            m1 = 128
            m2 = 128
            self.trajectory = []
            self.running = False
        else:
            # call the neural agent to get the new values of m1 and m2
            m1 = 6
            m2 = 7
            pass


        return {"m1": m1, "m2": m2}
