"""
    GUI main window
"""
import sys
import logging
import os
import zmq
import configparser

# PyQt5 libraries
from PyQt5 import QtWidgets, QtCore, QtGui
from PyQt5.QtCore import QTimer
from PyQt5.QtWidgets import QLabel, QMessageBox, QWidget, QListWidgetItem
from PyQt5.QtGui import QPixmap

# proprietary libraries
from uvispace.uvigui import mainwindowinterface
from uvispace.uvigui.image_generator import ImageGenerator
from uvispace.uvigui import load_csv
import uvispace.uvigui.tools.fuzzy_controller_calib.fuzzy_calibration as fuzzy_calib

class AppLogHandler(logging.Handler):
    """
    Customized logging handler class, for printing on a PyQt Widget.
    """
    def __init__(self, widget):
        logging.Handler.__init__(self)
        logging.basicConfig(filename="loger.log",
                            format="%(asctime)s.%(msecs)03d %(levelname)8s:"
                            " %(message)s",
                            datefmt="%H:%M:%S")
        self.widget = widget
        # logging.setLevel(logging.DEBUG)
        formatter = logging.Formatter(" %(asctime)s.%(msecs)03d %(levelname)8s:"
                                      " %(message)s", "%H:%M:%S")
        self.setFormatter(formatter)
        # Log messages colours.
        self.levelcolours = {
            logging.DEBUG: 'black',
            logging.INFO: 'blue',
            logging.WARN: 'orange',
            logging.ERROR: 'red',
        }
        # Paths to the log icons.
        parent_path = os.path.dirname(__file__)
        self.logsymbols = {
            logging.DEBUG: "icons/debug.png",
            logging.INFO: "icons/info.png",
            logging.WARN: "icons/warning.png",
            logging.ERROR: "icons/error.png",
        }
        # The True levels are the ones that are printed on the log.
        self.enabled = {
            logging.DEBUG: True,
            logging.INFO: True,
            logging.WARN: True,
            logging.ERROR: True,
        }

    def emit(self, record):
        """Override the logging.Handler.emit method.

        The received log message will be printed on the specified
        widget, typically a TextBox.
        """
        # Only print on the log the enabled log levels.
        if not self.enabled[record.levelno]:
            return
        new_log = self.format(record)
        #parent_path = os.path.dirname(__file__)
        self.widget.insertHtml('<img src="{img}" height="14" width="14"/>'
                               '<font color="{colour}">{log_msg}</font><br />'
                               .format(img=self.logsymbols[record.levelno],
                                       colour=self.levelcolours[record.levelno],
                                       log_msg=new_log))
        self.widget.moveCursor(QtGui.QTextCursor.End)
        return


