# -*- coding: utf-8 -*-
"""This module plot /blindtext

"""

import matplotlib.patches as ptch
import matplotlib.pyplot as plt
import time
import math


class PlotUgv:

    def __init__(self, x_limit, y_limit, x_trajectory, y_trajectory, period):

        self.fig, self.ax = plt.subplots()

        self.arrayX = []*500  # max_steps
        self.arrayY = []*500

        self.yellow_back_x = x_limit
        self.yellow_back_y = y_limit

        self.point, = self.ax.plot([], [], marker=(3, 0, 0), color='red')
        self.point2, = self.ax.plot([], [], 'r:')

        self.x_origin = -x_limit/2
        self.y_origin = -y_limit/2

        self.x_trajectory = x_trajectory
        self.y_trajectory = y_trajectory

        self.period = period

        self._begin()

    def _begin(self):

        self.ax.set_ylim(self.y_origin-0.5,
                         self.yellow_back_y + self.y_origin + 0.5)

        self.ax.set_xlim(self.x_origin - 0.5,
                         self.x_origin + self.yellow_back_x + 0.5)

        self.ax.set_facecolor('xkcd:black')

        rect2 = ptch.Rectangle((self.x_origin, self.y_origin),
                               self.yellow_back_x,
                               self.yellow_back_y, linewidth=2,
                               edgecolor='yellow', facecolor='none')

        self.ax.plot(self.x_trajectory, self.y_trajectory, 'tab:cyan',
                     linewidth=1.75,)

        self.ax.add_patch(rect2)

        #Christian wrote false in the plt.show argumant and it
        #it generated an error
        plt.show(block=False)
        plt.draw()
    def reset(self, state):

        self.x = state[0]
        self.y = state[1]
        self.arrayX = []
        self.arrayY = []
        self.point2.set_data(self.arrayX, self.arrayY)
        self.angle = state[2]
        self.point2, = self.ax.plot([], [], 'r:')
        self.execute(state)

    def execute(self, state):

        self.x = state[0]
        self.y = state[1]
        self.angle = state[2]
        plt.draw()
        self.fig.canvas.draw()

        self.point.set_xdata(self.x)
        self.point.set_ydata(self.y)

        self.point.set_marker((3, 0, math.degrees(self.angle)))

        time.sleep(self.period)

        self.arrayX.append(self.x)
        self.arrayY.append(self.y)

        self.point2.set_data(self.arrayX, self.arrayY)
        # self.theta = self.theta+20  # Check if is necessary


    def real_trayectory(self,x_array,y_array):
        self.ax.plot(x_array, y_array, 'tab:red',
                     linewidth=1.25, )
        self.fig.canvas.draw()
        plt.draw()
        plt.show()

if __name__ == "__main__":
    d = PlotUgv(3, 4, [-1.5, 0, 1.5], [-1.5, 0, 1.5], 1/30)
    d._begin()
    i = 0
    b = 0
    angle = 0
    d.reset([i,b,angle])
    while True:
        i = i+0.005

        b = b+0.01
        angle = 135
        d.execute([i+0.15, b, angle])
        if i == 10:
            break