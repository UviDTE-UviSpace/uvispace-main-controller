#!/usr/bin/env python

import matplotlib as mpl
mpl.rcParams['font.size'] = 13.0
mpl.rcParams['xtick.labelsize'] = 9.0
mpl.rcParams['ytick.labelsize'] = 9.0
mpl.rcParams['figure.subplot.left'] = 0.08
mpl.rcParams['figure.subplot.bottom'] = 0.06
mpl.rcParams['figure.subplot.right'] = 0.92
mpl.rcParams['figure.subplot.top'] = 0.92

from matplotlib.figure import Figure
from matplotlib.backends.backend_gtkagg import FigureCanvasGTKAgg as FigureCanvas
from matplotlib.lines import Line2D
from matplotlib.patches import Rectangle, Circle, Polygon, Arrow

from pylab import *
from PIL import Image

from sensor import transform


class PlotCapture(FigureCanvas):
    def __init__(self):
        # Plot widget
        self.figure = Figure(figsize=(6,4), dpi=60)
        self.axis = self.figure.add_subplot(111, axisbg=(0,0,0))
        self.axis.get_xaxis().set_visible(False)
        self.axis.get_yaxis().set_visible(False)
        self.axis.set_aspect('equal')
        # Initializes subclass
        FigureCanvas.__init__(self, self.figure)
        self.mpl_connect('button_press_event', self.on_button_mpl_clicked)
        self.mpl_connect('resize_event', self.resize_drawing_area)
        self.show()
        # Size of image sensor and last image_gray
        self.SENSOR_WIDTH, self.SENSOR_HEIGHT = (2592, 1944)
        self.WIDTH, self.HEIGHT = (1800, 1400)
        self.trackers = 15
        self.image = None 
        self.pixel = None
        self.background = None
        self.axis_background = None
        
    def on_button_mpl_clicked(self, event):
        if self.image != None:
            self.draw_captured_image(self.image)
            try:
                x, y = int(round(event.xdata, 0)), int(round(event.ydata, 0))
                r = self.image.shape[1] * self.image.shape[0] / 50000 # radius
                region = self.image[y-r:y+r,x-r:x+r].astype(int)
                self.pixel = array([round(mean(region[:,:,0]), 0), 
                                    round(mean(region[:,:,1]), 0),
                                    round(mean(region[:,:,2]), 0)]).astype(int) * 4
                self.axis.plot(x, y,'wo')
                self.axis.fill([x-r, x-r, x+r, x+r], [y-r, y+r, y+r, y-r], color='w')
                self.axis.text(x + 3, y + 3, '(%i,%i,%i)' %tuple(self.pixel / 4), size=10, 
                               color='w', ha='left', va='top') 
                self.draw()
            except:
                return
        
    def resize_drawing_area(self, event):
        if self.axis_background:
            self.draw_location_area()
            if any(self.background):
                self.draw_background_image(self.background)
         
    def draw_canvas_plot(self):
        self.axis.cla()
        self.axis.spines['left'].set_color('k')
        self.axis.spines['bottom'].set_color('k')
        self.axis.spines['right'].set_color('k')
        self.axis.spines['top'].set_color('k')
        self.axis.grid(True)
        
    def draw_active_image(self, start_column, start_row, column_size, row_size, skip):
        """Draws the active image in the area video_sensor."""
        self.image = None
        self.axis_background = None
        self.draw_canvas_plot()
        self.axis.set_title('Camera Sensor')
        x0, y0 = start_column, start_row
        x1, y1 = start_column + column_size, start_row + row_size
        width, height = (column_size + 1) / (skip + 1), (row_size + 1) / (skip + 1)
        txt = 'Active Image\n(%ix%i)\nZoom 1/%i' %(width, height, skip + 1)
        self.axis.fill([x0, x0, x1, x1], [y0, y1, y1, y0], color='w')
        self.axis.text((x0 + x1) / 2, (y0 + y1) / 2, txt, size=18, 
                       ha='center', va='center')
        self.axis.text(x1 - 10, y1 - 10, '(%i,%i)'%(x1, y1), size=9, 
                       ha='left', va='top')
        self.axis.set_xlim(self.SENSOR_WIDTH, 0)
        self.axis.set_ylim(0, self.SENSOR_HEIGHT)
        self.draw()
        
    def draw_captured_image(self, image, gray=False):
        """Draws the captured image."""
        self.image = image
        self.axis_background = None
        self.draw_canvas_plot()
        self.axis.set_title('Image Captured')
        if gray:
            self.axis.imshow(image, cmap=cm.gray)
        else:
            self.axis.imshow(image)
        self.axis.set_xlim(0, image.shape[1])
        self.axis.set_ylim(image.shape[0], 0)
        self.draw()
        
    def draw_targets_positions(self, image, shapes_list):
        """Draws corners position and figure contour of the located target shapes."""
        img = self.image
        self.draw_captured_image(image)
        self.image = img
        self.axis.set_title('Shapes Located')
        cols = ['r', 'g', 'b']
        for i, shapes in enumerate(shapes_list):
            if shapes:
                for corners in shapes:
                    self.axis.add_patch(Polygon(corners, closed=True, alpha=.5,
                                                fc=cols[i], ec='y', lw=1))
                    self.axis.plot(corners[:,0], corners[:,1], 'yo', lw=2)
        self.draw()
        
    def draw_location_area(self):
        """Draws the location area for all sensors."""
        self.image = None
        self.axis.cla()
        self.axis.set_title('Location Area')
        self.axis.spines['left'].set_position('center')
        self.axis.spines['bottom'].set_position('center')
        self.axis.spines['left'].set_color('y')
        self.axis.spines['bottom'].set_color('y')
        self.axis.spines['right'].set_color('none')
        self.axis.spines['top'].set_color('none')
        self.axis.set_xlim(-self.WIDTH, self.WIDTH)
        self.axis.set_ylim(-self.HEIGHT, self.HEIGHT)  
        # Draw grid
        for j in range(-3, 3):
            x1, y1 = -self.WIDTH, j * 400 + 200
            x2, y2 = self.WIDTH, j * 400 + 200
            self.axis.plot([x1, x2], [y1, y2], 'y--')
        for i in range(-4, 4):
            x1, y1 = i * 400 + 200, self.HEIGHT 
            x2, y2 = i * 400 + 200, -self.HEIGHT
            self.axis.plot([x1, x2], [y1, y2], 'y--')
        # Draw border
        self.axis.plot([-self.WIDTH, self.WIDTH], [-self.HEIGHT, -self.HEIGHT], 'y-', lw=5)
        self.axis.plot([-self.WIDTH, self.WIDTH], [self.HEIGHT, self.HEIGHT], 'y-', lw=5)
        self.axis.plot([-self.WIDTH, -self.WIDTH], [-self.HEIGHT, self.HEIGHT], 'y-', lw=5)
        self.axis.plot([self.WIDTH, self.WIDTH], [-self.HEIGHT, self.HEIGHT], 'y-', lw=5)
        self.draw()
        self.axis_background = self.figure.canvas.copy_from_bbox(self.axis.bbox)
        # Deletes drawing objects
        self.windows, self.shapes = {}, {}
        self.robots, self.obstacles = {}, {}
        self.text_frame_rate = []
        
    def draw_background_image(self, image):
        """Draws the background image captured by all cameras."""
        self.background = image
        self.axis.imshow(image, extent=[-self.WIDTH, self.WIDTH, 
                                        -self.HEIGHT, self.HEIGHT])
        self.draw()
        
    def update_windows(self, windows):
        for window_id, window in windows.iteritems():
            window = transform.calibrated_points(window)
            if window_id in self.windows:
                self.windows[window_id]['rect'].set_xy([window[0,0], window[0,1]])
                self.windows[window_id]['rect'].set_width(window[1,0] - window[0,0])
                self.windows[window_id]['rect'].set_height(window[1,1] - window[0,1])
                self.axis.draw_artist(self.windows[window_id]['rect'])
            else:
                rect = Rectangle([0, 0], 0, 0, alpha=.3, color='w', lw=1, 
                                 animated=True)
                self.axis.add_patch(rect)
                self.windows[window_id] = {'rect': rect}
    
    def update_shapes(self, shapes):
        for shape_id, shape in shapes.iteritems():
            shape = transform.calibrated_points(shape)
            if shape_id in self.shapes:
                self.shapes[shape_id]['line'].set_data(shape[:,0], shape[:,1])
                self.shapes[shape_id]['polygon'].xy = shape
                self.axis.draw_artist(self.shapes[shape_id]['line'])
                self.axis.draw_artist(self.shapes[shape_id]['polygon'])
            else:
                line = Line2D([0], [0], color='y', ls='None', marker='o', 
                              animated=True)
                poly = Polygon([[0, 0]], closed=True, alpha=.25, color='y', lw=2, 
                               animated=True)
                self.axis.add_line(line)
                self.axis.add_patch(poly)
                self.shapes[shape_id] = {'line': line, 'polygon': poly}
        
    def update_robots(self, robots):
        for robot_id, robot in robots.iteritems():
            if robot_id in self.robots:
                v0 = [robot[0] + 150 * cos(robot[2]), robot[1] + 150 * sin(robot[2])]
                v1 = [robot[0] + 15 * cos(robot[2] - pi/2), robot[1] + 15 * sin(robot[2] - pi/2)]
                v2 = [robot[0] + 15 * cos(robot[2] + pi/2), robot[1] + 15 * sin(robot[2] + pi/2)]
                self.robots[robot_id]['polygon'].xy = [v0, v1, v2]
                x, y = self.robots[robot_id]['data'][0], self.robots[robot_id]['data'][1]
                x.append(robot[0]), y.append(robot[1])
                self.robots[robot_id]['line'].set_data(x, y)
                self.robots[robot_id]['text'].set_x(robot[0])
                self.robots[robot_id]['text'].set_y(robot[1])
                #self.robots[robot_id]['text'].set_text('%s\n(%i,%i)' %(robot_id, robot[0], robot[1]))   
                self.axis.draw_artist(self.robots[robot_id]['line'])
                self.axis.draw_artist(self.robots[robot_id]['polygon'])
                self.axis.draw_artist(self.robots[robot_id]['text'])
            else:
                poly = Polygon([[0, 0]], closed=True, alpha=.7, color='m', 
                               animated=True)
                line, data = Line2D([0], [0], color='white', marker='+'), [[], []]
                text = self.axis.text(0, 0, robot_id, size=11, color='w', 
                                      ha='center', va='center', animated=True)
                self.axis.add_patch(poly)
                self.axis.add_line(line)
                self.robots[robot_id] = {'polygon': poly, 'line': line, 
                                         'data': data, 'text': text}
    
    def update_obstacles(self, obstacles):
        for obstacle_id, obstacle in obstacles.iteritems():
            if obstacle_id in self.obstacles:
                self.obstacles[obstacle_id]['circle'].center = (obstacle[0], obstacle[1])
                self.obstacles[obstacle_id]['circle'].radius = obstacle[2]
                self.obstacles[obstacle_id]['text'].set_x(obstacle[0])
                self.obstacles[obstacle_id]['text'].set_y(obstacle[1])
                self.axis.draw_artist(self.obstacles[obstacle_id]['circle'])
                self.axis.draw_artist(self.obstacles[obstacle_id]['text'])
            else:
                cir = Circle((0, 0), radius=0, alpha=.5, fc='m', animated=True)
                text = self.axis.text(0, 0, obstacle_id, size=11, color='w', 
                                      ha='center', va='center', animated=True)
                self.axis.add_patch(cir)
                self.obstacles[obstacle_id] = {'circle': cir, 'text': text}
            
    def update_info(self, frame, frame_rate):
        if self.text_frame_rate == []:
            self.text_frame_rate = self.axis.text(self.WIDTH-25, -self.HEIGHT+25,
                                                  'FPS: 0', size=13, color='y', 
                                                  ha='right', va='bottom', 
                                                  animated=True)
        else:
            self.text_frame_rate.set_text('FPS: %.1f\nFrame: %i' %(frame_rate, frame))   
            self.axis.draw_artist(self.text_frame_rate)
            
    def draw_positions(self, robots, obstacles, frame, frame_rate, windows={}, positions={}):
        self.restore_region(self.axis_background)
        
        self.update_windows(windows)
        self.update_shapes(positions)
        self.update_robots(robots)
        self.update_obstacles(obstacles)
        self.update_info(frame, frame_rate)

        self.blit(self.axis.bbox)