class CarWidget(QWidget):
    """
    Custom PyQt5 Widget, for showing the UGV properties.
    Includes the position (x,y,z), the battery status, the name of the UGV and
    an icon representing the UGV
    """
    def __init__(self, parent=None):
        QWidget.__init__(self, parent=parent)
        self.resize(270, 122)
        self.setObjectName("Car Widget")
        self.label = QtWidgets.QLabel(self)
        self.label.setGeometry(QtCore.QRect(30, 0, 33, 17))
        self.label.setObjectName("label")
        self.progressBar_battery = QtWidgets.QProgressBar(self)
        self.progressBar_battery.setGeometry(QtCore.QRect(120, 2, 131, 21))
        self.progressBar_battery.setProperty("value", 50)
        self.progressBar_battery.setObjectName("progressBar_battery")
        self.label_icon = QLabel(self)
        self.label_icon.setGeometry(QtCore.QRect(10, 50, 60, 60))
        self.label_icon.setObjectName("label_icon")
        self.label_icon.setText("IconLabel")
        self.label_UGV = QtWidgets.QLabel(self)
        self.label_UGV.setGeometry(QtCore.QRect(10, 20, 67, 17))
        self.label_UGV.setObjectName("label_UGV")
        self.formLayoutWidget = QtWidgets.QWidget(self)
        self.formLayoutWidget.setGeometry(QtCore.QRect(90, 30, 171, 88))
        self.formLayoutWidget.setObjectName("formLayoutWidget")
        self.formLayout = QtWidgets.QFormLayout(self.formLayoutWidget)
        self.formLayout.setObjectName("formLayout")
        self.label_2 = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_2.setObjectName("label_2")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label_2)
        self.label_wifi = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_wifi.setObjectName("label_wifi")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.label_wifi)
        self.label_4 = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_4.setObjectName("label_4")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.label_4)
        self.label_5 = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_5.setObjectName("label_5")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.LabelRole, self.label_5)
        self.label_6 = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_6.setObjectName("label_6")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.LabelRole, self.label_6)
        self.label_x = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_x.setObjectName("label_x")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.label_x)
        self.label_y = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_y.setObjectName("label_y")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.FieldRole, self.label_y)
        self.label_z = QtWidgets.QLabel(self.formLayoutWidget)
        self.label_z.setObjectName("label_z")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.FieldRole, self.label_z)
        self.label.setText("UGV:")
        self.label_icon.setText("IconLabel")
        self.label_UGV.setText("TextLabel")
        self.label_2.setText( "wifi:")
        self.label_wifi.setText("TextLabel")
        self.label_4.setText("x:")
        self.label_5.setText( "y:")
        self.label_6.setText("z:")
        self.label_x.setText("TextLabel")
        self.label_y.setText("TextLabel")
        self.label_z.setText("TextLabel")


