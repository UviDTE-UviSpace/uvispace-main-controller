# -*- coding: utf-8 -*-
import sys
sys.path.append('F:\\Javier\\Desktop\\TFM\\uvispace-main-controller')
import random
import numpy as np
from collections import deque
from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import Adam
from keras.models import load_model
from keras.initializers import  zeros
import  tensorflow as tf

from uvispace.uvirobot.neural_controller.environment import UgvEnv
import math

class Agent:
    def __init__(self,state_size,action_size, gamma=1, epsilon = 1.0, epsilon_min=0.01,epsilon_decay=0.995, learning_rate=0.001, batch_size=64, tau=0.1):
        #Define the parameter of the agent
        self.gamma=gamma
        self.epsilon=epsilon
        self.epsilon_min=epsilon_min
        self.epsilon_decay=epsilon_decay
        self.learning_rate=learning_rate
        self.state_size=state_size
        self.action_size=action_size
        self.batch_size=batch_size
        self.memory=deque(maxlen=100000)
        self.tau=tau
        self.model=self.build_network()
        self.session = tf.Session()
        self.graph = tf.get_default_graph()
        with self.graph.as_default():
            with self.session.as_default():
                self.target_model=self.build_network()
                self.target_model.set_weights(self.model.get_weights())


    def build_network(self):
        #create the neural network

        model=Sequential()
        model.add(Dense(30, input_dim = self.state_size, activation='relu'))
        model.add(Dense(30, activation='relu'))
        model.add(Dense(self.action_size, activation='linear'))
        model.compile(loss='mse', optimizer=Adam(self.learning_rate), metrics=['mae'])
        return model

    def remember(self,state, action, reward, next_state, done):
        #use it to remember and then replay
        with self.graph.as_default():
            with self.session.as_default():
                self.memory.append((state, action, reward, next_state, done))

    def action(self, state, training=True):
        with self.graph.as_default():
            with self.session.as_default():
                if training and np.random.random() < self.epsilon:
                    return random.randrange(self.action_size)
                else:
                    return np.argmax(self.model.predict(state)[0])

    def replay(self):
        with self.graph.as_default():
            with self.session.as_default():
                target_batch, state_batch = [], []
                batch=random.sample(self.memory,min(len(self.memory),self.batch_size))
                for state, action, reward, next_state, done in batch:
                    if done:
                        target = reward
                    else:
                        action_max=np.argmax(self.model.predict(next_state))

                        target=reward + self.gamma * self.target_model.predict(next_state)[0][action_max]
                    target_vec=self.model.predict(state)
                    target_vec[0][action] = target
                    target_batch.append(target_vec[0])
                    state_batch.append(state[0])
                # Instead of train in the for, I give all targets as array and give the batch size
                self.model.fit(np.array(state_batch), np.array(target_batch),batch_size=len(state_batch), epochs=1, verbose=0)


    def reduce_random(self):
        if self.epsilon > self.epsilon_min:
            self.epsilon*=self.epsilon_decay


    def training(self, state, action, reward, next_state, done):
        with self.graph.as_default():
            with self.session.as_default():
                if done:
                    target=reward
                else:
                    target=reward+self.gamma *np.amax(self.model.predict(next_state))
                target_vec = self.model.predict(state)
                target_vec[0][action] = target
                self.model.fit(state, target_vec, epochs=1,verbose=0)

    def format_state(self,state):
        return np.reshape(state[0:self.state_size], [1, self.state_size])

    def soft_update_target_network(self):
        with self.graph.as_default():
            with self.session.as_default():
                w_model=self.model.get_weights()
                w_target=self.target_model.get_weights()
                ctr = 0
                for wmodel, wtarget in zip(w_model, w_target):
                    wtarget = wtarget * (1 - self.tau) + wmodel * self.tau
                    w_target[ctr] = wtarget
                    ctr += 1

                self.target_model.set_weights(w_target)

    def save_model(self,name):
        with self.graph.as_default():
            with self.session.as_default():
                self.model.save(name)

    def load_model(self, name):
        with self.graph.as_default():
            with self.session.as_default():
                self.model=load_model(name)
                self.target_model.set_weights(self.model.get_weights())




