# -*- coding: utf-8 -*-
"""
Created on Mon Sep 22 16:46:16 2014

@author: aspitarl
"""

import numpy as np
import scipy.optimize as optimize
import textwrap

funcstr=textwrap.dedent('''\
def func(x, {p}):
    return x * 2*a + 4*b - 5*c
''')
def make_model(**kwargs):
    params=set(('a','b','c')).difference(kwargs.keys())
    exec funcstr.format(p=','.join(params)) in kwargs
    print funcstr.format(p=','.join(params))
    print funcstr
    print params
    return kwargs['func']

func=make_model(a=3,b=2)

xdata = np.array([1,3,6,8,10])
ydata = np.array([  0.91589774,   4.91589774,  10.91589774,  14.91589774,  18.91589774])
popt, pcov = optimize.curve_fit(func, xdata, ydata)
print(popt)