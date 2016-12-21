#!/usr/bin/env python
"""This module contains the VideoSensor class and related functions.

The functions are calls to the VideoSensor class methods in order to
capture images and then work with them using the imgprrocessing.Image
class and its methods.
"""
#Standard libraries
import ast
import ConfigParser
#import logging
import numpy as np
import pylab
from scipy import misc
import socket
import sys
#ROS libraries
import rospy
#Local libraries
from client import Client
import imgprocessing

def camera_startup(filename):
    """Bring up connection with camera and set up its configuration.
    
    Get an instance of the VideoSensor class and return it after doing
    initialization operations.
    """
    #Instantiate VideoSensor class. The filename contains the configuration
    camera = VideoSensor(filename)
    if not camera._connected:
        raise AttributeError("No connection to specified camera.")
    camera.load_configuration()
    #Reset trackers
    camera.set_register('FREE_ALL', '')
    #Select output = 4?
    camera.set_register('SYSTEM_OUTPUT', 4)
    conf = camera._client.write_command('CONFIGURE_CAMERA', True)
    return camera
    
def camera_shutdown(camera):
    """
    End connection to camera. Input is an instance of VideoSensor class.
    
    If disconnect_client() function is not called, the socket won't be 
    able to be reopened.
    """
    camera.set_register('SYSTEM_OUTPUT', 0)
    camera.disconnect_client()

def get_image(camera, filename=''):
    """Get an image. Input is an instance of VideoSensor class
    
    it can be saved to a local file (optional).
    """
    screenshot = camera.capture_frame(gray=True, output_file=filename)
    image = imgprocessing.Image(screenshot)
    image.binarize(camera._params['red_thresholds'])
    image.get_shapes()
    return image
    
def set_tracker(camera):
    """Configure trackers according to detected triangles.
    
    Parameters
    ----------
    camera : VideoSensor() object
        instance of the VideoSensor() class, from whom the initial
        frame will be obtained, and whose trackers register will be
        configured.
    
    Returns
    -------
    tracker_position : 5-elements list
        Contains the information about the configured tracker. The first
        element is the tracker id, the 2nd and 3rd are the X,Y initial
        coordinates and the 4th and 5th are the width and height.
        
    image : imgprocessing.Image() object
        frame captured and obtained from the FPGA.
    """
    #Get an Image object with triangle shapes in it already segregated.
    image = get_image(camera)
    tracker = {}
    tracker_position = []
    for index, triangle in enumerate(image.triangles):
        triangle.get_pose()
        triangle.get_window(min_value=0, max_value=image.image.shape)
        min_x = int(camera._scale * triangle.window[0,1])
        min_y = int(camera._scale * triangle.window[0,0])
        width = int(camera._scale * triangle.window[1,1] - min_x)
        height = int(camera._scale * triangle.window[1,0] - min_y)
        camera.configure_tracker(index+1, min_x, min_y, width, height)
        tracker_position = [index+1, min_x, min_y, width, height]
    return image, tracker_position



class VideoSensor(object):
    """
    This class contains methods for dealing with FPGA-camera system.
    """
    #Allowed attribute values.
    PARAMETERS = ('red_thresholds',
                  'green_thresholds',
                  'blue_thresholds',
                  'width', 
                  'height',
                  'start_col',
                  'start_row',
                  'col_size',
                  'row_size',
                  'col_mode',
                  'row_mode',
                  'exposure',
                  'skip',
                  'output')

    def __init__(self, filename='', scale=2.0):
        """
        Initialize attributes. If filename is passed, open connection.
        
        Parameters
        ----------
        filename : string
            Path to the configuration file of the camera. The path shall
            be passed relatively to the script directory.
            
        K : float
            scale value of the camera. relationship between the full
            resolution of the FPGA and the actual resolution that is 
            used. By, default, the FPGA is scaled with a 2:1 scale 
            i.e. only half of the pixels are used.
        """
        self.filename = None
        self.offsets = [0,0]
        self._ip = ''
        self._port = None
        self._scale = scale
        self._H = None
        #Dictionary variable where camera parameters are stored.
        self._params = {}
        #The Client class handles the TCP/IP connection to the device.
        self._client = Client()
        self._connected = False
        #Begin a logger, and associate it to the module __name__
#        self._logger = logging.getLogger(__name__)
        #Instantiate a configuration class and read input filename.
        self.conf = ConfigParser.RawConfigParser()
        self.read_conffile(filename)
        #Open connection if a filename is given
        if self.conf.sections():
            self.connect_client()

    def connect_client(self):
        """
        Read TCP/IP parameters in config file and connect to the device. 
        """
        #The IP and PORT parameters are stored in the config file.
        try:
            self._ip = self.conf.get('VideoSensor', 'IP')
            self._port = int(self.conf.get('VideoSensor', 'PORT'))
        except NoSectionError:
            rospy.logerr('Missing config file: {}'.format(self.filename))
