import numpy as np
import math

x_trajectory = np.append(np.linspace(0.2, 0.2, 41),
                                     np.cos(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.3)
y_trajectory = np.append(np.linspace(0.2, 0.4, 41),
                         np.sin(np.linspace(180 * np.pi / 180, 90 * np.pi / 180, 61)) * 0.1 + 0.4)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.3)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(270 * np.pi / 180, 360 * np.pi / 180, 81)) * 0.2 + 0.7)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.8)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(180 * np.pi / 180, -90 * np.pi / 180, 141)) * 0.3 + 0.7)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.8)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(90 * np.pi / 180, 180 * np.pi / 180, 61)) * 0.1 + 0.3)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.4)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(360 * np.pi / 180, 270 * np.pi / 180, 61)) * 0.3 + 0.3)
x_trajectory = np.append(x_trajectory,
                         np.cos(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.4)
y_trajectory = np.append(y_trajectory,
                         np.sin(np.linspace(270 * np.pi / 180, 180 * np.pi / 180, 81)) * 0.2 + 0.2)

l=[x_trajectory,y_trajectory]
datos = np.asarray(l)
np.savetxt("trajectory.csv",   # Archivo de salida
           datos.T,        # Trasponemos los datos
           fmt="%f",       # Usamos números enteros
           delimiter=";")  # Para que sea un CSV de verdad