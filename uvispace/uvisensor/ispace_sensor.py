#!/usr/bin/env python
import rospy
import roslib
from std_msgs.msg import String
from geometry_msgs.msg import Pose2D

from system_controller import SystemController


class iSpacePublisher():
    def __init__(self):
        rospy.init_node('ispace_sensor')

	# Creates 3 Handles (pub_pose[0..2]) for publishing messages of class Pose2D
	# on the topics /robot_[0..2]/pose2d
        self.pub_pose_0 = rospy.Publisher('/robot_0/pose2d', Pose2D, queue_size=1)
        self.pub_pose_1 = rospy.Publisher('/robot_1/pose2d', Pose2D, queue_size=1)
        self.pub_pose_2 = rospy.Publisher('/robot_2/pose2d', Pose2D, queue_size=1)
        
        self.sensors_controller_init()
        
        while not rospy.is_shutdown():
			# calculates the number of robots and obstacles with their positions.
            self.run()
            rospy.loginfo(self.get_robots_position())        
            #rospy.sleep(1.)
            x, y, theta  = 0, 0, 0
            for id, robot in self.robots.iteritems():
                x, y, theta = robot[0] / 1000, robot[1] / 1000, robot[2]
               
                if id == '0':
                    self.pub_pose_0.publish(Pose2D(x, y, theta))
                    rospy.loginfo('Passing pose to topic /robot_0/pose2d')
                if id == '1':
                    self.pub_pose_1.publish(Pose2D(x, y, theta))
                    rospy.loginfo('Passing pose to topic /robot_1/pose2d')
                if id == '2':
                    self.pub_pose_2.publish(Pose2D(x, y, theta))
                    rospy.loginfo('Passing pose to topic /robot_2/pose2d')
        
        self.sensors_controller_end()
        print 'Closed system.'
    
    def sensors_controller_init(self):
        rospy.loginfo('Starting video sensors...')
        self.system_controller = SystemController()
        self.system_controller.init_sensors()
        self.system_controller.start_sensors()
        rospy.loginfo('Started video sensors.')
        
    def sensors_controller_end(self):
        rospy.loginfo('Stopping video sensors...')
        self.system_controller.stop_sensors()
        self.system_controller.end_sensors()
        rospy.loginfo('Stopped video sensors.')
        
    def run(self):
        positions = self.system_controller.get_current_positions()
        self.system_controller.process_trackers()
        # Gets locations of all robots and obstacles
		# For every position, analyses if it is a triangle or a square
		# Finally, it returns a dictionary with each robot ID and position
        self.robots = self.system_controller.get_robots_position(positions)
        self.obstacles = self.system_controller.get_obstacles_position(positions)
            
    def get_image_gray(self):
        return self.system_controller.image_gray
                        
    def get_robots_position(self):
        robots = self.robots
        reply = '%i %s\n' %(len(robots), ' '.join([id + ' %i %i %f' %robot for id, robot in robots.iteritems()]))
        return reply
        


if __name__ == '__main__':    
#    import os
#    print os.getcwd()
#    pkg_dir = roslib.packages.get_pkg_dir('ispace_sensor')
#    os.chdir(pkg_dir + '/src/')	# changes directory to <package>/src	
#    print os.getcwd()		# prints current directory

    iSpacePublisher()

