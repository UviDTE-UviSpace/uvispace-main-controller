import os
import sys
import time
import zmq


def main():
    goal = {
        'x': float(sys.argv[1]),
        'y': float(sys.argv[2])
    }
    socket = zmq.Context.instance().socket(zmq.PUB)
    # Send goals for robot 1
    socket.bind("tcp://*:{}".format(
            int(os.environ.get("UVISPACE_BASE_PORT_GOAL"))+1))
    time.sleep(2)
    socket.send_json(goal)
    return

if __name__ == '__main__':
    main()
