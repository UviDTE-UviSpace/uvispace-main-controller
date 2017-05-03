#!/usr/bin/env python
""" 
Routine for getting UGV poses and publishing to speed topic

The module instantiates a RobotController object and uses its methods
for publishing new speed set points.

When calling the module, one argument must be passed, representing the 
id of the desired robot. It must be the same as the one passed to the
messenger.py module.
"""
# Standard libraries
import sys
import os
import getopt
import numpy as np
import time
import zmq

# Local libraries
from robot import RobotController
import plotter


def make_a_rectangle(my_robot):
    """Set the robot path to a rectangle of fixed vertices."""
    point_a = {'x': 1.0, 'y': 1.0}
    point_b = {'x': -1.0, 'y': 1.0}
    point_c = {'x': -1.0, 'y': -1.0}
    point_d = {'x': 1.0, 'y': -1.0}
    point_e = {'x': 1.0, 'y': 0.0}
    my_robot.new_goal(point_a)
    my_robot.new_goal(point_b)
    my_robot.new_goal(point_c)
    my_robot.new_goal(point_d)
    my_robot.new_goal(point_e)


def init_sockets():
    # Open a subscribe socket to listen for position data
    pos_sock = zmq.Context.instance().socket(zmq.SUB)
    pos_sock.setsockopt_string(zmq.SUBSCRIBE, u"")
    pos_sock.setsockopt(zmq.CONFLATE, True)
    # FIXME [floonone-20170503] hardcoded socket connect
    pos_sock.connect("tcp://localhost:35001")

    # Open a subscribe socket to listen for new goals
    goa_sock = zmq.Context.instance().socket(zmq.SUB)
    goa_sock.setsockopt_string(zmq.SUBSCRIBE, u"")
    pos_sock.setsockopt(zmq.CONFLATE, True)
    # FIXME [floonone-20170503] hardcoded socket connect
    goa_sock.connect("tcp://localhost:35021")

    sockets = {
        'position': pos_sock,
        'goal': goa_sock
    }
    return sockets


def listen(sockets, my_robot):
    # Initialize poll set
    poller = zmq.Poller()
    poller.register(sockets['position'], zmq.POLLIN)
    poller.register(sockets['goal'], zmq.POLLIN)

    # listen for position information and new goal points
    try:
        while True:
            socks = dict(poller.poll())
            if sockets['position'] in socks \
                    and socks[sockets['position']] == zmq.POLLIN:
                position = sockets['position'].recv_json()
                print(position)
                my_robot.set_speed(position)

            if sockets['goal'] in socks \
                    and socks[sockets['goal']] == zmq.POLLIN:
                goal = sockets['goal'].recv_json()
                my_robot.new_goal(goal)

            time.sleep(0.5)

    except KeyboardInterrupt:
        my_robot.on_shutdown()
    return


def main():
    # This exception forces to give the robot_id argument within run command.
    rectangle_path = False
    help_msg = ('Usage: controller.py [-r <robot_id>], [--robotid=<robot_id>], '
                '[--rectangle]')
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hr:", ["robotid=",
                                                         "rectangle"])
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
        if opt in ("-r", "--robotid"):
            robot_id = int(arg)
        if opt == "--rectangle":
            rectangle_path = True
    # Calls the main function
    my_robot = RobotController(robot_id)

    # Open listening sockets
    sockets = init_sockets()

    # Until the first pose is not published, the robot instance
    # is not initialized.
    while not my_robot.init:
        position = sockets['position'].recv_json()
        my_robot.set_speed(position)

    # This function sends 4 rectangle points to the robot path.
    if rectangle_path:
        make_a_rectangle(my_robot)

    # Listen sockets
    listen(sockets, my_robot)

    # Print the log output to files and plot it
    script_path = os.path.dirname(os.path.realpath(__file__))
    # A file identifier is generated from the current time value
    file_id = time.strftime('%Y%m%d_%H%M')
    with open('{}/tmp/path_{}.log'.format(script_path, file_id), 'a') as f:
        np.savetxt(f, my_robot.QCTracker.route, fmt='%.2f')
    # Plots the robot ideal path.
    plotter.path_plot(my_robot.QCTracker.path, my_robot.QCTracker.route)


if __name__ == '__main__':
    main()
