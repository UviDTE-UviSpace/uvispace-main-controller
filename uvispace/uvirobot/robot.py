#!/usr/bin/env python
"""This module communicates with user and sensors for finding paths.

It contains a class, *RobotController*, that represents a real UGV, and 
contains ROS functionality for publishing new speed values, UGVs 
attributes, such as the *robot_id*, its speed values, or an instance 
of the *PathTracker*, for calculating and storing the robot navigation 
values.
"""
# Standard libraries
import logging
import zmq

# Local libraries
import path_tracker


class RobotController(object):
    """
    This class contains methods needed to control a robot's behavior.

    :param int robot_id: Identifier of the robot
    """

    def __init__(self, robot_id=1):
        """Class constructor method"""
        self.robot_id = robot_id
        self.init = False
        self.speeds = {
            'linear': 0.0,
            'angular': 0.0
        }
        self.QCTracker = path_tracker.QuadCurveTracker()

        pub_vel = zmq.Context.instance().socket(zmq.PUB)
        # FIXME [floonone-20170428] hardcoded socket bind
        pub_vel.bind("tcp://*:35011")
        self.pub_vel = pub_vel

    def set_speed(self, pose):
        """
        Receives a new pose and calculates the UGV speeds.

        After calculating the new speed value, the dictionary containing 
        the new speed values is published via the pub_vel socket.
        Only the values X, Y and theta of the *Pose2D* type are used, as 
        the designed Space consists in a 2-D flat space.

        :param pose: contains a 2-D position, with 2 cartesian values (x,y)
         and an angle value (theta).
        """
        if not self.init:
            self.QCTracker.append_point((pose['x'], pose['y']))
            self.init = True
        linear, angular = self.QCTracker.run(
                pose['x'], pose['y'], pose['theta'])
        logging.info('\nLocation--> '
                     'X: {}, Y: {}, theta: {} \n'
                     'Speeds--> Linear: {}, Angular {}'.format(
                            pose['x'], pose['y'], pose['theta'],
                            linear, angular))
        self.speeds['linear'] = linear
        self.speeds['angular'] = angular
        self.pub_vel.send_json(self.speeds)

    def new_goal(self, goal):
        """
        Receives a new goal and calculates the path to reach it.

        :param goal: contains a 2-D position, with 2 cartesian values (x,y)
         and an angle value (theta).
        """
        if self.init:
            goal_point = (goal['x'], goal['y'])
            # Adds the new goal to the current path, calculating all the 
            # intermediate points and stacking them to the path array
            self.QCTracker.append_point(goal_point)
            logging.info('New goal--> X: {}, Y: {}'.format(
                    goal['x'], goal['y']))
        else:
            logging.info(' The system is not yet initialized. '
                         'Waiting for a pose to be published ')

    def on_shutdown(self):
        """
        Shutdown method. Is called when execution is aborted.
        """
        self.speeds['linear'] = 0.0
        self.speeds['angular'] = 0.0
        self.pub_vel.send_json(self.speeds)
