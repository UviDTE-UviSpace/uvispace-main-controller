import sys
sys.path.append('F:\\Javier\\Desktop\\TFM\\uvispace-main-controller')
import os

from PyQt5 import QtWidgets, QtGui

#import tools.neural_controller_trainer.neural_controller_trainer as neural
import neural_controller_trainer as neural
from uvispace.uvirobot.neural_controller.training import Training as TR

import sys
import  numpy as np
from PyQt5.QtWidgets import QApplication, QVBoxLayout, QWidget
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure

from numpy import arange, sin, pi
from PyQt5 import QtCore, QtWidgets
import random

from guitraining import Training
from uvispace.uvigui.tools.neural_controller_trainer.Plots import *

import threading
import time


class MainWindow(QtWidgets.QMainWindow, neural.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)
        self.layout = QVBoxLayout()



        # set the main page for the training process
        self.stackedWidget.setCurrentIndex(0)

        # button actions (next button)
        self.pbStartTraining.clicked.connect(self.start_training)
        self.pbStartTesting.clicked.connect(self.start_testing)
        self.pbfinish.clicked.connect(self.first_page)



    def start_training(self):
        if self.rbNeural.isChecked():
            #self.lTraining.setText('Training...  Please wait')
            #self.training_thread = TrainingThread(self.lefilename.text())
            #self.training_thread.finished.connect(self.plot_training)
            #self.training_thread.start()

            #usando threads aparece un error que asi no aparece
            if len(self.lefilename.text()) > 0:
                filename = self.lefilename.text() + '.h5'
            else:
                filename = 'emodel.h5'
            tr = Training()
            self.plot_data=tr.trainclosedcircuitplot(load=False, save_name=filename,
                                  reward_need=180)
            self.plot_training()

##
        elif self.rbTables.isChecked():
            pass
        else:
            self.lTraining.setText('Please, choose a training mode')
            self.next_page()

    def start_testing(self):
        #self.testing_thread = TestingThread(self.lefilename.text())
        #self.testing_thread.finished.connect(self.plot_testing)
        #self.testing_thread.start()
        x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                 np.cos(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.3)
        y_trajectory = np.append(np.linspace(0.2, 0.4, 41),
                                 np.sin(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.4)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.3)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.7)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.8)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.7)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.8)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.3)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.4)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.3)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.4)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.2)

        # x_trajectory = np.append(np.linspace(0.2, 0.2, 121),
        #                        np.linspace(0.2001,0.25, 10))
        # y_trajectory = np.append(np.linspace(0.2, 0.8, 121),
        #                       np.linspace(0.8,0.8, 10))
        # x_trajectory = np.append(x_trajectory,
        #                        np.linspace(0.25,0.25, 361))
        # y_trajectory = np.append(y_trajectory,
        #                       np.linspace(0.79999,-1, 361))
        #
        if len(self.lefilename.text()) > 0:
            filename = self.lefilename.text() + '.h5'
        else:
            filename = 'emodel.h5'
        tr = Training()
        self.plot_data=tr.testing(load_name='second-training.h5', x_trajectory=x_trajectory, y_trajectory=y_trajectory, closed=False)
        self.plot_testing()


    def first_page(self):
        self.stackedWidget.setCurrentIndex(0)
    def next_page(self):
        # goes to the next step in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index+1)

    def plot_training(self):
        self.training_plot = PlotTrainingResults(r=self.plot_data[0],v=self.plot_data[1],d=self.plot_data[2])
        self.next_page()
        self.wtrain = QtWidgets.QVBoxLayout(self.wTrainPlot)
        self.wtrain.addWidget(self.training_plot)

    def plot_testing(self):
        self.training_plot = PlotTestingResults(v=self.plot_data[0],d=self.plot_data[1])
        self.next_page()
        self.wtest = QtWidgets.QVBoxLayout(self.wTestPlot)
        self.wtest.addWidget(self.training_plot)

class TrainingThread(QtCore.QThread):
    def __init__(self, filename='',mode=False):
        QtCore.QThread.__init__(self)
        self.filename=filename
        if len(self.filename) > 0:
            self.filename = self.filename + '.h5'
        else:
            self.filename = 'emodel.h5'
        self.train = Training()
        self.mode=mode

    def run(self):
        if self. mode==False:
            self.plot_data=self.train.trainclosedcircuitplot(reward_need=180,save_name=self.filename)  # hay que poner todo
            #self.next_page()
            #l.addWidget(self.train.plot)

        else:
            x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                     np.cos(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.3)
            y_trajectory = np.append(np.linspace(0.2, 0.4, 41),
                                     np.sin(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.4)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.3)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.7)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.8)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.7)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.8)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.3)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.4)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.3)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.4)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.2)
            self.plot_data = self.train.testing(closed=False, load_name=self.filename, x_trajectory=x_trajectory,
                                                y_trajectory=y_trajectory)  # hay que poner todo

class TestingThread(QtCore.QThread):
    def __init__(self, filename=''):
        QtCore.QThread.__init__(self)
        self.filename=filename


    def run(self,filename=''):

        if len(self.filename) > 0:
            filename = self.filename + '.h5'
        else:
            filename = 'emodel.h5'


        x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                 np.cos(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.3)
        y_trajectory = np.append(np.linspace(0.2, 0.4, 41),
                                 np.sin(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.4)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.3)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.7)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.8)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.7)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.8)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.3)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.4)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.3)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.4)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.2)
        self.train = Training()
        self.plot_data=self.train.testing(closed=False,load_name=filename, x_trajectory=x_trajectory ,y_trajectory=y_trajectory)  # hay que poner todo
        #self.next_page()
        #l.addWidget(self.train.plot)

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())
