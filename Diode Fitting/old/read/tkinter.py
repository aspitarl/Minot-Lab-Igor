# -*- coding: utf-8 -*-
"""
Created on Thu Sep 18 15:51:07 2014

@author: aspitarl
"""

from __future__ import division
from pylab import *
from Tkinter import *
from Tkinter import Tk, Frame, BOTH
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
        self.columnconfigure(1, pad=3)
        self.columnconfigure(2, pad=3)
        self.columnconfigure(3, pad=3)
        
        self.rowconfigure(0, pad=3)
        self.rowconfigure(1, pad=3)
        self.rowconfigure(2, pad=3)
        self.rowconfigure(3, pad=3)
        self.rowconfigure(4, pad=3)
        
        entry = Entry(self)
        entry.grid(row=0, columnspan=4, sticky=W+E)
##        cls = Button(self, text="Cls")
##        cls.grid(row=1, column=0)
        label = Label(self,text="hello world")
        label.pack()
        
        frame=Frame(self)
        frame.pack(fill=BOTH,expand=1)
        
       
       
        quitbutton= Button(self,text="quit", command = self.parent.destroy)
        quitbutton.pack(side=RIGHT)

        self.pack(fill=BOTH,expand=.1)
root = Tk()
root.geometry("250x250+300+300")

w=Example(root)

root.mainloop()

