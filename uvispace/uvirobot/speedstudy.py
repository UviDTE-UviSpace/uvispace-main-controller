#!/usr/bin/env python
"""
Auxiliary program to move the car at speeds between 0 and 255 (binary).
"""
# Standard libraries
import sys
import getopt
import numpy as np
import time
# Local libraries
from messenger import connect_and_check
from robot import RobotController

class PolySpeedSolver(object):
    """This class solves a polynomial to get setpoints.

    From the coefficients obtained from the configuration file, an
    equation of two variables in the second degree is solved to obtain
    the speed setpoint from the desired linear and angular speeds.

    Class to study the speed of the UGV. Once validated, this class is
    implemented in the speedstransform module.

    :param coefs: coefficients of the second degree polynomial.
    :type coefs: tuple(6 elemens float).
    :param int sp: speed setpoint.
    :param thresholds: speed setpoint thresholds.
    :type thresholds tuple (3 elements int).
    """
    def __init__(self, coefs=(0, 0, 0, 0, 0, 0)):
        """Coefficients of a polynomial of two variables of sp funcion.

        sp(v,w) = c0 + c1*v + c2*w + c3*v^2 + c4*v*w + c5*w^2
        v: linear speed
        w: angular speed
        coefs = (c0, c1, c2, c3, c4, c5)
        """
        self._coefs = coefs
        self.sp = 0
        self.thresholds = (0, 127, 255)

    def solve(self, linear, angular):
        """Obtain setpoint values from angular and linear velocities.

        Apply a polynomial equation to the input, using the class'
        coeficients, in order to obtain a setpoint for the desired UGV.

        The polynomial function can have a maximum degree of 2.

        :param float linear: linear speed value.
        :param float angular: angular speed value.
        :return: physical vehicle setpoint.
        :rtype: 0 to 255 int
        """
        # Solve the poly function as a outer product between the coeficients
        # and the independent variables.
        variables = [1, linear, angular, linear**2, linear*angular, angular**2]
        sp = np.dot(np.array(self._coefs), np.array(variables))
        sp = np.dot(np.array(self._coefs), np.array(variables).reshape(6, 1))
        # Format the obtained value to the UGV setpoints scale.
        if linear > 0:
            self.sp = np.clip(int(sp), self.thresholds[1], self.thresholds[2])
        elif linear == 0 and angular == 0:
            self.sp = 127
        else:
            self.sp = 40
        return self.sp

    def update_coefs(self, coefs):
        """Update the coefficients of the equation.

        :param coefs: coefficients of the second degree polynomial.
        :type coefs: tuple(6 elements float).
        """
        self._coefs = coefs
        return self._coefs

def main():
    # Main routine
    help_msg = 'Usage: speedstudy.py [-r <robot_id>], [--robotid=<robot_id>]'
    # This try/except clause forces to give the robot_id argument.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hr:", ["robotid="])
    except getopt.GetoptError:
        print help_msg
        sys.exit()
    if not opts:
        print help_msg
        sys.exit()
    for opt, arg in opts:
        if opt == '-h':
            print help_msg
            sys.exit()
        elif opt in ("-r", "--robotid"):
            robot_id = int(arg)

    # Create an instance of SerMesProtocol and check connection to port.
    my_serial = connect_and_check(robot_id)
    my_robot = RobotController(robot_id)
    # Equation degrees linear velocity 2 and angular velocity 2.
    left_solver = PolySpeedSolver(coefs=(117.1, 0.334, 36.02, 0.00002422,
                                         -0.4208, 22.21))
    right_solver = PolySpeedSolver(coefs=(141, 0.0902, -94.88, 0.0004565,
                                          0.6557, 22.59))
    linear = float(raw_input("Enter the linear speed value\n"))
    angular = float(raw_input("Enter the angular speed value\n"))
    operatingtime = float(raw_input("Enter the time to evaluate in seconds \n"))
    init_time = time.time()
    sp_left = int(left_solver.solve(linear, angular))
    sp_right = int(right_solver.solve(linear, angular))
    print "I am sending (%d, %d)" % (sp_left, sp_right)
    while (time.time() - init_time) < operatingtime:
        my_serial.move([sp_right, sp_left])
    # When the desired time passes, the speed is zero
    print "I am sending (%d, %d)" % (sp_left, sp_right)
    sp_right = 127
    sp_left = 127
    my_serial.move([sp_right, sp_left])
    print "I am sending (%d, %d)" % (sp_left, sp_right)

if __name__ == '__main__':
    main()
