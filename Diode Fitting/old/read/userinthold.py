# -*- coding: utf-8 -*-
"""
Created on Thu Sep 18 15:51:07 2014

@author: aspitarl
"""

#from __future__ import division
#from pylab import *
#import Tkinter
#from Tkinter import *
#from Tkinter import Tk, Frame, IntVar
#from ttk import  Style, Entry
import Tkinter, tkFileDialog
import matplotlib
matplotlib.use('TKAgg')
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
from matplotlib.figure import Figure
import matplotlib.pyplot as pltlib
from Tkinter import *
from scipy.special import lambertw
from lmfit import minimize, Parameters, Parameter, report_fit



def find_nearest(array,value):
    idx = (np.abs(array-value)).argmin()
    return idx

def lamb(x, i0,nvt,R): 
    return i0*((nvt/(i0*R))*lambertw((i0*R/nvt)*exp((x+i0*R)/nvt)).real - 1)

def fnc2min(params,x,data):
    i0 = params['i0'].value
    nvt = params['nvt'].value
    R = params['R'].value
    return lamb(x,i0,nvt,R)-data
    

  
    
    
class Example(Frame):
    
    def __init__(self,parent):
        Frame.__init__(self,parent,background="white")
        self.parent = parent
        self.initUI()
    
    def initUI(self):
        self.parent.title("Curve Fitting")
        
        #declare global variables
#        self.popt = zeros(3)
        self.popt = Parameters()
        self.d = zeros((2,2))
        
        self.vdata = zeros(2)
        self.test = zeros((2,2))
        self.fit = zeros((2,2))        
        self.usei0=IntVar()
        self.usenvt=IntVar()
        self.useR=IntVar()
        self.usetest=IntVar()
        self.newfit=IntVar()
        
        cblabel= Label(self, text="fit Value?")
        cblabel.grid(row=0, column=0)
        self.entryi0 = Entry(self)
        self.entryi0.grid(row=1, column=1, sticky=W+E)
        self.entryi0.insert(0,1e-12)                
        self.cbi0= Checkbutton(self,text="i0",variable=self.usei0)
        self.cbi0.select()
        self.cbi0.grid(row=0,column=1)

                
        
        #setup plot space
        self.canvasFig=pltlib.figure(1)
        self.Fig = matplotlib.figure.Figure(figsize=(5,4),dpi=100)
        self.FigSubPlot = self.Fig.add_subplot(111)
        #add plot
        self.line1, = self.FigSubPlot.plot(self.d[:,0],self.d[:,1],'r-')
        self.canvas = matplotlib.backends.backend_tkagg.FigureCanvasTkAgg(self.Fig, master=self)
        self.canvas.show()
        self.canvas.get_tk_widget().pack(side=TOP, fill=BOTH, expand=1)
        self.canvas.get_tk_widget().grid(column=6,row=0, rowspan =5)
        self.update()#??
              
              
        labelfitin = Label(self, text="fit input", height=4)
        labelfitin.grid(row=1, column=0)
#        i0

        
#        nvt
        self.entrynvt = Entry(self)
        self.entrynvt.grid(row=1, column=2, sticky=W+E)
        self.entrynvt.insert(0,.025)        
        self.cbnvt= Checkbutton(self,text="nVt",variable=self.usenvt)
        self.cbnvt.select()
        self.cbnvt.grid(row=0,column=2)


#       R
        self.entryR = Entry(self)
        self.entryR.grid(row=1, column=3, sticky=W+E)
        self.entryR.insert(0,"%g" %(1e+9))
        self.cbR= Checkbutton(self,text="R",variable=self.useR)
        self.cbR.select()
        self.cbR.grid(row=0,column=3)

#        test function before fitting 
        self.cbtest= Checkbutton(self,text="test function",variable=self.usetest)
        self.cbtest.select()
        self.cbtest.grid(row=4,column=1)
        self.testline, = self.FigSubPlot.plot(self.test[:,0],self.test[:,1],'r-')
        
        self.fitline, = self.FigSubPlot.plot(self.fit[:,0],self.fit[:,1],'r-')
        
    
        labelfitout = Label(self, text="Fit output", height=4)
        labelfitout.grid(row=2, column=0)
        
        self.fiti0 = Text(self, width=12, height =1)
        self.fiti0.grid(row=2,column=1)
        self.fitnvt = Text(self, width=12, height =1)
        self.fitnvt.grid(row=2,column=2)
        self.fitR = Text(self, width=12, height =1)
        self.fitR.grid(row=2,column=3)
