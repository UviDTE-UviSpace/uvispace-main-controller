#!/usr/bin/env python
"""
This is the iSpace Video Sensor server, that implements the iSpace communication
protocol for the multi-camera video sensor location system.
"""

import sys
import math
import time
import socket
import threading
import logging

from pylab import *

from system_controller import SystemControllerThread
            
            
disconnect = False

BUFFER_SIZE = 2048

class iSpaceClientServer(threading.Thread):
    def __init__(self, connection, address, sensors_controller):
        threading.Thread.__init__(self)
        self.thread_id = self.getName()
        # TCP/IP 
        self.connection = connection
        self.IP = address[0]
        # Sensors and queues creation for each thread
        self.sensors_controller = sensors_controller
        sensors_controller.add_shared_resources(self.thread_id)
        # List of active robots
        self.active_robots = []
        self.running = True
    
    def stop(self):
        self.running = False
    
    def run(self):
        global disconnect
        logging.info('Opening connection from %s...' %self.IP)
        while self.running:
            request = self.connection.recv(BUFFER_SIZE).split('\n')[0]
            if request:
                command = request[0]
                if command == 'i': # Command of initialization
                    logging.debug('Initialization of system')
                    self.get_image_packages()
                elif command == 'a': # Command of robots position
                    logging.debug('Position of all robots')
                    self.get_robots_position()
                elif command == 'o': # Command of obstacles position
                    logging.debug('Position of all obstacles')
                    self.get_obstacles_position()
                elif command == 'c': # Command of robots activation
                    logging.debug('Activation of robots')
                    self.set_active_robots(request)
                elif command == 'd': # Command of robots deactivation
                    logging.debug('Deactivation of robots')
                    self.del_active_robots(request)
                elif command == 'r': # Command of active robots position
                    logging.debug('Position of active robots')
                    self.get_active_robots_position()
                elif command == 'x': # Command of disconnection
                    logging.debug('Closing connection...')
                    self.stop()
                elif command == 'q': # Command of disconnect
                    logging.debug('Leaving the system...')
                    disconnect = True
                    self.stop()
                    # Forces a new connection request to stop the server
                    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                    sock.connect(('127.0.0.1', 5055))
                    sock.send('\n')
                else:
                    logging.debug('The command is wrong')
                    self.connection.send('The command is wrong\n')
        self.sensors_controller.del_shared_resources(self.thread_id)
        self.connection.close()
        logging.info('Closed connection from %s.' %self.IP)
    
    def get_packages(self, image_data):
        """Gets data packages to send image."""
        # Image split in packages
        img_str = image_data.tostring()
        packages = []
        N = int(math.ceil(float(len(img_str)) / BUFFER_SIZE))
        for n in range(N):
            i = n * BUFFER_SIZE
            f = (n + 1) * BUFFER_SIZE
            packages.append(img_str[i:f])
        return packages
    
    def get_image_packages(self):
        image_gray = self.sensors_controller.get_image_gray()
        self.connection.send('%i %i\n' %(image_gray.shape[0], image_gray.shape[1]))
        for package in self.get_packages(image_gray):
            self.connection.send(package)
        
    def get_robots_position(self):
        robots = self.sensors_controller.get_robots_positions(self.thread_id)
        reply = '%i %s\n' %(len(robots), ' '.join([id + ' %i %i %f' %robot for id, robot in robots.iteritems()]))
        logging.debug(reply)
        self.connection.send(reply)
        
    def get_obstacles_position(self):
        obstacles = self.sensors_controller.get_obstacles_positions(self.thread_id)
        reply = '%i %s\n' %(len(obstacles), ' '.join(['%i %i %i' %obstacle for obstacle in obstacles.itervalues()]))
        logging.debug(reply)
        self.connection.send(reply)
        
    def set_active_robots(self, request):
        ids = request.split(' ')[2:]
        for id in ids:
            if id not in self.active_robots:
                self.active_robots.append(id)
        reply = request + '\n'
        logging.debug(reply)
        self.connection.send(reply)
    
    def del_active_robots(self, request):
        ids = request.split(' ')[2:]
        for id in ids:
            if id in self.active_robots:
                self.active_robots.remove(id)
        reply = request + '\n'
        logging.debug(reply)
        self.connection.send(reply)
        
    def get_active_robots_position(self):
        robots = self.sensors_controller.get_robots_positions(self.thread_id)
        active_robots = []
        for id in self.active_robots:
            if id in robots.iterkeys():
                active_robots.append(id)
        reply = '%i %s\n' %(len(active_robots), ' '.join([id + ' %i %i %f' %(robots[id]) for id in active_robots]))
        logging.debug(reply)
        self.connection.send(reply)


class iSpaceServer():
    def __init__(self):
        self.sensors_controller_init()
                                
        # Set up the server
        IP, PORT = '', 5055
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # Create socket
        server.bind((IP, PORT)) # Create bind to address
        server.listen(5)
        logging.info('Starting TCP server in PORT %s...' %PORT)
        logging.info('Waiting connection...')
        
        # Have the server serve "forever"
        threads_list = []
        while not disconnect:
            connection, address = server.accept() # Accept connection
            logging.info('Establishing connection from %s...' %address[0])
            logging.info('Waiting command...')
            reader = iSpaceClientServer(connection, address, self.sensors_controller)
            threads_list.append(reader)
            reader.start()
        
        for thrd in threads_list:
            thrd.stop()
            thrd.join()
        
        self.sensors_controller_end()
        logging.info('Closed system.')
    
    def sensors_controller_init(self):
        logging.info('Starting video sensors...')
        self.sensors_controller = SystemControllerThread()
        self.sensors_controller.system_controller.init_sensors()
        self.sensors_controller.system_controller.start_sensors()
        self.sensors_controller.start()
        logging.info('Started video sensors.')
        
    def sensors_controller_end(self):
        logging.info('Stopping video sensors...')
        self.sensors_controller.system_controller.stop_sensors()
        self.sensors_controller.system_controller.end_sensors()
        self.sensors_controller.stop()
        logging.info('Stopped video sensors.')
        


logging.basicConfig(level=logging.DEBUG, #logging.INFO, 
                    format='[%(levelname)s] (%(threadName)-10s) %(message)s', )        

if __name__ == '__main__':
    iSpaceServer()
    
