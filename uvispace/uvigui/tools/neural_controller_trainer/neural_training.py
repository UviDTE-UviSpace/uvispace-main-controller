import sys
from uvispace.uvirobot.neural_controller.DQNagent import  Agent
import numpy as np
from uvispace.uvirobot.neural_controller.environment import UgvEnv
import math
from collections import deque
import threading
import copy
from PyQt5 import QtCore
class Training(QtCore.QThread):
    def __init__(self):
        QtCore.QThread.__init__(self)

        self.SPACE_X = 4
        self.SPACE_Y = 3
        self.PERIOD= 1/30
        self.NUM_DIV_ACTION = 5
        self.INIT_TO_ZERO = True
        self.EPISODES = 2000
        self.state_size = 2
        self.action_size = 5 * 5

        self.lock = threading.Lock()

    def trainclosedcircuitplot(self, load=False, load_name='emodel.h5', save_name='emodel.h5', reward_need=100):

        self.load = load
        self.load_name = load_name
        self.save_name = save_name
        self.reward_need = reward_need

        self.start()

    def run(self):

        x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                 np.cos(np.linspace(180 * math.pi / 180, 90 * math.pi / 180, 61)) * 0.1 + 0.3)
        y_trajectory = np.append(np.linspace(0.2, 0.4, 41),
                                 np.sin(np.linspace(180 * math.pi / 180, 90 * math.pi / 180, 61)) * 0.1 + 0.4)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(270 * math.pi / 180, 360 * math.pi / 180, 81)) * 0.2 + 0.3)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(270 * math.pi / 180, 360 * math.pi / 180, 81)) * 0.2 + 0.7)
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(180 * math.pi / 180, 0 * math.pi / 180, 141)) * 0.3 + 0.8)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(180 * math.pi / 180, 0 * math.pi / 180, 141)) * 0.3 + 0.7)
        x_trajectory = np.append(x_trajectory, np.linspace(1.1, 1.1, 81))
        y_trajectory = np.append(y_trajectory, np.linspace(0.7, 0.3, 81))
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(0 * math.pi / 180, -90 * math.pi / 180, 81)) * 0.3 + 0.8)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(0 * math.pi / 180, -90 * math.pi / 180, 81)) * 0.3 + 0.3)
        x_trajectory = np.append(x_trajectory, np.linspace(0.8, 0.4, 81))
        y_trajectory = np.append(y_trajectory, np.linspace(0, 0, 81))
        x_trajectory = np.append(x_trajectory,
                                 np.cos(np.linspace(270 * math.pi / 180, 180 * math.pi / 180, 81)) * 0.2 + 0.4)
        y_trajectory = np.append(y_trajectory,
                                 np.sin(np.linspace(270 * math.pi / 180, 180 * math.pi / 180, 81)) * 0.2 + 0.2)

        scores = deque(maxlen=50)
        self.epi_reward_average = []
        # To plot velocity and distance to trayectory
        self.epi_v_average = []
        self.epi_d_average = []
        v = deque(maxlen=50)
        d = deque(maxlen=50)
        agent = Agent(self.state_size, self.action_size, gamma=0.999, epsilon=1, epsilon_min=0.01, epsilon_decay=0.995,
                      learning_rate=0.01, batch_size=128, tau=0.01)
        env = UgvEnv(x_trajectory, y_trajectory, self.PERIOD,
                     self.NUM_DIV_ACTION, closed=True)
        if self.load:
            agent.load_model(self.load_name)

        for e in range(self.EPISODES):
            state, agent_state = env.reset()
            agent_state = agent.format_state(agent_state)
            done = False
            R = 0
            epi_v = []
            epi_d = []

            while not done:
                action = agent.action(agent_state)
                new_state, new_agent_state, reward, done = env.step(action)
                epi_v.append(env.v_linear)
                epi_d.append(np.sqrt(new_agent_state[0] ** 2))
                new_agent_state = agent.format_state(new_agent_state)
                agent.remember(agent_state, action, reward, new_agent_state, done)

                agent_state = new_agent_state
                R += reward

            if len(agent.memory) > agent.batch_size:
                agent.replay()
                agent.soft_update_target_network()
            agent.reduce_random()
            scores.append(R)
            v.append(np.mean(epi_v))
            d.append(np.mean(epi_d))
            mean_score = np.mean(scores)

            # thread-safe copy of averages into shared variables with main thread
            self.lock.acquire()
            self.epi_reward_average.append(np.mean(scores))
            self.epi_v_average.append(np.mean(v))
            self.epi_d_average.append(np.mean(d))
            self.lock.release()

            if e%100 == 0:
                print("episode: {}/{}, score: {}, e: {:.2}, mean_score: {}, final state :({},{})"
                      .format(e, self.EPISODES, R, agent.epsilon, mean_score, env.state[0], env.state[1]))

            if mean_score > self.reward_need:
                print("episode: {}/{}, score: {}, e: {:.2}, mean_score: {}, final state :({},{})"
                      .format(e, self.EPISODES, R, agent.epsilon, mean_score, env.state[0], env.state[1]))
                agent.save_model(self.save_name)
                break

    def read_averages(self):
        self.lock.acquire()
        return_reward = copy.deepcopy(self.epi_reward_average)
        return_v = copy.deepcopy(self.epi_v_average)
        return_d = copy.deepcopy(self.epi_d_average)
        self.lock.release()
        return return_reward, return_v, return_d


