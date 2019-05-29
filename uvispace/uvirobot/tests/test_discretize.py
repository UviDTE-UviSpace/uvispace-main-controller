import sys
from os.path import realpath, dirname

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

import numpy as np
from uvispace.uvirobot.robot_model.environment import UgvEnv
import matplotlib.pyplot as plt

if __name__ == "__main__":

    env = UgvEnv()
    distance = np.linspace(-2, 2, 100)
    delta_theta = np.linspace(0.0, 360.0, 361)

    discrete_distance_vector = np.empty(100)
    discrete_delta_theta_vector = np.empty(361)

    index = 0

    for i in distance:

        discrete_distance, discrete_delta_theta = env._discretize_agent_state(i, 0)

        discrete_distance_vector[index] = discrete_distance

        index += 1

    plt.figure()
    plt.plot(distance, discrete_distance_vector)
    plt.xlabel('distance')
    plt.ylabel('discrete distance')

    index = 0

    for j in delta_theta:

        discrete_distance, discrete_delta_theta = env._discretize_agent_state(0, j)

        discrete_delta_theta_vector[index] = discrete_delta_theta

        index += 1

    plt.figure()
    plt.plot(delta_theta, discrete_delta_theta_vector)
    plt.xlabel('delta_theta')
    plt.ylabel('discrete_delta_theta')
    plt.show()
