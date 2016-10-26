#!/usr/bin/env python
"""
This is the multi-camera system controller, extensible to more of four cameras.
"""

import os
import time
import threading
import logging

from PIL import Image

from pylab import array, asarray, vstack

from sensor import processing
from sensor.video_sensor import VideoSensor

logging.basicConfig(level=logging.INFO, format='[%(levelname)s] (%(threadName)-10s) %(message)s', )

class VideoSensorThread(threading.Thread, VideoSensor):
    def __init__(self, filename, quadrant):
        threading.Thread.__init__(self)
        VideoSensor.__init__(self, filename=filename, quadrant=quadrant)
        self.positions = {}
        self.windows = {}
        
        self.leaving_objects = {}
        self.leaved_objects = {}
        
        self.activate = {}
        self.deactivate = {}
        
        self.running = True
        self.lock = threading.Lock()
        self.condition = threading.Condition()
        self.lock.acquire()
        #Starts the thread activity
        self.start()
        
    def kill(self):
        """Kills the thread execution."""
        self.running = False
        self.lock.release()
        
    def stop_run(self):
        """Locks the thread."""
        self.lock.acquire()
        
    def start_run(self):
        """Unlocks the thread."""
        self.lock.release()
        
    def run(self):
        while self.running:
            # Reads locations and windows if the thread is unlocked. (Lock) 
            self.lock.acquire()
            positions = self.get_current_positions()
            windows = self.get_current_windows()
            self.lock.release()
            
            # Processes locations with mutual exclusion. (Condition)
            self.condition.acquire()
            
            self.positions = positions
            self.windows = windows
            logging.debug(positions)
            logging.debug(windows)
            
            self.leaving_objects = self.get_leaving_windows(positions, windows)
            self.leaved_objects = self.get_leaved_windows(positions, windows)
            
            # Frees not used tracker resources
            for tracker_id in self.deactivate.iterkeys():
                if tracker_id in self.trackers.keys():
                    logging.debug(self.free_tracker(tracker_id))
            self.deactivate = {}
            
            # Configures new tracker resources
            for tracker_id, window in self.activate.iteritems():
                if tracker_id not in self.trackers.keys():
                    logging.debug(self.configure_tracker(tracker_id, window))
            self.activate = {}
            
            self.condition.notify_all()
            self.condition.release()
    
    def _check_box_in(self, box, margin=0):
        """Checks if the box is in the area of the sensor."""
        sbox = array([[margin, margin], 
                      [self.width - 2 * margin, self.height - 2 * margin]])
        sbox = self.transform_points_to_global(sbox)
        return processing.check_global_box_in(box, sbox)
            
    def _check_box_out(self, box, margin=10):
        """Checks if the box is out the area of the sensor."""
        sbox = array([[margin, margin], 
                      [self.width - 2 * margin, self.height - 2 * margin]])
        sbox = self.transform_points_to_global(sbox)
        return processing.check_global_box_out(box, sbox)
            
    def _check_box_over(self, box, margin=10):
        """Checks if the box is over the border of the area sensor."""
        sbox = array([[margin, margin], 
                      [self.width - 2 * margin, self.height - 2 * margin]])
        sbox = self.transform_points_to_global(sbox)
        return processing.check_global_box_over(box, sbox)
            
#    def get_leaving_objects(self, positions):
#        """Gets the objects over the border area of the sensor."""
#        leaving_objects = {}
#        for id, points in positions.iteritems():
#            box = processing.global_bounding_box(points)
#            if not self._check_box_out(box, margin=10):
#                if self._check_box_over(box, margin=1):
#                    leaving_objects[id] = box
#        return leaving_objects  
            
    def _check_point_in(self, point, margin=0):
        """Checks if the point is in the area of the sensor."""
        box = array([[margin, margin], 
                     [self.width - 2 * margin, self.height - 2 * margin]])
        box = self.transform_points_to_global(box)
        return processing.check_point_into_global_box(point, box)
            
    def get_leaving_windows(self, positions, windows):
        """Gets the objects over the border area of the sensor."""
        leaving_objects = {}
        for window_id, window in windows.iteritems():
            if window_id in self.trackers.keys():
                if not self._check_box_out(window, margin=10):
                    if self._check_box_over(window, margin=1):
                        # Calculates the real global window
                        if self._check_point_in(window[0], margin=10):
                            window = array([[window[0,0], window[0,1]],
                                            [window[0,0] + (self.skip + 1) * self.trackers[window_id][2], 
                                             window[0,1] - (self.skip + 1) * self.trackers[window_id][3]]])
                        if self._check_point_in(window[1], margin=10):
                            window = array([[window[1,0] - (self.skip + 1) * self.trackers[window_id][2], 
                                             window[1,1] + (self.skip + 1) * self.trackers[window_id][3]],
                                            [window[1,0], window[1,1]]])
                        leaving_objects[window_id] = window
        return leaving_objects
    
