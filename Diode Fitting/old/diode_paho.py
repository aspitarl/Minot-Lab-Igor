from __future__ import division
from pylab import *
#Contants
nVt = 1
R = .5
Is = 1
#Variables
Vs=arange(0,.2,.1)
I=zeros(Vs.size)
#Loop stuff
bound=.001
maxiter=100



for j in range(Vs.size):
    error=[bound+1]
    i=0
    Vd0=Vs[j]-.00001
    Vd=[Vd0]
    if Vs[j] == 0:
        error = [0]
        Vd[j]= 0
    while ((error[i]>bound) and (i<maxiter)):
        i= i+1

        print("inside log:", ((Vs[j]-Vd[i-1])/(R*Is))+1)
        print("Vd:", Vd[i-1])

        print("Vs:", Vs[j])
        print("Vs: " + str(Vs[j]))
        print("Vs: %.2f" %(Vs[j]))

        Vd.append(nVt*log(((Vs[j]-Vd[i-1])/(R*Is))+1))
        
        
        error.append(abs(Vd[i]-Vd[i-1]))
        
    I[j] = (Vs[j]- Vd[i])/R

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

    print(Vd)



print("\nThe current is" )
print(I)
print("\nThe error is" )
print(error[i])
print(i)
show()
