#!/usr/bin/env python
"""This module contain classes with image processing methods.

Notes
-----
A point array is written by convention in the form 
[row, column]. In a cartesian system, the points are expressed
as (x,y). Finally, in an image representation (viewer), the typical is 
to display points coordinates as  (x', y'). They equivalences are the 
following:

* x = x' = column
* y = -y' = -row

Thus, special care has to be taken when dealing with operations in 
different scopes e.g. trigonometric operations will be handled with the 
cartesian values, while image operations are normally performed with the
array convention. Finally, when sending the array values to a viewer or 
to an external device, the image representation mentioned above is 
the typical coordinates system used.
"""
#Standard libraries
import cv2
import logging
import numpy as np
from scipy import ndimage
import skimage.measure
import skimage.morphology

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



class Image(object):
    """Class with image processing methods oriented to UGV detection."""
    def __init__(self, image=None, contours=None):
        self.image = image
        self._binarized = None
        self.triangles = []
        self.contours = contours

    def binarize(self, thresholds):
        """Get a binarized image from a grey image given the thresholds.
        
        The input image can only have one dimension. This method is 
        intended to work with 3-component threshold values stored in a
        single 30-bit register:
        
            * register[0 to 10] : red component thresholds
            * register[10 to 20] : green component thresholds
            * register[10 to 30] : blue component thresholds
            
        The raw binary image contains plenty of noise. As it is very low
        around the triangle, a mask around it is used to get rid of the 
        rest of the noise.
        
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
        #Obtain the thresholds in base 2 and get the red component slice.
        th_min = bin(thresholds[0])
        th_max = bin(thresholds[1])
        red_c = (th_min[-30:-20], th_max[-30:-20])
        #Why is it neccesary to divide by 4??
        thr_min = int(red_c[0], 2) / 4
        thr_max = int(red_c[1], 2) / 4
        logging.debug("Thresholding between {} and {}".format(thr_min, thr_max))
        #The first binary approach is obtained evaluating 2 thresholds
        raw_binarized = cv2.inRange(self.image, thr_min, thr_max)
        #A simple erosion gets rid of the whole noise. Dilating the eroded  
        #image several times provides an acceptable ROI for the binary mask.
        kernel = np.ones((5,5),np.uint8)
        erosion = cv2.erode(raw_binarized, kernel, iterations=1)
        kernel = np.ones((5,5),np.uint8)
        dilate = cv2.dilate(erosion,kernel,iterations = 5)
        mask = dilate / 255
        filtered = raw_binarized * mask
        #Eliminate holes inside the detected shapes
        labels = skimage.morphology.label(filtered)
        label_count = np.bincount(labels.ravel())
        #Detect the background pixels, assuming they are majority in the image.
        background = np.argmax(label_count)
        self._binarized = filtered
        self._binarized[labels != background] = 255
        logging.debug("Image binarization finished")
        return self._binarized

    def get_shapes(self, tolerance=5, get_contours=True):
        """
        For each shape on the binarized image, returns its vertices.

        The shape is obtained using the marching cubes algorithm.
        Once obtained, the vertices are calculated using the 
        Ramer-Douglas-Peucker algorithm. Both are implemented on the 
        skimage library, and there is more information on its docs.
        
        if the kwarg get_contours if False, it is assumed that the 
        contours are already known (stored in variable self.contours). 
        If this is the case, the marching cubes algorithm is omitted.

        Parameters
        ----------
        tolerance : float
            minimum distance between an observed pixel and the previous
            contour pixels required to add the first one to the vertices
            list.
        
        get_contours : bool, True as default
            Specify if the marching cubes algorithm is applied to the 
            binarized image. Specifically set to False when the 
            binarization algorithm is implemented in the external 
            device (e.g. an FPGA).

        Returns
        -------
        self.contours : N-length list
            list containing the vertices of the N shapes detected on the
            image. each element contains an Mx2 NumPy array with the 
            coordinates of the M vertices of the shape.
        """
        logging.debug("Getting the shapes' vertices in the image")
        #Obtain a list with all the contours in the image, separating each
        #shape in a different element of the list
        if get_contours:
            self.contours = skimage.measure.find_contours(self._binarized, 200)
        self.triangles = []
        #Get the vertices of each shape in the image.
        for cnt in self.contours:
            coords = skimage.measure.approximate_polygon(cnt, tolerance)
            #The initial vertex is repeatead at the end. Thus, if len is 2
            #it implies a single point polygon. If len is 3 implies a line.
            if len(coords) == 4:
                triangle = Triangle(coords[1:])
                self.triangles.append(triangle)
            logging.debug("A {}-vertices shape was found".format(len(coords)))
        return self.triangles


        



