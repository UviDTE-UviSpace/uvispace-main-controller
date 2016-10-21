#!/usr/bin/env python
#ROS libraries
import rospy
from geometry_msgs.msg import Twist, Pose2D
#Local libraries
import path_tracker


class MoveBase():
	def __init__(self):
		rospy.init_node('move_base', anonymous=True)

		# The pose is published by the ispace_sensor node
		rospy.Subscriber('/robot_1/pose2d', Pose2D, 
					     self.callback_pose, queue_size=1)
		# The new goals are published by the user
		rospy.Subscriber('/robot_1/goal', Pose2D, 
					     self.callback_goal, queue_size=1)

		self.pub_cmd_vel = rospy.Publisher('/robot/cmd_vel', Twist, 
					                       queue_size=1)
			
		self.init = False
		self.QCTracker = path_tracker.QuadCurveTracker()

		self.twist = Twist()

		rospy.on_shutdown(self.on_shutdown)
		rospy.spin()

	def on_shutdown(self):
		self.twist.linear.x, self.twist.angular.z = 0, 0
		self.pub_cmd_vel.publish(self.twist)
		
	def callback_pose(self, msg):
		if self.init == False:
			self.QCTracker.append_point((msg.x, msg.y))  
			self.init = True
		rospy.loginfo('Location: %.3f, %.3f, %.3f' %(msg.x, msg.y, msg.theta))
		vl, va = self.QCTracker.run(msg.x, msg.y, msg.theta)
		rospy.loginfo('Speeds: %.3f, %.3f' %(vl, va))
		self.twist.linear.x, self.twist.angular.z =  vl, va
		self.pub_cmd_vel.publish(self.twist)

	def callback_goal(self, msg):
		if self.init :
			goal_point = (msg.x, msg.y)
			# Adds the new goal to the current path, calculating all the intermediate
			# points and stacking them to the path array
			self.QCTracker.append_point(goal_point)
			rospy.loginfo('New goal: %.3f, %.3f' %(msg.x, msg.y))
		else :
			rospy.loginfo(' The system is not yet initialized. Waiting for a pose to be published ')


if __name__ == '__main__':
    MoveBase()
    
