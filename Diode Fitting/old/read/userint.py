# -*- coding: utf-8 -*-
"""
Created on Thu Sep 18 15:51:07 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *
from Tkinter import *
from Tkinter import Tk, Frame, BOTH,IntVar
from ttk import  Style, Entry

class Example(Frame):
    
    def __init__(self,parent):
        Frame.__init__(self,parent,background="white")
        self.parent = parent
        self.initUI()
    
    def initUI(self):
        self.parent.title("simple")
        self.i0=IntVar()
        self.nvt=IntVar()
        self.R=IntVar()
        
        Style().configure("TButton", padding=(0, 5, 0, 5), 
            font='serif 10')
        
        self.columnconfigure(0, pad=3)
        self.columnconfigure(3, pad=3)
        
        self.rowconfigure(0, pad=3)
        self.rowconfigure(4, pad=3)
        
#        i0
        self.entryi0 = Entry(self)
        self.entryi0.grid(row=0, column=1, sticky=W+E)                
        cb= Checkbutton(self,text="i0",variable=self.i0)
        cb.select()
        cb.grid(row=1,column=1)
        cblabel= Label(self, text="use Value?")
        cblabel.grid(row=2, column=1)
        
#        nvt
        self.entrynvt = Entry(self)
        self.entrynvt.grid(row=0, column=2, sticky=W+E)        
        cb= Checkbutton(self,text="nVt",variable=self.nvt)
        cb.select()
        cb.grid(row=1,column=2)
        cblabel= Label(self, text="use Value?")
        cblabel.grid(row=2, column=2)

#       R
        self.entryR = Entry(self)
        self.entryR.grid(row=0, column=3, sticky=W+E)
        cb= Checkbutton(self,text="R",variable=self.R)
        cb.select()
        cb.grid(row=1,column=3)
        cblabel= Label(self, text="use Value?")
        cblabel.grid(row=2, column=3)
    
       
        quitbutton= Button(self,text="quit", command = self.parent.destroy)
        quitbutton.grid(row=8,column=0)
        
        refreshbutton= Button(self,text="refresh", command = self.onClick)
        refreshbutton.grid(row=8,column=4)
        

        self.pack()
        
    def onClick(self):
#        self.i0 = self.entryi0.get()
        print("i0:"+str(self.entryi0.get()))
#        self.nvt = self.entrynvt.get()
#        print("nvt:"+str(self.nvt))
#        self.R = self.entryR.get()
#        print("R:"+str(self.R))
root = Tk()
#root.geometry("250x250+300+300")

w=Example(root)

root.mainloop()

