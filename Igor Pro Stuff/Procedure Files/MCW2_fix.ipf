
#pragma rtGlobals=3        // Use strict wave reference mode

Window MCW() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(681,92,1277,545) as "MCW"
	ShowTools/A
	ShowInfo/W=MCW
	SetDrawLayer UserBack
	SetDrawEnv linefgc= (4352,4352,4352),fillpat= 3,fillfgc= (43520,43520,43520),fillbgc= (43520,43520,43520)
	DrawRect 15,296,352,402
	SetDrawEnv linefgc= (4352,4352,4352),fillpat= 3,fillfgc= (43520,43520,43520),fillbgc= (43520,43520,43520)
	DrawRect 65,19,395,113
	SetDrawEnv linefgc= (4352,4352,4352),fillpat= 3,fillfgc= (43520,43520,43520),fillbgc= (43520,43520,43520)
	DrawRect 400,17,529,116
	SetDrawEnv linefgc= (4352,4352,4352),fillpat= 3,fillfgc= (43520,43520,43520),fillbgc= (43520,43520,43520)
	DrawRect 21,120,554,285
	Button Load,pos={80,24},size={50,20},proc=ButtonProc_1,title="Load"
	Button Load,fColor=(61440,61440,61440)
	Button Loadimages,pos={428,28},size={80,20},proc=Loadimagebutton,title="Load Images"
	Button Loadimages,fColor=(61440,61440,61440)
	CheckBox Imageheader,pos={417,89},size={102,14},title="Get image header"
	CheckBox Imageheader,value= 1
	Button loadres,pos={76,124},size={60,20},proc=Loadresbutton,title="Load Res"
	Button loadres,fColor=(61440,61440,61440)
	Button Loadpow,pos={212,124},size={60,20},proc=Powbutton,title="Load pow"
	Button Loadpow,fColor=(61440,61440,61440)
	ListBox reslist,pos={27,150},size={169,99},listWave=root:Spectral:reswavelist
	ListBox reslist,selWave=root:Spectral:reswavelistSel,mode= 4
	ListBox powlist,pos={197,149},size={174,100},listWave=root:Spectral:powwavelist
	ListBox powlist,selWave=root:Spectral:powwavelistSel,mode= 4
	Button Normalizebutton,pos={349,122},size={60,20},proc=NormalizeButton,title="Normalize"
	Button Normalizebutton,fColor=(61440,61440,61440)
	SetVariable powname,pos={277,126},size={50,16},value= _STR:"vis"
	ListBox Normlist,pos={371,149},size={178,100}
	ListBox Normlist,listWave=root:Spectral:normwavelist
	ListBox Normlist,selWave=root:Spectral:normwavelistSel,mode= 4
	Button refreshbutton,pos={369,254},size={50,20},proc=refreshbutton,title="Refresh"
	Button refreshbutton,fColor=(61440,61440,61440)
	Button Displaybutton,pos={217,255},size={50,20},proc=displaybutton,title="Display"
	Button Displaybutton,fColor=(61440,61440,61440)
	PopupMenu evornm,pos={278,254},size={45,22}
	PopupMenu evornm,mode=1,popvalue="eV",value= #"\"eV;nm\""
	PopupMenu dataset,pos={155,336},size={106,22}
	PopupMenu dataset,mode=4,popvalue="CNTAtlas_calc",value= #"\"Atlas_zero;Columbia;CNTAtlas_epd;CNTAtlas_calc;CNTAtlas_calc_met\""
	Button Chiral,pos={153,305},size={60,20},proc=ChiralButon,title="Do Chiral"
	Button Chiral,fColor=(61440,61440,61440)
	ListBox Devicelist,pos={25,301},size={59,48}
	ListBox Devicelist,listWave=root:Spectral:Peaks:Devicelist,mode= 1,selRow= 0
	PopupMenu smormet,pos={216,305},size={46,22}
	PopupMenu smormet,mode=1,popvalue="SM",value= #"\"SM;Met\""
	Button dispreslist,pos={156,371},size={50,20},proc=displayreslist,title="Dispreslist"
	Button dispreslist,fColor=(61440,61440,61440)
	CheckBox Samegraph,pos={309,56},size={77,14},title="Same Graph",value= 1
	Button Delete,pos={85,257},size={50,20},proc=Delete,title="Delete"
	Button Delete,fColor=(61440,61440,61440)
	CheckBox oldres,pos={142,127},size={62,14},title="Old Res?",value= 0
	Button loadapp,pos={137,26},size={62,19},proc=Loadappbutton,title="Load App"
	Button loadapp,fColor=(61440,61440,61440)
	Button logright,pos={297,80},size={50,20},proc=logrightbutton,title="Log Right"
	Button Rename,pos={140,256},size={50,20},proc=RenameButton,title="Rename"
	SetVariable appstr,pos={85,56},size={136,16},title="Append string"
	SetVariable appstr,value= _STR:""
	SetVariable prestr,pos={81,81},size={136,16},title="Prepend string"
	SetVariable prestr,value= _STR:""
	Button Notes,pos={491,126},size={50,20},proc=Notesbutton,title="Notes"
	Button LeftRight,pos={237,82},size={50,20},proc=LeftRightButton,title="LeftRight"
	SetVariable headerlines,pos={232,55},size={66,16},title="# lines",value= _NUM:2
	Button DeviceTable,pos={498,298},size={63,20},proc=Devtablebutton,title="Dev Table"
	Button Altergraphbutton,pos={364,381},size={63,21},proc=Altergraphbutton,title="Alter Graph"
	SetVariable Altergraphnum,pos={435,382},size={74,16},title="Type",value= _NUM:8
	Button gatebias,pos={497,323},size={67,21},proc=Resultstablebuttion,title="Results table"
	ListBox Peaklist,pos={89,301},size={58,89}
	ListBox Peaklist,listWave=root:Spectral:Peaks:Dev1_text
	ListBox Peaklist,selWave=root:Spectral:Peaks:Dev1_sel,mode= 4
	Button editdevicebutton,pos={26,364},size={50,20},proc=Editdevicebutton,title="Edit"
	Button Calcabcs,pos={289,325},size={50,20},proc=Calcabcsbutton,title="Calc Abs"
	SetVariable n,pos={276,304},size={35,16},title="n"
	SetVariable n,limits={-inf,inf,0},value= _NUM:22
	SetVariable m,pos={314,304},size={35,16},title="m"
	SetVariable m,limits={-inf,inf,0},value= _NUM:15
	CheckBox appendright,pos={271,350},size={78,14},title="Append right",value= 0
	Button annotate,pos={270,24},size={50,20},proc=annbutton,title="ann"
	SetVariable devicenumber,pos={367,299},size={89,16},title="Dev num"
	SetVariable devicenumber,value= _NUM:1
	CheckBox peratom,pos={270,370},size={67,14},title="Per Atom?",value= 0
	PopupMenu Objective,pos={418,57},size={99,22},title="Objective"
	PopupMenu Objective,mode=1,popvalue="50X",value= #"\"50X;100X\""
	Button Loaddelft,pos={211,24},size={50,20},proc=Loaddelftbutton,title="LD"
	SetVariable Bias,pos={518,381},size={73,16},title="Bias(5)",value= _NUM:10
	SetVariable newgraphname,pos={444,355},size={128,16},title="Newgraph name"
	SetVariable newgraphname,value= _STR:"R"
	Button Newgraph,pos={363,354},size={68,21},proc=Newgraphbutton,title="New graph"
	Button fit1cs,pos={362,323},size={50,20},proc=Fit1csbutton,title="Fit1cs"
	SetVariable qyfitval,pos={419,326},size={66,16},title="QY fit",value= _NUM:0
	Button offset,pos={363,415},size={50,20},proc=offsetbutton,title="offset"
	Button centergauss,pos={417,414},size={66,20},proc=centergaussbutton,title="centergauss"
	SetVariable Cs_string,pos={15,413},size={246,16},title="Cross section name"
	SetVariable Cs_string,value= _STR:"PC_test"
	Button grabxsectionbut,pos={273,412},size={73,19},proc=Grabxsectionbutton,title="grabxsection"
	Button Typgraphbut,pos={326,24},size={60,20},proc=typicalgraphbutton,title="Typ. graph"
