# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'mainwindowinterface.ui'
#
# Created by: PyQt5 UI code generator 5.11.3
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(1116, 921)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(MainWindow.sizePolicy().hasHeightForWidth())
        MainWindow.setSizePolicy(sizePolicy)
        self.centralWidget = QtWidgets.QWidget(MainWindow)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.centralWidget.sizePolicy().hasHeightForWidth())
        self.centralWidget.setSizePolicy(sizePolicy)
        self.centralWidget.setObjectName("centralWidget")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.centralWidget)
        self.gridLayout_2.setContentsMargins(11, 11, 11, 11)
        self.gridLayout_2.setSpacing(6)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.group_logger = QtWidgets.QGroupBox(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.group_logger.sizePolicy().hasHeightForWidth())
        self.group_logger.setSizePolicy(sizePolicy)
        self.group_logger.setMaximumSize(QtCore.QSize(16777215, 200))
        self.group_logger.setAlignment(QtCore.Qt.AlignLeading|QtCore.Qt.AlignLeft|QtCore.Qt.AlignVCenter)
        self.group_logger.setObjectName("group_logger")
        self.gridLayout = QtWidgets.QGridLayout(self.group_logger)
        self.gridLayout.setContentsMargins(11, 11, 11, 11)
        self.gridLayout.setSpacing(6)
        self.gridLayout.setObjectName("gridLayout")
        self.DebugCheck = QtWidgets.QRadioButton(self.group_logger)
        self.DebugCheck.setChecked(True)
        self.DebugCheck.setAutoExclusive(False)
        self.DebugCheck.setObjectName("DebugCheck")
        self.gridLayout.addWidget(self.DebugCheck, 1, 3, 1, 1)
        self.WarnCheck = QtWidgets.QRadioButton(self.group_logger)
        self.WarnCheck.setChecked(True)
        self.WarnCheck.setAutoExclusive(False)
        self.WarnCheck.setObjectName("WarnCheck")
        self.gridLayout.addWidget(self.WarnCheck, 1, 1, 1, 1)
        self.ErrorCheck = QtWidgets.QRadioButton(self.group_logger)
        self.ErrorCheck.setChecked(True)
        self.ErrorCheck.setAutoExclusive(False)
        self.ErrorCheck.setObjectName("ErrorCheck")
        self.gridLayout.addWidget(self.ErrorCheck, 1, 2, 1, 1)
        self.InfoCheck = QtWidgets.QRadioButton(self.group_logger)
        self.InfoCheck.setChecked(True)
        self.InfoCheck.setAutoExclusive(False)
        self.InfoCheck.setObjectName("InfoCheck")
        self.gridLayout.addWidget(self.InfoCheck, 1, 0, 1, 1)
        self.LoggerBrowser = QtWidgets.QTextBrowser(self.group_logger)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.LoggerBrowser.sizePolicy().hasHeightForWidth())
        self.LoggerBrowser.setSizePolicy(sizePolicy)
        self.LoggerBrowser.setObjectName("LoggerBrowser")
        self.gridLayout.addWidget(self.LoggerBrowser, 2, 0, 1, 4)
        self.gridLayout_2.addWidget(self.group_logger, 4, 2, 1, 1)
        self.camera = QtWidgets.QVBoxLayout()
        self.camera.setSpacing(6)
        self.camera.setObjectName("camera")
        self.label = QtWidgets.QLabel(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.label.sizePolicy().hasHeightForWidth())
        self.label.setSizePolicy(sizePolicy)
        self.label.setObjectName("label")
        self.camera.addWidget(self.label)
        self.gridLayout_2.addLayout(self.camera, 0, 0, 16, 1)
        self.tabWidget = QtWidgets.QTabWidget(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.tabWidget.sizePolicy().hasHeightForWidth())
        self.tabWidget.setSizePolicy(sizePolicy)
        self.tabWidget.setMaximumSize(QtCore.QSize(300, 16777215))
        self.tabWidget.setObjectName("tabWidget")
        self.basic_control_tab = QtWidgets.QWidget()
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.basic_control_tab.sizePolicy().hasHeightForWidth())
        self.basic_control_tab.setSizePolicy(sizePolicy)
        self.basic_control_tab.setObjectName("basic_control_tab")
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self.basic_control_tab)
        self.verticalLayout_3.setContentsMargins(11, 11, 11, 11)
        self.verticalLayout_3.setSpacing(6)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.lineEdit = QtWidgets.QLineEdit(self.basic_control_tab)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.lineEdit.sizePolicy().hasHeightForWidth())
        self.lineEdit.setSizePolicy(sizePolicy)
        self.lineEdit.setMaximumSize(QtCore.QSize(280, 16777215))
        self.lineEdit.setObjectName("lineEdit")
        self.verticalLayout_3.addWidget(self.lineEdit)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setSpacing(6)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.run_Button = QtWidgets.QPushButton(self.basic_control_tab)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.run_Button.sizePolicy().hasHeightForWidth())
        self.run_Button.setSizePolicy(sizePolicy)
        self.run_Button.setMaximumSize(QtCore.QSize(100, 16777215))
        self.run_Button.setObjectName("run_Button")
        self.horizontalLayout.addWidget(self.run_Button)
        self.file_Button = QtWidgets.QPushButton(self.basic_control_tab)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.file_Button.sizePolicy().hasHeightForWidth())
        self.file_Button.setSizePolicy(sizePolicy)
        self.file_Button.setText("")
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("icons/folder.png"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        self.file_Button.setIcon(icon)
        self.file_Button.setObjectName("file_Button")
        self.horizontalLayout.addWidget(self.file_Button)
        self.verticalLayout_3.addLayout(self.horizontalLayout)
        self.listWidget = QtWidgets.QListWidget(self.basic_control_tab)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.listWidget.sizePolicy().hasHeightForWidth())
        self.listWidget.setSizePolicy(sizePolicy)
        self.listWidget.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAsNeeded)
        self.listWidget.setSizeAdjustPolicy(QtWidgets.QAbstractScrollArea.AdjustToContents)
        self.listWidget.setAutoScrollMargin(4)
        self.listWidget.setAlternatingRowColors(True)
        self.listWidget.setVerticalScrollMode(QtWidgets.QAbstractItemView.ScrollPerPixel)
        self.listWidget.setHorizontalScrollMode(QtWidgets.QAbstractItemView.ScrollPerPixel)
        self.listWidget.setResizeMode(QtWidgets.QListView.Adjust)
        self.listWidget.setViewMode(QtWidgets.QListView.ListMode)
        self.listWidget.setObjectName("listWidget")
        self.verticalLayout_3.addWidget(self.listWidget)
        self.tabWidget.addTab(self.basic_control_tab, "")
        self.train_tab = QtWidgets.QWidget()
        self.train_tab.setObjectName("train_tab")
        self.tabWidget.addTab(self.train_tab, "")
        self.gridLayout_2.addWidget(self.tabWidget, 1, 1, 1, 2)
        self.group_options = QtWidgets.QGroupBox(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.group_options.sizePolicy().hasHeightForWidth())
        self.group_options.setSizePolicy(sizePolicy)
        self.group_options.setObjectName("group_options")
        self.gridLayout_3 = QtWidgets.QGridLayout(self.group_options)
        self.gridLayout_3.setContentsMargins(11, 11, 11, 11)
        self.gridLayout_3.setSpacing(6)
        self.gridLayout_3.setObjectName("gridLayout_3")
        self.grid_check = QtWidgets.QCheckBox(self.group_options)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.grid_check.sizePolicy().hasHeightForWidth())
        self.grid_check.setSizePolicy(sizePolicy)
        self.grid_check.setObjectName("grid_check")
        self.gridLayout_3.addWidget(self.grid_check, 4, 0, 1, 1)
        self.path_check = QtWidgets.QCheckBox(self.group_options)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.path_check.sizePolicy().hasHeightForWidth())
        self.path_check.setSizePolicy(sizePolicy)
        self.path_check.setObjectName("path_check")
        self.gridLayout_3.addWidget(self.path_check, 4, 3, 1, 1)
        self.ugv_check = QtWidgets.QCheckBox(self.group_options)
        self.ugv_check.setObjectName("ugv_check")
        self.gridLayout_3.addWidget(self.ugv_check, 4, 1, 1, 1)
        self.label_img_type = QtWidgets.QLabel(self.group_options)
        self.label_img_type.setObjectName("label_img_type")
        self.gridLayout_3.addWidget(self.label_img_type, 0, 0, 1, 1)
        self.label_plot = QtWidgets.QLabel(self.group_options)
        self.label_plot.setObjectName("label_plot")
        self.gridLayout_3.addWidget(self.label_plot, 3, 0, 1, 1)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setSpacing(6)
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.black_rb = QtWidgets.QRadioButton(self.group_options)
        self.black_rb.setChecked(True)
        self.black_rb.setObjectName("black_rb")
        self.horizontalLayout_3.addWidget(self.black_rb)
        self.bin_rb = QtWidgets.QRadioButton(self.group_options)
        self.bin_rb.setObjectName("bin_rb")
        self.horizontalLayout_3.addWidget(self.bin_rb)
        self.gray_rb = QtWidgets.QRadioButton(self.group_options)
        self.gray_rb.setChecked(False)
        self.gray_rb.setObjectName("gray_rb")
        self.horizontalLayout_3.addWidget(self.gray_rb)
        self.rgb_rb = QtWidgets.QRadioButton(self.group_options)
        self.rgb_rb.setObjectName("rgb_rb")
        self.horizontalLayout_3.addWidget(self.rgb_rb)
        self.gridLayout_3.addLayout(self.horizontalLayout_3, 1, 0, 1, 5)
        self.gridLayout_2.addWidget(self.group_options, 2, 1, 1, 2)
        MainWindow.setCentralWidget(self.centralWidget)
        self.menuBar = QtWidgets.QMenuBar(MainWindow)
        self.menuBar.setGeometry(QtCore.QRect(0, 0, 1116, 22))
        self.menuBar.setObjectName("menuBar")
        self.menufile = QtWidgets.QMenu(self.menuBar)
        self.menufile.setObjectName("menufile")
        self.menuhelp = QtWidgets.QMenu(self.menuBar)
        self.menuhelp.setObjectName("menuhelp")
        self.menuTools = QtWidgets.QMenu(self.menuBar)
        self.menuTools.setObjectName("menuTools")
        MainWindow.setMenuBar(self.menuBar)
        self.mainToolBar = QtWidgets.QToolBar(MainWindow)
        self.mainToolBar.setObjectName("mainToolBar")
        MainWindow.addToolBar(QtCore.Qt.TopToolBarArea, self.mainToolBar)
        self.statusBar = QtWidgets.QStatusBar(MainWindow)
        self.statusBar.setObjectName("statusBar")
        MainWindow.setStatusBar(self.statusBar)
        self.actionExit = QtWidgets.QAction(MainWindow)
        self.actionExit.setObjectName("actionExit")
        self.action_about = QtWidgets.QAction(MainWindow)
        self.action_about.setObjectName("action_about")
        self.action_docs = QtWidgets.QAction(MainWindow)
        self.action_docs.setObjectName("action_docs")
        self.actionOpen_csv = QtWidgets.QAction(MainWindow)
        self.actionOpen_csv.setObjectName("actionOpen_csv")
        self.actionNuronal_controller_training = QtWidgets.QAction(MainWindow)
        self.actionNuronal_controller_training.setObjectName("actionNuronal_controller_training")
        self.actionFuzzy_controller_calibration = QtWidgets.QAction(MainWindow)
        self.actionFuzzy_controller_calibration.setObjectName("actionFuzzy_controller_calibration")
        self.menufile.addAction(self.actionOpen_csv)
        self.menufile.addAction(self.actionExit)
        self.menuhelp.addAction(self.action_about)
        self.menuTools.addAction(self.actionNuronal_controller_training)
        self.menuTools.addAction(self.actionFuzzy_controller_calibration)
        self.menuBar.addAction(self.menufile.menuAction())
        self.menuBar.addAction(self.menuTools.menuAction())
        self.menuBar.addAction(self.menuhelp.menuAction())

        self.retranslateUi(MainWindow)
        self.tabWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "UviSpace GUI"))
        self.group_logger.setTitle(_translate("MainWindow", "Logger"))
        self.DebugCheck.setText(_translate("MainWindow", "Debug"))
        self.WarnCheck.setText(_translate("MainWindow", "Warning"))
        self.ErrorCheck.setText(_translate("MainWindow", "Error"))
        self.InfoCheck.setText(_translate("MainWindow", "Info"))
        self.label.setText(_translate("MainWindow", "View"))
        self.run_Button.setText(_translate("MainWindow", "Run"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.basic_control_tab), _translate("MainWindow", "Basic control"))
        self.tabWidget.setTabText(self.tabWidget.indexOf(self.train_tab), _translate("MainWindow", "Parking"))
        self.group_options.setTitle(_translate("MainWindow", "Options"))
        self.grid_check.setText(_translate("MainWindow", "grid"))
        self.path_check.setText(_translate("MainWindow", "View path"))
        self.ugv_check.setText(_translate("MainWindow", "UGV"))
        self.label_img_type.setText(_translate("MainWindow", "Image type:"))
        self.label_plot.setText(_translate("MainWindow", "Plots"))
        self.black_rb.setText(_translate("MainWindow", "black"))
        self.bin_rb.setText(_translate("MainWindow", "bin"))
        self.gray_rb.setText(_translate("MainWindow", "gray"))
        self.rgb_rb.setText(_translate("MainWindow", "rgb"))
        self.menufile.setTitle(_translate("MainWindow", "File"))
        self.menuhelp.setTitle(_translate("MainWindow", "Help"))
        self.menuTools.setTitle(_translate("MainWindow", "Tools"))
        self.actionExit.setText(_translate("MainWindow", "Exit"))
        self.action_about.setText(_translate("MainWindow", "About..."))
        self.action_docs.setText(_translate("MainWindow", "Manual de utilización"))
        self.actionOpen_csv.setText(_translate("MainWindow", "Open .csv"))
        self.actionNuronal_controller_training.setText(_translate("MainWindow", "Neuronal controller training"))
        self.actionFuzzy_controller_calibration.setText(_translate("MainWindow", "Fuzzy controller calibration"))

