import sys
from uvispace.uvinavigator.controllers.linefollowers.table_controller.tabular_agent import Agent
import numpy as np
from uvispace.uvirobot.robot_model.environment import UgvEnv
from uvispace.uvinavigator.common import TableAgentType
from collections import deque
import threading
import copy
import math
from PyQt5 import QtCore


class TableTraining(QtCore.QThread):

    def __init__(self):
        QtCore.QThread.__init__(self)

        self.SPACE_X = 4
        self.SPACE_Y = 3
        self.PERIOD = 1 / 30
        self.NUM_DIV_ACTION = 9
        self.INIT_TO_ZERO = True
        self.EPISODES = 5500

        self.lock = threading.Lock()

    def trainclosedcircuitplot(self, save_name='table.npy',
                               differential_car=True,
                               agent_type=TableAgentType.sarsa):

        """ This function defines the training variables and start the thread
        to train """

        self.save_name = save_name
        self.differential_car = differential_car
        self.agent_type = agent_type

        self.start()

    def run(self):

        """ This function runs the training algorithm """

        if self.differential_car:
            # Read csv file
            coordinates = np.loadtxt(
                open("uvispace/uvigui/tools/reinforcement_trainer/resources/training_differential.csv", "r"),
                delimiter=";")
            x_trajectory = []
            y_trajectory = []
            for point in coordinates:
                x_trajectory.append(point[0])
                y_trajectory.append(point[1])

        else:

            # Read csv file
            coordinates = np.loadtxt(
                open("uvispace/uvigui/tools/reinforcement_trainer/resources/training_ackerman.csv", "r"),
                delimiter=";")
            x_trajectory = []
            y_trajectory = []
            for point in coordinates:
                x_trajectory.append(point[0])
                y_trajectory.append(point[1])

        self.reward_need = 50
        # print(self.reward_need)

        scores = deque(maxlen=50)
        self.epi_reward_average = []
        # To plot velocity and distance to trayectory
        self.epi_v_average = []
        self.epi_d_average = []
        v = deque(maxlen=50)
        d = deque(maxlen=50)

        agent = Agent(self.agent_type)

        if self.differential_car:
            env = UgvEnv(x_trajectory, y_trajectory, self.PERIOD,
                         self.NUM_DIV_ACTION, closed=False,
                         differential_car=True, discrete_input=True)
        else:
            env = UgvEnv(x_trajectory, y_trajectory, self.PERIOD,
                         self.NUM_DIV_ACTION, closed=False,
                         differential_car=False, discrete_input=True)

        for e in range(self.EPISODES):

            agent.init_episode(env)

            done = False
            R = 0
            epi_v = []
            epi_d = []

            while not done:
                state, reward, done, epsilon = agent.train_step(env)
                epi_v.append(env.v_linear)
                epi_d.append(env.distance)
                R += reward

            scores.append(R)
            v.append(np.mean(epi_v))
            d.append(np.mean(epi_d))
            mean_score = np.mean(scores)

            if mean_score >= self.reward_need:
                count += 1
            else:
                count = 0

            # thread-safe copy of averages into shared variables with main
            # thread

            self.lock.acquire()
            self.epi_reward_average.append(np.mean(scores))
            self.epi_v_average.append(np.mean(v))
            self.epi_d_average.append(np.mean(d))
            self.lock.release()


            print("episode: {} epsilon:{} reward:{} averaged reward:{} distance:{} gap:{} theta:{}".format
                (e, epsilon, R, mean_score, env.distance, env.gap, env.state[2]))

            if count == 3:
                # print("episode: {}, score: {}, e: {:.2}, mean_score: {}, final state :({},{})"
                # .format(e, R, agent.epsilon, mean_score, env.state[0], env.state[1]))
                agent.save_model(self.save_name)
                break

    def read_averages(self):

        self.lock.acquire()
        return_reward = copy.deepcopy(self.epi_reward_average)
        return_v = copy.deepcopy(self.epi_v_average)
        return_d = copy.deepcopy(self.epi_d_average)
        self.lock.release()

        return return_reward, return_v, return_d


class TableTesting(QtCore.QThread):
    def __init__(self):
        QtCore.QThread.__init__(self)

        self.SPACE_X = 4
        self.SPACE_Y = 3
        self.PERIOD = 1/12
        self.NUM_DIV_ACTION = 9
        self.INIT_TO_ZERO = True
        self.EPISODES = 5500

        self.v = []
        self.d = []

        self.lock = threading.Lock()

    def testing(self, load_name, x_trajectory, y_trajectory, closed=True,
                differential_car=True, discrete_input=True):

        """ This function defines the testing variables """

        self.load_name = load_name
        self.x_trajectory = x_trajectory
        self.y_trajectory = y_trajectory
        self.closed = closed
        # self.states = []
        self.differential_car = differential_car
        self.discrete_input = discrete_input

        self.start()

    def run(self):

        """ This function runs the testing algorithm """

        if not self.closed:
            reward_need = (len(self.x_trajectory) // 50) * 5 + 10
            print("Reward if it finishes: {}".format(reward_need))

        scores = deque(maxlen=3)

        # INSTANCIO EL AGENTE
        agent = Agent("SARSA", training=False)  #  training sirve para q non chame a _build_model e colla o modelo q se carga do archivo

        agent.load_model(self.load_name)

        # INSTANCIO EL ENVIRONMENT EN FUNCIÓN DEL TIPO DE COCHE
        if self.differential_car:
            env = UgvEnv(self.x_trajectory, self.y_trajectory, self.PERIOD,
                         self.NUM_DIV_ACTION, closed=self.closed,
                         differential_car=True, discrete_input=True)

        else:
            env = UgvEnv(self.x_trajectory, self.y_trajectory, self.PERIOD,
                         self.NUM_DIV_ACTION, closed=self.closed,
                         differential_car=False, discrete_input=True)

        for e in range(self.EPISODES):

            agent.init_episode(env)

            done = False
            R = 0
            epi_v = []
            epi_d = []

            while not done:
                state, reward, done, epsilon = agent.train_step(env)  # putada. ollo q non volva entrenar. de algunha forma hai que meter o training = false

                epi_v.append(env.v_linear)
                epi_d.append(env.distance)
                R += reward

            scores.append(R)
            self.v.append(np.mean(epi_v))
            self.d.append(np.mean(epi_d))
            mean_score = np.mean(scores)

            print("episode: {} epsilon:{} reward:{} averaged reward:{} distance:{} gap:{} theta:{}".format
                (e, epsilon, R, mean_score, env.distance, env.gap, env.state[2]))

    def read_values(self):
        """ This function locks the variables to be read by the GUI """
        self.lock.acquire()
        return_v = copy.deepcopy(self.v)
        return_d = copy.deepcopy(self.d)
        self.lock.release()
        return return_v, return_d
