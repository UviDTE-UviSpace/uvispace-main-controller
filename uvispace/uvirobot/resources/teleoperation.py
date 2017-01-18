#!/usr/bin/env python
import termios
import select
import sys
import time
import tty
#ROS libraries
from geometry_msgs.msg import Twist, Pose2D
import rospy
"""
Auxiliary program for controlling the UGV movements through keyboard.
"""

def getKey(settings):
    #Wait until stdin is ready to be read. There is a timeout of 0.1s
    rlist, _, _ = select.select([sys.stdin], [], [], 0.1)
    #Read the stdin input.
    if rlist:
        key = sys.stdin.read(1)
    else:
        key = ''
    #Set the attributes stored in settings after transmitting queued output
    termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
    return key

if __name__=="__main__":
    #Init node and publisher handler.
    rospy.init_node('teleop_keyboard')
    pub_vel = rospy.Publisher('/robot_1/cmd_vel', Twist, queue_size=1)
    speeds = Twist()
    #get stdin settings
    settings = termios.tcgetattr(sys.stdin)
    #Put terminal in raw mode
    tty.setraw(sys.stdin.fileno())
    init_time = time.time()
    print ('Teleoperation program initialized. Available commands:\n\r'
           '* S : Move backwards.\n\r'
           '* W : Move backwards.\n\r'
           '* Z : Stop moving.\n\r'
           '* Q : Stop and quit.\n\r'
          )
#    print ('\n\r'.join(message))
    while True:
        key = getKey(settings)
        #Move forward.
        if key in ('w','W'):
            print 'Moving forward'
            speeds.linear.x = 190
            pub_vel.publish(speeds)
        #Move backwards.
        if key in ('s','S'):
            print 'Moving backwards'
            speeds.linear.x = -300
            pub_vel.publish(speeds)
        #Stop moving.
        if key in ('z','Z'):
            print 'Stopping moving'
            speeds.linear.x = 0
            pub_vel.publish(speeds)
        #Stop moving and exit.
        if key in ('q','Q'):
            print 'Stopping and exiting program'
            speeds.linear.x = 0
            pub_vel.publish(speeds)
            break




