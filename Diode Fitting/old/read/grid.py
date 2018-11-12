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
        
        Style().configure("TButton", padding=(0, 5, 0, 5), 
            font='serif 10')
        
        self.columnconfigure(0, pad=3)
        self.columnconfigure(3, pad=3)
        
        self.rowconfigure(0, pad=3)
        self.rowconfigure(4, pad=3)
        
        entry = Entry(self)
        entry.grid(row=0, columnspan=4, sticky=W+E)
        
        
        
        cls = Button(self, text="Cls")
        cls.grid(row=1, column=0)         
       
        quitbutton= Button(self,text="quit", command = self.parent.destroy)
        quitbutton.grid(row=4,column=0)
        
        self.var=IntVar()        
        
        cb= Checkbutton(self,text="show title",variable=self.var,command=self.onClick)
        cb.select()
        cb.grid(row=2,column=2)
        self.pack()
        
    def onClick(self):
        if self.var.get() ==1:
            self.parent.title("checkbutton")
        else:
            self.parent.title("")
root = Tk()
#root.geometry("250x250+300+300")

w=Example(root)

root.mainloop()

