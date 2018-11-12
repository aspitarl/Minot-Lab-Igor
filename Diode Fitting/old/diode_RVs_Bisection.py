from __future__ import division
from pylab import *
#Contants
nVt = 1
Is = 1
#Variables
Rzero=.01
Rspace=.01
R = arange(Rzero,1,Rspace)  #Resistance array parameters

Rcut=.01
cut = (Rcut -Rzero)/Rspace  #Resistance for "cut" at the end
cut = int(cut)

Vs=arange(0,2,.01)    #Source voltage array

Vdfine = zeros(1)     #Initialize Vdfine, necessary?

#Loop stuff
maxiter=100
Vdfinestep= .0005

I=zeros((R.size,Vs.size))    #initalize current array
VdRVs= zeros((R.size,Vs.size))  #Initalize array for diode voltages



for k in range(R.size):
    Vd=arange(0,Vs[Vs.size-1],R[k]/2)   #coarse diode voltage array, needs to be finer than distance bettwen zero and singularity
    print(k)    #keep track of timing
    for j in range(Vs.size):
        change=0.1      #Get ready to go through diode voltages
        VdBi = 0.1
        i=0
        if Vs[j] == 0:  #if the supply voltage is zero, diode voltage is zero
            VdBi= 0
            change=-1
        while (change>0):  #Coarse loop
            a1=(nVt*log(((Vs[j]-Vd[i])/(R[k]*Is))+1))-Vd[i]
            b1=(nVt*log(((Vs[j]-Vd[i+1])/(R[k]*Is))+1))-Vd[i+1]     #calculate g(x) in intervals until it changes sign
            change =  (a1)*(b1)
            if (change<0):
                Vdfine=arange(Vd[i],Vd[i+1]+Vdfinestep,Vdfinestep) # Prepare fine array
                change = .1
                l=0
                while ((change>0) and (l<(Vdfine.size-1))):     #Fine loop      
                    a2= (nVt*log(((Vs[j]-Vdfine[l])/(R[k]*Is))+1))-Vdfine[l]
                    b2=(nVt*log(((Vs[j]-Vdfine[l+1])/(R[k]*Is))+1))-Vdfine[l+1]
                    change =  (a2)*(b2)   
                    if (change<0):
                        VdBi=(Vdfine[l] + Vdfine[l+1])/2    #Where sign changes, take average of voltages

                    l=l+1
                    
            i= i+1
    
        I[k,j] = (Vs[j]- VdBi)/R[k] # use calculated diode voltage to find currrent
        VdRVs[k,j] = VdBi
   

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
#Icut
figure()
plot(Vs, I[cut], label=r"$I(R=%.2f$)"%(R[cut]))
#plot(Vs,(Vs/R[cut]), label=r"I(Vs)=Vs/R")
legend(loc=2)
title("Diode cut R=%.4f$" %(R[cut]))
xlabel("$Vs$")
ylabel("I(Vs)")






##        if ((j==55) and (k ==90)):
##            figure()
##            plot(Vd)
##            title("$V_s = %.2f$" %(Vs[55]))
##            text(1,1,"R = %.2f" %(R[90]))
##            xlabel("$N$")
##            ylabel("$V_d$")
            
            

            
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








show()

