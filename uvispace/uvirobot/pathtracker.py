#!/usr/bin/env python
"""Module that allow the UGV choose the right speed.

It contains a class *FuzzyController*, that represents a controller type
(as its name indicates, the fuzzy controller).
"""
# Third party libraries
import numpy as np

class FuzzyController(object):
    """This class contains methods to choose the right speed for UGV.

    """
    def __init__(self):
        pass

    def fuzzyfication(self, input_value, sets):
        """Fuzzify all input values into fuzzy membership functions.

        :param float input_value: input_value in fuzzy sets.
        :param float sets: fuzzy sets.
        :returns: [set_index_array, m_degree_array]
          * *set_index_array* array with the indexes of the sets to
            which the input values correspond.
          * *m_degree_array* array with the degree of membership of the
            input value in the sets.
        :rtype: [float64 (shape=2), float64 (shape=2)]
        """
        # Convert input_value and sets to range (-1, 1).
        max_input_value = max([np.abs(sets.max()),np.abs(sets.min())])
        work_value = input_value / max_input_value
        work_sets = sets / max_input_value
        # Check that the value belongs to some set, that will be called set1.
        set1_membership = np.greater_equal(work_value, work_sets[:, 0])
        if np.any(set1_membership == True):
            # Index of set1.
            set1_index = (np.where(set1_membership == True)[0]).max()
            set1 = work_sets[set1_index]
            # Zone of set1.
            set1_zone = np.greater_equal(work_value, set1)
            set1_zone_index = (np.where(set1_zone == True)[0]).max()
            # Obtain the degree of membership to the set1.
            if set1_zone_index == 0:
                set1_m_degree = ((work_value - set1[0]) / (set1[1] - set1[0]))
            elif set1_zone_index == 1:
                set1_m_degree = 1
            else:
                set1_m_degree = 0
        else:
            set1_index = 0
            set1_m_degree = 0
        # Check that the value belongs to some set, that will be called set2.
        set2_membership = np.less_equal(work_value, work_sets[:, 3])
        if set1_m_degree == 1 or (np.all(set2_membership == False)):
            set2_index = 0
            set2_m_degree = 0
        else:
            # Index of set2.
            set2_index = (np.where(set2_membership == True)[0]).min()
            set2 = work_sets[set2_index]
            # Zone of set2.
            set2_zone = np.less_equal(work_value, set2)
            set2_zone_index = (np.where(set2_zone == True)[0]).min()
            # Obtain the degree of membership to the set2.
            if set2_zone_index == 3:
                set2_m_degree = ((set2[3] - work_value) / (set2[3] - set2[2]))
            elif set2_zone_index == 2:
                set2_m_degree = 1
            else:
                set2_m_degree = 0
        set_index_array = np.array([set1_index, set2_index])
        m_degree_array = np.array([set1_m_degree, set2_m_degree])
        return set_index_array, m_degree_array

    def defuzzyfication(self, set_index, m_degree, singletons):
        """Obtain output using the weighted average method.

        :param set_index: Array of floats64 with indexes of sets.
        :type set_index: numpy.array float64 (shape=4).
        :param m_degree: Array of floats64 with grade of membership of
         the input value in the sets.
        :type m_degree: numpy.array float64 (shape=4).
        :param singletons: Array of floats64 with singletons set.
        :type singletons: numpy.array float64 (shape=MxN).
        :return: output value of speed.
        :rtype: float
        """
        weight_array = np.array([min([m_degree[0], m_degree[2]]),
                                 min([m_degree[0], m_degree[3]]),
                                 min([m_degree[1], m_degree[2]]),
                                 min([m_degree[1], m_degree[3]])])
        singletons_array = np.array([singletons[set_index[0], set_index[2]],
                                     singletons[set_index[0], set_index[3]],
                                     singletons[set_index[1], set_index[2]],
                                     singletons[set_index[1], set_index[3]]])
        # Calculate the weighted arithmetic mean.
        if weight_array.sum(axis=0) == 0:
            # Consider zero denominator in division.
            output = 0
        else:
            output = (np.dot(weight_array, singletons_array) /
                      weight_array.sum(axis=0))
        return output
