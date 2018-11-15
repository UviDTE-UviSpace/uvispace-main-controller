# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'loadfilesinterface.ui'
#
# Created by: PyQt5 UI code generator 5.5.1
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_Form(object):
    def setupUi(self, Form):
        Form.setObjectName("Form")
        Form.resize(400, 223)
        self.gridLayout = QtWidgets.QGridLayout(Form)
        self.gridLayout.setObjectName("gridLayout")
        self.textEdit = QtWidgets.QTextEdit(Form)
        self.textEdit.setObjectName("textEdit")
        self.gridLayout.addWidget(self.textEdit, 1, 1, 2, 2)
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.button_openfile = QtWidgets.QPushButton(Form)
        self.button_openfile.setObjectName("button_openfile")
        self.verticalLayout.addWidget(self.button_openfile)
        self.button_save = QtWidgets.QPushButton(Form)
        self.button_save.setObjectName("button_save")
        self.verticalLayout.addWidget(self.button_save)
        self.gridLayout.addLayout(self.verticalLayout, 1, 0, 1, 1)
        spacerItem = QtWidgets.QSpacerItem(20, 40, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout.addItem(spacerItem, 2, 0, 1, 1)
        self.button_cancel = QtWidgets.QPushButton(Form)
        self.button_cancel.setObjectName("button_cancel")
        self.gridLayout.addWidget(self.button_cancel, 3, 2, 1, 1)
        self.button_acept = QtWidgets.QPushButton(Form)
        self.button_acept.setObjectName("button_acept")
        self.gridLayout.addWidget(self.button_acept, 3, 1, 1, 1)
        self.label = QtWidgets.QLabel(Form)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 1, 1, 1)

        self.retranslateUi(Form)
        QtCore.QMetaObject.connectSlotsByName(Form)

    def retranslateUi(self, Form):
        _translate = QtCore.QCoreApplication.translate
        Form.setWindowTitle(_translate("Form", "Open file"))
        self.button_openfile.setText(_translate("Form", "Open .csv file"))
        self.button_save.setText(_translate("Form", "Save"))
        self.button_cancel.setText(_translate("Form", "Cancel"))
        self.button_acept.setText(_translate("Form", "Acept"))
        self.label.setText(_translate("Form", "Trayectory points:"))

