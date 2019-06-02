import sys
from os.path import realpath, dirname

import numpy as np
from uvispace.uvirobot.robot_model.environment import UgvEnv
import matplotlib.pyplot as plt

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)


if __name__ == "__main__":

    env = UgvEnv()

    num_div_action = 5
    action = np.arange(0, num_div_action, 1)

    m1_vector = np.empty(25)
    m2_vector = np.empty(25)
    discrete_action_vector_m1 = np.empty(25)
    discrete_action_vector_m2 = np.empty(25)

    index = 0

    for i in action:
        for j in action:

            discrete_action = [i, j]
            m1, m2 = env._dediscretize_action(discrete_action)

            discrete_action_vector_m1[index] = i
            discrete_action_vector_m2[index] = j

            m1_vector[index] = m1
            m2_vector[index] = m2

            index += 1

    plt.figure()
    plt.plot(discrete_action_vector_m1, m1_vector)
    plt.xlabel('action')
    plt.ylabel('m1_vector')

    plt.figure()
    plt.plot(discrete_action_vector_m2, m2_vector)
    plt.xlabel('action')
    plt.ylabel('m2_vector')

    plt.show()
