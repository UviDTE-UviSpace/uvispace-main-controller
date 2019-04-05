"""
Invokes the main Uvispace package. It launches all uvispace sub packages.
Each sub package goes in a different thread
"""

from distutils.util import strtobool

from uvispace.uvisensor.uvisensor import UviSensor
from uvispace.uvisensor.common import ImgType

if __name__ == "__main__":

    # read configuration
    configuration = configparser.ConfigParser()
    conf_file = "uvispace/config.cfg"
    configuration.read(conf_file)
    gui_enabled = strtobool(configuration["Run"]["gui_enabled"])

    # launch Uvisensor package
    sensor = UviSensor(enable_img = True, enable_triang = True)
    # starts stream (triangles and multi-images) in other thread
    sensor.start_stream()

    # Launch UviRobot
    pass

    # Launch UviNavigator
    pass

    # launch UviGui package
    if gui_enabled:
        pass