#    def get_leaved_objects(self, positions):
#        """Gets the objects out of the border area of the sensor."""
#        leaved_objects = {}
#        for id, points in positions.iteritems():
#            box = processing.global_bounding_box(points)
#            if self._check_box_out(box, margin=10):
#                leaved_objects[id] = box
#        return leaved_objects 
    
    def get_leaved_windows(self, positions, windows):
        """Gets the objects out of the border area of the sensor."""
        leaved_objects = {}
        for window_id, window in windows.iteritems():
            if window_id in self.trackers.keys():
                if self._check_box_over(window, margin=10):
                    if window_id not in positions.keys():
                        leaved_objects[window_id] = window
        return leaved_objects
            
    def set_tracker(self, tracker_id, window):
        self.condition.acquire()
        self.condition.wait()
        self.activate[tracker_id] = window
        self.condition.release()
        
    def get_tracker(self, tracker_id):
        self.condition.acquire()
        self.condition.wait()
        self.deactivate[tracker_id] = None
        self.condition.release()
        
    def get_image(self):
        self.condition.acquire()
        self.condition.wait()
        image = self.get_new_frame(gray=True)
        self.condition.release()
        return image
    
    def get_objects_positions(self):
        self.condition.acquire()
        while self.positions is None:
            self.condition.release()
            time.sleep(0.001)
            self.condition.acquire()
        positions = self.positions
        self.positions = None
        self.condition.release()
        return positions
    
    def get_search_windows(self):
        self.condition.acquire()
        while self.windows is None:
            self.condition.release()
            time.sleep(0.001)
            self.condition.acquire()
        windows = self.windows
        self.windows = None
        self.condition.release()
        return windows
    
    def get_leaving_trackers(self):
        self.condition.acquire()
        while self.leaving_objects is None:
            self.condition.release()
            time.sleep(0.001)
            self.condition.acquire()
        leaving_objects = self.leaving_objects
        self.leaving_objects = None
        self.condition.release()
        return leaving_objects
        
    def get_leaved_trackers(self):
        self.condition.acquire()
        while self.leaved_objects is None:
            self.condition.release()
            time.sleep(0.001)
            self.condition.acquire()
        leaved_objects = self.leaved_objects
        self.leaved_objects = None
        self.condition.release()
        return leaved_objects


