#!/usr/bin/env python
"""
This is the principal module of video sensor in the PC side, which is a software 
abstraction layer of the video sensor hardware.
"""

import time
import socket
import logging
import ConfigParser

from pylab import * 
from PIL import Image

from sensor import calibrate, transform, processing, pimage

  
class Client:
    """The socket client class handles TCP connection with the video sensor."""
    
    def __init__(self, IP, PORT, BUFFER_SIZE):
        """Creates the socket object."""
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # self.sock.settimeout(3)
        self.IP, self.PORT = IP, PORT
        self.BUFFER_SIZE = BUFFER_SIZE
        self.connected = False
        self.connect()
        
    def connect(self):
        """Creates the socket connection and reads the welcome menu."""
        if self.connected == False:
            try:
                self.sock.connect((self.IP, self.PORT))
                logging.info('Starting TCP client...')
                logging.info('Connected with IP: %s and PORT: %s.' %(self.IP, self.PORT))
                self.read() # Reads the welcome message
                self.connected = True
            except:
                self.connected = False
        
    def disconnect(self):
        """Disconnects and closes communication through the socket connection."""
        if self.connected == True:
            self.write('Q\n')
            logging.info('Closing TCP client...')
            self.sock.close()
            self.connected = False
        
    def read(self):
        """Reads the socket buffer."""
        return self.sock.recv(self.BUFFER_SIZE).strip()
        
    def write(self, data):
        """Writes the socket buffer."""
        self.sock.send(data)
        
    def read_data(self, size):
        """Reads a size number of data bytes from the socket buffer."""
        bytes = 0
        packages = []
        t0 = time.time()
        while True:
            data = self.sock.recv(self.BUFFER_SIZE)
            bytes += len(data)
            packages.append(data)
            print 'Received %i bytes of %i (%.2f%%)\r' %(bytes, size, float(bytes) / size * 100),
            if bytes >= size:
                break
        t1 = time.time()    
        data = ''.join(packages)
        rate = bytes / (t1 - t0) * 8 / 1000
        print "\nReceived in %.3f s at %.1f kbps" %((t1 - t0), rate) 
        return data
        
    def write_command(self, data):
        """Writes a command value in the socket buffer and sends it."""
        self.write('%s\n' %data)
        return self.read()
    
    def read_register(self, reg):
        """Reads a register value."""
        try:
            self.write('r,%s\n' %reg)
            result = self.read()
            return eval(result)
        except:
            return {}

    def write_register(self, reg, value):
        """Writes a register value."""
        self.write('w,%s,%s\n' %(reg, value))
        return self.read()
        

