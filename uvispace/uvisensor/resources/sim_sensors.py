#!/usr/bin/env python
"""
This module simulates the uvisensor package for testing uvirobot.

A robot is simulated to be placed at the coordinate (1,1) with an angle
of 0 radians. The pose is published every 25 milliseconds.
"""
import logging
import time

import numpy
import zmq

import settings


def main():

    logger = logging.getLogger('sensor')

    logger.info("Start")
    publisher = zmq.Context.instance().socket(zmq.PUB)
    # FIXME [floonone-20170503] hardcoded socket bind
    publisher.bind("tcp://*:35001")

    logger.info("Publisher socket bound")
    position = {
        'x': numpy.asscalar(numpy.float32(1.0)),
        'y': numpy.asscalar(numpy.float32(2.4)),
        'theta': numpy.asscalar(numpy.float32(-2.9385785723))
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
