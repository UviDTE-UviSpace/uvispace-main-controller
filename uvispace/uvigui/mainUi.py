"""Ventana principal del GUI

"""
import sys
import logging
import configparser
import os


# PyQt5 libraries
from PyQt5 import QtWidgets, QtCore, QtGui
from PyQt5.QtCore import QRegularExpression, QTimer
from PyQt5.QtWidgets import QLabel, QMessageBox
from PyQt5.QtGui import QIcon, QPixmap


# propietary libraries
import mainwindowinterface
import image_procesing
import load_csv

# Create the application logger


class AppLogHandler(logging.Handler):
    """
    Customized logging handler class, for printing on a PyQt Widget
    """
    def __init__(self, widget):
        super().__init__()
        self.widget = widget
        self.setLevel(logging.DEBUG)
        

        # Log messages colours.
        """self.levelcolours = {
            logging.DEBUG: 'black',
            logging.INFO: 'blue',
            logging.WARN: 'orange',
            logging.ERROR: 'red',
        }
        # Paths to the log icons.
         parent_path = os.path.dirname(__file__)
        self.logsymbols = {
            logging.DEBUG: "{}/icons/debug.png".format(parent_path),
            logging.INFO: "{}/icons/info.png".format(parent_path),
            logging.WARN: "{}/icons/warning.png".format(parent_path),
            logging.ERROR: "{}/icons/error.png".format(parent_path),
        }
        # The True levels are the ones that are printed on the log.
        self.enabled = {
            logging.DEBUG: False,
            logging.INFO: True,
            logging.WARN: True,
            logging.ERROR: True,
        }"""
    def emit(self, record):
        """Override the logging.Handler.emit method.

            The received log message will be printed on the specified
            widget, typically a TextBox.
            """
        msg = self.format(record)
        self.widget.insertText(msg)
        new_log = self.format(record)
        self.widget.insertHtml('{log_msg}<br />'
                               .format(log_msg=new_log))
        self.widget.moveCursor(QtGui.QTextCursor.End)
        return


class MainWindow(QtWidgets.QMainWindow, mainwindowinterface.Ui_MainWindow):
    def __init__(self):
        QtWidgets.QMainWindow.__init__(self)
        # super(MainWindow, self).__init__()
        self.setupUi(self)
        self.popup = None

        # Initialise the logger
        handler = AppLogHandler(self.LoggerBrowser)
        handler.setFormatter(logging.Formatter('%(asctime)s : %(levelname)s - %(message)s'))
        file_handler = logging.FileHandler('loger.log')
        logger.addHandler(file_handler)

        logger.info("Logger iniciado")

        # initialise the QTimer to update the cameras image
        self.__actualizar_imagen = QTimer()
        t_refresco = 100
        self.__actualizar_imagen.start(t_refresco)
        self.__actualizar_imagen.timeout.connect(self.__imagen_actualizar)
        # menu actions
        self.actionSalir.triggered.connect(self.close)  # close the app
        self.action_about.triggered.connect(self.about_message)
        self.actionOpen_csv.triggered.connect(self.__loadfileswindow)
        # load cameras IP
        self.cameras_IPs = image_procesing.loadips()
        print(self.cameras_IPs)
        #load cameras size
        self.cameras_size = image_procesing.load_image_size()
        print(self.cameras_size)



    def __change_img_type(self):
        """
        Checks the radio buttons state, to especify the image type to show in the viewer
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
        return

    def __imagen_actualizar(self):
        """ refresh the image label
            calls the image_stack method to join the four camera images

        """
        image_procesing.image_stack(self.cameras_IPs, self.cameras_size, self.__change_img_type())
        # get the new image
        pixmap = QPixmap('salida.jpg').scaled(self.label.size(),
                                              aspectRatioMode= QtCore.Qt.KeepAspectRatio,
                                              transformMode = QtCore.Qt.SmoothTransformation)

        self.label.setPixmap(pixmap)
        #self.label.resize(width, height)
        self.label.adjustSize()
        self.label.setScaledContents(True)
        logger.info("Imagen actualizada")

    def about_message(self):
        # about message with a link to the main project web
        link = "https://uvispace.readthedocs.io/en/latest/"
        message = "App for the uvispace project <br> <a href='%s'>Project Web</a>" % link
        about = QMessageBox.about(self, "About...", message)

    def update_logger_level(self):
        """Evaluate the check boxes states and update logger level."""
        self.log_handler.enabled[logging.DEBUG] = self.DebugCheck.isChecked()
        self.log_handler.enabled[logging.INFO] = self.InfoCheck.isChecked()
        self.log_handler.enabled[logging.WARN] = self.WarnCheck.isChecked()
        self.log_handler.enabled[logging.ERROR] = self.ErrorCheck.isChecked()
        return


logger = logging.getLogger('view')

app = QtWidgets.QApplication(sys.argv)
form = MainWindow()
form.show()
sys.exit(app.exec_())
