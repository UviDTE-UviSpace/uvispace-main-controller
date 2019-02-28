# -*- coding: utf-8 -*-
import random
import numpy as np
from collections import deque
from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import Adam
from keras.models import load_model

from plot_ugv import PlotUgv
from environment import UgvEnv
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
        self.target_model=self.build_network()
        self.target_model.set_weights(self.model.get_weights())


    def build_network(self):
        #create the neural network
        FILE_NAME = "ann-weights.h5"
        model=Sequential()
        model.add(Dense(64, input_dim = self.state_size, activation='relu'))
        model.add(Dense(64, activation='relu'))
        model.add(Dense(self.action_size, activation='linear'))
        model.compile(loss='mse', optimizer=Adam(self.learning_rate), metrics=['mae'])
        return model

    def remember(self,state, action, reward, next_state, done):
        #use it to remember and then replay
        self.memory.append((state, action, reward, next_state, done))

    def action(self, state):
        if np.random.random() < self.epsilon:
            return random.randrange(self.action_size)
        else:
            return np.argmax(self.model.predict(state)[0])

    def replay(self):
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
        if done:
            target=reward
        else:
            target=reward+self.gamma *np.amax(self.model.predict(next_state))
        target_vec = self.model.predict(state)
        target_vec[0][action] = target
        self.model.fit(state, target_vec, epochs=1,verbose=0)

    def format_state(self,state):
        return np.reshape(state[0:self.state_size], [1, self.state_size])

    def save_network(self):
        self.model.save_weights("ann-weights.h5")

    def soft_update_target_network(self):
        w_model=self.model.get_weights()
        w_target=self.target_model.get_weights()
        ctr = 0
        for wmodel, wtarget in zip(w_model, w_target):
            wtarget = wtarget * (1 - self.tau) + wmodel * self.tau
            w_target[ctr] = wtarget
            ctr += 1

        self.target_model.set_weights(w_target)

    def save_model(self):
        self.model.save('model.h5')

    def load_model(self):
        self.model=load_model('model.h5')
        self.target_model.set_weights(self.model.get_weights())




if __name__ == "__main__":
    # Size of Uvispace area
    SPACE_X = 4
    SPACE_Y = 3
    # Sampling period (time between 2 images)
    PERIOD = (1 / 30)
    # Variable space quantization
    NUM_DIV_STATE = 5
    NUM_DIV_ACTION = 5
    # Init to zero?
    INIT_TO_ZERO = True
    # Number of episodes
    EPISODES = 1500
    # Define trajectory


    x_trajectory = np.append(np.linspace(0.2, 0.2, 121),np.cos(np.linspace(180*math.pi/180, 90*math.pi/180, 121))*0.4+0.6)
    y_trajectory = np.append(np.linspace(0.2, 0.8, 121),np.sin(np.linspace(180*math.pi/180, 90*math.pi/180, 121))*0.4+0.8)

    state_size = 2
    action_size=NUM_DIV_ACTION*NUM_DIV_ACTION

    scores = deque(maxlen=20)
    agent=Agent(state_size,action_size, gamma=0.99, epsilon = 0.4, epsilon_min=0.01,epsilon_decay=0.993, learning_rate=0.001, batch_size=64, tau=0.1)
    plot_ugv = PlotUgv(SPACE_X, SPACE_Y, x_trajectory, y_trajectory, PERIOD)
    env=UgvEnv(x_trajectory, y_trajectory, PERIOD, NUM_DIV_STATE,
                     NUM_DIV_ACTION)
    agent.load_model()

    for e in range(EPISODES):
        state, agent_state=env.reset()
        agent_state=agent.format_state(agent_state)
        done=False
        R=0
#
        while not done:
            action = agent.action(agent_state)
            new_state, new_agent_state, reward, done =env.step(action)
            new_agent_state = agent.format_state(new_agent_state)
            agent.remember(agent_state, action, reward, new_agent_state, done)
#
#
            agent_state=new_agent_state
            R+=reward
#
        if len(agent.memory)>agent.batch_size:
            agent.replay()
            agent.soft_update_target_network()
        agent.reduce_random()
        scores.append(R)
        mean_score = np.mean(scores)
        print("episode: {}/{}, score: {}, e: {:.2}, mean_score: {}, final state :({},{})"
                  .format(e, EPISODES, R, agent.epsilon, mean_score,env.state[0],env.state[1]))
#
        if mean_score > 20:
            agent.save_model()
            break

    #for e in range(EPISODES):
    #    state, agent_state=env.reset()
    #    agent_state=agent.format_state(agent_state)
    #    done=False
    #    R=0
#
    #    while not done:
    #        action = np.argmax(agent.model.predict(agent_state))
    #        new_state, new_agent_state, reward, done =env.step(action)
    #        new_agent_state = agent.format_state(new_agent_state)
#
    #        agent_state=new_agent_state
    #        R+=reward
#
    #    scores.append(R)
    #    mean_score = np.mean(scores)
    #    print("episode: {}/{}, score: {}, e: {:.2}, mean_score: {}, final state :({},{})"
    #              .format(e, EPISODES, R, agent.epsilon, mean_score,env.state[0],env.state[1]))