#!/usr/bin/env python
"""This module contains the class MessageProtocol.

The aim is to provide the message definition and packing for UGV communication.
The message protocol is independent from the communication protocol (serial or
wifi).
Each message sent contains the following Bytes:
-------------------------------------------------------------------------------
Byte Name          | Size (B) | Explanation
-------------------------------------------------------------------------------
Starting Byte (STX)|   1      | Flags beginning of new message
Master ID          |   1      | ID from the device sending
Slave ID           |   1      | ID of the device receiving
Message Size       |   2      | Size of the Data section of the message
Function code      |   1      | Command code (i.e. move motors)
Data               |   N      | Actual data of the message (i.e. value of pwm motor 1 and 2)
Ending Byte (ETX)  |   1      | Flags the end of this message
-------------------------------------------------------------------------------
Definition of available commands and functions to easy send them are defined
below in the MessageProtocol class
"""
# Standard libraries
import logging
from serial import Serial
import struct
import abc
import sys
import time

try:
    # Logging setup.
    import uvispace.settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")
logger = logging.getLogger("robot")


class MessageProtocol:
    """
    This class implements a message-based protocol over the serial port
    in Master-slave mode: The master (PC) starts communication with
    the slave(peripheral) sending a message. The slave process the
    message and returns an answer.
    """

    # ---------- CLASS CONSTANTS ---------- #

    # message fields
    STX = b'\x02'      # Start of message
    ETX = b'\x03'      # End of message
    # slave-to-master function codes
    ACK_MSG = b'\x01'  # Acknowledge
    SOC_MSG = b'\x02'  # State of Charge
    V_MSG = b'\x03'    # Battery Voltage
    R_CAP_MSG = b'\x04'
    TEMP_MSG = b'\x05' # Battery Temperature
    CURR_MSG = b'\x06' # Battery Current
    BAT_ERR = b'\x07'  # Battery Error
    # master-to-slave function codes
    READY = b'\x04'    # Ask if slave is ready (still there)
    MOVE = b'\x05'     # Change motor speed setpoints
    GET_SOC = b'\x06'  # Get the state of charge
    GET_V = b'\x07'    # Get battery voltage
    GET_R_CAP = b'\x08'#
    GET_TEMP = b'\x09' # Get battery temperature
    GET_CURR = b'\x0A' # Get battery current

    def __init__():
        pass
    # -------------------MASTER-SLAVE COMMANDS------------------- #
    def ready(self, tries=10):
        """Check if the communication channel is ready.

        The parameter **tries** specifies the number of attempts before
        exiting and raising an error message.

        :returns: returns a true or false condition which confirms that
         the message was received.
        :rtype: bool
        """
        ready = False
        # send configuration message.
        count = 0
        while not ready:
            if count == tries:
                logger.error("Unable to connect. Exited after {} tries".format(
                        tries))
                sys.exit()
            self.send_message(self.READY)
            # wait for the response from the device
            fun_code = self.read_message()[1]
            if fun_code == self.ACK_MSG:
                ready = True
            count += 1
        return ready

    def move(self, setpoint):
        """Send a move order to the slave.

        :param setpoint: List with UGV speeds, whose elements range from
         0 to 255. The first element corresponds to M1 (right wheels in
         DF Robot Pirate 4WD, acceleration in Lego UGV), and
         the second element corresponds to M2 (left wheels in the DF Robot
         Pirate 4WD, servo for steering in Lego UGV). Values are rounded if
         float.
        :type setpoint: [int, int]
        :returns: true or false condition which confirms that the
            message was received.
        :rtype: bool
        """
        # Check that the values are correct. Invalid values may crash
        # the Arduino program.
        while any(x > 255 or x < 0 for x in setpoint):
            logger.warn('Invalid set points. Please enter 2 values between '
                        '0 and 255 (Decimal values will be rounded)')
        if any(type(x) == float for x in setpoint):
            setpoint = [int(round(x)) for x in setpoint]
        # Values casted into bytes datatype
        setpoint_bytes = struct.pack('B', setpoint[0]) \
                         + struct.pack('B', setpoint[1])
        # send configuration messager
        self.send_message(self.MOVE, setpoint_bytes)
        # wait for the response from the device
        Rx_OK, fun_code, length, data = self.read_message()
        # If the Rx_OK field was not asserted, raise an error
        if Rx_OK is False:
            logger.error('Unsuccessfull communication3')
            return False
        else:  # no errors
            if fun_code == self.ACK_MSG:
                return True
            else:
                return False

    def get_soc(self):
        """Get the State of Charge (SoC) of the vehicle battery."""
        soc = None
        self.send_message(self.GET_SOC)
        Rx_OK, fun_code, length, data = self.read_message()
        # If the Rx_OK field was not asserted, raise an error
        if Rx_OK is False:
            logger.error('Unsuccessfull communication')
        else:
            if fun_code == self.SOC_MSG:
                soc = data
            elif fun_code == self.BAT_ERR:
                soc = -1
        return soc

    # -------------MASTER-SLAVE COMMANDS AUXILIAR FUNCTIONS------------- #
    def send_message(self, fun_code, data=b'', send_delay=0.01):
        """Send a message to slaves formatted with the defined protocol.

        :param byte fun_code: function code of the command that is going
         to be sent.
        :param bytes data: DATA field of the message.
        :param float send_delay: Delay time to wait between sent bytes.
        """
        # Prepares message.
        # The data length bytes are little endian according to the protocol.
        # Thus, these bytes have to be reversed.
        data_length = struct.pack('>H', len(data))[::-1]

        message =   self.STX       \
                  + self.SLAVE_ID  \
                  + self.MASTER_ID \
                  + data_length    \
                  + fun_code       \
                  + data           \
                  + self.ETX

        # Encode string to bytes (as required by pyserial 3) and send message.
        logger.debug('sending... {}'.format(message.hex()))

        self._write(message)

    def read_message(self):
        """Read a message using the serial message protocol.

        When the message is read, check the auxiliary bytes for
        assuring the consistence of the message.

        :returns: [Rx_OK, fun_code, data, length]

          * *Rx_OK* is 0 if an error ocurred.
          * *fun_code* is the non decodified hex-data corresponding to
            the function code given by the slave.
          * *data* is the non decodified bytes of data given by slave.
          * *length* is the size of the main data, in bytes
        :rtype: [bool, str, str, int]
        """
        Rx_OK = False
        fun_code = ""
        length = 0
        data = b""
        _STX = ""
        # Reading of the auxiliary initial bytes
        # The 1st byte of transmission corresponds to 'start transmission'.
        start_time = time.time()
        while _STX != self.STX:
            current_time = time.time()
            # Gives the slave 0.1 seconds to return an answer.
            if current_time - start_time > 0.1:
                logger.info('Error, STX was not found')
                return (Rx_OK, fun_code, length, data)
            _STX = self._read(1)
            #print(_STX)
            #print(self.STX)
        # The 2nd and 3rd bytes of transmission correspond to the master
        # and slave IDs
        id_dest = self._read(1)
        id_org = self._read(1)

        # Reading of the length-of-data bytes
        # With the try-except statements, it is checked that there
        # is data available in the 2 length bytes.
        try:
            length = struct.unpack('>H', self._read(2))[0]
        # TODO specify the exception.
        except:
            logger.error('Received length bytes are not valid')
            return (Rx_OK, fun_code, length, data)
        logger.debug('received data length = {}'.format(length))

        # Reading of the function code and the main data
        fun_code = self._read(1)
        for i in range(length):
            data = data + self._read(1)
        # Reading of the last byte, corresponding to end of transmission check.
        _ETX = self._read(1)

        # Check of message validity
        if (_ETX == self.ETX) and (id_dest == self.MASTER_ID):
            logger.debug('Succesfull communication')
            Rx_OK = True
        elif _ETX != SerMesProtocol.ETX:
            logger.error('Error, ETX was not found')
        elif id_dest != self.MASTER_ID:
            logger.warn('Message for other device')

        return (Rx_OK, fun_code, length, data)

    @abc.abstractmethod
    def _write(self, message):
        return False

    @abc.abstractmethod
    def _read(self,numbytes):
        return b'\x00'
