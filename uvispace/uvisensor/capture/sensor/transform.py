#!/usr/bin/env python

import time 
import numpy as np


# Points operations

def center_of_mass(points):
    """Calculates the center of mass from the array of points."""
    xs, ys = points[:,0], points[:,1]
    return np.array([np.mean(xs), np.mean(ys)])

def center_of_bounding_box(points):
    """Calculates the center of the bounding box from the array of points."""
    min_x, min_y = min(points[:,0]), min(points[:,1])
    max_x, max_y = max(points[:,0]), max(points[:,1])
    return np.array([(max_x + min_x) / 2, (max_y + min_y) / 2])

def distance(point1, point2):
    """Calculates the distance between two points."""
    x1, y1, x2, y2 = point1[0], point1[1], point2[0], point2[1]
    return np.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))

def vertex_perimeter(vertex):
    """Calculates the perimeter of the polygon from the list of vertex."""
    dist = (vertex - np.vstack((vertex[1:], vertex[0])))**2
    dist = np.sqrt(dist[:,0] + dist[:,1])
    perimeter = sum(dist)
    return perimeter


# Points transformations

def points_to_global(points, width, height, k, quadrant):
    """Transforms points from local to global coordinates."""
    if np.all(points >= 0):
        points = k * points
        width, height = k * width, k * height
        if quadrant == 1:
            points[:,0] = points[:,0]
            points[:,1] = height - points[:,1] 
        elif quadrant == 2:
            points[:,0] = points[:,0] - width
            points[:,1] = height - points[:,1]
        elif quadrant == 3:
            points[:,0] = points[:,0] - width
            points[:,1] = 0 - points[:,1]            
        else:
            points[:,0] = points[:,0]
            points[:,1] = 0 - points[:,1]
    return points

def points_to_local(points, width, height, k, quadrant):
    """Transforms point from global to local coordinates."""
    points = points / k
    for i in range(len(points)):
        if points[i][0] > 0:
            if quadrant == 1 or quadrant == 4:
                points[i][0] = points[i][0]
            if quadrant == 2 or quadrant == 3:
                points[i][0] = width
        else:
            if quadrant == 1 or quadrant == 4:
                points[i][0] = 0
            if quadrant == 2 or quadrant == 3:
                points[i][0] = width + points[i][0]
        if points[i][1] > 0:
            if quadrant == 1 or quadrant == 2:
                points[i][1] = height - points[i][1]
            if quadrant == 3 or quadrant == 4:
                points[i][1] = 0
        else:
            if quadrant == 1 or quadrant == 2:
                points[i][1] = height
            if quadrant == 3 or quadrant == 4:
                points[i][1] = -points[i][1]  
#        if points[i][0] > width:
#            points[i][0] = width 
#        if points[i][1] > height:
#            points[i][1] = height
    return points

def transform_coordinates(box1, box2, points):
    point10, point11 = box1.astype(float)
    point20, point21 = box2.astype(float)
    scale = (point21 - point20) / (point11 - point10) 
    return scale * (points - point10) + point20

# Homography transformation

def get_homography(corners, targets):
    """Calculates the homography from 4 point pairs."""
    n = 4 # number of points
    if len(corners) == len(targets) == n:
        A = np.zeros((n * 2, 8))
        B = np.zeros((n * 2, 1))
        for i in range(n):
            x, y = corners[i]
            X, Y = targets[i]
            A[2*i][0:3] = [x, y, 1]
            A[2*i][6:8] = [-x * X, -y * X]
            A[2*i+1][3:6] = [x, y, 1]
            A[2*i+1][6:8] = [-x * Y, -y * Y]
            B[2*i] = X
            B[2*i+1] = Y
        h = np.linalg.lstsq(A, B)[0]
        H = np.array([[h[0][0], h[1][0], h[2][0]],
                      [h[3][0], h[4][0], h[5][0]],
                      [h[6][0], h[7][0], 1]])
        return H
    else:
        return None


# Calc of homographiy transformations
init = False
H1 = np.eye(3)
H2 = np.eye(3)
H3 = np.eye(3)
H4 = np.eye(3)
def init_homographies():
    global H1, H2, H3, H4
    # CAM1
    corners1 = [[381, 1944-657], [2109, 1944-669], [2097, 1944-1812], [375, 1944-1809]]
    targets1 = [[200, 1000], [1400, 1000], [1400, 200], [200, 200]]
    H1 = get_homography(corners1, targets1)
    print 'H1', H1
    # CAM2
    corners2 = [[684-2592, 1944-648], [2433-2592, 1944-663], [2424-2592, 1944-1818], [663-2592, 1944-1809]]
    targets2 = [[-1400, 1000], [-200, 1000], [-200, 200], [-1400, 200]]
    H2 = get_homography(corners2, targets2)
    print 'H2', H2
    # CAM3
    corners3 = [[660-2592, -435], [2382-2592, -465], [2358-2592, -1590], [642-2592, -1572]]
    targets3 = [[-1400, -200], [-200, -200], [-200, -1000], [-1400, -1000]] 
    H3 = get_homography(corners3, targets3)
    print 'H3', H3
    # CAM4
    corners4 = [[357, -441], [2103, -444], [2091, -1596], [369, -1596]] 
    targets4 = [[200, -200], [1400, -200], [1400, -1000], [200, -1000]] 
    H4 = get_homography(corners4, targets4)
    print 'H4', H4
    return True