class Camera():
    """This class is a logical wrapper of the camera hardware module, that 
    allows to set the camera sensor settings: image size ('is'), start of
    image ('si'), sensor size ('ss'), sensor mode ('sm') which is the 
    configuration values of skip column and row and image exposure ('ie') 
    which is the value of image exposure time.
    """
    
    def __init__(self):
        """Initializes the camera configuration values."""
        self.load_camera_configuration()
        self.image = None
        self.image_gray = None
        # Size of image sensor
        self.WIDTH = 2592
        self.HEIGHT = 1944
        # Distortion correction
        self.kx = 0.035
        self.ky = 0.035
    
    def read_camera_registers(self):
        """Reads values of camera registers."""
        width, height = self.read_register('is') # image size
        self.width, self.height = 2 * width, 2 * height
        self.exposure = self.read_register('ie') # image exposure
        self.start_column, self.start_row = self.read_register('si') # start image
        self.start_column = self.start_column - 15
        self.start_row = self.start_row - 53
        self.column_size, self.row_size = self.read_register('ss') # sensor size
        self.column_mode, self.row_mode = self.read_register('sm') # sensor mode
        self.skip = self.row_mode # skip mode
        
    def write_camera_registers(self):
        """Writes values of camera registers."""
        print self.write_register('is', '%i,%i' %(self.width / 2, self.height / 2))
        print self.write_register('ie', '%i' %(self.exposure))
        print self.write_register('si', '%i,%i' %(self.start_column + 15, self.start_row + 53))
        print self.write_register('ss', '%i,%i' %(self.column_size, self.row_size))
        print self.write_register('sm', '%i,%i' %(self.column_mode, self.row_mode))
        print self.write_register('so', '%i' %(self.output))
    
    def load_camera_configuration(self, config=None):
        """Loads the camera configuration file."""
        if config:
            self.width = 2 * config.getint('Camera', 'width')
            self.height = 2 * config.getint('Camera', 'height')
            self.start_column = config.getint('Camera', 'start_column')
            self.start_row = config.getint('Camera', 'start_row')
            self.column_size = config.getint('Camera', 'column_size')
            self.row_size = config.getint('Camera', 'row_size')
            self.column_mode = config.getint('Camera', 'column_mode')
            self.row_mode = config.getint('Camera', 'row_mode')
            self.skip = self.row_mode
            self.exposure = config.getint('Camera', 'exposure')
            self.output = 0 # image output
    
    def save_camera_configuration(self, config=None):
        """Saves the camera configuration file."""
        if config:
            config.add_section('Camera')
            config.set('Camera', 'width', str(self.width / 2))
            config.set('Camera', 'height', str(self.height / 2))
            config.set('Camera', 'start_column', str(self.start_column))
            config.set('Camera', 'start_row', str(self.start_row))
            config.set('Camera', 'column_size', str(self.column_size))
            config.set('Camera', 'row_size', str(self.row_size))
            config.set('Camera', 'column_mode', str(self.column_mode))
            config.set('Camera', 'row_mode', str(self.row_mode))
            config.set('Camera', 'exposure', str(self.exposure))
    
    def configure_skip_mode(self):
        """Configures the camera skip zoom mode."""
        self.row_size = (self.height * (self.skip + 1)) - 1
        self.column_size = (self.width * (self.skip + 1)) - 1
        self.row_mode = self.skip
        self.column_mode = self.skip
        
    def configure_active_image(self):
        """Configures the active image on the camera sensor."""
        if (self.start_column + self.column_size) > self.WIDTH - 1:
            if self.column_size > self.WIDTH - 1:
                self.column_size = self.WIDTH - 1
                self.width = self.WIDTH /  (self.skip + 1)
            else:
                self.start_column = self.WIDTH - self.column_size - 1
        if (self.start_row + self.row_size) > self.HEIGHT - 1:
            if self.row_size > self.HEIGHT - 1: 
                self.row_size = self.HEIGHT - 1
                self.height = self.HEIGHT / (self.skip + 1)
            else:
                self.start_row = self.HEIGHT - self.row_size - 1
        if self.start_column < 0:
            self.start_column = 0
        if self.start_row < 0:
            self.start_row = 0
            
    def configure_camera(self):
        """Write the camera register values and configures the device."""
        self.write_camera_registers()
        self.write_command('C')
    
    def select_output(self, index):
        """Selects the output image."""
        self.output = index
    
    def select_vga_output(self):
        """Selects or deselects the vga output."""
        print self.write_command('V')
    
    def get_current_frame(self, gray=False):
        """Gets current frame stored in SDRAM memory."""
        if gray:
            self.write('G\n')
            data = self.read_data(self.width * self.height / 4)
            image = fromstring(data, dtype=uint8).reshape(self.height / 2, self.width / 2)
            self.image_gray = image
        else:
            self.write('D\n')
            data = self.read_data(3 * self.width * self.height / 4)
            image = fromstring(data, dtype=uint8).reshape(self.height / 2, self.width / 2, 3)
            image = calibrate.image_correct_distortion(image, self.kx, self.ky)
            self.image = image
        return image
    
    def get_new_frame(self, gray=False):
        """Gets a new frame image."""
        print self.write_command('S') # Captures a new image
        return self.get_current_frame(gray)


class Sensor():
    """This class is a logical wrapper of the sensor hardware module."""
    
    def __init__(self):
        """Initializes the sensor configuration values."""
        self.load_sensor_configuration()
        self.trackers = {}
        
