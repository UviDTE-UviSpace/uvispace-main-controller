import unittest
from uvispace.uvirobot import speedtransform

class MySpeedTestCase(unittest.TestCase):
    def test_speed_scale_conversion(self):
        input_max = 1
        max_output = 100
        output = messenger.get_2WD_speeds(input_max, 0,
                                          minInput=-1, maxInput=input_max, 
                                          minOutput=0, maxOutput=max_output)
        self.assertEqual((max_output, max_output), output)
