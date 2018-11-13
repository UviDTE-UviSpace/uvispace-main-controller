import numpy as np
import sys
from PyQt5.QtWidgets import QFileDialog, QWidget, QApplication


import loadfilesinterface
"""
    Class used to load csv files with a list of coordinates for the controller.
    Opens a new window. The new window also shows the coordinate list after the file is loaded
"""


class App(QWidget, loadfilesinterface.Ui_Form):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.button_openfile.clicked.connect(self.openFileNameDialog)
        self.button_send.clicked.connect(self.sendCoordinates)

    def openFileNameDialog(self):
        # Opens a .csv file and then displays the array in a textEdit Widget
        options = QFileDialog.Options()
        options |= QFileDialog.DontUseNativeDialog
        fileName, _ = QFileDialog.getOpenFileName(self, "Open file...", "",
                                                  "CSV files (*.csv);;All Files(*)", options=options)
        if fileName:
            print(fileName)
            coordinates = np.loadtxt(open(fileName, "r"), delimiter=";")
            self.textEdit.setText(str(coordinates))
        return

    def sendCoordinates(self):
        # Connects to the controller and send the new coordinates loaded
        print("Sending coordinates to the controller")
        # command to connect to the controller


if __name__ == '__main__':
    app = QApplication(sys.argv)
    form = App()
    form.show()
    sys.exit(app.exec_())



