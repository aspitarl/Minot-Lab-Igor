import os
import Tkinter
import tkFileDialog
import numpy

def main():

    Tkinter.Tk().withdraw() # Close the root window
    os.chdir('D:\lraspitarte\Desktop\Magselectfix')
    fpath = tkFileDialog.askopenfilename()
    
    f = open(fpath, 'r')
    fname= os.path.splitext(os.path.basename(fpath))[0]
    fpathbase= os.path.split(fpath)[0]
    print fpathbase
    newfname = fname + "_fix.dat"
    newfpath = os.path.split(fpath)[0] + "/" + newfname
    fnew = open(newfpath, 'w')
    
    
    
    content = f.readlines()
    #print content
    
    
    
    vsdfpath = os.path.split(fpath)[0] + "/" +fname +"_loop1.txt"
    floop = open(vsdfpath, 'r')
    loop = floop.readlines()
    vsdarr = numpy.zeros(len(loop))
    j=0
    for line in loop:               
        vsdarr[j] = float(line.split(",")[0])
        j=j+1
    j=0
    
    newarray = numpy.zeros((100*len(vsdarr),3))
    
    k=0
    Barr = numpy.linspace(0,2,num=200)
    
    vsdramp=-12
    vsdstep=.12
    
    i=0
    for line in content:
        linearr = line.split()
        if line.isspace():
            if j == len(vsdarr):
                j=0
                i=0
                numpy.savetxt(fnew,newarray, fmt='%.6e', newline ='\n')
                fnew.write("\n")
                newarray = numpy.zeros((100*len(vsdarr),3))
                               
                
                if k == len(Barr)-1:
                    break;
                else:    
                    k=k+1
            else:
                if j != len(vsdarr)-1:               
                    spacelin = numpy.arange(vsdarr[j+1]+vsdstep,vsdarr[j]+vsdramp-vsdstep,vsdstep)
                    spacelin = spacelin[::-1]                
                    spacearr = numpy.zeros((len(spacelin),3))
                    spacearr[:,0]=Barr[k]
                    spacearr[:,1]=spacelin
                    top = newarray[:i,:]
                    bottom =newarray[i:,:]
                    newarray = numpy.concatenate((top,spacearr,bottom))
                    i=i+len(spacelin)
                j=j+1
        else:
            linearr[0] = "{: .4E}".format(float(linearr[0])/100 + vsdarr[j])
            linearr.insert(0,str(Barr[k]))
            #if not line.isspace():    
            for n in range(0,len(linearr)-1):
                newarray[i][n] =  linearr[n]
            i=i+1    
            
    #newarray= newarray[:i][:]
    
    
    #newarray.tofile(fnew, sep="\n", format='%.6e')
    print "hello"
    
    #fnew = open(f_path, 'r')
if __name__ == "__main__":
    main()