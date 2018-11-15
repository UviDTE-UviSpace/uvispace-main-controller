"""Ventana principal del GUI

"""
import sys
import logging
import configparser
import os


# PyQt5 libraries
from PyQt5 import QtWidgets, QtCore, QtGui
from PyQt5.QtCore import QRegularExpression, QTimer
from PyQt5.QtWidgets import QLabel, QMessageBox, QWidget, QPlainTextEdit, QListWidgetItem
from PyQt5.QtGui import QIcon, QPixmap


# propietary libraries
import mainwindowinterface
import image_procesing
import load_csv

# Create the application logger
logger = logging.getLogger('view')


class AppLogHandler(logging.Handler):
    """
    Customized logging handler class, for printing on a PyQt Widget.
    """
    def __init__(self, widget):
        logging.Handler.__init__(self)
        logging.basicConfig(filename="loger.log")
        self.widget = widget
        #logging.setLevel(logging.DEBUG)
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
            logging.DEBUG: "icons/debug.png",#.format(parent_path),
            logging.INFO: "icons/info.png",#.format(parent_path),
            logging.WARN: "icons/warning.png",#.format(parent_path),
            logging.ERROR: "icons/error.png",#.format(parent_path),
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
        #self.widget.appendPlainText(new_log)
        parent_path = os.path.dirname(__file__)
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
    Includes the position (x,y,z), the battery status, the name of the UGV and an icon representing the UGV
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
        logger.info("Info")
        logger.error("Error")
        logger.debug("Debug")
        logger.warning("Warning")

        # Log console level selection buttons
        self.DebugCheck.clicked.connect(self.update_logger_level)
        self.InfoCheck.clicked.connect(self.update_logger_level)
        self.WarnCheck.clicked.connect(self.update_logger_level)
        self.ErrorCheck.clicked.connect(self.update_logger_level)

        # initialise the QTimer to update the cameras image
        self.__actualizar_imagen = QTimer()
        t_refresco = 100
        self.__actualizar_imagen.start(t_refresco)
        self.__actualizar_imagen.timeout.connect(self.__imagen_actualizar)
        # menu actions
        self.actionExit.triggered.connect(self.close)  # close the app
        self.action_about.triggered.connect(self.about_message)
        self.actionOpen_csv.triggered.connect(self.__loadfileswindow)
        # load cameras IP
        self.cameras_IPs = image_procesing.loadips()
        logger.info("Cameras IPs loaded")
        print(self.cameras_IPs)
        #load cameras size
        self.cameras_size = image_procesing.load_image_size()
        logger.info("Cameras size loaded")
        print(self.cameras_size)
        # file button event
        self.file_Button.clicked.connect(self.__loadfileswindow)
        coordinates_array = []  # stores the coordinates to send to the UGV
        self.filename = ""  # stores the filaname from where the coordinates are read

        # add Car Widget using QlistWidget
        itemN = QListWidgetItem(self.listWidget)
        widget = CarWidget()
        itemN.setSizeHint(widget.size())
        self.listWidget.addItem(itemN)
        self.listWidget.setItemWidget(itemN, widget)
        # testing the widget ...
        widget.label_x.setText("20")
        widget.progressBar_battery.setProperty('value', 90)


    def update_logger_level(self):
        """Evaluate the check boxes states and update logger level."""
        self.log_handler.enabled[logging.DEBUG] = self.DebugCheck.isChecked()
        self.log_handler.enabled[logging.INFO] = self.InfoCheck.isChecked()
        self.log_handler.enabled[logging.WARN] = self.WarnCheck.isChecked()
        self.log_handler.enabled[logging.ERROR] = self.ErrorCheck.isChecked()
        return

    def __check_img_type(self):
        """
        Checks the radio buttons state, to specify the image type to show in the viewer
        :return: string, can be BIN, GRAY, BLACK or RGB
        """

        if self.gray_rb.isChecked():
            img_type = "GRAY"
        elif self.bin_rb.isChecked():
            img_type = "BIN"
        elif self.rgb_rb.isChecked():
            img_type = "RGB"
        else:
            img_type = "BLACK"
        return img_type

    def __loadfileswindow(self):
        # opens a new window to load a .csv file
        logger.debug("Opening file loading window")
        self.popup = load_csv.App()
        self.popup.show()
        #change the lineEdit text
        self.filename = self.popup.file_csv
        self.lineEdit.setText(self.filename)
        return

    def __imagen_actualizar(self):
        """ refresh the image label
            calls the image_stack method to join the four camera images

        """
        image_np = image_procesing.image_stack(self.cameras_IPs, self.cameras_size, self.__check_img_type())

        # get the new image
        pixmap = QPixmap.fromImage(image_np).scaled(self.label.size(),
                                              aspectRatioMode= QtCore.Qt.KeepAspectRatio,
                                              transformMode = QtCore.Qt.SmoothTransformation)

        self.label.setPixmap(pixmap)
        # self.label.resize(width, height)
        self.label.adjustSize()
        self.label.setScaledContents(True)


    def about_message(self):
        # about message with a link to the main project web
        link = "https://uvispace.readthedocs.io/en/latest/"
        message = "App for the uvispace project <br> <a href='%s'>Project Web</a>" % link
        about = QMessageBox.about(self, "About...", message)


app = QtWidgets.QApplication(sys.argv)
form = MainWindow()
form.show()
sys.exit(app.exec_())
