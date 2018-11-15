import numpy as np
import sys
from PyQt5.QtWidgets import QFileDialog, QWidget, QApplication, QMessageBox


import loadfilesinterface
"""
    Module used to load csv files with a list of coordinates for the controller.
    Opens a new window. The new window also shows the coordinate list after the file is loaded.
    The Loadedfile class stores the coordinates array and the filename
"""


class App(QWidget, loadfilesinterface.Ui_Form):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.button_openfile.clicked.connect(self.openFileNameDialog)
        self.button_save.clicked.connect(self.sendCoordinates)
        self.button_acept.clicked.connect(self.aceptCoordinates)
        self.button_cancel.clicked.connect(self.cancelCoordinates)
        self.file_csv = ""

    def aceptCoordinates(self):
        # acept the coordinates
        self.close()

    def cancelCoordinates(self):
        """
        shows a question message when user clicks on cancel. If Yes is selected, closes the window.
        If No is selected, nothing hapens
        :return:
        """

        message = QMessageBox.question(self, 'Cancel', "Do you want to cancel the modifications?",
                                       QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
        if message == QMessageBox.Yes:
            self.close()

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
            self.file_csv = fileName

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



