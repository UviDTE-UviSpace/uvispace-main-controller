#!/usr/bin/env python

import time 
from pylab import *
from PIL import Image

import calibrate
import transform
import pimage

try:
    from zedboard import pose
except:
    print 'ERROR loading Zedboard peripheral.'
    pose = None

#------------------------------------------------------------------------------ 

def get_furthest_point(points, point):
    """Returns the furthest point in the list of points that is furthest of point."""
    differences = point - points
    distances = differences[:,0] * differences[:,0] + differences[:,1] * differences[:,1]
    furthest_point = points[argmax(distances)]
    return furthest_point

def get_line_from_points(point1, point2):
    """Returns the parameters of the line defined by point1 and point2."""
    # Line's equation y(x) = m x + b
    x1, y1, x2, y2 = point1[0], point1[1], point2[0], point2[1]
    m = float(y2 - y1) / (x2 - x1)
    b = y1 - m * x1
    return m, b

def get_furthest_point_from_line(points, line):
    """Returns a point, which is the furthest away from the specified line."""
    furthest_point = points[0]
    m, b = line
    div = sqrt(m * m + 1)
    distance = 0
    for point in points:
        x, y = point
        dist = abs(m * x + b - y) / div
        if dist > distance:
            distance = dist
            furthest_point = point
    return furthest_point, distance

def get_furthest_point_from_points(points, point1, point2):
    """Returns a point, which is the furthest away from the specified points."""
    furthest_point = points[0]
    min_dist = sum((point2 - point1) * (point2 - point1)) / 9
    max_dist = 0
    for point in points:
        d1 = sum((point1 - point) * (point1 - point))
        d2 = sum((point2 - point) * (point2 - point))
        if d1 > min_dist and d2 > min_dist:
            dist = d1 + d2
            if dist > max_dist:
                max_dist = dist
                furthest_point = point
    return furthest_point, max_dist

def get_distance_from_line(point, line):
    """Returns the distance from point to the line defined by point1 and point2."""
    x, y = point
    m, b = line
    div = sqrt(m * m + 1)
    distance = abs(m * x + b - y) / div
    return distance

def delete_point_in_points(points, point):
    pts = []
    for pnt in points:
        if all(pnt != point):
            pts.append(pnt)
    return array(pts)

def find_quadrilateral_corners(points):
    """Finds corners of quadrilateral or triangular area, which contains the 
    specified collection of points. For this, returns a list of 3 or 4 points,
    which are corners of the quadrilateral or triangular area filled by 
    specified collection of points.
        
    The first point in the list is the point with lowest X and Y coordinates, 
    while the other corners are provided in counter clockwise order.
    
    The method makes an assumption that the specified collection of points some 
    sort of quadrilateral triangular area. With this assumption it tries to 
    final corners of the area.
    
    The method does not search for bounding quadrilateral/triangular area, 
    where all specified points are inside of the found quadrilateral/triangle. 
    Some of the specified points potentially may be outside of the found
    quadrilateral/triangle, since the method takes corners only from the 
    specified collection of points but does not calculate such to form true 
    bounding quadrilateral/triangle.
    
    Ideally points 1 and 2 form a diagonal of the quadrilateral area, and 
    points 3 and 4 form another diagonal. But if one of the points 3 or 4 is 
    very close to the line connecting points 1 and 2, then it is one the same 
    line, which means corner was not found. In this case we deal with a 
    trapezoid or triangle, where 1 to 2 line is one of it sides.
    Another interesting case is when both points 3 and 4 are very close the
    1 to 2 line. In this case we may have just a flat quadrilateral.
    """
    corners = []
    # Gets the boundary rectangle of the list of points.
    min_xy = array([min(points[:,0]), min(points[:,1])])
    max_xy = array([max(points[:,0]), max(points[:,1])])
    # Gets the size and the center of boundary rectangle of the list of point.
    size = max_xy - min_xy
    center = min_xy + size / 2
    if all(size > 10):
        # Acceptable deviation limit (distortion limit allowed for quadrilaterals)
        distortion_limit = 0.25 * (size[0] + size[1]) / 2
        # Process points to find shape
        point1 = get_furthest_point(points, center)
        points = delete_point_in_points(points, point1) # del point1
        point2 = get_furthest_point(points, point1)
        points = delete_point_in_points(points, point2) # del point2
        line12 = get_line_from_points(point1, point2)
        #point3, distance3 = get_furthest_point_from_line(points, line12)
        while len(points) > 0:
            point3, distance3 = get_furthest_point_from_points(points, point1, point2)
            points = delete_point_in_points(points, point3) # del point3
            if (distance3 >= distortion_limit):
                corners.append(point1)
                corners.append(point3)
                corners.append(point2)
                break
            #point4 = get_furthest_point(points, point3)
            #distance4 = get_distance_from_line(point4, line12)
            #if (distance4 >= distortion_limit):
            #    corners.append(point4)
    return array(corners)
    
