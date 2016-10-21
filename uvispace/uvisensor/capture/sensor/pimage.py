#!/usr/bin/env python

import time 
from pylab import *
from PIL import Image

try:
    from cprocessing import *
except:
    print 'ERROR loading C library.'
    from pprocessing import *


def corners_area(corners):
    """Calculates the area of the polygon from the list of vertex."""
    v = vstack((corners[1:], corners[0]))
    D = sum(corners[:,0] * v[:,1])
    I = sum(corners[:,1] * v[:,0])
    area = abs(D - I) / 2
    return area

def connected(image):
    """Locates the boundary corners of shapes in the image with the application
    of a connected components algorithm.
    This algorithm assume 8-connectivity. So the connected components labeling
    operator scans the image and examines the four neighbors (west, north, 
    north-west and north-east) of the point which have already been encountered.
    """
    width, height = image.shape[1], image.shape[0]
    img = zeros((height, width), dtype=uint8)
    label = 0
    max_label = 0
    sizes = [0]
    corners = [zeros([8, 2])]
    for y in range(1, height):
        for x in range(1, width - 1):
            if image[y,x]:
                size = 0
                corner = array([[width, height], # left2
                                [width, height], # left1
                                [width, height], # top1
                                [width, height], # top2
                                [0, 0], # right1
                                [0, 0], # right2
                                [0, 0], # bottom2
                                [0, 0]]) # bottom1  
                # Labeling
                west = img[y,x-1]
                north_west = img[y-1,x-1]
                north = img[y-1,x]
                north_east = img[y-1,x+1]
                if west:
                    label = west
                elif north_west:
                    label = north_west
                elif north:
                    label = north
                elif north_east:
                    label = north_east
                else:
                    label = max_label + 1
                    max_label = label
                    sizes.append(size)
                    corners.append(corner)
                img[y,x] = label
                # Connected
                if north_east and (north_east != label):
                    size = sizes[north_east]
                    sizes[north_east] = 0
                    corner = corners[north_east]
                # Corners
                if label:
                    sizes[label] = sizes[label] + size + 1
                    if corners[label][0,0] >= x: # left2
                        corners[label][0] = x, y
                    if corners[label][1,0] > x: # left1
                        corners[label][1] = x, y
                    if corners[label][2,1] > y: # top1
                        corners[label][2] = x, y
                    if corners[label][3,1] >= y: # top2
                        corners[label][3] = x, y
                    if corners[label][4,0] < x: # right1
                        corners[label][4] = x, y
                    if corners[label][5,0] <= x: # right2
                        corners[label][5] = x, y
                    if corners[label][6,1] <= y: # bottom2
                        corners[label][6] = x, y
                    if corners[label][7,1] < y: # bottom1
                        corners[label][7] = x, y
                    # Adds corners of connected components 
                    if corners[label][0,0] > corner[0,0]:
                        corners[label][0] = corner[0]    
                    if corners[label][1,0] > corner[1,0]:
                        corners[label][1] = corner[1] 
                    if corners[label][2,1] > corner[2,1]:
                        corners[label][2] = corner[2]    
                    if corners[label][3,1] > corner[3,1]:
                        corners[label][3] = corner[3] 
                    if corners[label][4,0] < corner[4,0]:
                        corners[label][4] = corner[4] 
                    if corners[label][5,0] < corner[5,0]:
                        corners[label][5] = corner[5]
                    if corners[label][6,1] < corner[6,1]:
                        corners[label][6] = corner[6]
                    if corners[label][7,1] < corner[7,1]:
                        corners[label][7] = corner[7]
    corners_list = []
    sort_indexes = argsort(array(sizes))
    for sort_index in sort_indexes[::-1]:
        if sizes[sort_index] > 75:
            if sizes[sort_index] > 0.7 * corners_area(corners[sort_index]):
                corners_list.append(corners[sort_index])
        else:
            break
    return corners_list



def memory_bin(image, filename):
    # Memory simulation file (binary)
    memory = ""
    height, width = image.shape
    for pixel in image.reshape(width * height):
        binary = bin(256 | int(pixel))[-8:]
        memory += binary + "\n"
    file = open(filename, 'w')
    file.write(memory)
    file.close()
    

if __name__ == '__main__':
    img = Image.open('image.png')
    img = img.resize((320, 240))
    width, height =  img.size
    image = array(img.getdata(), dtype=uint8).reshape(height, width, 3)
    img = zeros((height, width, 3), dtype=uint8)
    for y in range(height):
        for x in range(width):
            img[y,x] = image[y,x] / 64 * 64
    subplot(211)
    imshow(image)
    subplot(212)
    imshow(img)
    show()
        
#------------------------------------------------------------------------------ 
    
    # Connectivity
    img = Image.open('capture_bin.png')
    img = img.resize((width, height))
    image = array(img.getdata(), dtype=uint8).reshape(height, width, 3)
    imshow(image)
    
    imgs = dsplit(image, 3)
    imshow(dstack([erosion(img) for img in imgs]))
    cols = ['r', 'g', 'b']
    for i, img in enumerate(imgs):
        img = erosion(img)
        #if i == 1:
        #    memory_bin(img, "connected.bin") # Modelsim data input
        corners_list = connected(img)
        for corners in corners_list:
            #corners = find_quadrilateral_corners(corners)
            if any(corners):
                # Draw bounding boxes
                #bb = bounding_box(corners)
                #gca().add_patch(Rectangle((bb[0], bb[1]), bb[2] - bb[0], bb[3] - bb[1], 
                #                          alpha=.6, color=cols[i], ec='w', lw=1))
                # Draws corners shapes
                gca().add_patch(Polygon(corners, closed=True, alpha=.8, fc='y', ec='y', lw=2))
                gca().plot(corners[:,0], corners[:,1], 'yo', lw=2)
                # Draws the center of mass
                if len(corners):
                    print corners, corners.shape

                    #window = search_window([x_cm, y_cm], [d, d])
                    #print array(window, dtype=int)
                    #gca().add_patch(Rectangle((window[0], window[1]), window[2], window[3], 
                    #                          alpha=.3, color='w', ec='w', lw=1))
                    #plot(x_cm, y_cm, 'wo')
    xlim([0, width])
    ylim([height, 0])
    show()
    