def homography_global_point(x, y):
    global init
    global H1, H2, H3, H4
    if not init: 
        init = init_homographies()
    p = np.array([x, y, 1])
    if x >= 0 and y >= 0:
        H = H1
    elif x <= 0 and y >= 0:
        H = H2
    elif x <= 0 and y <= 0:
        H = H3
    else: #if x >= 0 and y <= 0:
        H = H4
    P = np.dot(H , p)
    return np.round([P[0] / P[2], P[1] / P[2]], decimals=2)
    #return np.round([P[0], P[1]], decimals=2)

def calibrated_points(points):
    pts = np.zeros(points.shape)
    for k in range(points.shape[0]):
        x, y = points[k,:]
        pts[k,:] = homography_global_point(x, y)
    return np.array(pts)

if __name__ == '__main__':
        
    window = np.array([[150, 50], [250,-150]])
    width, height = 2 * 648, 2 * 486
    
    win1 = points_to_local(window, width, height, 2, 3)
    win2 = points_to_global(win1, width, height, 2, 3)
    print 'Local 3:', win1
    print 'Global 3:', win2
    
    w1 = points_to_local(window, width, height, 2, 4)
    w2 = points_to_global(w1, width, height, 2, 4)
    print 'Local 4:', w1
    print 'Global 4:', w2 
    
    x_cm, y_cm = center_of_mass(w2)
    print 'Center of mass 4:', x_cm, y_cm
    #d = distance(corners[0], corners[2]) * 1.1
    #print 'Distance:', d
    
    print transform_coordinates(np.array([[-width, 0], [0, -height]]), np.array([[0, 0], [width/2, height/2]]), window)
    print transform_coordinates(np.array([[0, 0], [width, height]]), np.array([[width/2, height/2], [0, 0]]), window)
 
    # Homography transformation
    #corners = [[372, 1944-661], [2102, 1944-699], [2078, 1944-1853], [348, 1944-1887]] # CAM1
    #corners = [[688-2592, 1944-675], [2424-2592, 1944-691], [2425-2592, 1944-1856], [658-2592, 1944-1842]] # CAM2
    #corners = [[102-2592, -507], [1793-2592, -506], [1797-2592, -1642], [650-2592, -1637]] # CAM3
    corners = [[386, -428], [2116, -437], [2112, -1591], [388, -1579]] # CAM4
    #targets = [[400, 800], [1600, 800], [1600, 0], [400, 0]] # CAM1
    #targets = [[-1200, 800], [0, 800], [0, 0], [-1200, 0]] # CAM2
    #targets = [[-1600, -400], [-400, -400], [-400, -1200], [-1200, -1200]] # CAM3
    targets = [[400, -400], [1600, -400], [1600, -1200], [400, -1200]] # CAM4
    H = get_homography(corners, targets)
    print H
    p = np.array([2490, 211, 1])
    P = np.dot(H , p)
    print P
    print np.round(P[0]), np.round(P[1])
    
    #import cv2.cv as cv   
       
    #filename = 'img/left01.jpg'        
    
    # Projective transformation
    #width, height = 400, 250
    #corners = [(171,72),(331,93),(333,188),(177,210)]
    #targets = [(0,0),(width,0),(width,height),(0,height)]

    #image = cv.LoadImageM(filename)
    #mat = cv.CreateMat(3, 3, cv.CV_32F)
    #cv.GetPerspectiveTransform(corners, targets, mat) 
    #out = cv.CreateMat(height, width, cv.CV_8UC3)
    #cv.WarpPerspective(image, out, mat, cv.CV_INTER_CUBIC)
    #cv.SaveImage('test.jpg', out)
    
    #print np.dot(np.asarray(mat), p)
    #print np.dot(get_homography(corners, targets), p)
    
    print homography_global_point(-870, -407)
    print homography_global_point(357, -441)
    p1 = homography_global_point(2592, 1944)
    p2 = homography_global_point(-2592, 1944)
    p3 = homography_global_point(-2592, -1944)
    p4 = homography_global_point(2592, -1944)
    print p1 - p2, p3 - p2, p4 - p2
    
    

    