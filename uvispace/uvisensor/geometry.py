#!/usr/bin/env python
#Standard libraries
import numpy as np
"""
This module contain classes and methods focused on geometry operations.

It works with 2-D shapes represented by arrays. Thus, the calculations
are based on matricial operations and linear algebra. 
"""

class Triangle(object):
    def __init__(self, vertices):
        self.vertices = vertices.astype(np.float32)
        #The barycenter X is equal to the sum of the X coordinates divided by 3
        self.barycenter = self.vertices.sum(axis=0) / 3
        self.sides = np.zeros([3])
        self.base_index = None
        self.midpoint = np.array([])
        self.angle = None
        self.window = np.array([])
        self.contours = []

    def get_pose(self):
        """
        Return triangle's angle and base midpoint, given its vertices.

        The coordinates of 3 vertices defining the triangle are used,
        packed in a single 3x2 array. This method asumes that the
        triangle is isosceles and the 2 equal sides are bigger than 
        the different one, called base.
        
        Returns
        -------
        midpoint[0] : float32
            X coordinate of the midpoint of the triangle's base side.

        midpoint[1] : float32
            Y coordinate of the midpoint of the triangle's base side.

        angle : float32
            Orientation angle of the triangle. It is the resulting angle
            between the horizontal axis and the segment that goes from 
            the triangle's midpoint to the frontal vertex. It is 
            expressed in radians, in the range [-pi, pi]
        """
        vertices = self.vertices.astype(np.float32)
        #Calculate the length of the sides i.e. the Euclidean distance
        self.sides[0] = np.linalg.norm(vertices[2] - vertices[1])
        self.sides[1] = np.linalg.norm(vertices[0] - vertices[2])
        self.sides[2] = np.linalg.norm(vertices[1] - vertices[0])
        #If 2 sides are equal, the common vertex is the front one and 
        #The base midpoint is calculated with the other 2.
        self.base_index = np.argmin(self.sides)
        self.midpoint = (vertices[self.base_index-1]
                         + vertices[self.base_index-2]) / 2
        row, col = vertices[self.base_index] - self.midpoint
        #The array 'y'(rows) counts downwards, contrary to cartesian system.
        self.angle = np.arctan2(-row, col)
        return self.midpoint[0], self.midpoint[1], self.angle

    def get_window(self, k=1.25):
        """
        Get the coordinates of a rectangle window around the triangle.
        
        At first, the barycenter of the triangle is calculated. Then, 
        the window is calculated as a rectangle with its sides k times
        the longest side further from the 
        barycenter.
        
        Returns
        -------
        self.window : 2x2 NumPy array
            array representing a square parallel to the horizontal 
            coordinates axe. The first row contains the X and Y minimum
            values of the square, and the second row contains the X and 
            Y maximum values of the square.
        """
        distance = self.sides.max() * k
        self.window = np.array([self.barycenter - distance, 
                                self.barycenter + distance])
        return self.window




