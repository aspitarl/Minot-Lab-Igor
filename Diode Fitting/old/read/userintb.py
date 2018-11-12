# -*- coding: utf-8 -*-
"""
Created on Thu Sep 18 15:51:07 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *
import Tkinter
from Tkinter import *
from Tkinter import Tk, Frame, IntVar
from ttk import  Style, Entry
matplotlib.use('TKAgg')
import matplotlib.pyplot as pltlib
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
import numpy as np
import scipy as sc


class Example(Frame):
    
    def __init__(self,parent):
        Frame.__init__(self,parent,background="white")
        self.parent = parent
        self.initUI()
    
    def initUI(self):
        self.parent.title("simple")
        self.usei0=IntVar()
        self.usenvt=IntVar()
        self.useR=IntVar()
        
        self.columnconfigure(0, pad=3)
        self.columnconfigure(3, pad=3)
        
        self.rowconfigure(0, pad=3)
        self.rowconfigure(4, pad=3)
        
        
        self.canvasFig=pltlib.figure(1)
        Fig = matplotlib.figure.Figure(figsize=(5,4),dpi=100)
        FigSubPlot = Fig.add_subplot(111)
        x=[]
        y=[]
        self.line1, = FigSubPlot.plot(x,y,'r-')
        self.canvas = matplotlib.backends.backend_tkagg.FigureCanvasTkAgg(Fig, master=self)
        self.canvas.show()
        self.canvas.get_tk_widget().pack(side=TOP, fill=BOTH, expand=1)
        self.canvas._tkcanvas.pack(side=Tkinter.TOP, fill=Tkinter.BOTH, expand=1)
#        self.resizable(True,False)
#        self.update()
        
#     
        i0
        self.entryi0 = Eself.line1, = self.FigSubPlot.plot(self.d[:,0],self.d[:,1],'r-')ntry(self)
        self.entryi0.grid(row=0, column=1, sticky=W+E)                
        self.cbi0= Checkbutton(self,text="i0",variable=self.usei0)
        self.cbi0.select()
        self.cbi0.grid(row=1,column=1)
        cblabel= Label(self, text="use Value?")
        cblabel.grid(row=2, column=1)
        
#        nvt
        self.entrynvt = Entry(self)
        self.entrynvt.grid(row=0, column=2, sticky=W+E)        
        self.cbnvt= Checkbutton(self,text="nVt",variable=self.usenvt)
        self.cbnvt.select()
        self.cbnvt.grid(row=1,column=2)
        cblabel= Label(self, text="use Value?")
        cblabel.grid(row=2, column=2)

#       R
        self.entryR = Entry(self)
        self.entryR.grid(row=0, column=3, sticky=W+E)
        self.cbR= Checkbutton(self,text="R",variable=self.useR)
        self.cbR.select()
        self.cbR.grid(row=1,column=3)
        cblabel= Label(self, text="use Value?")
        cblabel.grid(row=2, column=3)
    
       
        quitbutton= Button(self,text="quit", command = self.parent.destroy)
        quitbutton.grid(row=8,column=0)
        
        refreshbutton= Button(self,text="refresh", command = self.onClick)
        refreshbutton.grid(row=8,column=4)
        

        self.pack()
        
    def onClick(self):
#        self.i0 = self.entryi0.get()
        if self.usei0.get()==1:
            print("i0:"+str(self.entryi0.get()))
        else:
            print("i0: not used")
#        self.nvt = self.entrynvt.get()
#        print("nvt:"+str(self.nvt))
#        self.R = self.entryR.get()
#        print("R:"+str(self.R))
        x=[]
        y=[]
        for num in range(0,1000):x.append(num*.001+1)
        # just some random function is given here, the real data is a UV-Vis spectrum
        for num2 in range(0,1000):y.append(sc.math.sin(num2*.06)+sc.math.e**(num2*.001))
        X = np.array(x)
        Y = np.array(y)
        self.refreshFigure(X,Y)
    def refreshFigure(self,x,y):
        self.line1.set_data(x,y)
        ax = self.canvas.figure.axes[0]
        ax.set_xlim(x.min(), x.max())
        ax.set_ylim(y.min(), y.max())        
        self.canvas.draw()
root = Tk()
#root.geometry("250x250+300+300")

w=Example(root)

root.mainloop()

