#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function Loadd(app)
variable app //was load or loadapp pressed 1 = load
//setdatafolder root:
String wnamevg, wnameisd
string annstring =""


Variable refNum
String outputPaths
GetFilePaths(OutputPaths, refNum)

Variable numFilesSelected = ItemsInList(outputPaths, "\r")
Variable i
for(i=0; i<numFilesSelected; i+=1)
	String path = StringFromList(i, outputPaths, "\r")
			
		
	String tempstr
	String dummystr
	Open/R refNum as path
//	FReadLine/T=(num2char(10)) refNum , dummystr
//	FReadLine/T=(num2char(9)) refNum, tempstr
//	tempstr = removeending(tempstr)

	tempstr = "Vg"
	
	Controlinfo/W=MCW appstr	
	string appstr = S_Value	
	if(!stringmatch(appstr,""))
		appstr = "_" + appstr
	endif
	
	Controlinfo/W=MCW prestr	
	string prestr = S_Value	
	if(!stringmatch(appstr,""))
		prestr =  prestr + "_"
	endif

//	loadwave/J/O/Q/A/B="N='_skip_';N=Isd;N=Vg; N='_skip_', c=4;" S_fileName     //probe station
	loadwave/G/O/Q/A/B="N=Vg;N=Isd; N='_skip_', c=3;" S_fileName     //their python
	SplitString/E="_.*\." S_Filename
	
	String str= RemoveEnding(S_Value,".")
	
	wnamevg =  prestr + tempstr + "_" + str +appstr
	
	wnameisd = prestr + "Isd_" + str + appstr
	
	if(waveexists($wnamevg))
		prompt dummystr , "Wave already exists, enter something to append:"
		DoPrompt "Enter Values", dummystr
		if(!(V_Flag))
		wnamevg = wnamevg + dummystr
		wnameisd = wnameisd + dummystr

		endif

	endif
	
rename Vg $wnamevg
rename Isd $wnameisd	

	Controlinfo/W=MCW Samegraph
	variable sameg = V_Value

if(i==0 && app || !(sameg))
	display/K=1 $wnameisd vs $wnamevg
	
	Label left "Isd (A)"
	Label bottom tempstr +"(V)"
	
	annstring = "\\s('" + wnameisd + "')" + wnameisd 
	TextBox/C/N=text0/A=MC annstring
	//edit $wnameisd, $wnamevg
else
//	appendtograph $wnameisd vs $wnamevg
//	annstring +=  "\r" +"\\s(" + wnameisd + ")" + wnameisd
//	TextBox/C/N=text0/A=MC annstring

	appendtograph $wnameisd vs $wnamevg
	annstring =   "\\s('" + wnameisd + "')" + wnameisd
	Appendtext/N=text0 annstring
endif
	


endfor

colorize()
end



Function loadddiam(Vgstart,Vgend,Vsdstart,Vsdend)
Variable Vgstart,Vgend,Vsdstart,Vsdend

Variable refNum
String outputPaths
GetFilePaths(OutputPaths, refNum)

//for loop here to allow for multiple sel

	String path = StringFromList(0, outputPaths, "\r")	
	String tempstr
	String dummystr
	Open/R refNum as path

	
	loadwave/G/O/Q/A/B="N=Vsd;N=Isd; N='_skip_', c=3;" S_fileName
	
	
	wave Vsdwave = Vsd
	wave Isdwave = Isd
	variable i

variable slope = sign(Vsdwave[1]-Vsdwave[0])

for(i=1;i<dimsize(Vsdwave,0);i=i+1)

	if(sign(Vsdwave[i]-Vsdwave[i-1]) != slope)

		variable pnt1 = i
		
		break
	
	endif 

endfor

	print pnt1
	
	
	variable Vsdsize = pnt1
	variable Vgsize = dimsize(Vsdwave,0)/pnt1
	
	print Vsdsize, Vgsize
	
	
	make/o/n=(Vgsize,Vsdsize) image
	variable j
	for( j=0;j< Vgsize;j=j+1)
		for( i=j*Vsdsize;i< ((j+1)*Vsdsize);i=i+1)

		
		image[j][mod(i,Vsdsize)] = Isdwave[i]
			
		
		endfor	
		
	
	endfor
	
	SetScale/I x Vgstart,Vgend,"", image;DelayUpdate
	SetScale/I y Vsdstart,Vsdend,"", image;DelayUpdate

	//rename image $S_filename
	//rename image $S_filename
	Delftimage(nameofwave(image))
	labeldelftimage()
	Close/A
