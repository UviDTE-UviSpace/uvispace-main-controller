#!/usr/bin/env python
#Standard libraries
import numpy as np
"""
This module contain classes and methods focused on geometry operations.

It works with 2-D shapes represented by arrays. Thus, the calculations
are based on matricial operations and linear algebra. 
"""

class Triangle(object):
    """
    Class for dealing with geometric operations refered to a triangle.
    """
    def __init__(self, vertices, isglobal=False, cartesian=False):
        """
        Triangle class constructor.

        Parameters
        ----------
        vertices : 3x2 array
            Array containing the vertices coordinates of the triangle 
            object.

        isglobal : boolean
            Flag that indicates if the coordinate system refers to the 
            4-quadrant system (global) or to a single quadrant system.
        """
        if len(vertices) is not 3:
            raise ValueError("Expected an array with 3 vertices")
        self.vertices = vertices.astype(np.float32)
        #These flags indicate the coordinates system that is being used
        self.isglobal = isglobal
        self.cartesian = cartesian
        #The barycenter X is equal to the sum of the X coordinates divided by 3.
        self.barycenter = self.vertices.sum(axis=0) / 3
        self.sides = np.zeros([3])
        #base_index is the identifier for the base side in 'sides' array.
        self.base_index = None
        self.midpoint = np.array([])
        self.angle = None
        self.window = np.array([])
        self.contours = []
        #Scale ratio for converting pixel coordinates to millimetres.
        self._scale = 1

    def __str__(self):
        return ("Triangle\n{}".format(self.vertices))

    def __repr__(self):
        return ("Triangle\n{}".format(self.vertices))

    def get_local2global(self, offsets, K=None, image2cartesian=True):
        """
        Convert Triangle coordinates to the global coordinates system.

        The function performs 2 transformations:

        * Obain the 4-quadrant coordinates. The input is a coordinate 
        for a 1-quadrant system, and the output corresponds to the 
        4-quadrant system.
        * Move y-axis origin. Initially, for a given image the origin
        is placed at its top. However, for the used system the origin 
        is placed at the middle of the 4 quadrants.

        If indicated, the coordinates system will be transformed to the
        cartesian one. This is recommended, as the image system does not
        make sense for a space with origin in the middle.

        Only absolute coordinates shall be transformed. Lengths and 
        angles are invariant to the coordinate origin.

        Finally, a scale ratio will be applied to the coordinates. The 
        coordinates will be directly multiplied byy the K constant.

        Parameters
        ----------
        offsets[row_offset, col_offset] : 2-integer list
            column and row offsets between the local and the global 
            systems.

        K : positive int or float
            Scale ratio that will be applied to the points coordinates.

        image2cartesian : boolean
            If this flag is set to True, a conversion from image 
            coordinate system to cartesian system is performed. Thus, 
            the output will be of the form of [x,y] instead of 
            [row,column]
        """
        if self.isglobal:
            return
        #Assess K and assign value to 'scale' attribute if it is valid.
        if K is None:
            K = self._scale
        elif K <= 0:
            raise ValueError("The scale ratio K must be greater than 0")
        else:
            self._scale = K
        self.vertices[:,0] = offsets[0] - self.vertices[:,0]
        self.vertices[:,1] -= offsets[1]
        self.vertices *= self._scale
        self.barycenter[0] = offsets[0] - self.barycenter[0]
        self.barycenter[1] -= offsets[1]
        self.barycenter *= self._scale
        #If the pose was not previously calculated, 
        #a ValueError is catched and ignored.
        try:
            self.midpoint[0] = offsets[0] - self.midpoint[0]
            self.midpoint[1] -= offsets[1]
            self.midpoint *= self._scale
        except IndexError:
            pass
        if image2cartesian:
            #Convert the vertices coordinates
            tmp = np.copy(self.vertices[:,0])
            self.vertices[:,0] = self.vertices[:,1]
            self.vertices[:,1] = tmp
            #Convert the barycenter coordinates
            tmp = np.copy(self.barycenter[0])
            self.barycenter[0] = self.barycenter[1]
            self.barycenter[1] = tmp
            #Convert the midpoint coordinates
            try:
                tmp = np.copy(self.midpoint[0])
                self.midpoint[0] = self.midpoint[1]
                self.midpoint[1] = tmp
            except IndexError:
                pass
            self.cartesian = True
        self.isglobal = True

    def get_global2local(self, offsets):
        """
        Convert Triangle coordinates to the local coordinates system.
        
        Only absolute coordinates shall be transformed. Lengths and 
        angles are invariant to the coordinate origin.
        
        Parameters
        ----------
        offsets[row_offset, col_offset] : 2-integer list
            column and row offsets between the local and the global 
            systems.
        """
        if not self.isglobal:
            return
        self.vertices -= offsets
        self.barycenter -= offsets
        try:
            self.midpoint -= offsets
        except ValueError:
            pass
        self.isglobal = False

    def get_pose(self):
        """
        Return triangle's angle and base midpoint, given its vertices.

        The coordinates of 3 vertices defining the triangle are used,
        packed in a single 3x2 array. This method asumes that the
        triangle is isosceles and the 2 equal sides are bigger than 
        the different one, called base.

        The following attributes are updated:

        * self.sides : array containing the lengths of the 3 sides.
        * self.base_index : array index of the minor side. This is also
        the index of the vertex between the 2 mayor sides, as vertices
        indexes are the indexes of their opposite sides.

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
        #Calculus of the x and y distance between the midpoint and the vertex
        #opposite to the base side.
        if self.cartesian:
            x, y = vertices[self.base_index] - self.midpoint
        else:
            #The array 'y'(rows) counts downwards, contrary to cartesian system.
            row, col = vertices[self.base_index] - self.midpoint
            x, y = col, -row
        self.angle = np.arctan2(y, x)
        return self.midpoint[0], self.midpoint[1], self.angle

    def get_window(self, min_value, max_value, k=1.25):
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

        min_value : integer or 2x1 array
            value or values of the minimum allowed coordinates.
            
        max_value : integer or 2x1 array
            value or values of the maximum allowed coordinates.
        """
        distance = self.sides.max() * k
        window = np.array([self.barycenter - distance, 
                           self.barycenter + distance])
        self.window = np.clip(window, min_value, max_value)
        return self.window

    def homography(self, H):
        """
        Perform an homography operation to the Triangle vertices.

        The homography is a geometrical tranformation that obtains the 
        projection of certain points from a plain to another.

        Parameters
        ----------
        H : 3x3 np.array
            Homography matrix
        """
        points = np.copy(self.vertices)
        #Loop for performing the homography to very 2-D vertex' coordinates.
        for index, row in enumerate(points):
            #Append '1' to the point vector and perform a matrix product with H.
            operand = np.hstack([row, 1])
            product = np.dot(H , operand)
            new_point = product[0:2] / product[2]
            points[index] = new_point
        self.vertices = np.copy(points)
        return self.vertices   

    def in_borders(self, limits, tolerance=150):
        """Evaluate if vertices are near a 4-sides polygon perimeter.

        Parameters
        ----------
        limits : iterable of length 4
            Array containing the coordinates of the 4 points defining 
            the borders of the working space.

        tolerance : int or float
            Maximum allowed distance (mm) to the limits to be considered 
            within the borders region.
        """
        for index in range(len(limits)):
            #Define a segment with 2 limit points of the quadrant.
            seg = Segment(limits[index], limits[index-1])
            #Evaluate each vertex of the triangle.
            for vertex in self.vertices:
                #Get the distance in mm to the segment.
                dist = seg.distance2point(vertex)
                #Evaluate if the vertex is closer than the tolerance.
                if dist < tolerance:
                    return True
        #If any of the vertices wasn't near to any of the segments return False.
        return False


