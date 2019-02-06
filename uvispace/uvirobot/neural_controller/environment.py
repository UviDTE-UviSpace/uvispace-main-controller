# -*- coding: utf-8 -*-
"""This module trains a table Agent using different Reinforcement Learning
techniques.

"""
import numpy as np
import math
import time

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
ZONE0_LIMIT = 0.021  # Up to 2.1cm
ZONE1_LIMIT = 0.056  # Up to 5.6 cm
ZONE2_LIMIT = 0.071  # Up to 7.1 cm
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
        self.theta = 90
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
        wm1 = (42.77 * (m1 - 127) / 128)
        wm2 = (42.77 * (m2 - 127) / 128)

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
            reward = (-1 * BETA_DIST * self.distance) \
                     + BETA_GAP * self.gap - BETA_ZONE * self.zone_reward

        # Discretize state for the agent to control
        self._discretize_agent_state()
        self.agent_state = [self.discrete_distance, self.discrete_delta_theta]

        # Create state (x,y,theta)
        self.state = [self.x, self.y, self.theta]

        return self.state, self.agent_state, reward, done

    def _distance_next(self):

        self.distance = 10

        for w in range(self.index, self.index+6):
            self.dist_point = math.sqrt((x_trajectory[w] - self.x)**2 +
                                        (y_trajectory[w] - self.y)**2)
            if self.dist_point < self.distance:
                self.distance = self.dist_point
                self.index = w

        self._calc_side()

        self.distance = self.distance * self.sign

        return self.distance

    def _calc_delta_theta(self):

        # Difference between the vehicle angle and the trajectory angle
        next_index = self.index + 1

        if next_index >= len(x_trajectory):
            next_index = self.index

        self.trajec_angle = math.atan2((y_trajectory[next_index]
                                       - y_trajectory[self.index]),
                                       (x_trajectory[next_index]
                                        - x_trajectory[self.index]))

        self.delta_theta = self.trajec_angle - self.theta

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

        return self.gap

    def _calc_side(self):

        # Calculation of the side of the car with respect to the trajectory
        next_index = self.index + 1

        trajectory_vector = ((x_trajectory[next_index]
                              - x_trajectory[self.index]),
                             (y_trajectory[next_index]
                              - y_trajectory[self.index]))

        x_diff = self.x - x_trajectory[self.index]
        y_diff = self.y - y_trajectory[self.index]

        ugv_vector = (x_diff, y_diff)

        vector_z = ugv_vector[0] * trajectory_vector[1] - ugv_vector[1] - trajectory_vector[0]

        if vector_z > 0:

            # It is in the right side
            self.sign = 1

        else:

            # It is in the left side
            self.sign = -1

        return self.sign

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


if __name__ == "__main__":

        env = UgvEnv()
        action = (2, 2)
        EPISODES = 50
        epi_reward = np.zeros([EPISODES])
        epi_reward_average = np.zeros([EPISODES])

        state, agent_state = env.reset()

        b = PlotUgv(3, 4, x_trajectory, y_trajectory, 1 / 30)
        b.reset(state)

        # plot_ugv.reset(state[0], state[1], state[2])

        done = False
        while not done:
            state, agent_state, reward, done = env.step(action)
            # plot_ugv.execute(state[0], state[1], state[2])
            b.execute(state)

            print("reward:{} distance:{} gap:{} zone_reward:{} theta:{} done:{} x:{} y:{}"
                  .format(reward, env.distance, env.gap, env.zone_reward, env.theta, done, env.x, env.y))
            time.sleep(1)

