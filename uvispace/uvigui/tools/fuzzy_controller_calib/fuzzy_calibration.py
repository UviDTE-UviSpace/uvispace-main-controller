import sys
import os
import zmq
#import logging
import configparser
import glob
import ast
import time
import numpy as np


from PyQt5 import QtWidgets, QtGui

import tools.fuzzy_controller_calib.fuzzy_interface as fuzzy

from uvirobot.speedtransform import PolySpeedSolver
#from uvirobot.robot import RobotController

#try:
 #   import messenger
#except:
 #   print("could not load messenger")


#import fuzzy_interface as fuzzy

#logger = logging.getLogger('speedstudy')

class MainWindow(QtWidgets.QMainWindow, fuzzy.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)

        # set the images
        self.label_14.setPixmap(
            QtGui.QPixmap('tools/fuzzy_controller_calib/real_image.png'))
        self.label_13.setPixmap(
            QtGui.QPixmap('tools/fuzzy_controller_calib/diagram.png'))

        # set the main page for the calibration process
        self.stackedWidget.setCurrentIndex(0)

        # button actions (next button)
        self.next0Button.clicked.connect(self.next_page)
        self.next1Button.clicked.connect(self.next_page)
        self.next2Button.clicked.connect(self.next_page)
        self.next3Button.clicked.connect(self.next_page)

        # button actions (prev button)
        self.prev1Button.clicked.connect(self.prev_page)
        self.prev2Button.clicked.connect(self.prev_page)
        self.prev3Button.clicked.connect(self.prev_page)

        # button actions start the test
        self.Start_Button.clicked.connect(self.start_calibration)

        # hide the calibration finished message
        self.label_ready.hide()

        # start the pose subscriber to listen for position data
        self.pose_subscriber = zmq.Context.instance().socket(zmq.SUB)
        self.pose_subscriber.setsockopt_string(zmq.SUBSCRIBE, u"")
        self.pose_subscriber.setsockopt(zmq.CONFLATE, True)
        # self.pose_subscriber.connect("tcp://" + "192.168.0.51" + ":35000")
        self.pose_subscriber.connect("tcp://localhost:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_POSITION")) + 1))


    def next_page(self):
        # goes to the next step in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index+1)

    def prev_page(self):
        # goes to the previous page in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index-1)

    def start_calibration(self):
        """
        Calls the functions to move the car, read the car values and resolve
        the equations to get the coefficients.
        Calculates the forward and the only turn movement.
        :return:
        """
        logger.info("started calibration")

        # create an instance of SerMesProtocol and check connection to port
        my_serial = messenger.connect_and_check(1)

        # Execute the functions to do the calibration

        # TODO añadir bucle if para comprobar as combinacions dos motores

        #lista de combinacions
        sp_left_list = [160, 210, 255]
        sp_right_list = [160, 210, 255]

        # recorrer listas de consignas
        for left_order in sp_left_list:
            for right_order in sp_right_list:

                # receive initial ugv positions
                pose = self.pose_subscriber.recv_json()
                x_start = pose['x']
                y_start = pose['y']
                angle_start = pose['theta']
                logger.debug("Loaded initial positions")

                # time to move, in seconds
                operating_time = 1
                logger.debug("Sent to UGV ({}, {})".format(left_order, right_order))

                # start time
                init_time = time.time()

                while (time.time() - init_time) < operating_time:
                    my_serial.move([right_order, left_order])
                # save the end time  when the time finishes, stops the car
                end_time = time.time()
                my_serial.move([127, 127])

                # receive the stop position
                pose_end = self.pose_subscriber.recv_json()
                x_end = pose_end['x']
                y_end = pose_end['y']
                angle_end = pose_end['theta']
                logger.debug("Movement finished")

                # calcular a velocidad lineal e angular media de cada movemento

                data = np.zeros((2, 4))
                #            time      x       y         tita
                data[0] = [init_time, x_start, y_start, angle_start]
                data[1] = [end_time, x_end, y_end, angle_end]

                # get the lineal and angular velocity
                from uvisensor.resources import dataprocessing
                analysis = dataprocessing.DataAnalyzer()
                analysis.set_data(data)
                analysis.get_processed_data()
                avg_lin_speed = analysis._avg_lin_spd
                avg_ang_spd = analysis._avg_ang_spd_



        # resolver as ecuacions

        # enseñar os coeficientes na gui

        # mover o coche a unha velocidad lineal fija para saber si vai ben en linea recta

        conf = configparser.ConfigParser()
        conf_file = glob.glob("./resources/config/modelrobot.cfg")
        conf.read(conf_file)
        left_coefs = ast.literal_eval(conf.get('Coefficients', 'coefs_left'))
        right_coefs = ast.literal_eval(conf.get('Coefficients', 'coefs_right'))


        # preguntar o usuario si se moveu o coche ben en linea recta

        # realizar a calibracion para ver si vai ben en giro sobre si mismo


        # update the coefficients

        # show the ready message when finished
        self.label_ready.show()




if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())