if __name__ == "__main__":
    # Size of Uvispace area
    SPACE_X = 4
    SPACE_Y = 3
    # Sampling period (time between 2 images)
    PERIOD = (1 / 30)
    # Variable space quantization
    NUM_DIV_ACTION = 5
    # Init to zero?
    INIT_TO_ZERO = True
    # Number of episodes
    EPISODES = 15000
    # Define trajectory

    x_trajectory = np.linspace(0.2, 0.2, 121)
    y_trajectory = np.linspace(0.2, 1.2, 121)
    x_trajectory = np.append(np.linspace(0.2, 0.2, 41),np.cos(np.linspace(180*math.pi/180, 90*math.pi/180, 61))*0.1+0.3)
    y_trajectory = np.append(np.linspace(0.2, 0.4, 41),np.sin(np.linspace(180*math.pi/180, 90*math.pi/180, 61))*0.1+0.4)
    x_trajectory = np.append(x_trajectory,np.cos(np.linspace(270*math.pi/180, 360*math.pi/180, 81))*0.2+0.3)
    y_trajectory = np.append(y_trajectory,np.sin(np.linspace(270*math.pi/180, 360*math.pi/180, 81))*0.2+0.7)
    x_trajectory = np.append(x_trajectory,np.cos(np.linspace(180*math.pi/180, -90*math.pi/180, 141))*0.3+0.8)
    y_trajectory = np.append(y_trajectory,np.sin(np.linspace(180*math.pi/180, -90*math.pi/180, 141))*0.3+0.7)
    x_trajectory = np.append(x_trajectory,
                             np.cos(np.linspace(90 * math.pi / 180, 180 * math.pi / 180, 61)) * 0.1 + 0.8)
    y_trajectory = np.append(y_trajectory,
                             np.sin(np.linspace(90 * math.pi / 180, 180 * math.pi / 180, 61)) * 0.1 + 0.3)
    x_trajectory = np.append(x_trajectory,
                             np.cos(np.linspace(360 * math.pi / 180, 270 * math.pi / 180, 61)) * 0.3 + 0.4)
    y_trajectory = np.append(y_trajectory,
                             np.sin(np.linspace(360 * math.pi / 180, 270 * math.pi / 180, 61)) * 0.3 + 0.3)
    #x_trajectory = np.append(x_trajectory, np.linspace(1.1, 1.1, 101))
    #y_trajectory = np.append(y_trajectory, np.linspace(0.7, 0.2, 101))
    #x_trajectory = np.append(x_trajectory, np.cos(np.linspace(360*math.pi/180, 270*math.pi/180, 81))*0.2+0.9)
    #y_trajectory = np.append(y_trajectory, np.sin(np.linspace(360*math.pi/180, 270*math.pi/180, 81))*0.2+0.2)
    #x_trajectory = np.append(x_trajectory, np.linspace(0.9, 0.4, 141))
    #y_trajectory = np.append(y_trajectory, np.linspace(0.0, 0.0, 141))
    x_trajectory = np.append(x_trajectory,
                             np.cos(np.linspace(270 * math.pi / 180, 180 * math.pi / 180, 81)) * 0.2 + 0.4)
    y_trajectory = np.append(y_trajectory,
                             np.sin(np.linspace(270 * math.pi / 180, 180 * math.pi / 180, 81)) * 0.2 + 0.2)

    #Reward given if it completes an open circuit -5
    reward_need=(len(x_trajectory)//50)*5+20
    #print(reward_need)
    #print(x_trajectory)
    #print(y_trajectory)
#
    state_size = 2
    action_size=NUM_DIV_ACTION*NUM_DIV_ACTION

    scores = deque(maxlen=20)
    agent=Agent(state_size,action_size, gamma=0.99, epsilon = 1, epsilon_min=0.01,epsilon_decay=0.9995, learning_rate=0.001, batch_size=64, tau=0.1)
    env=UgvEnv(x_trajectory, y_trajectory, PERIOD,
                     NUM_DIV_ACTION)
    agent.load_model('fast-model.h5')

    #for e in range(EPISODES):
    #    state, agent_state=env.reset()
    #    agent_state=agent.format_state(agent_state)
    #    done=False
    #    R=0
#
    #    while not done:
    #        action = agent.action(agent_state)
    #        new_state, new_agent_state, reward, done =env.step(action)
    #        new_agent_state = agent.format_state(new_agent_state)
    #        agent.remember(agent_state, action, reward, new_agent_state, done)
#
#
    #        agent_state=new_agent_state
    #        R+=reward
#
    #    if len(agent.memory)>agent.batch_size:
    #        agent.replay()
    #        agent.soft_update_target_network()
    #    agent.reduce_random()
    #    scores.append(R)
    #    mean_score = np.mean(scores)
    #    print("episode: {}/{}, score: {}, e: {:.2}, mean_score: {}, final state :({},{})"
    #              .format(e, EPISODES, R, agent.epsilon, mean_score,env.state[0],env.state[1]))
#
    #    if mean_score > 275:
    #        agent.save_model('fast-model.h5')
    #        break
#
    for e in range(EPISODES):
        state, agent_state=env.reset()
        agent_state=agent.format_state(agent_state)
        done=False
        R=0
        v=deque()

        while not done:
            action = np.argmax(agent.model.predict(agent_state))
            new_state, new_agent_state, reward, done =env.step(action)
            new_agent_state = agent.format_state(new_agent_state)

            agent_state=new_agent_state
            R+=reward
            v.append(env.v_linear)

        scores.append(R)
        mean_score = np.mean(scores)
        mean_v=np.mean(v)
        print("episode: {}/{}, score: {}, laps: {:}, mean_score: {}, final state :({},{}), velocidad media: {}"
                  .format(e, EPISODES, R, env.laps, mean_score,env.state[0],env.state[1],mean_v))