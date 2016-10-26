from sensor.video_sensor import init_tracking
import os

class SystemController():
    def __init__(self):
        self.sensors_list = self._check_available_sensors()
        self.targets = {}
        self.sensors = {}    
        self.connect_sensors(self.sensors_list)
        
    def _check_available_sensors(self):
        """Checks if exist the configuration file of the video sensor."""
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
                
    def init_sensors(self):
        logging.info('Initiating video sensors...')
        self.get_image_packages(fake=True)
        # Dictionary iteration
        for sensor in self.sensors.itervalues():
            t0 = time.time()
            self.targets.update(init_tracking(sensor, len(self.targets)))
            t1 = time.time()
            print 'Time to initiate video sensors:', t1 - t0
        logging.info('Initiated video sensors.')
        
    def start_sensors(self):
        logging.info('Starting video sensors...')
        for sensor in self.sensors.itervalues():
            sensor.start_run()
        logging.info('Started video sensors.')