EndMacro



Function fixdatafolders()

newdatafolder/o root:Spectral
	newdatafolder/o root:spectral:Resonance
	newdatafolder/o root:spectral:Power
	newdatafolder/o root:spectral:Normalized
	newdatafolder/o root:spectral:xwaves
	newdatafolder/o root:spectral:Peaks
	newdatafolder/o root:spectral:Calculated
		newdatafolder/o root:spectral:Calculated:PCtoAbCS
	newdatafolder/o root:spectral:FF
		newdatafolder/o root:spectral:FF:Calculated
	newdatafolder/o root:spectral:Chiraldata
		newdatafolder/o root:spectral:Chiraldata:reslines
				
newdatafolder/o root:QE
	newdatafolder/o root:QE:DeviceData
		
newdatafolder/o root:crosssections



setdatafolder root:spectral

	make/o/t/n=0 reswavelist
	make/o/t/n=0 powwavelist
	make/o/t/n=0 normwavelist
	
	make/o/U/n=0 reswavelistSel
	make/o/U/n=0 powwavelistSel
	make/o/U/n=0 normwavelistSel
		

setdatafolder root:spectral:peaks

	make/o/t/n=2 Devicelist
	Devicelist[0] = "Dev1"
	Devicelist[1] = "Dev2"
	
	make/o/t/n=3 Dev1_text
	make/o/t/n=3 Dev2_text
	make/o/n=3 Dev1
	make/o/n=3 Dev2
	make/o/U/n=3 Dev1_sel
	make/o/U/n=3 Dev2_sel