class Segment(object):
    """
    This class contains methods for dealing with 2D segments operations.
    """
    def __init__(self, pointA, pointB):
        """Define the segment basic attributes.

        Parameters
        ----------
        pointA, pointB : 2 elements tuple or list
            X and Y coordinates of the initial and end points defining
            the segment.
        """
        self.pointA = np.array(pointA)
        self.pointB = np.array(pointB)
        #Get the segment modulus for further operations.
        self.modulus = np.linalg.norm(self.pointA - self.pointB)

    def distance2point(self, point):
        """
        Return the distance of a point to the nearest segment point.

        The calculus is based on the dot (scalar) product. The
        perpendicular projection of a first vector on a second one is
        the dot product the 2 vectors divided by the modulus of the 
        second:
            A.B = |A||B|cos(alpha)
            being |A|cos(alpha) the projection of A on B

        If the projection is less than 0, it implies that the point is
        left to the first point (as cos(alphha) is negative), being this
        first point the nearest one to the target point. 
        Moreover, if the projection is greter than the modulus of the
        segment, it implies that the target point is is right to the end
        point, being this the nearest one.

        Finally, the the distance to the segment is obtained and 
        returned using the Pitagoras' theorem.

        Parameters
        ----------
        point : 2-elements tuple or list
        """
        #target point and Segment's final point coordinates referred to the
        #initial point. Needed for the dot product.
        vector1 = self.pointB - self.pointA
        vector2 = point - self.pointA
        #Distance from pointA to the projection of vector2 on vector1.
        projection = np.dot(vector1, vector2) / self.modulus
        #Case that target point is minor that pointA
        if projection <= 0:
            distance = np.linalg.norm(vector2)
        #Case that target point is greater that pointB
        elif projection >= self.modulus:
            distance = np.linalg.norm(point - self.pointB)
        #Case that target point is between pointA and pointB
        else:
            #Pithagoras theorem for getting the leg of a right-angled triangle.
            distance = np.sqrt((vector2**2).sum() - projection**2)
        return distance





