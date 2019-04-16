
import abc

class Controller():
    """
    This class defines the common functions shared by all types of controllers
    and provides an unified set of functions that can be called from
    uvinavigator regardless the type of controller.
    Each controller must inherit from this class and overwrite the abstract
    methods
    """

    def __init__(self):
        # list of trajectory points
        self.trajectory = []
        # True if the UGV is executing a trajectory
        self.running = False

    def start_new_trajectory(self, trajectory):
        """
        stop the execution of the previous trajectory and start a new one
        params:
         - trajectory: list of points the ugv must pass through
        """
        trajectory = self.trajectory
        self.running = True

    def abort_trajectory(self):
        """
        stop the ugv and erase the previous trajectory
        """
        self.trajectory = []
        self.running = False

    def isRunning(self):
        return self.running

    @abc.abstractmethod
    def step(self, pose, delta_t):
        """
        Using the current pose of the UGV it generates the motor set points
        for motor 1 and motor 2 to follow the trajectory currently stored.
        This is an abstract function. Every specific controller must overwrite
        this function to adapt it to its behaviour.
        params:
         - pose: dictionary with the current pose of the UGV. Format:
           pose = {"x": <x>, "y": <y>, "theta": <theta> }
           <x> and <y> in meters and <theta> in radians.
         - delta_t: sampling period (equal to fps of the cameras if the
           computer is powerful enough to process everything on time).
         return:
          - motor_speed: dict with the speed setpoints of motor1 and motor2
            Format: motor_speed = {"m1": <speed_m1>, "m2": <speed_m2>}
            <speed_m1> and  <speed_m2> are values between 0 and 256.
            From 0 to 127 the motor goes one direction, 128 the motor is
            stopped, 128 to 255 the motor goes forward.
        """
        motor_speed =  {"m1": 128, "m2": 128}
        return motor_speed
