#!/usr/bin/env python
#Standard libraries
import logging
import sys
#Local libraries
import videosensor

if __name__ == '__main__':
    logging.basicConfig(format=('%(asctime)s.%(msecs)03d '
                               '%(levelname)s:%(message)s'), 
                        level=logging.DEBUG,
                        datefmt='%H:%M:%S',
                        filename='./log/main.log')
    logging.info("BEGINNING MAIN EXECUTION")
    filename = './resources/config/video_sensor2.cfg'
    #Instantiate VideoSensor class. The filename contains the configuration
    cam = videosensor.VideoSensor(filename)
    #The data of the cfg file contain the device parameters to be sent to FPGA
    if not cam._connected:
        sys.exit('Unable to connect')
    cam.load_configuration()
    #DON'T KNOW WHY FOLLOWING 2 STATEMENTS ARE USED
    #Reset trackers?
    cam.set_register('UNKNOWN', '')
    #Select output = 4?
    cam.set_register('SYSTEM_OUTPUT', 4)
    conf = cam._client.write_command('CONFIGURE_CAMERA', True)
    image = cam.capture_frame(gray=True)
    #End of the script
    cam.set_register('SYSTEM_OUTPUT', 0)
#    conf = cam._client.write_command('CONFIGURE_CAMERA', True)
    cam.disconnect_client()
    
    
