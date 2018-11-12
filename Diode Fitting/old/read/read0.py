# -*- coding: utf-8 -*-
"""
Created on Thu Sep 18 10:48:04 2014

@author: Lee
"""

from __future__ import division
from pylab import *
from scipy.special import lambertw
from scipy.optimize import curve_fit
import Tkinter, tkFileDialog

def find_nearest(array,value):
    idx = (np.abs(array-value)).argmin()
    return idx

def func(x, i0,nvt,R):
    return i0*((nvt/(i0*R))*lambertw((i0*R/nvt)*exp((x+i0*R)/nvt)).real - 1)

root = Tkinter.Tk()
root.withdraw()

file_path = tkFileDialog.askopenfilename()
d = np.loadtxt(file_path, delimiter="\t",skiprows=1)


#plt.plot(d[:,0],d[:,1])
#plt.ylabel(r'I', fontsize=18)
#plt.xlabel(r'V', fontsize=18)
#plt.yscale('log')
#plt.show()

minV=.22
maxV=.8

#minV= input('Minimum voltage: ')
#
minVidx = find_nearest(d[:,0],minV)
#
#maxV= input('Maximum voltage: ')
#
maxVidx = find_nearest(d[:,0],maxV)

vdata = d[minVidx:maxVidx,0]
idata = d[minVidx:maxVidx,1]

popt, pcov = curve_fit(func, vdata, idata,p0=(.1e-18,(.025)*(160/300)*(1.3),1e9))

y=func(vdata, popt[0],popt[1],popt[2])


plt.plot(d[:,0],d[:,1],'o')
plt.plot(vdata,y)
plt.ylabel(r'I', fontsize=18)
plt.xlabel(r'V', fontsize=18)
plt.yscale('log')
plt.axvline(d[minVidx,0])
plt.axvline(d[maxVidx,0])
plt.show()