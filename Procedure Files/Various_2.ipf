#pragma rtGlobals=3		// Use modern global access method and strict wave access.

//Procedures:
//Ideality
//newgraph
//altergraph
//manipulatewave
//linescan




Function GetFilePaths(OutputPaths, refNum)
String &outputPaths
Variable &refNum

////

	String message = "Select one or more files"
	
	//String fileFilters = "Data Files (*.txt,*.dat,*.csv):.txt,.dat,.csv;"
	String fileFilters = "All Files:.*;"
	outputpaths = ""

	Open /D /R /T="????" /MULT=1 /M=message refNum
	outputPaths = S_fileName
	
Close/A

end



//calculate the ideality factor from slope and temperature
Function Ideality(temp,calib)
variable temp, calib
 
variable Va = hcsr(A)
variable Vb = hcsr(B)  //get voltages and currents of cursors
variable Ia = vcsr(A)
variable Ib = vcsr(B)
print "cursor wave:", CsrWave(A)
print "Delta V:" ,(Vb-Va)
print "I(a)//I(b):" , (Ib/Ia)

temp = convtemp(temp,calib)

variable n = 11594.2*(1/temp)*(Vb-Va)*(1/ln(Ib/Ia))

print "n:" , n
end

Function Idealitylog(temp,calib)
variable temp, calib
 
variable Va = hcsr(A)
variable Vb = hcsr(B)  //get voltages and currents of cursors
variable Ia = vcsr(A)
variable Ib = vcsr(B)
print "cursor wave:", CsrWave(A)
print "Delta V:" ,(Vb-Va)
print "ln(Ib/Ia):" , Ib-Ia

temp = convtemp(temp,calib)

variable n = 11594.2*(1/temp)*(Vb-Va)*(1/(Ib-Ia))

print "n:" , n
end

//calculate the subthreshold slope in mv per decade
Function mvpdec()

 
variable Va = hcsr(A)
variable Vb = hcsr(B)  //get voltages and currents of cursors
variable Ia = vcsr(A)
variable Ib = vcsr(B)
print "cursor wave:", CsrWave(A)
print "Delta V:" ,(Vb-Va)
variable dLnI = ln(Ib)-ln(Ia)
print "Delta Ln(I):" , (Ib/Ia)
variable dLogI = log(Ib)-log(Ia)
print "Delta Ln(I):" , (Ib/Ia)

variable s
s = (Vb-Va)/dLogI


print s

end




//converts temperature read off diode at bottom of cryo to temperature read at sample. see 2014-09-10
Function convtemp(temp, calib)
variable temp, calib
variable tempnew

if(calib==0)
tempnew = temp
elseif(calib==1)
	tempnew =  29.936 + .88697*temp
elseif(calib==2)
	tempnew = 25.793 + .90277*temp
else
	print "0:no calibration"
	print "1:first day apiezon n"
	print "2:second day apiezon n"
endif
return tempnew

end




