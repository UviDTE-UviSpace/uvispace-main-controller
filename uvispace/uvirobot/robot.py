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
    :param path: array that stores the ideal path for the robot, with N
     goal_points.
    :type path: numpy.array float64 (shape=Nx2).
    :param route: array that stores the P points of the route made by
     the UGV.
    :type route: numpy.array float64 (shape=Px2).
    :param float beta: angle of the line between the UGV and the next
     goal point.
    :param float epsilon: difference between beta angle and UGV angle
     (theta). Angle error to correct.
    :param float prev_epsilon: epsilon angle of the previous iteration.
    :param float delta_epsilon: difference between the epsilon angles of
     the current and previous iteration.
    :param float linear: linear speed of UGV.
    :param float prev_linear: linear speed of UGV in previous iteration.
    :param float angular: angular speed of UGV.
    :param float max_valid_angle: accepted value of angle error to
     consider that there is nomaximo error. The value entered in the method
     call is in degrees, and it is transformed into initialization to
     radians.
    :param float distance: distance between UGV and the next goal point.
    :param float prev_distance: distance between UGV and the next goal
     point in previous iteration.
    :param float max_valid_distance: accepted value of distance between
     UGV and the next goal point to consider that there is no error.

    NOTE: The units used in the script are: For linear speed, mm/s; for
    angular speed, rad/s; for distance mm.
    """
    def __init__(self, robot_id=1, max_valid_angle=10,
                 max_valid_distance=60):
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
        self.path = np.array([None, None]).reshape(1,2)
        self.route = np.array([None, None]).reshape(1,2)
        self.beta = 0
        self.epsilon = 0
        self.prev_epsilon = 0
        self.delta_epsilon = 0
        self.linear = 0
        self.prev_linear = 0
        self.angular = 0
        self.max_valid_angle = max_valid_angle*np.pi / 180
        self.distance = 0
        self.prev_distance = 0
        self.max_valid_distance = max_valid_distance
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
        # Load the config file and read the fuzzy sets (fs) and singleton sets.
        self.conf_raw = ConfigParser.RawConfigParser()
        self.conf_raw.read(self.conf_file)
        self.fs_diff_angle = self.get_set_array('Fuzzy_sets', 'diff_angle')
        self.fs_diff_angle_var = self.get_set_array('Fuzzy_sets',
                                                    'diff_angle_var')
        self.st_ang_spd = self.get_set_array('Singletons', 'ang_spd')
        self.fs_distance = self.get_set_array('Fuzzy_sets', 'distance')
        self.fs_distance_var = self.get_set_array('Fuzzy_sets', 'distance_var')
        self.st_inc_lin_spd = self.get_set_array('Singletons', 'inc_lin_spd',)
        # Instance of the used controller.
        self.controller = pathtracker.FuzzyController()
        # Publishing socket instantiation.
        self.speed_publisher = zmq.Context.instance().socket(zmq.PUB)
        self.speed_publisher.bind("tcp://*:{}".format(
                int(os.environ.get("UVISPACE_BASE_PORT_SPEED"))+robot_id))

    def get_set_array(self, section, item):
        """Read set of a file and store them into array.

        :param str section: name of the section to be read in the configuration
         file.
        :param str item: name of the item to be read in the configuration file.
        :return: set converted into array.
        :rtype: numpy.array float64
        """
        raw_set = self.conf_raw.get(section, item)
        # Format the value in order to get an array.
        tuple_format = ','.join(raw_set.split('\n'))
        array_format = ast.literal_eval(tuple_format)
        set_read = np.array(array_format)
        return set_read

    def set_speed(self, pose):
        """Receive a new pose and obtain a speed value.

        This method calls the 'get_spd_motion' function to calculate the
        speed. After calculating the new speed value, call the
        'get_setpoint' function to transform the speed value into
        setpoints.

        :param pose: contains a 2-D position, with 2 cartesian values
        (x,y) and an angle value (theta).
        :type pose: dict
        """
        # Save linear speed of UGV in previous iteration.
        self.prev_linear = self.linear
        if not self.init:
            self.init = True
            self.linear = 0
            self.angular = 0
        if self.goal_points.all() is not None:
            # There is a goal point.
            current_point = (pose['x'], pose['y'])
            if self.route.all() is None:
                self.route = np.array([current_point]).reshape(1,2)
            else:
                self.route = np.vstack((self.route, current_point))
            next_point = self.goal_points[0, :]
            segment = next_point - current_point
            self.beta = np.arctan2(segment[1], segment[0])
            self.theta = pose['theta']
            self.prev_epsilon = self.epsilon
            # Correct UGV orientation.
            # 'kappa' is an uncorrected epsilon angle.
            kappa = self.beta - self.theta
            self.epsilon = np.where(np.abs(kappa) < np.pi, kappa,
                                    kappa - 2*np.pi*np.sign(kappa))
            # 'rho' is an uncorrected delta_epsilon angle.
            rho = self.epsilon - self.prev_epsilon
            self.delta_epsilon = np.where(np.abs(rho) < np.pi, rho,
                                          rho - 2*np.pi*np.sign(rho))
            # The movement is a rotation.
            turn_motion = True
            self.linear, self.angular = self.get_spd_motion(turn_motion)
            # Save distance between UGV and the next goal point in previous
            # iteration.
            self.prev_distance = self.distance
            # Calculate distance to next goal point.
            self.distance = np.linalg.norm(next_point - current_point)
            self.delta_distance = self.distance - self.prev_distance
            # Check distance to next goal point.
            if self.distance < self.max_valid_distance:
                self.delete_goal()
            # Straight movement if the angle is correct.
            if np.abs(self.epsilon) < self.max_valid_angle:
                # The movement is forward.
                turn_motion = False
                self.linear, self.angular = self.get_spd_motion(turn_motion)
        else:
            self.linear = 0
            self.angular = 0
            logger.info('Waiting for a goal...')
        self.robot_speed.set_speed([self.linear, self.angular],
                                   'linear_angular')
        logger.info('Pose--> X: {:1.4f}, Y: {:1.4f}, theta: {:1.4f} - '
                    'Speeds--> Linear: {:4.2f}, Angular {:4.2f}, Step {}'
                    .format(pose['x'], pose['y'], pose['theta'], self.linear,
                            self.angular, pose['step']))
        sp_left, sp_right = self.get_setpoints(self.linear, self.angular)
        self.publish_message(pose['step'], self.linear, self.angular, sp_left,
                             sp_right)
        return

    def get_spd_motion(self, turn_motion):
        """Calculate of speed of the UGV with fuzzylogic controller.

        :param bool turn_motion: this parameter determines if the
         movement of UGV is only-turn or not.
        :return: linear and angular speed values.
        :rtype: (float, float)
        """
        # Obtain of indexes of sets and degree of membership at the sets
        # acording to rules one and two in calculate of speed.
        if turn_motion:
            set_index1, m_degree1 = self.controller.fuzzyfication(self.epsilon,
                    self.fs_diff_angle)
            set_index2, m_degree2 = self.controller.fuzzyfication(
                    self.delta_epsilon, self.fs_diff_angle_var)
        else:
            set_index1, m_degree1 = self.controller.fuzzyfication(self.distance,
                    self.fs_distance)
            set_index2, m_degree2 = self.controller.fuzzyfication(
                    self.delta_distance, self.fs_distance_var)
        # Union of the results of the two rules.
        set_index_array = np.hstack((set_index1, set_index2))
        m_degree_array = np.hstack((m_degree1, m_degree2))
        # Output from both rules.
        if turn_motion:
            angular = self.controller.defuzzyfication(set_index_array,
                                                      m_degree_array,
                                                      self.st_ang_spd)
            # Minimum angular speed value is 0.7 rad/s.
            if np.abs(angular) < 0.7:
                angular = np.sign(angular)*0.7
            linear = 20
        else:
            inc_linear = self.controller.defuzzyfication(set_index_array,
                                                         m_degree_array,
                                                         self.st_inc_lin_spd)
            linear = self.prev_linear + inc_linear
            # Maximum angular speed value is 250 mm/s.
            if linear > 250:
                linear = 250
            angular = 0
        return (linear, angular)

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
        points are stored in the path array.
        """
        data_array = self.goal_points
        # Array that stores the ideal path for the robot.
        if self.path.all() is None:
            self.path = data_array[0, :]
        else:
            self.path = np.vstack((self.path, data_array[0, :]))
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
