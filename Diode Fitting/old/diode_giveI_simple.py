# -*- coding: utf-8 -*-
"""
Created on Mon Aug 25 10:28:15 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *


#Parameters for dt670
#nVt = .025*1 #kt/q x ideality factor
#R=1e2
#Is=1e-15
#I= arange(1e-9,100e-6,1e-9)

nVt = (.025*1)*(160/300)*(1.2) #kt/q x ideality factor
R=.5e9
Is=.1e-12
I= arange(1e-14,3e-10,1e-14)


Vs = zeros(I.size)
Vd = zeros(I.size)
VR = zeros(I.size)

for i in range(I.size):
    VR[i] = I[i]*R
    Vd[i] = nVt*log((I[i]/Is)+1)
    Vs[i]=VR[i] + Vd[i]






fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('I')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'I', fontsize=18)
ax.set_aspect('auto')
ax.set_yscale('log')
ax.plot(Vs, I)
#ax.plot(Vs[:,0], Iarray[:,0])
#ax.plot(Vs[:,1], (exp(Vs[:,1])-1))


fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('Vd/VR')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'Vd/Vr', fontsize=18)
ax.set_aspect('auto')
ax.set_yscale('log')
ax.plot(Vs, Vd/VR)