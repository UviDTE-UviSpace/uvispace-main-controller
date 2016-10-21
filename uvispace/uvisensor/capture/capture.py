#!/usr/bin/env python
import gtk
import gobject
import logging
import time

from PIL import Image
from pylab import *

from system_controller import SystemController
from plot_capture import PlotCapture
from sensor import processing
from sensor import threshold

#----------
import roslib
import rospy
from geometry_msgs.msg import Pose2D
#----------

            
class Capture:
    def __init__(self):
        #----------
        rospy.init_node('capture')
        self.pub_pose_0 = rospy.Publisher('/robot_0/pose2d', Pose2D)
        self.pub_pose_1 = rospy.Publisher('/robot_1/pose2d', Pose2D)
        self.pub_pose_2 = rospy.Publisher('/robot_2/pose2d', Pose2D)
        #----------

        self.builder = gtk.Builder()
        self.builder.add_from_file('capture.glade')
        self.builder.connect_signals(self)      
        
        self.window = self.builder.get_object('window')
        
        # Plot widget
        alignment_plot = self.builder.get_object('alignment_plot')
        self.plot_capture = PlotCapture()
        alignment_plot.add(self.plot_capture)
        
        self.button_run = self.builder.get_object('button_run')
        self.button_update = self.builder.get_object('button_update')
        self.button_configure = self.builder.get_object('button_configure')
        
        # Configuration area
        self.notebook_configuration = self.builder.get_object('notebook_configuration')
        self.notebook_configuration.hide()
        
        # Configures the image size and the exposure value
        self.entry_width = self.builder.get_object('entry_width')
        self.entry_height = self.builder.get_object('entry_height')
        self.hscale_exposure = self.builder.get_object('hscale_exposure')
        
        # Configures the active output
        self.combobox_select = self.builder.get_object('combobox_select')
        self.button_vga = self.builder.get_object('button_vga')
        
        # Video sensors system controller, it checks available sensors when is
        # instantiated.
        self.system_controller = SystemController()
        sensors = self.system_controller.sensors_list
        self.video_sensor = None
        # Configures active quadrants for available sensors 
        self.button_quadrant = [self.builder.get_object('button_quadrant1'),
                                self.builder.get_object('button_quadrant2'),
                                self.builder.get_object('button_quadrant3'),
                                self.builder.get_object('button_quadrant4')]
        [self.button_quadrant[sens-1].set_sensitive(True) for sens in sensors]
        
        # Color buttons
        self.button_color1 = self.builder.get_object('button_color1')
        self.button_color2 = self.builder.get_object('button_color2')
        self.button_color3 = self.builder.get_object('button_color3')
        # Red thresholds components
        self.entries_red_min = (self.builder.get_object('entry_red_min_R'),
                                self.builder.get_object('entry_red_min_G'),
                                self.builder.get_object('entry_red_min_B'))
        self.entries_red_max = (self.builder.get_object('entry_red_max_R'),
                                self.builder.get_object('entry_red_max_G'),
                                self.builder.get_object('entry_red_max_B'))
        # Green thresholds components
        self.entries_green_min = (self.builder.get_object('entry_green_min_R'),
                                  self.builder.get_object('entry_green_min_G'),
                                  self.builder.get_object('entry_green_min_B'))
        self.entries_green_max = (self.builder.get_object('entry_green_max_R'),
                                  self.builder.get_object('entry_green_max_G'),
                                  self.builder.get_object('entry_green_max_B'))
        # Blue thresholds components
        self.entries_blue_min = (self.builder.get_object('entry_blue_min_R'),
                                 self.builder.get_object('entry_blue_min_G'),
                                 self.builder.get_object('entry_blue_min_B'))
        self.entries_blue_max = (self.builder.get_object('entry_blue_max_R'),
                                 self.builder.get_object('entry_blue_max_G'),
                                 self.builder.get_object('entry_blue_max_B'))
                        
        self.plot_capture.draw_location_area()
        
        self.window.show()
        
    def start_video_sensor(self, quadrant):
        """Starts the video sensor selected."""
        self.video_sensor = self.system_controller.sensors[quadrant]
        if self.video_sensor.image == None:
            self.video_sensor.get_new_frame()
        # Configures the image size and the image exposure
        self.entry_width.set_value(self.video_sensor.width)
        self.entry_height.set_value(self.video_sensor.height)
        self.hscale_exposure.set_value(self.video_sensor.exposure)
        # Configures the active image output
        self.combobox_select.set_active(0)
        self.button_vga.set_active(False)
        # Configures the selected thresholds
        self.read_thresholds()
        
    def stop_video_sensor(self):
        """Stops the video sensor activated."""
        if self.video_sensor:
            self.video_sensor.configure()
            self.video_sensor = None
        
    def on_window_destroy(self, widget):
        """Closes window and saves configuration values."""
        if self.button_configure.get_active():
            self.stop_video_sensor()
        else:
            if self.button_run.get_active():
                self.system_controller.stop_sensors()
        self.system_controller.end_sensors()
        gtk.main_quit()
        
    def update_locations(self):
        """Updates the location of the targets."""
        if self.button_run.get_active():
            if self.button_configure.get_active():
                positions = self.video_sensor.get_current_positions()
                windows = self.video_sensor.get_current_windows()
                robots = self.video_sensor.get_robots_position(positions)
                print robots
                obstacles = self.video_sensor.get_obstacles_position(positions)
            else:
                positions = self.system_controller.get_current_positions()
                windows = self.system_controller.get_current_windows()
                self.system_controller.process_trackers() # WARNING!!!
                robots = self.system_controller.get_robots_position(positions)
                print robots
                #----------
                # ROS publisher
                rospy.loginfo(robots)
                x, y, theta  = 0, 0, 0
                for id, robot in robots.iteritems():
                    x, y, theta = robot[0] / 1000, robot[1] / 1000, robot[2]
                    if id == '0':
                        self.pub_pose_0.publish(Pose2D(x, y, theta))
                    if id == '1':
                        self.pub_pose_1.publish(Pose2D(x, y, theta))
                    if id == '2':
                        self.pub_pose_2.publish(Pose2D(x, y, theta))
                #----------
                obstacles = self.system_controller.get_obstacles_position(positions)
            t0 = time.time()
            self.plot_capture.draw_positions(robots, obstacles, 
                                             self.frame, self.frame_rate, 
                                             windows=windows, positions=positions)
            t1 = time.time()
            logging.debug('Drawing time: %.5f' %(t1 - t0))
            self.frame = self.frame + 1
            if self.frame > 25:
                self.times = append(self.times[1:], time.time()) 
                #self.frame_rate = round(self.frame / (time.time() - self.start_time), 1)
                fps = round(25.0 / (self.times[-1] - self.times[0]), 1)
                #if fps > self.frame_rate:
                self.frame_rate = fps 
            else:
                self.times = append(self.times, time.time())
            logging.debug('Frame: %i, FPS=%.1f' %(self.frame, self.frame_rate))
            return True
        else:
            return False
    
    def on_button_run_clicked(self, widget):
        """Runs the location system and shows targets located."""
        if self.button_run.get_active():
            widget.set_stock_id(gtk.STOCK_MEDIA_STOP)
            widget.set_label('Stop')
            self.button_update.set_sensitive(False)
            self.button_configure.set_sensitive(False)
            # Sensors initialization
            self.plot_capture.background = None
            self.plot_capture.draw_location_area()
            if self.button_configure.get_active():
                self.video_sensor.select_output(4)
                self.camera_configure()
                #self.plot_capture.trackers = self.video_sensor.trackers
                from sensor.video_sensor import init_tracking
                init_tracking(self.video_sensor)
            else:
                self.system_controller.init_sensors()
                self.system_controller.start_sensors()
            # Sensors visualization
            self.frame, self.frame_rate = 0, 0
            self.start_time = time.time()
            self.times = array([])
            gobject.idle_add(self.update_locations)
        else:
            widget.set_stock_id(gtk.STOCK_MEDIA_PLAY)
            widget.set_label('Run')
            self.button_update.set_sensitive(True)
            self.button_configure.set_sensitive(True)
            # Sensors stopping
            if self.button_configure.get_active():
                self.video_sensor.select_output(0)
                self.video_sensor.configure()
                image = self.video_sensor.get_new_frame()
                self.plot_capture.draw_captured_image(image)
            else:
                self.system_controller.stop_sensors()
                self.plot_capture.draw_location_area()
    
    def on_button_update_clicked(self, widget):
        """Updates the background image captured by cameras."""
        if self.button_configure.get_active():
            self.video_sensor.configure()
            image = self.video_sensor.get_new_frame()
            self.plot_capture.draw_captured_image(image)
        else:
            image = self.system_controller.get_image_packages()
            self.plot_capture.draw_background_image(image)
    
    def on_button_configure_clicked(self, widget):
        """Shows the graphical interface for camera and sensor configuration."""
        if widget.get_active():
            self.notebook_configuration.show()
            if all([not button.get_active() for button in self.button_quadrant]):
                self.button_quadrant[self.system_controller.sensors_list[0]-1].emit('clicked')
            self.plot_capture.draw_captured_image(self.video_sensor.get_new_frame())
        else:
            self.video_sensor.configure()
            self.notebook_configuration.hide()
            self.plot_capture.draw_location_area()
        
    def on_button_about_clicked(self, widget):
        """Shows the about dialog."""
        about = gtk.AboutDialog()
        about.set_program_name('iSpace Location System\nConfiguration Tool')
        about.set_version('1.7.7 (13.11)')
        about.set_copyright('\n'.join(('Copyright (c) 2011, 2012, 2013 DTE Universidade de Vigo',
                                       'Jorge Rodriguez Araujo <grrodri@gmail.com>')))
        about.set_comments('This is the configuration tool of the iSpace Location System.')
        about.set_logo(gtk.gdk.pixbuf_new_from_file('ico/camera.png'))
        about.set_transient_for(self.window)
        about.run()
        about.destroy()
                
    def save_video_sensor_configuration(self):
        """Shows the save configuration message dialog."""
        dialog = gtk.MessageDialog(self.window, gtk.DIALOG_DESTROY_WITH_PARENT,
                                   gtk.MESSAGE_QUESTION, gtk.BUTTONS_YES_NO,
                                   'Save the system configuration?')
        dialog.set_transient_for(self.window)
        reply = dialog.run()
        if reply == gtk.RESPONSE_YES:
            self.system_controller.save_configuration()
        dialog.destroy()    
        
    def on_button_save_clicked(self, widget):
        """Saves the configuration files of the video sensors."""
        if self.button_configure.get_active():
            self.video_sensor.save_configuration()
        else:
            self.system_controller.save_configuration()
        
    def on_button_quit_clicked(self, widget):
        """Closes connections and exits."""
        #if not self.button_configure.get_active():
        #    self.save_video_sensor_configuration()
        self.on_window_destroy(widget)
        