end


Function Delftimage(imagename)
	string imagename
	
	//string path = ("root:Diamond:" + imagename)
	wave imagewave = $imagename
	
	string graphname = imagename + "_Graph"
	
	//Killwindow graphname
	
	PauseUpdate; Silent 1		// building window...
	Display/K=1 /W=(35.25,42.5,700.5,378.5) as graphname
	AppendImage imagewave
	
	//imagename = "'" + imagename + "'"
	 //imagename = nameofwave(imagewave)
	ModifyImage $imagename ctab= {-1000,1000,RedWhiteBlue,0}
	ModifyGraph mirror=2
	ModifyGraph axOffset(left)=18.4286
	ColorScale/C/N=text0/A=MC/X=-64.31/Y=-15.75 image=$imagename
	//ColorScale/C/N=text0 "IpA"
	//ColorScale/C/N=text0 lblLatPos=-110,lblMargin=50,lblRot=90
	//ShowTools/A
	SetVariable Range,pos={45,22},size={82,16},title="Range",value= _NUM:1000
	SetVariable offset,pos={47,49},size={82,16},title="Offset",value= _NUM:0
	Button UpdateImgscale,pos={70,80},size={50,20},proc=Updateimagebutton,title="Update"

	Labeldelftimage()


End


Function Labeldelftimage()

•ModifyGraph tick=2,mirror=1,btLen=3
•Label left "V\Bsd\M (mV)";DelayUpdate
•Label bottom "V\Bg\M (mV)"
ModifyGraph gfSize=14
ColorScale/C/N=text0 "I (pA)"
end



Function Updateimagebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo Range
			variable Range = V_value
			Controlinfo offset
			variable offset = V_value
			
			variable bottom = offset - range/2
			variable top = offset + range/2
			
			string list = ImageNameList("", "")
			string imagename = StringFromList(0, list, ";")
			ModifyImage $imagename ctab= {bottom,top,RedWhiteBlue,0}
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Function makelines(vsdmax, appstr)
variable vsdmax
string appstr

variable i 
string linename
variable Vgmin, Vgmax

wave slopes = $("Slopes_pos"+ appstr)
wave yint = $("yint_pos"+ appstr)
wave xint = $("xint_pos"+ appstr)




for(i=0 ; i<dimsize(slopes,0) ; i=i+1)

	linename = "line_pos" + num2str(i) + appstr
	
	make/o/n=2 $linename
	
	wave line = $linename

		
	line[0] = -vsdmax
	line[1] = +vsdmax
	
	Vgmin = xint[i] - (vsdmax/slopes[i]) 
	Vgmax = xint[i] + (vsdmax/slopes[i]) 
	
	if(i==0 || i==2)
	line[0] = 0
	Vgmin = xint[i] 
	endif
	
	SetScale/I x Vgmin,Vgmax,"", line
endfor


wave slopes = $("Slopes_neg"+ appstr)
wave yint = $("yint_neg"+ appstr)
wave xint = $("xint_neg"+ appstr)

for(i=0 ; i<dimsize(slopes,0) ; i=i+1)

	linename = "line_neg" + num2str(i) + appstr
	
	make/o/n=2 $linename
	
	wave line = $linename
	
	line[0] = -vsdmax
	line[1] = +vsdmax
	
	Vgmin = xint[i] - (vsdmax/slopes[i]) 
	Vgmax = xint[i] + (vsdmax/slopes[i]) 
	
	if(i==0 || i==2)
	line[1] = 0
	Vgmax = xint[i] 
	endif
	
	SetScale/I x Vgmin,Vgmax,"", line
endfor


//variable x_pos = 

//bandg = (yint_h - yint_e*((slope_h/slope_e)))/(1 - (slope_h/slope_e))


end


Function calcEg(appstr)
string appstr

wave slopes_pos = $("Slopes_pos"+ appstr)
wave yint_pos = $("yint_pos"+ appstr)
wave xint_pos = $("xint_pos"+ appstr)
wave Eg_pos = $("Eg_pos"+ appstr)
wave Eg_pos_Vg = $("Eg_pos_Vg"+ appstr)

wave slopes_neg = $("Slopes_neg"+ appstr)
wave yint_neg = $("yint_neg"+ appstr)
wave xint_neg = $("xint_neg"+ appstr)
wave Eg_neg = $("Eg_neg"+ appstr)
wave Eg_neg_Vg = $("Eg_neg_Vg"+ appstr)



