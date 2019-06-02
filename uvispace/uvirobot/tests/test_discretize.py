import sys
from os.path import realpath, dirname

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

import numpy as np
from uvispace.uvirobot.robot_model.environment import UgvEnv
import matplotlib.pyplot as plt
import math

if __name__ == "__main__":

    env = UgvEnv()
    distance = np.linspace(-0.07, 0.07, 101)
    delta_theta = np.linspace(-180.0, 180.0, 361)
    # delta_theta = np.arange(-75, 75, 1)

    discrete_distance_vector = np.empty(101)
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

        discrete_distance, discrete_delta_theta = env._discretize_agent_state(0, math.radians(j))

        discrete_delta_theta_vector[index] = discrete_delta_theta

        index += 1

    plt.figure()
    plt.plot(delta_theta, discrete_delta_theta_vector)
    plt.xlabel('delta_theta')
    plt.ylabel('discrete_delta_theta')
    plt.show()
