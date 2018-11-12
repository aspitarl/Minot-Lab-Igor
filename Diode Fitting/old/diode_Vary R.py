from __future__ import division
from pylab import *
#Contants
nVt = 1
Is = 1
#Variables
Vs=arange(0,.2,.1)
I=zeros(Vs.size)
#Loop stuff
bound=.001
maxiter=100

print(range(Vs.size))

R = arange(.1,1,.1)
errorR=zeros(R.size)
VdR= zeros(R.size)
for k in range(R.size):
    error=zeros(maxiter+1)
    Vd=zeros(maxiter+1)
    for j in range(Vs.size):
        error[0]=bound+1
        i=0
        Vd0=Vs[j]-.099999
        Vd[0]= Vd0
        if Vs[j] == 0:
            error[0] = 0
            Vd[j]= 0
        while ((error[i]>bound) and (i<maxiter)):
            i= i+1
            #print("R:", R[k])
            #print("k:", k)
            #print("inside log:", ((Vs[j]-Vd[i-1])/(R[k]*Is))+1)
            #print("Vd:", Vd[i-1])
            #print("Vs:", Vs[j])
            
            warnings.simplefilter("ignore")
            Vd[i] = (nVt*log(((Vs[j]-Vd[i-1])/(R[k]*Is))+1))
            warnings.resetwarnings()
                
            
            error[i] = abs(Vd[i]-Vd[i-1])
            
        I[j] = (Vs[j]- Vd[i])/R[k]
        
    #Trim arrays
    error = error[:i]
    Vd = Vd[:i]
    errorR[k] = error[i-1]
    VdR[k] = Vd[i-1]
#Figures
if j!=0:
    figure()
    plot(Vd)
    title("$V_s = %.2f$" %(Vs[j]))
    text(1,1,"R = %.2f" %(R[k]))
    xlabel("$N$")
    ylabel("$V_d$")
    
    figure()
    loglog(error)
    title("$V_s = %.2f$" %(Vs[j]))
    xlabel("$N$")
    ylabel("Error")

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

print("\nThe current is", I )
print("\nThe error is", error)
print("\nIterated", i , "Times")
      
show()
