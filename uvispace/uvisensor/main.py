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
    filename = './resources/config/video_sensor1.cfg'
    #Instantiate VideoSensor class. The filename contains the configuration
    cam = videosensor.VideoSensor(filename)
    if not cam._connected:
        sys.exit('Unable to connect')
    cam.load_configuration()
    #DON'T KNOW WHY FOLLOWING 2 STATEMENTS ARE USED
    #Reset trackers?
    cam.set_register('UNKNOWN', '')
    #Select output = 4?
    cam.set_register('SYSTEM_OUTPUT', 4)
    conf = cam._client.write_command('CONFIGURE_CAMERA', True)
    #Get an image and save it to a local file.
    image = cam.capture_frame(gray=True, output_file='./tmp/grey_capture.png')
    #Call disconnect routine. If not, socket won't be able to be reopened.
    cam.set_register('SYSTEM_OUTPUT', 0)
    cam.disconnect_client()



