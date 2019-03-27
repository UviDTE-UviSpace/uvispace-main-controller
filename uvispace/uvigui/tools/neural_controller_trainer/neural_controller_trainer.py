# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'neural_controller_trainer.ui'
#
# Created by: PyQt5 UI code generator 5.11.3
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_fuzzy_window(object):
    def setupUi(self, fuzzy_window):
        fuzzy_window.setObjectName("fuzzy_window")
        fuzzy_window.resize(721, 508)
        self.centralWidget = QtWidgets.QWidget(fuzzy_window)
        self.centralWidget.setObjectName("centralWidget")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.centralWidget)
        self.gridLayout_2.setContentsMargins(11, 11, 11, 11)
        self.gridLayout_2.setSpacing(6)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.stackedWidget = QtWidgets.QStackedWidget(self.centralWidget)
        self.stackedWidget.setObjectName("stackedWidget")
        self.page_0 = QtWidgets.QWidget()
        self.page_0.setObjectName("page_0")
        self.pbStartTraining = QtWidgets.QPushButton(self.page_0)
        self.pbStartTraining.setGeometry(QtCore.QRect(270, 210, 111, 31))
        self.pbStartTraining.setObjectName("pbStartTraining")
        self.label_3 = QtWidgets.QLabel(self.page_0)
        self.label_3.setGeometry(QtCore.QRect(10, 0, 131, 71))
        self.label_3.setObjectName("label_3")
        self.rbNeural = QtWidgets.QRadioButton(self.page_0)
        self.rbNeural.setGeometry(QtCore.QRect(10, 60, 121, 20))
        self.rbNeural.setObjectName("rbNeural")
        self.rbTables = QtWidgets.QRadioButton(self.page_0)
        self.rbTables.setGeometry(QtCore.QRect(10, 100, 111, 20))
        self.rbTables.setObjectName("rbTables")
        self.label = QtWidgets.QLabel(self.page_0)
        self.label.setGeometry(QtCore.QRect(440, 20, 211, 31))
        self.label.setObjectName("label")
        self.lefilename = QtWidgets.QLineEdit(self.page_0)
        self.lefilename.setGeometry(QtCore.QRect(440, 60, 113, 22))
        self.lefilename.setObjectName("lefilename")
        self.lTraining = QtWidgets.QLabel(self.page_0)
        self.lTraining.setGeometry(QtCore.QRect(120, 280, 421, 101))
        font = QtGui.QFont()
        font.setPointSize(16)
        self.lTraining.setFont(font)
        self.lTraining.setText("")
        self.lTraining.setObjectName("lTraining")
        self.stackedWidget.addWidget(self.page_0)
        self.page_1 = QtWidgets.QWidget()
        self.page_1.setObjectName("page_1")
        self.label_2 = QtWidgets.QLabel(self.page_1)
        self.label_2.setGeometry(QtCore.QRect(10, 0, 591, 41))
        self.label_2.setObjectName("label_2")
        self.pbnextButton = QtWidgets.QPushButton(self.page_1)
        self.pbnextButton.setGeometry(QtCore.QRect(620, 400, 75, 23))
        self.pbnextButton.setObjectName("pbnextButton")
        self.wTrainPlot = QtWidgets.QWidget(self.page_1)
        self.wTrainPlot.setGeometry(QtCore.QRect(-11, 30, 721, 361))
        self.wTrainPlot.setObjectName("wTrainPlot")
        self.stackedWidget.addWidget(self.page_1)
        self.page_2 = QtWidgets.QWidget()
        self.page_2.setObjectName("page_2")
        self.label_6 = QtWidgets.QLabel(self.page_2)
        self.label_6.setGeometry(QtCore.QRect(10, 10, 111, 31))
        self.label_6.setObjectName("label_6")
        self.stackedWidget.addWidget(self.page_2)
        self.gridLayout_2.addWidget(self.stackedWidget, 0, 1, 1, 1)
        fuzzy_window.setCentralWidget(self.centralWidget)
        self.menuBar = QtWidgets.QMenuBar(fuzzy_window)
        self.menuBar.setGeometry(QtCore.QRect(0, 0, 721, 26))
        self.menuBar.setObjectName("menuBar")
        fuzzy_window.setMenuBar(self.menuBar)
        self.mainToolBar = QtWidgets.QToolBar(fuzzy_window)
        self.mainToolBar.setObjectName("mainToolBar")
        fuzzy_window.addToolBar(QtCore.Qt.TopToolBarArea, self.mainToolBar)
        self.statusBar = QtWidgets.QStatusBar(fuzzy_window)
        self.statusBar.setObjectName("statusBar")
        fuzzy_window.setStatusBar(self.statusBar)

        self.retranslateUi(fuzzy_window)
        self.stackedWidget.setCurrentIndex(0)
        QtCore.QMetaObject.connectSlotsByName(fuzzy_window)

    def retranslateUi(self, fuzzy_window):
        _translate = QtCore.QCoreApplication.translate
        fuzzy_window.setWindowTitle(_translate("fuzzy_window", "proba"))
        self.pbStartTraining.setText(_translate("fuzzy_window", "Start Training"))
        self.label_3.setText(_translate("fuzzy_window", "Choose the controller:"))
        self.rbNeural.setText(_translate("fuzzy_window", "Neural Network"))
        self.rbTables.setText(_translate("fuzzy_window", "Tables"))
        self.label.setText(_translate("fuzzy_window", "Name the file:"))
        self.label_2.setText(_translate("fuzzy_window", "Training reults"))
        self.pbnextButton.setText(_translate("fuzzy_window", "Next Step"))
        self.label_6.setText(_translate("fuzzy_window", "Testing"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    fuzzy_window = QtWidgets.QMainWindow()
    ui = Ui_fuzzy_window()
    ui.setupUi(fuzzy_window)
    fuzzy_window.show()
    sys.exit(app.exec_())

