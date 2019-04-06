from distutils.util import strtobool
import threading
import configparser

from PyQt5 import QtWidgets

from uvispace.uvisensor.uvisensor import UviSensor
from uvispace.uvisensor.common import ImgType
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

        # create some threads to launch the different modules
        self.thread_UviSensor = threading.Thread(target = self.launch_UviSensor)
        self.thread_UviNavigator = threading.Thread(target = self.launch_UviNavigator)
        self.thread_UviRobot = threading.Thread(target = self.launch_UviRobot)

    def start(self):
        # launch UviSensor in a new thread
        self.thread_UviSensor.start()

        # Launch UviRobot
        pass

        # Launch UviNavigator
        pass

        # launch UviGui package
        if self.gui_enabled:
            app = QtWidgets.QApplication(sys.argv)
            form = MainWindow()
            form.show()
            sys.exit(app.exec_())
        else:
            while(1):
                pass

    def launch_UviSensor(self):
        sensor = UviSensor(enable_img = True, enable_triang = False)
        sensor.start_stream()

    def launch_UviNavigator():
        pass

    def launch_UviRobot(self):
        pass
