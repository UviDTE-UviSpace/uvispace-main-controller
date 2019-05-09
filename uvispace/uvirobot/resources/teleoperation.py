#!/usr/bin/env python
"""
Auxiliary program for controlling the UGV movements through keyboard.

The module makes a reading of the keyboard, and sends the movement
chosen by the user.

For the correct operation of the module, it is necessary that the
keyboard delay in the operating system is less than 250 ms.
"""
# Standard libraries
import ast
import configparser
import getopt
import glob
import logging
import os
import select
import signal
import sys
import termios
import tty
# Third party libraries
import zmq

import sys
from os.path import realpath, dirname

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

from uvispace.uvirobot.common import UgvType
from uvispace.uvinavigator.controllers.point_to_point.fuzzy_controller.speed_transform import Speed

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("robot")


def get_key():
    """Return key pressed."""
    # File descriptor (integer that represents an open file).
    fd = sys.stdin.fileno()
    # Get stdin settings
    settings = termios.tcgetattr(fd)
    # Put terminal in raw mode
    tty.setraw(fd)
    # Wait until stdin is ready to be read. There is a timeout of 0.25s.
    # This time depends on the keyboard delay in the operating system.
    rlist, _, _ = select.select([sys.stdin], [], [], 0.25)
    # Read the stdin input.
    if rlist:
        key = sys.stdin.read(1)
    else:
        key = ''
    # Set the attributes stored in settings after transmitting queued output.
    termios.tcsetattr(fd, termios.TCSADRAIN, settings)
    return key

