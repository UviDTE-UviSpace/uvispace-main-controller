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
        self.pub_cmd_vel = rospy.Publisher('/robot/cmd_vel', Twist, 
					                       queue_size=1)
		
	def new_pose(self, msg):
		if self.init == False:
			self.QCTracker.append_point((msg.x, msg.y))  
			self.init = True
		rospy.loginfo('Location: %.3f, %.3f, %.3f' %(msg.x, msg.y, msg.theta))
		vl, va = self.QCTracker.run(msg.x, msg.y, msg.theta)
		rospy.loginfo('Speeds: %.3f, %.3f' %(vl, va))
		self.twist.linear.x, self.twist.angular.z =  vl, va
		self.pub_cmd_vel.publish(self.twist)

	def new_goal(self, msg):
		if self.init :
			goal_point = (msg.x, msg.y)
			# Adds the new goal to the current path, calculating all the 
			# intermediate points and stacking them to the path array
			self.QCTracker.append_point(goal_point)
			rospy.loginfo('New goal: %.3f, %.3f' %(msg.x, msg.y))
		else :
			rospy.loginfo(' The system is not yet initialized. \
			Waiting for a pose to be published ')
    
    
    
