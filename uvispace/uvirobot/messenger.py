#!/usr/bin/env python
"""This module contains the classes WifiMessenger and ZigBeeMessenger.
They are the Wifi and ZigBee versions of the MessageProtocol class (not
dependent on communication protocol).
These classes inherit from MessageProtocol and define the abstract methods
read and write according to the communication protocol.

For each Wifi object created a new socket (IP, port) is created. However for
Zigbee is different. The ZigBeeMessenger supposed that all UGV are connected to
a single ZigBee module connected to the main controller. Therefore a single
serial port is shared by all objects of this class.

"""
import logging
import socket
from serial import Serial

from uvispace.uvirobot.message_protocol import MessageProtocol

class ZigBeeMessenger(Serial, MessageProtocol):

    """
    ZigBee wrapper of the MessageProtocol class

    :param str port: name identifier of the port path in the PC's OS.
    :param int baudrate: communications speed between the XBee modules.
    :param int stopbits: Number of bits at the end of each message.
    :param str parity: Message parity. *None* by default
    :param float timeout: Time to wait to achieve the communication.
    """

    def __init__(self, port,
             baudrate,
             stopbits=1,
             parity='N',
             timeout=0.5):
        # Initializes the parent class
        Serial.__init__(self, port=port,
                    baudrate=baudrate,
                    stopbits=stopbits,
                    parity=parity,
                    timeout=timeout)
        # IDs of the master and slave.
        self.MASTER_ID = b'\x01'
        self.SLAVE_ID = b'\x01'
        if self.is_open:
            self.flushInput()

    def _read(self, numbytes):
        data = self.read(numbytes)
        return data

    def _write(self, message):
        self.write(message)

class WifiMessenger(MessageProtocol):
    """
    WiFi wrapper of the MessageProtocol class
    """
    def __init__(self,TCP_IP, TCP_PORT):
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((TCP_IP, TCP_PORT))
        # IDs of the master and slave. Not used in this protocol
        self.MASTER_ID = b'\x01'
        self.SLAVE_ID = b'\x01'
    def _read(self, numbytes):
        data = self.s.recv(numbytes)
        return data

    def _write(self, message):
        self.s.send(message)