#------------------------------------------------------------------------------ 
        
    def _draw_active_image(self):
        self.plot_capture.draw_active_image(self.video_sensor.start_column,
                                            self.video_sensor.start_row,
                                            self.video_sensor.column_size,
                                            self.video_sensor.row_size,
                                            self.video_sensor.skip)
        self.video_sensor.configured = False
        
#------------------------------------------------------------------------------ 

    # Sets the size of the image (width, height)
        
    def on_entry_width_changed(self, widget):
        self.video_sensor.width = int(widget.get_value())
        self.video_sensor.configure_skip_mode()
        self.video_sensor.configure_active_image()
        widget.set_value(self.video_sensor.width)
        self._draw_active_image()
        
    def on_entry_height_changed(self, widget):
        self.video_sensor.height = int(widget.get_value())
        self.video_sensor.configure_skip_mode()
        self.video_sensor.configure_active_image()
        widget.set_value(self.video_sensor.height)
        self._draw_active_image()
        
#------------------------------------------------------------------------------ 
        
    def on_button_up_clicked(self, widget):
        """Moves up the video_sensor area."""
        self.video_sensor.start_row += 20
        self.video_sensor.configure_active_image()
        self._draw_active_image()
        
    def on_button_down_clicked(self, widget):
        """Moves down the video_sensor area."""
        self.video_sensor.start_row -= 20
        self.video_sensor.configure_active_image()
        self._draw_active_image()
      
    def on_button_right_clicked(self, widget):
        """Moves right the video_sensor area."""
        self.video_sensor.start_column -= 20
        self.video_sensor.configure_active_image()
        self._draw_active_image()
        
    def on_button_left_clicked(self, widget):
        """Moves left the video_sensor area."""
        self.video_sensor.start_column += 20
        self.video_sensor.configure_active_image()
        self._draw_active_image()
        
    def on_button_skip_clicked(self, widget):
        """Changes the camera skip zoom mode."""
        self.video_sensor.skip = self.video_sensor.skip - 1
        if self.video_sensor.skip < 0: self.video_sensor.skip = 2
        self.video_sensor.configure_skip_mode()
        self.video_sensor.configure_active_image()
        self.entry_width.set_value(self.video_sensor.width)
        self.entry_height.set_value(self.video_sensor.height)
        self._draw_active_image()
    
    def on_hscale_exposure_changed(self, widget):
        """Sets the image exposure level."""
        self.video_sensor.exposure = int(widget.get_value())
        self._draw_active_image()

