import sys
from os.path import realpath, dirname

import numpy as np

from uvispace.uvinavigator.controllers.linefollowers.table_controller.\
    neural_ugv import Agent

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

NUM_DIV_STATE = 3
NUM_DIV_ACTION = 3

if __name__ == "__main__":

    Agent = Agent()

    modelo = Agent.model

    i = 0


    for discrete_distance in range(NUM_DIV_STATE):
        for discrete_delta_theta in range(NUM_DIV_ACTION):
            for m1 in range(NUM_DIV_ACTION):
                for m2 in range(NUM_DIV_ACTION):
                    i += 1
                    modelo[discrete_distance, discrete_delta_theta, m1, m2] = i

    # print(modelo)

    # Se comprueba que se escoge siempre la acción correcta, siendo esta la de
    # mayor valor Q. Para ello se sustituye el self.epsilon por 0 para
    # que siempre entre en el else.

    for discrete_distance in range(NUM_DIV_STATE):
        for discrete_delta_theta in range(NUM_DIV_ACTION):

            agent_state = [discrete_distance, discrete_delta_theta]

            action_matrix = Agent.predict(agent_state)

            action = Agent._choose_action(agent_state)

            print(action_matrix)
            print("-----------")
