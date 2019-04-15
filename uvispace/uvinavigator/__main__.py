from uvispace.uvinavigator.uvinavigator import UviNavigator

if __name__ == '__main__':
    """
    Just launches the UviNavigator package and starts reading trajectories
    and pose of that robot through the zmq sockets and sending the motor
    setpoints through other zmq sockets so the UGV makes the trajectories.
    """
    navigator = UviNavigator(threaded = False)
    navigator.start()