#            self._logger.ERROR('Missing config file: {}'.format(self.filename))
            return
        self._logger.debug('Opened configuration file. '
                           'Connecting to {}'.format(self._ip))
        try:
            self._client.open_connection(self._ip, self._port)
            self._connected = True
        except socket.timeout:
            rospy.logwarn('Unable to connect to port. Timeout')
#            self._logger.warning('Unable to connect to port. Timeout')

    def disconnect_client(self):
        """Close TCP/IP connection with the device."""
        self._client.close_connection()
        self._connected = False

    def load_configuration(self, write2fpga=True):
        """
        Load the config file and send the configuration to the FPGA.
        
        * Read camera and sensor parameters in self.filename. They are 
        then stored in the self._params variable. 
        * If write2fpga flag is True, write paramters in the FPGA 
        registers by calling set_resgister() method. Finally, send 
        'CONFIGURE_CAMERA' command to FPGA.
        """
        #Check that the filename is correct
        if not self.conf.sections():
            rospy.logerr('Missing config file: {}'.format(self.filename))
#            self._logger.ERROR('Missing config file: {}'.format(self.filename))
            return
        #Sensor color thresholds parameters
        self._params['red_thresholds'] = ast.literal_eval(
                                self.conf.get('Sensor', 'red_thresholds'))
        self._params['green_thresholds'] = ast.literal_eval(
                                self.conf.get('Sensor', 'green_thresholds'))
        self._params['blue_thresholds'] = ast.literal_eval(
                                self.conf.get('Sensor', 'blue_thresholds'))
        #Camera acquisition geometry parameters
        self._params['width'] = self.conf.getint('Camera', 'width')
        self._params['height'] = self.conf.getint('Camera', 'height')
        self._params['start_col'] = self.conf.getint('Camera', 'start_column')
        self._params['start_row'] = self.conf.getint('Camera', 'start_row')
        self._params['col_size'] = self.conf.getint('Camera', 'column_size')
        self._params['row_size'] = self.conf.getint('Camera', 'row_size')
        self._params['col_mode'] = self.conf.getint('Camera', 'column_mode')
        self._params['row_mode'] = self.conf.getint('Camera', 'row_mode')
        self._params['exposure'] = self.conf.getint('Camera', 'exposure')
        self._params['skip'] = self._params['row_mode']
        self._params['output'] = 0
        #Read and store the camera offsets
        self.get_offsets()
        self.get_homography_array()
        #If the flag is marked as False, the method stops here.
        if not write2fpga:
            logging.debug("Loaded parameters. FPGA wasn't configured")
            return
        #--------------------------------------------------------------#
        ###Write to the FPGA registers the loaded configuration.###
        ####SENSOR COLOR THRESHOLDS####
        #They must be of string type.
        self.set_register('RED_THRESHOLD', self._params['red_thresholds'])
        self.set_register('GREEN_THRESHOLD', self._params['green_thresholds'])
        self.set_register('BLUE_THRESHOLD', self._params['blue_thresholds'])
        ####CAMERA GEOMETRY PARAMETERS####
        #They must be string type.
        self.set_register('IMAGE_SHAPE', (self._params['width'], 
                                          self._params['height']))
        self.set_register('IMAGE_EXPOSURE', self._params['exposure'])
        #Why is adding 15 and 53??
        self.set_register('SYSTEM_INDEXES', (self._params['start_col'],
                                             self._params['start_row']))
        self.set_register('SYSTEM_SHAPE', (self._params['col_size'], 
                                           self._params['row_size']))
        self.set_register('SYSTEM_MODES', (self._params['col_mode'], 
                                           self._params['row_mode']))
        self.set_register('SYSTEM_OUTPUT', self._params['output'])
        #Send the configuration command to the FPGA
        conf = self._client.write_command('CONFIGURE_CAMERA', True)
        logging.debug(repr("Obtained '{}' "
                           "after 'CONFIGURE_CAMERA'".format(conf)))

    def read_conffile(self, filename):
        """
        Look for a configuration file on the given path and read it.
        """
        self.filename = filename
        self.conf.read(self.filename)
        return

    def get_homography_array(self):
        """
        Get an homography array from the configuration file.
        """
        try:
            #Read the value of H as is written on file.
            raw_H = self.conf.get('Misc', 'H')
        except NoSectionError:
            raise AttributeError("There is no 'H' section in the conf file")
        #Format the value in order to get a 3x3 array.
        tuple_format = ','.join(raw_H.split('\n'))
        array_format = ast.literal_eval(tuple_format)
        self._H = np.array(array_format)
        return self._H

    def get_offsets(self):
        """
        Get the offset of the sensor respect to the iSpace center.
        
        The row offset of the camera images corresponds to the images
        height and the column offset corresponds to the images width.
        
        Returns
        -------
        offsets : 2-element list
            List containing the row and column offset i.e. 
            [row_offset, col_offset] 
        """
        #Get the physical quadrant value
        quadrant = self.conf.get('Misc', 'quadrant')
        try:
            width = self._params['width']
            height = self._params['height']
        except KeyError:
            raise KeyError("VideoSensor parameters were not loaded yet")
        if quadrant == '1':
            offsets = [height, 0]
        elif quadrant == '2':
            offsets = [height, width]
        elif quadrant == '3':
            offsets = [0, width]
        elif quadrant == '4':
            offsets = [0, 0]
        try:
            self.offsets = offsets
        except UnboundLocalError:
            raise AttributeError("Quadrant not valid: {}".format(quadrant))
        return offsets

    def get_register(self, register):
        """Read the content of the specified register.
        
        Parameters
        ----------
        register : string
            key identifier of valid register name of the FPGA. The full
            list of valid keys and their associated name can be found on
            the documentation of the client.Client class.
        """
        value = self._client.read_register(register)
        return value
        
    def set_register(self, register, value):
        """
        Write the desired value into an FPGA register.
        
        Parameters
        ----------
        register : string
            key identifier of valid register name of the FPGA. The full
            list of valid keys and their associated name can be found on
            the documentation of the client.Client class.
        
        value : int or N-element tuple/list
            the value that will be written to the register. It is 
            mandatory to send it as string type. Thus, the value has to
            be converted. For tupples or lists, brackets or parenthesis
            are not allowed, so they have to be eliminated.
            
            examples :
                sent_value = '6' ---> OK
                sent_value = '(3.45, 2.21)' ---> No OK
                sent_value = '3.45, 2.21' ---> OK
        """
        #int values are directly converted to string variables.
        if type(value) in (str, int):
            formatted_value = str(value)
        #In case of tuples, FPGA only understands decomposed string elements.
        #i.e. '(value1, value2)' is not valid. 'value1,value2' is valid.
        elif type(value) is tuple:
            #First element is added individually because it is not preceded
            #by a comma separator.
            formatted_value = str(value[0])
            for item in value[1:]:
                formatted_value = "{},{}".format(formatted_value, item)
        else:
            logging.warning("Not valid value type for {}".format(value))
        message = self._client.write_register(register, formatted_value)
        rospy.logdebug(repr("Obtained '{}' after writing {} on {} register."
                                "".format(message, formatted_value, register))))
