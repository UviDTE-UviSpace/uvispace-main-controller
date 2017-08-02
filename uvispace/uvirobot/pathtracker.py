#!/usr/bin/env python
"""Module with functions to allow the UGV to reach the goal points.

It contains functions to selecction correct speed depending on the
position of the UGV and its goal.
"""
# Standard libraries
import ast
import ConfigParser
import glob
# Third party libraries
import numpy as np

class FuzzyController(object):

    def get_output(var_in, fuzzyset):
        value_max = max([np.abs(fuzzyset.max()),np.abs(fuzzyset.min())])
        work_var_in = var_in / value_max
        work_fuzzyset = fuzzyset / value_max
        which_membership1 = np.greater_equal(work_var_in, work_fuzzyset[:, 0])
        if np.any(which_membership1 == True):
            membership_index1 = (np.where(which_membership1 == True)[0]).max()
            membership1 = work_fuzzyset[membership_index1]
            which_zone1 = np.greater_equal(work_var_in, membership1)
            zone_index = (np.where(which_zone1 == True)[0]).max()
            if zone_index == 0:
                degree_of_membership1 = ((work_var_in - membership1[0]) /
                                         (membership1[1]-membership1[0]))
            elif zone_index == 1:
                degree_of_membership1 = 1
            else:
                degree_of_membership1 = 0
        else:
            degree_of_membership1 = 0
            membership_index1 = 0


        which_membership2 = np.less_equal(work_var_in, work_fuzzyset[:, 3])
        if np.any(which_membership2 == True):
            membership_index2 = (np.where(which_membership2 == True)[0]).min()
            membership2 = work_fuzzyset[membership_index2]
            which_zone2 = np.less_equal(work_var_in, membership2)
            zone_index2 = (np.where(which_zone2 == True)[0]).min()
            if zone_index2 == 3:
                degree_of_membership2 = ((membership2[3] - work_var_in) /
                                       (membership2[3]-membership2[2]))
            elif zone_index2 == 2:
                degree_of_membership2 = 1
            else:
                degree_of_membership2 = 0
        else:
            degree_of_membership2 = 0
            membership_index2 = 0

        if degree_of_membership1 == 1:
            degree_of_membership2 = 0

        return (degree_of_membership1, membership_index1,
                degree_of_membership2, membership_index2)

    def get_weighted_arith_mean(d_mem, mem, singletons):

        a = min([d_mem[1], d_mem[3]])
        a1 = a * singletons[mem[1], mem[3]]
        b = min([d_mem[1], d_mem[4]])
        b1 = b * singletons[mem[1], mem[4]]
        c = min([d_mem[2], d_mem[3])
        c1 = c * singletons[mem[2], mem[3]]
        d = min([d_mem[2], d_mem[4]])
        d1 = d * singletons[mem[2], mem[4]]

        weighted_arith_mean = (a1 + b1 + c1 + d1) / (a + b + c + d)
        if (a+b+c+d) == 0:
            weighted_arith_mean = 0

        return weighted_arith_mean
