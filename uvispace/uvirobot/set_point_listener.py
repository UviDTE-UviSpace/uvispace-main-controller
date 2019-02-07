#!/usr/bin/env python
"""This module 'listens' to speed SPs and sends them through serial port.

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
import getopt
import glob
import logging
import configparser
import ast
import os
import struct
import sys
import time
# Third party libraries
import zmq
# Local libraries
import plotter
from messenger import ZigBeeMessenger
from messenger import WifiMessenger

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger('messenger')


def connect_and_check(robot_id, port=None, baudrate=57600):
    """Return an instance of SerMesProtocol and check it is ready.

    If no port is specified, take the first one available.
    """
    logger.debug("Checking connection")
    conf = configparser.ConfigParser()
    conf_file = glob.glob("./resources/config/robot{}.cfg".format(robot_id))
    conf.read(conf_file)
    communication_type = conf.get('Communication', 'protocol_type')
    if communication_type == 'wifi':

        TCP_PORT = communication_type = ast.literal_eval(conf.get('Communication', 'port'))
        TCP_IP = communication_type = ast.literal_eval(conf.get('Communication', 'ip'))
        wificomm = WifiMessenger(TCP_IP,TCP_PORT)
        return wificomm

    else:
        # This exception prevents a crash when no device is connected to CPU.
        if not port:
            try:
                port = glob.glob('/dev/ttyUSB*')[0]
            except IndexError:
                logger.info("It was not detected any serial port connected to PC")
                sys.exit()
                # Convert the Python id number to the C format 'unsigned byte'
        serialcomm = ZigBeeMessenger(port=port, baudrate=baudrate)
        serialcomm.SLAVE_ID = struct.pack('>B', robot_id)
        # Check connection to board. If broken, program exits
        if serialcomm.ready():
            logger.info("The board is ready")
        else:
            logger.info("The board is not ready")
            sys.exit()
        return serialcomm


def listen_speed_set_points(com_device, robot_id, speed_calc_times,
                            wait_times, xbee_times, soc_read_interval=5):
    """Listens for new speed set point messages on a subscriber socket."""
    logger.debug("Initializing subscriber socket")
    # Open a subscribe socket to listen speed directives
    speed_subscriber = zmq.Context.instance().socket(zmq.SUB)
    # Set subscribe option to empty so it receives all messages
    speed_subscriber.setsockopt_string(zmq.SUBSCRIBE, u"")
    # Set the conflate option to true so it only keeps the last message received
    speed_subscriber.setsockopt(zmq.CONFLATE, True)
    speed_subscriber.connect("tcp://localhost:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_SPEED"))+robot_id))

    logger.debug("Listening for speed set points")

    #uncomment to print som state-of-charge from the battery
    # while True:
    #     soc=read_battery_soc(com_device)
    #     text_file = open("battery charging SOC.txt", "a")
    #     text_file.write("{}\n".format(soc))
    #     text_file.close()
    #     time.sleep(10)


    # Initialize the time for checking if the soc has to be read.
    soc_time = time.time()
    # listen for speed directives until interrupted
    try:
        while True:
            data = speed_subscriber.recv_json()
            logger.debug("Received new speed set point: {}".format(data))
            move_robot(data, com_device, wait_times, speed_calc_times,
                       xbee_times)
            # Read the battery state-of-charge after regular seconds intervals.
            if (time.time()-soc_time) > soc_read_interval:
                read_battery_soc(com_device)
                soc_time = time.time()
    except KeyboardInterrupt:
        pass
    # Cleanup resources
    speed_subscriber.close()
    return


def move_robot(data, com_device, wait_times, speed_calc_times, xbee_times):
    """Send setpoints through port."""
    global t0
    global t1
    global t2
    t1 = time.time()
    wait_times.append(t1 - t0)
    sp_m1 = data['sp_m1']
    sp_m2 = data['sp_m2']
    t2 = time.time()
    speed_calc_times.append(t2 - t1)
    logger.info('I am sending M1: {} M2: {}'.format(sp_m1, sp_m2))
    com_device.move([sp_m2, sp_m1])
    t0 = time.time()
    xbee_times.append(t0 - t2)
    logger.debug('Transmission ended successfully')
    return


def read_battery_soc(com_device):
    """Send a petition to the slave for returning the battery SOC"""
    raw_soc = com_device.get_soc()
    if raw_soc is None:
        soc = 0
        logger.warn("Unable to get the battery state of charge")
    elif raw_soc == -1:
        soc = 0
        logger.warn("Fuel gauge PCB not detected")
    else:
        # Unpack the state of charge 0-100% (soc):
        # Code for old fel gauge chip (SOC was 2 Byte variable):
        # soc = struct.unpack('>H', raw_soc[1]+raw_soc[3])[0]
        # Code for the new fuel gauge chip (SOC is 1 Byte variable):
        soc = struct.unpack('<B', raw_soc)[0]
        logger.info("The current battery soc is {}%".format(soc))
    return soc

def stop_vehicle(com_device, wait_times, speed_calc_times, xbee_times):
    """Send a null speed to the UGV."""
    stop_speed = {
        'sp_m1': 127,
        'sp_m2': 127,
    }
    move_robot(stop_speed, com_device, wait_times, speed_calc_times, xbee_times)
    return


def print_times(wait_times, speed_calc_times, xbee_times):
    """Calculate the average time of each part of the process."""
    wait_mean_time = sum(wait_times) / len(wait_times)
    speed_calc_mean_time = sum(speed_calc_times) / len(speed_calc_times)
    xbee_mean_time = sum(xbee_times) / len(xbee_times)
    logger.info('Wait mean time: {wait} - '
                'Speed calculation mean time: {speed} - '
                'XBee message sending mean time: {xbee}'
                .format(wait=wait_mean_time, speed=speed_calc_mean_time,
                        xbee=xbee_mean_time))
    return


def main():
    logger.info("BEGINNING EXECUTION")
    global t0
    # Main routine
    help_msg = 'Usage: messenger.py [-r <robot_id>], [--robotid=<robot_id>]'
    # This try/except clause forces to give the robot_id argument.
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hr:", ["robotid="])
    except getopt.GetoptError:
        print(help_msg)
        sys.exit()
    if not opts:
        print(help_msg)
        sys.exit()
    for opt, arg in opts:
        if opt == '-h':
            print(help_msg)
            sys.exit()
        elif opt in ("-r", "--robotid"):
            robot_id = int(arg)
    wait_times = []
    speed_calc_times = []
    xbee_times = []
    # Create an instance of SerMesProtocol and check connection to port.
    com_device = connect_and_check(robot_id)
    t0 = time.time()

    # Infinite loop for parsing setpoint values and sending to the UGV.
    listen_speed_set_points(com_device, robot_id, wait_times, speed_calc_times,
                            xbee_times)
    # Send to the UGV setpoints for making it stop moving.
    stop_vehicle(com_device, wait_times, speed_calc_times, xbee_times)
    # Calculate and print the average execution times
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