class MainWindow(QtWidgets.QMainWindow, mainwindowinterface.Ui_MainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        # super(MainWindow, self).__init__()
        self.setupUi(self)
        self.popup = None

        # Configure the logger

        self.log_handler = AppLogHandler(self.LoggerBrowser)
        logger.setLevel(5)
        logger.addHandler(self.log_handler)
        logger.info("Info debug actived")
        logger.error("Error debug actived")
        logger.debug("Debug debug actived")
        logger.warning("Warning debug actived")

        # Log console level selection buttons
        self.DebugCheck.clicked.connect(self.update_logger_level)
        self.InfoCheck.clicked.connect(self.update_logger_level)
        self.WarnCheck.clicked.connect(self.update_logger_level)
        self.ErrorCheck.clicked.connect(self.update_logger_level)

        #Image type checks
        self.bin_rb.clicked.connect(self.__check_img_type)
        self.gray_rb.clicked.connect(self.__check_img_type)
        self.black_rb.clicked.connect(self.__check_img_type)

        # initialise the QTimer to update the cameras image
        self.__update_image_timer = QTimer()
        t_refresh = 10
        self.__update_image_timer.start(t_refresh)
        self.__update_image_timer.timeout.connect(self.__update_interface)

        # menu actions
        self.actionExit.triggered.connect(self.close)  # close the app
        self.action_about.triggered.connect(self.about_message)
        self.actionOpen_csv.triggered.connect(self.__load_files_window)
        self.actionFuzzy_controller_calibration.triggered.connect(self.__fuzzy_controller_calibration)

        # create an object to control the image generation
        self.img_generator = ImageGenerator()

        # image border, ugv and path check events
        self.grid_check.clicked.connect(self.update_border_status)
        self.ugv_check.clicked.connect(self.update_ugv_status)

        # file button event
        self.file_Button.clicked.connect(self.__load_files_window)

        # add Car Widget using QlistWidget
        itemN = QListWidgetItem(self.listWidget)
        self.widget = CarWidget()
        itemN.setSizeHint(self.widget.size())
        self.listWidget.addItem(itemN)
        self.listWidget.setItemWidget(itemN, self.widget)
        logger.info("Car 1 added")
        # testing the widget ...
        #self.widget.label_x.setText("20")
        self.widget.progressBar_battery.setProperty('value', 90)
        self.widget.label_UGV.setText("Coche 1")

        # create the subscriber to read the vehicles location
        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)
        pose_port = configuration["ZMQ_Sockets"]["position_base"]
        self.receiver = zmq.Context.instance().socket(zmq.SUB)
        self.receiver.connect("tcp://localhost:{}".format(pose_port))
        self.receiver.setsockopt_string(zmq.SUBSCRIBE, u"")
        self.receiver.setsockopt(zmq.CONFLATE, True)

        print("hola")

    def update_ugv_status(self):
        if self.ugv_check.isChecked():
            self.img_generator.set_ugv_visible(True)
            logger.debug("UGV draw activated")
        else:
            self.img_generator.set_ugv_visible(False)

    def update_border_status(self):
        if self.grid_check.isChecked():
            self.img_generator.set_border_visible(True)
            logger.debug("Border draw activated")
        else:
            self.img_generator.set_border_visible(False)

    def update_logger_level(self):
        """Evaluate the check boxes states and update logger level."""
        self.log_handler.enabled[logging.DEBUG] = self.DebugCheck.isChecked()
        self.log_handler.enabled[logging.INFO] = self.InfoCheck.isChecked()
        self.log_handler.enabled[logging.WARN] = self.WarnCheck.isChecked()
        self.log_handler.enabled[logging.ERROR] = self.ErrorCheck.isChecked()
        return

    def __check_img_type(self):
        """
        Checks the radio buttons state, to specify the image type
        to show in the viewer
        """
        logger.debug("Clikado selector image")
        if self.gray_rb.isChecked():
            self.img_generator.set_img_type("GRAY")
            logger.debug("Image changed to gray")
        elif self.bin_rb.isChecked():
            self.img_generator.set_img_type("BIN")
            logger.debug("Image changed to bin")
        elif self.rgb_rb.isChecked():
            self.img_generator.set_img_type("RGB")
            logger.debug("Image changed to rgb")
        else:
            self.img_generator.set_img_type("BLACK")
            logger.debug("Image changed to black")
        self.img_generator.reconnect_cameras()
        return

    def __load_files_window(self):
        # opens a new window to load a .csv file
        logger.debug("Opening file loading window")
        self.popup = load_csv.App()
        self.popup.show()
        # change the lineEdit text
        coord_filename = self.popup.file_csv
        self.lineEdit.setText(coord_filename)
        return

    def __fuzzy_controller_calibration(self):
        # opens a new window to do the fuzzy controller calibration
        logger.debug("Opening the fuzzy controller calibration window")
        self.popup = fuzzy_calib.MainWindow()
        self.popup.show()
        return

    def __update_interface(self):
        """
        refresh the image label
        refresh the car coordinates

        """
        #self.get_pose()
        qpixmap_image = self.img_generator.get_image()

        pixmap = QPixmap.fromImage(qpixmap_image).scaled(self.label.size(),
                                aspectRatioMode= QtCore.Qt.KeepAspectRatio,
                                transformMode = QtCore.Qt.SmoothTransformation)

        self.label.adjustSize()
        self.label.setScaledContents(True)
        self.label.setPixmap(pixmap)

    def get_pose(self):
        # read the car coordinates and the angle
        # Connects to the IP port and read the pose of the UGV
        #TODO: read the UGV IP from file

        coordinates = self.receiver.recv_json()

        #translate coordinates from uvispace reference system to numpy
        x_mm = coordinates['x']
        y_mm = coordinates['y']
        #x_px = (x_mm+2000)*1280/4000
        #y_px = (-y_mm+1500)*936/3000
        x_px = int(x_mm)
        y_px = int(y_mm)


        x_px = int(x_mm)
        y_px = int(y_mm)
        self.widget.label_x.setText(str(x_px))
        self.widget.label_y.setText(str(y_px))
        self.widget.label_z.setText(str(coordinates['theta']))

        return coordinates

    def about_message(self):
        # about message with a link to the main project web
        link = "https://uvispace.readthedocs.io/en/latest/"
        message = "App for the uvispace project <br> <a href='%s'>Project Web</a>" % link
        about = QMessageBox.about(self, "About...", message)
