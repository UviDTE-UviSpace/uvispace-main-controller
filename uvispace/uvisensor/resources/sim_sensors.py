#!/usr/bin/env python
import rospy
import roslib
from std_msgs.msg import String
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
