import numpy as np
import sys
from PyQt5.QtWidgets import QFileDialog, QWidget, QApplication, QMessageBox
import zmq
import configparser


from uvispace.uvigui import loadfilesinterface
"""
    Module used to load csv files with a list of coordinates for the controller.
    Opens a new window. The new window also shows the coordinate list after the
    file is loaded.
"""


class App(QWidget, loadfilesinterface.Ui_Form):
    def __init__(self):
        super().__init__()
        self.setupUi(self)

        # buttons actions
        self.button_openfile.clicked.connect(self.openFileNameDialog)
        self.button_save.clicked.connect(self.sendCoordinates)
        self.button_acept.clicked.connect(self.aceptCoordinates)
        self.button_cancel.clicked.connect(self.cancelCoordinates)
        self.file_csv = ""

        # uvispace config file
        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)
        self.trajectory_base_port = int(
            configuration["ZMQ_Sockets"]["trajectory_base"])

        #socket to send trajectories
        pose_publisher = zmq.Context.instance().socket(zmq.PUB)
        # Send goals for robot 1
        pose_publisher.bind("tcp://*:{}".format(self.trajectory_base_port))



    def aceptCoordinates(self):
        # acept the coordinates and send to selected ugv
        self.close()

    def cancelCoordinates(self):
        """
        Shows a question message when user clicks on cancel. If Yes is selected,
        closes the window.
        If No is selected, nothing happens
        :return:
        """

        message = QMessageBox.question(self, 'Cancel',
                                       "Do you want to cancel the modifications?",
                                       QMessageBox.Yes | QMessageBox.No,
                                       QMessageBox.No)
        if message == QMessageBox.Yes:
            self.close()

    def openFileNameDialog(self):
        # Opens a .csv file and then displays the array in a textEdit Widget
        options = QFileDialog.Options()
        options |= QFileDialog.DontUseNativeDialog
        fileName, _ = QFileDialog.getOpenFileName(self, "Open file...", "",
                                                  "CSV files (*.csv);;All Files(*)",
                                                  options=options)
        if fileName:
            print(fileName)
            self.coordinates = np.loadtxt(open(fileName, "r"), delimiter=";")
            self.textEdit.setText(str(self.coordinates))
            self.file_csv = fileName
        return

    def sendCoordinates(self):
        # Connects to the controller and send the new coordinates loaded
        print("Sending coordinates to the controller")
        # command to connect to the controller

    def read_coordinates(self):
        # function to read coordiantes from main gui
        return self.coordinates

    def read_filename(self):
        # function to read filename from main gui
        return self.file_csv

if __name__ == '__main__':
     app = QApplication(sys.argv)
     form = App()
     form.show()
     sys.exit(app.exec_())
