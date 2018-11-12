# -*- coding: utf-8 -*-
"""
Created on Thu Sep 11 14:02:48 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *
from scipy.special import lambertw
from scipy.optimize import curve_fit




xdata = numpy.linspace(-.1, 1., 1000)
ydata = zeros(xdata.size)

def func(x, i0,nvt,R):
    return i0*((nvt/(i0*R))*lambertw((nvt/(i0*R))*exp((x+i0*R)/nvt)).real - 1)

for i in range(xdata.size):
    ydata[i] = func(xdata[i],.1e-15,(.025)*(160/300)*(1.3),.5e9) #+(random()/1e+15)


#def func(x, p1,p2):
#    return p1*lambertw(p2*x).real
#
#for i in range(xdata.size):
#    ydata[i] = func(xdata[i], 1,1) +(random()/1e+15)

    

    


popt, pcov = curve_fit(func, xdata, ydata,p0=(.1e-15,(.025)*(160/300)*(1.3),.5e9))
#
y=func(xdata, popt[0],popt[1],popt[2])


plt.plot(xdata,ydata,'o',xdata,y)
plt.xlim([xdata[0]-1, xdata[-1] + 1 ])
plt.ylabel(r'I', fontsize=18)
plt.xlabel(r'V', fontsize=18)
plt.annotate('p1='+str(popt[0]) + '\np2=' + str(popt[1]),xy=(6,.11))
plt.yscale('log')
plt.show()