#!/usr/bin/env python

import time 
from pylab import *

def binarize(image, (thr_min, thr_max)):
    """Binarizes the image through the configured thresholds."""
    width, height = image.shape[1], image.shape[0]
    img = zeros((height, width), dtype=uint8)
    for y in range(height):
        for x in range(width):
            if ((image[y,x,0] >= thr_min[0]) and
                (image[y,x,0] <= thr_max[0]) and
                (image[y,x,1] >= thr_min[1]) and
                (image[y,x,1] <= thr_max[1]) and
                (image[y,x,2] >= thr_min[2]) and
                (image[y,x,2] <= thr_max[2])):
                img[y,x] = 255
    return img

def erosion(image):
    """Erodes the image with a 3x3 kernel."""
    height, width = image.shape[0:2]
    img = zeros((height, width), dtype=uint8)
    for y in range(1, height - 1):
        for x in range(1, width - 1):
            if (image[y-1,x-1] and image[y-1,x] and image[y-1,x+1] and
                image[y,x-1] and image[y,x] and image[y,x+1] and
                image[y+1,x-1] and image[y+1,x] and image[y+1,x+1]):
                img[y,x] = 255
    return img

def dilation(image):
    """Dilates the image with a 3x3 kernel."""
    height, width = image.shape[0:2]
    img = zeros((height, width), dtype=uint8)
    for y in range(1, height - 1):
        for x in range(1, width - 1):
            if (image[y-1,x-1] or image[y-1,x] or image[y-1,x+1] or
                image[y,x-1] or image[y,x] or image[y,x+1] or
                image[y+1,x-1] or image[y+1,x] or image[y+1,x+1]):
                img[y,x] = 255
    return img

def location(image):
    """Locates the boundary corners of shape in the image."""
    size = 0
    width, height = image.shape[1], image.shape[0]
    # Region of interest
    left, top = 0, 0
    right, bottom = width, height
    # Corners
    left1 = array([right, bottom])
    left2 = array([right, bottom])
    top1 = array([right, bottom])
    top2 = array([right, bottom])
    right1 = array([left, top])
    right2 = array([left, top])
    bottom1 = array([left, top])
    bottom2 = array([left, top])
    for y in range(height):
        for x in range(width):
            if image[y,x]:
                size = size + 1
                if left1[0] > x:
                    left1 = x, y
                if left2[0] >= x:
                    left2 = x, y
                if top1[1] > y:
                    top1 = x, y
                if top2[1] >= y:
                    top2 = x, y
                if right1[0] < x:
                    right1 = x, y
                if right2[0] <= x:
                    right2 = x, y
                if bottom1[1] < y:
                    bottom1 = x, y
                if bottom2[1] <= y:
                    bottom2 = x, y
    if size:
        corners = vstack([left2, left1, 
                          top1, top2, 
                          right1, right2, 
                          bottom2, bottom1])
    else:
        corners = zeros((8, 2))
    return corners

    

if __name__ == '__main__':
    
    from PIL import Image
    from pylab import *
    
    import time
    
    img = Image.open('image.png')
    width, height =  img.size
    image = array(img.getdata(), dtype=uint8).reshape(height, width, 3)
    imshow(image)
    
    thr_min = array([150, 50, 40], dtype=uint8)
    thr_max = array([180, 70, 60], dtype=uint8)
    
    t0 = time.time()
    image_out = binarize(image, (thr_min, thr_max))
    image_out = erosion(image_out)
    points = location(image_out)
    
    print points   

    t1 = time.time()
    print t1 - t0 

    gray()
    imshow(image_out)
    plot(points[:,0], points[:,1], 'ro')
    xlim(0, width)
    ylim(height, 0)
    show()
    
