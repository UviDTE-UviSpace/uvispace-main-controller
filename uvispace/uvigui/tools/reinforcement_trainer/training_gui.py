"""This module creates the trainig GUI and its logic
"""
import math
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavTbar
from PyQt5.QtCore import QTimer
from PyQt5 import QtWidgets
import matplotlib.patches as ptch
import matplotlib.pyplot as plt


import uvispace.uvigui.tools.reinforcement_trainer.interface.reinforcement_trainer as reinforcement
from uvispace.uvigui.tools.reinforcement_trainer.neural_training import *
from uvispace.uvigui.tools.reinforcement_trainer.table_training import *
from uvispace.uvinavigator.common import TableAgentType


class MainWindow(QtWidgets.QMainWindow, reinforcement.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)
        self.layout = QtWidgets.QVBoxLayout()

        # set the main page for the training process
        self.stackedWidget.setCurrentIndex(0)

        # hide  buttons
        self.pbStartTesting.hide()
        self.pbRetrain.hide()

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
        self.gridLayout_plot_test.addWidget(self.toolbar)
        self.gridLayout_plot_test.addWidget(self.canvas_testing)

        # add title
        self.figure_testing.suptitle('Velocity[m/s]    Distance[m]')

        # define axes for Reward Velocity and Distance to trajectory
        self.axes1testing = self.figure_testing.add_axes([0.1, 0.5, 0.8, 0.4])
        self.axes2testing = self.figure_testing.add_axes([0.1, 0.1, 0.8, 0.4])

        self.axes2testing.set_xlabel('Steps')

        # Testing simulation plot
        self.state_number = 0

        self.fig, self.ax = plt.subplots()

        self.fig.patch.set_alpha(0)
        self.canvas = FigureCanvas(self.fig)
        self.toolbar = NavTbar(self.canvas, self)
        self.gridLayout_plot_sim.addWidget(self.toolbar)
        self.gridLayout_plot_sim.addWidget(self.canvas)

        self.arrayX = [] * 500  # max_steps
        self.arrayY = [] * 500

        x_limit = 4
        y_limit = 3
        period = 1/12

        self.yellow_back_x = x_limit
        self.yellow_back_y = y_limit

        self.point2, = self.ax.plot([], [], 'r:')

        self.x_origin = -x_limit / 2
        self.y_origin = -y_limit / 2

        self.period = period

        # Qt timer set-up for updating the training plots.
        self.timer_training = QTimer()
        self.timer_training.timeout.connect(self.update_training_plot)

        # Qt timer set-up for updating the simulation plots.
        self.timer_sim = QTimer()
        self.timer_sim.timeout.connect(self.plot_sim)

    def start_training(self):
        """This function checks what type of training has to do and runs the training of the controller
        """

        if self.rbNeural.isChecked():

            self.hdf5_file_name = 'uvispace/uvinavigator/controllers/linefollowers/neural_controller/resources/neural_nets/ANN_ugv{}.h5'.format(
                self.lineEdit_ugvid.text())

            #Hide start button to avoid multiple training
            self.pbStartTraining.hide()
            self.pbStartTesting.hide()

            self.tr = NeuralTraining()
            if self.rbDifferential.isChecked():
                self.tr.trainclosedcircuitplot(
                    load=False, save_name=self.hdf5_file_name, differential_car=True)
            elif self.rbAckerman.isChecked():
                self.tr.trainclosedcircuitplot(
                    load=False, save_name=self.hdf5_file_name, differential_car=False)
            self.timer_training.start(500)
            self.tr.finished.connect(self.finish_training)

        elif self.rbTables.isChecked():

            self.csv_file_name = 'uvispace/uvinavigator/controllers/linefollowers/table_controller/resources/tables_agents/table_ugv{}.csv'.format(
                self.lineEdit_ugvid.text())

            # Hide start button to avoid multiple training
            self.pbStartTraining.hide()
            self.pbStartTesting.hide()

            self.tr = TableTraining()

            if self.rbDifferential.isChecked():
                self.tr.trainclosedcircuitplot(save_name=self.csv_file_name, differential_car =True, agent_type = TableAgentType.sarsa)
            elif self.rbAckerman.isChecked():
                self.tr.trainclosedcircuitplot(save_name=self.csv_file_name, differential_car = True, agent_type = TableAgentType.sarsa)
            self.timer_training.start(500)
            self.tr.finished.connect(self.finish_training)

    def start_testing(self):
        """This function checks what type of testing has to be done and runs
        the testing of the controller
        """

        self._begin()
        # redraw to avoid visual bug
        self.canvas_testing.draw()
        self.reset([0.2, 0.2, np.pi/4])

        self.next_page()

        if self.rbNeural.isChecked():
            self.ts = NeuralTesting()
            if self.rbDifferential.isChecked():

                #Read csv file
                coordinates = np.loadtxt(open("uvispace/uvigui/tools/reinforcement_trainer/resources/testing_differential.csv", "r"), delimiter=";")
                x_trajectory=[]
                y_trajectory=[]
                for point in coordinates:
                    x_trajectory.append(point[0])
                    y_trajectory.append(point[1])

                self.ts.testing(load_name=self.hdf5_file_name, x_trajectory=x_trajectory, y_trajectory=y_trajectory, closed=False, differential_car=True)

            elif self.rbAckerman.isChecked():

                # Read csv file
                coordinates = np.loadtxt(
                    open("uvispace/uvigui/tools/reinforcement_trainer/resources/testing_ackerman.csv", "r"),
                    delimiter=";")
                x_trajectory = []
                y_trajectory = []
                for point in coordinates:
                    x_trajectory.append(point[0])
                    y_trajectory.append(point[1])

                self.ts.testing(load_name=self.hdf5_file_name, x_trajectory=x_trajectory, y_trajectory=y_trajectory, closed=False, differential_car=False)


            self.ts.finished.connect(self.finish_testing)

        elif self.rbTables.isChecked():
            self.ts = TableTesting()

            if self.rbDifferential.isChecked():

                # Read csv file
                coordinates = np.loadtxt(
                    open("uvispace/uvigui/tools/reinforcement_trainer/resources/testing_differential.csv",
                    "r"), delimiter=";")

                x_trajectory = []
                y_trajectory = []
                for point in coordinates:
                    x_trajectory.append(point[0])
                    y_trajectory.append(point[1])

                self.ts.testing(load_name=self.csv_file_name,
                                x_trajectory=x_trajectory,
                                y_trajectory=y_trajectory, closed=False,
                                differential_car=True, discrete_input=True)

            elif self.rbAckerman.isChecked():

                # Read csv file
                coordinates = np.loadtxt(
                    open("uvispace/uvigui/tools/reinforcement_trainer/resources/testing_ackerman.csv",
                        "r"), delimiter=";")

                x_trajectory = []
                y_trajectory = []
                for point in coordinates:
                    x_trajectory.append(point[0])
                    y_trajectory.append(point[1])

                self.ts.testing(load_name=self.csv_file_name,
                                x_trajectory=x_trajectory,
                                y_trajectory=y_trajectory, closed=False,
                                differential_car=False, discrete_input=True)

            self.ts.finished.connect(self.finish_testing)

    def finish_training(self):
        """This function shows the testing bottom after training is done
        """
        self.pbStartTraining.show()
        self.timer_training.stop()
        self.pbStartTesting.show()
        QtWidgets.QMessageBox.about(self, 'Attention', 'Training finished')

    def finish_testing(self):
        """This function starts the plot of the training results
        """
        # self.timer_testing.stop()
        self.update_testing_plot()
        self.timer_sim.start(1000/12)

    def update_training_plot(self):
        """This function update the training plots in real time
        """
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
        """This function updates the training plot
        """
        self.axes1testing.cla()
        self.axes2testing.cla()

        self.axes3training.set_xlabel('Episode')

        v, d = self.ts.read_values()

        self.axes1testing.plot(v)
        self.axes2testing.plot(d)

        self.canvas_testing.draw()

    def next_page(self):
        """This function changes the window to the testing section
        """
        # goes to the next step in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index + 1)

    def first_page(self):
        """This function goes back to the training window
        """

        # redraw to avoid visual bug
        self.canvas_training.draw()

        self.pbRetrain.hide()
        self.stackedWidget.setCurrentIndex(0)

    def _begin(self):
        """This function initialises the testing plot of the circuit
        """

        # create the trajectories to plot

        if self.rbDifferential.isChecked():
            # Read csv file
            coordinates = np.loadtxt(
                open("uvispace/uvigui/tools/reinforcement_trainer/resources/testing_differential.csv", "r"),
                delimiter=";")
            x_trajectory = []
            y_trajectory = []
            for point in coordinates:
                x_trajectory.append(point[0])
                y_trajectory.append(point[1])

        elif self.rbAckerman.isChecked():

            # Read csv file
            coordinates = np.loadtxt(
                open("uvispace/uvigui/tools/reinforcement_trainer/resources/testing_ackerman.csv", "r"),
                delimiter=";")
            x_trajectory = []
            y_trajectory = []
            for point in coordinates:
                x_trajectory.append(point[0])
                y_trajectory.append(point[1])

        self.ax.clear()

        self.point, = self.ax.plot([], [], marker=(3, 0, 0), color='red')

        self.ax.set_ylim(self.y_origin-0.5,
                         self.yellow_back_y + self.y_origin + 0.5)

        self.ax.set_xlim(self.x_origin - 0.5,
                         self.x_origin + self.yellow_back_x + 0.5)

        self.ax.set_facecolor('xkcd:black')

        rect2 = ptch.Rectangle((self.x_origin, self.y_origin),
                               self.yellow_back_x,
                               self.yellow_back_y, linewidth=2,
                               edgecolor='yellow', facecolor='none')

        self.ax.plot(x_trajectory, y_trajectory, 'tab:cyan',
                     linewidth=1.75,)

        self.ax.add_patch(rect2)

        # Christian wrote false in the plt.show argumant and it
        # it generated an error
        # plt.show(False)
        plt.draw()

    def execute(self, state):
        """This function updates the testing plot
        """

        self.x = state[0]
        self.y = state[1]
        self.angle = state[2]
        plt.draw()
        self.fig.canvas.draw()

        self.point.set_xdata(self.x)
        self.point.set_ydata(self.y)

        self.point.set_marker((3, 0, math.degrees(self.angle)))

        self.arrayX.append(self.x)
        self.arrayY.append(self.y)

        self.point2.set_data(self.arrayX, self.arrayY)
        plt.draw()
        # self.theta = self.theta+20  # Check if is necessary

    def reset(self, state):
        """This function reset the testing plot
        """

        self.x = state[0]
        self.y = state[1]
        self.arrayX = []
        self.arrayY = []
        self.point2.set_data(self.arrayX, self.arrayY)
        self.angle = state[2]
        self.point2, = self.ax.plot([], [], 'r:')
        self.execute(state)

    def plot_sim(self):
        """This function calls the update of the testing plot if it has not
        finished
        """
        if self.state_number < len(self.ts.states):
            self.execute(self.ts.states[self.state_number])
            self.state_number += 1
        else:
            self.end_simulation()

    def end_simulation(self):
        """This function finishes the testing plot
        """
        self.state_number = 0
        self.timer_sim.stop()
        self.pbRetrain.show()
