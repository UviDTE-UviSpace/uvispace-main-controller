#!/usr/bin/env python
"""
This module simulates the uvisensor package for testing uvirobot.

A robot is simulated to be placed at the coordinate (1,1) with an angle
of 0 radians. The pose is published every 25 milliseconds.
"""
import os
import logging.config
import time

import zmq

import settings
logger = logging.getLogger('sensor')


def main():

    logger.info("Start")
    publisher = zmq.Context.instance().socket(zmq.PUB)
    # Send positions for robot 1
    publisher.bind("tcp://*:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_POSITION"))+1))

    logger.info("Publisher socket bound")
    position = {
        'x': 1.0,
        'y': 1.0,
        'theta': 0.0
    }
    try:
        while True:
            publisher.send_json(position)
            logger.info("Sent {}".format(position))
            time.sleep(0.025)
    except KeyboardInterrupt:
        logger.info("End")


if __name__ == '__main__':
    main()
