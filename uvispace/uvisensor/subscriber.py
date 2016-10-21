#!/usr/bin/env python
import roslib; roslib.load_manifest('ispace_sensor')

import rospy
from std_msgs.msg import String
from geometry_msgs.msg import Pose2D


import gtk
import gobject

import sys
import time

from pylab import *

from capture.plot_capture import PlotCapture 

class ClientWindow():
    def __init__(self, DELAY=0):
        window = gtk.Window()
        window.set_title('iSpace client')
        window.resize(500, 400)
        window.connect("destroy", self.on_window1_destroy)
              
        self.plot_capture = PlotCapture()
        window.add(self.plot_capture)
        
        window.show_all()
        
        self.delay = DELAY
                
        self.frame, self.frame_rate = 0, 0
        self.start_time = time.time()
        
        self.plot_capture.draw_location_area()
        #gobject.idle_add(self.update_locations)
        
        rospy.init_node('subscriber', anonymous=True)
        robot_name = rospy.get_param('~robot', 'robot_1')
        rospy.Subscriber('/%s/pose2d' %robot_name, Pose2D, self.update_locations)
        rospy.spin()
            
    def update_locations(self, data):
        """Updates the location of the targets."""
        time.sleep(self.delay)
        robots = (int(data.x * 1000), int(data.y * 1000), float(data.theta))
        print '%i ROBOTS %s' %(self.frame, robots)
        
        t0 = time.time()
        robots = {1: robots}
        self.plot_capture.draw_positions(robots, {}, self.frame, self.frame_rate)
        t1 = time.time()
        print 'Drawing time: %.5f' %(t1 - t0)
        
        self.frame = self.frame + 1
        self.frame_rate = round(self.frame / (time.time() - self.start_time), 1)
        print 'Frame: %i, FPS=%.1f' %(self.frame, self.frame_rate)
        return True

    def on_window1_destroy(self, widget):
        """Closes the socket communication client."""
        gtk.main_quit()


class iSpaceSubscriber():
    def __init__(self):
        rospy.init_node('subscriber', anonymous=True)
        robot_name = rospy.get_param('~robot', 'robot_1')
        rospy.Subscriber('/%s/pose2d' %robot_name, Pose2D, self.callback_pose)
        rospy.spin()
        
    def callback_pose(self, data):
        rospy.loginfo(">>> %.1f %.1f %.4f", data.x, data.y, data.theta)



if __name__ == '__main__':
    #iSpaceSubscriber()

    ClientWindow()
    gtk.main()
    
