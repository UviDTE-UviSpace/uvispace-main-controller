#!/usr/bin/env python
"""This package communicates with user and sensors for finding paths."""
# ROS libraries
import rospy
from geometry_msgs.msg import Twist, Pose2D
# Local libraries
import path_tracker

class RobotController(object):
    """
    This class contains methods needed to control a robot's behavior.
    """
    def __init__(self, robot_id=1):
        self.robot_id = robot_id
        self.init = False
        self.speeds = Twist()
        self.QCTracker = path_tracker.QuadCurveTracker()
        self.pub_vel = rospy.Publisher('/robot_{}/cmd_vel'.format(robot_id),
                                       Twist, queue_size=1)
		
    def set_speed(self, pose):
        """
        Receives a new pose and calculates the UGV speeds.
        
        Only the values x, y and theta are used, as the designed iSpace
        consists of a 2-D flat space.
        
        Parameters
        ----------
        pose : variable of type geometry_msgs.Pose2D 
            Variable that contains a 2-D position, with 2 cartesian 
            values (x,y) and an angle value (theta).
        """
        if self.init == False:
            self.QCTracker.append_point((pose.x, pose.y))  
            self.init = True
        linear, angular = self.QCTracker.run(pose.x, pose.y, pose.theta)
        rospy.loginfo('\nLocation--> '
               'X: {pose.x}, Y: {pose.y}, theta: {pose.theta} \n'
               'Speeds--> Linear: {linear}, Angular {angular}'.format(
               pose=pose, linear=linear, angular=angular))
        self.speeds.linear.x = linear
        self.speeds.angular.z = angular
        self.pub_vel.publish(self.speeds)

    def new_goal(self, goal):
        """
        Receives a new goal and calculates the path to reach it.
        
        Parameters
        ----------
        goal : variable of type geometry_msgs.Pose2D 
            Variable that contains a 2-D position, with 2 cartesian 
            values (x,y) and an angle value (theta).
        """
        if self.init :
            goal_point = (goal.x, goal.y)
            # Adds the new goal to the current path, calculating all the 
            # intermediate points and stacking them to the path array
            self.QCTracker.append_point(goal_point)
            rospy.loginfo('New goal--> X: {}, Y: {}'.format(goal.x, goal.y))
        else :
            rospy.loginfo(' The system is not yet initialized. \
            Waiting for a pose to be published ')
            
    def on_shutdown(self):
        """ Shutdown method. Is called when execution is aborted."""
        self.speeds.linear.x = 0.0
        self.speeds.angular.z = 0.0
        self.pub_vel.publish(self.speeds)       