#-------------------------------------------------------------------------------
        
    def read_sensor_registers(self):
        """Reads values of sensor registers."""
        self.red_thresholds = self.read_register('rt') # red thresholds
        self.green_thresholds = self.read_register('gt') # green threshold
        self.blue_thresholds = self.read_register('bt') # blue threshold
        
    def write_sensor_registers(self):
        """Writes values of sensor registers."""
        print self.write_register('rt', '%i,%i' %self.red_thresholds)
        print self.write_register('gt', '%i,%i' %self.green_thresholds)
        print self.write_register('bt', '%i,%i' %self.blue_thresholds)
    
    def load_sensor_configuration(self, config=None):
        """Loads the sensor configuration file."""
        if config:
            self.red_thresholds = eval(config.get('Sensor', 'red_thresholds'))
            self.green_thresholds = eval(config.get('Sensor', 'green_thresholds'))
            self.blue_thresholds = eval(config.get('Sensor', 'blue_thresholds')) 
        
    def save_sensor_configuration(self, config=None):
        """Saves the sensor configuration file."""
        if config:
            config.add_section('Sensor')
            config.set('Sensor', 'red_thresholds', str(self.red_thresholds))
            config.set('Sensor', 'green_thresholds', str(self.green_thresholds))
            config.set('Sensor', 'blue_thresholds', str(self.blue_thresholds))
                
    def configure_sensor(self):
        """Write the sensor register values and configures the device."""
        self.write_sensor_registers()
    
#------------------------------------------------------------------------------ 
      
    def _decode_threshold(self, threshold):
        """Decodes color components of threshold."""
        MASK = int('1111111111', 2)
        red_component = (threshold >> 20) & MASK
        green_component = (threshold >> 10) & MASK
        blue_component = threshold & MASK
        return red_component, green_component, blue_component
    
    def _get_thresholds(self, thresholds, byte=False):
        """Gets the color components of the thresholds."""
        thr_min = array(self._decode_threshold(thresholds[0]), dtype=int16)
        thr_max = array(self._decode_threshold(thresholds[1]), dtype=int16)
        if byte:
            thr_min = (thr_min / 4).astype(uint8)
            thr_max = (thr_max / 4).astype(uint8)
        return thr_min, thr_max
    
    def get_red_thresholds(self, byte=False):
        """Gets the color components of the red thresholds."""
        red_min, red_max = self._get_thresholds(self.red_thresholds, byte)
        return red_min, red_max
    
    def get_green_thresholds(self, byte=False):
        """Gets the color components of the green thresholds."""
        green_min, green_max = self._get_thresholds(self.green_thresholds, byte)
        return green_min, green_max
    
    def get_blue_thresholds(self, byte=False):
        """Gets the color components of the blue thresholds."""
        blue_min, blue_max = self._get_thresholds(self.blue_thresholds, byte)    
        return blue_min, blue_max
    
#-------------------------------------------------------------------------------
    
    def get_binarized_images(self, image):
        """Converts the image to the corresponding binarized images."""
        red_bin = pimage.binarize(image, self.get_red_thresholds(byte=True))
        green_bin = pimage.binarize(image, self.get_green_thresholds(byte=True))
        blue_bin = pimage.binarize(image, self.get_blue_thresholds(byte=True))
        return red_bin, green_bin, blue_bin    
    
#-------------------------------------------------------------------------------
    
    def _encode_threshold(self, (red_component, green_component, blue_component)):
        """Encodes threshold from color components."""
        MASK = int('1111111111', 2)
        threshold = (red_component & MASK) << 20
        threshold += (green_component & MASK) << 10
        threshold += (blue_component & MASK)
        return threshold
    
    def _set_thresholds(self, thr_min, thr_max):
        """Sets the color components of the thresholds."""
        thr_min = self._encode_threshold(thr_min)
        thr_max = self._encode_threshold(thr_max)
        return (thr_min, thr_max)
    
    def set_red_thresholds(self, red_min, red_max):
        """Sets red thresholds with the specified color components."""
        self.red_thresholds = self._set_thresholds(red_min, red_max)
        
    def set_green_thresholds(self, green_min, green_max):
        """Sets green thresholds with the specified color components."""
        self.green_thresholds = self._set_thresholds(green_min, green_max)
                
    def set_blue_thresholds(self, blue_min, blue_max):
        """Sets blue thresholds with the specified color components."""
        self.blue_thresholds = self._set_thresholds(blue_min, blue_max)
    
