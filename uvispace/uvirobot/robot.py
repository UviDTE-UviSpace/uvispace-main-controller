#!/usr/bin/env python
"""This package communicates with user and sensors and find paths."""
# ROS libraries
import rospy
from geometry_msgs.msg import Twist, Pose2D
# Local libraries
import path_tracker

class RobotController(object):
    """
    This class contains methods needed to control a robot's behavior.
    """
    def __init__(self, robot_id=1, port=None, baudrate=57600):
        self.robot_id = robot_id
        self.init = False
        self.speeds = Twist()
        self.QCTracker = path_tracker.QuadCurveTracker()
        self.pub_vel = rospy.Publisher('/robot_{}/cmd_vel'.format(robot_id),
                                       Twist, queue_size=1)
		
    def new_speed(self, pose):
        """
        Receives a new pose and calculates the UGV speeds.
        
        Parameters
        ----------
        pose : variable of type geometry_msgs.msg.Twist 
            Variable that contains a 3-D position, with 3 cartesian 
            values (x,y,z) and 3 angles(thetaX, thetaY, thetaZ).
        """
        if self.init == False:
            self.QCTracker.append_point((msg.x, msg.y))  
            self.init = True
        rospy.loginfo('Location: {}, {}, {}'.format(msg.x, msg.y, msg.theta))
        linear, angular = self.QCTracker.run(msg.x, msg.y, msg.theta)
        rospy.loginfo('Speeds: {}, {}'.format(vl, va))
        self.speeds.linear.x = linear
        self.speeds.angular.z = angular
        self.pub_vel.publish(self.speeds)

    def new_goal(self, goal):
        """Receives a new goal and calculates the path to reach it."""
        if self.init :
            goal_point = (goal.x, goal.y)
            # Adds the new goal to the current path, calculating all the 
            # intermediate points and stacking them to the path array
            self.QCTracker.append_point(goal_point)
            rospy.loginfo('New goal: %.3f, %.3f' %(goal.x, goal.y))
        else :
            rospy.loginfo(' The system is not yet initialized. \
            Waiting for a pose to be published ')
    
    
    
