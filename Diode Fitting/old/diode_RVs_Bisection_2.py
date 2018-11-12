from __future__ import division
from pylab import *
plt.close('all')
#Contants
nVt = 1
Is = 1
#Variables
Rzero=.01
Rspace=.2
R = arange(Rzero,1.01,Rspace)  #Resistance array parameters

Rcut=.011
cut = (Rcut -Rzero)/Rspace  #Resistance for "cut" at the end
cut = int(cut)

Vs=arange(0,10,.01)    #Source voltage array

Vdfine = zeros(1)     #Initialize Vdfine, necessary?

#Loop stuff
maxiter=100
bound = .0001

I=zeros((R.size,Vs.size))    #initalize current array
I2=zeros((R.size,Vs.size)) 
VdRVs= zeros((R.size,Vs.size))  #Initalize array for diode voltages
errorRVs=zeros((R.size,Vs.size))

for k in range(R.size): 
    print(k)    #keep track of timing
    for j in range(Vs.size):
        errorRVs[k,j]=0.1      #Get ready to go through diode voltages
        VdBi = 0.1
        i=0
        left= 0
        right = Vs[j]
        mid = (right+left)/2
        if Vs[j] == 0:  #if the supply voltage is zero, diode voltage is zero
            VdBi= 0
            change=-1

        while ((i<maxiter) and (abs(errorRVs[k,j])>bound)):     #Fine loop      
            
            
            c=(nVt*log( ((Vs[j]-mid)/(R[k]*Is)) + 1) )-mid
            errorRVs[k,j] =  c
            if (abs(c)<bound):                
                VdBi = mid
            elif (c<0):
                right = mid
            elif (c>0):
                left =mid
            mid = (right+left)/2
                
            i= i+1
            I[k,j] = (Vs[j]- VdBi)/R[k] # use calculated diode voltage to find currrent
#            I2[k,j] = Is*(exp(VdBi/nVt)-1)
            VdRVs[k,j] = VdBi
   

#I
fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('I')
ax.set_aspect('auto')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'R', fontsize=18)
ax.plot(Vs,R[cut]+(Rspace/2) + 0*Vs)
plt.pcolor(Vs, R,I)
plt.colorbar()
##
#Icut
fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('I')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'I', fontsize=18)
ax.set_aspect('auto')
ax.set_yscale('log')
#ax.plot(Vs, (VdRVs[cut]/(Vs-VdRVs[cut])), label=r"$I(R=%.2f$)"%(R[cut]))
ax.plot(Vs, I[cut], label=r"$I(R=%.2f$)"%(R[cut]))
ax.plot(Vs, Is*(exp(Vs/nVt)-1), label=r"$I(R=%.2f$)"%(R[cut]))
#ax.plot(Vs, Vs/R[cut], label=r"$I(R=%.2f$)"%(R[cut]))
#ax.plot(Vs, I2[cut], label=r"$I(R=%.2f$)"%(R[cut]))

fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('I')
ax.set_xlabel(r'Vs', fontsize=18)
ax.set_ylabel(r'I', fontsize=18)
ax.set_aspect('auto')
ax.set_yscale('log')
for x in range(R.size):
    ax.plot(Vs, I[x])


print[VdRVs[1,1]]
print[Vs[1]]
print[((1-VdRVs[1,1])/R[1])]

print[I[1,1]]




#        while (change>0):  #Coarse loop
#            a1=(nVt*log(((Vs[j]-Vd[i])/(R[k]*Is))+1))-Vd[i]
#            b1=(nVt*log(((Vs[j]-Vd[i+1])/(R[k]*Is))+1))-Vd[i+1]     #calculate g(x) in intervals until it changes sign
#            change =  (a1)*(b1)
#            if (change<0):
#                Vdfine=arange(Vd[i],Vd[i+1]+Vdfinestep,Vdfinestep) # Prepare fine array
#                change = .1
#                l=0


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

