#!/usr/bin/env python
"""
Auxiliary program for controlling the UGV movements through keyboard.
"""
# Standard libraries
import os
import termios
import tty
import select
import sys
# Third party libraries
import zmq


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
    speeds = {
        'linear': 0.0,
        'angular': 0.0
    }
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
            message = 'moving forward'
            speeds['linear'] = 190
            speeds['angular'] = 0
            publisher.send_json(speeds)
        # Move backwards.
        elif key in ('s', 'S'):
            message = 'moving backwards'
            speeds['linear'] = -300
            speeds['angular'] = 0
            publisher.send_json(speeds)
        # Move left.
        elif key in ('a', 'A'):
            message = 'moving left'
            speeds['linear'] = 0
            speeds['angular'] = 10
            publisher.send_json(speeds)
        # Move right.
        elif key in ('d', 'D'):
            message = 'moving right'
            speeds['linear'] = 0
            speeds['angular'] = -10
            publisher.send_json(speeds)
        # Stop moving and exit.
        elif key in ('q', 'Q'):
            print ('Stop and exiting program. Have a good day! =)')
            speeds['linear'] = 0
            speeds['angular'] = 0
            publisher.send_json(speeds)
            break
        # Stop moving.
        else:
            message = 'stop moving'
            speeds['linear'] = 0
            speeds['angular'] = 0
            publisher.send_json(speeds)
        # if key pressed now and key pressed previously are different,
        # update message
        if prev_key != key:
            print('Currently %s. \n\r' % message)


if __name__ == '__main__':
    main()