#------------------------------------------------------------------------------ 
        
    # Selects the video sensor output image and change configuration
    
    def on_combobox_select_changed(self, widget):
        self.video_sensor.select_output(widget.get_active())
        self._draw_active_image()
        
    def on_button_vga_clicked(self, widget):
        self.video_sensor.select_vga_output()
        self._draw_active_image()
                
    def camera_configure(self):
        if self.button_vga.get_active(): # Disable VGA
            self.button_vga.emit('clicked')
        # Configured the camera registers and gets a new image if is need.
        self.video_sensor.configure()
        if self.button_configure.get_active():
            if not any(self.video_sensor.image):
                self.video_sensor.get_new_frame()
        
    def on_button_capture_clicked(self, widget):
        """Disables the VGA if is acCaptures and shows the current frame image."""
        # Transfer image data
        if self.button_vga.get_active(): # Disable VGA
            self.button_vga.emit('clicked')
        self.video_sensor.configure()
        image = self.video_sensor.get_new_frame()
        Image.fromarray(image).save('capture_rgb.png')
        self.plot_capture.draw_captured_image(image)

#------------------------------------------------------------------------------ 

    # Selects the video sensor in the corresponding quadrant.
    
    def select_quadrant_sensor(self, widget, quadrant):
        [self.button_quadrant[q].set_active(False) for q in range(4) if q != quadrant - 1]
        self.stop_video_sensor()
        if widget.get_active(): 
            self.start_video_sensor(quadrant)
        
    def on_button_quadrant1_clicked(self, widget):
        self.select_quadrant_sensor(widget, 1)
        
    def on_button_quadrant2_clicked(self, widget):
        self.select_quadrant_sensor(widget, 2)
        
    def on_button_quadrant3_clicked(self, widget):
        self.select_quadrant_sensor(widget, 3)
        
    def on_button_quadrant4_clicked(self, widget):
        self.select_quadrant_sensor(widget, 4)
        
