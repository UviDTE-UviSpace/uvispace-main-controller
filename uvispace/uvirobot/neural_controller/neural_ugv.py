# -*- coding: utf-8 -*-
"""This module trains a table Agente using different Reinforcement Learning
techniques.

All of distances are a square to avoid the square root calculation.
"""
import random
import numpy as np
from collections import deque
import matplotlib.pyplot as plt
import math

from plot_ugv import PlotUgv

# Size of Uvispace area
SPACE_X = 4
SPACE_Y = 3

# Maximum number of steps allowed
MAX_STEPS = 500

# Sampling period (time between 2 images)
PERIOD = (1 / 30)

# Reward weights
BETA_DIST = 0.01
BETA_GAP = 0.01
BETA_ZONE = 0.01

# Variable space quantization
NUM_DIV_STATE = 5
NUM_DIV_ACTION = 5
BAND_WIDTH = 0.02

# Define Reward Zones
ZONE0_LIMIT = 0.021
ZONE1_LIMIT = 0.056
ZONE2_LIMIT = 0.071

# Init to zero?
INIT_TO_ZERO = False

# Define trajectory
x_trajectory = np.linspace(0.2, 0.2, 201)
y_trajectory = np.linspace(0.2, 1.2, 201)  # 5mm

# Number of episodes
EPISODES = 500


class UgvEnv:
    a = int

    def __init__(self):

        # Size of the space
        self.max_x = SPACE_X / 2  # [m]
        self.max_y = SPACE_Y / 2  # [m]
        self.state = []
        self.x_goal = x_trajectory
        self.y_goal = y_trajectory
        self.ro = 0.0325  # [m]
        self.diameter = 0.133  # [m]
        self.time = PERIOD  # frames per second
        self.max_steps = MAX_STEPS
        self.constant = -0.1
        self.x_ant = 0.0
        self.y_ant = 0.0
        # Sqr of the limit distance
        self.zone_0_limit = ZONE0_LIMIT
        self.zone_1_limit = ZONE1_LIMIT
        self.zone_2_limit = ZONE2_LIMIT

    def reset(self):

        # Reset the environment (start a new episode)
        self.y = 0.2
        self.x = 0.2
        self.theta = 0
        self.steps = 0
        self.index = 0

        self._distance_next()
        self._calc_delta_theta()

        # discretize state for the agent to control
        self._discretize_agent_state()

        self.agent_state = [self.discrete_distance, self.discrete_delta_theta]

        # Create state (x,y,theta)
        self.state = [self.x, self.y, self.theta]

        return self.state, self.agent_state

    def step(self, action):  # m1 = left_motor, m2 = right_motor

        m1, m2 = self._dediscretize_action(action)

        # PWM to rads conversion
        wm1 = (42.77 * m1 / 128)
        wm2 = (42.77 * m2 / 128)

        # Calculate linear and angular velocity
        self.v_linear = (wm2 + wm1) * (self.ro / 2)
        self.w_ang = (wm2 - wm1) * (self.diameter / (4 * self.ro))

        # Calculate position and theta
        self.x = self.x + self.v_linear * math.cos(self.w_ang
                                                   * self.time) * self.time
        self.y = self.y + self.v_linear * math.sin(self.w_ang
                                                   * self.time) * self.time
        self.theta = self.theta + self.w_ang * self.time

        # Calculate the distance to the closest point in trajectory,
        # depending on distance, delta theta (ugv to trajectory) and distance
        # covered in this step
        self._distance_next()
        self._calc_zone()
        self._calc_delta_theta()
        self._distance_covered()

        # Calculate done and reward
        if self.index == (len(x_trajectory) - 1):
            done = 1
            reward = 20

        elif (self.x > self.max_x) or (self.x < -self.max_x) or \
                (self.y < -self.max_y) or (self.y > self.max_y):
            done = 1
            reward = -10

        elif self.steps >= self.max_steps:
            done = 1
            reward = -20

        elif self.zone_reward == 3:
            done = 1
            reward = -10

        else:
            done = 0
            reward = (-1 * BETA_DIST * self.distance) + BETA_GAP * self.gap \
                     - BETA_ZONE * self.zone_reward

        # Discretize state for the agent to control
        self._discretize_agent_state()
        self.agent_state = [self.discrete_distance, self.discrete_delta_theta]

        # Create state (x,y,theta)
        self.state = [self.x, self.y, self.theta]

        return self.state, self.agent_state, reward, done, None

    def _distance_next(self):

        self.distance = 10

        for w in range(self.index, self.index+6):
            self.dist_point = math.sqrt((x_trajectory[w] - self.x)**2
                                        + (y_trajectory[w] - self.y)**2)

            if self.dist_point < self.distance:
                self.distance = self.dist_point
                self.index = w

    def _calc_delta_theta(self):

        # Difference between the vehicle angle and the trajectory angle
        next_index = self.index+1

        if next_index >= len(x_trajectory):
            next_index = self.index

        self.delta_theta = math.atan2((y_trajectory[next_index]
                                       - y_trajectory[self.index]),
                                      (x_trajectory[next_index]
                                       - x_trajectory[self.index]))

    def _calc_zone(self):

        if self.distance < self.zone_0_limit:
            self.zone_reward = -1
        elif self.distance < self.zone_1_limit:
            self.zone_reward = 1
        elif self.distance < self.zone_2_limit:
            self.zone_reward = 2
        else:
            self.zone_reward = 3

        return

    def _distance_covered(self):

        # Calculation of distance traveled compared to the previous point
        self.gap = math.sqrt((self.x - self.x_ant)**2
                             - (self.y - self.y_ant)**2)
        self.x_ant = self.x
        self.y_ant = self.y

        return

    def _discretize_agent_state(self):

        left_band = -(((NUM_DIV_STATE-1)/2) - 0.5)

        self.discrete_distance = 0
        for div in range(NUM_DIV_STATE-1):
            if self.distance > ((left_band + div) * BAND_WIDTH):
                self.discrete_distance = div + 1

        angle_band_width = math.pi/(NUM_DIV_STATE - 2)

        self.discrete_delta_theta = 0
        for div in range(NUM_DIV_STATE - 1):
            if self.discrete_delta_theta > (left_band + div) * angle_band_width:
                self.discrete_delta_theta = div + 1

    def _dediscretize_action(self, action):

        discrete_m1 = action[0]
        discrete_m2 = action[1]

        m1 = 127 + discrete_m1 * 128/(NUM_DIV_ACTION - 1)
        m2 = 127 + discrete_m2 * 128/(NUM_DIV_ACTION - 1)

        return m1, m2


