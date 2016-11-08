#!/usr/bin/env python
#Standard libraries
import matplotlib.path as mpath
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import host_subplot

def format_plotting():
    plt.rcParams['figure.figsize'] = (10, 8)
    plt.rcParams['font.size'] = 30
    plt.rcParams['font.family'] = 'Times New Roman'
    plt.rcParams['axes.labelsize'] = plt.rcParams['font.size']
    plt.rcParams['axes.titlesize'] = 1.2*plt.rcParams['font.size']
    plt.rcParams['legend.fontsize'] = 0.7 * plt.rcParams['font.size']
    plt.rcParams['xtick.labelsize'] = 0.8*plt.rcParams['font.size']
    plt.rcParams['ytick.labelsize'] = 0.8*plt.rcParams['font.size']
    plt.rcParams['savefig.dpi'] = 1000
    plt.rcParams['savefig.format'] = 'eps'
    plt.rcParams['xtick.major.size'] = 3
    plt.rcParams['xtick.minor.size'] = 3
    plt.rcParams['xtick.major.width'] = 1
    plt.rcParams['xtick.minor.width'] = 1
    plt.rcParams['ytick.major.size'] = 3
    plt.rcParams['ytick.minor.size'] = 3
    plt.rcParams['ytick.major.width'] = 1
    plt.rcParams['ytick.minor.width'] = 1
    plt.rcParams['legend.frameon'] = False
    plt.rcParams['legend.loc'] = 'lower left'
    plt.rcParams['axes.linewidth'] = 1
    plt.rcParams['lines.linewidth'] = 5

    plt.gca().spines['right'].set_color('none')
    plt.gca().spines['top'].set_color('none')
    plt.gca().xaxis.set_ticks_position('bottom')
    plt.gca().yaxis.set_ticks_position('left')   

def plot(input_path, real_route):
    """Drawing on a figure the desired and real paths."""
    x1, y1 = input_path[:,0], input_path[:,1]
    x2, y2 = real_route[:,0], real_route[:,1]
    #Draws the figure
    format_plotting()
    ax = plt.subplot(111)
    line1, = ax.plot(x1, y1, 'bo-')
    line2, = ax.plot(x2, y2, 'ro-')    
    ax.grid()
    ax.axis('equal')
    ax.set_xlim([-2, 2])
    ax.set_ylim([-2, 2])
    ax.set_xlabel('X Axis')    
    ax.set_ylabel('Y Axis')
    plt.show()


if __name__ == "__main__":
    import numpy as np
    test_path = np.array(
          [[ 0.0,  0.0],
           [ 0.1,  0.1],
           [ 0.1,  0.2],
           [ 0.1,  0.3],
           [ 0.2,  0.5],
           [ 0.4,  0.6]])
    test_route = np.array(
          [[ 0.0,  0.0],
           [ 0.0,  -0.1],
           [ 0.1,  0.0],
           [ 0.4,  0.5],
           [ 0.5,  0.6],
           [ 0.8,  0.7],
           [ 1.0,  0.0],
           [ 0.7,  -0.6],
           [ 2.0,  -1.6]])
    plot(test_path, test_route)



