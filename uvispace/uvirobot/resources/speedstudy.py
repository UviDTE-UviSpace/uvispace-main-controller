#!/usr/bin/env python
"""Auxiliary program to move the UGV at constant speed.

This module allows the UGV to move at a constant speed for a given time.
These values are required to the user.

There are two possible modes of operation:

-(lin_ang) Linear and angular speeds that transform into setpoints by
solving a polynomial equation. The coefficients of the equation will be
read from the modelrobot.cfg file in 'config' directory. This file can
be modified by the user introducing these coefficients in the section
'Coefficients'. It is necessary to introduce coefficients for the left
and right setpoints.

-(setpoints) Introduction of setpoints directly.
"""
# Standard libraries
import ast
import ConfigParser
import glob
import getopt
import logging
import numpy as np
import sys
import time
# Local libraries
from uvirobot.robot import RobotController
from uvirobot.speedtransform import PolySpeedSolver

try:
    import messenger
except ImportError:
    # Exit program if the uvirobot package can't be found.
    sys.exit("Can't find uvirobot module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")

# Logging setup.
import settings

logger = logging.getLogger('speedstudy')

def main():
    logger.info("BEGINNING EXECUTION")

    # Main routine
    help_msg = ('Usage: speedstudy.py [-r <robot_id>], [--robotid=<robot_id>],'
                '[-m <mode>], [--mode=<lin_ang/setpoints>]\n'
                'There are two possible modes of operation:\n'
                '-(lin_ang) Linear and angular speeds that transform into'
                'setpoints by solving a polynomial equation (see help section).'
                '\n-(setpoints) Introduction of setpoints directly.')
    # This try/except clause forces to give the robot_id argument.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hr:m:", ["robotid=", "mode="])
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
        elif opt in ("-m", "--mode"):
            mode= str(arg)
            if not mode in ('lin_ang', 'setpoints'):
                print help_msg
                sys.exit()
    logger.info("Start")
    # Create an instance of SerMesProtocol and check connection to port.
    my_serial = messenger.connect_and_check(robot_id)
    # my_robot = RobotController(robot_id)
    if mode == 'lin_ang':
        conf = ConfigParser.ConfigParser()
        conf_file = glob.glob("./resources/config/modelrobot.cfg")
        conf.read(conf_file)
        # Coefficients for a movement.
        left_coefs = ast.literal_eval(conf.get('Coefficients', 'coefs_left'))
        right_coefs = ast.literal_eval(conf.get('Coefficients', 'coefs_right'))
        # Equation degrees linear velocity 2 and angular velocity 2.
        left_solver = PolySpeedSolver(coefs=left_coefs)
        right_solver = PolySpeedSolver(coefs=right_coefs)
        linear = check_value("Enter the linear speed value\n", mode, False)
        angular = check_value("Enter the angular speed value\n", mode, False)
        sp_left = left_solver.solve(linear, angular)
        sp_right = right_solver.solve(linear, angular)
    else:
        sp_left = check_value("Enter value of sp_left between 0 and 255\n",
                              mode, False)
        sp_right = check_value("Enter value of sp_right between 0 and 255\n",
                               mode, False)
    operatingtime = check_value("Enter the time to move in seconds\n",
                                mode, True)
    init_time = time.time()
    logger.info("Sent to UGV ({}, {})".format(sp_left, sp_right))
    while (time.time() - init_time) < operatingtime:
        my_serial.move([sp_right, sp_left])
    # When the desired time passes, the speed is zero
    sp_right = 127
    sp_left = 127
    my_serial.move([sp_right, sp_left])
    logger.info("Sent to UGV ({}, {})".format(sp_left, sp_right))
    logger.info("Shutting down")
    return

def check_value(message, mode, check_time):
    """Check if the value introduced by the user is correct.

    :param str message: message about the value to enter.
    :param str mode: mode of operation.
    :param bool check_time: boolean to check if the value to be corrected is
     time or not.
    :return: correct value
    :rtype: int or float. It depends on the checkup.
    """
    while True:
        value = raw_input(message)
        try:
            if (mode == 'lin_ang' and check_time == False):
                value = float(value)
                return value
            elif (mode == 'setpoints' and check_time == False):
                value = int(value)
                if (value > 255 or value < 0):
                    logger.info("The value is not correct")
                else:
                    return value
            else:
                value = float(value)
                if value < 0:
                    logger.info("The value is not correct")
                else:
                    return value
        except ValueError:
            logger.info("The value is not correct")

if __name__ == '__main__':
    main()
