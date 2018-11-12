Window QETablepeak() : Table     //QE calculated from peak PC
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:QE:
	Edit/W=(51.75,93.5,871.5,361.25) Image,peakPC,bias,gates,PCaval,Power,OD,PowerOD,eV,diam,EQEpeak
	AppendToTable abcs,Length,FF2,IQEpeak
	ModifyTable format(Point)=1
	SetDataFolder fldrSav0
EndMacro


Window gatebias() : Table     //QE calculated from peak PC
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:QE:
	Edit/K=1/W=(51.75,93.5,871.5,361.25) Image, gates,bias,QY_fit, Length
	ModifyTable format(Point)=1
	SetDataFolder fldrSav0
EndMacro

Window Devicetable() : Table
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:QE:Devicedata:
	Edit/K=1/W=(5.25,42.5,510,236.75) Device,Ep,Power,sigmaL,avalbeam,FF2
	ModifyTable format(Point)=1
	SetDataFolder fldrSav0
EndMacro

Function Maketriplet(tablestart,tableend,tripname, gatestep, biasstep)
	variable tablestart, tableend
	string tripname
	variable gatestep, biasstep
	String fldrSav0= GetDataFolder(1)
	
	SetDataFolder root:QE
	wave gates = gates
	wave bias = bias
	wave qy_fit= qy_fit
	wave length = length
	
	SetDataFolder root:QE:triplets
	
	Duplicate/o/R=[tablestart,tableend] gates gates_trim
	Duplicate/o/R=[tablestart,tableend] bias bias_trim
	Duplicate/o/R=[tablestart,tableend] qy_fit qy_fit_trim
	
	string tripwavename = (tripname + "_qy_fit_trip")
	Concatenate/o {gates_trim,bias_trim,qy_fit_trim}, $tripwavename
	wave xyzwave = $tripwavename
	
	
	
//	variable x0 = 5
//	variable dx = .5
//	variable xn = 10
//	variable y0 = 1
//	variable dy = .5
//	variable yn = 4
//	
//	ImageInterpolate/S={x0,dx,xn,y0,dy,yn } Voronoi $(tripname + "_qy_fit")

	string imgwavename = (tripname + "_qy_fit_img")
	variable gatesize = ((wavemax(gates_trim) - wavemin(gates_trim))/gatestep)+1
	variable biassize = ((wavemax(bias_trim) - wavemin(bias_trim))/biasstep)+1
	
//	SetDataFolder root:images
	
	Make /O /N=(gatesize,biassize) $imgwavename=0
	wave imgwave = $imgwavename	
	SetScale x,wavemin(gates),wavemax(gates),imgwave
	SetScale y,wavemin(bias),wavemax(bias),imgwave
	Duplicate /O imgwave,countMat
	ImageFromXYZ /AS xyzwave, imgwave, countMat
	
	
	killwaves gates_trim, bias_trim, qy_fit_trim, countMat
	//ImageLineProfile
	SetDataFolder fldrSav0
end






Macro CalcQEpeaknew()
String fldrSav0= GetDataFolder(1)
Setdatafolder root:QE

// IntPC - nA 
//PCaval um^2
//abcs - um2/um
// pow - W
// diameter - nm


PowerOD = Power*10^(-OD)
EQEpeak = 1e-9*(peakPC*(pi*PCaval^2))/((PowerOD/eV)*diam*1e-3)
IQEpeak = 1e-9*(peakPC*(pi*PCaval^2))/((PowerOD/eV)*abcs)
IQEpeak /= sqrt(pi)*PCaval*erf(Length/(2*PCaval))
IQEpeak /=FF2
SetDataFolder fldrSav0
endMacro



//calculate what the plateau of a convolution fit should be
//think this should include FF2....
Function CalcCoef100()
//variable Ep, P, sigmaL,a, FF2
//Ep         - eV
//P          - W
//sigmaL  - um^2/um
// a          - m
// IE         - field factor magnitude

	String fldrSav0= GetDataFolder(1)
	setdatafolder root:QE:Devicedata
	wave Ep =Ep
	wave Power =Power
	wave sigmaL=sigmaL
	wave avalbeam =avalbeam
	wave FF2=FF2
	

	controlinfo/W=MCW devicenumber	

	variable devicenum = V_value
	

//variable amp = ((P*FF2)/Ep)*sigmaL*(1/(2*sqrt(pi)*a*1e6))

