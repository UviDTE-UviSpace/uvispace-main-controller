#!/usr/bin/env python
"""Module for implementing a Kalman filter.

The Kalman filter is a well-known algorithm for imrpoving the
localization of an object given measures of its position and a model of
its behaviour.
The algorithm is defined by two main equations, namely the state
equation, that predicts the state (position) of the object given the
previous one and the value of the input variables; and the measurement
equation, that stimates the value that a sensor should obtain, given the
state prediction.

Relevant documentation:
* http://www.bzarg.com/p/how-a-kalman-filter-works-in-pictures/
* http://www.cl.cam.ac.uk/~rmf25/papers
/Understanding%20the%20Basis%20of%20the%20Kalman%20Filter.pdf

* http://biorobotics.ri.cmu.edu/papers/sbp_papers/integrated3/
kleeman_kalman_basics.pdf
"""
# Third party libraries
import numpy as np

class Kalman(object):
    """Class for implementing a linear Kalman Filter."""

    def __init__(self, var_dim=3, input_dim=2):
        """Initialize the Kalman filter instance

        F is the prediction matrix
        B is the control matrix
        P is the state covariance matrix
        R is the measurement noise covariance matrix
        Q is the process noise covariance matrix
        """
        self._variables_dim = var_dim
        self._input_dim = input_dim
        # Measurement equation matrix.
        self.measurement = np.zeros([var_dim, 1])
        self.H = np.eye(var_dim)
        self.observation_noise = np.zeros([var_dim, 1])
        # Actual and predicted states vectors.
        self.state = np.zeros([var_dim, 1])
        self.pred_state = np.zeros([var_dim, 1])
        # State equation matrices.
        self.F = np.eye(var_dim)
        self.B = np.array([[np.cos(self.state[2]), 0], 
                           [np.sin(self.state[2]), 0],
                           [0, 1]])
        # Actual and predicted states covariance matrices.
        self.P = np.eye(var_dim) * np.array([100**2, 100**2, (5*np.pi/180)**2])
        self.pred_P = np.zeros([var_dim, var_dim])
        # State and Measurement noise covariance matrix.
        self.Q = np.eye(var_dim) * np.array([100**2, 100**2, (5*np.pi/180)**2])
        self.R = np.eye(var_dim) * np.array([100**2, 100**2, (5*np.pi/180)**2])
        # Kalman gain.
        self.K = np.zeros([var_dim, var_dim])

    def predict(self, ext_input, delta_t):
        """
        Estimate the new position given the external input vector.

        The function predicts the new position of the object, applying
        the input vector to the previous state.

        Hypothesis: The angular speed between two iterations does not
        affect on the new position (x,y) of the object, as the time is
        considered small enough between iterations.
        """
        self.B = delta_t * np.array([[np.cos(self.state[2,-1]), 0], 
                                     [np.sin(self.state[2,-1]), 0],
                                     [0, 1]])
        pred_state = np.dot(self.F, self.state[:,-1]) + np.dot(self.B, ext_input)
        self.pred_state = np.hstack((self.pred_state, pred_state))
        # Predict the new covariances matrix.
        self.pred_P = np.dot(np.dot(self.F, self.P), np.transpose(self.F))
        self.pred_P += self.Q
        return (pred_state, self.pred_P)

    def update(self, measurement):
        # Estimated value of the measurement and its error.
        pred_measure = np.dot(self.H, self.pred_state[:,-1])
        meas_error = measurement - pred_measure
        self.measurment = np.hstack((self.measurment, pred_measure))
        # Innovation (or residual) covariance
        S = np.dot(np.dot(self.H, self.pred_P), np.transpose(self.H)) + self.R
        S_inv = np.linalg.inv(S)
        # Calculate the Kalman gain (K).
        self.K = np.dot(np.dot(self.pred_P, np.transpose(self.H)), S_inv)
        import pdb; pdb.set_trace()
        # Get the updated state covariance matrix.
        self.P = self.pred_P - np.dot(np.dot(self.K, self.H), self.pred_P)
        state = self.pred_state[:,-1] + np.dot(self.K, meas_error)
        self.state = np.hstack((self.state, state))
        return (state, self.P)
