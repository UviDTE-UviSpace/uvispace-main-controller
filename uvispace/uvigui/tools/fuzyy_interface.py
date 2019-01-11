import sys
import os

from PyQt5 import QtWidgets


import fuzzy_calibration

print("test")

class MainWindow(QtWidgets.QMainWindow, fuzzy_calibration.Ui_fuzzy_window):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        self.setupUi(self)
        print("test2")
        self.stackedWidget.setCurrentIndex(0)
        #button actions (next button)
        self.next0Button.clicked.connect(self.next_page)
        self.next1Button.clicked.connect(self.next_page)
        self.next2Button.clicked.connect(self.next_page)
        self.next4Button.clicked.connect(self.next_page) # TODO change in ui name to button 3

        #button actions (prev button)
        self.prev1Button.clicked.connect(self.prev_page)
        self.prev2Button.clicked.connect(self.prev_page)
        self.prev4Button.clicked.connect(self.prev_page) # TODO change in ui name to button3


    def next_page(self):
        # goes to the next step in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index+1)

    def prev_page(self):
        # goes to the previous page in the interface
        index = self.stackedWidget.currentIndex()
        self.stackedWidget.setCurrentIndex(index-1)

app = QtWidgets.QApplication(sys.argv)
form = MainWindow()
form.show()
sys.exit(app.exec_())
