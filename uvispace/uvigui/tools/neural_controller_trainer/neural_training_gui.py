import numpy as np
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavTbar
from PyQt5.QtCore import QTimer
from PyQt5 import QtWidgets

import uvispace.uvigui.tools.neural_controller_trainer.interface.neural_controller_trainer as neural
from uvispace.uvigui.tools.neural_controller_trainer.guitraining import *
from uvispace.uvigui.tools.neural_controller_trainer.Plots import *

import matplotlib.pyplot as plt



class MainWindow(QtWidgets.QMainWindow, neural.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)
        self.layout = QtWidgets.QVBoxLayout()

        # set the main page for the training process
        self.stackedWidget.setCurrentIndex(0)

        #hide start training button
        self.pbStartTesting.hide()

        # button actions (next button)
        self.pbStartTraining.clicked.connect(self.start_training)
        self.pbStartTesting.clicked.connect(self.start_testing)
        self.pbRetrain.clicked.connect(self.first_page)




        # initialize training figure
        self.figure_training = plt.figure()
        self.figure_training.patch.set_alpha(0)
        self.canvas_training = FigureCanvas(self.figure_training)
        self.toolbar = NavTbar(self.canvas_training, self)
        self.verticalLayout_plot.addWidget(self.toolbar)
        self.verticalLayout_plot.addWidget(self.canvas_training)

        # add title
        self.figure_training.suptitle('Reward    Velocity[m/s]    Distance[m]')


        # define axes for Reward Velocity and Distance to trajectory
        self.axes1training = self.figure_training.add_axes([0.1, 0.65, 0.8, 0.25])
        self.axes2training = self.figure_training.add_axes([0.1, 0.4, 0.8, 0.25])
        self.axes3training = self.figure_training.add_axes([0.1, 0.15, 0.8, 0.25])

        self.axes3training.set_xlabel('Episode')

        # initialize testing figure
        self.figure_testing = plt.figure()
        self.figure_testing.patch.set_alpha(0)
        self.canvas_testing = FigureCanvas(self.figure_testing)
        self.toolbar = NavTbar(self.canvas_testing, self)
        self.verticalLayout_plot_test.addWidget(self.toolbar)
        self.verticalLayout_plot_test.addWidget(self.canvas_testing)

        # add title
        self.figure_testing.suptitle('Velocity[m/s]    Distance[m]')

        # define axes for Reward Velocity and Distance to trajectory
        self.axes1testing = self.figure_testing.add_axes([0.1, 0.5, 0.8, 0.4])
        self.axes2testing = self.figure_testing.add_axes([0.1, 0.1, 0.8, 0.4])

        self.axes2testing.set_xlabel('Steps')

        # Qt timer set-up for updating the training plots.
        self.timer_training = QTimer()
        self.timer_training.timeout.connect(self.update_training_plot)

        # Qt timer set-up for updating the testing plots.
        self.timer_testing = QTimer()
        self.timer_testing.timeout.connect(self.update_testing_plot)

    def start_training(self):
        if self.rbNeural.isChecked():

            self.tr = Training()
            self.tr.trainclosedcircuitplot(load=False, save_name='emodel.h5',reward_need=180)
            self.timer_training.start(500)
            self.tr.finished.connect(self.finish_training)



        elif self.rbTables.isChecked():
            self.pbStartTesting.show()
            pass

    def start_testing(self):

        self.next_page()

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
        self.ts = Testing()
        self.ts.testing(load_name='emodel.h5', x_trajectory=x_trajectory, y_trajectory=y_trajectory, closed=False)
        self.timer_testing.start(500)
        self.ts.finished.connect(self.finish_testing)

    def finish_training(self):
        self.timer_training.stop()
        self.pbStartTesting.show()

    def finish_testing(self):
        self.timer_testing.stop()
        self.update_testing_plot()
        self.pbRetrain.show()

    def update_training_plot(self):
        self.axes1training.cla()
        self.axes2training.cla()
        self.axes3training.cla()

        self.axes3training.set_xlabel('Episode')

        reward, v, d = self.tr.read_averages()

        self.axes1training.plot(reward)
        self.axes2training.plot(v)
        self.axes3training.plot(d)

        self.canvas_training.draw()

    def update_testing_plot(self):
        self.axes1testing.cla()
        self.axes2testing.cla()

        self.axes3training.set_xlabel('Episode')

        v, d = self.ts.read_values()


        self.axes1testing.plot(v)
        self.axes2testing.plot(d)

        self.canvas_testing.draw()

    def next_page(self):
        # goes to the next step in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index + 1)

    def first_page(self):
        self.stackedWidget.setCurrentIndex(0)

