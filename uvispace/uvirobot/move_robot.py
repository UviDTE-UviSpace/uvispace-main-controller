#!/usr/bin/env python
# Standard libraries
import sys
import os
import getopt
import numpy as np
import time
#ROS libraries
import rospy
from geometry_msgs.msg import Twist, Pose2D
#Local libraries
from robot import RobotController
import plotter
""" 
This module gets info from pose2d topic and publishes to speed topic

The module instantiates a RobotController object and uses its methods
for publishing new speed set points in the topic '/robot_{}/cmd_vel'.

When calling the module, one argument must be passed, representing the 
id of the desired robot. It must be the same as the one passed to the
messenger.py module.
"""

def new_node(my_robot, robot_id):
    """Subscribe to topics and spins until aborted."""   
    rospy.init_node('move_robot_{}'.format(robot_id), anonymous=True)
    # The pose is published by the uvispace package
    rospy.Subscriber('/robot_{}/pose2d'.format(robot_id), Pose2D, 
			         my_robot.set_speed, queue_size=1)    
    # The new goals are published by the user
    rospy.Subscriber('/robot_{}/goal'.format(robot_id), Pose2D, 
			         my_robot.new_goal, queue_size=1)
    rospy.on_shutdown(my_robot.on_shutdown)
    
def make_a_rectangle():
    """Set the robot path to a rectangle of fixed vertices."""
    pointA = Pose2D(x=1.0, y=0.5)
    pointB = Pose2D(x=-1.0, y=0.5)
    pointC = Pose2D(x=-1.0, y=-0.5)
    pointD = Pose2D(x=1.0, y=-0.5)
    pointE = Pose2D(x=1.0, y=0.0)
    my_robot.new_goal(pointA)
    my_robot.new_goal(pointB)
    my_robot.new_goal(pointC)
    my_robot.new_goal(pointD)
    my_robot.new_goal(pointE)    
    
if __name__ == "__main__":
    #This exception forces to give the robot_id argument within run command.
    #import pdb; pdb.set_trace()
    help_msg = 'Usage: move_robot.py [-r <robot_id>], [--robotid=<robot_id>]'
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hr:", ["robotid="])
    except getopt.GetoptError:
        print help_msg
        sys.exit()
    if not opts:
        print help_msg
        sys.exit()
    for opt, arg in opts:
        if opt == '-h':
            print help_msg
            sys.exit()
        elif opt in ("-r", "--robotid"):
            robot_id = int(arg)
    # Calls the main function  
    my_robot = RobotController(robot_id)      
    new_node(my_robot, robot_id)
    #Until the first pose is not published, the robot instance 
    #is not initialized.
    while not my_robot.init:
        pass
    #This function sends 4 rectangle points to the robot path.
    make_a_rectangle()
    rospy.spin()
    
    ###############################################################
    ########## Print the log output to files and plot it ##########
    ###############################################################
    script_path = os.path.dirname(os.path.realpath(__file__))
    #A file identifier is generated from the current time value
    file_id = int(time.time())
    with open('{}/tmp/path{}.log'.format(script_path, file_id), 'a') as f:
        np.savetxt(f, my_robot.QCTracker.route, fmt='%.2f')
    #Plots the robot ideal path.
    plotter.path_plot(my_robot.QCTracker.path, my_robot.QCTracker.route)
    

