Function typgraph()
 ModifyGraph tick=2,mirror=1,btLen=3
 ModifyGraph gfSize=12
 ModifyGraph standoff=0
end

Function pcimg()
•
•ModifyGraph gfSize=16
•Label left "x (um)\\u#2";DelayUpdate
•Label bottom "x (um)\\u#2"
ModifyGraph lblPosMode=0,lblMargin(left)=20,lblMargin(bottom)=5,lblLatPos=0
ColorScale/C/N=ColorBar0 "I\\BPC\\M(nA)"
ColorScale/C/N=ColorBar0 nticks=3
end

Function Rimg()
•ModifyGraph gfSize=16
•Label left "x (um)\\u#2";DelayUpdate
•Label bottom "x (um)\\u#2"
ColorScale/C/N=ColorBar0 "R (a.u.)"
ColorScale/C/N=ColorBar0 nticks=3
end

Macro qylen_gates()

•Label left "QY \\u#2";DelayUpdate
•Label bottom "V\\Bg1,2\\M (V) \\u#2";DelayUpdate
•Label right "L\\Bint \\M(um)\\u#2";DelayUpdate
•SetAxis left 0,1.1
ModifyGraph tick=2,mirror(bottom)=1,btLen=3
end

Macro Labelres()

•Label left "\\u#2 Ipc (nA/W)";DelayUpdate
•Label bottom "Photon energy (eV)";DelayUpdate
•Label right "\\u#2  Absorption cross section(cm\\S2\\M/atom)";DelayUpdate
•SetAxis left 0,*;DelayUpdate
•SetAxis right 0,*

end

Function Ivg()
•Label bottom "V\\Bg\\M (V)"
•Label left "I\\Bsd\\M (A)"
end

Function IVsd()
•Label bottom "V\\Bsd\\M (V)"
•Label left "I\\Bsd\\M (A)"
end

Macro Resistance()

Label left "\\f02R\\f00 (k\\F'Symbol'W\\F'Arial')\\u#2"
Label bottom "\\f02V\\Bg\\M\\f00 (V)"
typgraph()
end

Macro ann()

Legend/C/N=text0/A=MC
colorize()
end

////       altering graphs

Function center(xmid) /// dont quite get this one. 
variable xmid

string windowname
windowname = winname(0,1)
wave w = CsrWaveRef(A)
//string wname = NameofWave(w)

variable xmax =pnt2x(w,dimsize(w,0))
variable xmin =pnt2x(w,0)
//variable xmiddle = (xmax +xmin)/2

//variable xpeak =wavemax(w)
variable smoothing =10
variable threshold =0

FindPeak/B=(smoothing)/I/M=(threshold)/P/Q w
variable peakpos=pnt2x(w,V_PeakLoc)

print peakpos

variable shift = xmid - peakpos
//variable shift = -peakpos


SetScale/I x (xmin+shift),(xmax+shift),"m", w

end

Function centerPC() /// dont quite get this one. 


string windowname
windowname = winname(0,1)
wave w = CsrWaveRef(A)
//string wname = NameofWave(w)

variable xmax =pnt2x(w,dimsize(w,0))
variable xmin =pnt2x(w,0)
//variable xmiddle = (xmax +xmin)/2

//variable xpeak =wavemax(w)
//variable smoothing =10
//variable threshold =0

//FindPeak/B=(smoothing)/I/M=(threshold)/P/Q w

wavestats/q w

variable peakpos=V_maxLoc

print peakpos

variable shift =  - peakpos



SetScale/I x (xmin+shift),(xmax+shift),"m", w

end




//takes the traces in a graph and alters them according to manipulatewave(below)
Function altergraph(var) // goes through traces on graph and passes to manipulate wave
variable var // this is the manipulation to do
	string windowname
	windowname = winname(0,1)
	
	string tracelist
	tracelist = TraceNameList(windowname,";",1)

	
	
	Variable index=0
	variable waveindex =0
	string ywave
	do
		// Get the next wave name
		ywave = StringFromList(index, tracelist)
		if ((strlen(ywave) == 0) )
			break							// Ran out of waves
		endif
		
		if(!(StringMatch(ywave,"fit_*")))
			if(var)
			ywave = ReplaceString("'",ywave,"")
			
			
			waveindex += 1
			if(var == 10)
			NVAR currentwave = root:asymmdata:currentwave
			currentwave = waveindex
			endif
			
			wave ywavewave = TraceNameToWaveRef(windowname,ywave)
			ManipulateWave(ywavewave, var)
			endif
		endif
		index += 1
	while (1)			
	