class SystemController():
    def __init__(self):
        self.sensors = {}
        self.targets = {}
        self.sensors_list = self._check_available_sensors()
        self.connect_sensors(self.sensors_list)    
        
    def _check_available_sensors(self):
        """Checks if exist a configuration file of the video sensor."""
        file_list = os.listdir(os.getcwd())
        sens_list = []
        for i in range(4):
            conf_file = 'video_sensor{}.cfg'.format(i + 1)
            if conf_file in file_list:
                sensor = VideoSensor(conf_file, quadrant=i+1)
                if sensor.connected:
                    sensor.disconnect()
                    sens_list.append(i + 1)
        return sens_list 
        
    def connect_sensors(self, sensors_list):
        logging.info('Connecting video sensors...')
        for sensor_id in sensors_list:
            self.sensors[sensor_id] = VideoSensorThread('video_sensor%i.cfg' %(sensor_id), sensor_id) 
        logging.info('Connected video sensors.')
        
    def disconnect_sensors(self):
        logging.info('Disconnecting video sensors...')
        for sensor in self.sensors.itervalues():
            sensor.disconnect()
        logging.info('Disconnected video sensors.')
        
    def init_sensors(self):
        logging.info('Initiating video sensors...')
        self.get_image_packages(fake=True)
        from sensor.video_sensor import init_tracking
        for sensor in self.sensors.itervalues():
            t0 = time.time()
            self.targets.update(init_tracking(sensor, len(self.targets)))
            t1 = time.time()
            print 'Time to initiate video sensors:', t1 - t0
        logging.info('Initiated video sensors.')
        
    def start_sensors(self):
        logging.info('Starting video sensors...')
        for sensor in self.sensors.itervalues():
            #releases the lock object. Resets the lock to unlocked and returns
            sensor.lock.release()
        logging.info('Started video sensors.')
        
    def stop_sensors(self):
        logging.info('Stopping video sensors...')
        for sensor in self.sensors.itervalues():
            sensor.stop_run()
            sensor.select_output(0)
            sensor.configure()
        logging.info('Stopped video sensors.')
    
    def end_sensors(self):
        logging.info('Ending video sensors...')
        for sensor in self.sensors.itervalues():
            sensor.kill()
            sensor.join()
            sensor.disconnect()
        logging.info('Ended video sensors.')
    
    def save_configuration(self):
        logging.info('Saving video sensors configuration...')
        for sensor in self.sensors.itervalues():
            sensor.save_configuration()
        logging.info('Saved video sensors configuration.')
      
    def get_image_packages(self, fake=False):
        """Gets the image of the camera sensors for the system initialization."""
        WIDTH, HEIGHT = 2592, 1944
        image = Image.new('RGB', (2 * WIDTH, 2 * HEIGHT))
        if not fake:
            for k, sensor in self.sensors.iteritems():
                width, height = sensor.width, sensor.height
                points = sensor.transform_points_to_global(array([[0, 0], [width, height]]))
                left, top = points[0,0] + WIDTH, abs(points[0,1] - HEIGHT)
                right, bottom = points[1,0] + WIDTH, abs(points[1,1] - HEIGHT)
                sensor.select_output(0)
                sensor.configure()
                img = Image.fromarray(sensor.get_new_frame())
                img = img.resize(((sensor.skip + 1) * width, (sensor.skip + 1) * height))
                img.save('capture_cam%s.png' %k)
                image.paste(img, (left, top, right, bottom))
        self.image = asarray(image)
        self.image_gray = asarray(image.convert('L')) # convert to grayscale
        return self.image

    def _points_to_box(self, points):
        """Returns the bounding box of the points."""
        x1, y1 = min(points[:,0]), max(points[:,1])
        x2, y2 = max(points[:,0]), min(points[:,1])
        box = array([[x1, y1], [x2, y2]])
        return box
    
    def _merge_windows(self, windows1, windows2):
        """Merges the windows with the same id."""
        windows = windows1
        for id2, window2 in windows2.iteritems():
            if id2 in windows1.keys():
                windows[id2] = self._points_to_box(vstack((windows1[id2], windows2[id2])))
            else:
                windows[id2] = window2
        return windows
        
    def get_current_windows(self):
        """Gets search windows of all trackers from the camera sensors system."""
        windows = {}
        for sensor in self.sensors.itervalues():
            windows = self._merge_windows(windows, sensor.get_search_windows())
        logging.debug(windows)
        return windows
    
    def _merge_positions(self, positions1, positions2):
        """Merges the arrays of positions with the same id."""
        positions = positions1
        for id2, position2 in positions2.iteritems():
            if id2 in positions1.keys():
                positions[id2] = vstack((positions1[id2], positions2[id2]))
            else:
                positions[id2] = position2
        return positions
        
    def get_current_positions(self):
        """Gets the current corners positions of all trackers in the system and
        merges those that have the same id."""
        positions = {}
        for sensor in self.sensors.itervalues():
            positions = self._merge_positions(positions, sensor.get_objects_positions())
        logging.debug(positions)
        return positions
        
    def _reposition_window(self, point, size, width, height):
        """Repositions the coordinates of the window."""
        if point[0] +  size[0] > width:
            x = width - size[0]
        else:
            x = point[0]
        if point[1] + size[1] > height:
            y = height - size[1]
        else:
            y = point[1]
        return [x, y, size[0], size[1]]
        
    def process_trackers(self):
        """Processes the trackers in the border zone for activate or deactivate
        the corresponding devices."""
        # Leaving area (activate tracker) and Leaved area (deactivate tracker)
        leaving_objects = {}
        for sensor in self.sensors.itervalues():
            objects = sensor.get_leaving_trackers()
            leaving_objects.update(objects)
        for sensor in self.sensors.itervalues():
            leaved_objects = sensor.get_leaved_trackers()
            for leaved_id in leaved_objects:
                logging.debug(sensor.get_tracker(leaved_id))
                logging.info('Leaved area for id: %s' %leaved_id)
            for leaving_id in leaving_objects.iterkeys():
                if leaving_id not in sensor.trackers.keys():# and leaving_id not in leaved_objects.keys():
                    if sensor._check_box_over(leaving_objects[leaving_id], margin=1):
                        box = sensor.transform_points_to_local(leaving_objects[leaving_id])
                        point, size = [box[0,0], box[0,1]], self.targets[leaving_id]
                        x, y, width, height = self._reposition_window(point, size, sensor.width, sensor.height)
                        logging.debug(sensor.set_tracker(leaving_id, [x, y, width, height]))
                        logging.info('Leaving area for id: %s' %leaving_id)                   
        
    def get_robots_position(self, positions):
        """Gets positions of all robots from the camera sensors system."""
        robots = {} # List of detected robots
        triangles, squares = processing.get_triangle_and_square_shapes(positions)
        for triangle_id, triangle in triangles.iteritems():
            robots[triangle_id] = processing.get_triangle_position(triangle)
        logging.debug('Robots: %s' %robots)
        return robots
        
    def get_obstacles_position(self, positions):
        """Gets positions of all obstacles form the camera sensors system."""
        obstacles = {} # List of detected obstacles
        triangles, squares = processing.get_triangle_and_square_shapes(positions)
        for square_id, square in squares.iteritems():
            obstacles[square_id] = processing.get_square_position(square)
        logging.debug('Obstacles: %s' %obstacles)
        return obstacles
        
    def set_active_robots(self, request):
        """Activates a deactivated robot."""
        ids = request.split(' ')[2:]
        for robot_id in ids:
            self.active_robots.append(robot_id)
            for sensor in self.sensors.itervalues():
                sensor.activate_tracker(robot_id)
    
    def del_active_robots(self, request):
        """Deactivates a activated robot."""
        ids = request.split(' ')[2:]
        for robot_id in ids:
            self.active_robots.remove(robot_id)
            for sensor in self.sensors.itervalues():
                sensor.deactivate_tracker(robot_id)
        
    def get_active_robots_position(self):
        """Gets the position list of active robots.""" 
        robots = {}
        for sensor in self.sensors.itervalues():
            robots.update(sensor.get_robots_positions(self.thread_id))
        logging.debug(robots)
        return robots



class SystemControllerThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.robots = {}
        self.obstacles = {}
        self.condition = threading.Condition()
        self.system_controller = SystemController()
        self.running = True
        
    def stop(self):
        self.running = False
        
    def run(self):
        while self.running:
            positions = self.system_controller.get_current_positions()
            #windows = self.system_controller.get_current_windows()
            self.system_controller.process_trackers() # WARNING!!!
            self.condition.acquire() #acquire the lock
            # Gets locations of all robots and obstacles
            robots = self.system_controller.get_robots_position(positions)
            obstacles = self.system_controller.get_obstacles_position(positions)
            #logging.debug(robots)
            #logging.debug(obstacles)
            for thread_id in self.robots.iterkeys():
                self.robots[thread_id] = robots
            for thread_id in self.obstacles.iterkeys():
                self.obstacles[thread_id] = obstacles
            self.condition.notifyAll()
            self.condition.release()
            
    def get_image_gray(self):
        #self.condition.acquire()
        #self.condition.release()
        return self.system_controller.image_gray
            
    def get_robots_positions(self, thread_id):
        self.condition.acquire()
        while self.robots[thread_id] is None:
            self.condition.release()
            time.sleep(0.001)
            self.condition.acquire()
        robots = self.robots[thread_id]
        self.robots[thread_id] = None
        self.condition.release()
        return robots
    
    def get_obstacles_positions(self, thread_id):
        self.condition.acquire()
        while self.obstacles[thread_id] is None:
            self.condition.release()
            time.sleep(0.001)
            self.condition.acquire()
        obstacles = self.obstacles[thread_id]
        self.obstacles[thread_id] = None
        self.condition.release()
        return obstacles
    
    def add_shared_resources(self, thread_id):
        self.robots[thread_id] = None
        self.obstacles[thread_id] = None
    
    def del_shared_resources(self, thread_id):
        del self.robots[thread_id]
        del self.obstacles[thread_id]
    



if __name__ == '__main__':
    
    sc = SystemController()
    image = sc.get_image_packages()
    imshow(image)
    show()
    
    sc.init_sensors()
    positions = sc.get_current_positions()
    print sc.get_robots_position(positions)
    sc.start_sensors()
    sc.disconnect_sensors()
    