variable i


Eg_pos[0] = 0
Eg_pos_Vg[0] = 0


Eg_neg[0] = 0
Eg_neg_Vg[0] = 0



for(i=1 ; i<dimsize(Eg_pos,0) ; i=i+1)

Eg_pos_Vg[i] = (yint_pos[i] - yint_neg[0])/(slopes_neg[0] - slopes_pos[i])
Eg_pos[i] = slopes_neg[0]*Eg_pos_Vg[i] + yint_neg[0]

endfor

for(i=1 ; i<dimsize(Eg_neg,0) ; i=i+1)

Eg_neg_Vg[i] = (yint_neg[i] - yint_pos[0])/(slopes_pos[0] - slopes_neg[i])
Eg_neg[i] = slopes_pos[0]*Eg_neg_Vg[i] + yint_pos[0]

endfor



//duplicate/o Eg_pos alpha_pos
//duplicate/o Eg_neg alpha_neg

variable deltaVg_pos = xint_pos[1] - xint_pos[0]
variable deltaVg_neg = xint_neg[1] - xint_neg[0]

make/o/n=2 alpha

alpha[0] = Eg_pos[1]/deltaVg_pos
alpha[1] = Eg_neg[1]/deltaVg_neg

//alpha_pos = 


end


Function loaddlines(appstr)
string appstr





make/o/n=100 $("Slopes_pos"+ appstr)
make/o/n=100 $("yint_pos"+ appstr)
make/o/n=100 $("xint_pos"+ appstr)
make/o/n=100 $("Slopes_neg"+ appstr)
make/o/n=100 $("yint_neg"+ appstr)
make/o/n=100 $("xint_neg"+ appstr)
make/o/n=100 $("Eg_pos"+ appstr),$("Eg_neg"+ appstr)
make/o/n=100 $("Eg_pos_Vg"+ appstr),$("Eg_neg_Vg"+ appstr)

wave slopes_pos = $("Slopes_pos"+ appstr)
wave yint_pos = $("yint_pos"+ appstr)
wave xint_pos = $("xint_pos"+ appstr)
wave Eg_pos = $("Eg_pos"+ appstr)
wave Eg_pos_Vg = $("Eg_pos_Vg"+ appstr)

wave slopes_neg = $("Slopes_neg"+ appstr)
wave yint_neg = $("yint_neg"+ appstr)
wave xint_neg = $("xint_neg"+ appstr)
wave Eg_neg = $("Eg_neg"+ appstr)
wave Eg_neg_Vg = $("Eg_neg_Vg"+ appstr)


Variable refNum
String outputPaths
GetFilePaths(OutputPaths, refNum)

//for loop here to allow for multiple sel

	String path = StringFromList(0, outputPaths, "\r")	
	String tempstr
	String dummystr
	Open/R refNum as path

	
	loadwave/G/O/Q/A/B="N='_skip_';N=slopes_temp;N=yint_temp; N=xint_temp, c=4;" S_fileName
	
	
	wave slopes_temp = slopes_temp
	wave yint_temp = yint_temp
	wave xint_temp = xint_temp
	
	variable i
	variable numpos,numneg = 0
	
	for(i=0; i<dimsize(slopes_temp,0);i=i+1)
	
		if(sign(slopes_temp[i])>0)
			
			slopes_pos[numpos] = slopes_temp[i]
			yint_pos[numpos] = yint_temp[i]
			xint_pos[numpos] = xint_temp[i]
			numpos += 1
			
		else 
			
			slopes_neg[numneg] = slopes_temp[i]
			yint_neg[numneg] = yint_temp[i]
			xint_neg[numneg] = xint_temp[i]
			numneg += 1
		endif
		
	
	
	endfor
	
	redimension/n=(numpos) slopes_pos,yint_pos,xint_pos,Eg_pos,Eg_pos_Vg 
	redimension/n=(numneg) slopes_neg,yint_neg,xint_neg,Eg_neg,Eg_neg_Vg 
	
	calcEg(appstr)
	
	variable maxpos = wavemax(Eg_pos)
	variable maxneg =abs( wavemax(Eg_neg))
	
	if(maxpos > maxneg)
	
	makelines(maxpos+20, appstr)
	
	else
	makelines(maxneg+20, appstr)
	endif
	
	Killwaves slopes_temp,yint_temp,xint_temp
	
end