import sys

from PyQt5 import QtWidgets

from uvispace.uvigui.mainUi import MainWindow

if __name__ == '__main__':
    """
    It launches the Uvispace Graphical interface.
    Call with: python -m uvispace.uvigui
    """
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())
