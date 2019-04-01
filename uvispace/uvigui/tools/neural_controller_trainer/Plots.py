import sys
from PyQt5.QtWidgets import QApplication, QVBoxLayout, QWidget
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.pyplot as plt
from PyQt5 import QtCore, QtWidgets


class MyMplCanvas(FigureCanvas):
    """Ultimately, this is a QWidget (as well as a FigureCanvasAgg, etc.)."""

    def __init__(self, t=[], parent=None, width=5, height=4, dpi=100,):
        self.t=t
        fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)

        self.compute_initial_figure()

        FigureCanvas.__init__(self, fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                                   QtWidgets.QSizePolicy.Expanding,
                                   QtWidgets.QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)

    def compute_initial_figure(self):
        pass

class PlotTrainingResults(FigureCanvas):
    """Simple canvas with a sine plot."""
    def __init__(self, r=[],v=[], d=[] ,parent=None, width=5, height=4, dpi=100,):
        self.reward=r
        self.velocity=v
        self.distance=d
        fig = Figure(figsize=(width, height), dpi=dpi)
        fig.suptitle('Reward    Velocity[m/s]    Distance[m]')

        #Create layout
        self.axes1 = fig.add_axes([0.1, 0.65, 0.8, 0.25])

        self.axes2 = fig.add_axes([0.1, 0.4, 0.8, 0.25])

        self.axes3 = fig.add_axes([0.1, 0.15, 0.8, 0.25])

        #Plot
        self.axes1.plot(self.reward)
        self.axes2.plot(self.velocity)
        self.axes3.plot(self.distance)

        #Label
        self.axes1.set_xlabel('Episode')

        FigureCanvas.__init__(self, fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                                   QtWidgets.QSizePolicy.Expanding,
                                   QtWidgets.QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)

class PlotTestingResults(FigureCanvas):
    """Simple canvas with a sine plot."""
    def __init__(self,v=[], d=[] ,parent=None, width=5, height=4, dpi=100,):
        self.velocity=v
        self.distance=d
        fig = Figure(figsize=(width, height), dpi=dpi)
        fig.suptitle('Velocity[m/s]    Distance[m]')

        #Create layout
        self.axes1 = fig.add_axes([0.1, 0.5, 0.8, 0.4])

        self.axes2 = fig.add_axes([0.1, 0.1, 0.8, 0.4])


        #Plot
        self.axes1.plot(self.velocity)
        self.axes2.plot(self.distance)

        #Label
        self.axes1.set_xlabel('Step')

        FigureCanvas.__init__(self, fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                                   QtWidgets.QSizePolicy.Expanding,
                                   QtWidgets.QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)


