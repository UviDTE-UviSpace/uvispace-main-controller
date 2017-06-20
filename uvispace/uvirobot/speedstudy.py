#!/usr/bin/env python
"""
Auxiliary program to move the car at speeds between 0 and 255 (binary).
"""
# Standard libraries
import sys
import getopt
import time
# Local libraries
from messenger import connect_and_check
from robot import RobotController

class PolySpeedSolver(object):

    def __init__(self, coefs=(0, 0, 0, 0, 0, 0)):
        "f(x,y) = c0 + c1*x + c2*y + c3*x^2 + c4*x*y + c5*y^2"
        self._coefs = coefs
        self.sp = 0

    def solve(self, linear, angular):
        addend = [0, 0, 0, 0, 0, 0]
        addend[0] = self._coefs[0]
        addend[1] = self._coefs[1] * linear
        addend[2] = self._coefs[2] * angular
        addend[3] = self._coefs[3] * linear ** 2
        addend[4] = self._coefs[4] * linear * angular
        addend[5] = self._coefs[5] * angular ** 2
        for x in range (0, 6):
            self.sp += addend[x]
        if self.sp > 255:
            self.sp = 255
        if self.sp < 160:
            self.sp = 160

        return self.sp

    def update_coefs(self, coefs):
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
    # Request of speeds and time to the user
    # Equation degrees linear velocity 1 and angular velocity 1.
    #left_solver = PolySpeedSolver(coefs=(128.2, 0.311, -57.05, 0, 0, 0))
    #right_solver = PolySpeedSolver(coefs=(116.1, 0.3269, 60.87, 0, 0, 0))
    # Equation degrees linear velocity 1 and angular velocity 2.
    #left_solver = PolySpeedSolver(coefs=(115.5, 0.347, 36.6, 0, -0.4232, 22.03))
    #right_solver = PolySpeedSolver(coefs=(110.7, 0.3357, -84.03, 0, 0.6101, 19.21))
    # Equation degrees linear velocity 2 and angular velocity 2.
    left_solver = PolySpeedSolver(coefs=(117.1, 0.334, 36.02, 0.00002422, -0.4208, 22.21))
    right_solver = PolySpeedSolver(coefs=(141, 0.0902, -94.88, 0.0004565, 0.6557, 22.59))
    # sp_left = input("Enter the speed value for the left wheels, between "
    #                 "0 and 255 \n")
    # sp_right = input("Enter the speed value for the right wheels, between "
    #                 "0 and 255 \n")
    linear = float(raw_input("Enter the linear speed value\n"))
    angular = float(raw_input("Enter the angular speed value\n"))
    operatingtime = float(raw_input("Enter the time to evaluate in seconds \n"))
    init_time = time.time()
    sp_right = int(right_solver.solve(linear, angular))
    sp_left = int(left_solver.solve(linear, angular))
    print "I am sending (%d, %d)" % (sp_left, sp_right)
    #import pdb; pdb.set_trace()
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