//takes a trace and alters it
//1=absolute value of graph
//2=absolute value and ln
//3= exponential of graph
//4 = divide by I0/T (Gabor)
//5= convert to conductivity(prompts user for bias)
//6 add lr red blue to colors
Function ManipulateWave(w, var)
variable var
wave w
ControlInfo/W=MCW bias
variable bias =V_Value
string windowname = winname(0,1)
	if(var==1)  
		w= abs(w)	//manipulate y wave
	elseif(var==2)
		w= abs(w)	//manipulate y wave
		w=ln(w)
	elseif(var==3)
		w = exp(w)
	elseif(var==4)
		w /= 2.5e-8
	elseif(var==5)		
		//prompt bias,"enter bias in mV:"
		//DoPrompt "Enter Values",bias
		w /= (bias*.001)
		Label left "Conductivity(S)"
	elseif(var==6) //add lr red blue to colors
		wave xwave = XWaveRefFromTrace(windowname, nameofwave(w))		
		string cwname = nameofwave(xwave) +"_cw"
		duplicate/o xwave $cwname
		wave cw = $cwname
		variable i
		for(i=0; i<(dimsize(cw,0)-1);i=i+1)
		cw[i] = xwave[i+1] - xwave[i]
		
		//cw[] = xwave[p+1] - xwave[p]
		endfor
		cw[dimsize(cw,0)-1] =0
		string ywname = nameofwave(w)
		ModifyGraph zColor($ywname)={cw,wavemin(cw),wavemax(cw),RedWhiteBlue}
	elseif(var==7)			
		fitcspcref(w)
	elseif(var==8)
		w=1/w
	elseif(var==9)
		trimwave(w)
	elseif(var==10)
		NVAR currentwave = root:asymmdata:currentwave
		asymmwave(w,currentwave,1)
	elseif(var==11)
		variable offsetavg = (w[0] + w[1] + w[2])/3
		w-= offsetavg
	elseif(var==12)
		//get the maximum of each trace and add it to a wave maximum in the root folder
		//traces have to be in the order that you want them to show up in the wave
		Wavestats/Q w
		variable tracemax = V_max
		setdatafolder root:
		wave maximum = maximum_day2
		variable size = dimsize(maximum,0)
		maximum[size-1] = tracemax
		redimension/n=(size+1) maximum 
	elseif(var==13)
	
	wave xwave = XWaveRefFromTrace(windowname, nameofwave(w))
	
	
	endif
	
end



Window FWHMtable() : Table     //FWHM stuff
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:QE:FWHM
	edit FWHMlisttext, aval,FWHM
	ModifyTable format(Point)=1
	SetDataFolder fldrSav0
EndMacro

Macro calcFWHM()
String fldrSav0= GetDataFolder(1)
SetDataFolder root:QE:FWHM
FWHM = aval*2*sqrt(ln(2))
SetDataFolder fldrSav0
endmacro





Function Bandgap(cond, condcon,l,lambda)
variable cond,condcon,l

variable lambda 

return .025*ln((4/12900)*(lambda/(l+lambda))*((1/cond)-(1/condcon))+1)
end


Function Arr()
//get all trace names, get min conductance and max, create wave of calculated band gap values

	string windowname
	windowname = winname(0,1)
	
	string tracelist
	tracelist = TraceNameList(windowname,";",1)
	
	//make/o/n=(itemsinlist(tracelist,";")) bandgaps
	make/o/n=(itemsinlist(tracelist,";")) lnMaxR
	Variable index=0
	string ywave
	do
		// Get the next wave name
		ywave = StringFromList(index, tracelist)
		if ((strlen(ywave) == 0) )
			break							// Ran out of waves
		endif
		
		if(!(StringMatch(ywave,"fit_*")))
			
			
			//bandgaps[index] = Bandgap(wavemin($ywave)/.025, wavemax($ywave)/.025,0,1000)
			lnMaxR[index] = ln(.025/wavemin($ywave) - 0.025/wavemax($ywave))
			//lnMaxR[index] = ln(.025/wavemin($ywave))
		endif
		index += 1
	while (1)	
	
end


//takes a series of waves starting with Isd0 or Isd00 and takes the absolute value
Function absolute(startnum, endnum)
Variable startnum, endnum
variable num

num = endnum - startnum

Variable i
String wavestr
for(i=0; i< num+1; i +=1)
if((startnum+i)>9)
wavestr = "Isd_0" + num2str(startnum +i)
else
wavestr = "Isd_00" + num2str(startnum +i)
endif
wave dummy = $wavestr
dummy = abs(dummy)
//duplicate/o dummy $wavestr
endfor

end




//GET WIDTH

Function fitcs()

wave ywave = csrwaveref(A)
wave xwave = csrXwaveref(A)
String fldrSav0= GetDataFolder(1)
SetDataFolder root:temp

variable a= abs(hcsr(B)-hcsr(A))/2
variable x0= abs(hcsr(B)+hcsr(A))/2
variable amp= (vcsr(B)-vcsr(A))/2
variable y0= abs(vcsr(B)+vcsr(A))/2

variable L = a

•Make/D/N=4/O W_coef
•W_coef[0] = {a,x0,amp,y0}
FuncFit/Q/NTHR=0 erffit W_coef ywave[pcsr(A),pcsr(B)] /D 
//FuncFit/NTHR=0 erffit W_coef ywave[pcsr(A),pcsr(B)] /X=xwave /D 
print w_coef[0]
SetDataFolder fldrsav0
end



