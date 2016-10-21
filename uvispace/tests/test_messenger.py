import unittest
from uvispace.uvirobot import messenger

class MyMessengerTestCase(unittest.TestCase):

    def test_speed_scale_conversion(self):
        input_max = 1
        max_output = 100
        output = messenger.get_2WD_speeds(input_max, 0,
                                          minInput=-1, maxInput=input_max, 
                                          minOutput=0, maxOutput=max_output)
        self.assertEqual((max_output, max_output), output)
    
    
    
    from serial import Serial
    class SerialComm():
        def __init__(self)
            # Do some stuff
            # ...
            self.port = glob.glob('/dev/ttyUSB*')[0]
            self.serial = Serial(port=self.port)
            
        def ask_if_ready(port, baudrate):
            """Send an acknowledge request through serial port."""
            message = SerialComm.build_message(function='ready')
            my_serial = Serial(port=port, baudrate=baudrate)
            my_serial.write(message) 
            return my_serial.read()
            
        def build_message(function):
            """Makes a message based on a protocol"""
            #Do stuff
            return message
