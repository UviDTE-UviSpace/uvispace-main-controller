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


##DIFF INFINITE
x_trajectory = np.append(np.cos(np.linspace(180 * np.pi / 180, 0.01 * np.pi / 180, 20)) * 0.5 - 0,
                                     np.cos(np.linspace(180 * np.pi / 180, 539.99 * np.pi / 180, 80)) * 0.4 + 0.9)
y_trajectory = np.append(np.sin(np.linspace(180 * np.pi / 180,0.01 * np.pi / 180, 20)) * 0.5 + 0.75,
                         np.sin(np.linspace(180 * np.pi / 180, 539.99 * np.pi / 180, 80)) * 0.5 + 0.75)
x_trajectory = np.append(x_trajectory,np.cos(np.linspace(360 * np.pi / 180, 180 * np.pi / 180, 20)) * 0.5 - 0)
y_trajectory = np.append(y_trajectory, np.sin(np.linspace(360 * np.pi / 180, 180 * np.pi / 180, 20)) * 0.5 + 0.75)

##DIFF_CURVE
x_trajectory = np.append(np.linspace(0.3, 0.3, 10), np.cos(np.linspace(180.01 * np.pi / 180, 89.99 * np.pi / 180, 20)) * 0.2  + 0.5)
y_trajectory = np.append(np.linspace(0.2, 0.5, 10), np.sin(np.linspace(180.01 * np.pi / 180, 89.99 * np.pi / 180, 20)) * 0.2 + 0.5)
x_trajectory = np.append(x_trajectory,np.linspace(0.5, 1, 20))
y_trajectory = np.append(y_trajectory, np.linspace(0.7, 0.7, 20))


##ACK U
x_trajectory=np.cos(np.linspace(180 * np.pi / 180, 0 * np.pi / 180, 180)) * 0.7 + 0.9
y_trajectory=np.sin(np.linspace(180 * np.pi / 180,0 * np.pi / 180, 180)) * 0.7 + 0.3


#ACK_SHOW

x_trajectory = np.append(np.linspace(0.5, -0.5 , 200), np.cos(np.linspace(90.001 * np.pi / 180,179.99 * np.pi / 180, 90)) * 0.7 - 0.5)
y_trajectory = np.append(np.linspace(1,1, 200),
                         np.sin(np.linspace(90.001 * np.pi / 180, 179.99 * np.pi / 180, 90)) * 0.7 + 0.3)
x_trajectory = np.append(x_trajectory,np.linspace(-1.2, -1.2, 120))
y_trajectory = np.append(y_trajectory, np.linspace(0.3, -0.3, 120))
x_trajectory = np.append(x_trajectory,np.cos(np.linspace(180.01 * np.pi / 180, 269.99 * np.pi / 180, 90)) * 0.7  -0.5)
y_trajectory = np.append(y_trajectory, np.sin(np.linspace(180.01 * np.pi / 180, 269.99 * np.pi / 180, 90)) * 0.7 - 0.3)
x_trajectory = np.append(x_trajectory,np.linspace(-0.5, 0.5, 200))
y_trajectory = np.append(y_trajectory, np.linspace(-1, -1, 200))
x_trajectory = np.append(x_trajectory,np.cos(np.linspace(270.01 * np.pi / 180, 359.99 * np.pi / 180, 90)) * 0.7  + 0.5)
y_trajectory = np.append(y_trajectory, np.sin(np.linspace(270.01 * np.pi / 180, 359.99 * np.pi / 180, 90)) * 0.7 - 0.3)
x_trajectory = np.append(x_trajectory,np.linspace(1.2, 1.2, 120))
y_trajectory = np.append(y_trajectory, np.linspace(-0.3, 0.3, 120))
x_trajectory = np.append(x_trajectory,np.cos(np.linspace(0.01 * np.pi / 180, 89.99 * np.pi / 180, 90)) * 0.7  + 0.5)
y_trajectory = np.append(y_trajectory, np.sin(np.linspace(0.01 * np.pi / 180, 89.99 * np.pi / 180, 90)) * 0.7 + 0.3)

x_trajectory = np.append(np.linspace(0.3, 0.3, 10), np.cos(np.linspace(180.01 * np.pi / 180, 89.99 * np.pi / 180, 20)) * 0.2  + 0.5)
y_trajectory = np.append(np.linspace(0.2, 0.5, 10), np.sin(np.linspace(180.01 * np.pi / 180, 89.99 * np.pi / 180, 20)) * 0.2 + 0.5)
x_trajectory = np.append(x_trajectory,np.linspace(0.5, 1, 20))
y_trajectory = np.append(y_trajectory, np.linspace(0.7, 0.7, 20))

x_trajectory = np.append(np.cos(np.linspace(180 * np.pi / 180, 0.01 * np.pi / 180, 20)) * 0.5 - 0,
                                     np.cos(np.linspace(180 * np.pi / 180, 539.99 * np.pi / 180, 80)) * 0.4 + 0.9)
y_trajectory = np.append(np.sin(np.linspace(180 * np.pi / 180,0.01 * np.pi / 180, 20)) * 0.5 + 0.75,
                         np.sin(np.linspace(180 * np.pi / 180, 539.99 * np.pi / 180, 80)) * 0.5 + 0.75)
x_trajectory = np.append(x_trajectory,np.cos(np.linspace(360 * np.pi / 180, 180 * np.pi / 180, 20)) * 0.5 - 0)
y_trajectory = np.append(y_trajectory, np.sin(np.linspace(360 * np.pi / 180, 180 * np.pi / 180, 20)) * 0.5 + 0.75)



l=[x_trajectory,y_trajectory]
datos = np.asarray(l)
np.savetxt("DIFF_8.csv",   # Archivo de salida
           datos.T,        # Trasponemos los datos
           fmt="%f",       # Usamos números enteros
           delimiter=";")  # Para que sea un CSV de verdad