variable amp = ((Power[devicenum]*FF2[devicenum])/Ep[devicenum])*sigmaL[devicenum]*(1/(2*sqrt(pi)*avalbeam[devicenum]*1e6))

	•wave fit_coef = fit_coef
	•fit_coef = {avalbeam[devicenum],0,amp,0,0}
	
	SetDataFolder fldrsav0
//return W_coef
end



//Function fitcspc()
////variable Ep, P, sigmaL,avalbeam,FF2, qy //a value for the laser
//
//wave ywave = csrwaveref(A)
////wave xwave = csrXwaveref(A)
//String fldrSav0= GetDataFolder(1)
//SetDataFolder root:temp
//
//variable L= abs(hcsr(B)-hcsr(A))/2
//variable x0= abs(hcsr(B)+hcsr(A))/2
//variable y0= abs(vcsr(B)+vcsr(A))/2
////variable y0= 0 //
//
//string fitstr =""
//
//
////variable amp = CalcAmp100(Ep,P,sigmaL, avalbeam,FF2)
//variable amp = CalcAmp100()
//if(qy==0) //fit the qy
//fitstr = "10010"
//else
//amp  *= qy
//fitstr = "10110"
//
//endif
//
//•Make/D/N=4/O W_coef
//•W_coef[0] = {avalbeam,x0,amp,y0,L}
//
//
////print w_coef
////FuncFit/NTHR=0 conv W_coef ywave[pcsr(A),pcsr(B)] /X=xwave /D 
//FuncFit/X=1/Q/NTHR=0/H=fitstr conv W_coef ywave[pcsr(A),pcsr(B)]  /D 
//
//print "a,x0,amp,y0,L"
//print W_coef
//print ("qy=" + num2str(W_coef[2]/amp))
//print ("L=" + num2str(W_coef[4]))
////print W_coef[4]
//SetDataFolder fldrsav0
//end




Function fitcspcref(w)
	wave w

	String fldrSav0= GetDataFolder(1)
	//wave xwave = csrXwaveref(A)
	variable xl = dimoffset(w,0)
	variable xr = DimDelta(w,0)*dimsize(w,0) + xl
	variable L= abs(xr-xl)
	variable x0= (xl+xr)/2
	//variable y0= wavemin(w)
	variable y0= 0 //
	
	setdatafolder root:QE:Devicedata
	wave fit_coef = fit_coef
	
	//fit_coef= {avalbeam[devicenum],x0,amp,y0,L}
	
	CalcCoef100()
	variable amp0 = fit_coef[2]
	

	
	fit_coef[1] = x0
	fit_coef[3] = y0
	fit_coef[4] = L	
	//print fit_coef
	Controlinfo/W=MCW qyfitval	
	
	variable qy = V_Value
	
	string fitstr =""
	if(qy==0) //fit the qy
	fitstr = "10010"
	else
	fit_coef[2]  *= qy
	fitstr = "10110"
	
	endif
	SetDataFolder root:temp
	
	
	

	Make/O/T/N=2 T_Constraints
	
	string constraint1 = ("K4 > " + num2str(fit_coef[0]))
	//string constraint1 = ("K4 > 0")	
	T_Constraints[0] = {constraint1,"K4 < 2e-6"}
	
	
	
	
	FuncFit/X=1/Q/NTHR=0/H=fitstr conv fit_coef w  /D /C=T_Constraints 
	
	//print "a,x0,amp,y0,L"
	print nameofwave(w)
	print fit_coef
	
	string qyresult = "qy=" + num2str(fit_coef[2]/amp0)	
	if(qy!=0)
		qyresult += " (fixed)"
	endif
	print qyresult

	SetDataFolder fldrsav0
end


//if(amp==0)
////variable amp= wavemin(ywave)
//amp= wavemax(ywave)
////variable amp= 2.8e-11
//fitstr = "10010"
//elseif(amp==1)
//
//variable sigmal = .0003666
//variable pow = 1.54e-6
//variable eV = 2.505
//variable qy =.2
//
//amp = 1e-6*(sqrt(pi)/2)*(avalbeam)*sigmal*(pow/(eV*pi*(avalbeam^2)))*qy
//fitstr = "10110"
//else
//fitstr = "10110"
//print ("qy=" + num2str(.2*(amp/3.4366e-11)*(1/.782)))
//endif 