def get_triangle_and_square_shapes(shapes):
    """Gets the triangle and the square shapes in the list of shapes."""
    triangles, squares = {}, {}
    for shape_id, shape in shapes.iteritems():
        # Homography
        #points = zeros(shape.shape)
        #for k in range(shape.shape[0]):
        #    x, y = shape[k,:]
        #    points[k,:] = transform.homography_global_point(x, y)
        #shape = array(points)
        # ----------
        corners = find_quadrilateral_corners(shape)
        if len(corners) == 3:
            triangles[shape_id] = corners
        elif len(corners) == 4:
            squares[shape_id] = corners
    return triangles, squares

def get_triangle_position(points):
    """Gets the current position of the triangle from their corners."""
    #(x1, y1) = (points[0] + points[2]) / 2
    #(x2, y2) = points[1]
    points = transform.calibrated_points(points)
    r1 = points[1] - points[0] 
    r2 = points[1] - points[2]
    d1 = r1[0] * r1[0] + r1[1] * r1[1]
    d2 = r2[0] * r2[0] + r2[1] * r2[1]
    if d1 < d2:
        (x1, y1) = (points[0] + points[1]) / 2
        (x2, y2) = points[2]
    else:
        (x1, y1) = (points[2] + points[1]) / 2
        (x2, y2) = points[0]
    # Homography
    #(x1, y1) = transform.homography_global_point(x1, y1)
    #(x2, y2) = transform.homography_global_point(x2, y2)
    position = x1, y1, arctan2((y2 - y1), (x2 - x1))
    if not pose == None:
        if pose.dev == None:
            pose.dev = pose.init()
        print 'Soft:', position
        position = pose.position(points, dev=pose.dev)
        print 'Hard:', position
    position = round(position[0], 1), round(position[1], 1), round(position[2], 4)
    return position
    
def get_square_position(points):
    """Gets the current position of the square from their corners."""
    dist1 = (points[0] - points[2]) * (points[0] - points[2])
    dist2 = (points[1] - points[3]) * (points[1] - points[3])
    dist1 = sqrt(dist1[0] + dist1[1])
    dist2 = sqrt(dist2[0] + dist2[1])
    x = round(mean(points[:,0]), 0)
    y = round(mean(points[:,1]), 0)
    r = round((dist1 + dist2) / 4, 0)
    return (x, y, r)
        
#------------------------------------------------------------------------------       

# Global box transformations
        
def check_global_box_in(box1, box2):
    """Checks if the box1 is in the area of the box2."""
    left1, top1, right1, bottom1 = box1[0,0], box1[0,1], box1[1,0], box1[1,1]
    left2, top2, right2, bottom2 = box2[0,0], box2[0,1], box2[1,0], box2[1,1]
    if ((left1 > left2) and 
        (top1 < top2) and
        (right1 < right2) and
        (bottom1 > bottom2)):
        return True
    else:
        return False
        
def check_global_box_out(box1, box2):
    """Checks if the box1 is out the area of the box2."""
    left1, top1, right1, bottom1 = box1[0,0], box1[0,1], box1[1,0], box1[1,1]
    left2, top2, right2, bottom2 = box2[0,0], box2[0,1], box2[1,0], box2[1,1]
    if ((left1 > right2) or 
        (top1 < bottom2) or 
        (right1 < left2) or 
        (bottom1 > top2)):
        return True
    else:
        return False
    
def check_global_box_over(box1, box2):
    """Checks if the box1 is over the border of the area of the box2."""
    left1, top1, right1, bottom1 = box1[0,0], box1[0,1], box1[1,0], box1[1,1]
    left2, top2, right2, bottom2 = box2[0,0], box2[0,1], box2[1,0], box2[1,1]
    if (((left1 <= left2) and (right1 >= left2)) or
        ((right1 >= right2) and (left1 <= right2))):
        if (((top1 < top2) and (top1 > bottom2)) or 
            ((bottom1 < top2) and (bottom1 > bottom2))):
            return True
        else:
            return False
    elif (((top1 >= top2) and (bottom1 <= top2)) or
          ((bottom1 <= bottom2) and (top1 >= bottom2))):
        if (((left1 > left2) and (left1 < right2)) or
            ((right1 > left2) and (right1 < right2))):
            return True
        else:
            return False
    else:
        return False

#------------------------------------------------------------------------------

def bounding_box(points, margin=5):
    """Finds the bounding box of the points cloud."""
    left = min(points[:,0]) - margin
    top = min(points[:,1]) - margin
    right = max(points[:,0]) + margin
    bottom = max(points[:,1]) + margin
    return [left, top, right, bottom]

