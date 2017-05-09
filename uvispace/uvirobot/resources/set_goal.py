import sys
import time
import zmq

import settings

def main():
    goal = {
        'x': float(sys.argv[1]),
        'y': float(sys.argv[2])
    }
    socket = zmq.Context.instance().socket(zmq.PUB)
    # Send goals for robot 1
    socket.bind("tcp://*:{}".format(settings.goal_base_port+1))
    time.sleep(2)
    socket.send_json(goal)
    return

if __name__ == '__main__':
    main()
