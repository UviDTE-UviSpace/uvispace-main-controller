#!/usr/bin/env python

# Standard libraries
import glob
import copy
import numpy as np
import threading
import time

# Local libraries
from resources import saveposes

filename = "{}".format(time.strftime("%d_%m_%Y_%H%M"))
array2save = np.array(['time','pos x','pos y','angle'])
cycletime=time.time()
test1=time.time()-cycletime
test2=9
test3=10
test4=12
t1="{:.{prec}}".format(test1, prec=0)
t2="{}".format(test2)
t3="{}".format(test3)
t4="{}".format(test4)
test5=time.time()-cicletime
t5="{:.{prec}}".format(test5, prec=0)
array2saveb = np.array([t1,t2,t3,t4])
array2save = np.vstack((array2save,array2saveb))
array2saveb = np.array([t5,t2,t3,t4])
array2save = np.vstack((array2save,array2saveb))
print array2save

# Instructions to execute after end_event is raised.
# Save poses in spreadsheet.
sLeft=input("sLeft of test \n")
sRight=input("sRight of test \n")
saveposes.data2spreadsheet(array2save,
        "tmp/{}-L{}-R{}.xlsx".format(filename,sLeft,sRight))
# Save poses in textfile.
saveposes.data2textfile(array2save,
        "tmp/{}-L{}-R{}.txt".format(filename,sLeft,sRight))