end


//Copies the traces in a graph and adds "endstr" to the wave name
Function newgraph(endstr)
string endstr
	string windowname
	windowname = winname(0,1)
	
	string tracelist
	tracelist = TraceNameList(windowname,";",1)
	
	string ann
	ann = StringFromList(13,AnnotationInfo(windowname,"text0"))
	ann= ReplaceString("TEXT:", ann,"" )
	
	
	Variable index=0

	string yold
	string ynew
	string xold
	string xnew
	wave y
	do
		// Get the next wave name
		yold = StringFromList(index, tracelist)
		if ((strlen(yold) == 0) )
			break							// Ran out of waves
		endif
		
		if(!(StringMatch(yold,"fit_*")))
			wave ywaveold = TraceNameToWaveRef(windowname,yold)
			setdatafolder GetWavesDataFolder(ywaveold, 1 )
			duplicate/o  ywaveold $(yold +endstr)
			wave ywavenew =  $(yold +endstr) 		
			//ynew = yold + endstr    // add tag onto name of new wave
			//duplicate/o ytemp  $ynew    
		
			ann= ReplaceString(yold, ann,ynew ) // change name in annotation
			
			wave xwaveold = XWaveRefFromTrace(windowname,yold)
			xold =nameofwave(xwaveold) // duplicate x wave
			//xnew = xold + endstr
			setdatafolder GetWavesDataFolder(xwaveold, 1 )
			duplicate/o xwaveold  $(xold + endstr)
			wave xwavenew =  $(xold +endstr) 	
		
		
			if (index == 0)				// Is this the first wave?
				Display ywavenew vs xwavenew
			else
				appendtograph ywavenew vs xwavenew
			endif
		endif
		index += 1
	while (1)			

//string cmd = "DoWindow/R/S=Graphstyle " + windowname + ";Graphstyle()"  //crappy way to copy graph style
//print cmd
//Execute cmd

ann = "\"" + ann + "\""
string cmd = "TextBox/C/N=text0 " + ann //cant get return characters to work so have to excecute this as well...
execute cmd

Label left "Isd (A)"
Label bottom "Vsd(V)"
end


Function colorize()
//takes a regular trace and appends the log of it to the right scale
	String fldrSav0= GetDataFolder(1)
	setdatafolder root:
	string windowname
	windowname = winname(0,1)
	
	string tracelist
	tracelist = TraceNameList(windowname,";",1)
	
	Variable index=0
	string ywave
	variable red, green, blue
	string annstring
	do
		// Get the next wave name
		ywave = StringFromList(index, tracelist)
		wave xwave = XWaveRefFromTrace(windowname, ywave)
		if ((strlen(ywave) == 0) )
			break							// Ran out of waves
		endif
		
		if(!(StringMatch(ywave,"fit_*")))
			
			
			//GetTraceColor(windowname,ywave,red,green,blue)
			//ywavenew = ywave +"#1"
			if(!Mod(index,6))
				ModifyGraph rgb($ywave)=(65535,0,0), zColor($ywave) =0
			elseif(!(Mod(index,6)-1))
				ModifyGraph rgb($ywave)=(0,0,65535),zColor($ywave) =0	
			elseif(!(Mod(index,6)-2))
				ModifyGraph rgb($ywave)=(0,65535,0),zColor($ywave) =0
			elseif(!(Mod(index,6)-3))
				ModifyGraph rgb($ywave)=(65280,43520,0),zColor($ywave) =0
			elseif(!(Mod(index,6)-4))
				ModifyGraph rgb($ywave)=(65280,0,52224),zColor($ywave) =0
			elseif(!(Mod(index,6)-5))
				ModifyGraph rgb($ywave)=(0,0,0),zColor($ywave) =0
			endif
			ModifyGraph lStyle($ywave)=trunc(index/6)
			//annstring =   "\\s(" + ywave + ")" 
			//Appendtext/N=text0 annstring
		endif
		index += 1
	while (1)	
	setdatafolder fldrSav0