Function grabxsection(sectname)
string sectname

String fldrSav0= GetDataFolder(1)
SetDataFolder root:crosssections

wave ysection = root:packages:MFP3D:Main:Analyze:Section:SectionWaveY
//wave xsection = root:packages:MFP3D:Main:Analyze:Section:SectionWaveX

//duplicate/o ysection $("ycs_" + sectname)
//duplicate/o xsection $("xcs_" + sectname)

duplicate/o ysection $(sectname) // y section wave is already scaled...don't need x wave.

//display $("ycs_" + sectname) vs $("xcs_" + sectname)

//display/k=1 $(sectname)

SetDataFolder fldrSav0
end








Function calclint(L0, Vg0, Vb0,Vb,Vg)
Variable L0, Vg0, Vb0, Vb,Vg

variable k= ((L0*sqrt(Vg0))/(.4+Vb0))

return k*((.4+Vb)/sqrt(Vg))

end

Function avgplateau()
wave ywave = csrwaveref(A)
WaveStats/Q/R=[pcsr(A),pcsr(B)] ywave
print V_avg
end

//calculate a basic field factor wave with the simple model



function makediamond()


variable start =-600
variable final = +800
variable delta =100

string basename = "D37_"
string filename
variable vg
for(vg = start; vg<=final;vg = vg+delta)

filename = basename + num2str(vg)



endfor



end




Function pnandsb(x,Lpn,QYpn,Lsb,Lsboff,QYsb,a)
variable x //in microns
variable Lpn,QYpn
variable Lsb,Lsboff,QYsb
variable a

variable amp =450e-12

variable x0pn = 0
variable x0sb = 1.1 -Lsb/2+Lsboff

if(x==0)
print "xosb" +num2str(x0sb)
endif
return amp*( QYpn*(erf((x+Lpn/2-x0pn)/a) - erf((x-Lpn/2-x0pn)/a)) + QYsb*(erf((x+Lsb/2-x0sb)/a) - erf((x-Lsb/2-x0sb)/a)) )

end

Function pnandsbQY(x,Lpn,QYpn,Lsb,Lsboff,QYsb,a)
variable x //in microns
variable Lpn,QYpn
variable Lsb,Lsboff,QYsb
variable a

variable amp =1

variable x0pn = -.05
variable x0sb = 1 -Lsb/2+Lsboff

variable QY =0

if( (x > (x0pn- Lpn/2)) &&(x< (x0pn+ Lpn/2)) )
QY += QYpn
endif

if( (x > (x0sb- Lsb/2)) &&(x< (x0sb+ Lsb/2)) )
QY += QYsb
endif

return QY


end









Function erffit(w,x) : FitFunc
	Wave w
	Variable x

	//CurveFitDialog/ These comments were created by the Curve Fitting dialog. Altering them will
	//CurveFitDialog/ make the function less convenient to work with in the Curve Fitting dialog.
	//CurveFitDialog/ Equation:
	//CurveFitDialog/ f(x) = y0 + amp*erf((x-x0)/a)
	//CurveFitDialog/ End of Equation
	//CurveFitDialog/ Independent Variables 1
	//CurveFitDialog/ x
	//CurveFitDialog/ Coefficients 4
	//CurveFitDialog/ w[0] = a
	//CurveFitDialog/ w[1] = x0
	//CurveFitDialog/ w[2] = amp
	//CurveFitDialog/ w[3] = y0

	return w[3] + w[2]*erf((x-w[1])/w[0])
End

