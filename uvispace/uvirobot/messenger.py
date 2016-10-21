#!/usr/bin/env python 
"""
This module subscribes to speed topic and sends SPs through serial port

If run as main script, it invokes the class SerMesProtocol() to manage 
the serial port. When a new speed value is received, it is send to the 
external UGV using the serial protocol object.

The move_robot function has a speed limit set to [89-165]. This limit is
needed when the robot is connected to a DC source with a small intensity
limit.
If the program is run when the UGV is powered through a USB-B cable, it 
will not be able to move, as the limit is too small to be able to move.
"""
# Standard libraries
import glob
import struct
import sys
import getopt
# Math libraries
import numpy as np
# ROS libraries
import rospy
from geometry_msgs.msg import Twist
# Local libraries
from serialcomm import SerMesProtocol
    
def connect_and_check(robot_id, port=None, baudrate=57600):
    """Returns an instance of SerMesProtocol and checks it is ready."""
    # This exception prevents a crash when no device is connected to CPU.
    # If no port is specified, the function looks for the first available. 
    if not port:
        try:
            port = glob.glob('/dev/ttyUSB*')[0]
        except IndexError:
            print 'It was not detected any serial port connected to PC'		
            sys.exit()
    # Converts the Python id number to a C valid number, in unsigned byte
    serialcomm = SerMesProtocol(port=port, baudrate=baudrate)    
    serialcomm.SLAVE_ID = struct.pack( '>B',robot_id)
    # Checks connection to board. If broken, program exits
    if serialcomm.ready():
        print "The board is ready"
        listener(robot_id)
    else:
        print "The board is not ready"
        sys.exit()
    return serialcomm        
        
def listener(robot_id):
    """Creates a node and subscribes to its robot 'cmd_vel' topic.""" 
    rospy.init_node('robot{}_messenger'.format(robot_id), anonymous=True)
    rospy.Subscriber('/robot_{}/cmd_vel'.format(robot_id), Twist, 
                     move_robot, queue_size=1)        
    
def move_robot(data, rho=0.065, L=0.150):
    """Converts Twist msg into 2WD value and send it through port."""
    v_RightWheel, v_LeftWheel = get_2WD_speeds(data.linear.x, data.angular.z)
    rospy.loginfo('I am sending R: {} L: {}'.format(v_RightWheel,
                                                      v_LeftWheel) )
    my_serial.move([v_RightWheel, v_LeftWheel])
            
def get_2WD_speeds(vLinear, vRotation, minInput=-0.3, maxInput=0.3, 
                    minOutput=89, maxOutput=165, rho=0.065, L=0.150):
    """
    Obtains two speeds components, one for each side of the vehicle. It
    calculates the resulting value according to the output required 
    scale. This calculus responds to the dynamics system proposed on the 
    paper: http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5674957

    Parameters
    ----------
    vLinear : int or float
        desired linear speed of the vehicle.

    vRotation : int or float
        desired rotatory speed of the vehicle.

    minInput : int or float
        input value for reverse linear direction at max speed.

    maxInput : int or float
        input value for direct linear direction at max speed.

    minOutput : int or float
        output value for minimum set point sent to the vehicle.

    maxOutput : int or float
        output value for maximum set point sent to the vehicle. 

    rho : float 
        Parameter of the dynamic model, which represents the vehicle's 
        wheels diameter, in meters.

    L : float
        Parameter of the dynamic model, which represents the distance 
        between the driving wheels of the vehicle.

    Returns
    -------
    v_R : 0 to 255 int
        output value for the right wheel.
        0 corresponds to max speed at reverse direction.
        255 corresponds to max speed at direct direction.
        127 corresponds to null speed.

    v_L : 0 to 255 int
        output value for the left wheel.
    """
    # Conversion of the linear speed range to the wheels angular speed.
    maxAngular = maxInput / rho
    minAngular = minInput / rho
    # Both terms are previosly calculated to reduce redundant operations.
    term1 = (1 / rho ) * vLinear
    term2 = (2 * rho * vRotation) / L
    # Calculates non-scaled raw values of the speeds.
    vR_raw = term1 + term2
    vL_raw = term1 - term2
    # Clips and scales the speed values to minOutput and maxOutput.
    v_clipped = np.clip([vR_raw, vL_raw], minAngular, maxAngular)
    v_num = (v_clipped - minAngular) * (maxOutput - minOutput)
    v_den = (maxAngular - minAngular)
    import pdb; pdb.set_trace()
    v_scaled = minOutput + v_num // v_den
    v_R, v_L = v_scaled.astype(int)
    return v_R, v_L   
     
    
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
    # Creates an instance of SerMesProtocol and checks connection to port
    my_serial = connect_and_check(robot_id)
    # Keeps python from exiting until this node is stopped
    rospy.spin()   
    
    git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch uvispace/path_tracker.py' \
--prune-empty --tag-name-filter cat -- --all
    
    
    
        