setdatafolder root:spectral:FF
	LoadWave/O/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:FF:cs_x_newfoc_nt105_NA8_.ibw"
	LoadWave/O/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:FF:cs_x_newfoc_nt105_noplug_.ibw"
	LoadWave/O/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:FF:cs_x_newPW_nt105_noplug_.ibw"

setdatafolder root:spectral:Chiraldata
	LoadWave/o/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:Atlas:CNTAtlas_calc.ibw"
	LoadWave/o/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:Atlas:CNTAtlas_zero.ibw"
	LoadWave/o/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:Atlas:CNTAtlas_epd.ibw"
	LoadWave/o/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:Atlas:ColumbiaData.ibw"
	LoadWave/o/H "C:Users:aspitarl:Desktop:T Drive Backup:Analysis:Files:Atlas:CNTAtlas_calc_met.ibw"
	
setdatafolder root:QE


	make/o/t Image
	//make/n=5 peakPC,bias,gates,PCaval,Power,OD,PowerOD,eV,diam,EQEpeak
	make/o  gates,bias,QY_fit, Length

setdatafolder root:QE:DeviceData

	make/o/t/n=5 Device
	make/o/n=5 Ep,Power,sigmaL,avalbeam,FF2,qy
	make/D/o/n=4 fit_coef

end


Function fixdatafolderst()

newdatafolder/o root:Spectral
	newdatafolder/o root:spectral:Resonance
	newdatafolder/o root:spectral:Power
	newdatafolder/o root:spectral:Normalized
	newdatafolder/o root:spectral:xwaves
	newdatafolder/o root:spectral:Peaks
	newdatafolder/o root:spectral:Calculated
		newdatafolder/o root:spectral:Calculated:PCtoAbCS
	newdatafolder/o root:spectral:FF
		newdatafolder/o root:spectral:FF:Calculated
	newdatafolder/o root:spectral:Chiraldata
		newdatafolder/o root:spectral:Chiraldata:reslines
				
newdatafolder/o root:QE
	newdatafolder/o root:QE:DeviceData
		
newdatafolder/o root:crosssections



setdatafolder root:spectral

	make/o/t/n=0 reswavelist
	make/o/t/n=0 powwavelist
	make/o/t/n=0 normwavelist
	
	make/o/U/n=0 reswavelistSel
	make/o/U/n=0 powwavelistSel
	make/o/U/n=0 normwavelistSel
		

setdatafolder root:spectral:peaks

	make/o/t/n=2 Devicelist
	Devicelist[0] = "Dev1"
	Devicelist[1] = "Dev2"
	
	make/o/t/n=3 Dev1_text
	make/o/t/n=3 Dev2_text
	make/o/n=3 Dev1
	make/o/n=3 Dev2
	make/o/U/n=3 Dev1_sel
	make/o/U/n=3 Dev2_sel

setdatafolder root:spectral:FF
	LoadWave/O/H "T:Physics:Minot Group:Lee:Analysis:Files:FF:cs_x_newfoc_nt105_NA8_.ibw"
	LoadWave/O/H "T:Physics:Minot Group:Lee:Analysis:Files:FF:cs_x_newfoc_nt105_noplug_.ibw"
	LoadWave/O/H "T:Physics:Minot Group:Lee:Analysis:Files:FF:cs_x_newPW_nt105_noplug_.ibw"

setdatafolder root:spectral:Chiraldata
	LoadWave/o/H "T:Physics:Minot Group:Lee:Analysis:Files:Atlas:CNTAtlas_calc.ibw"
	LoadWave/o/H "T:Physics:Minot Group:Lee:Analysis:Files:Atlas:CNTAtlas_zero.ibw"
	LoadWave/o/H "T:Physics:Minot Group:Lee:Analysis:Files:Atlas:CNTAtlas_epd.ibw"
	LoadWave/o/H "T:Physics:Minot Group:Lee:Analysis:Files:Atlas:ColumbiaData.ibw"
	
setdatafolder root:QE


	make/o/t Image
	//make/n=5 peakPC,bias,gates,PCaval,Power,OD,PowerOD,eV,diam,EQEpeak
	make/o  gates,bias,QY_fit, Length

setdatafolder root:QE:DeviceData

	make/o/t/n=5 Device
	make/o/n=5 Ep,Power,sigmaL,avalbeam,FF2,qy
	make/D/o/n=4 fit_coef

end

