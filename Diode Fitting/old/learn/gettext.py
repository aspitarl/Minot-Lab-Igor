# -*- coding: utf-8 -*-
"""
Created on Wed Oct 01 10:39:12 2014

@author: Lee
"""

import Tkinter, tkFileDialog
import matplotlib
matplotlib.use('TKAgg')
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
import matplotlib.pyplot as pltlib
from Tkinter import *
from scipy.special import lambertw
from lmfit import minimize, Parameters, Parameter, report_fit

#file_path = tkFileDialog.askopenfilename()

#d = np.loadtxt("C:\\Users\\Lee\\Google Drive\\Research\\python\\Code\\diode model\\old\\read\\z.txt", delimiter="\t",skiprows=2, usecols= (0,1))
#d = np.loadtxt("C:\\Users\\Lee\\Google Drive\\Research\\python\\Code\\diode model\\old\\read\\001", delimiter="\t",skiprows=2, usecols= (0,1))
#
#print d

arr = np.array([[1,2], [5,6], [9,10],[9,11],[9,12]])
print arr
print arange(0,2)
arr = np.delete(arr,arange(0,2),0)
print arr
