import sys
import os

from PyQt5 import QtWidgets, QtGui

import tools.fuzzy_controller_calib.fuzzy_interface as fuzzy
#import fuzzy_interface as fuzzy


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
        # Execute the functions to do the calibration
        #multiplecamera.py guardar poses robot

        #SpeedStudy introducir combinacion de consignas

        #leer datos e pasar a resolver as ecuacions

        #enseñar os coeficientes na gui

        # update the coefficients

        # show the ready message when finished
        self.label_ready.show()


if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())


