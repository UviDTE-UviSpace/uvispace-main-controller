import numpy as np
import math

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
l=[x_trajectory,y_trajectory]
datos = np.asarray(l)
np.savetxt("training_differential.csv",   # Archivo de salida
           datos.T,        # Trasponemos los datos
           fmt="%f",       # Usamos números enteros
           delimiter=";")  # Para que sea un CSV de verdad