#       Input for bounds for curve fitting

        labelminV=Label(self, text="minV", height=4)
        labelminV.grid(row=3, column=0)
        labelmaxV=Label(self, text="maxV", height=4)
        labelmaxV.grid(row=3, column=2)       
        self.entryminV = Entry(self)
        self.entryminV.grid(row=3, column=1, sticky=W+E)
        self.entryminV.insert(0,0.25)
        self.entrymaxV = Entry(self)
        self.entrymaxV.grid(row=3, column=3, sticky=W+E)     
        self.entrymaxV.insert(0,0.5)
       
        quitbutton= Button(self,text="quit", command = self.parent.destroy)
        quitbutton.grid(row=4,column=0)
        
        refreshbutton= Button(self,text="refresh", command = self.refreshFigure)
        refreshbutton.grid(row=4,column=2)
        
        loadbutton= Button(self,text="loadfile", command = self.loadfile)
        loadbutton.grid(row=4,column=3)

        fitbutton= Button(self,text="Fit!", command = self.dofit)
        fitbutton.grid(row=5,column=2)
        
        transbutton= Button(self,text="Trans parameters", command = self.transfer)
        transbutton.grid(row=5,column=3)
        
        
        labelcalcnvt=Label(self, text="T,n:", height=4)
        labelcalcnvt.grid(row=6, column=0)
        self.entryT = Entry(self)
        self.entryT.grid(row=6, column=1, sticky=W+E)
        self.entryT.insert(0,300)
        self.entryn = Entry(self)
        self.entryn.grid(row=6, column=2, sticky=W+E)     
        self.entryn.insert(0,1)        
        calcnvtbutton= Button(self,text="calc nvt", command = self.calcnvt)
        calcnvtbutton.grid(row=6,column=3)
        
        
        self.pack()
        
    def refreshFigure(self):
        if len(self.FigSubPlot.lines) > 1 : #if there is a plot remove it
            for i in range(len(self.FigSubPlot.lines)):
                self.FigSubPlot.lines[-1].remove()
        self.line1, = self.FigSubPlot.plot(self.d[:,0],self.d[:,1],'o',color='g') #add new plot
#        test function is no longer nesssecary as can fit with zero params
        if (self.usetest.get() == 1):        
            testvdata = arange(self.d[:,0].min(),self.d[:,0].max(),(self.d[1,0]-self.d[0,0]))
            self.linetest, = self.FigSubPlot.plot(testvdata,lamb(testvdata,float(self.entryi0.get()),float(self.entrynvt.get()),float(self.entryR.get())),'r-',color='b')
            
        if (self.newfit == 1):
            self.fitline, = self.FigSubPlot.plot(self.vdata,lamb(self.vdata,self.popt['i0'].value,self.popt['nvt'].value,self.popt['R'].value),color = 'r')
            self.fiti0.delete("1.0",END)
            self.fiti0.insert(INSERT, "%g" %(self.popt['i0'].value))
            self.fitnvt.delete("1.0",END)
            self.fitnvt.insert(INSERT, "%g" %(self.popt['nvt'].value))
            self.fitR.delete("1.0",END)
            self.fitR.insert(INSERT, "%g" %(self.popt['R'].value))
        ax = self.FigSubPlot.axes
        ax.set_xlim(self.d[:,0].min(), self.d[:,0].max())   #set up axes
        ax.set_ylim(abs(self.d[:,1]).min(), self.d[:,1].max())
        self.FigSubPlot.set_yscale('log')
        
        self.FigSubPlot.axvline(self.entryminV.get())  #add curve fit bound lines
        self.FigSubPlot.axvline(self.entrymaxV.get())
        
        self.canvas.draw()
        
        
    def loadfile(self):
        file_path = tkFileDialog.askopenfilename()
        self.d = np.loadtxt(file_path, delimiter="\t",skiprows=1)
        self.refreshFigure()
        
    def dofit(self):
        minVidx = find_nearest(self.d[:,0],float(self.entryminV.get()))
        maxVidx = find_nearest(self.d[:,0],float(self.entrymaxV.get()))
        self.vdata = self.d[minVidx:maxVidx,0]
        idata = self.d[minVidx:maxVidx,1]
        

            
        self.popt['i0'] = Parameter(value=float(self.entryi0.get()),vary=self.usei0.get())
        self.popt['nvt'] = Parameter(value=float(self.entrynvt.get()), vary =self.usenvt.get() )
        self.popt['R'] = Parameter(value=float(self.entryR.get()), vary = self.useR.get())
        
        minimize(fnc2min, self.popt, args=(self.vdata,idata))
        self.newfit=1
        self.refreshFigure()
    def transfer(self):
        if (self.usei0.get()==0):
            self.entryi0.delete(0,END)
            self.entryi0.insert(0, "%g" %(self.popt['i0'].value))
        if (self.usenvt.get()==0):
            self.entrynvt.delete(0,END)
            self.entrynvt.insert(0, "%g" %(self.popt['nvt'].value))
        if (self.useR.get()==0):
            self.entryR.delete(0,END)
            self.entryR.insert(0, "%g" %(self.popt['R'].value))
    def calcnvt(self):
        self.entrynvt.delete(0,END)
        self.entrynvt.insert(0, (.026)*(float(self.entryT.get())/300)*float(self.entryn.get()))
root = Tk()
#root.geometry("250x250+300+300")

w=Example(root)

root.mainloop()