Function conv(w,x) : FitFunc
	Wave w
	Variable x

	//CurveFitDialog/ These comments were created by the Curve Fitting dialog. Altering them will
	//CurveFitDialog/ make the function less convenient to work with in the Curve Fitting dialog.
	//CurveFitDialog/ Equation:
	//CurveFitDialog/ f(x) = y0 + amp*(erf((x+L/2-x0)/a) - erf((x-L/2-x0)/a))
	//CurveFitDialog/ End of Equation
	//CurveFitDialog/ Independent Variables 1
	//CurveFitDialog/ x
	//CurveFitDialog/ Coefficients 5
	//CurveFitDialog/ w[0] = a
	//CurveFitDialog/ w[1] = x0
	//CurveFitDialog/ w[2] = amp
	//CurveFitDialog/ w[3] = y0
	//CurveFitDialog/ w[4] = L

	return w[3] + w[2]*(erf((x+w[4]/2-w[1])/w[0]) - erf((x-w[4]/2-w[1])/w[0]))
End


Function conv_func(x,a,x0,amp,y0,L) 
	variable x,a,x0,amp,y0,L

	return y0 + amp*(erf((x+L/2-x0)/a) - erf((x-L/2-x0)/a))
End


Function conv_figs( L) 
variable L 
String PCname = ("PC" + num2str(L))
String Lintname = ("Lint" + num2str(L))


variable x0 = 0
variable range = 10

make/n=1000/o xvar 
make/n=1000/o $(PCname)
make/n=1000/o $(Lintname)

wave PC = $(PCname)
wave Lint = $(Lintname)

variable i 
for(i=0 ;i<dimsize(xvar,0); i=i+1)
	xvar[i] = ((i/1000)-0.5)*(range)
endfor

variable a = 0.5
variable amp =1
variable y0 = 0


for(i=0 ;i<dimsize(xvar,0); i=i+1)
	PC[i] = conv_func(xvar[i],a,x0,amp,y0,L) 
	
	if( (xvar[i] > (x0 - L/2) ) && (xvar[i] < (x0 + L/2) ) )
		Lint[i] = 1
	else
		Lint[i] = 0
	endif
	
	
endfor


end

Function asymmcsr(wavenum,V)
variable wavenum,V
wave w = csrwaveref(A)

wave xwave = CsrXWaveRef(A)

asymm(w,xwave, wavenum,V)

end

Function asymmwave(w, wavenum,V)
wave w
variable wavenum,V
setdatafolder root:NG:Trim



string wname = nameofwave(w)
string xwavestr = replacestring("Isd",wname,"VgYo")
wave xwave = $xwavestr

asymm(w,xwave, wavenum,V)

end


Function makeasymmwaves()

make/t name
make VgR0V 
make R0V 
make  Rm1V 
make Rp1V 
make asymmetry
make asymmetrydelta 
make Egp1V 
make Egm1V

end

Function asymm(w,xwave,wavenum,V)
wave w,xwave
variable wavenum,V



wavestats/Q/M=1 w

variable maxpnt = x2pnt(w,V_maxloc)
variable Vgval = xwave[maxpnt]

variable i

setdatafolder root:Temp

duplicate/o xwave xwavetemp

//-1 V
xwavetemp = abs(xwave - (Vgval -V))
wavestats/Q/M=1 xwavetemp
variable Vgm1Vpnt = x2pnt(xwavetemp,V_minloc)


//+1 V
xwavetemp = abs(xwave - (Vgval +V))
wavestats/Q/M=1 xwavetemp
variable Vgp1Vpnt = x2pnt(xwavetemp,V_minloc)

//print " Vgm1Vpnt: " + num2str(Vgm1Vpnt)
//print " Vgp1Vpnt: " + num2str(Vgp1Vpnt)

//print (" R(-1V) : " + num2str(Rm1V))
//print (" R(+1V) : " + num2str(Rp1V))
//print (" R(0V) : " + num2str(R0V))

setdatafolder root:asymmdata





wave VgR0V = VgR0V
wave R0V = R0V
wave  Rm1V = Rm1V
wave Rp1V =  Rp1V
wave asymmetry = asymmetry
wave asymmetrydelta = asymmetrydelta
wave Egp1V = Egp1V
wave Egm1V = Egm1V

//wave VgR0V = VgR0V_RIO
//wave R0V = R0V_RIO
//wave  Rm1V = Rm1V_RIO
//wave Rp1V =  Rp1V_RIO
//wave asymmetry = asymmetry_RIO
//wave asymmetrydelta = asymmetrydelta_RIO
//wave Egp1V = Egp1V_RIO
//wave Egm1V = Egm1V_RIO


