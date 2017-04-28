#!/usr/bin/env python 
"""
This module 'listens' to speed SPs and sends them through serial port.

**Usage: messenger.py [-r <robot_id>], [--robotid=<robot_id>]**

To communicate with the external slaves, the data has to be packed using 
a prearranged protocol, in order to be unpacked and understood 
correctly by the slave.

If it is run as main script, it creates an instance of the class 
*SerMesProtocol* for managing the serial port. T

When a new speed SP is received, it is sent to the target UGV using the 
instanced object.

**Speed formatting:**


The *move_robot* function has the default speed limit set to [89-165]. 
These limits are needed when the robot is connected to a DC source with 
a small intensity limit.
If the program is run when the UGV is powered through a USB-B cable, it 
will move slowly, as the limit is too small to be able to move properly.

When the execution ends, the *plotter* module is called and the time 
delays values are plotted on a graph.
"""
# Standard libraries
import glob
import struct
import sys
import getopt
import time
import os
import logging
import zmq

# Local libraries
from serialcomm import SerMesProtocol
from speedtransform import Speed
import plotter


def connect_and_check(robot_id, port=None, baudrate=57600):
    """
    Return an instance of SerMesProtocol and check it is ready.
    
    If no port is specified, take the first one available.
    """
    # This exception prevents a crash when no device is connected to CPU.   
    if not port:
        try:
            port = glob.glob('/dev/ttyUSB*')[0]
        except IndexError:
            print("It was not detected any serial port connected to PC")
            sys.exit()
    # Convert the Python id number to the C format 'unsigned byte'
    serialcomm = SerMesProtocol(port=port, baudrate=baudrate)
    serialcomm.SLAVE_ID = struct.pack('>B', robot_id)
    # Check connection to board. If broken, program exits
    if serialcomm.ready():
        print("The board is ready")
    else:
        print("The board is not ready")
        sys.exit()
    return serialcomm


def listen_speed_directives(my_serial, robot_speed, speed_calc_times,
                            wait_times, xbee_times):
    # Open a  subscribe socket to listen speed directives
    listener = zmq.Context.instance().socket(zmq.SUB)
    listener.setsockopt_string(zmq.SUBSCRIBE, u"")
    # FIXME [floonone-20170428] hardcoded socket connect
    listener.connect("tcp://localhost:35011")

    # listen for speed directives until interrupted
    try:
        while True:
            data = listener.recv_json()
            move_robot(data, my_serial, wait_times, speed_calc_times,
                       xbee_times, robot_speed)
    except KeyboardInterrupt:
        pass
    return


def move_robot(data, my_serial, wait_times, speed_calc_times, xbee_times,
               robot_speed, min_speed=70, max_speed=190):
    """
    Convert speed msg into 2WD value and send it through port.
    """
    global t0
    global t1
    global t2
    t1 = time.time()
    wait_times.append(t1 - t0)
    logging.info('New set point received')
    linear = data['linear']
    angular = data['angular']
    t2 = time.time()
    speed_calc_times.append(t2 - t1)
    robot_speed.set_speed([linear, angular], 'linear_angular')
    # Get the right and left speeds in case of direct movement
    # The coefficients were found empirically
    if robot_speed.get_speed()[0] > 0:
        robot_speed.get_2WD_speeds(wheels_modifiers=[0.53, 1])
    # Get the right and left speeds in case of reverse movement
    else:
        robot_speed.get_2WD_speeds(wheels_modifiers=[1, 1])
    v_right, v_left = robot_speed.nonlinear_transform(min_A=min_speed,
                                                      max_B=max_speed)
    logging.info('I am sending R: {} L: {}'.format(v_right, v_left))
    my_serial.move([v_right, v_left])
    t0 = time.time()
    xbee_times.append(t0 - t2)
    logging.info('Transmission ended succesfully\n\n')


def stop_vehicle(my_serial, wait_times, speed_calc_times, xbee_times,
                 robot_speed):
    """
    Send a null speed to the UGV.
    """
    stop_speed = {
        'linear': 0.0,
        'angular': 0.0
    }
    move_robot(stop_speed, my_serial, wait_times, speed_calc_times, xbee_times,
               robot_speed)


def print_times(wait_times, speed_calc_times, xbee_times):
    """
    Calculate the average time of each part of the process.
    """
    wait_mean_time = sum(wait_times) / len(wait_times)
    speed_calc_mean_time = sum(speed_calc_times) / len(speed_calc_times)
    xbee_mean_time = sum(xbee_times) / len(xbee_times)
    print ('Wait mean time: {wait}\n'
           'Speed calculation mean time: {speed}\n'
           'XBee message sending mean time: {xbee}'
           .format(wait=wait_mean_time, speed=speed_calc_mean_time,
                   xbee=xbee_mean_time))


def main():
    global t0
    # Main routine
    help_msg = 'Usage: messenger.py [-r <robot_id>], [--robotid=<robot_id>]'
    # This try/except clause forces to give the robot_id argument.
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
    wait_times = []
    speed_calc_times = []
    xbee_times = []
    # Create an instance of SerMesProtocol and check connection to port.
    my_serial = connect_and_check(robot_id)
    robot_speed = Speed()
    t0 = time.time()

    listen_speed_directives(my_serial, robot_speed, speed_calc_times,
                            wait_times, xbee_times)

    stop_vehicle(my_serial, wait_times, speed_calc_times,
                 xbee_times, robot_speed)
    print_times(wait_times, speed_calc_times, xbee_times)

    # Print the log output to files and plot it
    script_path = os.path.dirname(os.path.realpath(__file__))
    # A file identifier is generated from the current time value
    file_id = int(time.time())
    with open('{}/tmp/comm{}.log'.format(script_path, file_id), 'a') as f:
        for item in xbee_times:
            print>> f, '{0:.5f}'.format(item)
    with open('{}/tmp/waittimes{}.log'.format(script_path, file_id), 'a') as f:
        for item in wait_times:
            print>> f, '{0:.5f}'.format(item)
    # Plots the robot ideal path.
    plotter.times_plot(xbee_times, wait_times)


if __name__ == '__main__':
    main()
