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

# Size of Uvispace area
SPACE_X = 4
SPACE_Y = 3
# Reward weights
BETA_DIST = 0.01
BETA_GAP = 0.01
BETA_ZONE = 0.01
# Variable space quantization
NUM_DIV_STATE = 5
NUM_DIV_ACTION = 5
# Init to zero?
INIT_TO_ZERO = False

x_trajectory = np.linspace(0.2, 0.2, 201)
y_trajectory = np.linspace(0.2, 1.2, 201)  # 5mm
EPISODES = 500


class UgvEnv:
    a = int

    def __init__(self):
        # Size of the space
        self.max_x = SPACE_X / 2  # [m]
        self.max_y = SPACE_Y / 2  # [m]
        self.x = float
        self.y = float
        self.theta = float  # Ojo, funciones en radianes
        self.v_linear = float
        self.w_ang = float
        self.state = []
        self.x_goal = x_trajectory
        self.y_goal = y_trajectory
        self.ro = 0.0325  # [m]
        self.diameter = 0.133  # [m]
        self.time = (1 / 30)  # frames per second
        self.distance = float
        self.steps = int
        self.max_steps = 500
        self.zone = int
        self.constant = -0.1
        # Sqr of the limit distance
        self.zone_0_limit = 0.00045  # Up to 2.1cm
        self.zone_1_limit = 0.0032  # Up to 5.6 cm
        self.zone_2_limit = 0.0050  # Up to 7.1 cm
        self.last_index = int

    def reset(self):
        # Reset the environment (start a new episode)
        self.y = 5.0
        self.x = 5.0
        self.theta = 0
        self.steps = 0
        # self.state = np.matrix([self.x, self.y])
        self.last_index = 0

        self.state = [self.x, self.y, self.theta]
        self._distance_next()
        self._calc_delta_theta()

        ## xerar agent state en índices a partir de distancia e theta
        self.agent_state = []

        return self.state, self.agent_state

    def step(self, action):  # m1 = left_motor, m2 = right_motor
        action = [ ]  # Definir os intervalos, porque action devolve os indices donde estan as m1 e m2 que devolve o agent
        m1 = action [0]


        # PWM to rads conversion
        real_m1 = m1 - 127
        real_m2 = m2 - 127
        wm1 = (42.77 * real_m1 / 128)
        wm2 = (42.77 * real_m2 / 128)

        # Calculate linear and angular velocity
        self.v_linear = (wm2 + wm1) * (self.ro / 2)
        self.w_ang = (wm2 - wm1) * (self.diameter / (4 * self.ro))

        # Calculate position and theta
        self.x = self.v_linear * math.cos(self.w_ang * self.time) * self.time
        self.y = self.v_linear * math.sin(self.w_ang * self.time) * self.time
        self.theta = self.w_ang * self.time

        self.steps += 1

        # Calculate the distance to the closest point in trajectory and zone
        self._distance_next()
        self._calc_zone()
        self._calc_delta_theta()

        # Calculate done and reward
        if (self.x == x_trajectory[len(x_trajectory) - 1]) and \
                (self.y == y_trajectory[len(y_trajectory) - 1]):

            done = 1
            reward = 20

        elif (self.x > self.max_x) or (self.x < -self.max_x) or (self.y < -self.max_y) or (self.y > self.max_y):
            done = 1
            reward = -10

        elif self.steps >= self.max_steps:
            done = 1
            reward = -20

        elif self.zone == 3:  # se non se chamou á función que o calcula, queda gardado o valor anterior?
            done = 1
            reward = -10

        else:
            done = 0
            reward = (-1 * BETA_DIST * self.distance) + BETA_GAP * self.gap + BETA_ZONE * self.zone

        self.state = [self.x, self.y, self.theta]


        # xerar agent state en índices a partir de distancia e theta

        # dividir en intervalos a distancia que nos dea e gardala nun array, logo o agent state apuntará ao índice da distancia
        self.agent_state =


        return self.state, self.agent_state, reward, done, None


    def _calc_delta_theta(self):
        return


    def _distance_next(self):

        self.distance = 1

        for w in range(self.index, self.index+6):
            self.dist_point = (x_trajectory[w] - self.x)**2 + (y_trajectory[w]
                                                               - self.y)**2
            if self.dist_point < self.distance:
                self.distance = self.dist_point
                self.index = w

    def _calc_zone(self):
        if self.distance < self.zone_0_limit:
            self.zone = -1
        elif self.distance < self.zone_1_limit:
            self.zone = 1
        elif self.distance < self.zone_2_limit:
            self.zone = 2
        else:
            self.zone = 3

        return

    def _distance_covered(self, x, y):
        # Calculation of distance traveled compared to the previous point
        self.gap = (x**2 + y**2) - (self.x_ant**2 + self.y_ant**2)
        self.x_ant = x
        self.y_ant = y
        return


