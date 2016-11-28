#!/usr/bin/env python
"""This module contains the VideoSensor class."""
#Standard libraries
import ast
import ConfigParser
import logging
import pylab
from scipy import misc
import socket
#Local libraries
from client import Client

class VideoSensor(object):
    """This class contains methods for dealing with FPGA-camera system

    Parameters
    ----------
    filename : str
        Path of the camera config file.
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

    def __init__(self, filename=''):
        """
        Initialize attributes. If filename is passed, open connection.
        """
        self.filename = filename
        self._ip = ''
        self._port = None
        #Dictionary variable where camera parameters are stored.
        self._params = {}
        #The Client class handles the TCP/IP connection to the device.
        self._client = Client()
        self._connected = False
        #Begin a logger, and associate it to the module __name__
        self._logger = logging.getLogger(__name__)
        #Instantiate a configuration class and read input filename.
        self.conf = ConfigParser.RawConfigParser()
        self.conf.read(filename)
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
            self._logger.ERROR('Missing config file: {}'.format(self.filename))
            return
        self._logger.debug('Opened configuration file. '
                           'Connecting to {}'.format(self._ip))
        try:
            self._client.open_connection(self._ip, self._port)
            self._connected = True
        except socket.timeout:
            self._logger.warning('Unable to connect to port. Timeout')

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

    def set_register(self, register, value):
        """
        Write the desired value into an FPGA register.
        
        Parameters
        ----------
        register : string
            key identifier of valid register name of the FPGA. The full
            list of valid keys and their associated name can be found on
            the documentation of the client.Client class.
        
        value : int or 2-element tuple/list
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
        self._logger.debug(repr("Obtained '{}' after writing {} on {} register."
                                "".format(message, formatted_value, register)))

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




