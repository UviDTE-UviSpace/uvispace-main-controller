#!/usr/bin/env python 
"""
Module with a class that deals with the formatting of speed values.

An instance of the *Speed* class represents the speeds of 2WD (2-Wheel-
Drive) UGVs, and the attributes and operations related to them. They 
convert *linear-angular* speeds into *left-right* speeds, which is the 
used format in the *Arduino* slaves.

They also allow to change the values scale. It is important to know that
the *Arduino* manages speed values ranging from 0 to 255 for each wheel.
The first 127 values represent reverse direction speeds, and the last 
127 direct direction speeds (127 is null speed).
"""
import numpy as np
import logging

import settings
logger = logging.getLogger('messenger')


class Speed(object):
    """
    This class manages the speed values compatible with a 2WD vehicle.
    
    The default speed format is *linear_angular*. This means that the 
    speed is a 2-values array, whose items corresponds to the linear 
    and angular speed respectively.

    :param speed: speed values of the vehicle. If the 
     format is *linear_angular*, it represents the linear and angular 
     speeds of the vehicle. If the format is *2_wheel_drive*, it 
     represents the velocities of the right and left wheels of the 
     vehicle, respectively.
    :param float min_value: Minimum value of the *speed* attribute
    :param float max_value: Maximum value of the *speed* attribute
    :param str spd_format: Format of the speed. Possible values are 
     stored in the tuple *Speed.SPEEDFORMATS*.
    :param str scale: Scaling of the speed. Possible values are 
     stored in the tuple *Speed.SPEEDSCALES*.
    :type speed: [float, float]
    """
    # Available speed formats
    SPEEDFORMATS = ('linear_angular', '2_wheel_drive')
    SPEEDSCALES = ('linear', 'non-linear')

    def __init__(self, speed=[0, 0], min_value=-0.3, max_value=0.3,
                 spd_format='linear_angular', scale='linear'):
        self._min_value = min_value
        self._max_value = max_value
        self._speed = np.array([None, None])
        self._format = None
        # Wheel's diameter
        self.rho = None
        # Calls the set_speed method to initialize the format and speed
        # attributes.
        self._scale = self._set_scale(scale)
        self.set_speed(speed, spd_format)

    def set_speed(self, speed, speed_format, speed_scale='linear'):
        """Set a new speed value.
        
        Input speed must be a 2-values list or tupple. If out of bounds, 
        it will be rounded to the nearest limit.

        :param [float/int, float/int] speed: new values for the *speed* 
         attribute. Depending on the format, the values may refer to the
         linear and angular values, or to the left and right wheels 
         speeds.
        :param str speed_format: The format of the new speed. It has to 
         be a valid one (Check the attribute *Speed.SPEEDFORMATS*) 
        :param str speed_scale: The scale of the new speed. It has to 
         be a valid one (Check the attribute *Speed.SPEEDSCALES*) 
        """
        s = np.array([0.0, 0.0])
        try:
            for index, value in enumerate(speed):
                s[index] = float(value)
        except:
            raise ValueError("Not a valid speed: {}".format(speed))
        else:
            if len(speed) is not 2:
                raise ValueError("Not a valid speed: {}".format(speed))
        # If no errors are raised, assign values to _speed attribute.
        self._speed = s
        # The speed value is rounded to the nearest limit when out of bounds.
        self.check_bounds()
        self._set_format(speed_format)
        self._set_scale(speed_scale)

    def get_speed(self):
        """Return the value of the speed."""
        return self._speed

    def check_bounds(self):
        """Check that the speed values are inside valid bounds.

        If the value is out of bounds, it is rounded to the nearest 
        limit.
        """
        if self._scale == 'linear':
            for index, value in enumerate(self._speed):
                if (self._speed[index] < self._min_value):
                    self._speed[index] = self._min_value
                elif (self._speed[index] > self._max_value):
                    self._speed[index] = self._max_value
        if self._scale == 'non-linear':
            pass
            # Checks if the speed value is in segmentA or segmentB.
        return self._speed

    def get_min_value(self):
        """ Return the minimum allowed value for a linear scale."""
        return self._min_value

    def get_max_value(self):
        """ Return the maximum allowed value for a linear scale."""
        return self._max_value

    def _set_format(self, new_format):
        """Set the new format of the speed.
        
        :Available values: 

        * linear_angular ([vL, vR]): *vL* corresponds to the linear 
          velocity and *vR* corresponds to the angular velocity.            
        * 2_wheel_drive ([v_right, v_left]): *v_right* corresponds to 
          the velocity of the right wheel and *v_left* corresponds to 
          the velocity of the left wheel.
        """
        if not new_format in self.SPEEDFORMATS:
            raise ValueError("Not a valid format type: {}".format(new_format))
        if (self._format is '2_wheel_drive' and new_format is 'linear_angular'):
            self._max_value *= self.rho
            self._min_value *= self.rho
        self._format = new_format

    def get_format(self):
        """Return the format value."""
        return self._format

    def _set_scale(self, new_scale):
        """Set the scale of the speed.
        
        :Available values : 
        
        * 'linear'
        * 'non-linear'
        """
        if not new_scale in self.SPEEDSCALES:
            raise ValueError("Not a valid scale type: {}".format(new_scale))
        self._scale = new_scale

    def get_scale(self):
        """Return the scale value."""
        return self._scale

    def linear_transform(self, new_min, new_max):
        """Change the range of values of the speed.
        
        The method converts the actual *speed* values and the limits it 
        can take.

        :param float new_min: absolute minimum that the new speed values 
         may take.
        :param float new_max: absolute maximum that the new speed values 
         may take.
        """
        if self._scale is not 'linear':
            raise ValueError("Not a valid scale type: {}".format(self._scale))
        num = (self._speed - self._min_value) * (new_max - new_min)
        den = self._max_value - self._min_value
        new_value = (num/den) + new_max
        self.set_speed(new_value)
        return new_value

    def nonlinear_transform(self, min_A=30, max_A=100,
                            min_B=160, max_B=220,
                            scale_zero=127):
        """ 
        Make a non-linear conversion of speed values.
        
        Intended to avoid the useless values near to 0 speed on a real 
        UGV, and extreme values that implies high power. It translates 
        the input speeds to useful segments. A characterization of the 
        UGV has been done before performing this rescalation.
        
        This method can only be called if the class' scale is linear 
        i.e. can't convert a nonlinear scale to another nonlinear scale.
        
        :Transformation:

        The values range is divided into 2 equal segments (segment A and
        segment B). If the value belongs to segment A, it will be 
        rescalated between min_A and max_A values. On the contrary, if 
        it belongs to segment B it is rescalated between min_B and 
        max_B. The mid value is assigned to 0.

        ::

                      min_value    zero_value    max_value
                          |------------|------------|         
                            segment A     segment B               
        
            min_A             max_A         min_B             max_B
              |-----------------|      |      |-----------------|
                                   scale_zero

        :param int/float [min_A, max_A, min_B, max_B]: Limit values for 
         the segments A and B. The transformed values will belong to one
         of the 2 intervals and 0.
         
            *min_A < max_A < scale_zero < min_B < max_B*

        :param int scale_zero: Null speed value in the new scale.
        :returns: The speed value after being converted to the new 
         scale.
        :rtype: int
        """
        if self._scale is not 'linear':
            raise ValueError("Not a valid scale type: {}".format(self._scale))
        try:
            condition = (float(min_A) < float(max_A) < float(scale_zero)
                         < float(min_B) < float(max_B))
        except (ValueError, TypeError) as e:
            raise e
        if not (float(min_A) < float(max_A) < float(scale_zero)
                < float(min_B) < float(max_B)):
            raise ValueError("Not valid segment limits. "
                             "min_A < max_A < scale_zero < min_B < max_B")
        # Gets the value of the middle point
        zero_value = (self._max_value + self._min_value) / 2.0
        speed = self._speed
        # Numerators and denominators for the 2 options of the inequation
        num1 = (speed - zero_value) * (max_B - min_B)
        num2 = (speed - self._min_value) * (max_A - min_A)
        den1 = self._max_value - zero_value
        den2 = zero_value - self._min_value
        # Operations applied to values greater than zero_value
        speed[speed>zero_value] = (num1[speed>zero_value] / den1) + min_B
        # Operations applied to values smaller than zero_value
        speed[speed<zero_value] = (num2[speed<zero_value] / den2) + min_A
        # Zero values are turned to the new scale defined zero
        speed[speed == zero_value] = scale_zero
        self._speed = speed
        self._scale = 'non-linear'
        return self._speed

    def get_2WD_speeds(self, rho=0.065, L=0.150, wheels_modifiers=[1, 1]):
        """
        Obtain two speeds components, one for each side of the vehicle.
        
        It calculates the speed component for each side, when  the
        linear and angular velocities of the vehicle are given.
        The method also changes the maximum and minimum values.
        
        This calculus responds to the dynamics system proposed on: 
        http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5674957

        :param float rho: Parameter of the dynamic model, which 
         represents the vehicle's wheels diameter, in meters.
        :param float L: Parameter of the dynamic model, which represents
         the distance between the driving wheels of the vehicle.
        :param wheels_modifiers: It is intended to adjust
         the error between the ideal model and the real system. Thus, it
         corrects the performance difference between the 2 wheels. It is
         recommended to tune this values by testing them on the real 
         vehicle.
        :type wheels_modifiers: [float, float]           
        :returns: output value for the right and left wheels. Maximum 
         and minimum limits are modified proportionally to rho.
        :rtype: np.array([V_Right, V_Left])
        """
        self.rho = rho
        if self.get_format() is '2_wheel_drive':
            logger.info("The speed type is already '2_wheel_drive'.")
            return self.get_speed()
        vLinear = self._speed[0]
        vRotation = self._speed[1]
        # Extract and clip the 2 coefficients from the input list
        right_coef, left_coef = np.clip(wheels_modifiers, 0, 1)
        # Conversion of the linear speed range to the wheels angular speed.
        self._max_value /= rho
        self._min_value /= rho
        # Calculation of the 2 different values of the conversion matrix.
        term1 = (1 / rho) * vLinear
        term2 = (2 * rho * vRotation) / L
        # Calculates the raw velocity values.
        vR_raw = (term1 + term2) * right_coef
        vL_raw = (term1 - term2) * left_coef
        # Clips the raw velocities to avoid invalid values
        rl_speeds = np.clip([vR_raw, vL_raw], self._min_value, self._max_value)
        self.set_speed(rl_speeds, '2_wheel_drive')
        return self._speed
