#!/usr/bin/env python
"""This module contains the VideoSensor class."""
#Standard libraries
import ast
import ConfigParser
import logging
#Local libraries
from client import Client

class VideoSensor(object):
    """This class contains methods for dealing with a FPGA-camera system

    Parameters
    ----------
    filename : str
        Path of the camera config file.
    """
    #Allowed attribute values.
    PARAMETERS = (width, height)

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
        self.config = ConfigParser.RawConfigParser()
        self.config.read(filename)
        #Open connection if a filename is given
        if self.config.sections():
            self.connect_client()

    def connect_client(self):
        """
        Read TCP/IP parameters in config file and connect to the device. 
        """
        #The IP and PORT parameters are stored in the config file.
        self._ip = self.config.get('VideoSensor', 'IP')
        self._port = int(self.config.get('VideoSensor', 'PORT'))
        try:
            self._client.connect(self._ip, self._port)
            self._connected = True
        except socket.timeout:
            self._logger.warning('Unable to connect to port')

    def disconnect_client(self):
        """Close TCP/IP connection with the device."""
        self._client.close_connection()
        self._connected = False

    def load_configuration(self):
        """Read camera and sensor parameters in config file."""
        #Sensor color thresholds parameters
        self._params['red_thresholds'] = ast.literal_eval(
                                self.config.get('Sensor', 'red_thresholds'))
        self._params['green_thresholds'] = ast.literal_eval(
                                self.config.get('Sensor', 'green_thresholds'))
        self._params['blue_thresholds'] = ast.literal_eval(
                                self.config.get('Sensor', 'blue_thresholds'))
        #Camera acquisition geometry parameters
        self._params['width'] = self.config.getint('Camera', 'width')
        self._params['height'] = self.config.getint('Camera', 'height')
        self._params['start_col'] = self.config.getint('Camera', 'start_column')
        self._params['start_row'] = self.config.getint('Camera', 'start_row')
        self._params['col_size'] = self.config.getint('Camera', 'column_size')
        self._params['row_size'] = self.config.getint('Camera', 'row_size')
        self._params['col_mode'] = self.config.getint('Camera', 'column_mode')
        self._params['row_mode'] = self.config.getint('Camera', 'row_mode')
        self._params['skip'] = self._params['row_mode']
        self._params['exposure'] = self.config.getint('Camera', 'exposure')
        self._params['output'] = 0

    def write_conf_registers(self):
        """Write to the FPGA registers the loaded configuration."""
        ####SENSOR COLOR THRESHOLDS####
        #They must be string type.
        self._client.write_register('RED_THRESHOLD', 
                        str(self._params['red_thresholds']))
        self._client.write_register('GREEN_THRESHOLD', 
                        str(self._params['green_thresholds']))
        self._client.write_register('BLUE_THRESHOLD', 
                        str(self._params['blue_thresholds']))
        ####CAMERA GEOMETRY PARAMETERS####
        #They must be string type.
        self._client.write_register('IMAGE_SHAPE', '{}{}'.format(
                        self._params['width'], self._params['height']))
        self._client.write_register('IMAGE_EXPOSURE', 
                        str(self._params['exposure']))
        #Why is adding 15 and 53??
        self._client.write_register('SYSTEM_INDEXES', '{}{}'.format(
                        self._params['start_col'] + 15, 
                        self._params['start_row'] + 53))
        self._client.write_register('SYSTEM_SHAPE', '{}{}'.format(
                        self._params['col_size'], self._params['row_size']))
        self._client.write_register('SYSTEM_MODES', '{}{}'.format(
                        self._params['col_mode'], self._params['row_mode']))
        self._client.write_register('SYSTEM_OUTPUT', 
                        str(self._params['output']))