#------------------------------------------------------------------------------ 
        
    def on_alignment_plot_button_release_event(self, widget, event):
        if self.plot_capture.image != None:
            if self.plot_capture.pixel != None:
                thr_min, thr_max = threshold.get_best_color(self.video_sensor.image, 
                                                            self.plot_capture.pixel / 4, 64)
                thr_min, thr_max = thr_min.astype(int) * 4, thr_max.astype(int) * 4
                # Update thresholds
                if self.button_color1.get_active():
                    self.video_sensor.set_red_thresholds(thr_min, thr_max)
                    self.button_color1.set_active(False)
                if self.button_color2.get_active():
                    self.video_sensor.set_green_thresholds(thr_min, thr_max)
                    self.button_color2.set_active(False)
                if self.button_color3.get_active():
                    self.video_sensor.set_blue_thresholds(thr_min, thr_max)
                    self.button_color3.set_active(False)
                self.read_thresholds()
    
    def _entries_set_values(self, entries, values):
        for i in range(len(entries)):
            entries[i].set_value(values[i])
            
    def read_thresholds(self):
        """Reads the thresholds components and sets values in the text entries."""
        red_min, red_max = self.video_sensor.get_red_thresholds() 
        self._entries_set_values(self.entries_red_min, red_min)
        self._entries_set_values(self.entries_red_max, red_max)
        green_min, green_max = self.video_sensor.get_green_thresholds() 
        self._entries_set_values(self.entries_green_min, green_min)
        self._entries_set_values(self.entries_green_max, green_max)
        blue_min, blue_max = self.video_sensor.get_blue_thresholds() 
        self._entries_set_values(self.entries_blue_min, blue_min)
        self._entries_set_values(self.entries_blue_max, blue_max)
        
    def _entries_get_values(self, entries):
        values = [0, 0, 0]
        for i in range(len(entries)):
            values[i] = int(entries[i].get_value())
        return values 

    def write_thresholds(self):
        """Writes the thresholds components that gets from values in the text entries."""
        red_min = self._entries_get_values(self.entries_red_min)
        red_max = self._entries_get_values(self.entries_red_max)
        self.video_sensor.set_red_thresholds(red_min, red_max) 
        green_min = self._entries_get_values(self.entries_green_min)
        green_max = self._entries_get_values(self.entries_green_max)
        self.video_sensor.set_green_thresholds(green_min, green_max) 
        blue_min = self._entries_get_values(self.entries_blue_min)
        blue_max = self._entries_get_values(self.entries_blue_max)
        self.video_sensor.set_blue_thresholds(blue_min, blue_max) 
    
    def on_button_binarize_clicked(self, widget):
        """Shows the results of the new binarize color threshold."""
        self.write_thresholds()
        images_bin = self.video_sensor.get_binarized_images(self.video_sensor.image) 
        shapes_list = processing.location_shapes_list_in_images(images_bin)
        self.plot_capture.draw_targets_positions(dstack(images_bin), shapes_list)



if __name__ == "__main__":
    Capture()
    gtk.main()
    
