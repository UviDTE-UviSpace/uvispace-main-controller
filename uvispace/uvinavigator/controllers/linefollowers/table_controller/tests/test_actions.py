import sys
from os.path import realpath, dirname

import numpy as np

from uvispace.uvinavigator.controllers.linefollowers.table_controller.\
    neural_ugv import Agent

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

if __name__ == "__main__":

    num_div_actions = 5
    Agent = Agent()
    discrete_distance = np.arange(0, num_div_actions, 1)
    discrete_delta_theta = np.arange(0, num_div_actions, 1)

    for i in discrete_distance:
        for j in discrete_delta_theta:
            virtual_agent = [i, j]
            ret_val = Agent.predict(virtual_agent)
            print("agent_state: {}".format(virtual_agent))
            print(ret_val)
            print("+++++++++++++++++++")
            action = Agent._choose_action(virtual_agent)
            print("Action: {}".format(action))
            print("----------------------------")
