#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function Loadd(app)
variable app //was load or loadapp pressed 1 = load
setdatafolder root:
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
	
	wnamevg =  prestr + tempstr + "_" + S_Value +appstr
	
	wnameisd = prestr + "Isd_" + S_Value + appstr
	
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
