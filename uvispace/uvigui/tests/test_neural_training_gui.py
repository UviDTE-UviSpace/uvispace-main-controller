import sys
from os.path import realpath, dirname
from PyQt5 import QtWidgets

sys.path.append(dirname(dirname(dirname(dirname(realpath(__file__))))))

from uvispace.uvigui.tools.neural_controller_trainer.neural_training_gui import MainWindow

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    form = MainWindow()
    form.show()
    sys.exit(app.exec_())