class Agent:
    def __init__(self, agent_type = "SARSA"):
        self.agent_type = agent_type
        self._build_model()
        # Define some constants for the learning
        self.EPSILON_DECAY = 0.95
        self.EPSILON_MIN = 0.0
        self.ALFA = 0.04 # learning rate
        self.GANMA = 0.95 # disccount factor
        # Reset the training variables
        self.epsilon = 1.0

    def _build_model(self):
        # Create the model all with zeros
        self.model = np.zeros([NUM_DIV_STATE, NUM_DIV_STATE, NUM_DIV_ACTION, NUM_DIV_ACTION])
        # Initialize random Q table (except the terminal state that is 0)
        for distance in range(NUM_DIV_STATE):
            for theta in range(NUM_DIV_STATE):
                for m1 in range(NUM_DIV_ACTION):
                    for m2 in range(NUM_DIV_ACTION):
                        if INIT_TO_ZERO:
                            self.model[distance, theta, m1, m2] = 0
                        else:
                            if theta == 0:
                                if m1 == m2:
                                    self.model[distance, theta, m1, m2] = 10
                                else:
                                    self.model[distance, theta, m1, m2] = -10
                            elif theta < 0:
                                if m1 > m2:
                                    self.model[distance, theta, m1, m2] = 10
                                else:
                                    self.model[distance, theta, m1, m2] = -10
                            else:
                                if m1 < m2:
                                    self.model[distance, theta, m1, m2] = 10
                                else:
                                    self.model[distance, theta, m1, m2] = -10

    def _choose_action(self, agent_state):
        if np.random.rand() <= self.epsilon:
            action = [random.randrange(NUM_DIV_ACTION, random.randrange(NUM_DIV_ACTION)]
        else:
            action = np.argmax(self.predict(agent_state))  # comprobar que devolve este argmax
        return action

    def predict(self, agent_state):
        ret_val = self.model[agent_state[0, 0], agent_state[0, 1], :, :]
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
        self.state, self.agent_state  = env.reset()
        self.action = self._choose_action(self.agent_state)
        return self.state

    def _init_episode_n_step_sarsa(self, env):
        self.N=3
        self.R = deque()
        self.A = deque()
        self.S = deque()
        self.state, self.agent_state = env.reset()
        self.action = self._choose_action(self.agent_state)
        self.S.append(self.agent_state)
        self.A.append(self.action)
        self.T = float("inf")
        self.t=0

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
        self.model[self.agent_state[0,0], self.agent_state[0, 1], self.action[0,0], self.action[0,1]] \
            += self.ALFA* \
            (reward + self.GANMA*self.predict(new_agent_state)[new_action] \
            - self.predict(self.state)[self.action])
        self.agent_state = new_agent_state
        self.action = new_action
        if done:
            self.epsilon *= self.EPSILON_DECAY
            if self.epsilon < self.EPSILON_MIN
                self.epsilon = self.EPSILON_MIN
        return new_state, reward, done, self.epsilon

    def _train_step_qlearning(self, env):
        self.action = self._choose_action(self.state)
        new_state, new_agent_state, reward, done, _ = env.step(self.action)
        # Q(S;A)<-Q(S;A) + alfa[R + ganma*maxQ(S';a) - Q(S;A)]
        self.model[self.state[0,0], self.state[0,1], self.action] \
            += self.ALFA* \
            (reward + self.GANMA*np.amax(self.predict(new_state)) \
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
        self.model[self.state[0,0], self.state[0,1], self.action] \
            += self.ALFA* \
            (reward + self.GANMA*(1/4)*np.sum(self.predict(new_state)) \
            - self.predict(self.state)[self.action])
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
        if done:#if St+1 terminal
            self.T = self.t + 1;
        else:
            self.action = self._choose_action(new_state)
            self.A.append(self.action)

        tau = self.t - self.N + 1
        if tau >= 0:
            G = 0.0
            for i in range(tau+1, min(tau+self.N,self.T)):
                G += (self.GANMA**(i-tau-1)) * self.R[i]
            if (tau + self.N < self.T):
                G = G + (self.GANMA**self.N)\
                *self.predict(self.S[tau+self.N])[self.A[tau+self.N]]
                # Q(S;A)<-Q(S;A) + alfa[R + ganma*Q(S';A') - Q(S;A)]
                self.model[self.S[tau][0,0], self.S[tau][0,1], self.A[tau]] \
                += self.ALFA* (G - self.predict(self.S[tau])[self.A[tau]])

        # Count the time
        if tau != self.T - 1:
          self.t += 1

        if done:
            self.epsilon *= self.EPSILON_DECAY
            if self.epsilon < self.EPSILON_MIN:
                self.epsilon = self.EPSILON_MIN
        return new_state, reward, done, self.epsilon




if __name__ == "__main__":
    agent_types = ["SARSA","Q-Learning","Expected SARSA"]#, "n-step SARSA"]
    #agent_types = ["n-step SARSA"]

    # Train
    epi_reward = {}
    epi_reward_average = {}
    for i in range(len(agent_types)):
        env = UgvEnv()
        agent = Agent(agent_types[i])
        epi_reward[i] = np.zeros([EPISODES])
        epi_reward_average[i] = np.zeros([EPISODES])
        for e in range(EPISODES):
            state = agent.init_episode(env)
            # Here the plot can be added for the initial state
            done = False
            while not done:
                state, reward, done, epsilon = agent.train_step(env)
                epi_reward[i][e] += reward
                # Here the plot can be added to plot every step
            epi_reward_average[i][e] = np.mean(epi_reward[i][max(0,e-20):e])
            print("episode: {} epsilon:{} reward:{} averaged reward:{}".format(e, epsilon, epi_reward[i][e], epi_reward_average[i][e]))

    # Plot Rewards
    fig, ax = plt.subplots()
    fig.suptitle('Rewards')
    for j in range(len(epi_reward_average)):
        ax.plot(range(len(epi_reward_average[j])), epi_reward_average[j], label=agent_types[j])
    legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')
    plt.xlabel("Episode")
    plt.ylabel("Reward")
    plt.show()
