#!/usr/bin/env python
"""Executable module for simulating the Kalman filter class"""
# Standard libraries
import sys
# Third party libraries
import matplotlib.pyplot as plt
import numpy as np
#Local libraries
import uvisensor.kalmanfilter as kalmanfilter

try:
    # Logging setup.
    import settings
except ImportError:
    # Exit program if the settings module can't be found.
    sys.exit("Can't find settings module. Maybe environment variables are not"
             "set. Run the environment .sh script at the project root folder.")

def main():
    """ 
    Hypothesis: On each time step:
    * The vehicle advances 10mm on the X axis
    * The Y axis follows the quadratic function y = ax**2
    * The pose is the first derivative of the previous function
    """
    # Set the simulation parameters:
    # time between samples: 20ms=0.02s
    # number of samples: 20
    # vehicle speed: linear=100mm/s, angular=1rad/s
    # initial pose to X=0mm, Y=0mm and theta=0rad.
    time_step = 0.02
    steps = 20
    linear = 100
    angular = 1
    u = np.array([linear, angular]).reshape(2,1)
    real_poses = np.array([0, 0, 0]).reshape([3, 1])
    ideal_poses = np.array([0, 0, 0]).reshape([3, 1])
    pose_noise = np.zeros([3,1])
    # Kalman filter object
    kalman = kalmanfilter.Kalman()
    Q = np.eye(3) * np.array([100**2, 100**2, (5*np.pi/180)**2])
    R = np.eye(3) * np.array([100**2, 100**2, (5*np.pi/180)**2])
    kalman.set_prediction_noise(Q)
    kalman.set_measurement_noise(R)
    estimates = np.array([0, 0, 0]).reshape(3,1)
    measurements = np.array([0, 0, 0]).reshape(3,1)
    filtered_values = np.array([0, 0, 0]).reshape(3,1)
    # Plot markers
    markers = []
    for step in range(steps):
        # Calculate the new pose
        x_i = ideal_poses[0, -1] + time_step*linear*np.cos(ideal_poses[2,-1])
        x = real_poses[0, -1] + time_step*linear*np.cos(real_poses[2,-1])
        y_i = ideal_poses[1, -1] + time_step*linear*np.sin(ideal_poses[2,-1])
        y = real_poses[1, -1] + time_step*linear*np.sin(real_poses[2,-1])
        theta_i = ideal_poses[2,-1] + time_step*angular
        theta = real_poses[2,-1] + time_step*angular
        # Execute the first stage of the kalman filter.
        estimated, _ = kalman.predict(u, time_step)
        estimates = np.hstack([estimates, estimated])
        # Build the vector of the new_pose
        new_ideal_pose = np.array([x_i, y_i, theta_i]).reshape([3, 1])
        new_pose = np.array([x, y, theta]).reshape([3, 1])
        pose_noise[0:2] = np.random.normal(0,.2,(2,1))
        pose_noise[2] = np.random.normal(0, .05)
        noisy_pose = new_pose + pose_noise
        ideal_poses = np.hstack([ideal_poses, new_ideal_pose])
        real_poses = np.hstack([real_poses, noisy_pose])
        # Kalman second stage
        measurement = noisy_pose + np.random.normal(0,.2,(3,1))
        measurements = np.hstack([measurements, measurement])
        filtered, _ = kalman.update(measurement)
        filtered_values = np.hstack([filtered_values, filtered])
        # Build plot markers
        marker = (3, 0, -90 + noisy_pose[2]*180/np.pi)
        marker_s = (3, 0, -90 + estimated[2]*180/np.pi)
        marker_m = (3, 0, -90 + measurement[2]*180/np.pi)
        marker_f = (3, 0, -90 + filtered[2]*180/np.pi)
        # Plot the values
        plt.plot(noisy_pose[0], noisy_pose[1], marker=marker, markersize=12, 
                 color='red')
        plt.plot(estimated[0], estimated[1], marker=marker, markersize=12, 
                 color='green')
        plt.plot(measurement[0], measurement[1], marker=marker, markersize=12, 
                 color='blue')
        plt.plot(filtered[0], filtered[1], marker=marker, markersize=12, 
                 color='yellow')
    # Plot the result
    # plt.plot(real_poses[0], real_poses[1], marker=markers, 
    #          markersize=12, color='red')
    plt.plot(ideal_poses[0], ideal_poses[1])
    plt.xlabel('X axis (mm)')
    plt.ylabel('Y axis (mm)')
    plt.title('Simulated Kalman filter')
    plt.grid(True)
    plt.show()
    return real_poses

if __name__ == '__main__':
    poses = main()
