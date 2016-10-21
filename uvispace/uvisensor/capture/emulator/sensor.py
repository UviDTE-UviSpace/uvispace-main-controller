#!/usr/bin/env python
# Socket server

import time
import socket

from pylab import *
from PIL import Image

#from pimage import binarize, erosion, location
from cprocessing import binarize, erosion, location



IP = ''
PORT = 5005
BUFFER_SIZE = 2048

FILENAME = 'image.png'

# Registers
register = {}
# Camera registers
register['is'] = (320, 240) # Image Size (width, height)
register['ie'] = 1984 # Image exposure
register['si'] = (16, 54) # Start Image (start column, start row)
register['ss'] = (1919, 1439) # Sensor Size (column size, row size)
register['sm'] = (2, 2) # Sensor Mode (column mode, row mode)
# Sensor registers
register['rt'] = (424673280, 1073026373) # Red Thresholds (min, max)
register['gt'] = (281600, 599785019) # Green Thresholds (min, max)
register['bt'] = (212, 577281023) # Blue thresholds (min, max)
# Location registers
register['al'] = {}
register['aw'] = {}
register['sw'] = (0, 0, 0, 0)
# Trackers registers
register['tr'] = 6
register['fa'] = "All trackers freed."


def get_image(image, gray=False):
    img = Image.open(image)
    if gray:
        img = img.convert('L')   # convert to grayscale
    img = img.resize((2592, 1944))
    left, top = register['si'][0] - 15, register['si'][1] - 53
    right, bottom = left + register['ss'][0] + 1, top + register['ss'][1] + 1
    img = img.crop((left, top, right, bottom))
    img_data = img.resize((img.size[0] / (2 * (register['sm'][0] + 1)), 
                           img.size[1] / (2 * (register['sm'][1] + 1))))
    img_data = array(img_data.getdata(), dtype=uint8)
    if gray:
        img_data = img_data.reshape(register['is'][1], register['is'][0])
    else:
        img_data = img_data.reshape(register['is'][1], register['is'][0], 3)
    return img_data

img_data = get_image(FILENAME)

def get_proc_image(image):
    img = Image.open(image)
    img = img.resize((2592, 1944))
    left, top = register['si'][0] - 15, register['si'][1] - 53
    right, bottom = left + register['ss'][0] + 1, top + register['ss'][1] + 1
    img = img.crop((left, top, right, bottom))
    img_data = img.resize((img.size[0] / (register['sm'][0] + 1),
                           img.size[1] / (register['sm'][1] + 1)))
    img_data = array(img_data.getdata(), dtype=uint8)
    return img_data.reshape(register['is'][1] * 2, register['is'][0] * 2, 3)

proc_image = get_proc_image(FILENAME)

def get_packages(image, gray=False):
    """Read image file and get data packages."""
    img_data = get_image(image, gray=gray)
    # Image split in packages
    img_str = img_data.tostring()
    packages = []
    N = int(ceil(float(len(img_str)) / BUFFER_SIZE))
    for n in range(N):
        i = n * BUFFER_SIZE
        f = (n + 1) * BUFFER_SIZE
        packages.append(img_str[i:f])
    return packages

def _decode_threshold(threshold):
    """Decodes color components of threshold."""
    MASK = int('1111111111', 2)
    red_component = (threshold >> 20) & MASK
    green_component = (threshold >> 10) & MASK
    blue_component = threshold & MASK
    return array([red_component / 4, green_component / 4, blue_component / 4], 
                 dtype=uint8)

def get_all_positions(image):
    thresholds = (register['rt'], register['gt'], register['bt'])
    positions = {}
    print image.shape[1], image.shape[0]
    t0 = time.time()
    for i, thres in enumerate(thresholds):
        thr_min = _decode_threshold(thres[0])
        thr_max = _decode_threshold(thres[1])
        img = erosion(binarize(image, [thr_min, thr_max]))
        positions[str(i)] = tuple([tuple(loc) for loc in location(img).astype(int)])
    t1 = time.time()
    print t1 - t0
    return positions


# Create socket and bind to address
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind((IP, PORT))
sock.listen(1)

print 'Starting TCP server...'
print 'IP:', IP, 'PORT:', PORT
print 'Waiting connection...'

while True:
    # Accept connection
    conn, addr = sock.accept()
    #conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
    
    print 'Connection address:', addr
    print 'Waiting for data...'
    
    menu  = '===========================================\n'
    menu += 'Nios II Camera Commands Menu               \n'
    menu += '===========================================\n'
    menu += '                                           \n'
    menu += 'r,xx: Read value of register (xx)          \n'
    menu += 'w,xx,yy: Write value (yy) in register (xx) \n'
    menu += '                                           \n'
    menu += 'C: Configure camera sensor                 \n'
    menu += 'S: Start/Stop capture                      \n'
    menu += 'D: Send RGB image data                     \n'
    menu += 'G: Send gray image data                    \n'
    menu += 'V: VGA (Live video mode)                   \n'
    menu += 'T: Sensor/Camera selection                 \n'
    menu += '                                           \n'
    menu += 'Q: Terminate session                       \n'
    menu += '===========================================\n'
    menu += 'Enter your choice & press return:>         \n'
    conn.send(menu)

    while True:
        try:
            data = conn.recv(BUFFER_SIZE).strip()#.split('\n')[0]
            #print data
            command = data[0]
        except:
            command = ''
        if command == 'r' or command == 'w':
            reg = data[2:4]
            if command == 'w': # Command (write)
                if reg == 'fa':
                    pass
                elif reg == 'sw':
                    values = data[5:].split(',')
                    id, x, y, width, height = [int(value) for value in values]
                    register['sw'] = (x, y, width, height)
                    register['aw'][str(id)] = ((x, y), (width, height))  
                else:
                    register[reg] = eval(data[5:])
            conn.send(str(register[reg]) + '\n')
            if command == 'r' and reg == 'al': # Commmand (read)
                #proc_image = get_proc_image(FILENAME)
                register['al'] = get_all_positions(proc_image) 
        elif command == 'C': # Reconfigure
            img_data = get_image(FILENAME)
            proc_image = get_proc_image(FILENAME)
            conn.send('System configured\n')
        elif command == 'S': # Capture
            register['al'] = get_all_positions(proc_image)
            conn.send('Image captured\n')
        elif command == 'D' or data == 'G': # Send image data
            bytes = 0
            t0 = time.time()
            if data == 'D':
                packages = get_packages(FILENAME)
            else:
                packages = get_packages(FILENAME, gray=True)
            for package in packages:
                conn.send(package)
                bytes += len(package)
            t1 = time.time()
            rate = bytes / (t1 - t0) * 8 / 1000
            print "Sended %s bytes in %i packages" %(bytes, len(packages))
            print "Sended in %.3f s at %.1f kbps" %((t1 - t0), rate)
        elif data == 'Q':
            print 'Closing connection...'
            break
        else:
            conn.send(menu) 
    
    conn.close()
    
print 'Closing TCP server...'
sock.close()
