# -*- coding: utf-8 -*-
"""
Created on Fri Sep 19 13:30:43 2014

@author: Lee
"""

from __future__ import division
from pylab import *

class Point():
    def __init__(self, x=0,y=0):
        self.x =x
        self.y = y
    def printout(self):
        print("("+ str(self.x)+ "," + str(self.y) + ")")

p = Point(1,3)
p.what =5


print p.what
p.printout()

print("a" + "b")