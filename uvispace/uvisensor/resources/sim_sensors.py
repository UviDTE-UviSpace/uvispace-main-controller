#!/usr/bin/env python
"""
This module simulates the uvisensor package for testing uvirobot.

A robot is simulated to be placed at the coordinate (1,1) with an angle
of 0 radians. The pose is published to the topic every 25 milliseconds.
"""
import rospy
from geometry_msgs.msg import Pose2D
import time

rospy.init_node('ispace_sensor')
pub_pose_1 = rospy.Publisher('/robot_1/pose2d', Pose2D, queue_size=1)
x = 1.0
y = 1.0
theta = 0.0
while not rospy.is_shutdown():
    pub_pose_1.publish(Pose2D(x, y, theta))
    time.sleep(0.025)
