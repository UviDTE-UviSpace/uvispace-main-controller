#!/usr/bin/env python
"""
This module contains the class Client, which inherits from socket.socket

* socket.socket class source code can be found in the folowing link:
https://hg.python.org/cpython/file/2.7/Lib/socket.py

* The socket.socket class is a subclass of the _socket.socket class.
_socket.socket class source code can be found in the following link:
https://github.com/biosbits/bits/blob/master/python/_socket.py
"""
# Standard libraries
import logging
import socket
from socket import socket as Socket

class Client(Socket):
    """
    A child class of socket.socket which includes register operations.
    
    It is intended to work with registers of a device, namely of an 
    FPGA. The register identifiers must correspond with the ones of the
    designed circuit.
    
    Methods from parent class:
    
    * connect((host, port)) : connects to a remote address
    * send(data) 
    * recv(buflen) : read the specified number of bytes
    """
    def __init__(self, ip, port, buffer_size=2048, timeout=5.0):
        """Creates the socket object.
        
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
        self.ip = ip
        self.port = port
        self.buffer_size = buffer_size
        self._logger = logging.getLogger(__name__)
        #Call parent method for setting the timeout
        self.settimeout(timeout)

    def open_connection(self):
        """Creates the socket connection.
        
        It uses the class ip and port attributes as the connection 
        address. It writes to log the connection.
        """
        self.connect((self.ip, self.port))
        self._logger.info('Started TCP client with IP: {} '
                          'and PORT:{}.'.format(self.ip, self.port))
        #Empty the data buffer, as it contains the welcome message.
        self.recv(self.buffer_size)
        
    def close_connection(self):
        """
        Write 'Q' to FPGA register and call Socket.close() method.
        """
        #The parent class changes _sock class when it is closed.
        if not isinstance(self._sock, socket._closedsocket):
            self.send('Q\n')
            self.close()
        self._logger.info('Closed the TCP client')
        
    def read_data(self, size):
        """Reads a size number of data bytes from the socket buffer."""
        bytes = 0
        packages = []
        while (bytes < size):
            data = self.sock.recv(self.buffer_size)
            bytes += len(data)
            packages.append(data)
            _logger.debug('Received {} bytes of {} ({:.2f})\r'
                          ''.format(bytes, size, (100 * float(bytes)/size))
        data = ''.join(packages)
        return data
        
    def write_command(self, data):
        """
        Writes a command value in the  buffer and sends it to TCP client.
        """
        self.send('{}\n'.format(data))
        return self.read()
    
    def read_register(self, reg):
        """Reads the value from a register ."""
        self.send('r,{}\n'.format(reg))
        result = self.recv(self.buffer_size)
        return eval(result)

    def write_register(self, reg, value):
        """Writes a value into a register."""
        self.send('w,{},{}\n'.format(reg, value))
        return self.recv(self.buffer_size)



