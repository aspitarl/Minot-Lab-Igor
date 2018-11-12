Function Lorentzian(E,Epp,wp) //abcs from exciton
variable E,Epp,wp

return (wp/((E-Epp)^2 + wp^2)) //um2 per micron

end


//calculates integrated absorption for p peak of d diameter tube
function intcs(p,d) ///ACTUALLY DOESN'T DEPEND ON D FOR PER UNIT LENGTH...
variable p,d
variable sigmap

sigmap = 45.9/((7.5+p)*(d))

sigmap *= 1e-18


Controlinfo/W=MCW peratom

if(!V_Value)

sigmap *= ((4*pi*d)/(sqrt(3)*(.249^2)))*1e3
//ev cm^2 per micron
sigmap *= 10^8
//ev um2 per micron

endif
return sigmap

end


Function Heavyside(x, xo)
//+
     Variable x, xo
     return x < xo ? 0 : 1
//+
End




Function CalcSpectAbCS(row, devname, chilib)
variable row //which row of 
string devname // name of calculated wave
wave chilib

//pull out peak positions and p value
//wave reslistall = root:Spectral:reslist_all //without fitted peak values



setdatafolder root:spectral:calculated
//variable numpeaks = dimsize(reslistall,1)-4
variable numpeaks = dimsize(chilib,1)-4
make/o/n=(numpeaks) currentpeaks

variable i 
for(i=0;i<=numpeaks;i=i+1)
//currentpeaks[i] = reslistall[row][i+4]
currentpeaks[i] = chilib[row][i+4]
endfor

//variable d = reslistall[row][2]
variable d = chilib[row][3]
//variable type = reslistall[row][3]
//print d, type

variable type =1


//setup destination wave
variable wsize = 5000
make/o/n=(wsize) $devname
make/o/n=(wsize) exciton
make/o/n=(wsize) continuum
wave spectrum = $devname
wave exciton = exciton
wave continuum = continuum
spectrum =0

variable eVmax = 4
variable eVmin = 0

SetScale/I x eVmin,eVmax,"", spectrum
SetScale/I x eVmin,eVmax,"", exciton
SetScale/I x eVmin,eVmax,"", continuum

//Setup convolution waves
variable convpoints = 10*wsize
variable conveVrange =5*eVmax
variable deltaeconv = (conveVrange)/convpoints

make/o/n=(convpoints) stepfn   //set up cont. stuff
SetScale/I x 0,conveVrange,"", stepfn
make/o/n=(convpoints) contlor
SetScale/I x -(conveVrange/2),(conveVrange/2),"", contlor


//parameters
variable a  //oscillator strength
variable b  //linebroadening
variable delta  //cont. offset  
variable Etowp //coefficient for Epp to wp

if(type==1)//semiconducting
a = 4.673 -0.747*d  //oscillator strength
//a = 3.8 -0.747*d  //oscillator strength
b = .97 +0.256*d  //linebroadening
//b = 1.5 +0.256*d  //linebroadening
 delta = 0.273 -0.041*d //cont. offset 
 Etowp = .0194
endif
  
if(type==0)//metallic
a = 0.976 +0.186*d  //oscillator strength
b = 3.065 - 0.257*d  //linebroadening
delta = 0.175 -0.0147*d //cont. offset  
 Etowp = .0214
endif
//print a,b,delta

variable eVrange = eVmax- eVmin
variable wp // half peak width

variable doexciton =1
variable docontinuum =1
variable psel = 0 //zero for all peaks

variable j 
Variable E //just to make read easier, the energy independent variable
variable Econt

for(i=0;i<=numpeaks-1;i=i+1)   
	variable p = i+1
		
	if((currentpeaks[i] != 0) && (p==psel || psel ==0))
	wp = Etowp*currentpeaks[i] 
	


	for(j=0;j<dimsize(exciton,0);j=j+1) //calculate exciton
		E =pnt2x(exciton,j)
		exciton[j] = Lorentzian(E,currentpeaks[i],wp)		
	endfor
	exciton *= intcs(p,d)/(pi)
	
	ECont = currentpeaks[i]+delta
	//ECont = 1
	for(j=0;j<dimsize(stepfn,0);j=j+1)    //calculate step function for convolution 
		E =pnt2x(stepfn,j)
		if(Heavyside(E,Econt))
			stepfn[j] = 1/sqrt(E-Econt)
		else
			stepfn[j] =0
		endif
	endfor	
	
	
	//Calculate lorenzian for cont convolution
	for(j=0;j<dimsize(contlor,0);j=j+1)
		E =pnt2x(contlor,j)
		contlor[j] = Lorentzian(E,0,b*wp)	
	endfor	
	contlor *= intcs(p,d)/(pi*a)
	

	variable Econv
	variable x

	Duplicate/O contlor,W_Convolution;DelayUpdate
	Convolve stepfn, W_Convolution                                     //convolve 
	W_convolution *= deltaeconv	
	
	for(j=0;j<dimsize(W_convolution,0);j=j+1) //Get convolution into addable form
		Econv =pnt2x(W_convolution,j)
		if((Econv>eVmin) && (Econv<eVmax))
			 x = x2pnt(continuum, Econv)
			continuum[x] = W_convolution[j]
		endif
	endfor



	
	
	if(doexciton)
	spectrum += exciton
	endif
	if(docontinuum)
	spectrum += continuum
	endif
	
	DoUpdate
	endif
