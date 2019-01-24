# -*- coding: utf-8 -*-
import random
import numpy as np
from collections import deque
import matplotlib.pyplot as plt
import math

GRID_WIDTH = 15
GRID_HEIGHT = 15  # Change
x_trajectory = np.linspace(0.2, 0.2, 201)
y_trajectory = np.linspace(0.2, 1.2, 201)  # 5mm
EPISODES = 500


class UgvEnv:
    a = int

    def __init__(self, m1, m2):
        # Size of the space
        self.max_x = 4  # [m]
        self.max_y = 3
        self.x = float
        self.y = float
        self.v_linear = float
        self.w_ang = float
        self.state = []
        self.x_goal = x_trajectory
        self.y_goal = y_trajectory
        self.ro = 0.0325  # [m]
        self.diameter = 0.133  # [m]
        self.time = (1 / 30)  # frames per second
        self.m1 = m1
        self.m2 = m2
        self.x_edge = 0.1
        self.y_edge = 0.1
        self.distance = float
        self.steps = int
        self.max_steps = 100
        self.zone = int
        self.zone_0_limit = 0.00045  # [m]
        self.zone_1_limit = 0.0032  # [m]
        self.zone_2_limit = 0.0050  # [m]

    def reset(self):
        # Reset the environment (start a new episode)
        self.x = 5.0
        self.y = 0
        # self.theta = 0
        self.state = np.matrix([self.x, self.y])
        return self.state

    def step(self, m1, m2):  # m1 = left_motor, m2 = right_motor
        # PWM to rads conversion
        real_m1 = m1 - 127
        real_m2 = m2 - 127
        wm1 = (42.77 * real_m1 / 128)
        wm2 = (42.77 * real_m2 / 128)

        # Calculate linear and angular velocity
        self.v_linear = (wm2 + wm1) * (self.ro / 2)
        self.w_ang = (wm2 - wm1) * (self.diameter / (4 * self.ro))

        # Calculate position
        self.x = self.v_linear * math.cos(self.w_ang * self.time) * self.time
        self.y = self.v_linear * math.sin(self.w_ang * self.time) * self.time

        self.steps += 1

        # Calculate reward CAMBIARRRRRRRRRRRR
        if self._distance(self.x, self.y) > (self.x_edge**2 + self.y_edge**2):
            # Outside of borders
            reward = -100
            self.x = 5.0
            self.y = 5.0
        else:
            reward = - (self._distance(self.x, self.y))

        # Calculate done
        if (self.x == x_trajectory[len(x_trajectory) - 1]) and \
                (self.y == y_trajectory[len(y_trajectory) - 1]):
            done = 1
            reward = 10
            self.steps = 0
        elif (self.x > self.max_x) or (self.y > self.max_y):
            done = 1
            self.steps = 0
            reward = -10
        elif self.steps >= self.max_steps:
            done = 1
            self.steps = 0
            reward = -10
        elif self.zone == 3:  # se non se chamou á función que o calcula, queda gardado o valor anterior?
            done = 1
            self.steps = 0
            reward = -10
        else:
            done = 0

        return self.state, reward, done, None

    def _distance_next(self, x, y):  # TO DO FALTA RECORRER O ARRAY DOS PUNTOS E VER CAL É O MÁIS CERCANO, CHEGARÍA CON RECORRER OS 5 ANTERIORES E OS 10 POSTERIORES DESDE ONDE ESTÁS TI
        self.distance = (x_trajectory[self.a]**2 + y_trajectory[self.a]**2) - \
                        (x**2 + y**2)
        self.a += 1

        if self.distance < self.zone_0_limit:
            self.zone = -1
        elif self.distance < self.zone_1_limit:
            self.zone = 1
        elif self.distance < self.zone_2_limit:
            self.zone = 2
        else:
            self.zone = 3
        return self.zone

    def _distance_covered(self, x, y):

        # Se calcula la distancia recorrida respecto al punto anterior
        return self.gap


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

    def _build_model(self):  # Re do the size of the table
        # Create the model all with zeros
        self.model = np.zeros([GRID_WIDTH, GRID_HEIGHT, 4])

        # Initialize random Q table (except the terminal state that is 0)
        for x in range(GRID_WIDTH):
            for y in range(GRID_HEIGHT):
                for action in range(4):
                    if not ((y == 0) and (x == (GRID_WIDTH - 1))):
                        self.model[x, y, action] = -12  # np.random.rand()*-100

    def _choose_action(self, state):  # We need to do the action here
        if np.random.rand() <= self.epsilon:
            action = random.randrange(4)
        else:
            action = np.argmax(self.predict(state))
        return action

    def train_episode(self, env):
        if self.agent_type == "SARSA":
            return self._train_sarsa(env)
        if self.agent_type == "Q-Learning":
            return self._train_qlearning(env)
        if self.agent_type == "Expected SARSA":
            return self._train_expected_sarsa(env)
        if self.agent_type == "n-step SARSA":
            return self._train_nstep_sarsa(env)

    def _train_sarsa(self, env):
        # Init of the function -------------------------------------------------
        state = env.reset
        action = self._choose_action(state)
        done = False
        episode_reward = 0

        # ----------------------------------------------------------------------
        while not done:
            new_state, reward, done, _ = env.step(action)
            new_action = self._choose_action(new_state)

            # Q(S;A)<-Q(S;A) + alfa[R + ganma*Q(S';A') - Q(S;A)]
            self.model[state[0, 0], state[0, 1], action] \
                += self.ALFA * \
                (reward + self.GANMA*self.predict(new_state)[new_action]
                 - self.predict(state)[action])
            state = new_state
            action = new_action
            episode_reward += reward

        # ----------------------------------------------------------------------
        self.epsilon *= self.EPSILON_DECAY
        if self.epsilon < self.EPSILON_MIN:
            self.epsilon = self.EPSILON_MIN
        return episode_reward, self.epsilon

    def _train_qlearning(self, env):
        # Init of the function -------------------------------------------------
        state = env.reset
        done = False
        episode_reward = 0

        # ----------------------------------------------------------------------
        while not done:
            action = self._choose_action(state)
            new_state, reward, done, _ = env.step(action)

            # Q(S;A)<-Q(S;A) + alfa[R + ganma*maxQ(S';a) - Q(S;A)]
            self.model[state[0, 0], state[0, 1], action] \
                += self.ALFA * \
                (reward + self.GANMA*np.amax(self.predict(new_state))
                 - self.predict(state)[action])
            state = new_state
            episode_reward += reward

        # ----------------------------------------------------------------------
        self.epsilon *= self.EPSILON_DECAY
        if self.epsilon < self.EPSILON_MIN:
            self.epsilon = self.EPSILON_MIN
        return episode_reward, self.epsilon

    def _train_expected_sarsa(self, env):
        # Init of the function -------------------------------------------------
        state = env.reset
        action = self._choose_action(state)
        done = False
        episode_reward = 0

        # ----------------------------------------------------------------------
        while not done:
            new_state, reward, done, _ = env.step(action)
            new_action = self._choose_action(new_state)

            # Q(S;A)<-Q(S;A) + alfa[R + E[Q(S';A')|S'] - Q(S;A)]
            self.model[state[0, 0], state[0, 1], action] \
                += self.ALFA * \
                (reward + self.GANMA*(1/4)*np.sum(self.predict(new_state))
                 - self.predict(state)[action])
            state = new_state
            action = new_action
            episode_reward += reward

        # ----------------------------------------------------------------------
        self.epsilon *= self.EPSILON_DECAY
        if self.epsilon < self.EPSILON_MIN:
            self.epsilon = self.EPSILON_MIN
        return episode_reward, self.epsilon

    def _train_nstep_sarsa(self, env):
        # Init of the function -------------------------------------------------
        N = 3
        R = deque()
        A = deque()
        S = deque()
        state = env.reset
        action = self._choose_action(state)
        done = False
        episode_reward = 0
        S.append(state)
        A.append(action)
        T = float("inf")
        t = 0

        # ----------------------------------------------------------------------
        while not done:
            new_state, reward, done, _ = env.step(action)
            episode_reward += reward
            R.append(reward)
            S.append(new_state)
            if done:  # if St+1 terminal
                T = t + 1
            else:
                action = self._choose_action(new_state)
                A.append(action)

            tau = t - N + 1
            if tau >= 0:
                G = 0.0
                for i in range(tau+1, min(tau+N, T)):
                    G += (self.GANMA**(i-tau-1)) * R[i]
                if tau + N < T:
                    G = G + (self.GANMA**N)*self.predict(S[tau+N])[A[tau+N]]

                    # Q(S;A)<-Q(S;A) + alfa[R + ganma*Q(S';A') - Q(S;A)]
                    self.model[S[tau][0, 0], S[tau][0, 1], A[tau]] \
                        += self.ALFA * (G - self.predict(S[tau])[A[tau]])
            if tau == T - 1:
                break

            # Count the time
            t += 1

        # ----------------------------------------------------------------------
        self.epsilon *= self.EPSILON_DECAY
        if self.epsilon < self.EPSILON_MIN:
            self.epsilon = self.EPSILON_MIN
        return episode_reward, self.epsilon

    def predict(self, state):
        ret_val = self.model[state[0, 0], state[0, 1], :]
        return ret_val


if __name__ == "__main__":

    agent_types = ["SARSA", "Q-Learning", "Expected SARSA"]
    # agent_types = ["n-step SARSA"]

    # Train
    rewards = {}
    rewards_average = {}
    for i in range(len(agent_types)):
        env = UgvEnv()  # Rellenar parámetros de m1 y m2
        agent = Agent(agent_types[i])
        rewards[i] = np.zeros([EPISODES])
        rewards_average[i] = np.zeros([EPISODES])
        for e in range(EPISODES):
            episode_reward, epsilon = agent.train_episode(env)
            rewards[i][e] = episode_reward
            rewards_average[i][e] = np.mean(rewards[i][max(0, e-20):e])
            print("episode: {} epsilon:{} reward:{} averaged reward:{}"
                  .format(e, epsilon, rewards[i][e], rewards_average[i][e]))

    # Plot
    fig, ax = plt.subplots()
    fig.suptitle('Rewards')
    for j in range(len(rewards_average)):
        ax.plot(range(len(rewards_average[j])), rewards_average[j], label=agent_types[j])
    legend = ax.legend(loc='lower right', shadow=True, fontsize='x-large')
    plt.xlabel("Episode")
    plt.ylabel("Reward")
    plt.show()
