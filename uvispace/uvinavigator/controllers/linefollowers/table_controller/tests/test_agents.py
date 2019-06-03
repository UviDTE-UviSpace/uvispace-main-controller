import sys
from os.path import realpath, dirname

import numpy as np

from uvispace.uvinavigator.controllers.linefollowers.table_controller.\
    neural_ugv import Agent

from uvispace.uvirobot.robot_model.environment import UgvEnv

uvispace_path = dirname(dirname(dirname(dirname(realpath(__file__)))))
sys.path.append(uvispace_path)

# Define trajectory
x_trajectory = np.linspace(0.2, 0.2, 201)
y_trajectory = np.linspace(0.2, 1.2, 201)
x_trajectory = np.append(np.linspace(0.2, 0.2, 41), np.cos(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.3)
y_trajectory = np.append(np.linspace(0.2, 0.4, 41), np.sin(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.4)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.3)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.7)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.8)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.7)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.8)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.3)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.4)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.3)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.4)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.2)

PERIOD = 1/30
NUM_DIV_ACTION = 3

if __name__ == "__main__":

    env = UgvEnv(x_trajectory, y_trajectory, PERIOD,
                 NUM_DIV_ACTION, True, True, True)

    Agent = Agent()

    state = Agent._init_episode_sarsa_qlearning(env)

    print(state)




# self.predict(self.agent_state)[self.action[0], self.action[1]]