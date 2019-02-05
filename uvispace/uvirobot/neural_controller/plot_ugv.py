# -*- coding: utf-8 -*-
"""This module plot /blindtext

"""

import matplotlib.patches as ptch
import matplotlib.pyplot as plt
import time


class PlotUgv:

    def __init__(self, x_limit, y_limit, x_trajectory, y_trajectory, period):

        self.fig, self.ax = plt.subplots()
        self.arrayX = []*500  # max_steps
        self.arrayY = []*500
        self.yellow_back_x = x_limit
        self.yellow_back_y = y_limit
        self.point, = self.ax.plot([], [], marker=(3, 0, 0), color='red')
        self.point2, = self.ax.plot([], [], 'r:')
        self.x_origin = 0
        self.y_origin = 0
        self.x_trajectory = x_trajectory
        self.y_trajectory = y_trajectory
        self._begin()
        self.period = period

    def _begin(self):

        self.ax.set_ylim(self.y_origin-0.5,
                         self.yellow_back_y + self.y_origin+0.5)

        self.ax.set_xlim(self.x_origin-0.5,
                         self.x_origin+self.yellow_back_x+0.5)

        self.ax.set_facecolor('xkcd:black')

        rect2 = ptch.Rectangle((self.x_origin, self.y_origin),
                               self.yellow_back_x,
                               self.yellow_back_y, linewidth=2,
                               edgecolor='yellow', facecolor='none')

        self.ax.plot(self.x_trajectory, self.y_trajectory, 'tab:cyan',
                     linewidth=1.75,)

        self.ax.add_patch(rect2)

        plt.show(False)
        plt.draw()

    def reset(self, x, y, angle):

        self.point2, = self.ax.plot([], [], 'r:')
        self.execute(x, y, angle)

    def execute(self, x, y, angle):

        self.fig.canvas.draw()
        self.point.set_xdata(x)
        self.point.set_ydata(y)
        self.point.set_marker((3, 0, angle))

        time.sleep(self.period)

        self.arrayX.append(x)
        self.arrayY.append(y)
        self.point2.set_data(self.arrayX, self.arrayY)
        # self.theta = self.theta+20  # Check if is necessary


d = PlotUgv(3, 4, [1, 2, 2.5], [1, 2, 2.5], 1/30)
d._begin()
i = 0
b = 0
angle = 0
while True:
    i = i+0.005

    b = b+0.01
    angle = 135
    d.execute(i+0.15, b, angle)
    if i == 10:
        break