class Testing(QtCore.QThread):
    def __init__(self):
        QtCore.QThread.__init__(self)

        self.SPACE_X = 4
        self.SPACE_Y = 3
        self.PERIOD= 1/30
        self.NUM_DIV_ACTION = 5
        self.INIT_TO_ZERO = True
        self.EPISODES = 2000
        self.state_size = 2
        self.action_size = 5 * 5
        self.v = []
        self.d = []


        self.lock = threading.Lock()

    def testing(self, load_name, x_trajectory, y_trajectory, closed=True):

        self.load_name = load_name
        self.x_trajectory=x_trajectory
        self.y_trajectory=y_trajectory
        self.closed=closed
        self.states=[]

        self.start()

    def run(self):
        if not self.closed:
            reward_need = (len(self.x_trajectory) // 50) * 5 + 15
            print("Reward if it finishes: {}".format(reward_need))
        scores = deque(maxlen=3)
        agent = Agent(self.state_size, self.action_size, gamma=0.99, epsilon=1, epsilon_min=0.01, epsilon_decay=0.92,
                      learning_rate=0.005, batch_size=64, tau=0.01)

        env = UgvEnv(self.x_trajectory, self.y_trajectory, self.PERIOD,
                     self.NUM_DIV_ACTION, closed=self.closed)
        agent.load_model(self.load_name)

        state, agent_state = env.reset()
        agent_state = agent.format_state(agent_state)
        done = False
        R = 0
        self.v = []
        self.d = []
        self.states.append(state)
        while not done:
            action = agent.action(agent_state, training=False)
            new_state, new_agent_state, reward, done = env.step(action)

            self.states.append(new_state)

            self.lock.acquire()
            self.v.append(env.v_linear)
            self.d.append(np.sqrt(env.distance ** 2))
            self.lock.release()

            new_agent_state = agent.format_state(new_agent_state)
            agent_state = new_agent_state
            R += reward
        scores.append(R)
        mean_score = np.mean(scores)
        mean_v = np.mean(self.v)
        mean_d = np.mean(self.d)
        print(
            "score: {}, laps: {:}, mean_score: {}, final state :({},{}), velocidad media: {}, Distancia media: {}"
            .format(R, env.laps, mean_score, env.state[0], env.state[1], mean_v, mean_d))




    def read_values(self):
        self.lock.acquire()
        return_v = copy.deepcopy(self.v)
        return_d = copy.deepcopy(self.d)
        self.lock.release()
        return return_v, return_d

