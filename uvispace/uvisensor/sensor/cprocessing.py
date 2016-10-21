#!/usr/bin/env python

#First make a shared object library by doing (at the command line)
#gcc -shared -o ctest.so cprocessing.c
#gcc.exe -DBUILD_DLL -shared -o ctest.dll cprocessing.c

import ctypes
import platform
import numpy 
from numpy.ctypeslib import ndpointer


if platform.system() == 'Windows':
    lib = ctypes.cdll.LoadLibrary('./ctest.dll')
if platform.system() == 'Linux':
    lib = ctypes.cdll.LoadLibrary('./ctest.so')

           
bin = lib.cbinarize
bin.restype = None
bin.argtypes = [ndpointer(ctypes.c_ubyte), ndpointer(ctypes.c_ubyte),
                ctypes.c_int,
                ndpointer(ctypes.c_ubyte), ndpointer(ctypes.c_ubyte)]         
       
def binarize(image, (thr_min, thr_max)):
    """Binarizes the image through the configured thresholds."""
    width, height = image.shape[1], image.shape[0]
    img = numpy.zeros((height, width), dtype=numpy.uint8)
    thr_min = thr_min.astype(numpy.uint8)
    thr_max = thr_max.astype(numpy.uint8)
    bin(image, img, width * height, thr_min, thr_max)
    return img

ero = lib.cerosion
ero.restype = None
ero.argtypes = [ndpointer(ctypes.c_ubyte), ndpointer(ctypes.c_ubyte),
                ctypes.c_int, ctypes.c_int]

def erosion(image):
    """Erodes the image with a 3x3 kernel."""
    width, height = image.shape[1], image.shape[0]
    img = numpy.zeros((height, width), dtype=numpy.uint8)
    ero(image, img, width, height)
    return img
    
dil = lib.cdilation
dil.restype = None
dil.argtypes = [ndpointer(ctypes.c_ubyte), ndpointer(ctypes.c_ubyte),
                ctypes.c_int, ctypes.c_int]

def dilation(image):
    """Erodes the image with a 3x3 kernel."""
    width, height = image.shape[1], image.shape[0]
    img = numpy.zeros((height, width), dtype=numpy.uint8)
    dil(image, img, width, height)
    return img

loc = lib.clocation
loc.restype = None
loc.argtypes = [ndpointer(ctypes.c_ubyte), ctypes.c_int, ctypes.c_int,
                ndpointer(ctypes.c_int), ndpointer(ctypes.c_int)]

def location(image):
    """Locates the boundary corners of shape in the image."""
    width, height = image.shape[1], image.shape[0]
    corners_x = numpy.zeros((8, 1), dtype=numpy.int32)
    corners_y = numpy.zeros((8, 1), dtype=numpy.int32)
    loc(image, width, height, corners_x, corners_y)
    corners = numpy.hstack([corners_x, corners_y])
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
    
