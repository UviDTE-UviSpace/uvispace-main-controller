#!/usr/bin/env python
"""Module that allow the UGV choose the right speed.

It contains a class *FuzzyController*, that represents a controller type
(as its name indicates, the fuzzy controller).
"""
# Standard libraries
import ast
import ConfigParser
import glob
# Third party libraries
import numpy as np

class FuzzyController(object):
    """This class contains methods to choose the right speed for UGV.

    """
    def __init__(self, input_fs_1, input_fs_2, input_singleton):
        # Load the config file and read the fuzzy sets (fs) and singleton sets.
        self._conf_file = glob.glob("./resources/config/fuzzysets.cfg")
        self._conf_raw = ConfigParser.RawConfigParser()
        self._conf_raw.read(self._conf_file)
        self._fuzzysets_1 = self.get_set_array('Fuzzy_sets', input_fs_1)
        self._fuzzysets_2 = self.get_set_array('Fuzzy_sets', input_fs_2)
        self._singleton = self.get_set_array('Singletons', input_singleton)

    def get_set_array(self, section, item):
        """Read set of a file and store them into array.

        :param str section: name of the section to be read in the configuration
         file.
        :param str item: name of the item to be read in the configuration file.
        :return: set converted into array.
        :rtype: numpy.array float64
        """
        raw_set = self._conf_raw.get(section, item)
        # Format the value in order to get an array.
        tuple_format = ','.join(raw_set.split('\n'))
        array_format = ast.literal_eval(tuple_format)
        set_read = np.array(array_format)
        return set_read

    def fuzzyfication(self, input_value, input_set):
        """Fuzzify all input values into fuzzy membership functions.

        :param float input_value: input_value in fuzzy sets.
        :param int input_set: value for choose fuzzysets_1 or
         fuzzysets_2
        :returns: [set_index_array, m_degree_array]
          * *set_index_array* array with the indexes of the sets to
            which the input values correspond.
          * *m_degree_array* array with the degree of membership of the
            input value in the sets.
        :rtype: [float64 (shape=2), float64 (shape=2)]
        """
        if input_set == 1:
            sets = self._fuzzysets_1
        else:
            sets = self._fuzzysets_2
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

    def defuzzyfication(self, set_index, m_degree):
        """Obtain output using the weighted average method.

        :param set_index: Array of floats64 with indexes of sets.
        :type set_index: numpy.array float64 (shape=4).
        :param m_degree: Array of floats64 with grade of membership of
         the input value in the sets.
        :type m_degree: numpy.array float64 (shape=4).
        :return: output value of speed.
        :rtype: float
        """
        weight_array = np.array([min([m_degree[0], m_degree[2]]),
                                 min([m_degree[0], m_degree[3]]),
                                 min([m_degree[1], m_degree[2]]),
                                 min([m_degree[1], m_degree[3]])])
        singletons_array = np.array([self._singleton[set_index[0],
                                     set_index[2]],
                                     self._singleton[set_index[0],
                                     set_index[3]],
                                     self._singleton[set_index[1],
                                     set_index[2]],
                                     self._singleton[set_index[1],
                                     set_index[3]]])
        # Calculate the weighted arithmetic mean.
        if weight_array.sum(axis=0) == 0:
            # Consider zero denominator in division.
            output = 0
        else:
            output = (np.dot(weight_array, singletons_array) /
                      weight_array.sum(axis=0))
        return output
