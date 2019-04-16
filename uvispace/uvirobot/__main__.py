from uvispace.uvirobot.uvirobot import UviRobot

if __name__ == '__main__':
    """
    Just launches the UviRobot package and starts sending the motor speed
    setpoints that enter from speed zmq sockets to the real UGVs.
    If simulated_ugvs mode is activated in the main UviSpace config file
    the movement of the robot is simulated using a model of it and the current
    pose of the UGV is sourced to the position zmq socket.
    """
    robot = UviRobot(threaded = False)
    robot.start()
