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

        * F is the prediction matrix
        * B is the control matrix
        * P is the state covariance matrix
        * R is the measurement noise covariance matrix
        * Q is the process noise covariance matrix
        * K is the Kalman gain. The bigger it is, the more importance is
        given to the measurement, and less to the prediction.
        """
        self._variables_dim = var_dim
        self._input_dim = input_dim
        self._step = 0
        # Measurement equation matrix.
        self.measurements = np.zeros([var_dim, 1])
        self._H = np.eye(var_dim)
        self.observation_noise = np.zeros([var_dim, 1])
        # Actual and predicted states vectors.
        self.states = np.zeros([var_dim, 1])
        self.pred_states = np.zeros([var_dim, 1])
        # State equation matrices.
        self._F = np.eye(var_dim)
        self.B = np.array([[np.cos(self.states[2]), 0], 
                           [np.sin(self.states[2]), 0],
                           [0, 1]])
        # Actual and predicted states covariance matrices.
        self._P = np.eye(var_dim) * np.array([100**2, 100**2, (5*np.pi/180)**2])
        self._pred_P = np.zeros([var_dim, var_dim])
        # State and Measurement noise covariance matrix.
        self._Q = np.eye(var_dim) * np.array([100**2, 100**2, (5*np.pi/180)**2])
        self._R = np.eye(var_dim) * np.array([100**2, 100**2, (5*np.pi/180)**2])
        # Kalman gain.
        self._K = np.ones([var_dim, var_dim])

    def set_prediction_noise(self, noise):
        """Set the prediction noise matrix to the given values

        A bigger estimation or prediction noise will make the Kalman
        filter to diminish the weight of the state prediction on the
        final result.

        If the noise is uncorrelated, the input can be a tuple or list,
        and the output will be a diagonal matrix with the given values.

        Note that the input dimensions must coincide with the dimensions
        of the system state variables.
        """
        # Routine for a list or tuple input, that results on a diagonal matrix.
        if type(noise) in (list, tuple):
            if len(noise) != self._variables_dim:
                raise ValueError("noise length is different to variables dim")
            # Set the noise diagonal to the given values.
            self._Q = np.eye(self._variables_dim) * noise
        # Routine for an array input, that results on an identical noise array.
        # Note that the input array must be square.
        elif type(noise) is np.ndarray:
            if any(length != self._variables_dim for length in noise.shape):
                raise ValueError("one dimension is different to variables dim")
            # Set the noise matrix to the given matrix.
            self._Q = noise
        else:
            raise ValueError("Input must be an array, tuple or list")
        return self._Q

    def set_measurement_noise(self, noise):
        """Set the measurement noise matrix to the given values

        A bigger measurement noise will make the Kalman filter to
        diminish the weight of the state measurement given by the system
        sensors.

        If the noise is uncorrelated, the input can be a tuple or list,
        and the output will be a diagonal matrix with the given values.

        Note that the input dimensions must coincide with the dimensions
        of the system state variables.
        """
        # Routine for a list or tuple input, that results on a diagonal matrix.
        if type(noise) in (list, tuple):
            if len(noise) != self._variables_dim:
                raise ValueError("noise length is different to variables dim")
            # Set the noise diagonal to the given values.
            self._R = np.eye(self._variables_dim) * noise
        # Routine for an array input, that results on an identical noise array.
        # Note that the input array must be square.
        elif type(noise) is np.ndarray:
            if any(length != self._variables_dim for length in noise.shape):
                raise ValueError("one dimension is different to variables dim")
            # Set the noise matrix to the given matrix.
            self._R = noise
        else:
            raise ValueError("Input must be an array, tuple or list")
        return self._R

    def predict(self, ext_input, delta_t):
        """
        Estimate the new position given the external input vector.

        The function predicts the new position of the object, applying
        the input vector to the previous state.

        Hypothesis: The angular speed between two iterations does not
        affect on the new position (x,y) of the object, as the time is
        considered small enough between iterations.
        """
        self.B = delta_t * np.array([[np.cos(self.states[2,-1]), 0], 
                                     [np.sin(self.states[2,-1]), 0],
                                     [0, 1]])
        # The array has to be reshaped in order to obtain a column vector.
        previous_state = self.states[:,-1].reshape([self._variables_dim,1])
        pred_state = np.dot(self._F, previous_state) + np.dot(self.B, ext_input)
        self.pred_states = np.hstack((self.pred_states, pred_state))
        # Predict the new covariances matrix.
        self._pred_P = np.dot(np.dot(self._F, self._P), np.transpose(self._F))
        self._pred_P += self._Q
        return (pred_state, self._pred_P)

    def update(self, measurement):
        # Estimated value of the measurement and its error.
        pred_state = self.pred_states[:,-1].reshape([self._variables_dim,1])
        pred_measure = np.dot(self._H, pred_state)
        meas_error = measurement - pred_measure
        self.measurements = np.hstack((self.measurements, measurement))
        # Innovation (or residual) covariance
        S = np.dot(np.dot(self._H, self._pred_P), 
                   np.transpose(self._H)) + self._R
        S_inv = np.linalg.inv(S)
        # Calculate the Kalman gain (K).
        self._K = np.dot(np.dot(self._pred_P, np.transpose(self._H)), S_inv)
        # Get the updated state covariance matrix.
        self._P = self._pred_P - np.dot(np.dot(self._K, self._H), self._pred_P)
        state = pred_state + np.dot(self._K, meas_error)
        self.states = np.hstack((self.states, state))
        return (state, self._P)
