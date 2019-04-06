import sys
import os
import zmq
import logging
import configparser
import glob
import ast
import time
import numpy as np


from PyQt5 import QtWidgets, QtGui
from PyQt5.QtWidgets import QTableWidget, QTableWidgetItem

import tools.fuzzy_controller_calib.fuzzy_interface as fuzzy

from uvirobot.speedtransform import PolySpeedSolver
#from uvirobot.robot import RobotController

#try:
 #   import messenger
#except:
 #   print("could not load messenger")


#import fuzzy_interface as fuzzy

logger = logging.getLogger('view.fuzzy')

class MainWindow(QtWidgets.QMainWindow, fuzzy.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)

        # logger init
        self.logger = logging.getLogger('view.fuzzy.fuzzy')
        self.logger.debug("fuzzy loger created")

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

        #initialise coefficients
        self.left_coefs = 0
        self.right_coefs = 0

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

    def get_speeds(self, work_data):
        # calculate the linear and angular speeds of the given data
        # time  x   y   tita
        #   0   1   2   3
        # base time. All the times are converted to that time minus the
        # zero time
        work_data[:, 0] -= work_data[0, 0]
        # differential data
        diff_data = np.zeros_like(work_data)
        diff_data[1:] = work_data[1:] - work_data[0:-1]

        # calculate the length
        diff_length = np.sqrt(diff_data[:, 1] ** 2 + diff_data[:, 2] ** 2)

        diff_speed = np.zeros(2)

        diff_speed[1:] = 1000 * diff_length[1:] / diff_data[1:, 0]

        diff_angle_speed = 1000 * diff_data[1][3] / diff_data[1][0]

        return_speeds = np.zeros(2)
        return_speeds = [diff_speed[1], diff_angle_speed]
        return np.round(return_speeds, 2)

    def resolve(self, points):
        # This function resolves the car movement equation and returns the car
        # movement coefficients
        # create an empty array
        x = np.zeros((points.shape[0], 2))
        z = np.zeros((points.shape[0]))

        # rearrange array data
        for i in range(points.shape[0]):
            x[i] = (points[i][0:2])
            z[i] = points[i][2]

        # factor list
        degrees = [(0, 0), (1, 0), (0, 1), (2, 0), (1, 1), (0, 2)]
        matrix = np.stack([np.prod(x ** d, axis=1) for d in degrees], axis=-1)

        # solves the linear system
        coeff, resid, rank, s = np.linalg.lstsq(matrix, z, rcond=None)
        # TODO: round the coeffs to have two decimal
        return coeff

    def start_calibration(self):
        """
        Calls the functions to move the car, read the car values and resolve
        the equations to get the coefficients.
        Calculates the forward and the only turn movement.
        :return:
        """
        logger.info("started calibration")

        # create an instance of SerMesProtocol and check connection to port
        #my_serial = messenger.connect_and_check(1)

        # speed list to send to the UGV
        sp_left_list = [160, 210, 255]
        sp_right_list = [160, 210, 255]

        # initialise speed data array. This data is used to calculate the
        # angular and linear speeds
        speed_data = np.array([0, 0])
        pose_data = np.zeros((2, 4))
        move_fwd_left = np.zeros_like([0, 0, 0])
        move_fwd_right = np.zeros_like([0, 0, 0])

        # do the robot movements
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
                    logger.debug("Moving car")
                    #my_serial.move([right_order, left_order])
                # save the end time  when the time finishes, stops the car
                end_time = time.time()
                #my_serial.move([127, 127])

                # receive the stop position
                pose_end = self.pose_subscriber.recv_json()
                x_end = pose_end['x']
                y_end = pose_end['y']
                angle_end = pose_end['theta']
                logger.debug("Movement finished")

                # prepare the data to calculate the lineal and angular speed
                #            time      x       y              tita
                pose_data[0] = [init_time, x_start, y_start, angle_start]
                pose_data[1] = [end_time, x_end, y_end, angle_end]

                # get the lineal and angular velocity
                speed_data = self.get_speeds(pose_data)
                print("speed data")
                print(speed_data)
                sp_left_speed = np.append(speed_data, left_order)
                print("sp_left_speed")
                print(sp_left_speed)
                sp_right_speed = np.append(speed_data, right_order)
                print("sp_right_speed")
                print(sp_right_speed)
                move_fwd_left_aux = np.vstack((sp_left_speed, move_fwd_left))
                move_fwd_left = move_fwd_left_aux
                print("move_fwd_left")
                print(move_fwd_left)

                move_fwd_right_aux = np.vstack((sp_right_speed, move_fwd_right))
                move_fwd_right = move_fwd_right_aux
                print("move_fwd_left")
                print(move_fwd_right)

        # get the coefficients
        self.left_coefs = self.resolve(move_fwd_left)
        self.right_coefs = self.resolve(move_fwd_right)
        logger.debug("Movement coeficients calculated")
        print("coeficientes")
        print(self.left_coefs)
        print(self.right_coefs)

        # calibration finished message
        self.label_ready.show()
        # show the coefficients in table
        for i in range(6):
            self.tableWidget.setItem(0, i, QTableWidgetItem(str(self.left_coefs[i])))
            self.tableWidget.setItem(1, i, QTableWidgetItem(str(self.right_coefs[i])))


    def test_results(self):
        # move the car using the coeficients to test the results
        conf = configparser.ConfigParser()
        conf_file = glob.glob("./resources/config/modelrobot.cfg")
        conf.read(conf_file)
        left_coefs = ast.literal_eval(conf.get('Coefficients', 'coefs_left'))
        right_coefs = ast.literal_eval(conf.get('Coefficients', 'coefs_right'))


        # preguntar o usuario si se moveu o coche ben en linea recta

        # realizar a calibracion para ver si vai ben en giro sobre si mismo


        # update the coefficients

        # show the ready message when finished




if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())


