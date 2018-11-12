# -*- coding: utf-8 -*-
"""
Created on Thu Sep 11 14:14:58 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *
from scipy.special import lambertw
from scipy.optimize import curve_fit

xdata = np.array([-2,-1.64,-1.33,-0.7,0,0.45,1.2,1.64,2.32,2.9])
ydata = np.array([0.699369,0.700462,0.695354,1.03905,1.97389,2.41143,1.91091,0.919576,-0.730975,-1.42001])

def func(x, p1,p2):
  return p1*np.cos(p2*x) + p2*np.sin(p1*x)

popt, pcov = curve_fit(func, xdata, ydata,p0=(1.0,0.2))


xax = numpy.linspace(-5., 5., 100)
y=func(xax, popt[0],popt[1])


plt.plot(xdata,ydata,'o', xax, y)
plt.xlim([xax[0]-1, xax[-1] + 1 ])
plt.show()



#    matplotlib.pyplot.plot(i,y)

#axes = matplotlib.pyplot.gca()
#axes.set_xlabel('x')
#axes.set_ylabel('y')


#fig = plt.figure()
#ax = fig.add_subplot(111)
#ax.set_title('I')
#ax.set_xlabel(r'Vs', fontsize=18)
#ax.set_ylabel(r'I', fontsize=18)
#ax.set_aspect('auto')
#ax.plot(x, y[x])