#        self._logger.debug(repr("Obtained '{}' after writing {} on {} register."
#                                "".format(message, formatted_value, register)))
        return message

    def configure_tracker(self, tracker_id, min_x, min_y, width, height):
        """Send to FPGA rectangle parameters for defining a tracker.

        Parameters
        ----------
        tracker_id : integer
            identifier of the detected object.

        min_x, min_y : integer
            value of the X and Y cartesian coordinates, respectively, 
            of the tracker window.

        width, height : integer
            value of the width (X axis) and height (Y axis) of the 
            tracker window.

        NOTE: It is mandatory that the coordinates and dimensions passed
        to the FPGA are integers. Other types like float are not valid
        and the FPGA will not recognize them.
        """
        rospy.logdebug('Configuring tracker {}'.format(tracker_id))
#        self._logger.debug('Configuring tracker {}'.format(tracker_id))
        self.set_register('SET_WINDOW', '{},{},{},{},{}'
                          ''.format(tracker_id, min_x, min_y, width, height))

    def capture_frame(self, gray=True, tries=20, output_file=''):
        """
        This method requests a frame to the FPGA.
        
        Paramters
        ---------
        get_gray : Boolean
            if true, a gray-scale image will be requested. If false,
            the requested image will be colored
        
        tries : int
            number of times that the system will try to obtain the 
            requested image. After the last try, the system will exit.
            
        output_file : URL str
            name of the output file were the image will be stored. If 
            left blank, the image will not be saved.
            
        Returns
        -------
        image : MxNxdim numpy.array
            image contained in an array with dimensions specified in the
            configuration file. If gray color is True, the dim value 
            will be 1, and 3 for False (representing color images). dim
            equals to the number of components per pixel.
        """
        #Request a frame capture to the socket client
        message = self._client.write_command('GET_NEW_FRAME', True)
        while message != "Image captured.\n":
            if not tries:
                logging.warning("Stop waiting for a frame after 20 tries")
                sys.exit()
            tries -= 1
            #Timeout error means that the FPGA buffer is empty. If this
            #happens, it will try to read the buffer again.
            try:
                message = self._client.recv(self._client.buffer_size)
            except socket.timeout:
                pass
        logging.debug(repr("'{}' after {} tries.".format(message, 20 - tries)))
        #dim (dimensions) is the number of components per pixel.
        if gray:
            command = 'GET_GRAY_IMAGE'
            dim = 1
            shape = (self._params['height'], self._params['width'])
        else:
            command = 'GET_COLOR_IMAGE'
            dim = 3
            shape = (self._params['height'], self._params['width'], dim)
        self._client.write_command(command)
        logging.debug("'{}' command sent.".format(command))
        #SIZE = Width x Height x Dimensions
        img_size = self._params['width'] * self._params['height'] * dim
        data = self._client.read_data(img_size)
        image = pylab.fromstring(data, dtype=pylab.uint8).reshape(shape)
        if output_file:
            misc.imsave(output_file, image)
        return image




