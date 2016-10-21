#!/usr/bin/env python

import gtk
import gobject

import sys
import time
import socket
import logging

BUFFER_SIZE = 2048

from pylab import *

from plot_capture import PlotCapture
  
class Client():
    def __init__(self, IP, PORT):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.IP, self.PORT = IP, PORT
        
    def connect(self):
        self.sock.connect((self.IP, self.PORT))
        logging.info('Started iSpace client from %s.' %self.IP)
        
    def disconnect(self):
        self.sock.send('q\n')
        self.sock.close()
        logging.info('Closed iSpace client from %s.' %(self.IP))
        
    def get_data(self, command):
        self.sock.send(command)
        return self.sock.recv(BUFFER_SIZE).strip()
        
    def get_image(self, size):
        data_bytes = 0
        packages = []
        t0 = time.time()
        while True:
            data = self.sock.recv(BUFFER_SIZE)
            data_bytes += len(data)
            packages.append(data)
            if data_bytes >= size:
                break
        t1 = time.time()
        data = ''.join(packages)
        data_bytes = len(data)
        logging.info('Received %s data_bytes in %i packages' %(data_bytes, len(packages)))
        if t1 > t0:
            rate = data_bytes / (t1 - t0) * 8 / 1000
            logging.info('Received in %.3f s at %.1f kbps.' %((t1 - t0), rate))
        return data

    def get_initial_image(self):
        self.sock.send('i\n')
        height, width = [int(val) for val in self.sock.recv(BUFFER_SIZE).strip().split(' ')]
        img_data = fromstring(self.get_image(size=(width * height)), dtype=uint8) 
        return img_data.reshape(height, width)
        
    def get_robots_position(self):
        return self.get_data('a\n')
    
    def get_obstacles_position(self):
        return self.get_data('o\n')



class ClientWindow():
    def __init__(self, IP, PORT, DELAY=0):
        window = gtk.Window()
        window.set_title('iSpace client')
        window.resize(500, 400)
        window.connect("destroy", self.on_window1_destroy)
              
        self.plot_capture = PlotCapture()
        window.add(self.plot_capture)
        
        window.show_all()
        
        self.delay = DELAY
        
        self.client = Client(IP, PORT)
        self.client.connect()
        image_gray = self.client.get_initial_image()
        self.plot_capture.draw_captured_image(image_gray, gray=True)
        
        time.sleep(5)
        
        self.frame, self.frame_rate = 0, 0
        self.start_time = time.time()
        
        self.plot_capture.draw_location_area()
        gobject.idle_add(self.update_locations)
    
    def parse_robots_positions(self, positions):
        positions_list = positions.split(' ')
        positions = {}
        for i in range(int(positions_list[0])):
            j = i * 4 + 1
            positions[positions_list[j]] = (int(positions_list[j+1]),
                                            int(positions_list[j+2]),
                                            float(positions_list[j+3]))
        return positions
    
    def parse_obstacles_positions(self, positions):
        positions_list = positions.split(' ')
        positions = {}
        for i in range(int(positions_list[0])):
            j = i * 3 + 1
            positions[str(i)] = (int(positions_list[j]),
                                 int(positions_list[j+1]),
                                 int(positions_list[j+2]))
        return positions
            
    def update_locations(self):
        """Updates the location of the targets."""
        time.sleep(self.delay)
        robots = self.client.get_robots_position()
        obstacles = self.client.get_obstacles_position()
        logging.debug('%i ROBOTS %s' %(self.frame, robots))
        logging.debug('%i OBSTACLES %s' %(self.frame, obstacles))
        
        t0 = time.time()
        robots = self.parse_robots_positions(robots)
        obstacles = self.parse_obstacles_positions(obstacles)
        self.plot_capture.draw_positions(robots, obstacles, 
                                         self.frame, self.frame_rate)
        t1 = time.time()
        logging.debug('Drawing time: %.5f' %(t1 - t0))
        
        self.frame = self.frame + 1
        self.frame_rate = round(self.frame / (time.time() - self.start_time), 1)
        logging.debug('Frame: %i, FPS=%.1f' %(self.frame, self.frame_rate))
        return True

    def on_window1_destroy(self, widget):
        """Closes the socket communication client."""
        self.client.disconnect()
        gtk.main_quit()
     
        
        
logging.basicConfig(level=logging.DEBUG, 
                    format='[%(levelname)s] (%(threadName)-10s) %(message)s', ) 
        
if __name__ == '__main__':
    
    if len(sys.argv) == 3:
        IP = sys.argv[1]
        PORT = int(sys.argv[2])
    else:
        IP = '127.0.0.1'
        #IP = '172.19.5.106'
        PORT = 5055
    
    ClientWindow(IP, PORT, DELAY=0
    
    )
    gtk.main()
    