endfor




end



//attemp at a convolution

//	make/o/n=(dimsize(contlor,0) + dimsize(stepfn,0)) Convolutionman
//	SetScale/I x -(2*conveVrange),(2*conveVrange),"", Convolutionman
//	variable k,E2
//	for(j=0;j<dimsize(Convolutionman,0);j=j+1) //Get convolution into addable form
//		Econv =pnt2x(Convolutionman,j)
//		if((Econv>eVmin) && (Econv<eVmax))
//			 x = x2pnt(continuum, Econv)
////			 for(k=0;k<dimsize(contlor,0);k=k+1)
////			 	E2 = pnt2x(contlor, k)
////			 	contlor[k] =(intcs(p,d)/(pi*a))*Lorentzian(E,Econv-E2,b*wp)
////			 endfor
//			duplicate/o stepfn integrand,integral
//			 integrand[] = stepfn[p]*contlor[x-p]
//			 Integrate integrand
//		continuum[j] = integral[dimsize(integral,0)]
//		DoUpdate
//		endif
//	endfor	
//	



Function Scalecalcabcs(abcswavestr,FFwavestr)
string abcswavestr
string FFwavestr

string abcswavename = "root:spectral:calculated:" + abcswavestr
string FFwavename = "root:spectral:FF:" + FFwavestr

wave abcswave = $abcswavename
wave FFwave = $FFwavename

setdatafolder root:spectral:calculated

duplicate/o abcswave $(abcswavename + "_FF")
wave abcswaveFF = $(abcswavename + "_FF")

variable i,Eph

for(i=0;i<dimsize(abcswave,0);i=i+1)
	Eph = pnt2x(abcswave,i)
	if(Eph>=pnt2x(FFwave,0))
	abcswaveFF[i] = abcswaveFF[i]*FFwave(Eph)
	endif
endfor
//variable xabcs
//for(i=0;i<dimsize(FFwave,0);i=i+1)
//	Eph = pnt2x(FFwave,i)
//	xabcs = x2pnt(abcswaveFF,Eph)
//	abcswaveFF[xabcs] = abcswaveFF[xabcs]*FFwave[i]
//
//endfor


end

Function ScalePC(PCwavestr,FFwavestr)
string PCwavestr
string FFwavestr

string PCwavename = "root:spectral:normalized:" + PCwavestr
string PCxwavename = "root:spectral:xwaves:" + PCwavestr + "eV"
string FFwavename = "root:spectral:FF:" + FFwavestr

wave PCwave = $PCwavename
wave PCxwave = $PCxwavename
wave FFwave = $FFwavename

setdatafolder root:spectral:normalized

duplicate/o PCwave $(PCwavename + "_FF")
wave PCwaveFF = $(PCwavename + "_FF")

variable i,Eph

for(i=0;i<dimsize(PCwave,0);i=i+1)
	Eph = PCxwave[i]
	if(Eph>=pnt2x(FFwave,0))
	PCwaveFF[i] = PCwaveFF[i]/FFwave(Eph)
	endif
endfor
//variable xabcs
//for(i=0;i<dimsize(FFwave,0);i=i+1)
//	Eph = pnt2x(FFwave,i)
//	xabcs = x2pnt(abcswaveFF,Eph)
//	abcswaveFF[xabcs] = abcswaveFF[xabcs]*FFwave[i]
//
//endfor

end


Function calculateFF(wavestr,L,r,phasefactor,angle,n)

string wavestr
variable r,phasefactor,L,angle , n //index of refraction

setdatafolder root:spectral:FF:Calculated
wavestr = "FFcalc_" + wavestr
make/o/n=1000 $(wavestr)
wave FFcalc = $(wavestr)

//string lambdawavestr = "Lambda_" + wavestr
//make/o/n=1000 $(lambdawavestr)
//wave lambdawave = $(lambdawavestr)

string evwavestr = "ev_" + wavestr
make/o/n=1000 $(evwavestr)
wave evwave = $(evwavestr)

evwave = 1+2*(p/1000)



variable phaseshift =phasefactor*2*pi


//FFcalc = 1+r^2+2*r*cos(phaseshift + 2*pi*((2*L)/lambdawave))

FFcalc = 1+r^2+2*r*cos(phaseshift + 2*pi*n*(eVwave/1240)*cos(angle*(2*pi/360))*(2*L))

//SetScale/I x 1.240/wavemax(lambdawave),1.240/wavemin(lambdawave),"", FFcalc
SetScale/I x wavemin(evwave),wavemax(evwave),"", FFcalc

end




Function NTdiam(n,m)
variable n,m

variable a = 0.246
return a/pi*sqrt(n^2+n*m+m^2)

end