Function ButtonProc_1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			//Controlinfo Loadnum
			//if(V_Value ==1)
			//Load()
			//elseif(V_Value>1)
			//Loadapp(V_Value)
			Loaddialog(1)
			//else
			//print "Enter the number of files you want to load"
			//endif
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function Loadappbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			loaddialog(0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End






Function Loadimagebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	variable numimage
	variable header
	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo Imageheader
			header = V_Value
			Controlinfo Objective
			variable objectivetype = V_Value
			Loadimageheader(header,(objectivetype-1))  //0 for 50X 1 for 100X
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Loadresbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo resname
			Loadresdialog(0)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function refreshbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			refreshpanel()
			
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

function refreshpanel()
//Updates the resonance/power panels

variable numwaves 

setdatafolder root:spectral:   //these lists are used 
wave/t reswavelist = reswavelist
wave/t powwavelist = powwavelist
wave/t normwavelist = normwavelist
//wave/t peakwavelist = peakwavelist

//count up the names of the resonances/power in each folder and add to the list
numwaves = CountObjects(":resonance:",1)
redimension/N=(numwaves) reswavelist
variable i
for(i=0; i<numwaves; i=i+1)
	reswavelist[i] = GetIndexedObjName(":resonance:", 1, i )
endfor

numwaves = CountObjects(":power:",1)
redimension/N=(numwaves) powwavelist
for(i=0; i<numwaves; i=i+1)
	powwavelist[i] = GetIndexedObjName(":power:", 1, i )
endfor

numwaves = CountObjects(":normalized:",1)
redimension/N=(numwaves) normwavelist
for(i=0; i<numwaves; i=i+1)
	normwavelist[i] = GetIndexedObjName(":normalized:", 1, i )
endfor


//Think the following is obsolete

//numwaves = CountObjects(":peaks:",1)
//redimension/N=(numwaves) peakwavelist
//for(i=0; i<numwaves; i=i+1)
//	peakwavelist[i] = GetIndexedObjName(":peaks:", 1, i )
//endfor


updatesellists()
end

Function updatesellists()
setdatafolder root:spectral
wave/t reswavelist = reswavelist
wave/t powwavelist = powwavelist
wave/t normwavelist = normwavelist
wave/t reswavelistSel = reswavelistSel
wave/t powwavelistSel = powwavelistSel
wave/t normwavelistSel = normwavelistSel
redimension/n=(dimsize(reswavelist,0)) reswavelistsel
redimension/n=(dimsize(powwavelist,0)) powwavelistsel
redimension/n=(dimsize(normwavelist,0)) normwavelistsel


//refresh chiral fit area

setdatafolder root:spectral:peaks

DFREF dfr = GetDataFolderDFR()	

variable numwaves = CountObjects("", 1 )

make/o/t/n=(0) Devicelist

variable i
variable numvarwaves =0
for(i=0; i<numwaves;i=i+1)

string currentwavename = GetIndexedObjnameDFR(dfr, 1, i)
wave currentwave = $currentwavename


if(wavetype($currentwavename)==2)
numvarwaves +=1
make/o/t/n=(dimsize(currentwave,0)) $(currentwavename +"_text") = num2str(currentwave)
make/W/U/o/n=(dimsize(currentwave,0)) $(currentwavename +"_sel") 
wave textwave = $(currentwavename +"_text")

Redimension/N=(Numvarwaves) Devicelist
Devicelist[numvarwaves-1] = currentwavename

endif
endfor

Controlinfo/W=MCW Devicelist

string devicestr = devicelist[V_Value]
wave devicewave = $(devicestr + "_text")
wave deviceselwave = $(devicestr + "_sel")

ListBox Peaklist listWave=devicewave, selWave= deviceselwave, win=MCW


end


Function NormalizeButton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			normalize()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End




function normalize()

//Normalize the selected resonances by power
setdatafolder root:spectral:
wave/t reswavelist = reswavelist
wave/t powwavelist = powwavelist
wave reswavelistsel = reswavelistsel
wave powwavelistsel = powwavelistsel

variable i
variable rescount = 0 
for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
	rescount = rescount + reswavelistsel[i]
endfor

variable powcount = 0 
for(i=0; i<dimsize(powwavelistsel,0); i=i+1)
	powcount = powcount + powwavelistsel[i]
	if(powwavelistsel[i])
		string powstring = powwavelist[i]

	endif
endfor

if(powcount != 1)//exit if not only one pow wave sel
return 0
endif

string resstring

for(i=0 ; i< rescount; i=i+1)
	for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
		 resstring = reswavelist[i]
		 
		 if(reswavelistsel[i])
		 
			normalizewaves(resstring,powstring)   //the actual normalization

		
		endif
	endfor
endfor
end

Function Normalizewaves(resstring, powstring)//having issues with redeclaring wave in for loop. derp, is because not changing folder
string resstring, powstring
setdatafolder root:spectral:
variable sizeres, sizepow, spaceres, spacepow
variable offset
			
		 	
WAVE res = $(":resonance:" + resstring)
WAVE nmres = $(":xwaves:" + resstring + "nm")
wave pow = $(":power:" + powstring)
wave nmpow = $(":xwaves:" + powstring + "nm")	

			

//get size and spacing of waves
sizeres = dimsize(res, 0)
sizepow = dimsize(pow, 0)

spaceres = nmres[2] - nmres[1]
spacepow = nmpow[2] - nmpow[1]

offset = (nmres[0] - nmpow[0])/spacepow


setdatafolder root:spectral:normalized:
make/o/n=(sizeres) resn

resn[] = res[p]/pow[p+offset]

//add a note
Note/K resn  "Original filename " + resstring + "\rNormalized by " + powstring
Note resn  "Resonance wave spacing: "+  num2str(spaceres) + " \rResonance nm range:" + num2str(nmres[0])+ "-"+ num2str(nmres[sizeres-1] )
Note resn "Power wave spacing: " +   num2str(spacepow)  +" \rPower nm range:" + num2str(nmpow[0]) + "-" + num2str(nmpow[sizepow-1]) 


rename resn $resstring
			waveclear res
 	waveclear nmres	

end

Function displaybutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			displayreswaves()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

function displayreswaves()
//old one at bottom
setdatafolder root:spectral:
wave/t reswavelist = reswavelist
wave/t powwavelist = powwavelist
wave/t normwavelist = normwavelist
wave reswavelistSel = reswavelistSel
wave powwavelistSel = powwavelistSel
wave normwavelistSel = normwavelistSel
variable i
variable graphmade =0
string annstring

//unnormalized resonances same strucutre for others below
controlinfo/W=MCW reslist
if(V_Value != -1) //selected?
	for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
		string resstring = reswavelist[i]
		Controlinfo/W=MCW evornm
		if(reswavelistsel[i])
			if(graphmade==0) // If first graph then display
				if(V_Value ==1)
					display/K=1 $(":resonance:" + resstring) vs $(":xwaves:" + resstring + "eV")
					Label left "UnNormalized Photocurrent (A/W)"
					Label bottom "Photon Energy(eV)"
				elseif(V_Value==2)
					display/K=1 $(":resonance:" + resstring) vs $(":xwaves:" + resstring + "nm")
					Label left "UnNormalized Photocurrent (A/W)"
					Label bottom "Wavelength(nm)"
				endif
				annstring = "\\s(" + resstring + ")" + resstring
				TextBox/C/N=text0/A=MC annstring
				graphmade=1
			
			else  // if already graph append
				if(V_Value ==1)
					appendtograph $(":resonance:" + resstring) vs $(":xwaves:" + resstring + "eV")
				elseif(V_Value==2)
					appendtograph $(":resonance:" + resstring) vs $(":xwaves:" + resstring + "nm")
				endif
				annstring =   "\\s(" + resstring + ")" + resstring
				Appendtext/N=text0 annstring
			endif
		endif
	endfor
endif
graphmade=0

//power 
controlinfo/W=MCW powlist
if(V_Value != -1)
	for(i=0; i<dimsize(powwavelistsel,0); i=i+1)
		string powstring = powwavelist[i]
		Controlinfo/W=MCW evornm
		if(powwavelistsel[i])
			if(graphmade==0)
				if(V_Value ==1)
					display/K=1 $(":power:" + powstring) vs $(":xwaves:" + powstring + "eV")
					Label left "Power (W)"
					Label bottom "Photon Energy(eV)"
				elseif(V_Value==2)
					display/K=1 $(":power:" + powstring) vs $(":xwaves:" + powstring + "nm")
					Label left "Power (W)"
					Label bottom "Wavelength(nm)"
				endif
				annstring = "\\s(" + powstring + ")" + powstring
				TextBox/C/N=text0/A=MC annstring
				graphmade=1
			
			else
				if(V_Value ==1)
					appendtograph $(":power:" + powstring) vs $(":xwaves:" + powstring + "eV")
				elseif(V_Value==2)
					appendtograph $(":power:" + powstring) vs $(":xwaves:" + powstring + "nm")
				endif
				annstring =   "\\s(" + powstring + ")" + powstring
				Appendtext/N=text0 annstring
			endif
		endif
	endfor
endif
graphmade=0




//normalized resonances
controlinfo/W=MCW normlist
if(V_Value != -1)
	for(i=0; i<dimsize(normwavelistsel,0); i=i+1)
		string normstring = normwavelist[i]
		Controlinfo/W=MCW evornm
		if(normwavelistsel[i])
			if(graphmade==0)
				if(V_Value ==1)
					display/K=1 $(":normalized:" + normstring) vs $(":xwaves:" + normstring   + "eV")
					Label left "Normalized Photocurrent (A/W)"
					Label bottom "Photon Energy(eV)"
				elseif(V_Value==2)
					display/K=1 $(":normalized:" + normstring) vs $(":xwaves:" + normstring + "nm")
					Label left "Normalized Photocurrent (A/W)"
					Label bottom "Wavelength(nm)"
				endif
				annstring = "\\s(" + normstring + ")" + normstring
				TextBox/C/N=text0/A=MC annstring
				graphmade=1
			
			else
				if(V_Value ==1)
					appendtograph $(":normalized:" + normstring) vs $(":xwaves:" + normstring   + "eV")
				elseif(V_Value==2)
					appendtograph $(":normalized:" + normstring) vs $(":xwaves:" + normstring + "nm")
				endif
				annstring =   "\\s(" + normstring + ")" + normstring
				Appendtext/N=text0 annstring
			endif
		endif
	endfor
endif
graphmade=0



//if(V_Value != -1)
//	string normstring = normwavelist[V_Value]
//	Controlinfo/W=MCW evornm
//	if(V_Value ==1)
//	display/K=1 $(":normalized:" + normstring) vs $(":xwaves:" + normstring   + "eV")
//	Label left "Normalized Photocurrent (A/W)"
//	Label bottom "Photon Energy(eV)"
//	elseif(V_Value==2)
//	display/K=1 $(":normalized:" + normstring) vs $(":xwaves:" + normstring + "nm")
//	Label left "Normalized Photocurrent (A/W)"
//	Label bottom "Wavelength(nm)"
//	endif
//endif

end

Function ChiralButon(ba) : ButtonControl
	STRUCT WMButtonAction &ba


	switch( ba.eventCode )
		case 2: // mouse up
			dochiral()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


function dochiral()
//sets up chiral fitting with info from mcw
	setdatafolder root:spectral:
	//wave/t peakwavelist = peakwavelist
	refreshpanel()
	
	//string peakwavename = peakwavelist[V_Value]
	//wave peakwave = $(":peaks:" + peakwavename)

	//Controlinfo pcol
	//peakwavecol[] = peakwave[p][V_Value]
	//Controlinfo numpeaks
	//variable num = V_Value
	

	
	Controlinfo/W=MCW devicelist
	setdatafolder root:spectral:peaks
	
	wave/t devicelist = devicelist
	
	string peakwavename = devicelist[V_Value]
	
	wave peakwave = $peakwavename
	wave peakwavesel = $(peakwavename + "_sel")
	
	setdatafolder root:temp:
	make/o/n=(dimsize(peakwave,0)) peakwavecut
	
	variable i
	variable numpeaks = 0
	
	for(i=0;i<dimsize(peakwave,0);i=i+1)
	
	if(peakwavesel[i] == 1)
		numpeaks=numpeaks+1
		peakwavecut[numpeaks-1] = peakwave[i]
	endif
	
	endfor
	
	redimension/n=(numpeaks) peakwavecut
	
	print peakwavecut,numpeaks
	
	Controlinfo dataset
	variable set = V_Value
	Controlinfo smormet
	Variable type
	if(V_Value ==1)
		type = 1
	elseif(V_Value == 2)
		type = 0
	endif
	if(set ==1)
		makereslist(peakwavecut,numpeaks,root:spectral:Chiraldata:CNTAtlas_zero, 1,type)
	elseif(set ==2)
		makereslist(peakwavecut,numpeaks,root:spectral:Chiraldata:Columbiadata, 0,type)
	elseif(set ==3)
		makereslist(peakwavecut,numpeaks,root:spectral:Chiraldata:CNTAtlas_epd, 0,type)
	elseif(set ==4)
		makereslist(peakwavecut,numpeaks,root:spectral:Chiraldata:CNTAtlas_calc, 0,type)
	elseif(set ==5)
		makereslist(peakwavecut,numpeaks,root:spectral:Chiraldata:CNTAtlas_calc_met, 0,type)
	endif
end

Function Integratebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Integrateres()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

function integrateres()
//integrates a certian range of a resonacne wave to compare to absorption or something. old
controlinfo normlist

if(V_Value != -1)
	setdatafolder root:spectral:
	wave/t normwavelist = normwavelist
	string normstring = normwavelist[V_Value]
	wave normwave = $("root:spectral:normalized:" + normstring)
	wave normev = $("root:spectral:xwaves:" + normstring + "eV")
	setdatafolder root:spectral:xwaves:
	duplicate/o normeV normeVint
	normeVint[] = normeV[dimsize(normeV,0)-p-1]
	Redimension/N=(dimsize(normeV,0)+1) normeVint
	normeVint[dimsize(normeV,0)] = 2*normeVint[dimsize(normeV,0)-1] - normeVint[dimsize(normeV,0)-2]
	setdatafolder root:spectral:normalized:
	string intstring = normstring +"int"
	make/o/n=(dimsize(normwave,0)) $intstring
	wave int = $intstring
	int[] = normwave[dimsize(normwave,0) - p -1]
	display int vs normeVint
	Integrate int /X=normeVint
	display/k=1 normwave vs normeV
	appendtograph/R int vs normeVint
	label left "Normalized Photocurrent (A/W)"
	label bottom "Photon Energy (eV)"
	label right "Integrated Photocurrent (A/W) eV"
	
endif
end

Function intcsbutton(ba) : ButtonControl

//given p and d what is sigma p. also comes up with a conversion factor for photocurrent to absorption cross seciton by dividing the fittted lorentzian area. 
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			string win = winname(0,1)
			if(!stringmatch(win, ""))
			variable intval = abs(vcsr(A) - vcsr(B))
			variable eVrange = abs(hcsr(A) - hcsr(B))  
			//print "integral:" + num2str(intval)
			//print "range:" + num2str(eVrange)
			Controlinfo diam
			variable d = V_Value
			variable siga = 7.6e-18*(eVrange/.93)*((4*pi*d)/(sqrt(3)*(.249^2)))*1e3 //?????
			//print "intcs/micron:" + num2str(intcs)
			//print "conversion(cm^2/(A/W)):" + num2str(intcs/intval)
			SetVariable dispsiga value=_NUM:(siga)
			SetVariable sigaconv value=_NUM:(siga/intval)
			endif
			ControlInfo pp
			variable p = V_Value
			SetVariable dispsigp value=_NUM:(intcs(p,d))
			Controlinfo PCpeakarea
			SetVariable sigpconv value=_NUM:(intcs(p,d)/V_Value*1e-6)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Function Delete(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Deletefn()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Deletefn()
//deletes selected waves
setdatafolder root:spectral:
wave/t reswavelist = reswavelist
wave/t powwavelist = powwavelist
wave/t normwavelist = normwavelist
wave reswavelistSel = reswavelistSel
wave powwavelistSel = powwavelistSel
wave normwavelistSel = normwavelistSel
variable i

for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
	if(reswavelistsel[i])
		string resstring = reswavelist[i]
		Killwaves $(":resonance:" + resstring)
		Killwaves $(":xwaves:" + resstring + "eV")
		Killwaves $(":xwaves:" + resstring + "nm")
	endif
endfor

for(i=0; i<dimsize(powwavelistsel,0); i=i+1)
	if(powwavelistsel[i])
		string powstring = powwavelist[i]
		Killwaves $(":power:" + powstring)
		Killwaves $(":xwaves:" + powstring + "eV")
		Killwaves $(":xwaves:" + powstring + "nm")
	endif
endfor


//controlinfo/W=MCW powlist
//if(V_Value != -1)
//	string powstring = powwavelist[V_Value]
//	Killwaves $(":power:" + powstring), $(":xwaves:" + powstring + "eV"),$(":xwaves:" + powstring + "nm")
//endif
for(i=0; i<dimsize(normwavelistsel,0); i=i+1)
	if(normwavelistsel[i])
		string normstring = normwavelist[i]
		Killwaves $(":Normalized:" + normstring)
		//Killwaves $(":xwaves:" + normstring + "eV")
		//Killwaves $(":xwaves:" + normstring + "nm")
	endif
endfor

end

Function logrightbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			logright()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function RenameButton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			RenameFunction()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function Renamefunction()
//renames a selected wave

setdatafolder root:spectral:
wave/t reswavelist = reswavelist
wave/t powwavelist = powwavelist
wave/t normwavelist = normwavelist
wave reswavelistSel = reswavelistSel
wave powwavelistSel = powwavelistSel
wave normwavelistSel = normwavelistSel
variable i
string newname
string promptstr
string evstr
string nmstr
string normstr

for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
	if(reswavelistsel[i])
		string resstring = reswavelist[i]
		newname = resstring
		promptstr = "Rename " + resstring + " to"
		Prompt newname , promptstr
		DoPrompt "Rename Unnormalized res", newname
		if(!(V_Flag))
			Rename $(":resonance:" + resstring) $newname
			evstr = newname + "eV"
			nmstr = newname + "nm"
			Rename $(":xwaves:" + resstring + "eV") $evstr
			Rename $(":xwaves:" + resstring + "nm") $nmstr
			
			normstr = (":normalized:" + resstring)
			if(waveexists($normstr))
				Rename $(":normalized:" + resstring) $newname
			endif
		endif
	endif
endfor

for(i=0; i<dimsize(powwavelistsel,0); i=i+1)
	if(powwavelistsel[i])
		string powstring = powwavelist[i]
		newname = powstring
	
		promptstr = "Rename " + powstring + " to"
		Prompt newname , promptstr
		DoPrompt "Rename Power", newname
		if(!(V_Flag))
			Rename $(":power:" + powstring) $newname
			evstr = newname + "eV"
			nmstr = newname + "nm"
			Rename $(":xwaves:" + powstring + "eV") $evstr
			Rename $(":xwaves:" + powstring + "nm") $nmstr
		endif
	endif
endfor

//for(i=0; i<dimsize(normwavelistsel,0); i=i+1)
//	if(normwavelistsel[i])
//		string normstring = normwavelist[i]
//		promptstr = "Rename " + normstring + " to"
//		Prompt newname , promptstr
//		DoPrompt "Rename Normalized Res", newname
//		if(!(V_Flag))
//			Rename $(":Normalized:" + normstring) $newname
//			evstr = newname + "eV"
//			nmstr = newname + "nm"
//			Rename $(":xwaves:" + normstring + "eV") $evstr
//			Rename $(":xwaves:" + normstring + "nm") $nmstr
//		endif
//	endif
//endfor

end



Function Notesbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			 Execute "Notespanel()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function LeftRightButton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Altergraph(6)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Colorizebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			colorize()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Powbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo powname
			Loadresdialog(1)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function Devtablebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			 Execute "Devicetable()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Altergraphbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			controlinfo/W=MCW Altergraphnum
			print V_Value
			altergraph(V_Value)  //gets wave from each trace and applies manipulatewave() to each function
			
			//takes a trace and alters it
//1=absolute value of graph
//2=absolute value and ln
//3= exponential of graph
//4 = divide by I0/T (Gabor)
//5= convert to conductivity
//6 add lr red blue to colors
//7 fitpccs
//8 inverse
//9 trim
//10 asymmetry (for narrow gap tubes)
//11 subtract offset resonance average of 380-390

//manipulatewave()    <--- go here to see options
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Resultstablebuttion(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			execute "gatebias()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Calcabcsbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo/W=MCW n
			variable n = V_Value
			Controlinfo/W=MCW m
			variable m = V_Value
			controlinfo/W=MCW  dataset
			string datasetname = S_value
			variable dataset = V_Value
			
			
			if(dataset ==1)
				wave datasetwave = root:spectral:Chiraldata:CNTAtlas_zero
			elseif(dataset ==2)
				wave datasetwave = root:spectral:Chiraldata:Columbiadata
			elseif(dataset ==3)
				wave datasetwave = root:spectral:Chiraldata:CNTAtlas_epd
			elseif(dataset ==4)
				wave datasetwave = root:spectral:Chiraldata:CNTAtlas_calc
			elseif(dataset ==5)
				wave datasetwave = root:spectral:Chiraldata:CNTAtlas_calc_met
			endif
			
			string calcname = "calc_" + num2str(n) + "_" + num2str(m) + "_" + datasetname
			
			variable row = getnm(n,m,datasetwave)
			
			calcspectabcs(row,calcname,datasetwave)
			
			Controlinfo/W=mcw appendright
			
			if(V_value)
			setdatafolder root:spectral:calculated
			
			appendtograph/R $calcname
			
			endif
			
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function getnm(n,m,datasetwave)
variable n, m
wave datasetwave
	


variable row =0

for(row=0;row<dimsize(datasetwave,0);row=row+1)

if(datasetwave[row][0] == n)
	if(datasetwave[row][1] == m)
		return row
		
	endif
endif


endfor


end




Function Editdevicebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo/W=MCW Devicelist
			wave/t Devicelist = root:spectral:peaks:Devicelist
			string devicestr = Devicelist[V_Value]
			edit/k=1 $("root:spectral:peaks:" + devicestr)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function annbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			execute "ann()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Function makefolders()

setdatafolder root:spectral:peaks
make/o/t/n=2 Devicelist
make/o/t/n=2 Dev1_text
make/U/o/n=2 Dev1_sel

end

Function displayreslist(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			edit/k=1 root:spectral:reslist
			Modifytable horizontalindex=2
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Function Loaddelftbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			loadd(1)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Newgraphbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Controlinfo/W=MCW newgraphname
			newgraph(S_Value)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Fit1csbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			wave ywave = csrwaveref(A)
			fitcspcref(ywave)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function offsetbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			offset()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function centergaussbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			centergauss()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Function Grabxsectionbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Controlinfo/W=MCW Cs_string
			string Csname = S_Value
			grabxsection(Csname)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function typicalgraphbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			typgraph()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function resnotebutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			printresnote()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


function printresnote()

//Normalize the selected resonances by power
setdatafolder root:spectral:
wave/t reswavelist = reswavelist
wave reswavelistsel = reswavelistsel

variable i
variable rescount = 0 
for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
	rescount = rescount + reswavelistsel[i]
endfor

string resstring
string resnote

for(i=0 ; i< rescount; i=i+1)
	for(i=0; i<dimsize(reswavelistsel,0); i=i+1)
		 resstring = reswavelist[i]
		if(reswavelistsel[i])
		 
			WAVE res = $(":resonance:" + resstring)
			resnote = note(res)
			print resnote
		
		endif
	endfor
endfor
end


end