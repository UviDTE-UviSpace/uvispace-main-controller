#!/usr/bin/env python
"""This module communicates with user and sensors for finding paths.

It contains a class, *RobotController*, that represents a real UGV, and
contains functionality for publishing new speed values, UGVs
attributes such as the *robot_id* or its speed values. It imports
*pathtracker*, for calculating the robot navigation values.
"""
# Standard libraries
import ast
import ConfigParser
import glob
import logging
import os
import sys
# Third party libraries
import numpy as np
import zmq
# Local libraries
import pathtracker
from speedtransform import Speed

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("navigator")


class RobotController(object):
    """This class contains methods needed to control a robot's behavior.

    :param int robot_id: identifier of the robot.
    :param bool init: indicates if the instance has been initialized or
     not.
    :param dict speed_status: dictionary with iteration values of the
     kalman filter, linear and angular speeds, and UGV setpoints.
    :param goal_points: array that stores the following M goal points
     for the UGV.
    :type goal_points: numpy.array float64 (shape=Mx2).
    :param ideal_path: array that stores the desired path for the
     robot, with N goal_points.
    :type ideal_path: numpy.array float64 (shape=Nx2).
    :param real_path: array that stores the P points of the real_path
     made by the UGV.
    :type real_path: numpy.array float64 (shape=Px2).
    :param float epsilon: difference between angle beta and UGV angle
     (theta). Angle error to correct. (See 'control_decision' function)
    :param float delta_epsilon: difference between the epsilon angles of
     the current and previous iteration.
    :param float allowed_orientation_error: accepted value of angle
     error to consider that there is no error. The value entered in the
     method call is in degrees, and it is transformed into
     initialization to radians.
    :param float distance: distance between UGV and the next goal point.
    :param float delta_distance: difference between the distances of
     the current and previous iteration.
    :param float max_clear_goal_distance: accepted value of distance
     between UGV and the next goal point to consider that there is no
     error.

    NOTE: The units used in the script are: For linear speed, mm/s; for
    angular speed, rad/s; for distance mm.
    """
    def __init__(self, robot_id=1, allowed_orientation_error=8,
                 max_clear_goal_distance=25):
        """Class constructor method"""
        self.robot_id = robot_id
        self.init = False
        self.speed_status = {
            'step': 0,
            'linear': 0.0,
            'angular': 0.0,
            'sp_left': 127,
            'sp_right': 127,
        }
        # Path and vehicle distances and angles.
        self.goal_points = np.array([None, None]).reshape(1,2)
        self.ideal_path = np.array([None, None]).reshape(1,2)
        self.real_path = np.array([None, None]).reshape(1,2)
        self.epsilon = 0
        self.delta_epsilon = 0
        self.allowed_orientation_error = (allowed_orientation_error *
                                         np.pi / 180)
        self.distance = 0
        self.delta_distance = 0
        self.max_clear_goal_distance = max_clear_goal_distance
        # Load the config file and read the polynomial coeficients.
        self.conf = ConfigParser.ConfigParser()
        self.conf_file = glob.glob("./resources/config/robot{}.cfg"
                                   .format(self.robot_id))
        self.conf.read(self.conf_file)
        # Coefficients for a forward movement.
        self._left_fwd_coefs = ast.literal_eval(self.conf.get(
                'Coefficients_fwd', 'coefs_left'))
        self._right_fwd_coefs = ast.literal_eval(self.conf.get(
                'Coefficients_fwd', 'coefs_right'))
        # Coefficients for an in-place turn movement (without linear shift).
        self._left_turn_coefs = ast.literal_eval(self.conf.get(
                'Coefficients_turn', 'coefs_left'))
        self._right_turn_coefs = ast.literal_eval(self.conf.get(
                'Coefficients_turn', 'coefs_right'))
        # Send the coeficients to the polynomial solver objects.
        self.robot_speed = Speed()
        self.robot_speed.left_fwd_solver.update_coefs(self._left_fwd_coefs)
        self.robot_speed.right_fwd_solver.update_coefs(self._right_fwd_coefs)
        self.robot_speed.left_turn_solver.update_coefs(self._left_turn_coefs)
        self.robot_speed.right_turn_solver.update_coefs(self._right_turn_coefs)
        # Instance of the used controller.
        self.onlyturn_controller = pathtracker.FuzzyController(
                'fuzzysets_onlyturn')
        self.forward_controller = pathtracker.FuzzyController(
                'fuzzysets_forward')
        # Publishing socket instantiation.
        self.speed_publisher = zmq.Context.instance().socket(zmq.PUB)
        self.speed_publisher.bind("tcp://*:{}".format(
                int(os.environ.get("UVISPACE_BASE_PORT_SPEED"))+robot_id))

    def control_decision(self, pose):
        """Receive a new pose and obtain a speed value.

        This method calls the 'get_speed_forward' or the
        'get_speed_onlyturn' function to calculate the speed. After
        calculating the new speed value, call the 'get_setpoints'
        function to transform the speed value into setpoints.

        :param pose: contains a 2-D position, with 2 cartesian values
        (x,y) and an angle value (theta).
        :type pose: dict
        """
        if not self.init:
            self.init = True
            linear = 0
            angular = 0
        if self.goal_points.all() is not None:
            # There is a goal point.
            current_point = (pose['x'], pose['y'])
            if self.real_path.all() is None:
                self.real_path = np.array([current_point]).reshape(1,2)
            else:
                self.real_path = np.vstack((self.real_path, current_point))
            # The next point is the first point of the goal_points.
            next_point = self.goal_points[0, :]
            # Save distance between UGV and the next goal point in
            # previous iteration.
            prev_distance = self.distance
            # Calculate distance to next goal point.
            self.distance = np.linalg.norm(next_point - current_point)
            # Check distance to next goal point.
            if self.distance < self.max_clear_goal_distance:
                self.delete_goal()
                linear = 0
                angular = 0
            else:
                segment = next_point - current_point
                # Angle of the line between the UGV and the next goal
                # point.
                beta = np.arctan2(segment[1], segment[0])
                # Save angle epsilon in previous iteration.
                prev_epsilon = self.epsilon
                # Correct UGV orientation.
                # 'kappa' is an uncorrected epsilon angle.
                kappa = beta - pose['theta']
                self.epsilon = np.where(np.abs(kappa) < np.pi, kappa,
                                        kappa - 2*np.pi*np.sign(kappa))
                # Straight movement if the angle is correct.
                if np.abs(self.epsilon) < self.allowed_orientation_error:
                    # The movement is forward.
                    self.delta_distance = self.distance - prev_distance
                    linear = self.forward_controller.get_speed(self.distance,
                            self.delta_distance)
                    if np.abs(linear) < 110:
                        linear = 110
                    angular = 0
                else:
                    # 'rho' is an uncorrected delta_epsilon angle.
                    rho = self.epsilon - prev_epsilon
                    self.delta_epsilon = np.where(np.abs(rho) < np.pi, rho,
                                                  rho - 2*np.pi*np.sign(rho))
                    # The movement is a rotation.
                    angular = self.onlyturn_controller.get_speed(self.epsilon,
                            self.delta_epsilon)
                    # Minimum angular speed value is 0.7 rad/s.
                    if np.abs(angular) < 0.7:
                        angular = np.sign(angular)*0.7
                    linear = 30
        else:
            linear = 0
            angular = 0
            logger.info('Waiting for a goal...')
        self.robot_speed.set_speed([linear, angular], 'linear_angular')
        logger.info('Pose--> X: {:1.4f}, Y: {:1.4f}, theta: {:1.4f} - '
                    'Speeds--> Linear: {:4.2f}, Angular {:4.2f}, Step {}'
                    .format(pose['x'], pose['y'], pose['theta'], linear,
                            angular, pose['step']))
        sp_left, sp_right = self.get_setpoints(linear, angular)
        self.publish_message(pose['step'], linear, angular, sp_left, sp_right)
        return

    def get_setpoints(self, linear, angular):
        """Receive speed value and transform it into setpoints.

        :param float linear: linear speed value.
        :param float angular: angular speed value.
        :return: setpoints values.
        :rtype: (int, int)
        """
        # Get the right and left speeds in case of direct movement
        if linear > 60:
            sp_left = self.robot_speed.left_fwd_solver.solve(linear, angular)
            sp_right = self.robot_speed.right_fwd_solver.solve(linear, angular)
        else:
            sp_left = self.robot_speed.left_turn_solver.solve(linear, angular)
            sp_right = self.robot_speed.right_turn_solver.solve(linear, angular)
        return (sp_left, sp_right)

    def publish_message(self, step, linear, angular, sp_left, sp_right):
        """Receives speeds and setpoints and publish them.

        :param int step: kalman filter iterator counter.
        :param float linear: linear speed value.
        :param float angular: angular speed value.
        :param int sp_left: setpoint left value.
        :param int sp_right: setpoint right value.
        """
        self.speed_status['step'] = step
        self.speed_status['linear'] = linear
        self.speed_status['angular'] = angular
        self.speed_status['sp_left'] = sp_left
        self.speed_status['sp_right'] = sp_right
        self.speed_publisher.send_json(self.speed_status)
        return

    def new_goal(self, goal):
        """Receives a new goal and stores it in goal points array.

        :param goal: contains a 2-D position, with 2 cartesian values
        (x,y) and an angle value (theta).
        :type goal: dict
        """
        if self.init:
            goal_point = (goal['x'], goal['y'])
            # Adds the new goal to goal points array.
            if self.goal_points.all() == None:
                self.goal_points = np.array([goal_point]).reshape(1,2)
            else:
                self.goal_points = np.vstack([self.goal_points, goal_point])
            logger.info('New goal--> X: {}, Y: {}'.format(goal['x'], goal['y']))
        else:
            logger.info('The system is not yet initialized, '
                        'waiting for a pose to be published.')
        return

    def delete_goal(self):
        """Delete the current goal point of the array.

        The current goal point is in the first row of the array. It is
        deleted when the destination is reached. The goal destination
        points are stored in the ideal_path array.
        """
        data_array = self.goal_points
        # Array that stores the desired path for the robot.
        if self.ideal_path.all() is None:
            self.ideal_path = data_array[0, :]
        else:
            self.ideal_path = np.vstack((self.ideal_path, data_array[0, :]))
        if data_array.shape[0] == 1:
            # If the data matrix only contain one data.
            data_array = np.array([None, None]).reshape(1,2)
        else:
            data_array = data_array[1:, :]
        self.goal_points = data_array
        return

    def on_shutdown(self):
        """Shutdown method, called when execution is aborted."""
        logger.info('Shutting down')
        sp_left, sp_right = self.get_setpoints(0, 0)
        self.publish_message(self.speed_status['step']+1, 0, 0, sp_left,
                             sp_right)
        # Cleanup resources
        self.speed_publisher.close()
        return