def global_bounding_box(points, margin=5):
    """Finds the bounding box of the points cloud defined in global coordinates."""
    left = min(points[:,0]) - margin
    top = max(points[:,1]) + margin
    right = max(points[:,0]) + margin
    bottom = min(points[:,1]) - margin
    return array([[left, top], [right, bottom]])

def check_point_into_global_box(point, box):
    """Checks if the point is in the area of the box."""
    x, y = point
    left, top, right, bottom = box[0,0], box[0,1], box[1,0], box[1,1]
    if ((x > left) and (y < top) and
        (x < right) and (y > bottom)):
        return True
    else:
        return False

#------------------------------------------------------------------------------ 

def window_into_the_box(window, box):
    """Processes the window to get the one is into the box."""
    x1, y1 = window[0]
    x2, y2 = window[1]
    if x1 < box[0,0]:
        x1 = box[0,0]
    if y1 < box[0,1]:
        y1 = box[0,1]
    if x2 > box[1,0]:
        x2 = box[1,0]
    if y2 > box[1,1]:
        y2 = box[1,1]
    return array([[x1, y1], [x2, y2]])

def location_shapes_list_in_images(images_bin):
    """Processes the list of binary images to get the corners of the located shapes."""
    shapes_list = []
    for image_bin in images_bin:
        image_bin = pimage.erosion(image_bin)
        #image_bin = pimage.erosion(image_bin)
        image_bin = pimage.dilation(image_bin)
        image_bin = pimage.dilation(image_bin)
        image_bin = pimage.dilation(image_bin)
        shapes = pimage.connected(image_bin)
        shapes_list.append(shapes)
    return shapes_list

def location_objects_and_windows_in_images(images_bin):
    """Processes the list of shapes to find the triangles and squares objects 
    in the list and their search windows."""
    objects, windows = [], []
    #width, height = images_bin[0].shape[1], images_bin[0].shape[0]
    #box = array([[0, 0], [width, height]])
    images_bin = [images_bin[0] | images_bin[1] | images_bin[2]]
    shapes_list = location_shapes_list_in_images(images_bin)
    for shapes in shapes_list:
        for points in shapes:
            points = find_quadrilateral_corners(points)
            if len(points):
                #point_cm = transform.center_of_mass(points)
                point_cm = transform.center_of_bounding_box(points)
                distance = transform.distance(points[2,:], points[0,:]) * 0.65
                window = array([point_cm - distance, point_cm + distance])
                #window = window_into_the_box(window, box)
                #if all(window[0] > box[0]) and all(window[1] < box[1]):
                windows.append(window)
                objects.append(points)
    return objects, windows

def find_objects_in_image(image, images_bin, start_id):
    """Finds the objects in the image."""
    # Image processing, shapes location and tracking windows calculation
    objects, windows = location_objects_and_windows_in_images(images_bin)
    
    # Draws the shapes found and their search windows
    figure()
    imshow(image)
    width, height = image.shape[1], image.shape[0]
    for i, box in enumerate(windows):
        target_id = i + start_id + 1
        gca().add_patch(Rectangle([box[0,0], box[0,1]], 
                                  box[1,0] - box[0,0], 
                                  box[1,1] - box[0,1], 
                                  alpha=.6, color='y', ec='w', lw=1))
        gca().add_patch(Polygon(objects[i], closed=True, 
                                alpha=.8, fc='y', ec='k', lw=1))
        plot(objects[i][:,0], objects[i][:,1], 'yo', lw=2)
        text((box[0,0] + box[1,0]) / 2, (box[0,1] + box[1,1]) / 2, 
             str(target_id), ha='center', va='center')
    xlim([0, width])
    ylim([height, 0])
    show()
    
    return windows
    
    
    
if __name__ == '__main__':
            
    window = array([[150, 50], [250,-150]])
    width, height = 2 * 648, 2 * 486
    
    win1 = transform.points_to_local(window, width, height, 2, 3)
    win2 = transform.points_to_global(win1, width, height, 2, 3)
    print 'Local 3:', win1, 'Global 3:', win2
    
    w1 = transform.points_to_local(window, width, height, 2, 4)
    w2 = transform.points_to_global(w1, width, height, 2, 4)
    print 'Local 4:', w1, 'Global 4:', w2 
    
    points = np.array([[1, 1],
                       [3, 1],
                       [2, 3]])
    print get_triangle_position(points)
    print get_triangle_position(points)
    points = np.array([[1, 1],
                       [1, 3],
                       [2, 3]])
    print get_triangle_position(points)
    print get_triangle_position(points)


    
    
    