#-------------------------------------------------------------------------------
    
    def reset_trackers(self):
        """Frees all tracker devices."""
        self.trackers = {}
        return self.write_register('fa', '')
            
    def configure_tracker(self, tracker_id, window):
        """Configures and activates a tracker device."""
        x, y, width, height = window
        self.trackers[tracker_id] = window
        return 'Activated tracker: %s' %tracker_id, self.write_register('sw', '%s,%i,%i,%i,%i' %(tracker_id, x, y, width, height))
            
    def activate_tracker(self, tracker_id):
        """Activates a tracker device to return the location position."""
        self.trackers[tracker_id]
        return self.write_register('at', '%s' %tracker_id)
        
    def deactivate_tracker(self, tracker_id):
        """Deactivates a tracker device to not return the location position."""
        self.trackers[tracker_id]
        return self.write_register('dt', '%s' %tracker_id)
        
    def free_tracker(self, tracker_id):
        """Frees a tracker device to accept a new tracking object."""
        try: 
            del self.trackers[tracker_id]
        except:
            pass
        return self.write_register('ft', '%s' %tracker_id)    
    
#-------------------------------------------------------------------------------
        
        
class VideoSensor(Client, Camera, Sensor):
    """This is the logical wrapper of video sensor system hardware."""
    
    def __init__(self, filename='video_sensor.cfg', quadrant=1):
        """Initializes the socket communication and configures the camera and 
        sensor registers.  
        """
        self.filename = filename
        self.quadrant = quadrant
        self.positions = None
        self.load_configuration()
        Client.__init__(self, self.IP, self.PORT, 2048)
        Camera.__init__(self)
        Sensor.__init__(self)
        if self.connected:
            self.configure()
            print self.read_register('tr') # Number of tracker resources 
        
    def load_configuration(self):
        """Loads the video sensor configuration file."""
        config = ConfigParser.RawConfigParser()
        config.read(self.filename)
        self.IP = config.get('VideoSensor', 'IP')
        self.PORT = eval(config.get('VideoSensor', 'PORT'))
        self.load_camera_configuration(config=config)
        self.load_sensor_configuration(config=config)
        logging.info('Loaded configuration %s.' %self.filename)
        
    def save_configuration(self):
        """Saves the sensor configuration file."""
        config = ConfigParser.RawConfigParser()
        config.add_section('VideoSensor')
        config.set('VideoSensor', 'IP', self.IP)
        config.set('VideoSensor', 'PORT', str(self.PORT))
        self.save_camera_configuration(config=config)
        self.save_sensor_configuration(config=config)
        with open(self.filename, 'wb') as configfile:
            config.write(configfile)
        logging.info('Saved configuration %s.' %self.filename)
        
    def configure(self):
        """Configures the video sensor system (camera and sensor)."""
        self.configure_sensor()
        self.configure_camera()
    
    def transform_points_to_global(self, points):
        """Transforms a points array from local to global coordinates."""
        return transform.points_to_global(points, self.width, self.height, 
                                          self.skip + 1, self.quadrant)
    
    def transform_points_to_local(self, points):
        """Transforms a points array from global to local coordinates."""
        return transform.points_to_local(points, self.width, self.height,
                                         self.skip + 1, self.quadrant)
    
    def get_current_windows(self):
        """Gets data of all current search windows activated in the system, 
        processes the search windows of the tracker devices to transform to 
        cartesian coordinates, according to their quadrant."""
        boxes = {}
        windows = self.read_register('aw')
        for window_id, window in windows.iteritems():
            point, size = asarray(window)
            points = array([point, point + size])
            boxes[window_id] = self.transform_points_to_global(points)
        return boxes
    
    def get_current_positions(self):
        """Gets current positions of all targets corners and processes the 
        positions of points cloud to transform to cartesian coordinates, 
        according to their quadrant and checks that are not on the border of 
        the image."""
        corners = {}
        positions = self.read_register('al')
        for position_id, position in positions.iteritems():
            points = calibrate.points_correction(asarray(position), (self.width / 2, self.height / 2), (self.kx, self.ky))
            if points.any():
                corners[position_id] = self.transform_points_to_global(points)
        return corners
    
    def get_robots_position(self, positions):
        """Gets the current positions of the robots from their corners."""
        robots = {} 
        triangles = processing.get_triangle_and_square_shapes(positions)[0]
        for triangle_id, triangle in triangles.iteritems():
            robots[triangle_id] = processing.get_triangle_position(triangle)
        return robots
        
    def get_obstacles_position(self, positions):
        """Gets the current positions of the obstacles from their corners."""
        obstacles = {}
        squares = processing.get_triangle_and_square_shapes(positions)[1]
        for square_id, square in squares.iteritems():
            obstacles[square_id] = processing.get_square_position(square) 
        return obstacles
   

    
