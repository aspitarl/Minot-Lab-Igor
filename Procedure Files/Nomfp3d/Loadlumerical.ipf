#pragma rtGlobals=3		// Use modern global access method and strict wave access.





Function LoadImagelumerical()



Variable refNum
String outputPaths
GetFilePaths(OutputPaths, refNum)

Variable numFilesSelected = ItemsInList(outputPaths, "\r")


variable num = numFilesSelected
if(num<3)
Wave w = root:images:image
else
Wave w = root:images:imagetabs
endif


String header =  "Note: \r"	


variable l
for(l=0; l<num; l+=1)
String path = StringFromList(l, outputPaths, "\r")


//Open the file and read the header which ends with ;
Open/R refNum as path

//I can't figure out how to deal with return characters so I'll read in the paramaters from each insturment seperately and add returns in between

//header += ("\rOriginal filename:" + S_Filename)


ReadHeader(header,4, S_Filename, l, refnum)


//Make/N=(200,200)/O temp0

//Loads the file into temp0, flips it the right way, redimensions, then creates a new image based on the filename and puts the wave in it
setdatafolder root:Images
LoadWave/G/M/A/O/Q/K=0/N=temp S_fileName

wave temp0 = temp0

Close refNum

//ImageTransform fliprows temp0
//
Variable wsizex, wsizey
//
wsizex = dimsize(temp0,0)
wsizey = dimsize(temp0,1)
//
Redimension/N=(wsizex,wsizey,-1) w
//
w[][][l] = temp0[p][q]
//
endfor
if(num<3)
header +=  "\rColorMap 0:BlueWhiteRed \rColorMap 1:BlueWhiteRed \rScanRate: 0.65104" //after reading in parameters set right colors
else
header +=  "\rColorMap 0:BlueWhiteRed \rColorMap 1:BlueWhiteRed \rColorMap 2:BlueWhiteRed \rColorMap 3:BlueWhiteRed \rColorMap 4:BlueWhiteRed \rScanRate: 0.65104"
header +=  "\rColorMap 0:BlueWhiteRed \rColorMap 5:BlueWhiteRed \rColorMap 6:BlueWhiteRed \rColorMap 7:BlueWhiteRed \rColorMap 8:BlueWhiteRed \rScanRate: 0.65104"
endif
String fn
//
fn = "x_" + S_filename[0,19]
//
duplicate/o w root:images:$fn
//
////Add header into note and delete and initialize note
//
Note/K root:images:$fn header 

wave freqwave = temp1
wave xwave = temp2 

variable h = 4.1356e-15

•SetScale/I y freqwave[0]*h,freqwave[dimsize(freqwave,0)-1]*h,"", $fn
•SetScale/I x xwave[0],xwave[dimsize(xwave,0)-1],"", $fn
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Function grabxsectionlum(sectname)
string sectname

String fldrSav0= GetDataFolder(1)
SetDataFolder root:crosssections

wave ysection = root:packages:MFP3D:Main:Analyze:Section:SectionWaveY
wave xsection = root:packages:MFP3D:Main:Analyze:Section:SectionWaveX

SVAR lastwavestrorig = root:packages:MFP3D:Main:Analyze:Section:LastImage
string lastwavestr = lastwavestrorig
string lastwavecut 
variable cutpos =strsearch(lastwavestr, "#",0)
lastwavecut= lastwavestr[0,cutpos-2]
wave imagewave = $("root:images:" + lastwavecut)

duplicate/o ysection $("cs_" + lastwavecut +"_"+ sectname)
//duplicate/o xsection $("xcs_" + lastwavecut+ sectname)

wave cs = $("cs_"+ lastwavecut+"_" + sectname)
//wave ycs = $("ycs_"+ lastwavecut + sectname)




SetScale/P x dimoffset(imagewave, 1),DimDelta(imagewave, 1),"", cs


//display $("ycs_" + sectname) vs $("xcs_" + sectname)

SetDataFolder fldrSav0
end

Function ButtonProc_3(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// loadimageheaderlum()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function Loadlumbutton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			 LoadImagelumerical()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End