end



//annotate the graph
Function annotate()

	string windowname
	windowname = winname(0,1)
	
	string tracelist
	tracelist = TraceNameList(windowname,";",1)

	
	
	Variable index=0
	string ywave
	do             //Looping is not the most efficient probably as all names are obtained first but...already working
		// Get the next wave name
		ywave = StringFromList(index, tracelist)
		
		if ((strlen(ywave) == 0) )
			break							// Ran out of waves
		endif
			
		ywave = ReplaceString("'",ywave,"")
		wave ywavewave = $ywave	
		string annstring
		if(index==0)
	
			annstring = "\\s('" + ywave + "')" + ywave 
			TextBox/C/N=text0/A=MC annstring
	
			else

			annstring =   "\\s('" + ywave + "')" + ywave 
			Appendtext/N=text0 annstring
		endif
			
		index += 1
	while (1)			
	
end




//kill wave and display only over selected range with cursors
Function graphrange()
string windowname
windowname = winname(0,1)
wave w = CsrWaveRef(A)
wave xw =  CsrXWaveRef(A)
string wname = NameofWave(w)

variable pa = pcsr(A)
variable pb = pcsr(B)
variable red, green,blue
GetTraceColor("",wname,red,green,blue)

RemoveFromGraph $wname

if(pb>pa)
Appendtograph w[pa,pb] vs xw[pa,pb]
else
Appendtograph w[pb,pa] vs xw[pb,pa]
endif

ModifyGraph rgb($wname) = (red,green,blue)
end

Function GetTraceColor(graph,trace,red,green,blue)
	String graph, trace
	Variable &red,&green,&blue
 
	String info = TraceInfo(graph,trace,0)
	String color=StringByKey("rgb(x)",info,"=")
	sscanf color,"(%d,%d,%d)",red,green,blue
End


Function logright()
//takes a regular trace and appends the log of it to the right scale
	setdatafolder root:
	string windowname
	windowname = winname(0,1)
	
	string tracelist
	tracelist = TraceNameList(windowname,";",1)
	
	Variable index=0
	string ywave
	variable red, green, blue
	string ywavenew
	string annstring
	do
		// Get the next wave name
		ywave = StringFromList(index, tracelist)
		wave xwave = XWaveRefFromTrace(windowname, ywave)
		if ((strlen(ywave) == 0) )
			break							// Ran out of waves
		endif
		
		if(!(StringMatch(ywave,"fit_*")))
			
			appendtograph/R $(ywave) vs xwave
			ModifyGraph log(right)=1
			Label right "Log"
			GetTraceColor(windowname,ywave,red,green,blue)
			ywavenew = ywave +"#1"
			ModifyGraph rgb($ywavenew)=(red,green,blue)
			annstring =   "\\s(" + ywavenew + ")" + "Log(" + ywave +")"
			Appendtext/N=text0 annstring
		endif
		index += 1
	while (1)	
	
end



Function Centergauss()

wave w = csrwaveref(A)
//variable x0= (hcsr(B)+hcsr(A))/2
variable x0= hcsr(A)

variable xl = dimoffset(w,0)
variable xr = xl+DimDelta(w,0)*(dimsize(w,0)-1)

print xl,xr

SetScale/I x (xl - x0),(xr -x0),"m", w;DelayUpdate

//print xl,xr,x0

end

Function offset()
wave w = csrwaveref(A)

variable offset = vcsr(A)

w-= offset
end


Function Scaleimg(fn)
string fn
Controlinfo Objective
variable objtype = V_Value -1

wave Imagewave = $"root:Images:" + fn

variable wsizex = dimsize(Imagewave,0)
variable wsizey = dimsize(Imagewave,1)

		variable imagesize
		prompt imagesize, "Image size (um):"
		DoPrompt "Enter Values", imagesize
print objtype

variable Scale
if(objtype)
 Scale = (0.1599e-6)*(imagesize/5)*(200/wsizex)
else 
 Scale = (.126e-6)*(imagesize/2)*(200/wsizex)
endif
SetScale/P x 0,Scale,"", Imagewave
SetScale/P y 0,Scale,"", Imagewave

end