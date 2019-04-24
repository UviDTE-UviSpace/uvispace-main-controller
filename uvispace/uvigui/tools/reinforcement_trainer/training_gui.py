import numpy as np
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavTbar
from PyQt5.QtCore import QTimer
from PyQt5 import QtWidgets
import matplotlib.patches as ptch
import matplotlib.pyplot as plt



import uvispace.uvigui.tools.reinforcement_trainer.interface.reinforcement_trainer as reinforcement
from uvispace.uvigui.tools.reinforcement_trainer.neural_training import *


class MainWindow(QtWidgets.QMainWindow, reinforcement.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)
        self.layout = QtWidgets.QVBoxLayout()

        # set the main page for the training process
        self.stackedWidget.setCurrentIndex(0)

        #hide  buttons
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

        x_limit=4
        y_limit=3
        period= 1/30

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

        self.hdf5_file_name = 'uvispace/uvinavigator/controllers/linefollowers/neural_controller/resources/neural_nets/ANN_ugv{}.h5'.format(self.lineEdit_ugvid.text())

        if self.rbNeural.isChecked():

            #Hide start button to avoid multiple training
            self.pbStartTraining.hide()
            self.pbStartTesting.hide()

            self.tr = Training()
            if self.rbDifferential.isChecked():
                self.tr.trainclosedcircuitplot(load=False, save_name=self.hdf5_file_name,reward_need=180,differential_car=True)
            elif self.rbAckerman.isChecked():
                self.tr.trainclosedcircuitplot(load=False, save_name=self.hdf5_file_name, reward_need=50,
                                               differential_car=False)
            self.timer_training.start(500)
            self.tr.finished.connect(self.finish_training)

        elif self.rbTables.isChecked():
            self.pbStartTesting.show()

            print((self.hdf5_file_name))
            pass


    def start_testing(self):

        self._begin()
        #redraw to avoid visual bug
        self.canvas_testing.draw()
        self.reset([0.2,0.2,np.pi/4])

        self.next_page()

        self.ts = Testing()
        if self.rbDifferential.isChecked():
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

            self.ts.testing(load_name=self.hdf5_file_name, x_trajectory=x_trajectory, y_trajectory=y_trajectory, closed=False, differential_car=True)

        elif self.rbAckerman.isChecked():
            x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                     np.cos(np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.8 + 1)
            y_trajectory = np.append(np.linspace(0.2, 0.399, 41),
                                     np.sin(np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.8 + 0.4)
            x_trajectory = np.append(x_trajectory, np.linspace(1.8, 1.8, 181))
            y_trajectory = np.append(y_trajectory, np.linspace(0.4, -0.699, 181))
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(360 * math.pi / 180, 270.001 * math.pi / 180, 81)) * 0.7 + 1.1)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(360 * math.pi / 180, 270.001 * math.pi / 180, 81)) * 0.7 - 0.7)
            x_trajectory = np.append(x_trajectory, np.linspace(1.1, -1.099, 41))
            y_trajectory = np.append(y_trajectory, np.linspace(-1.4, -1.4, 41))
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(270 * math.pi / 180, 180.001 * math.pi / 180, 81)) * 0.8 - 1.1)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(270 * math.pi / 180, 180.001 * math.pi / 180, 81)) * 0.8 - 0.6)
            x_trajectory = np.append(x_trajectory, np.linspace(-1.9, -1.9, 161))
            y_trajectory = np.append(y_trajectory, np.linspace(-0.6, 0.1999, 161))
            x_trajectory = np.append(x_trajectory,
                                     np.cos(
                                         np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.525 - 1.375)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.525 + 0.2)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(180 * math.pi / 180, 359.999 * math.pi / 180,
                                                        191)) * 0.525 - 0.325)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(
                                         np.linspace(180 * math.pi / 180, 359.999 * math.pi / 180, 191)) * 0.525 + 0.2)

            self.ts.testing(load_name=self.hdf5_file_name, x_trajectory=x_trajectory, y_trajectory=y_trajectory, closed=False, differential_car=False)


        self.ts.finished.connect(self.finish_testing)

    def finish_training(self):
        self.pbStartTraining.show()
        self.timer_training.stop()
        self.pbStartTesting.show()
        QtWidgets.QMessageBox.about(self, 'Attention', 'Training finished')

    def finish_testing(self):
        #self.timer_testing.stop()
        self.update_testing_plot()
        self.timer_sim.start(1000/30)

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

        #redraw to avoid visual bug
        self.canvas_training.draw()

        self.pbRetrain.hide()
        self.stackedWidget.setCurrentIndex(0)

    def _begin(self):

        #create the trajectories to plot

        if self.rbDifferential.isChecked():
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




        elif self.rbAckerman.isChecked():

            x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                     np.cos(np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.8 + 1)
            y_trajectory = np.append(np.linspace(0.2, 0.399, 41),
                                     np.sin(np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.8 + 0.4)
            x_trajectory = np.append(x_trajectory, np.linspace(1.8, 1.8, 181))
            y_trajectory = np.append(y_trajectory, np.linspace(0.4, -0.699, 181))
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(360 * math.pi / 180, 270.001 * math.pi / 180, 81)) * 0.7 + 1.1)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(360 * math.pi / 180, 270.001 * math.pi / 180, 81)) * 0.7 - 0.7)
            x_trajectory = np.append(x_trajectory, np.linspace(1.1, -1.099, 41))
            y_trajectory = np.append(y_trajectory, np.linspace(-1.4, -1.4, 41))
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(270 * math.pi / 180, 180.001 * math.pi / 180, 81)) * 0.8 - 1.1)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(270 * math.pi / 180, 180.001 * math.pi / 180, 81)) * 0.8 - 0.6)
            x_trajectory = np.append(x_trajectory, np.linspace(-1.9, -1.9, 161))
            y_trajectory = np.append(y_trajectory, np.linspace(-0.6, 0.1999, 161))
            x_trajectory = np.append(x_trajectory,
                                     np.cos(
                                         np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.525 - 1.375)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(np.linspace(180 * math.pi / 180, 0.001 * math.pi / 180, 161)) * 0.525 + 0.2)
            x_trajectory = np.append(x_trajectory,
                                     np.cos(np.linspace(180 * math.pi / 180, 359.999 * math.pi / 180,
                                                        191)) * 0.525 - 0.325)
            y_trajectory = np.append(y_trajectory,
                                     np.sin(
                                         np.linspace(180 * math.pi / 180, 359.999 * math.pi / 180, 191)) * 0.525 + 0.2)

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

        #Christian wrote false in the plt.show argumant and it
        #it generated an error
        #plt.show(False)
        plt.draw()

    def execute(self, state):

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

        self.x = state[0]
        self.y = state[1]
        self.arrayX = []
        self.arrayY = []
        self.point2.set_data(self.arrayX, self.arrayY)
        self.angle = state[2]
        self.point2, = self.ax.plot([], [], 'r:')
        self.execute(state)

    def plot_sim(self):
        if self.state_number < len(self.ts.states):
            self.execute(self.ts.states[self.state_number])
            self.state_number+=1
        else:
            self.end_simulation()

    def end_simulation(self):
        self.state_number = 0
        self.timer_sim.stop()
        self.pbRetrain.show()