def main():
    # SIGINT handling:
    # -Create a global flag to check if the execution should keep running.
    # -Whenever SIGINT is received, set the global flag to False.
    global run_program
    run_program = True

    def sigint_handler(signal, frame):
        global run_program
        run_program = False
        return
    signal.signal(signal.SIGINT, sigint_handler)
    # This exception forces to give the robot_id argument within run command.
    help_msg = ('Usage: teleoperation.py [-r <robot_id>],'
                '[--robotid=<robot_id>]')
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hr:", ["robotid="])
    except getopt.GetoptError:
        print(help_msg)
        sys.exit()
    if not opts:
        print(help_msg)
        sys.exit()
    for opt, arg in opts:
        if opt == '-h':
            print(help_msg)
            sys.exit()
        if opt in ("-r", "--robotid"):
            robot_id = int(arg)

    # Read speed socket from uvispace configuration
    configuration = configparser.ConfigParser()
    conf_file = "uvispace/config.cfg"
    configuration.read(conf_file)
    speed_base_port = int(configuration["ZMQ_Sockets"]["speed_base"])

    # Read UGV type (each UGV has different behaviour for M1 and M2)
    ugv_configuration = configparser.ConfigParser()
    ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(robot_id)
    ugv_configuration.read(ugv_conf_file)
    ugv_type = ugv_configuration.get('Robot_chassis', 'ugv_type')

    # Create a speed transformer that linearizes the behaviour of differential
    # UGVs
    speed = Speed()
    coefs_left = ast.literal_eval(ugv_configuration.get('Coefficients_fwd', 'coefs_left'))
    coefs_right = ast.literal_eval(ugv_configuration.get('Coefficients_fwd', 'coefs_right'))
    speed.left_fwd_solver.update_coefs(coefs_left)
    speed.right_fwd_solver.update_coefs(coefs_right)

    # Init publisher and send 127 to each wheel (stop UGV)
    speed_publisher = zmq.Context.instance().socket(zmq.PUB)
    speed_publisher.bind("tcp://*:{}".format(int(speed_base_port)))
    speed_message = {
        'm1': 127,
        'm2': 127,
    }

    # Instructions for moving the UGV.
    print ('\n\r'
           'Teleoperation program initialized. Available commands:\n\r'
           '* S : Move backwards.\n\r'
           '* W : Move forward.\n\r'
           '* A : Move left. \n\r'
           '* D : Move right. \n\r'
           '* Q : Stop and quit.\n\r'
           '* Nothing or another key : Stop moving.\n\r'
           '\n\r'
           'Currently stop moving \n\r'
           )
    # This initialization is necessary to update the previous state variable
    # key (prev_key) the first time.
    key = ''
    while True:
        # Variables key pressed now and key previously pressed.
        prev_key = key
        key = get_key()
        if ugv_type == UgvType.lego_42039:

            # Move forward.
            if key in ('w', 'W'):
                screen_message = 'moving forward'
                speed_message['m1'] = 255
                speed_message['m2'] = 127
                speed_publisher.send_json(speed_message)
            # Move backwards.
            elif key in ('s', 'S'):
                screen_message = 'moving backwards'
                speed_message['m1'] = 0
                speed_message['m2'] = 127
                speed_publisher.send_json(speed_message)
            # Move left.
            elif key in ('a', 'A'):
                screen_message = 'moving left'
                speed_message['m1'] = 230
                speed_message['m2'] = 0
                speed_publisher.send_json(speed_message)
            # Move right.
            elif key in ('d', 'D'):
                screen_message = 'moving right'
                speed_message['m1'] = 230
                speed_message['m2'] = 255
                speed_publisher.send_json(speed_message)
            # Stop moving and exit.
            elif key in ('q', 'Q'):
                print ('Stop and exiting program. Have a good day! =)')
                speed_message['m1'] = 127
                speed_message['m2'] = 127
                speed_publisher.send_json(speed_message)
                break
            # Stop moving.
            else:
                screen_message = 'stop moving'
                speed_message['m1'] = 127
                speed_message['m2'] = 127
                speed_publisher.send_json(speed_message)
            # If key pressed now and key pressed previously are different,
            # update message.
            if prev_key != key:
                print('Currently %s. \n\r' % screen_message)
        elif ugv_type == UgvType.df_robot_baron4:

            # Move forward.
            if key in ('w', 'W'):
                screen_message = 'moving forward'
                speed_message['m1'] = int(speed.right_fwd_solver.solve(200, 0))
                speed_message['m2'] = int(speed.left_fwd_solver.solve(200, 0))
                speed_publisher.send_json(speed_message)
            # Move backwards.
            elif key in ('s', 'S'):
                screen_message = 'moving backwards'
                speed_message['m1'] = int(speed.right_fwd_solver.solve(-200, 0))
                speed_message['m2'] = int(speed.left_fwd_solver.solve(-200, 0))
                speed_publisher.send_json(speed_message)
            # Move left.
            elif key in ('a', 'A'):
                screen_message = 'moving left'
                speed_message['m1'] = int(speed.right_fwd_solver.solve(200, 1))
                speed_message['m2'] = int(speed.left_fwd_solver.solve(200, 1))
                speed_publisher.send_json(speed_message)
            # Move right.
            elif key in ('d', 'D'):
                screen_message = 'moving right'
                speed_message['m1'] = int(speed.right_fwd_solver.solve(200, -1))
                speed_message['m2'] = int(speed.left_fwd_solver.solve(200, -1))
                speed_publisher.send_json(speed_message)
            # Stop moving and exit.
            elif key in ('q', 'Q'):
                print ('Stop and exiting program. Have a good day! =)')
                speed_message['m1'] = int(speed.right_fwd_solver.solve(0, 0))
                speed_message['m2'] = int(speed.left_fwd_solver.solve(0, 0))
                speed_publisher.send_json(speed_message)
                break
            # Stop moving.
            else:
                screen_message = 'stop moving'
                speed_message['m1'] = int(speed.right_fwd_solver.solve(0, 0))
                speed_message['m2'] = int(speed.left_fwd_solver.solve(0, 0))
                speed_publisher.send_json(speed_message)
            # If key pressed now and key pressed previously are different,
            # update message.
            if prev_key != key:
                print('Currently %s. \n\r' % screen_message)
        else:
            print("Unrecognized UGV type: {}.".format(ugv_type))

    # Cleanup resources before end.
    speed_publisher.close()
    return

if __name__ == '__main__':
    main()
