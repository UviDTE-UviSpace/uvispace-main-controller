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
from PyQt5.QtCore import QTimer, QModelIndex
from PyQt5.QtWidgets import QLabel, QMessageBox, QWidget, QListWidgetItem
from PyQt5.QtGui import QPixmap

# proprietary libraries
import uvispace.uvigui.tools.reinforcement_trainer.training_gui as reinforcement_train
from uvispace.uvigui import mainwindowinterface
from uvispace.uvigui.image_generator import ImageGenerator
from uvispace.uvigui import load_csv
import uvispace.uvigui.tools.fuzzy_controller_calib.fuzzy_calibration as fuzzy_calib
from uvispace.uvisensor.common import ImgType

logger = logging.getLogger('view')


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
            logging.DEBUG: "uvispace/uvigui/icons/debug.png",
            logging.INFO: "uvispace/uvigui/icons/info.png",
            logging.WARN: "uvispace/uvigui/icons/warning.png",
            logging.ERROR: "uvispace/uvigui/icons/error.png",
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
        self.label_2.setText("wifi:")
        self.label_wifi.setText("TextLabel")
        self.label_4.setText("x:")
        self.label_5.setText("y:")
        self.label_6.setText("theta:")
        self.label_x.setText("?")
        self.label_y.setText("?")
        self.label_z.setText("?")


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

        # draw folder icon on coordinates loader
        self.file_Button.setIcon(QtGui.QIcon('uvispace/uvigui/icons/folder.png'))
        self.file_Button.setIconSize(QtCore.QSize(16, 16))

        # create the subscriber to read the vehicles location
        configuration = configparser.ConfigParser()
        conf_file = "uvispace/config.cfg"
        configuration.read(conf_file)
        self.position_base_port = int(
            configuration["ZMQ_Sockets"]["position_base"])
        self.trajectory_base_port = int(
            configuration["ZMQ_Sockets"]["trajectory_base"])

        # Log console level selection buttons
        self.DebugCheck.clicked.connect(self.update_logger_level)
        self.InfoCheck.clicked.connect(self.update_logger_level)
        self.WarnCheck.clicked.connect(self.update_logger_level)
        self.ErrorCheck.clicked.connect(self.update_logger_level)

        # Image type checks
        self.bin_rb.clicked.connect(self.__check_img_type)
        self.gray_rb.clicked.connect(self.__check_img_type)
        self.black_rb.clicked.connect(self.__check_img_type)
        self.rgb_rb.clicked.connect(self.__check_img_type)

        # car list selection changed
        self.listWidget.itemSelectionChanged.connect(self.car_selection_changed)

        # image border, ugv and path check events
        self.grid_check.clicked.connect(self.update_border_status)
        self.ugv_check.clicked.connect(self.update_ugv_status)
        self.path_check.clicked.connect(self.update_view_trajectory_status)

        # file button event
        self.file_Button.clicked.connect(self.__load_files_window)
        self.trajectories = load_csv.App()
        self.coordinates_file_name = self.trajectories.file_csv
        self.lineEdit.setText(self.coordinates_file_name)
        self.trajectories.button_acept.clicked.connect(self.filename_updated)
        self.run_Button.clicked.connect(self.run)

        # menu actions
        self.actionExit.triggered.connect(self.close)  # close the app
        self.action_about.triggered.connect(self.about_message)
        self.actionOpen_csv.triggered.connect(self.__load_files_window)
        self.actionFuzzy_controller_calibration.triggered.connect(
            self.__fuzzy_controller_calibration)

        # initialise the QTimer to update the cameras image
        self.__update_image_timer = QTimer()
        t_refresh = int(configuration["GUI"]["visualization_fps"])
        self.__update_image_timer.start(1000/t_refresh)
        self.__update_image_timer.timeout.connect(self.__update_interface)
        self.actionReinforcement_training.triggered.connect(self.__reinforcement_training)

        # load the number of ugs, ugvs id and active ugvs
        self.num_ugvs = int(configuration["UGVs"]["number_ugvs"])
        self.ugv_ids = list(
            map(int, configuration["UGVs"]["ugv_ids"].split(",")))
        self.active_ugvs = list(
            map(int, configuration["UGVs"]["active_ugvs"].split(",")))

        # create an object to control the image generation
        self.img_generator = ImageGenerator(self.num_ugvs)

        # create sockets to read poses and publish trajectories
        # also creates the car widget with info about car id and car type
        self.trajectory_socket = []
        self.pose_sockets = []
        self.ugv_widget = []
        list_widget_item = []  # cars on the lateral list widget
        self.ugv_id_order = []  # relation between ugv ids and list widget order
        self.id_selected = 1  # ugv selected in gui list

        for i in range(self.num_ugvs):
            # socket to publish trajectories
            trajectory_publisher = zmq.Context.instance().socket(zmq.PUB)
            trajectory_publisher.sndhwm = 1
            trajectory_publisher.bind("tcp://*:{}".format(
                self.trajectory_base_port + i))
            self.trajectory_socket.append(trajectory_publisher)
            # socket to read robot pose (x, y and theta)
            pose_subscriber = zmq.Context.instance().socket(zmq.SUB)
            pose_subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
            pose_subscriber.setsockopt(zmq.CONFLATE, True)
            pose_subscriber.connect("tcp://localhost:{}".format(
                self.position_base_port + i))
            self.pose_sockets.append(pose_subscriber)

            # create car widget
            list_widget_item.append(QListWidgetItem(self.listWidget))
            widget = CarWidget()
            self.ugv_widget.append(widget)
            list_widget_item[i].setSizeHint(self.ugv_widget[i].size())

            # create an object to store ugv poses
            self.poses = [None]*self.num_ugvs

            # draw car widget if active
            # its prepared in case that in the future the cars could
            # be activated and deactivated dinamically

            if self.active_ugvs[i]:
                self.listWidget.addItem(list_widget_item[i])
                self.listWidget.setItemWidget(list_widget_item[i], self.ugv_widget[i])
                # load ugv properties
                self.ugv_widget[i].label_UGV.setText(str(self.ugv_ids[i]))
                # saves the relation between ugv ids and widgets order
                self.ugv_id_order.append(i)
                self.ugv_widget[i].label_wifi.setText(str(self.position_base_port+i))
                ugv_configuration = configparser.ConfigParser()
                ugv_conf_file = "uvispace/uvirobot/resources/config/robot{}.cfg".format(
                    self.ugv_ids[i])
                ugv_configuration.read(ugv_conf_file)
                ugv_type = ugv_configuration["Robot_chassis"]["ugv_type"]
                self.ugv_widget[i].label_icon.setText(ugv_type)
                logger.info("Car {} added".format(self.ugv_ids[i]))

                self.poses[i] = self.get_pose(i, block = "True")

    def run(self):
        # Get trajectory dictionary
        trajectory = self.trajectories.read_coordinates()

        # find ugv number from ugv id
        ugv_selected = 0
        for i in range(self.num_ugvs):
            if self.ugv_ids[i] == self.id_selected:
                ugv_selected = i

        # clean the real trajectory in the image
        self.img_generator.clean_real_trajectory()

        # send trajectories through the socket of the selected ugv
        self.trajectory_socket[ugv_selected].send_json(trajectory)
        logger.info('Trajectory sent')


    def filename_updated(self):
        # updates the csv filename on main gui
        filename = self.trajectories.read_filename()
        self.lineEdit.setText(filename)
        # updates the desired trajectory variable in image
        trajectory = self.trajectories.read_coordinates()
        self.img_generator.set_desired_trajectory(trajectory)

    def car_selection_changed(self):
        selected_widget = self.listWidget.currentRow()
        self.id_selected = self.ugv_id_order[selected_widget]
        self.img_generator.set_selected_ugv(id)
        logger.debug("Car selection changed to car  {}".format(id),)

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

    def update_view_trajectory_status(self):
        if self.path_check.isChecked():
            self.img_generator.set_trajectory_visible(True)
            logger.debug("Trajectory draw activated")
        else:
            self.img_generator.set_trajectory_visible(False)

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
        if self.gray_rb.isChecked():
            self.img_generator.set_img_type(ImgType.GRAY)
            logger.debug("Image changed to gray")
        elif self.bin_rb.isChecked():
            self.img_generator.set_img_type(ImgType.BIN)
            logger.debug("Image changed to bin")
        elif self.rgb_rb.isChecked():
            # Set Random image because RGB is not implemented yet
            self.img_generator.set_img_type(ImgType.RAND)
            logger.debug("Image changed to rgb")
        else:
            self.img_generator.set_img_type(ImgType.BLACK)
            logger.debug("Image changed to black")
        return

    def __load_files_window(self):
        # opens a new window to load a .csv file
        logger.debug("Opening file loading window")
        self.trajectories.show()
        # change the lineEdit text in main gui
        self.coordinates_file_name = self.trajectories.read_filename()
        self.lineEdit.setText(self.coordinates_file_name)
        return

    def __fuzzy_controller_calibration(self):
        # opens a new window to do the fuzzy controller calibration
        logger.debug("Opening the fuzzy controller calibration window")
        self.popup = fuzzy_calib.MainWindow()
        self.popup.show()
        return

    def __reinforcement_training(self):
        # opens a new window to do the neural controller training
        logger.debug("Opening the neural controller training window")
        self.popup = reinforcement_train.MainWindow()
        self.popup.show()
        return

    def __update_interface(self):
        """
        refresh the image label
        refresh the car coordinates
        """
        # update pose (only the ones that changed)
        if self.ugv_check.isChecked():
            for i in range(self.num_ugvs):
                if self.active_ugvs[i]:
                    r,pose = self.get_pose(i)
                    if r:
                        # update pose for later plot in the image
                        self.img_generator.set_pose(i, pose)
                        # update labels in ugv gui
                        self.ugv_widget[i].label_x.setText(str(pose['x']))
                        self.ugv_widget[i].label_y.setText(str(pose['y']))
                        self.ugv_widget[i].label_z.setText(str(pose['theta']))

        # update image (if changed)
        r, qpixmap_image = self.img_generator.get_image()
        if r:
            pixmap = QPixmap.fromImage(qpixmap_image).scaled(self.label.size(),
                                    aspectRatioMode=QtCore.Qt.KeepAspectRatio,
                                    transformMode=QtCore.Qt.SmoothTransformation)
            self.label.adjustSize()
            self.label.setScaledContents(True)
            self.label.setPixmap(pixmap)


    def get_pose(self, ugv_number, block = False):
        """
        read the UGVs pose(x,y,theta) from pose zmq socket
        :param int ugv_number: number of ugv in software (does not
         missunderstand with ugv_id)
        :param bool block: if true this function block and waits until a
         pose is available. if false it does not block
        :return: if block=True pose in format
         pose={"x":<x>, "y":<y>, "theta":<theta>} is returned.  If block = False
         (r, pose) are returned where r is True if a new pose was received and
         False otherwise. pose={"x":<x>, "y":<y>, "theta":<theta>} if r=True
         and None otherwise.
        """
        if block:
            pose = self.pose_sockets[ugv_number].recv_json()
            return pose

        else:
            try:
                # check for a message, this will not block the interface
                # if no message it leaves the try
                pose = self.pose_sockets[ugv_number].recv_json(flags=zmq.NOBLOCK)
                logger.debug("received pose {} for ugv {}".format(pose,ugv_number))
                r = True
            except:
                logger.debug("No pose received")
                pose = None
                r = False
            return r, pose
        return

    def about_message(self):
        # about message with a link to the main project web
        link = "https://uvispace.readthedocs.io/en/latest/"
        message = "App for the uvispace project <br> <a href='%s'>Project Web</a>" % link
        about = QMessageBox.about(self, "About...", message)
