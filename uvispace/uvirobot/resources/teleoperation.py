#!/usr/bin/env python
"""Auxiliary program for controlling the UGV movements through keyboard."""
# Standard libraries
import ast
import ConfigParser
import glob
import os
import termios
import tty
import select
import sys
# Third party libraries
import zmq
# Local libraries
from uvirobot.speedtransform import Speed

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")

def get_key():
    """Return key pressed."""
    # file descriptor (integer that represents an open file).
    fd = sys.stdin.fileno()
    # get stdin settings
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
    # Init publisher
    publisher = zmq.Context.instance().socket(zmq.PUB)
    publisher.bind("tcp://*:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_SPEED"))+1))
    pub_message = {
        'linear': 0.0,
        'angular': 0.0,
        'step': 0,
        'sp_left': 127,
        'sp_right': 127,
    }
    robot_spd = Speed()
    # Read configuration file coefficients.
    conf = ConfigParser.ConfigParser()
    conf_file = glob.glob("./config/robot.cfg")
    conf.read(conf_file)
    coefs_left = ast.literal_eval(conf.get('Coefficients', 'coefs_left'))
    coefs_right = ast.literal_eval(conf.get('Coefficients', 'coefs_right'))
    # Send the coeficients to the polynomial solver objects.
    robot_spd.poly_solver_left.update_coefs(coefs_left)
    robot_spd.poly_solver_right.update_coefs(coefs_right)
    #import pdb; pdb.set_trace()
    # instructions for moving the UGV.
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
    # this initialization is necessary to update the previous state variable
    # key (prev_key) the first time.
    key = ''
    while True:
        # variables key pressed now and key previously pressed
        prev_key = key
        key = get_key()
        # Move forward.
        if key in ('w', 'W'):
            screen_message = 'moving forward'
            pub_message['sp_left'] = robot_spd.poly_solver_left.solve(400, 0)
            pub_message['sp_right'] = robot_spd.poly_solver_right.solve(400, 0)
            publisher.send_json(pub_message)
        # Move backwards.
        elif key in ('s', 'S'):
            screen_message = 'moving backwards'
            pub_message['sp_left'] = robot_spd.poly_solver_left.solve(-200, 0)
            pub_message['sp_right'] = robot_spd.poly_solver_right.solve(-200, 0)
            publisher.send_json(pub_message)
        # Move left.
        elif key in ('a', 'A'):
            screen_message = 'moving left'
            pub_message['sp_left'] = robot_spd.poly_solver_left.solve(200, 0.5)
            pub_message['sp_right'] = robot_spd.poly_solver_right.solve(200, 0.5)
            publisher.send_json(pub_message)
        # Move right.
        elif key in ('d', 'D'):
            screen_message = 'moving right'
            pub_message['sp_left'] = robot_spd.poly_solver_left.solve(200, -0.5)
            pub_message['sp_right'] = robot_spd.poly_solver_right.solve(200, -0.5)
            publisher.send_json(pub_message)
        # Stop moving and exit.
        elif key in ('q', 'Q'):
            print ('Stop and exiting program. Have a good day! =)')
            pub_message['sp_left'] = 127
            pub_message['sp_right'] = 127
            publisher.send_json(pub_message)
            break
        # Stop moving.
        else:
            screen_message = 'stop moving'
            pub_message['sp_left'] = 127
            pub_message['sp_right'] = 127
            publisher.send_json(pub_message)
        # if key pressed now and key pressed previously are different,
        # update message
        if prev_key != key:
            print('Currently %s. \n\r' % screen_message)


if __name__ == '__main__':
    main()
