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
variable bias =25
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
