#!/usr/bin/env python
"""
This module contains the class Client, which inherits from socket.socket

* socket.socket class source code can be found in the folowing link:
https://hg.python.org/cpython/file/2.7/Lib/socket.py

* This class is a child of the _socket.socket class.
_socket.socket class source code can be found in the following link:
https://github.com/biosbits/bits/blob/master/python/_socket.py
"""
# Standard libraries
import logging
import socket
from socket import socket as Socket

class Client(Socket):
    """Child class of socket.socket which includes register operations.
    
    It is intended to work with registers of a device, namely of an 
    FPGA. The register identifiers must correspond with the ones of the
    designed HDL circuit.
    
    Used methods from parent class:
    
    * connect((host, port)) : connects to a remote address
    * close()
    * send(data) 
    * recv(buflen) : read the specified number of bytes
    * settimeout(timeout)
    """
    def __init__(self, ip, port, buffer_size=2048, timeout=1.0):
        """Set attributes, inheritance and logger.
                
        Parameters
        ----------
        ip : string
            IP adress of the device that will be connected.
            
        port: int
            Device port where the connection will be stablished.
            
        buffer_size : int
            size in bytes of the buffer for the incomming data.
            
        timeout : int or float
            value in seconds of the time that will be waited for reading
            incoming data. This will set the object to timeout mode. By
            default, it is set to blocking mode 
        """
        #Initializes parent class
        Socket.__init__(self, family=socket.AF_INET, type=socket.SOCK_STREAM)
        #Connection parameters for the client device
        self.ip = ip
        self.port = port
        self.buffer_size = buffer_size
        self._logger = logging.getLogger(__name__)
        #Call parent method for setting the timeout
        self.settimeout(timeout)

    def open_connection(self):
        """Create the socket connection.
        
        After connecting, the input buffer is read for emptying it.
        """
        self.connect((self.ip, self.port))
        self._logger.info('Started TCP client with IP: {} '
                          'and PORT:{}.'.format(self.ip, self.port))
        #Empty the data buffer, as it contains the welcome message.
        self.recv(self.buffer_size)
        
    def close_connection(self):
        """Send close command to device and close connection.
        
        Write 'Q' to FPGA register and call Socket.close() method.
        """
        #Check parent class _sock variable,
        #as it changes its class when it is closed.
        #WARNING: not valid method for Python3.
        if not isinstance(self._sock, socket._closedsocket):
            self.send('Q\n')
            self.close()
            self._logger.info('Closed the TCP client')
        else:
            self._logger.debug('Unable to close TCP client. Already closed')
        
    def read_data(self, size):
        """Read N packages and return a cocatenation of all of them.
        
        Parameters
        ----------
        size : int
            Number of bytes wished to be read.
        """
        bytes = 0
        packages = []
        #Do not stop reading new packages until target 'size' is reached.
        while (bytes < size):
            received_package = self.sock.recv(self.buffer_size)
            bytes += len(received_package)
            packages.append(received_package)
            _logger.debug('Received {} bytes of {} ({:.2f})\r'
                          ''.format(bytes, size, (100 * float(bytes)/size))
                         )
        #Cocatenate all the packages in a unique variable
        data = ''.join(packages)
        return data
        
    def write_command(self, data):
        """Send a command to the TCP client and return the response."""
        self.send('{}\n'.format(data))
        return self.recv(self.buffer_size)
    
    def read_register(self, reg):
        """Read the value of a register."""
        self.send('r,{}\n'.format(reg))
        result = self.recv(self.buffer_size)
        return eval(result)

    def write_register(self, reg, value):
        """Write a value into a register and clean up input buffer."""
        self.send('w,{},{}\n'.format(reg, value))
        return self.recv(self.buffer_size)