VgR0V[wavenum] = Vgval
R0V[wavenum] = w[maxpnt]
Rm1V[wavenum] = w[Vgm1Vpnt]
Rp1V[wavenum] = w[Vgp1Vpnt]
asymmetry[wavenum] = Rm1V[wavenum]/Rp1V[wavenum]

variable deltaRp1V = R0V[wavenum] -Rp1V[wavenum]
variable deltaRm1V = R0V[wavenum] -Rm1V[wavenum]

 asymmetrydelta[wavenum] = deltaRp1V/deltaRm1V
Egp1V[wavenum] = ln(deltaRp1V/7413)*49.5
Egm1V[wavenum] = ln(deltaRm1V/7413)*49.5




setdatafolder root:
end


function trimcsr()
wave w = csrwaveref(A)

wave xwave = CsrXWaveRef(A)
trim(w,xwave)
end

function trimwave(w)
wave w
string wname = nameofwave(w)
string xwavestr = replacestring("Isd",wname,"Vg")
//string xwavestr = replacestring("Isd",wname,"VgYo")
wave xwave = $xwavestr
trim(w,xwave)
end



Function trim(w,xwave)
wave w,xwave


variable i

variable slope = sign(xwave[1]-xwave[0])

for(i=1;i<dimsize(xwave,0);i=i+1)

	if(sign(xwave[i]-xwave[i-1]) != slope)

		variable pnt1 = i
		
		break
	
	endif 

endfor

for(i=(pnt1+1);i<dimsize(xwave,0);i=i+1)

	if(sign(xwave[i]-xwave[i-1]) == slope)

		variable pnt2 = i
		
		break
	
	endif 

endfor


string newxwname = nameofwave(xwave) + "t"

make/o/n=(pnt2-pnt1) $newxwname

wave xwavetrim = $newxwname



string newwname = nameofwave(w) + "t"

make/o/n=(pnt2-pnt1) $newwname

wave wavetrim = $newwname

for(i=0;i<(pnt2-pnt1); i=i+1)

	xwavetrim[i] = xwave[pnt1+i]
	wavetrim[i] = w[pnt1+i]

endfor

appendtograph wavetrim vs xwavetrim

end

function avgwave()

wave w = csrwaveref(A)

//print num2str(xcsr(A))
print ("mean: " + num2str(mean(w, xcsr(A), xcsr(B) )))
print ("sqrtVariance: " + num2str(sqrt(variance(w, xcsr(A), xcsr(B) ))))

//print ("mean: " + num2str(mean(w, x2pnt(w,.5), x2pnt(w,1)  ) )   )

end

Function fitng(xoff)
variable xoff


string isdstr
string vgstr



wave ywave = csrwaveref(A)
wave xwave = csrxwaveref(A)

//variable xoff = xwave(x2pnt(ywave,wavemax(ywave)))
//print pnt2x(ywave,wavemax(ywave))

//variable xoff = hcsr(B)
//print xoff




//CurveFit/Q/G/NTHR=0/TBOX=256/K={xoff} exp_XOffset  ywave[pcsr(A),pcsr(B)] /X=xwave /D /C=T_Constraints 

make/n=3/o fit_coef
	wave fit_coef = fit_coef


	fit_coef[0] = wavemin(ywave)
	fit_coef[1] = 30000
	fit_coef[2] = -3	


CurveFit/X/Q/G/H="000"/NTHR=0/TBOX=256/K={xoff} exp_XOffset kwCWave=fit_coef ywave[pcsr(A),pcsr(B)] /X=xwave /D 


//print ("tau = " + num2str(fit_coef[2]))


//print fit_coef[0]
//print wavemax(ywave)
Variable Dr = wavemax(ywave) - fit_coef[0]

print ("Dr = " + (num2str( Dr)))

variable Eg

Eg = 58.9*ln((Dr/13349))
//Eg = 52*ln((Dr/12900))

print nameofwave(ywave)
print ("Eg = " + num2str(Eg))

end



Function Diodemodel(kT,I0,n1,Vs,n2)
variable kT,I0,n1,Vs,n2

