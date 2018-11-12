from __future__ import division
from pylab import *
t = arange(0, 20, 0.1) #seconds
v = zeros(t.size) #meters/seconds
i = 0 
for i in range(t.size):
    v[i] = -9.8*t[i]
    i=i+1
print(v)
show(plot(v))
