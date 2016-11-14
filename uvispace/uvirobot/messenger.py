#!/usr/bin/env python 
"""
This module subscribes to speed topic and sends SPs through serial port

If run as main script, it invokes the class SerMesProtocol() to manage 
the serial port. When a new speed value is received, it is send to the 
external UGV using the serial protocol object.

The move_robot function has a default speed limit set to [89-165]. This 
limit is needed when the robot is connected to a DC source with a small 
intensity limit.
If the program is run when the UGV is powered through a USB-B cable, it 
will move slowly, as the limit is too small to be able to move properly.
"""
# Standard libraries
import glob
import struct
import sys
import getopt
import time
import serial
import os
# ROS libraries
import rospy
from geometry_msgs.msg import Twist
# Local libraries
from serialcomm import SerMesProtocol
from speedtransform import Speed
import plotter
    
def connect_and_check(robot_id, port=None, baudrate=57600):
    """Return an instance of SerMesProtocol and check it is ready.
    
    If no port is specified, take the first one available.
    """
    # This exception prevents a crash when no device is connected to CPU.   
    if not port:
        try:
            port = glob.glob('/dev/ttyUSB*')[0]
        except IndexError:
            print 'It was not detected any serial port connected to PC'		
            sys.exit()
    #Converts the Python id number to a C valid number, in unsigned byte
    serialcomm = SerMesProtocol(port=port, baudrate=baudrate)    
    serialcomm.SLAVE_ID = struct.pack('>B', robot_id)
    #Checks connection to board. If broken, program exits
    if serialcomm.ready():
        print "The board is ready"
    else:
        print "The board is not ready"
        sys.exit()
    return serialcomm        
        
def listener(robot_id, robot_speed, serial):
    """Create a node and subscribe to its robot 'cmd_vel' topic.""" 
    try:
        rospy.init_node('robot{}_messenger'.format(robot_id), anonymous=True)
    except rospy.exceptions.ROSException:
        pass
    rospy.Subscriber('/robot_{}/cmd_vel'.format(robot_id), Twist, 
                     move_robot, callback_args=serial,
                     queue_size=1)
    
def move_robot(data, my_serial):
    """Convert Twist msg into 2WD value and send it through port."""
    #Change proposal. In order to accept all the parameterfs
#    my_serial = args[0]
#    robot_speed = args[1]
    global t0
    global t1
    global t2
    t1 = time.time()
    wait_times.append(t1-t0)
    rospy.loginfo('New set point received')
    linear = data.linear.x
    angular = data.angular.z
    t2 = time.time()
    speed_calc_times.append(t2-t1)
    robot_speed.set_speed([linear, angular], 'linear_angular')
    robot_speed.get_2WD_speeds()
    v_RightWheel, v_LeftWheel = robot_speed.nonlinear_transform(min_A=70,
                                                                max_B=190)
    rospy.loginfo('I am sending R: {} L: {}'.format(v_RightWheel, v_LeftWheel))
    my_serial.move([v_RightWheel, v_LeftWheel])
    t0 = time.time()
    xbee_times.append(t0-t2)
    rospy.loginfo('Transmission ended succesfully\n\n')

def stop_request(my_serial):
    """Send a null speed to the UGV."""
    stop_speed = Twist()
    stop_speed.linear.x = 0.0
    stop_speed.angular.z = 0.0
    move_robot(stop_speed, my_serial)


def print_times(wait_times, speed_calc_times, xbee_times):
    """Calculate the average time of each part of the process."""
    wait_mean_time = sum(wait_times) / len(wait_times)
    speed_calc_mean_time = sum(speed_calc_times) / len(speed_calc_times)
    xbee_mean_time = sum(xbee_times) / len(xbee_times)
    print ('Wait mean time: {wait}\n'
           'Speed calculation mean time: {speed}\n'
           'XBee message sending mean time: {xbee}'
           .format(wait=wait_mean_time, speed=speed_calc_mean_time,
                   xbee=xbee_mean_time)
          )
          

if __name__ == "__main__":
    #This exception forces to give the robot_id argument within run command.
    help_msg = 'Usage: messenger.py [-r <robot_id>], [--robotid=<robot_id>]'
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
    t0 = time.time()
    wait_times = []
    speed_calc_times = []
    xbee_times = []
    #Creates an instance of SerMesProtocol and checks connection to port
    my_serial = connect_and_check(robot_id)
    robot_speed = Speed()
    t0 = time.time()
    listener(robot_id, robot_speed, my_serial)  
    #Keeps python from exiting until this node is stopped
    rospy.spin()   
    stop_request(my_serial)
    print_times(wait_times, speed_calc_times, xbee_times)
    
    ###############################################################
    ########## Print the log output to files and plot it ##########
    ###############################################################
    script_path = os.path.dirname(os.path.realpath(__file__))
    #A file identifier is generated from the current time value
    file_id = int(time.time())
    with open('{}/tmp/comm{}.log'.format(script_path, file_id), 'a') as f:
        for item in xbee_times:
            print>>f, '{0:.5f}'.format(item)
    with open('{}/tmp/waittimes{}.log'.format(script_path, 
                                              file_id), 'a') as f:
        for item in wait_times:
            print>>f, '{0:.5f}'.format(item)
    #Plots the robot ideal path.
    plotter.times_plot(xbee_times, wait_times)
    

    


