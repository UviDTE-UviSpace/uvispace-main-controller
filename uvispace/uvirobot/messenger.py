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
# ROS libraries
import rospy
from geometry_msgs.msg import Twist
# Local libraries
from serialcomm import SerMesProtocol
from speedtransform import Speed
    
def connect_and_check(robot_id, port=None, baudrate=57600):
    """Returns an instance of SerMesProtocol and checks it is ready.
    
    If no port is specified, the function takes the first available.
    """
    # This exception prevents a crash when no device is connected to CPU.   
    if not port:
        try:
            port = glob.glob('/dev/ttyUSB*')[0]
        except IndexError:
            print 'It was not detected any serial port connected to PC'		
            sys.exit()
    # Converts the Python id number to a C valid number, in unsigned byte
    serialcomm = SerMesProtocol(port=port, baudrate=baudrate)    
    serialcomm.SLAVE_ID = struct.pack('>B', robot_id)
    # Checks connection to board. If broken, program exits
    if serialcomm.ready():
        print "The board is ready"
    else:
        print "The board is not ready"
        sys.exit()
    return serialcomm        
        
def listener(robot_id, robot_speed, serial):
    """Creates a node and subscribes to its robot 'cmd_vel' topic.""" 
    try:
        rospy.init_node('robot{}_messenger'.format(robot_id), anonymous=True)
    except rospy.exceptions.ROSException:
        pass
    rospy.Subscriber('/robot_{}/cmd_vel'.format(robot_id), Twist, 
                     move_robot, callback_args=serial,
                     queue_size=1)    
                     
def messenger_shutdown():
    """When messenger is shutdown, robot speeds must be set to 0."""
    stop_speed = Twist()
    stop_speed.linear.x = 0.0
    stop_speed.angular.z = 0.0
    move_robot(stop_speed, my_serial)
    
def move_robot(data, serial):
    """Converts Twist msg into 2WD value and send it through port."""
    #Change proposal. In order to accept all the parameterfs
#    serial = args[0]
#    robot_speed = args[1]
    linear = data.linear.x
    angular = data.angular.z
    robot_speed.set_speed([linear, angular], 'linear_angular')
    robot_speed.get_2WD_speeds()
    v_RightWheel, v_LeftWheel = robot_speed.nonlinear_transform()
    rospy.loginfo('I am sending R: {} L: {}'.format(v_RightWheel, v_LeftWheel))
    serial.move([v_RightWheel, v_LeftWheel])


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
    #Creates an instance of SerMesProtocol and checks connection to port
    my_serial = connect_and_check(robot_id)
    robot_speed = Speed()
    listener(robot_id, robot_speed, my_serial)
    rospy.on_shutdown(messenger_shutdown)    
    #Keeps python from exiting until this node is stopped
    rospy.spin()   


