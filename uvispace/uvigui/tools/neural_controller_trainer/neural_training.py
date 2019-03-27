import sys
sys.path.append('F:\\Javier\\Desktop\\TFM\\uvispace-main-controller')
import os

from PyQt5 import QtWidgets, QtGui

#import tools.neural_controller_trainer.neural_controller_trainer as neural
import neural_controller_trainer as neural
#import fuzzy_interface as fuzzy

import sys
from PyQt5.QtWidgets import QApplication, QVBoxLayout, QWidget
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure

from numpy import arange, sin, pi
from PyQt5 import QtCore, QtWidgets
import random

from guitraining import Training
from uvispace.uvigui.tools.neural_controller_trainer.Plots import PlotTrainingResults

import threading
import time


class MainWindow(QtWidgets.QMainWindow, neural.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)
        self.layout = QVBoxLayout()

        # set the main page for the calibration process
        self.stackedWidget.setCurrentIndex(0)

        # button actions (next button)
        self.pbStartTraining.clicked.connect(self.start_training)
        # button actions (prev button)

        self.train=Training()
        #self.prev1Button.clicked.connect(self.prev_page)
        #self.prev2Button.clicked.connect(self.prev_page)
        #self.prev3Button.clicked.connect(self.prev_page)
#
        ## button actions start the test
        #self.Start_Button.clicked.connect(self.start_calibration)
#
        ## hide the calibration finished message
        #self.label_ready.hide()


    def next_page(self):
        # goes to the next step in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index+1)

    def plot_training(self):
        self.training_plot = PlotTrainingResults(r=self.thread.plot_data[0],v=self.thread.plot_data[1],d=self.thread.plot_data[2])
        self.next_page()
        self.l = QtWidgets.QVBoxLayout(self.wTrainPlot)
        self.l.addWidget(self.training_plot)
        pass

    def start_training(self):
        if self.rbNeural.isChecked():
            self.lTraining.setText('Training...  Please wait')
            self.thread = TrainingThread()
            self.thread.finished.connect(self.plot_training)
            self.thread.start()
#
        elif self.rbTables.isChecked():
            pass
        else:
            pass

class TrainingThread(QtCore.QThread):
    def __init__(self, filename=''):
        QtCore.QThread.__init__(self)
        self.filename=filename


    def run(self,filename=''):

        if len(self.filename) > 0:
            filename = self.filename + '.h5'
        else:
            filename = 'emodel.h5'
        self.train = Training()
        self.plot_data=self.train.trainclosedcircuitplot(reward_need=180,load_name=filename)  # hay que poner todo
        #self.next_page()
        #l.addWidget(self.train.plot)



if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())
