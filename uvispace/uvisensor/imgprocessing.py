#!/usr/bin/env python
"""This module contain a class with image processing methods."""
#Standard libraries
import cv2

class Image(object):
    """Class with image processing methods oriented to UGV detection."""
    def __init__(self, image):
        self.image = image
        self._binarized = None

##Deprecated method. Pending acclarations
#    def get_threshold(self, thresholds):
#        #Get thresholds
#        MASK = int('1111111111', 2)
#        Th_min, Th_max = thresholds
#        #Get minimum threshold components
#        red_c_min = (Th_min >> 20) & MASK
#        green_c_min = (Th_min >> 10) & MASK
#        blue_c_min = Th_min & MASK
#        #Get maximum threshold components
#        red_c_max = (Th_max >> 20) & MASK
#        green_c_max = (Th_max >> 10) & MASK
#        blue_c_max = Th_max & MASK
#        
#        thr_min = pylab.array((red_c_min, green_c_min, blue_c_min),
#                               dtype=pylab.int16)
#        thr_max = pylab.array((red_c_max, green_c_max, blue_c_max), 
#                               dtype=pylab.int16)
#        
#        self.thr_min = thr_min /4
#        self.thr_max = thr_max /4
#        return thr_min, thr_max
        
    def binarize(self, thresholds):
        """Get a binarized image from a grey image given the thresholds.
        
        The input image can only have one dimension. This method is 
        intended to work with 3-component threshold values stored in a
        30-bit register:
        
            * register[0 to 10] : red component thresholds
            * register[10 to 20] : green component thresholds
            * register[10 to 30] : blue component thresholds
        
        Parameters
        ----------
        thresholds : 2-element list or tuple
            minimum and maximum values betweeen whom the image intensity
            values will be accepted as 1 (or 255). Values greater than 
            the maximum and smaller than the minimum will be truncated
            to 0.
        
        Returns
        -------
        bin_image : binary MxN numpy array
            Image of the same size as the input image with only 255 or 0
            values (Equivalent to 1 and 0), according to the input 
            threshold values.
        """
        #Obtain the thresholds in base 2.
        th_min = bin(thresholds[0])
        th_max = bin(thresholds[1])
        #The 3-color components are packed in a single 30-bit value.
        #The 30-bit value has to be sliced for getting a single component.
        red_c = (th_min[-30:-20], th_max[-30:-20])
        #Why is it neccesary to divide by 4??
        thr_min = int(red_c[0], 2) / 4
        thr_max = int(red_c[1], 2) / 4
        self._binarized = cv2.inRange(self.image, thr_min, thr_max)
        return self._binarized
        