def init_tracking(video_sensor, start_id=0):
    """Initializes the tracking system."""
    
    t0 = time.time()
    # Reset trackers and gets the current image
    video_sensor.reset_trackers() 
    video_sensor.select_output(4)
    video_sensor.configure()
    image = video_sensor.get_new_frame()
    t1 = time.time()
    print 'Time to get a frame:', t1 - t0
    
    # Image processing, shapes location and tracking windows calculation
    t0 = time.time()
    images_bin = video_sensor.get_binarized_images(image)
    objects, windows = processing.location_objects_and_windows_in_images(images_bin)
    t1 = time.time()
    print 'Time to locate robots:', t1 - t0
    
    # Draws the shapes found and their search windows
    figure()
    imshow(image)
    width, height = image.shape[1], image.shape[0]
    for i, box in enumerate(windows):
        target_id = i + start_id + 1
        gca().add_patch(Rectangle([box[0,0], box[0,1]], 
                                  box[1,0] - box[0,0], 
                                  box[1,1] - box[0,1], 
                                  alpha=.6, color='y', ec='w', lw=1))
        gca().add_patch(Polygon(objects[i], closed=True, 
                                alpha=.8, fc='y', ec='k', lw=1))
        plot(objects[i][:,0], objects[i][:,1], 'yo', lw=2)
        text((box[0,0] + box[1,0]) / 2, (box[0,1] + box[1,1]) / 2, 
             str(target_id), ha='center', va='center')
    xlim([0, width])
    ylim([height, 0])
    show()
    
    # Activates the tracking windows
    targets = {}
    for i, box in enumerate(windows):
        target_id, box = i + start_id + 1, box * 2
        targets[str(target_id)] = [box[1,0] - box[0,0], box[1,1] - box[0,1]]
        print video_sensor.configure_tracker(str(target_id), [box[0,0], box[0,1], box[1,0] - box[0,0], box[1,1] - box[0,1]])
    video_sensor.read_register('al')
    return targets

    

if __name__ == '__main__':
    if len(sys.argv) > 1:
        N = int(sys.argv[1])
    else:
        N = 100
    T = 0.01
    print 'Number of iterations:', N
    print 'Waiting time:', T
    
    video_sensor = VideoSensor(filename='video_sensor1.cfg', quadrant=1)
    init_tracking(video_sensor)

    # It reads positions of targets.
    t0 = time.time()
    for i in arange(N):
        positions = video_sensor.get_current_positions()
        robots = video_sensor.get_robots_position(positions)
        obstacles = video_sensor.get_obstacles_position(positions)
        print 'Frame: %i' %i
        print 'Robots:', robots
        print 'Obstacles:', obstacles
        time.sleep(T)
    t1 = time.time()
    print 'FPS: %i' %(N / (t1 - t0))
    
    video_sensor.write_register('so', 3)
    print video_sensor.write_command('C')
    
    # Socket client test
    while True:
        command = raw_input(">> ")
        if command.upper() == 'D':
            image = video_sensor.get_current_frame()
            Image.fromarray(image).save('rgb.png') # Save image
            figure()
            imshow(image)
            show()        
        elif command.upper() == 'G':
            image = video_sensor.get_current_frame(gray=True)
            Image.fromarray(image).save('gray.png') # Save image
            figure()
            gray()
            imshow(image)
            show()
        elif command.upper() == 'Q':
            break
        else:
            print video_sensor.write_command(command)
    
    # Closes socket communication
    video_sensor.disconnect()

