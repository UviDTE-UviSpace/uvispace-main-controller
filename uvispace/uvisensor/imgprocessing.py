#!/usr/bin/env python
"""This module contain a class with image processing methods."""
#Standard libraries
import cv2
import logging
import numpy as np
from scipy import ndimage
import skimage.measure
import skimage.morphology

class Image(object):
    """Class with image processing methods oriented to UGV detection."""
    def __init__(self, image):
        self.image = image
        self._binarized = None
        self.corners_list = []
        self.contours = []

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
        #A simple erosion gets rid of the whole noise. Dilating the eroded image 
        #several times provides an acceptable ROI for the binary mask.
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

    def get_vertices(self, tolerance=5):
        """
        For each shape on the binarized image, returns its vertices.

        The shape is obtained using the marching cubes algorithm.
        Once obtained, the vertices are calculated using the 
        Ramer-Douglas-Peucker algorithm. Both are implemented on the 
        skimage library, and there is more information on its docs.

        Parameters
        ----------
        tolerance : float
            minimum distance between an observed pixel and the previous
            contour pixels required to add the first one to the vertices
            list.

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
        self.contours = []
        contours_list = skimage.measure.find_contours(self._binarized, 200)
        #Get the vertices of each shape in the image.
        for cnt in contours_list:
            coords = skimage.measure.approximate_polygon(cnt, tolerance)
            #The initial vertex is repeatead at the end. Thus, if len is 2
            #it implies a single point polygon. If len is 3 implies a line.
            if len(coords) > 2:
                self.contours.append(coords[1:])
            logging.debug("A {}-vertices shape was found".format(len(coords)))
        return self.contours

    @staticmethod 
    def get_triangle_position(vertices):
        """Return the angle and the front vertex of the triangle.
        
        The input are the coordinates of 3 vertices defining a triangle,
        packed in a single 3x2 array.
        The returned angle is expressed in radians, in the range 
        [-pi, pi]"""
        vertices = vertices.astype(np.float32)
        #Calculate the length of the sides i.e. the Euclidean distance
        side_A = np.linalg.norm(vertices[0] - vertices[1])
        side_B = np.linalg.norm(vertices[0] - vertices[2])
        side_C = np.linalg.norm(vertices[1] - vertices[2])
        #If 2 sides are equal, the common vertex is the front one and 
        #The base midpoint is calculated with the other 2.
        import pdb; pdb.set_trace()
        if side_A == side_B:
            midpoint = (vertices[1]+vertices[2]) / 2
            x, y = vertices[0] - midpoint
            angle = np.arctan2(x, y)
        elif side_B == side_C:
            midpoint = (vertices[0]+vertices[1]) / 2
            x, y = vertices[2] - midpoint
            angle = np.arctan2(x, y)
        else:
            midpoint = (vertices[0]+vertices[2]) / 2
            x, y = vertices[1] - midpoint
            angle = np.arctan2(y, x)
        return midpoint[0], midpoint[1], angle    

#    def get_corners(self):
#        """Locates the boundary corners of shapes in the image.
#        
#        This algorithm assume 8-connectivity. So the connected
#        components labeling operator scans the image and examines the
#        four neighbors (west, north, north-west and north-east) of the
#        point which have already been encountered.
#        """
#        width, height = self._binarized.shape[1], self.image.shape[0]
#        img = np.zeros((height, width), dtype=np.uint8)
#        label = 0
#        max_label = 0
#        sizes = [0]
#        corners = [np.zeros([8, 2])]
#        for y in range(1, height):
#            for x in range(1, width - 1):
#                if self._binarized[y,x]:
#                    size = 0
#                    corner = np.array([[width, height], # left2
#                                    [width, height], # left1
#                                    [width, height], # top1
#                                    [width, height], # top2
#                                    [0, 0], # right1
#                                    [0, 0], # right2
#                                    [0, 0], # bottom2
#                                    [0, 0]]) # bottom1  
#                    # Labeling
#                    west = img[y,x-1]
#                    north_west = img[y-1,x-1]
#                    north = img[y-1,x]
#                    north_east = img[y-1,x+1]
#                    if west:
#                        label = west
#                    elif north_west:
#                        label = north_west
#                    elif north:
#                        label = north
#                    elif north_east:
#                        label = north_east
#                    else:
#                        label = max_label + 1
#                        max_label = label
#                        sizes.append(size)
#                        corners.append(corner)
#                    img[y,x] = label
#                    # Connected
#                    if north_east and (north_east != label):
#                        size = sizes[north_east]
#                        sizes[north_east] = 0
#                        corner = corners[north_east]
#                    # Corners
#                    if label:
#                        sizes[label] = sizes[label] + size + 1
#                        if corners[label][0,0] >= x: # left2
#                            corners[label][0] = x, y
#                        if corners[label][1,0] > x: # left1
#                            corners[label][1] = x, y
#                        if corners[label][2,1] > y: # top1
#                            corners[label][2] = x, y
#                        if corners[label][3,1] >= y: # top2
#                            corners[label][3] = x, y
#                        if corners[label][4,0] < x: # right1
#                            corners[label][4] = x, y
#                        if corners[label][5,0] <= x: # right2
#                            corners[label][5] = x, y
#                        if corners[label][6,1] <= y: # bottom2
#                            corners[label][6] = x, y
#                        if corners[label][7,1] < y: # bottom1
#                            corners[label][7] = x, y
#                        # Adds corners of connected components 
#                        if corners[label][0,0] > corner[0,0]:
#                            corners[label][0] = corner[0]    
#                        if corners[label][1,0] > corner[1,0]:
#                            corners[label][1] = corner[1] 
#                        if corners[label][2,1] > corner[2,1]:
#                            corners[label][2] = corner[2]    
#                        if corners[label][3,1] > corner[3,1]:
#                            corners[label][3] = corner[3] 
#                        if corners[label][4,0] < corner[4,0]:
#                            corners[label][4] = corner[4] 
#                        if corners[label][5,0] < corner[5,0]:
#                            corners[label][5] = corner[5]
#                        if corners[label][6,1] < corner[6,1]:
#                            corners[label][6] = corner[6]
#                        if corners[label][7,1] < corner[7,1]:
#                            corners[label][7] = corner[7]
#        sort_indexes = np.argsort(np.array(sizes))
#        for sort_index in sort_indexes[::-1]:
#            if sizes[sort_index] > 75:
#                v = np.vstack((corners[sort_index][1:], 
#                               corners[sort_index][0]))
#                D = sum(corners[sort_index][:,0] * v[:,1])
#                I = sum(corners[sort_index][:,1] * v[:,0])
#                area = abs(D - I) / 2
#                if sizes[sort_index] > 0.7 * area:
#                    self.corners_list.append(corners[sort_index])
#            else:
#                break
#        return self.corners_list


