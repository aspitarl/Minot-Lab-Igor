from __future__ import division
from pylab import *
#Contants
nVt = 1
Is = 1
#Variables
Rspace=.01

Vs=arange(0,2,.01)
R = arange(.1,1,Rspace)

#Loop stuff
bound=.00001
maxiter=100

I=zeros((R.size,Vs.size))
errorRVs=zeros((R.size,Vs.size))
VdRVs= zeros((R.size,Vs.size))
for k in range(R.size):
    for j in range(Vs.size):
        error=zeros(maxiter+1)
        Vd=zeros(maxiter+1)
        error[0]=bound+1
        i=0
        Vd0=Vs[j]*(9999/10000)
        Vd[0]= Vd0
        if Vs[j] == 0:
            error[0] = 0
            Vd[j]= 0
        while ((error[i]>bound) and (i<maxiter)):
            i= i+1          
            warnings.simplefilter("ignore")
            Vd[i] = (nVt*log(((Vs[j]-Vd[i-1])/(R[k]*Is))+1))
            warnings.resetwarnings()         
            error[i] = abs(Vd[i]-Vd[i-1])
        if(i==0):
            i=1
    
        I[k,j] = (Vs[j]- Vd[i-1])/R[k]
        errorRVs[k,j] = error[i-1]
        VdRVs[k,j] = Vd[i-1]
        error = error[:i]
        Vd = Vd[:i]        
        #Trim arrays

        if ((j==55) and (k ==90)):
            figure()
            plot(Vd)
            title("$V_s = %.2f$" %(Vs[55]))
            text(1,1,"R = %.2f" %(R[90]))
            xlabel("$N$")
            ylabel("$V_d$")
            
            

            
##            Vdplot = Vd    
####            l=0
####            while(l<(Vd.size)):
####                Vdplot[l] = Vd[l]
####                l=l+1
##            Vdplot = Vdplot[:l]
    
#Figures
##if j!=0:
##figure()
##plot(Vdplot)
##title("$V_s = %.2f$" %(Vs[10]))
##text(1,1,"R = %.2f" %(R[10]))
##xlabel("$N$")
##ylabel("$V_d$")
##    
##    figure()
##    loglog(error)
##    title("$V_s = %.2f$" %(Vs[j]))
##    xlabel("$N$")
##    ylabel("Error")

##    figure()
##    plot(R,errorR)
##    #title("$Error(R)")
##    xlabel("$R$")
##    ylabel("Error(R)")
##
##    figure()
##    plot(R,VdR)
##    #title("$Error(R)")
##    xlabel("$R$")
##    ylabel("Vd(R)")
##    show()


##print("\nThe current is", I )
##print("\nThe error is", error)
##print("\nIterated", i , "Times")

Rcut=.1
cut = (Rcut -.01)/Rspace
cut = int(cut)

###Error
##fig = plt.figure()
##ax = fig.add_subplot(111)
##ax.set_title('Error')
##plt.pcolor(Vs, R,errorRVs)
##ax.set_aspect('equal')
##ax.set_xlabel(r'Vs', fontsize=18)
##ax.set_ylabel(r'R', fontsize=18)
##plt.colorbar()
##plt.show()

###Vd
##fig = plt.figure()
##ax = fig.add_subplot(111)
##ax.set_title('Vd')
##plt.pcolor(Vs, R,VdRVs)
##ax.set_aspect('equal')
##ax.set_xlabel(r'Vs', fontsize=18)
##ax.set_ylabel(r'R', fontsize=18)
##plt.colorbar()
##plt.show()



#I
fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('I')
ax.set_aspect('equal')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'R', fontsize=18)
ax.plot(Vs,R[cut]+ ((Rspace)/2)+0*Vs)
plt.pcolor(Vs, R,I)
plt.colorbar()
##
###Icut
##figure()
##plot(Vs, I[cut], label=r"$I(R=%.2f$)"%(R[cut]))
##plot(Vs,(Vs/R[cut]), label=r"Vs=Vs")
##legend(loc=2)
##title("Diode cut R=%.2f$" %(R[cut]))
##xlabel("$Vs$")
##ylabel("I(Vs)")





show()