class Agent:
    def __init__(self, agent_type="SARSA"):
        self.agent_type = agent_type
        self._build_model()

        # Define some constants for the learning
        self.EPSILON_DECAY = 0.95
        self.EPSILON_MIN = 0.0
        self.ALFA = 0.04  # learning rate
        self.GANMA = 0.95  # discount factor

        # Reset the training variables
        self.epsilon = 1.0

    def _build_model(self):

        # Create the model all with zeros
        self.model = np.zeros([NUM_DIV_STATE, NUM_DIV_STATE,
                               NUM_DIV_ACTION, NUM_DIV_ACTION])

        # Initialize random Q table (except the terminal state that is 0)
        for distance in range(NUM_DIV_STATE):
            for delta_theta in range(NUM_DIV_STATE):
                for m1 in range(NUM_DIV_ACTION):
                    for m2 in range(NUM_DIV_ACTION):
                        if INIT_TO_ZERO:
                            self.model[distance, delta_theta, m1, m2] = 0
                        else:
                            if delta_theta == 0:
                                if m1 == m2:
                                    self.model[distance, delta_theta, m1, m2] \
                                        = 10
                                else:
                                    self.model[distance, delta_theta, m1, m2] \
                                        = -10
                            elif delta_theta < 0:
                                if m1 > m2:
                                    self.model[distance, delta_theta, m1, m2] \
                                        = 10
                                else:
                                    self.model[distance, delta_theta, m1, m2] \
                                        = -10
                            else:
                                if m1 < m2:
                                    self.model[distance, delta_theta, m1, m2] \
                                        = 10
                                else:
                                    self.model[distance, delta_theta, m1, m2] \
                                        = -10

    def _choose_action(self, agent_state):

        if np.random.rand() <= self.epsilon:
            action = [random.randrange(NUM_DIV_ACTION),
                      random.randrange(NUM_DIV_ACTION)]
        else:
            A = self.predict(agent_state)
            row_max = math.floor(np.argmax(A)/3)
            col_max = np.argmax(A)-3*math.floor(np.argmax(A)/3)
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

        new_state, new_agent_state, reward, done, _ = env.step(self.action)
        new_action = self._choose_action(new_agent_state)

        # Q(S;A)<-Q(S;A) + alfa[R + ganma*Q(S';A') - Q(S;A)]

        self.model[self.agent_state[0, 0], self.agent_state[0, 1],
                   self.action[0, 0], self.action[0, 1]] \
            += self.ALFA * (reward + self.GANMA
                            * self.predict(new_agent_state)[new_action[0],
                                                            new_action[1]]
                            - self.predict(self.state)[self.action])

        self.agent_state = new_agent_state
        self.action = new_action

        if done:
            self.epsilon *= self.EPSILON_DECAY
            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon

    def _train_step_qlearning(self, env):

        self.action = self._choose_action(self.state)
        new_state, new_agent_state, reward, done, _ = env.step(self.action)

        # Q(S;A)<-Q(S;A) + alfa[R + ganma*maxQ(S';a) - Q(S;A)]

        self.model[self.state[0, 0], self.state[0, 1], self.action] \
            += self.ALFA * (reward + self.GANMA*np.amax(self.predict(new_state))
                            - self.predict(self.state)[self.action])

        self.state = new_state

        if done:
            self.epsilon *= self.EPSILON_DECAY
            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon

    def _train_step_expected_sarsa(self, env):

        new_state, reward, done, _ = env.step(self.action)
        new_action = self._choose_action(new_state)

        # Q(S;A)<-Q(S;A) + alfa[R + E[Q(S';A')|S'] - Q(S;A)]

        self.model[self.state[0, 0], self.state[0, 1], self.action] \
            += self.ALFA * (reward + self.GANMA*(1/4)
                            * np.sum(self.predict(new_state)) -
                            self.predict(self.state)[self.action])

        self.state = new_state
        self.action = new_action

        if done:
            self.epsilon *= self.EPSILON_DECAY
            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN

        return new_state, reward, done, self.epsilon

    def _train_step_nstep_sarsa(self, env):

        new_state, reward, done, _ = env.step(self.action)

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

    # agent_types = ["SARSA","Q-Learning","Expected SARSA"]#, "n-step SARSA"]
    agent_types = ["SARSA"]

    # Train
    epi_reward = {}
    epi_reward_average = {}
    plot_ugv = PlotUgv(SPACE_X, SPACE_Y, x_trajectory, y_trajectory, PERIOD)

    for i in range(len(agent_types)):
        env = UgvEnv()
        agent = Agent(agent_types[i])
        epi_reward[i] = np.zeros([EPISODES])
        epi_reward_average[i] = np.zeros([EPISODES])

        for e in range(EPISODES):
            state = agent.init_episode(env)
            plot_ugv.reset(state[0], state[1], state[2])

            done = False
            while not done:
                state, reward, done, epsilon = agent.train_step(env)
                epi_reward[i][e] += reward
                plot_ugv.execute(state[0], state[1], state[2])

            epi_reward_average[i][e] = np.mean(epi_reward[i][max(0, e-20):e])
            print("episode: {} epsilon:{} reward:{} averaged reward:{}".format
                  (e, epsilon, epi_reward[i][e], epi_reward_average[i][e]))

    # Plot Rewards
    fig, ax = plt.subplots()
    fig.suptitle('Rewards')

    for j in range(len(epi_reward_average)):
        ax.plot(range(len(epi_reward_average[j])), epi_reward_average[j],
                label=agent_types[j])

    legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')
    plt.xlabel("Episode")
    plt.ylabel("Reward")
    plt.show()
