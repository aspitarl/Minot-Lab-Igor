# -*- coding: utf-8 -*-
"""
Created on Mon Aug 25 10:28:15 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *


nVt = (.025)*(140/300)*(1.3) #kt/q x ideality factor
R= logspace(6,10, num=5)
Is=.001e-15

print(R)

Iarray=zeros((99999,R.size))
Vs = zeros((99999,R.size))
endindex= zeros(R.size)
Vsmax=.5

for j in range(R.size):
#    I= arange(.001,((1e-10)/R[j]),(.001/R[j]))
    I= arange(1e-14,1e-9,1e-14)
    for i in range(I.size):
        VR = I[i]*R[j]
        Vd = nVt*log((I[i]/Is)+1)
        Vs[i,j]=VR + Vd
        if(Vs[i,j] > Vsmax):
            break
    Iarray[:,j]=I
    



fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('I')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'I', fontsize=18)
ax.set_aspect('auto')
ax.set_yscale('log')
ax.plot(Vs, Iarray)
#ax.plot(Vs[:,0], Iarray[:,0])
#ax.plot(Vs[:,1], (exp(Vs[:,1])-1))
