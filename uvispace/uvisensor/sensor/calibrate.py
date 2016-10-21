# Camera calibration
#import cv2
import glob
import time
import numpy as np
import pylab as pl

#def find_chessboard(filename, pattern_size):
#    """Finds the chessboard in the image."""
#    image = cv2.imread(filename, cv2.CV_LOAD_IMAGE_COLOR)
#    #img = cv2.imread(filename, cv2.CV_LOAD_IMAGE_GRAYSCALE)
#    img = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
#    found, corners = cv2.findChessboardCorners(img, pattern_size)
#    return img, found, corners

#def draw_chessboard(img, pattern_size, found, corners):
#    """Draws the finded chessboard in the image."""
#    chessboard = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
#    cv2.drawChessboardCorners(chessboard, pattern_size, corners, found)
#    return chessboard
#    
#def show_image(image):
#    cv2.namedWindow('image')
#    cv2.imshow('image', image)
#    cv2.waitKey()

def distortion_correction(x, y, cx, cy, kx, ky):
    """Corrects the barrel distortion."""
    xd, yd = x - cx, y - cy
    r2 = xd * xd + yd * yd
    xu = xd * (1 + kx * r2) + cx
    yu = yd * (1 + ky * r2) + cy
    if xu < 0:
        xu = 0
    if xu > 2 * cx:
        xu = 2 * cx
    if yu < 0:
        yu = 0
    if yu > 2 * cy:
        yu = 2 * cy
    return xu, yu

def filter_points(points):
    """Filter the corner points of the found shape."""
    lines = []
    for k in range(len(points)):
        pnt1, pnt2 = points[k], points[k-1]
        dist2 = sum((pnt2 - pnt1) * (pnt2 - pnt1))
        if dist2 < 900:
            continue
        lines.append([pnt1 * 1.0, pnt2 * 1.0])
    pts = []
#    for k in range(len(lines)):
#        x1, y1 = lines[k][0]
#        x2, y2 = lines[k][1]
#        x3, y3 = lines[k-1][0]
#        x4, y4 = lines[k-1][1]
#        # Intersection point from two lines
#        x = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
#        y = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
#        pts.append([x, y])
    if len(pts) < 3:
        for k in range(len(points)):
            if not (points[k,0] == points[k-1,0] and points[k,1] == points[k-1,1]):
                pts.append(points[k])   
    return np.array(pts)

def points_correction(points, c, k):
    """Corrects the barrel distortion in the set of points."""
    cx, cy = c
    R2 = cx * cx + cy * cy
    kx, ky = k[0] / R2, k[1] / R2
    kx, ky = kx / 2, kx / 2 # it is the half of image
    pts = []
    points = filter_points(points)
    for k in range(len(points)):
        pts.append(distortion_correction(points[k,0], points[k,1], cx, cy, kx, ky)) 
    return np.array(pts)

def image_correct_distortion(img, kx, ky):
    """Corrects the barrel distortion of the image."""
    w, h = img.shape[1], img.shape[0]
    imgu = np.zeros((h, w, 3), dtype=np.uint8)
    cx, cy = w / 2, h / 2
    R2 = cx * cx + cy * cy
    kx, ky = kx / R2, ky / R2 
    x2, y2, r2 = 0, 0, 0
    xu, yu = 0, 0
    for y in range(cy):
        y2 = y * y
        for x in range(cx):
            x2 = x * x
            r2 = x2 + y2
            xu = int(x * (1 + kx * r2))
            yu = int(y * (1 + ky * r2))
            if yu >= 0 and xu >= 0 and yu < cy and xu < cx:
                imgu[cy-yu,cx-xu] = img[cy-y,cx-x]
                imgu[cy-yu,cx+xu] = img[cy-y,cx+x]
                imgu[cy+yu,cx+xu] = img[cy+y,cx+x]
                imgu[cy+yu,cx-xu] = img[cy+y,cx-x]
    # Interpolation
    for y in range(h):
        if y > 0 and y < (h - 1):
            for x in range(w):
                if x > 0 and x < (w - 1):
                    if imgu[y,x,0] == 0 and imgu[y,x,1] == 0 and imgu[y,x,2] == 0:
                        imgu[y,x,0] = np.sum(imgu[y-1:y+2,x-1:x+2,0]) / 8
                        imgu[y,x,1] = np.sum(imgu[y-1:y+2,x-1:x+2,1]) / 8
                        imgu[y,x,2] = np.sum(imgu[y-1:y+2,x-1:x+2,2]) / 8    
    return imgu
    

if __name__ == '__main__':
#    img_names = glob.glob('img/cap*.png')

#    pattern_size = (8, 5)
#    pattern_points = np.zeros((np.prod(pattern_size), 3), np.float32)
#    pattern_points[:,:2] = np.indices(pattern_size).T.reshape(-1, 2)
#    #print pattern_points

#    obj_points = []
#    img_points = []
#    h, w = 0, 0
#    for fn in img_names:
#        print 'Processing %s... ' % fn,
#        img, found, corners = find_chessboard(fn, pattern_size)
#        #show_image(img)
#        if found:
#            chessboard = draw_chessboard(img, pattern_size, found, corners)
#            #show_image(chessboard)
#            print 'chessboard found [OK]'
#        else:
#            print 'chessboard not found [FAIL]'
#            continue
#        img_points.append(corners.reshape(-1, 2))
#        obj_points.append(pattern_points)
#        
#    h, w = img.shape[:2]

#    point_cnts = len(obj_points)
#    camera_matrix = np.identity(3)
#    dist_coefs = np.zeros((4, 1))
#    rms, camera_matrix, dist_coefs, rvecs, tvecs = cv2.calibrateCamera(obj_points, img_points, (w, h), camera_matrix, dist_coefs)
#    print "RMS:", rms
#    print "camera matrix:\n", camera_matrix
#    print "distortion coefficients: ", dist_coefs.ravel()
#    
#    print h, w
#    camera_matrix = np.array([[800., 0., 324.],
#                              [0., 800., 243.],
#                              [0., 0., 1.]])
#    dist_coefs = np.array([[-0.145], [0.], [0.], [0.], [0.]])
#    
#    intrinsics = cv.fromarray(camera_matrix)
#    dist_coeffs = cv.fromarray(dist_coefs)
#    src = cv.LoadImage('img/capture00.png')
#    dst = cv.CreateImage(cv.GetSize(src), src.depth, src.nChannels)
#    cv.Undistort2(src, dst, intrinsics, dist_coeffs)

#    test = np.asarray(cv.GetMat(dst))
#    
#    show_image(test)
#    cv2.imwrite('test.png', test)

    # Correction of barrel distortion
    Id = pl.imread('img/capture00.png', )
    Id = np.array(Id * 255, dtype='uint8')
    
    w, h = Id.shape[1], Id.shape[0]
    kx, ky = 0.035, 0.035
    
    #cx, cy = w / 2, h / 2
    #R2 = cx * cx + cy * cy
    #kx, ky = kx / R2, ky / R2
    #print distortion_correction(100, 300, cx, cy, kx, ky)

    t0 = time.time()
    Iu = image_correct_distortion(Id, kx, ky)
    t1 = time.time()
    print t1 - t0
    
    pl.figure()
    pl.subplot(1,2,1)
    pl.imshow(Id)
    pl.subplot(1,2,2)
    pl.imshow(Iu)
    pl.show()
    

    
