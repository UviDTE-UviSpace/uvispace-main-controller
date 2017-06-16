#!/usr/bin/env python
"""This module simulates the uvisensor package for testing uvirobot.

A robot is simulated to be placed at pose introduced by the user. The pose is
published every 25 milliseconds.
"""
# Standard libraries
import getopt
import logging.config
import os
import sys
import time
# Third party libraries
import zmq

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger('sensor')


def main():
    logger.info("Start")
    ## Get arguments
    # Main routine
    help_msg = """Usage: sim_sensors.py [-x <pose_x>], [--pose_x=<pose_x>],
               [-y <pose_y>], [--pose_y=<pose_y>], [-theta <pose_theta>],
               [--pose_theta=<pose_theta>]"""
    # This try/except clause forces to give the robot_id argument.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hx:y:t:", ["pose_x=",
                                   "pose_y", "pose_theta="])
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
        elif opt in ("-x", "--pose_x"):
            pose_x = float(arg)
        elif opt in ("-y", "--pose_y"):
            pose_y = float(arg)
        elif opt in ("-t", "--pose_theta"):
            pose_theta = float(arg)
    publisher = zmq.Context.instance().socket(zmq.PUB)
    # Send positions for robot 1
    publisher.bind("tcp://*:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_POSITION"))+1))
    step = 0
    logger.info("Publisher socket bound")
    position = {
        'x': pose_x,
        'y': pose_y,
        'theta': pose_theta,
        'step': step
    }
    try:
        while True:
            step += 1
            position['step'] = step
            publisher.send_json(position)
            logger.info("Sent {}".format(position))
            time.sleep(0.025)
    except KeyboardInterrupt:
        publisher.close()
        logger.info("End")


if __name__ == '__main__':
    main()
