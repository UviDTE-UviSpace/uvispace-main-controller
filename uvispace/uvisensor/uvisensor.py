#!/usr/bin/env python
import os
import rospy
import roslib
from std_msgs.msg import String
from geometry_msgs.msg import Pose2D
from system_controller import SystemController


class iSpacePublisher():
    def __init__(self, robot_id):
        self.robot_id = robot_id
        self.controller = SystemController()
        self.robots = None
        self.obstacles = None
        rospy.init_node('ispace_sensor')
        self.pub_pose = rospy.Publisher('/robot_{}/pose2d'.format(robot_id),
                                          Pose2D, queue_size=1)       
        self.sensors_controller_init()   
        # calculates the number of robots and obstacles with their positions.            
        while not rospy.is_shutdown():
            self.run()
            rospy.loginfo(self.get_robots_position())        
            x, y, theta  = 0, 0, 0
            for id, robot in self.robots.iteritems():
                x, y, theta = robot[0] / 1000, robot[1] / 1000, robot[2]
                self.pub_pose.publish(pose2D(x,y,theta))
                
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

        self.controller.init_sensors()
        self.controller.start_sensors()
        rospy.loginfo('Started video sensors.')
        
    def sensors_controller_end(self):
        rospy.loginfo('Stopping video sensors...')
        self.controller.stop_sensors()
        self.controller.end_sensors()
        rospy.loginfo('Stopped video sensors.')
        
    def run(self):
        positions = self.system_controller.get_current_positions()
        self.controller.process_trackers()
        # Gets locations of all robots and obstacles
		# For every position, analyses if it is a triangle or a square
		# Finally, it returns a dictionary with each robot ID and position
        self.robots = self.controller.get_robots_position(positions)
        self.obstacles = self.controller.get_obstacles_position(positions)
                        
    def get_robots_position(self):
        reply = '%i %s\n' %(len(self.robots), 
                            ' '.join([id + ' %i %i %f' %robot for id, robot in self.robots.iteritems()]))
        return reply


if __name__ == '__main__':    
    pkg_dir = roslib.packages.get_pkg_dir('ispace_sensor')
    os.chdir(pkg_dir + '/src/')	# changes directory to <package>/src	
    iSpacePublisher()