wave turnon1 = root:Platueautime:turnon1
wave turnon2 = root:Platueautime:turnon2



Make/n=1000/o Vsd_model
make/n=1000/o Isd_model

wave Vsd_model = Vsd_model
wave Isd_model = Isd_model

variable j 

for (j=0;j < dimsize(turnon1,0) ; j = j +1)

variable i 
Variable Vrange = 1.5

for (i=0;i<dimsize(Vsd_model,0); i=i+1)

Vsd_model[i] = (Vrange/dimsize(Vsd_model,0))*i

variable current0 = I0*(exp(Vsd_model[i]/(n1*kT))-1)

if(current0 < turnon1[j])
	Isd_model[i] = current0
else
	Isd_model[i] = turnon1[j]
endif

variable current1 = I0*(exp((Vsd_model[i]-Vs)/(n2*kT))-1)

if(Vsd_model[i] > Vs)
	if((current1+turnon1[j]) <  turnon2[j] )
		Isd_model[i] += current1
	else
		Isd_model[i] += turnon2[j]
	endif
endif

duplicate/o Isd_model $("Isd_model_" + num2str(j))

endfor

endfor

end



Function diodeiterate()
variable R = 1
variable I0 = 1
variable kT = 0.025

variable i
variable Niter = 3

make/o/n=(Niter+1) Id,Vd
make/o/n=(Niter+1) IR,VR

variable Vtot,Itot

variable Iavg

Vtot = 1
Vd[0] = 0.01
VR[0] = 0.5

for ( i =0; i<Niter;i=i+1)
Id[i] = I0*exp(Vd[i]/kT)
IR[i] = VR[i]/R

Iavg = (Id[i] + IR[i])/2

Vd[i+1] = kT*ln(Iavg/I0)
VR[i+1] = Iavg*R

if(VR[i+1]>Vtot)
VR[i+1] = Vtot
endif

endfor

end

Function diodefromI(I0pn,I0SBn,I0SBp, Vshift)

variable I0pn 
variable I0SBn 
variable I0SBp 
variable Vshift 
variable kT = 0.025

variable n = 1.3

wave Isd = Isd
wave Vpn = Vpn
wave Vsb = Vsb
wave Vsbp = Vsbp
wave Vtot = Vtot

variable i 

for (i=0 ; i <dimsize(isd,0); i=i+1)

	
	Vsbp[i] = -kT*ln(1-(Isd[i]/I0sbp))

	
	if (Isd[i]< I0SBn)
	Vpn[i] = n*kT*ln((Isd[i]/I0pn)+1)
	Vsb[i] = -kT*ln(1-(Isd[i]/I0sbn))
	else
	Vpn[i] = n*kT*ln(((Isd[i]-I0SBn)/I0pn)+1)
	Vsb[i] = Vshift
	
	
	endif

endfor

Vtot = Vpn +Vsb + Vsbp

end


Function WFmodel()

variable taue = 5.5e-3
variable tauh = 1

variable e = 1.6e-19
variable kb = 1.38e-23
variable h = 6.626e-34
//variable C = 1.686e-8
//variable C = 7.311e-11
variable T = 300

wave phie= phie
wave phih = phih

variable i

for (i=0;i<dimsize(phie,0);i=i+1)

variable I0SBn = ((4*e*kb*taue)/h)*T*exp(-(e*phie[i])/(1000*kb*T))
variable I0SBp = ((4*e*kb*tauh)/h)*T*exp(-(e*phih[i])/(1000*kb*T))
variable I0pn = ((8*e*kb*1)/h)*T*exp(-(e*1.2*(phih[i]+phie[i]))/(1000*kb*T))
//variable I0pn = 3e-14

variable tpn = (h/(4*e*kb*T))*I0pn*exp((e*0.410)/(kb*T))
//print tpn

diodefromI(I0pn,I0SBn,I0SBp, 0.9)

wave Isd = Isd
wave Vtot = Vtot

duplicate/o Isd $("Isd_" + num2str(i))
duplicate/o Vtot $("Vtot_" + num2str(i))

endfor

end