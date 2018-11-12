
#pragma rtGlobals=3        // Use strict wave reference mode






Function MakeMCPButton(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			MakeMCP()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function MakeMCP()
	NewPanel/k=1/N=MCP /W=(338,105,638,305) 
	ShowTools/A
	Button button0,pos={63,20},size={100,20}, proc=MCPbutton1, title="scale image"
	SetVariable Scaleset pos={182,20},value= _NUM:1
end

//Function scaleimage()
//String GraphStr = StringFromList(0,WinList(cOfflineBaseName+"*",";","WIN:1"),";")
//
//	String ImageName, ImageFolder
//	Variable Layer
//	GetGraphData(GraphStr,ImageFolder,ImageName,Layer)
//wave MaskWave = $"root:Packages:MFP3D:Main:Display:"+ImageName+"Mask"+num2str(layer)
//wave Imagewave = $"root:Images:" + Imagename
//
//Controlinfo scaleset
//
//SetScale/P x 0,V_Value,"", Imagewave
//SetScale/P y 0,V_Value,"", Imagewave
//SetScale/P x 0,V_Value,"", Maskwave
//SetScale/P y 0,V_Value,"", Maskwave
//
//end

Function MCPbutton1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//scaleimage()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End



Window Notespanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(539,108,839,308)
	ShowTools/A
	SetDrawLayer UserBack
	DrawText 33,16,"Blue = Right, Red = Left"
EndMacro
