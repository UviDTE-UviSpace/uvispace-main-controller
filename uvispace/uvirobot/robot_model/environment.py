# -*- coding: utf-8 -*-
"""This module trains a table Agent using different Reinforcement Learning
techniques.

"""
import numpy as np
import math
import time



# Size of Uvispace area
SPACE_X = 4
SPACE_Y = 3
# Maximum number of steps allowed
MAX_STEPS = 500

# Reward weights
BETA_DIST = 0.1
BETA_GAP = 0.1
BETA_ZONE = 0.05

BAND_WIDTH = 0.02
# Define Reward Zones
ZONE0_LIMIT = 0.021  # Up to 2.1cm
ZONE1_LIMIT = 0.056  # Up to 5.6 cm
ZONE2_LIMIT = 0.071  # Up to 7.1 cm


class UgvEnv:

    def __init__(self, x_traj, y_traj, period, num_div_action, closed=True, differential_car=True):

        # Size of the space
        self.max_x = SPACE_X / 2  # [m]
        self.max_y = SPACE_Y / 2  # [m]
        self.state = []
        self.x_trajectory = x_traj
        self.y_trajectory = y_traj
        self.ro = 0.0325  # [m]
        self.diameter = 0.133  # [m]
        self.time = period  # frames per second

        #more steps for ackerman model because circuit is longer
        if differential_car:
            self.max_steps = 500
        else:
            self.max_steps = 500



        self.constant = -0.1
        self.x_ant = 0.0
        self.y_ant = 0.0
        # Sqr of the limit distance
        self.zone_0_limit = ZONE0_LIMIT
        self.zone_1_limit = ZONE1_LIMIT
        self.zone_2_limit = ZONE2_LIMIT
        self.num_div_action = num_div_action
        #It is to inform if it´s an closed circuit without ending
        self.closed=closed

        #distance between axis in ackerman car
        self.l_ack=0.245
        #Radius of wheels of the ackerman car
        self.r_ack=0.035
        # Maximum angle of the wheels of the ackerman car
        self.alpha_ack=25.34*np.pi/180


        #Choose car model
        self.differential_car=differential_car

        #parameters to add noise to x, y, angle values
        #self.mu=0
        #self.sigmaxy=0.002
        #self.sigmaangle=2*np.pi/180


    def reset(self):

        # Reset the environment (start a new episode)
        self.y = 0.2
        self.x = 0.2
        self.theta = 90
        self.theta = math.radians(self.theta)
        self.steps = 0
        self.index = 0
        self.farthest = -1
        self.laps=0
        # add noise to position and theta
        #self.x_noise = self.x + np.random.normal(self.mu, self.sigmaxy, 1)
        #self.y_noise = self.y + np.random.normal(self.mu, self.sigmaxy, 1)
        #self.theta_noise = self.theta + np.random.normal(self.mu, self.sigmaangle, 1)

        self._distance_next()
        self._calc_delta_theta()

        # discretize state for the agent to control
        #self._discretize_agent_state()

        #self.agent_state has to be a matrix to be accepted by keras
        self.agent_state = np.array([self.distance, self.delta_theta])

        # Create state (x,y,theta)
        self.state = [self.x, self.y, self.theta]

        return self.state, self.agent_state

    def step(self, action):  # m1 = left_motor, m2 = right_motor

        m1, m2 = self._dediscretize_action(action)

        if self.differential_car == False:  # ackerman model
            #m1 = orientation  m2= engine

            # i dont know the relation between pwm to angle in radians

            wm1 = (16.257 * (m1 - 180) / 75)

            # the negative sign is because it turns to the left with PWM 0-127 and for us turning to the left is
            # positive w_ang
            wm2 = - self.alpha_ack * (m2 - 128) / 127


            #necesito el diametro de las ruedas
            self.v_linear=wm1*self.r_ack*np.cos(wm2)

            self.w_ang=-(wm1*self.r_ack*np.cos(wm2)*np.tan(wm2))/self.l_ack

        else: #differential model
            # PWM to rads conversion
            wm1 = (25 * (m1 - 127) / 128)
            wm2 = (25 * (m2 - 127) / 128)

            # Calculate linear and angular velocity
            self.v_linear = (wm2 + wm1) * (self.ro / 2)
            #wm1 - wm2 because m1 is the engine of  the right
            self.w_ang = (wm1 - wm2) * (self.diameter / (4 * self.ro))

        # Calculate position and theta
        self.x = self.x + self.v_linear * math.cos(self.theta) * self.time
        self.y = self.y + self.v_linear * math.sin(self.theta) * self.time
        self.theta = self.theta + self.w_ang * self.time



        #to set theta between [0,2pi]
        if self.theta > 2*math.pi:
            self.theta=self.theta-2*math.pi
        elif self.theta<0:
            self.theta=self.theta+2*math.pi

        # add noise to position and theta
        #self.x_noise = self.x + np.random.normal(self.mu, self.sigmaxy, 1)
        #self.y_noise = self.y + np.random.normal(self.mu, self.sigmaxy, 1)
        #self.theta_noise = self.theta + np.random.normal(self.mu, self.sigmaangle, 1)

        # Calculate the distance to the closest point in trajectory,
        # depending on distance, delta theta (ugv to trajectory) and distance
        # covered in this step
        self._distance_next()
        self._calc_zone()
        self._calc_delta_theta()
        self._distance_covered()
        #I want to know how far it went to give reward each 50 points

        # Calculate done and reward
        #Only want this end for open circuit
        if self.index == (len(self.x_trajectory) - 1) and not self.closed:
            done = 1
            reward = 20

        elif (self.x > self.max_x) or (self.x < -self.max_x) or \
                (self.y < -self.max_y) or (self.y > self.max_y):
            done = 1
            # It had a reward of -10 but doesnt make sense cause the car doesnt know where it is
            reward = 0

        elif self.steps >= self.max_steps:
            done = 1
            #Reward of -10 if its open circuit, for closed circuit reward=0 because it wouldnt make sense to punish
            #because it is infinite
            if self.closed:
                reward = 0
            else:
                reward=-10

        #elif math.fabs(self.delta_theta) > math.pi/2:
        #    done = 1
        #    reward = -10

        elif self.zone_reward == 3:
            done = 1
            reward = -10

        else:
            done = 0
            #I removed Christians rewards
            reward =-1 * BETA_DIST * math.fabs(self.distance) + BETA_GAP * self.gap
            if (self.index//50)>self.farthest:
                self.farthest=self.index//50
                reward+=5
#
            # Number of iterations in a episode
            self.steps += 1

        # Discretize state for the agent to control
        #self._discretize_agent_state()

        #self.norm_distance=(self.distance+0.071)/(0.071*2)
        #self.norm_delta_theta=(self.delta_theta+np.pi)/(2*np.pi)

        self.agent_state = np.array([self.distance, self.delta_theta])

        # Create state (x,y,theta)
        self.state = [self.x, self.y, self.theta]
        #print(self.state,self.sign)

        return self.state, self.agent_state, reward, done

    def _distance_next(self):

        self.distance = 10

        #Here a set index to 0 if the car is finishing a lap
        #Also reset the farthest
        if self.index > (len(self.x_trajectory) - 6) and self.closed:
            self.index=0
            self.farthest=-1
            self.laps+=1

        for w in range(self.index, self.index + 20):

            self.dist_point = math.sqrt((self.x_trajectory[w] - self.x)**2 +
                                        (self.y_trajectory[w] - self.y)**2)

            if self.dist_point < self.distance:
                self.distance = self.dist_point
                self.index = w

            if w >= (len(self.x_trajectory) - 1):
                break

        self._calc_side()

        self.distance = self.distance * self.sign

        return self.distance

    def _calc_delta_theta(self):

        # Difference between the vehicle angle and the trajectory angle
        next_index = self.index + 1

        if next_index >= len(self.x_trajectory):
            next_index = self.index

        self.trajec_angle = math.atan2((self.y_trajectory[next_index]
                                       - self.y_trajectory[self.index]),
                                       (self.x_trajectory[next_index]
                                        - self.x_trajectory[self.index]))
        #to set trajec_angle between [0,2pi]
        if self.trajec_angle < 0:
            self.trajec_angle= math.pi + self.trajec_angle + math.pi


        self.delta_theta = self.trajec_angle - self.theta#_noise
        #if the difference is bigger than 180 is because someone went trhoug a lap
        if self.delta_theta > math.pi:
            self.delta_theta = self.delta_theta - 2 * math.pi

        if self.delta_theta < -math.pi:
            self.delta_theta = self.delta_theta + 2 * math.pi



        #to avoid having differences bigger than 2pi

    def _calc_zone(self):

        if np.abs(self.distance) < self.zone_0_limit:

            self.zone_reward = -1

        elif np.abs(self.distance) < self.zone_1_limit:

            self.zone_reward = 1

        elif np.abs(self.distance) < self.zone_2_limit:

            self.zone_reward = 2

        else:

            self.zone_reward = 3

        return

    def _distance_covered(self):

        # Calculation of distance traveled compared to the previous point
        self.gap = math.sqrt((self.x - self.x_ant)**2
                             + (self.y - self.y_ant)**2)

        self.x_ant = self.x
        self.y_ant = self.y

        return self.gap

    def _calc_side(self):

        # Calculation of the side of the car with respect to the trajectory
        next_index = self.index + 1

        if next_index == len(self.x_trajectory):
            next_index = self.index

        trajectory_vector = ((self.x_trajectory[next_index]
                              - self.x_trajectory[self.index]),
                             (self.y_trajectory[next_index]
                              - self.y_trajectory[self.index]))

        x_diff = self.x - self.x_trajectory[self.index]
        y_diff = self.y - self.y_trajectory[self.index]

        ugv_vector = (x_diff, y_diff)

        vector_z = ugv_vector[0] * trajectory_vector[1] - ugv_vector[1] * trajectory_vector[0]

        if vector_z >= 0:

            # It is in the right side
            self.sign = 1

        else:

            # It is in the left side
            self.sign = -1

        return self.sign


        return self.sign


    def _dediscretize_action(self, action):

        if self.differential_car:
            # actions fron 0 to 24
            discrete_m1=action//5
            discrete_m2=action%5

            m1 = 127 + discrete_m1 * 128/(self.num_div_action - 1)
            m2 = 127 + discrete_m2 * 128/(self.num_div_action - 1)

        else:
            discrete_m1 = action // 5
            discrete_m2 = action % 5

            #the traction engine of the ackerman car starts working with pwm=180
            m1 = 180 + discrete_m1 * 75 / (self.num_div_action - 1)

            #it is the servo and goes from 0 to 255
            m2 =discrete_m2 * 255 / (self.num_div_action - 1)

        return m1, m2


        #Christian´s function

        #discrete_m1 = action[0]
        #discrete_m2 = action[1]
#
        #m1 = 127 + discrete_m1 * 128/(self.num_div_action - 1)
        #m2 = 127 + discrete_m2 * 128/(self.num_div_action - 1)
#
        #return m1, m2


if __name__ == "__main__":

        env = UgvEnv()
        action = (4, 1)
        EPISODES = 1
        epi_reward = np.zeros([EPISODES])
        epi_reward_average = np.zeros([EPISODES])

        state, agent_state = env.reset()

        b = PlotUgv(3, 4, env.x_trajectory, env.y_trajectory, 1 / 30)
        b.reset(state)

        # plot_ugv.reset(state[0], state[1], state[2])

        done = False
        while not done:
            state, agent_state, reward, done = env.step(action)
            # plot_ugv.execute(state[0], state[1], state[2])
            b.execute(state)

            print("reward:{} distance:{} gap:{} zone_reward:{} theta:{} done:{} x:{} y:{} index:{}"
                  .format(reward, env.distance, env.gap, env.zone_reward, env.theta, done, env.x, env.y, env.index))
            time.sleep(1)

