#!/usr/bin/env python

import time 
from pylab import *
from PIL import Image

import pimage, processing

# Estimation of optimal thresholds
    
def find_valleys(image, bins):
    """Finds valleys in the image histogram by the differential analysis."""
    nbins = bins
    hist, bins = histogram(image, bins=nbins, range=[0,256])
    diff = zeros(nbins, dtype=int)
    for i in range(nbins - 1):
        diff[i] = hist[i+1] - hist[i]
    valleys = [0]
    for i in range(nbins - 2):
        if (diff[i] <= 0 and diff[i+1] >= 0 and diff[i] != diff[i+1]):
            valleys.append(bins[i+1])
    valleys.append(255)
    return valleys

def find_range(value, range_list):
    """Finds the valid range between the valleys of the histogram."""
    for i in range(len(range_list) - 1):
        if value >= range_list[i] and value <= range_list[i+1]:
            thr_min, thr_max = range_list[i], range_list[i+1]
            return thr_min, thr_max

def get_best_color(image, pixel, bins):
    """Gets the best color range by automatic thresholding."""
    img_red, img_green, img_blue = dsplit(image, 3)
    thr_r = find_range(pixel[0], find_valleys(img_red, bins))
    thr_g = find_range(pixel[1], find_valleys(img_green, bins))
    thr_b = find_range(pixel[2], find_valleys(img_blue, bins))
    thr_min = array([thr_r[0], thr_g[0], thr_b[0]]).astype(uint8)
    thr_max = array([thr_r[1], thr_g[1], thr_b[1]]).astype(uint8)
    return thr_min, thr_max
    
#------------------------------------------------------------------------------ 

def click(event):
    """If the left mouse button is pressed: draw a little square. """
    if event.button == 1:
        x, y = event.xdata, event.ydata
        print img[y,x]
        print H[y,x]
        plot([x],[y],'rs')
        draw()


def hue((b, g, r)):
    """Converts a RGB value to a Hue value."""  
    r, g, b = int(r), int(g), int(b)
    M = max([r, g, b])
    m = min([r, g, b])
    d = M - m
    h, s, v = 0, 0, 0
    v = M
    if M > 0:
        s = 255 * d / M
    else:
        s = 0
#    if d > 0:
#        if M == r:
#            h = (256 * (G - B) / d)
#        elif M == g:
#            h = (512 + (256 * (B - R) / d))
#        elif M == b:
#            h = (1024 + (256 * (R - G) / d))
#        h = 85 * h / 512
#        if h < 0:
#            h = h + 255
#    else:
#        h = 0
    if d > 0:
        if M == r:
            if g < b:
                h = 16 * 6 - (16 * (b - g) / d)
            else:
                h = 16 * 0 + (16 * (g - b) / d)
        elif M == g:
            if b < r:
                h = 16 * 2 - (16 * (r - b) / d)
            else:
                h = 16 * 2 + (16 * (b - r) / d)
        elif M == b:
            if r < g:
                h = 16 * 4 - (16 * (g - r) / d)
            else:
                h = 16 * 4 + (16 * (r - g) / d)
        h = 85 * h / 32
    else:
        h = 0
    return h



if __name__ == '__main__':
    import time
    import ImageFilter
    
    width, height = 864, 648
    
    # Thresholding
    image = Image.open('capture_rgb.png')#'CameraII/2_2929_c.png')#capture_rgb1.png')
    #image = image.filter(ImageFilter.SMOOTH)
    image = image.resize((width, height))
    image = array(image.getdata(), dtype=uint8).reshape(height, width, 3)

    t0 = time.time()
    
    # Creates a new image that shows the Hue channel from the original image.
    H = zeros((height, width))
    for j in range(height):
        for i in range(width):
            H[j,i] = hue(image[j,i])
            # Show test values
            if i > 100 and j > 100 and i < 110 and j < 110:
                print image[j,i], H[j,i]
    
    print 'M:', max(H.reshape(width * height))
    print 'm:', min(H.reshape(width * height))
            
    figure()
    imshow(H)
    
    img = dstack([H, H, H]).astype(uint8)
    imsave('imgh.png', img)    
    img_h, img_g, img_b = dsplit(img, 3)

    bins = 128
    #pixel = [170, 170, 170]
    pixel = [245, 245, 245]
    thr_min, thr_max = get_best_color(img, pixel, bins)
    print thr_min, thr_max
    thr_min, thr_max = [150, 150, 150], [255, 255, 255]
    img = pimage.binarize(img, [thr_min, thr_max])
    img = pimage.erosion(img)
        
    figure() 
    subplot(221)
    gray()
    imshow(H)
    connect('button_press_event', click)
    subplot(222)
    hist(img_h.reshape(width * height), bins=bins, range=[0, 255], color='y', lw=0)
    #plot(vall_r, zeros(len(vall_r)), 'ok')
    plot([thr_min[0], thr_max[0]], [0, 0], 'oy')
    xlim(0, 255)
    subplot(223)
    imshow(img)
    subplot(224)
    imshow(image)
    xlim(0, width)
    ylim(height, 0)
        
    # Connectivity    
    figure()
    imshow(image)
    #img = pimage.erosion(img)
    img = pimage.dilation(img)
    corners_list = pimage.connected(img)
    for corners in corners_list:
        #corners = find_quadrilateral_corners(corners)
        if any(corners):
            # Draw bounding boxes
            bb = processing.bounding_box(corners)
            gca().add_patch(Rectangle((bb[0], bb[1]), bb[2] - bb[0], bb[3] - bb[1], 
                                      alpha=.6, color='w', ec='w', lw=1))
            # Draws corners shapes
            gca().add_patch(Polygon(corners, closed=True, alpha=.4, fc='r', ec='r', lw=2))
            #gca().plot(corners[:,0], corners[:,1], 'yo', lw=1)
            # Draws the center of mass
            #if len(corners):
                #print corners, corners.shape
                #window = search_window([x_cm, y_cm], [d, d])
                #print array(window, dtype=int)
                #gca().add_patch(Rectangle((window[0], window[1]), window[2], window[3], 
                #                          alpha=.3, color='w', ec='w', lw=1))
                #plot(x_cm, y_cm, 'wo')
    xlim([0, width])
    ylim([height, 0])
    
    t1 = time.time()
    print t1 - t0
    
    show()
    
    
