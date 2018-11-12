from __future__ import division
from pylab import *
#Contants
nVt = 1
R = 1
Is = 1
#Variables
Vs=arange(0,1,.1)
I=zeros(Vs.size)
#Loop stuff
bound=.001
maxiter=100

error=zeros(maxiter)
Vd=zeros(maxiter)

for j in range(Vs.size):
    error[0]=bound+1
    i=0
    Vd0=Vs[j]-.05
    Vd[0]= Vd0
    if Vs[j] == 0:
        error[0] = 0
        Vd[j]= 0
    while ((error[i]>bound) and (i<maxiter)):
        i= i+1

        print("inside log:", ((Vs[j]-Vd[i-1])/(R*Is))+1)
        print("Vd:", Vd[i-1])
        print("Vs:", Vs[j])

        Vd[i] = (nVt*log(((Vs[j]-Vd[i-1])/(R*Is))+1))        
        error[i] = abs(Vd[i]-Vd[i-1])
        
    I[j] = (Vs[j]- Vd[i])/R

#Trim arrays
error = error[:i]
Vd = Vd[:i]
#Figures
if j!=0:
    figure()
    plot(Vd)
    title("$V_s = %.2f$" %(Vs[j]))
    xlabel("$N$")
    ylabel("$V_d$")
    figure()
    loglog(error)
    title("$V_s = %.2f$" %(Vs[j]))
    xlabel("$N$")
    ylabel("Error")



print("\nThe current is", I )
print("\nThe error is", error)
print("\nIterated", i , "Times")
      
show()
