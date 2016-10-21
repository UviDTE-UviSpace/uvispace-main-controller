#!/usr/bin/env python

#First make a shared object library by doing (at the command line)
#gcc -shared -o ctest.so cprocessing.c
#gcc.exe -DBUILD_DLL -shared -o ctest.dll cprocessing.c

import ctypes
import numpy as np

lib = ctypes.cdll.LoadLibrary('./libdir.so')

dev = None
     
iniciar = lib.iniciar
iniciar.restype = None
iniciar.argtypes = [ctypes.POINTER(ctypes.c_int), ctypes.POINTER(ctypes.c_int)]

def init():
    fd_wr, fd_rd = ctypes.c_int(), ctypes.c_int()
    iniciar(ctypes.byref(fd_wr), ctypes.byref(fd_rd))
    return fd_wr, fd_rd


direccion = lib.direccion
direccion.restype = None
direccion.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_float, ctypes.c_float, 
                      ctypes.c_float, ctypes.c_float, ctypes.c_float, ctypes.c_float, 
                      ctypes.POINTER(ctypes.c_float), ctypes.POINTER(ctypes.c_float), 
                      ctypes.POINTER(ctypes.c_float)]

def position(points, dev=None):
    if dev == None:
        fd_wr, fd_rd = init()
    else:
        fd_wr, fd_rd = dev
    #p00, p01 = ctypes.c_float(1), ctypes.c_float(1)
    #p10, p11 = ctypes.c_float(3), ctypes.c_float(1)
    #p20, p21 = ctypes.c_float(2), ctypes.c_float(3)
    p00, p01 = points[0]
    p10, p11 = points[1]
    p20, p21 = points[2]
    x, y, theta = ctypes.c_float(0), ctypes.c_float(0), ctypes.c_float(0)
    direccion(fd_wr, fd_rd, p00, p01, p10, p11, p20, p21, ctypes.byref(x), ctypes.byref(y), ctypes.byref(theta))
    x, y, theta = x.value, y.value, theta.value
    return x, y, theta
    
   
class Pose:
    def __init__(self):
        self.dev = init()

    def position(self, points):
        x, y, theta = position(points, dev=self.dev)
        return x, y, theta

       
if __name__ == '__main__':
    import time

    points = np.array([[1, 1],
                       [3, 1],
                       [2, 3]])
    
#    dev = init()
#    t0 = time.time()
#    pose = position(points, dev=dev)
#    t1 = time.time()
#    print t1 - t0, pose

#    pose = Pose()
#    t0 = time.time()
#    position = pose.position(points)
#    t1 = time.time()
#    print t1 - t0, position

    t0 = time.time()
    pose = position(points)
    t1 = time.time()
    print t1 - t0, pose

    
