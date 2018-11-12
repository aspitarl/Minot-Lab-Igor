import os
import Tkinter
import tkFileDialog
import numpy
import glob
import tempfile


def main():

    Tkinter.Tk().withdraw() # Close the root window
    #os.chdir('D:\lraspitarte\Desktop\Magselectfix')
    #fpath = tkFileDialog.askopenfilename()
    os.chdir(tempfile.gettempdir())
    fname =glob.glob('xsection.0.dat.*')
    fpath = tempfile.gettempdir() + "\\" + fname[0]
    f = open(fpath, 'r')
#    
    os.chdir("C:\\Users\\aspitarl\\Desktop\\Consolidating data\\CNT Marvin 44_O2\\12\\CNT_Marvin_44_mag\\Gaussian Fitting\\")

#    
    content = f.readlines()
    infostr = content[len(content)-2]
    infostr2= infostr.split(",")[1]
    Bindex = infostr2.find("e+")
    if(Bindex ==-1):
        Bindex = infostr2.find("e-")
    Bvalstr = infostr2[(Bindex-9):(Bindex+5)]
    Bval = float(Bvalstr)
#    
    newarray = numpy.zeros((len(content),3))
#    
#
#    

    i=0
    for line in content:
        linearr = line.split()
        if(i>(len(content)-4)):
            break;
        newarray[i][0]= float(linearr[0])
        newarray[i][1]= float(linearr[1])
        newarray[i][2]= Bval

        i=i+1

    newarray = newarray[~numpy.all(newarray == 0, axis=1)]
    #newfpath = str(abs(vgval)) + "_lc" 
    newfpath = str(Bval)
    fnew = open(newfpath, 'w')
    numpy.savetxt(fnew,newarray, fmt='%.6e', newline ='\n')
#    print "hello"
    fnew.close()
    f.close()
#    #fnew = open(f_path, 'r')
if __name__ == "__main__":
    main()