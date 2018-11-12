# -*- coding: utf-8 -*-
"""
Simulates the photocurrent from a CNT pn junciton including Multiple Exciton Generation.

Created on Thu Sep 18 15:51:07 2014

@author: aspitarl
"""

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2TkAgg
import matplotlib.pyplot as plt
import math as math
import time
from tkinter import *
import numpy as np
    
class Example(Frame):
    
    def __init__(self,parent):
        Frame.__init__(self,parent,background="white")
        self.parent = parent
        self.initUI()
    
    def initUI(self):
        self.parent.title("MEG Simulator 3000")
        
        refreshbutton= Button(self,text="refresh", command = self.refreshFigure)
        refreshbutton.grid(row=0, column=1)
        
        self.sizeEnt = Entry(self)
        self.sizeEnt.grid(row=2, column=2, sticky=W+E)
        self.sizeEnt.insert(0,2000)
        sizeEntlabel= Label(self, text="Total Length(nm)")
        sizeEntlabel.grid(row=2, column=1)
        
        self.lenintEnt = Entry(self)
        self.lenintEnt.grid(row=4, column=2, sticky=W+E)
        self.lenintEnt.insert(0,250)
        lenintEntlabel= Label(self, text="Length intrinsic region(nm)")
        lenintEntlabel.grid(row=4, column=1)
        
        self.diflenEnt = Entry(self)
        self.diflenEnt.grid(row=5, column=2, sticky=W+E)
        self.diflenEnt.insert(0,100)
        diflenEntlabel= Label(self, text="Diffusion Length(nm)")
        diflenEntlabel.grid(row=5, column=1)
        
        self.EgEnt = Entry(self)
        self.EgEnt.grid(row=6, column=2, sticky=W+E)
        self.EgEnt.insert(0,1)
        EgEntlabel= Label(self, text="BandGap(eV)")
        EgEntlabel.grid(row=6, column=1)
        
        self.WaitEnt = Entry(self)
        self.WaitEnt.grid(row=7, column=2, sticky=W+E)
        self.WaitEnt.insert(0,.1)
        WaitEntlabel= Label(self, text="Wait time(s)")
        WaitEntlabel.grid(row=7, column=1)
        
        
        self.fullrange = IntVar()
        self.cbfullrange= Checkbutton(self,text="Check: Illuminate Full Length, Uncheck:left half",variable=self.fullrange)
        self.cbfullrange.select()
        self.cbfullrange.grid(row=7,column=3)
        

        
        
        #plt.ion()
        self.fig =plt.figure(figsize=(12,4))
        self.FigSubPlot = self.fig.add_subplot(121)

        self.FigSubPlot.set_xlabel('Length(nm)')
        self.FigSubPlot2 = self.fig.add_subplot(122)
        self.FigSubPlot2.set_xlabel('Vsd(V)')
        self.FigSubPlot2.set_ylabel('Photocurrent(electrons)')
        self.canvas = FigureCanvasTkAgg(self.fig, master=self)
        self.canvas.show()
        # self.canvas.get_tk_widget().pack(side=TOP, fill=BOTH, expand=1)
        self.canvas.get_tk_widget().grid(column=3,row=0, rowspan =7,columnspan=5)
        

        
    def refreshFigure(self):
        size = int(self.sizeEnt.get() ) #number of boxes
        lenint =int(self.lenintEnt.get()) # length of intrinsic region
        diflen =int(self.diflenEnt.get()) #diffusion length
        Eg=float(self.EgEnt.get()) #bandgap
        lendop= (size-lenint)/2  #length of one doped region        
        Vsd = np.arange(-1.0,3,.1) #source drain
        I = np.zeros(len(Vsd))
        U = np.zeros(size)
        Ef = np.zeros(size)
        Etot = U + Ef
        Electrons = np.zeros(size)
        x = np.arange(0, size)
        


   
        for j in range(0,len(Vsd)):
            for i in range(0, size):   #set up potential (from gates)
                if(i<(lendop)):
                    U[i]=Eg
                elif((i>lendop-1)  and (i<(lendop +lenint+1))):
                    U[i] = Eg - (Eg/lenint)*(i-lendop)
                else:
                    U[i] = 0
                    
                    
            for i in range(0, size):     #set up fermi energy (from Vsd)
                if(i<(lendop)):
                    Ef[i] = Vsd[j]
                elif((i>lendop-1)  and (i<(lendop +lenint+1))):
                    Ef[i] = Vsd[j] - (Vsd[j]/lenint)*(i-lendop)
                else:
                    Ef[i] = 0
                    
            Etot = U + Ef
            
            
            Illumrange = np.zeros(size)
            
            for i in range(0, size):     #set up fermi energy (from Vsd)
                if(i<(size/2)):
                    Illumrange[i] = 1
                else:
                    if(self.fullrange.get()==0):
                        Illumrange[i] = 0
                    else:
                        Illumrange[i] = 1
            
                
            
            for i in range(0, size):     #electrons generated in each bin
                if((i>lendop-diflen)  and (i<(lendop+lenint+diflen))):    #check if within diff length of intrinsic
                    
                        
                    Electrons[i] = math.floor((Etot[i]/Eg)+1)*Illumrange[i]  
                #if((i>lendop-diflen)):                                      #check only on p side
                     
                    
            I[j] = np.sum(Electrons)
            
            if len(self.FigSubPlot.lines) > 1 : #if there is a plot remove it
                for i in range(len(self.FigSubPlot.lines)):
                    self.FigSubPlot.lines[-1].remove()       
            if len(self.FigSubPlot2.lines) > 1 : #if there is a plot remove it
                for i in range(len(self.FigSubPlot2.lines)):
                    self.FigSubPlot2.lines[-1].remove() 
            self.Energyline, = self.FigSubPlot.plot(x, Etot[x], linewidth=2)      
            self.Electronline, = self.FigSubPlot.plot(x, Electrons[x], linewidth=2)
            self.FigSubPlot.legend((self.Energyline, self.Electronline), ('U(x) + Ef(x) (eV)', '#electrons'))
            self.Iline, = self.FigSubPlot2.plot(Vsd, I, linewidth=2)
            self.FigSubPlot2.set_ylim(0, I.max())   #set up axes
            self.canvas.draw()
            time.sleep(float(self.WaitEnt.get()))
root = Tk()
#root.geometry("250x250+300+300")

w=Example(root)

w.pack()

root.mainloop()


#sys.exit(0)
