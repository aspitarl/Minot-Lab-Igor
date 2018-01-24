#pragma rtGlobals=3		// Use modern global access method and strict wave access.




Function ReadHeader(header,numheaderlines, Filename, l, refnum)
		String &header 
		variable numheaderlines 
		String filename
		variable l
		Variable refnum
		
		
		string strin = Filename

		variable strloc = strsearch(strin, "SPCM",0)+4
		string Filename_cut
		Filename_cut = strin[strloc,strlen(strin)]
		print Filename_cut
		
		header +=  "Note: \r"
		
		String tempstr
		variable i		
		header += "File "+ num2str(l) +": " + filename + "\r"
		header +=  "File cut: " +Filename_cut +" \r"
		for( i=0; i<numheaderlines; i +=1)// however many lines to read
			FReadLine/T=";" refNum, tempstr  //read until ;			
			FReadLine/T=";" refNum, tempstr //read until next ; (should be on next line, reseting to next line without picking up return character)
			header += tempstr + "\r" //add string and return		
		endfor
end


Function Loaddialog(app)
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
	
	Controlinfo/W=MCW headerlines
	
	variable headerlines = V_value
	if(i==0)
	print ("Headerlines:" + num2str(headerlines))
	endif
	
	variable j
	for(j=0;j<headerlines;j=j+1)
	FReadLine refNum , dummystr
	//print dummystr
	endfor
	
	if(headerlines ==0)
	tempstr = "Vg"
	else 
	//FReadLine/T=(num2char(10)) refNum , dummystr
	FReadLine/T=(num2char(9)) refNum, tempstr
	tempstr = removeending(tempstr)
	endif
	
	
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
	
	loadwave/G/O/Q/A/B="N=Vg;N=Isd; N='_skip_', c=4;" S_fileName
	
	Close/A
	//print num2str(strlen(prestr))
	wnamevg = prestr +  tempstr + "_" + S_filename[0,26-strlen(prestr)-strlen(appstr)] +appstr
	
	wnameisd = prestr + "Isd_" + S_filename[0,26-strlen(prestr)-strlen(appstr)] +appstr
	dummystr =""
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

//display
//
//
	Controlinfo/W=MCW Samegraph
	variable sameg = V_Value

if(i==0 && app || !(sameg))
	display/K=1 $wnameisd vs $wnamevg
	
	Label left "Isd (A)"
	Label bottom tempstr +"(V)"
	
	//annstring = "\\s('" + wnameisd + "')" + wnameisd 
	//TextBox/C/N=text0/A=MC annstring
	//edit $wnameisd, $wnamevg
else
//	appendtograph $wnameisd vs $wnamevg
//	annstring +=  "\r" +"\\s(" + wnameisd + ")" + wnameisd
//	TextBox/C/N=text0/A=MC annstring

	appendtograph $wnameisd vs $wnamevg
	//annstring =   "\\s('" + wnameisd + "')" + wnameisd
	//Appendtext/N=text0 annstring
	execute "ann()"
endif
	


endfor

//colorize()


end


///RES

Function Loadresdialog(type)
variable type // 0 for res 1 for pow
setdatafolder root:temp:

Variable refNum
String outputPaths
GetFilePaths(OutputPaths, refNum)

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
	
	
Variable numFilesSelected = ItemsInList(outputPaths, "\r")
Variable l
String header
for(l=0; l<numFilesSelected; l+=1)
	String path = StringFromList(l, outputPaths, "\r")		
	

	Open/R refNum as path
	
	Controlinfo/W=MCW oldres
	If(!V_Value)
		loadwave/G/O/Q/A/B="N='skip';N=tempres;N=tempnmres;" S_fileName
		ReadHeader(header,5, S_Filename, l, refnum)		
	else
		loadwave/G/O/Q/A/B="N=tempres;N=tempnmres;" S_fileName
	endif
	
	
	string resname
	resname = "r_" + prestr +S_filename[0,26-strlen(prestr)-strlen(appstr)] +appstr
		
// Put data into res

wave restemp = 'tempres'
wave nmres = 'tempnmres'

if(type)
	setdatafolder root:spectral:Power:
else
	setdatafolder root:spectral:resonance:
endif

variable sizeres, spaceres
variable offset

//get size and spacing of waves
sizeres = dimsize(restemp, 0)
spaceres = nmres[2] - nmres[1]


make/o/n=(sizeres) res
res[] = restemp[p]


//add note
Note/K res "Original filename " + resname  + "   Unnormalized" 
Note res "Resonance wave spacing: "+  num2str(spaceres) + " \rResonance nm range:" + num2str(nmres[0])+ "-"+ num2str(nmres[sizeres-1] )
//Note res header 
//rename waves

string dummystr 

wave reswavetest = $resname
	if(waveexists(reswavetest))
		prompt dummystr , "Wave already exists, enter something to append:"
		DoPrompt "Enter Values", dummystr
		if(!(V_Flag))
		resname = resname + dummystr

		endif
	endif
rename res $resname

setdatafolder root:spectral:xwaves:

make/o/n=(sizeres) ev
make/o/n=(sizeres) nm

ev = 1239.84/nmres

nm = nmres
string wnameev = resname + "eV"
string wnamenm = resname + "nm"
rename ev $wnameev
rename nm $wnamenm


	


endfor

end



///IMAGE

//num=number of images, if <2 uses image, if >2 uses imagetabs
//get header= read in header and affect note? 0 no 1 yes
Function LoadImageheader(getheader,objtype)
Variable getheader,objtype //0 for 50X 1 for 100X
Variable num
Variable l
//w1 = "root:Images:" + w1

