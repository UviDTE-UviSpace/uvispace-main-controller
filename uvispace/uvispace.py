from distutils.util import strtobool
import threading
import configparser
import sys

from PyQt5 import QtWidgets

from uvispace.uvisensor.uvisensor import UviSensor
from uvispace.uvirobot.uvirobot import UviRobot
from uvispace.uvinavigator.uvinavigator import UviNavigator
from uvispace.uvigui.mainUi import MainWindow

class UviSpace():
    """
    This class permits to launch all UviSpace packages in a single command
    UviSpace().start()
    """
    def __init__(self):
        # read configuration
        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)
        self.gui_enabled = strtobool(configuration["Run"]["gui_enabled"])

    def start(self):
        print("Starting Uvispace!!!")

        # launch UviSensor in a new thread
        sensor = UviSensor(enable_img = True, enable_triang = False, threaded = True)
        sensor.start_stream()

        # Launch UviRobot in a new thread
        robot = UviRobot(threaded = True)
        robot.start()

        # Launch UviNavigator in a new thread
        navigator = UviNavigator(threaded = True)
        navigator.start()


        # Leave in this thread a way to interact with UviSpace (gui or console)
        if self.gui_enabled:
            # launch UviGui package in this thread
            app = QtWidgets.QApplication(sys.argv)
            form = MainWindow()
            form.show()
            app.exec_()
        else:
            # launch a console
            response = ""
            while(response != "EXIT"):
                response = input('Type EXIT to leave UviSpace:')

        # Stop UviNavigator
        navigator.stop()

        # Stop UviRobot
        robot.stop()

        # Stop Uvisensor
        sensor.stop_stream()

        print("Leaving Uvispace!!!")
