#!/usr/bin/env python 
import numpy as np

class Speed(object):
    """
    This class manages the speed values compatible with a 2WD vehicle.
    
    An initial speed value must be provided. Default speed format is 
    linear_angular. This means that the speed is a 2-value array, whose
    items corresponds to the linear and angular speed respectively.
    """    
    # Available speed formats
    SPEEDFORMATS = ('linear_angular', '2_wheel_drive')
    SPEEDSCALES = ('linear', 'non-linear')
    
    def __init__(self, speed, min_value=-0.3, max_value=0.3,
                 spd_format='linear_angular'):
        self._min_value = min_value
        self._max_value = max_value
        self._speed = np.array([None, None])
        self._format = None
        self._scale = 'linear'
        
        self.rho = None
        #Calls the set_speed method to initialize the format and speed 
        #attributes.
        self.set_speed(speed, spd_format)
        
    def set_speed(self, speed, speed_format, speed_scale='linear'):
        """Sets the speed value.
        
        Input speed must be a 2-value list or tupple. If out of bounds, 
        it will be rounded to the nearest bound.
        """
        s = np.array([None, None])
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
        self.check_bounds()
        self._set_format(speed_format)
        self._set_scale(speed_scale)
    
    def get_speed(self):
        """Returns the value of the speed."""
        return self._speed
                
    def check_bounds(self):
        """Checks that the speed values are inside valid bounds."""
        if self._scale == 'linear':
            for index, value in enumerate(self._speed):
                if (self._speed[index] < self._min_value):
                    self._speed[index] = self._min_value
                elif (self._speed[index] > self._max_value):
                    self._speed[index] = self._max_value
        if self._scale == 'non-linear':
            pass
            #Checks if the speed value is in segmentA or segmentB.
        return self._speed

    def _set_format(self, new_format):
        """Sets the format of the speed.
        
        Available values : 
        ----------------
        linear_angular : [vL, vR]
            vL corresponds to the linear velocity and vR corresponds to
            the angular velocity
            
        2_wheel_drive : [v_right, v_left]
            v_right corresponds to the velocity of the right wheel and 
            v_left corresponds to the velocity of the left wheel.
        """
        if not new_format in self.SPEEDFORMATS:
            raise ValueError("Not a valid format type: {}".format(new_format))
        if (self._format is '2_wheel_drive' and new_format is 'linear_angular'):
            self._max_value *= self.rho
            self._min_value *= self.rho
        self._format = new_format
        
    def get_format(self):
        """Returns the format value."""
        return self._format
        
    def _set_scale(self, new_scale):
        """Sets the scale of the speed.
        
        Available values : 
        ----------------
        'linear'
            
        'non-linear'
        """
        if not new_scale in self.SPEEDSCALES:
            raise ValueError("Not a valid scale type: {}".format(new_scale))
        self._scale = new_scale
                
    def get_scale(self):
        """Returns the scale value."""
        return self._scale

    def linear_transform(self, new_min, new_max):
        """Changes the range of values of the speed.
        
        This is a linear conversion of the speed values.
        """
        if self._scale is not 'linear':
            raise ValueError("Not a valid scale type: {}".format(self._scale))
        num = (self._speed - self._min_value) * (new_max - new_min)
        den = self._max_value - self._min_value
        new_value = (num/den) + new_max
        self.set_speed(new_value)
        return new_value
        
    def nonlinear_transform(self, min_A=30, max_A=100,
                                  min_B=160, max_B=220):
        """ 
        Makes a non-linear conversion of speed values.
        
        Intended to avoid useless points near to 0 on a real UGV, it
        translates the input speeds to useful segments.
        
        The previous scale has to be linear.
        
        A characterization of the UGV should be done before performing 
        this rescalation.
        
        Transformation
        --------------
        The values range is divided into 2 equal segments (segment A and
        segment B). If the value belongs to segment A, it will be 
        rescalated between min_A and max_A values. On the contrary, if 
        it belongs to segment B it is rescalated between min_B and 
        max_B. The mid value is assigned to 0.
        
                  min_value                max_value
                      |------------|-----------|         
                       segment A      segment B
                          
                                   
        min_A             max_A   127   min_B             max_B
          |-----------------|      |      |-----------------|
        
        Parameters
        ----------
        value : int or float
            value to be transformed into the nonlinear space
            
        min_A, max_A, min_B, max_B : int or float
            limit values for the segments A and B. The transformed
            values will belong to one of the 2 intervals and 0.
            min_A < max_A < 0 < min_B < max_B
        """
        if self._scale is not 'linear':
            raise ValueError("Not a valid scale type: {}".format(self._scale))
        if not (min_A < max_A < min_B < max_B):
            raise ValueError("Not valid segment limits. \
                              min_A < max_A < min_B < max_B")
        #Gets the value of the middle point
        zero_value = (self._max_value + self._min_value) / 2.0
        speed = self._speed
        #Numerators and denominators for the 2 options of the inequation
        num1 = (speed - zero_value) * (max_B - min_B)
        num2 = (speed - self._min_value) * (max_A - min_A)
        den1 = self._max_value - zero_value
        den2 = zero_value - self._min_value
        #Operations applied to values greater than zero_value
        speed[speed>zero_value] = (num1[speed>zero_value] / den1) + min_B
        #Operations applied to values smaller than zero_value
        speed[speed<zero_value] = (num2[speed<zero_value] / den2) + min_A
        #Zero values are turned to 0
        speed[speed==zero_value] = (max_A + min_B) / 2
        self._speed = speed
        self._scale = 'non-linear'
        return self._speed
        
    def get_2WD_speeds(self, rho=0.065, L=0.150):
        """
        Obtains two speeds components, one for each side of the vehicle.
        
        It calculates the speed component for each side, when  the
        linear and angular velocities of the vehicle are given.
        The calculation changes as well the maximum and minimum values.
        
        This calculus responds to the dynamics system proposed on: 
        http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5674957
        
        Parameters
        ----------
        vLinear : int or float
            value of the linear speed of the vehicle.

        vRotation : int or float
            value of the angular speed of the vehicle.

        rho : float 
            Parameter of the dynamic model, which represents the vehicle's 
            wheels diameter, in meters.

        L : float
            Parameter of the dynamic model, which represents the distance 
            between the driving wheels of the vehicle. 
            
        Returns
        -------
        rl_speeds[] : 0 to 255 int 2-element np.array()
            output value for the right and left wheels.
            0 corresponds to max speed at reverse direction.
            255 corresponds to max speed at direct direction.
            127 corresponds to null speed.            
        """
        self.rho = rho
        if self.get_format() is '2_wheel_drive':
            print "The speed type is already '2_wheel_drive'."
            return self.get_speed()
        vLinear = self._speed[0]
        vRotation = self._speed[1]
        #Conversion of the linear speed range to the wheels angular speed.
        self._max_value /= rho
        self._min_value /= rho
        #Calculation of the 2 different values of the conversion matrix.
        term1 = (1 / rho ) * vLinear
        term2 = (2 * rho * vRotation) / L    
        #Calculates the raw velocity values.
        vR_raw = term1 + term2
        vL_raw = term1 - term2
        #Clips the raw velocities to avoid invalid values
        rl_speeds = np.clip([vR_raw, vL_raw], self._min_value,
                                              self._max_value)
        self.set_speed(rl_speeds, '2_wheel_drive')
        return self._speed

