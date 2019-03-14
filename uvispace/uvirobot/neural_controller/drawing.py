import matplotlib.patches as ptch
import matplotlib.pyplot as plt
import time
import math
import numpy as np


fig = plt.figure()
plt.axis([0, 1000, 0, 1])

i = 0
x = list()
y = list()

while i < 1000:
    temp_y = np.random.random()
    x.append(i)
    y.append(temp_y)
    plt.scatter(i, temp_y)
    i += 1
    plt.show()
    time.sleep(0.5)
    plt.close()
