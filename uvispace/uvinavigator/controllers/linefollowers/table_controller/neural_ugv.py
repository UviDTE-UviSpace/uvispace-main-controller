import numpy as np
import random
from collections import deque
import matplotlib.pyplot as plt
import math

import sys
from os.path import realpath, dirname

uvispace_path = dirname(dirname(dirname(dirname(dirname(dirname(dirname(realpath(__file__))))))))
sys.path.append(uvispace_path)

from uvispace.uvirobot.robot_model.environment import UgvEnv
from uvispace.uvinavigator.controllers.linefollowers.neural_controller.resources.plot_ugv import PlotUgv

# Size of Uvispace area
SPACE_X = 4
SPACE_Y = 3
# Sampling period (time between 2 images)
PERIOD = (1 / 30)
# Variable space quantization
NUM_DIV_STATE = 9
NUM_DIV_ACTION = 9
# Init to zero?
INIT_TO_ZERO = True
# Number of episodes
EPISODES = 5000
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

# x_trajectory = np.cos(np.linspace(180 * np.pi / 180, 0.01 * np.pi / 180, 61)) * 0.5 + 1
# y_trajectory = np.sin(np.linspace(180 * np.pi / 180, 0.01 * np.pi / 180, 61)) * 0.5 + 0.5

class Agent:
    def __init__(self, agent_type="SARSA"):
        self.agent_type = agent_type
        self._build_model()

        # Define some constants for the learning
        self.EPSILON_DECAY = 0.9995
        self.EPSILON_MIN = 0.1
        self.ALFA = 0.16  # learning rate
        self.GANMA = 0.95  # discount factor

        # Reset the training variables
        self.epsilon = 1.0

    def _build_model(self):

        # Create the model all with zeros
        self.model = np.zeros([NUM_DIV_STATE, NUM_DIV_STATE,
                               NUM_DIV_ACTION, NUM_DIV_ACTION])

        # Initialize random Q table (except the terminal state that is 0)
        for discrete_distance in range(NUM_DIV_STATE):
            for discrete_delta_theta in range(NUM_DIV_STATE):
                for m1 in range(NUM_DIV_ACTION):
                    for m2 in range(NUM_DIV_ACTION):
                        if INIT_TO_ZERO:
                            self.model[discrete_distance, discrete_delta_theta,
                                       m1, m2] = 0
                        else:
                            if discrete_delta_theta == (NUM_DIV_STATE/2) - 0.5:
                                # Is well oriented
                                if m1 == m2:
                                    self.model[discrete_distance,
                                               discrete_delta_theta,
                                               m1, m2] = 0.01
                                else:
                                    self.model[discrete_distance,
                                               discrete_delta_theta,
                                               m1, m2] = -0.01

                            elif discrete_delta_theta < (NUM_DIV_STATE/2) - 0.5:
                                # Is oriented to the left
                                if m1 < m2:
                                    self.model[discrete_distance,
                                               discrete_delta_theta,
                                               m1, m2] = 100.0
                                else:
                                    self.model[discrete_distance,
                                               discrete_delta_theta,
                                               m1, m2] = -0.01

                            else:
                                # Is oriented to the right
                                if m1 > m2:
                                    self.model[discrete_distance,
                                               discrete_delta_theta,
                                               m1, m2] = 100.0
                                else:
                                    self.model[discrete_distance,
                                               discrete_delta_theta,
                                               m1, m2] = -0.01

    def _choose_action(self, agent_state):

        if np.random.rand() <= self.epsilon:
            action = [random.randrange(NUM_DIV_ACTION),
                      random.randrange(NUM_DIV_ACTION)]

        else:
            A = self.predict(agent_state)
            row_max = np.argmax(A) // NUM_DIV_ACTION

            col_max = np.argmax(A) - NUM_DIV_ACTION*(np.argmax(A)
                                                     // NUM_DIV_ACTION)

            action = [row_max, col_max]

        return action

    def predict(self, agent_state):

        ret_val = self.model[agent_state[0], agent_state[1], :, :]

        return ret_val

    def init_episode(self, env):

        if self.agent_type == "SARSA":

            return self._init_episode_sarsa_qlearning(env)

        if self.agent_type == "Q-Learning":

            return self._init_episode_sarsa_qlearning(env)

        if self.agent_type == "Expected SARSA":

            return self._init_episode_sarsa_qlearning(env)

        if self.agent_type == "n-step SARSA":

            return self._init_episode_n_step_sarsa(env)

    def _init_episode_sarsa_qlearning(self, env):

        self.state, self.agent_state = env.reset()
        self.action = self._choose_action(self.agent_state)

        return self.state

    def _init_episode_n_step_sarsa(self, env):

        self.N = 3
        self.R = deque()
        self.A = deque()
        self.S = deque()

        self.state, self.agent_state = env.reset()
        self.action = self._choose_action(self.agent_state)

        self.S.append(self.agent_state)
        self.A.append(self.action)

        self.T = float("inf")
        self.t = 0

    def train_step(self, env):

        if self.agent_type == "SARSA":

            return self._train_step_sarsa(env)

        if self.agent_type == "Q-Learning":

            return self._train_step_qlearning(env)

        if self.agent_type == "Expected SARSA":

            return self._train_step_expected_sarsa(env)

        if self.agent_type == "n-step SARSA":

            return self._train_step_nstep_sarsa(env)

    def _train_step_sarsa(self, env):

        new_state, new_agent_state, reward, done = env.step(self.action)

        new_action = self._choose_action(new_agent_state)

        # Q(S;A)<-Q(S;A) + alfa[R + ganma*Q(S';A') - Q(S;A)]
        self.model[self.agent_state[0], self.agent_state[1], self.action[0],
                   self.action[1]] \
            += self.ALFA * (reward + self.GANMA
                            * self.predict(new_agent_state)[new_action[0],
                                                            new_action[1]]
                            - self.model[self.agent_state[0],
                                         self.agent_state[1],
                                         self.action[0], self.action[1]])

        self.agent_state = new_agent_state
        self.action = new_action

        if done:
            self.epsilon *= self.EPSILON_DECAY

            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon

    def _train_step_qlearning(self, env):

        new_state, new_agent_state, reward, done = env.step(self.action)

        new_action = self._choose_action(new_agent_state)

        # Q(S;A)<-Q(S;A) + alfa[R + ganma*maxQ(S';a) - Q(S;A)]

        self.model[self.agent_state[0], self.agent_state[1], self.action[0],
                   self.action[1]] \
            += self.ALFA * (reward + self.GANMA *
                            np.amax(self.predict(new_agent_state)[new_action[0],
                                                                  new_action[1]])
                            - self.model[self.agent_state[0],
                                         self.agent_state[1],
                                         self.action[0], self.action[1]])

        self.agent_state = new_agent_state
        self.action = new_action

        if done:
            self.epsilon *= self.EPSILON_DECAY

            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon

    def _train_step_expected_sarsa(self, env):

        new_state, new_agent_state, reward, done = env.step(self.action)

        new_action = self._choose_action(new_agent_state)

        # Q(S;A)<-Q(S;A) + alfa[R + E[Q(S';A')|S'] - Q(S;A)]

        self.model[self.agent_state[0], self.agent_state[1], self.action[0],
                   self.action[1]] \
            += self.ALFA * (reward + self.GANMA*(1/4)
                            * np.sum(self.predict(new_agent_state)
                                     [new_action[0], new_action[1]])
                            - self.predict(self.agent_state)[self.action[0],
                                                             self.action[1]])

        self.agent_state = new_agent_state
        self.action = new_action

        if done:
            self.epsilon *= self.EPSILON_DECAY

            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon

    def _train_step_nstep_sarsa(self, env):

        new_state, new_agent_state, reward, done = env.step(self.action)

        self.R.append(reward)
        self.S.append(new_state)

        if done:  # if St+1 terminal
            self.T = self.t + 1

        else:
            self.action = self._choose_action(new_state)
            self.A.append(self.action)

        tau = self.t - self.N + 1
        if tau >= 0:
            G = 0.0
            for i in range(tau+1, min(tau+self.N, self.T)):
                G += (self.GANMA**(i-tau-1)) * self.R[i]

            if tau + self.N < self.T:
                G = G + (self.GANMA**self.N) \
                    * self.predict(self.S[tau+self.N])[self.A[tau+self.N]]

                # Q(S;A)<-Q(S;A) + alfa[R + ganma*Q(S';A') - Q(S;A)]

                self.model[self.S[tau][0, 0], self.S[tau][0, 1], self.A[tau]] \
                    += self.ALFA * (G - self.predict(self.S[tau])[self.A[tau]])

        # Count the time
        if tau != self.T - 1:
            self.t += 1

        if done:
            self.epsilon *= self.EPSILON_DECAY

            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon


if __name__ == "__main__":

    # agent_types = ["SARSA","Q-Learning","Expected SARSA"]
    agent_types = ["SARSA"]
    # agent_types = ["Q-Learning"]
    # agent_types = ["Expected SARSA"]
    # agent_types = ["n-step SARSA"]

    # Train
    epi_reward = {}
    epi_reward_average = {}

    plot_ugv = PlotUgv(SPACE_X, SPACE_Y, x_trajectory, y_trajectory, PERIOD)

    for i in range(len(agent_types)):
        env = UgvEnv(x_trajectory, y_trajectory, PERIOD,
                     NUM_DIV_ACTION, True, True, True)

        agent = Agent(agent_types[i])
        epi_reward[i] = np.zeros([EPISODES])
        epi_reward_average[i] = np.zeros([EPISODES])

        for e in range(EPISODES):
            state = agent.init_episode(env)

            if e % 2000 == 0:
                plot_ugv.reset(state)

            done = False
            while not done:
                state, reward, done, epsilon = agent.train_step(env)
                epi_reward[i][e] += reward
                # print(agent.action)

                if e % 2000 == 0:
                    plot_ugv.execute(state)

            epi_reward_average[i][e] = np.mean(epi_reward[i][max(0, e-20):e])
            print("episode: {} epsilon:{} reward:{} averaged reward:{} distance:{} gap:{} theta:{}".format
                  (e, epsilon, epi_reward[i][e], epi_reward_average[i][e], env.distance, env.gap, env.state[2]))

    # Plot Rewards
    fig, ax = plt.subplots()
    fig.suptitle('Reward average')
    # print(agent.action)
    print(agent.model)

    for j in range(len(epi_reward_average)):
        ax.plot(range(len(epi_reward_average[j])), epi_reward_average[j],
                label=agent_types[j])

    legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')
    plt.xlabel("Episode")
    plt.ylabel("Reward average")
    plt.show()
