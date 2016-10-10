#!/usr/bin/env python
"""Package intended communicate with UGVs and calculate paths."""
# ROS libraries
import rospy
from geometry_msgs.msg import Twist, Pose2D


class RobotController(object):
    """
    This class contains methods needed to control a robot's behavior.
    """
    def __init__(self, robot_id=1, port=None, baudrate=57600):
        self.robot_id = robot_id
        self.port = port
        self.baudrate = baudrate
        self.init = False
        self.serial = None
        self.comm_is_ready = False   
        rospy.init_node('robot{}_controller'.format(robot_id),    
                        anonymous=True)      
    
    def subscribe_to_navigation_topic(self):
        """ Subscribes the node to a pose topic """
        rospy.Subscriber('/robot_{}/pose2d'.format(self.robot_id), Pose2D, 
					     self.new_pose, queue_size=1)
    
    def subscribe_to_goal_topic(self):
        """ Subscribes the node to a goal topic """  
 		rospy.Subscriber('/robot_{}/goal'.format(self.robot_id), Pose2D, 
					     self.new_goal, queue_size=1)   
					     
    def publish_to_speeds_topic(self):					     
					     
    
    
    