//choosing image template



Variable refNum
String outputPaths
GetFilePaths(OutputPaths, refNum)


		variable imagesize
		prompt imagesize, "Image size (um):"
		DoPrompt "Enter Values", imagesize
		


Variable numFilesSelected = ItemsInList(outputPaths, "\r")


num = numFilesSelected
if(num<3)
Wave w = root:images:image
else
Wave w = root:images:imagetabs
endif


String header =  "Note: \r"	



for(l=0; l<num; l+=1)
String path = StringFromList(l, outputPaths, "\r")
Make/N=(200,200)/O temp0

//Open the file and read the header which ends with ;
Open/R refNum as path

//I can't figure out how to deal with return characters so I'll read in the paramaters from each insturment seperately and add returns in between

//header += ("\rOriginal filename:" + S_Filename)

If(getheader)
ReadHeader(header,5, S_Filename, l, refnum)
endif



//Loads the file into temp0, flips it the right way, redimensions, then creates a new image based on the filename and puts the wave in it

LoadWave/G/M/A/O/Q/K=0/N=temp S_fileName

Close refNum

ImageTransform fliprows temp0


Variable wsizex, wsizey

wsizex = dimsize(temp0,0)
wsizey = dimsize(temp0,1)


Redimension/N=(wsizex,wsizey,-1) w

w[][][l] = temp0[p][q]

endfor





if(num<3)
header +=  "\rColorMap 0:BlueWhiteRed \rColorMap 1:BlueWhiteRed \rScanRate: 0.65104" //after reading in parameters set right colors
else
header +=  "\rColorMap 0:BlueWhiteRed \rColorMap 1:BlueWhiteRed \rColorMap 2:BlueWhiteRed \rColorMap 3:BlueWhiteRed \rColorMap 4:BlueWhiteRed \rScanRate: 0.65104"
header +=  "\rColorMap 0:BlueWhiteRed \rColorMap 5:BlueWhiteRed \rColorMap 6:BlueWhiteRed \rColorMap 7:BlueWhiteRed \rColorMap 8:BlueWhiteRed \rScanRate: 0.65104"
endif
String fn

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
	fn ="x_"+ prestr + "_" + S_filename[0,24-strlen(prestr)-strlen(appstr)] +appstr

	string dummystr
	setdatafolder root:images
	if(waveexists($fn))
		prompt dummystr , "Wave already exists, enter something to append:"
		DoPrompt "Enter Values", dummystr
		if(!(V_Flag))
		fn = fn + dummystr

		endif

	endif

//fn = "x_" + S_filename[0,19]

duplicate/o w root:images:$fn

//Add header into note and delete and initialize note
if(getheader)
Note/K root:images:$fn header 
 endif

//wave MaskWave = $"root:Packages:MFP3D:Main:Display:"+fn +"Mask"+num2str(layer)
//wave MaskWave = $"root:Packages:MFP3D:Main:Display:"+fn +"Mask0"
wave Imagewave = $"root:Images:" + fn
variable Scale
if(objtype)
 Scale = (0.1599e-6)*(imagesize/5)*(200/wsizex)
else 
 Scale = (.126e-6)*(imagesize/2)*(200/wsizex)
endif
SetScale/P x 0,Scale,"", Imagewave
SetScale/P y 0,Scale,"", Imagewave
//SetScale/P x 0,Scale,"", Maskwave
//SetScale/P y 0,Scale,"", Maskwave




end




//EXTRA IMAGE STUFF
//inserts image into image w1 at location num and multiplies it by sens

Function AddImage(w1, num, sens)
string w1
Variable num, sens

w1 = "root:Images:" + w1

Wave w = $w1

Make/N=(200,200)/O temp0

LoadWave/J/M/D/A/O/Q/K=0/N=temp 

ImageTransform fliprows temp0

temp0 *= sens

w[][][num] = temp0[p][q]

//String fn

//fn = S_filename

//Rename w $fn
 

end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





//Takes a bunch of linescans and makes an image out of them
Function Linescan(Path, fnbase, imgwave, Vgmin, Vgmax, dVg)
String Path, fnbase, imgwave
Variable Vgmin, Vgmax, dVg

Variable imgy

imgy = ceil((Vgmax-Vgmin)/dVg + 1)

Make/o/n=(200,(imgy)) $imgwave

Wave imgw = $imgwave

variable n
String tempstr, fin, PLstr
Wave tempw, tempw0

n=0

for (n=0;n<imgy;n+=1)

tempstr = num2str((Vgmin+n*dVg))

fin = fnbase+tempstr

PLstr = Path+fin

LoadWave/J/M/D/O/Q/N=tempw PLstr

imgw[][n] = (tempw0[p][1]+tempw0[p][2]+tempw0[p][3])/3

endfor

end






//Load in temperature data taken from cryostat. 

Function Loadtemp()
String wnametemp, wnameA, wnameB

Variable refNum
String tempstr
String dummystr
Open/R/T="????" refNum


loadwave/G/O/Q/A/B="N=Temp;N=A; N=B;" S_fileName
wnametemp =  "Temp_" + S_filename 

rename Temp $wnametemp

wnameA = "A_" + S_filename 

rename A $wnameA

wnameB = "B_" + S_filename 

rename B $wnameB

display $wnameA, $wnameB vs $wnametemp
Label left "Temp (K)"
Label bottom tempstr +"Time (s)"

end