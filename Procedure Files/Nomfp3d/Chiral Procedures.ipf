#pragma rtGlobals=1		// Use modern global access method.


//start with table of peaks
//generate wave with all possible combinations without just permutations
//make reslist
//for loop:
		//passing colums into chiral generating Resid
		//pulling out peaks for that iteration into temp wave peakwave
		//use appendlowestresdata to append lowest res data from resid to reslist with peaks from peakwave
//if there is only one combination for "num peaks" then just use the old method and see different residuals for one set of peaks. 


Function subtractoffsetres()

wave/t reswavelist = root:spectral:reswavelist

variable numwaves = dimsize(reswavelist,0)

variable i
string reswavename
for(i=0; i<numwaves; i=i+1)

reswavename = "root:spectral:Resonance:" + reswavelist[i]

wave reswave = $reswavename

variable offset =reswave[0]


reswave -= offset


endfor

end



Function makereslist(peaks,numpeaks,chilib, chilibtype, tubetype)
wave peaks,chilib
variable chilibtype
variable tubetype
variable numpeaks //number of peaks you want to use in chiral fitting
variable totnumpeaks= dimsize(peaks,0) // total number in peaks wave


make/o/n=(numpeaks,Binomial(totnumpeaks,numpeaks)) peakwave



variable i,j,k,l,m

//
if (numpeaks == 2)
for(j=0;j<dimsize(peaks,0)-numpeaks+1;j+=1)
	
	for(k=0;k<dimsize(peaks,0)-numpeaks-j+1; k+=1)
	peakwave[0][i] = peaks[j]
	peakwave[1][i] = peaks[j+k+1]
	i+=1
	endfor
		
endfor
//
elseif(numpeaks == 3)

for(j=0;j<dimsize(peaks,0)-numpeaks+1;j+=1)
	
	for(k=0;k<dimsize(peaks,0)-numpeaks-j+1; k+=1)
	for(l=0;l<dimsize(peaks,0)-numpeaks-j-k+1; l+=1)
	peakwave[0][i] = peaks[j]
	peakwave[1][i] = peaks[j+k+1]
	peakwave[2][i] = peaks[j+k+l+2]
	i+=1
	endfor
endfor
		

endfor


elseif(numpeaks == 4)

for(j=0;j<dimsize(peaks,0)-numpeaks+1;j+=1)
	
	for(k=0;k<dimsize(peaks,0)-numpeaks-j+1; k+=1)
	for(l=0;l<dimsize(peaks,0)-numpeaks-j-k+1; l+=1)
	for(m=0;m<dimsize(peaks,0)-numpeaks-j-l-k+1; m+=1)
	peakwave[0][i] = peaks[j]
	peakwave[1][i] = peaks[j+k+1]
	peakwave[2][i] = peaks[j+k+l+2]
	peakwave[3][i] = peaks[j+k+l+m+3]
	i+=1
	endfor
	endfor
		endfor
		
endfor

else

endif

//--------------------------

setdatafolder root:spectral:
make/o/n=(1,13+numpeaks) reslist
wave reslist = reslist  //reslist is in spectral folder
setdatafolder root:temp:
make/o resIDtemp   //now move to temp folder and get temp wave
wave resIDtemp = resIDtemp

//if(Binomial(totnumpeaks,numpeaks)>1)
	for(i=0; i<Binomial(totnumpeaks,numpeaks);i+=1)
		
		nPeakMatchnew(chilib, tubetype, i, peakwave, "ResIDtemp", 0)
		appendlowestresdata(ResIDtemp, reslist, peakwave,numpeaks,i)
		
	endfor
	//rename labels only if doing combinations of peaks
	string colname
	for(i=0;i<numpeaks;i=i+1)
	colname = "peak " + num2str(i+1)
	setdimlabel 1, i, $colname, reslist	
	endfor
		setdimlabel 1, numpeaks, n, reslist											// Label Data Columns
		setdimlabel 1, numpeaks+1, m, reslist
		setdimlabel 1, numpeaks+2, Diameter, reslist
		setdimlabel 1, numpeaks+3, Residualperpeak, reslist	
		setdimlabel 1, numpeaks+4, p1, reslist
		setdimlabel 1, numpeaks+5, p2,reslist
		setdimlabel 1, numpeaks+6, p3, reslist
		setdimlabel 1, numpeaks+7, p4,reslist
		setdimlabel 1, numpeaks+8, p5, reslist
		setdimlabel 1, numpeaks+9, p6,reslist
		setdimlabel 1, numpeaks+10, p7,reslist
		setdimlabel 1, numpeaks+11, p8,reslist
		setdimlabel 1, numpeaks+12, p9,reslist
		
		
		reslist[][numpeaks+3] /= numpeaks
//else   // if only one peak set, just do the old chiral fitting. haven't figured out dim labels/inserting peaks into reslist.
//		nPeakMatch(chilib, chilibtype, tubetype, i, peakwave, "ResIDtemp", 0)
//		setdatafolder root:spectral:
//		duplicate/o resIDtemp reslist
//endif




setdatafolder root:
end


Function appendlowestresdata(ResID, reslist, peakwave, numpeaks,peakset)
wave ResID, reslist, peakwave
Variable numpeaks, peakset
variable rows, layers
rows = dimsize(ResID,0)
layers = dimsize(ResID,2)

make/o/n=(rows*layers) temp

variable i,j,k
k=0

for(i=0; i<layers; i+=1)
	for(j=0; j<rows; j+=1)
	temp[k] = resID[j][3][i]
	k+=1
	endfor
endfor

makeindex temp,temp

//not worry about mod because already sorted
variable layer


//add row
//variable reslistrow = dimsize(reslist,0)+1
variable reslistrow = dimsize(reslist,0)
Redimension/N=(reslistrow+3,-1) reslist
//append reslist
//variable residcol = dimsize(ResID,1)
variable a=numpeaks
variable b = dimsize(ResID,1)
for (i=0; i <a ;i+=1)
reslist[reslistrow-1][i] = peakwave[i][peakset]
endfor

for (i=0; i <b ;i+=1)

for(j=0;j<3;j=j+1)
layer= floor(temp[j]/rows)
reslist[reslistrow-1+j][i+a] = ResID[j][i][layer]

endfor
endfor
//return temp[0]

end



//Chilib CNTAtlas, AtlasData, or Columbia data
//DatSrc 1 for Atlas, 0 for Columbia
//SM 1 for semiconducting 0 for metal
//PCol column of Peaks wave
//Peaks name of 2D wave resonances are in (x = peak y = data set)
//ResID name of output wave
//disp make new table?
Function nPeakMatchnew(Chlib, SM, PCol, Peaks, ResID, disp)
Wave Chlib, Peaks // Chiral Data library and wave of Resonances in ascending order
Variable SM, PCol, disp // Data Source Atlas/Columb (1/0), Semic/Metal (1/0), Column # of Peak data, Display Yes/No (1/0)
String ResID // Output Filename for Residual Analysis and Matches

Variable i, j, k, jsize, psize, n, m, nP, ndP, mp, outq
String index, Datname

nP = 0//number of peaks
psize = dimsize(Peaks, 0)

for(i=0;i<psize;i+=1)

	if(Peaks[i][Pcol] != 0)
		nP+=1
	endif
	
endfor

jsize = dimsize(Chlib, 0)

	if(SM == 1 || SM==0)

		Datname = "x data set..."
		ndP = 10
		outq = 13
		//if(DatSrc == 0)
			//ndP = 10
			//Datname = "Columbia data set..."
			//outq = 13
		//endif

		mp = ndP-nP   //size of data wave minus number of peaks
	
		make/o/n=6 Res
		Res = 0
		make/o/n=(3,2,mp) Rnm
		Rnm = 1
		
		Print "Calculating Residuals for", nP,"peak Semiconducting CNT Matches from the",Datname
		variable peaknumber= 0
		variable p
		variable libpeak
		for(j=0;j<jsize;j+=1)
		
			for(m=0;m<mp;m+=1)											// Loop over different combinations
			peaknumber = 0
				for(i=0;(i+m)<ndP;i+=1)
					p = i+1
					libpeak = Chlib[j][4+i+m]
					if((libpeak != 0)  && (p != 3)  && (p !=6)  && (p !=9)  )
					
					Res[m] = Res[m] + (libpeak-Peaks[peaknumber][PCol])^2		// Add up errors for particular combo
					peaknumber +=1
					
					if(peaknumber == nP)
					break
					endif
					
					endif

					
				endfor
				
				if(peaknumber < nP)
				res[m] = 10
				endif
			endfor
		
			Res = sqrt(Res)
			
			for(k=0;k<mp;k+=1)
				LowSort(j, Res[k], k, Rnm)									//sort 3 lowest errors for
			endfor														//each combination
			
			Res = 0
			
		endfor
			
		Make/o/n=(3,outq,mp) $Resid											// Make output Wave
		Wave rout = $Resid
	
		setdimlabel 1, 0, n, rout											// Label Data Columns
		setdimlabel 1, 1, m, rout
		setdimlabel 1, 2, Diameter, rout
		setdimlabel 1, 3, Residual, rout	
		setdimlabel 1, 4, S11, rout
		setdimlabel 1, 5, S22, rout
		setdimlabel 1, 6, S33, rout
		setdimlabel 1, 7, S44, rout
		setdimlabel 1, 8, S55, rout
		setdimlabel 1, 9, S66, rout
		
		//if(DatSrc == 1)
		//setdimlabel 1, 10, S77, rout
		//endif
		
		for(n=0;n<3;n+=1)												// Write Data to output wave
		
			for(m=0;m<mp;m+=1)
					
				rout[n][0][m] = Chlib[(Rnm[n][0][m])][0]						// Write n, m, d, residual
				rout[n][1][m] = Chlib[(Rnm[n][0][m])][1]
				rout[n][2][m] = Chlib[(Rnm[n][0][m])][3]
				rout[n][3][m] = Rnm[n][1][m]
				
				for(i=4;i<outq;i+=1)											// Write n,m peaks from atlas
					rout[n][i][m] = Chlib[(Rnm[n][0][m])][i]
				endfor
			
			endfor
			
		endfor	
	
		if(disp==1)														// Display wave
			edit rout
			ModifyTable horizontalindex=2									// Use horizontal Labels
		endif
			
	
	endif


end

Function nPeakMatch(Chlib, DatSrc, SM, PCol, Peaks, ResID, disp)
Wave Chlib, Peaks // Chiral Data library and wave of Resonances in ascending order
Variable DatSrc, SM, PCol, disp // Data Source Atlas/Columb (1/0), Semic/Metal (1/0), Column # of Peak data, Display Yes/No (1/0)
String ResID // Output Filename for Residual Analysis and Matches

Variable i, j, k, jsize, psize, n, m, nP, ndP, mp, outq
String index, Datname

nP = 0//number of peaks
psize = dimsize(Peaks, 0)

for(i=0;i<psize;i+=1)

	if(Peaks[i][Pcol] != 0)
		nP+=1
	endif
	
endfor

jsize = dimsize(Chlib, 0)

	if(SM == 1 || SM==0)

		Datname = "CNT Atlas data set..."
		ndP = 8
		outq = 11
		if(DatSrc == 0)
			ndP = 7
			Datname = "Columbia data set..."
			outq = 10
		endif

		mp = ndP-nP   //size of data wave minus number of peaks
	
		make/o/n=6 Res
		Res = 0
		make/o/n=(3,2,mp) Rnm
		Rnm = 1
		
		Print "Calculating Residuals for", nP,"peak Semiconducting CNT Matches from the",Datname
		variable peaknumber= 1
		for(j=0;j<jsize;j+=1)
		
			for(m=0;m<mp;m+=1)											// Loop over different combinations
			peaknumber = 1
				for(i=0;(i+m)<ndP;i+=1)
				
					if(Chlib[j][4+i+m] != 0)
					//Res[m] = Res[m] + (Chlib[j][4+i+m]-Peaks[i][PCol])^2		// Add up errors for particular combo
					Res[m] = Res[m] + (Chlib[j][4+i+m]-Peaks[peaknumber][PCol])^2		// Add up errors for particular combo
					peaknumber +=1
					endif
				endfor
				
			endfor
		
			Res = sqrt(Res)
			
			for(k=0;k<mp;k+=1)
				LowSort(j, Res[k], k, Rnm)									//sort 3 lowest errors for
			endfor														//each combination
			
			Res = 0
			
		endfor
			
		Make/o/n=(3,outq,mp) $Resid											// Make output Wave
		Wave rout = $Resid
	
		setdimlabel 1, 0, n, rout											// Label Data Columns
		setdimlabel 1, 1, m, rout
		setdimlabel 1, 2, Diameter, rout
		setdimlabel 1, 3, Residual, rout	
		setdimlabel 1, 4, S11, rout
		setdimlabel 1, 5, S22, rout
		setdimlabel 1, 6, S33, rout
		setdimlabel 1, 7, S44, rout
		setdimlabel 1, 8, S55, rout
		setdimlabel 1, 9, S66, rout
		
		if(DatSrc == 1)
		setdimlabel 1, 10, S77, rout
		endif
		
		for(n=0;n<3;n+=1)												// Write Data to output wave
		
			for(m=0;m<mp;m+=1)
					
				rout[n][0][m] = Chlib[(Rnm[n][0][m])][0]						// Write n, m, d, residual
				rout[n][1][m] = Chlib[(Rnm[n][0][m])][1]
				rout[n][2][m] = Chlib[(Rnm[n][0][m])][3]
				rout[n][3][m] = Rnm[n][1][m]
				
				for(i=4;i<outq;i+=1)											// Write n,m peaks from atlas
					rout[n][i][m] = Chlib[(Rnm[n][0][m])][i]
				endfor
			
			endfor
			
		endfor	
	
		if(disp==1)														// Display wave
			edit rout
			ModifyTable horizontalindex=2									// Use horizontal Labels
		endif
			
	
	endif


end

Function ResMatch(Chlib, SM, PCol, Peaks, ResID, disp)
Wave Chlib, Peaks // Chiral Data library and wave of Resonances in ascending order
Variable SM, PCol, disp // Semic/Metal (1/0), Column # of Peak data, Display Yes/No (1/0)
String ResID // Output Filename for Residual Analysis and Matches

Variable i, j, k, jsize, psize, n, m, nP


nP = 0
psize = dimsize(Peaks, 0)

for(i=0;i<psize;i+=1)

	if(Peaks[i][Pcol] != 0)
		nP+=1
	endif
	
endfor

jsize = dimsize(Chlib, 0)

if(SM == 1)

	if(nP == 2)
	
		make/o/n=6 Res
		make/o/n=(3,2,6) Rnm
		Rnm = 1
		
		//Print "Calculating Residuals for 2 peak Semiconducting CNT Matches..."
		
		for(j=0;j<jsize;j+=1)
		
			Res[0] = sqrt((Chlib[j][4]-Peaks[0][PCol])^2 + (Chlib[j][5]-Peaks[1][PCol])^2)		// Calculate residuals for
			Res[1] = sqrt((Chlib[j][5]-Peaks[0][PCol])^2 + (Chlib[j][7]-Peaks[1][PCol])^2)		// all peak combinations
			Res[2] = sqrt((Chlib[j][7]-Peaks[0][PCol])^2 + (Chlib[j][8]-Peaks[1][PCol])^2)
			Res[3] = sqrt((Chlib[j][8]-Peaks[0][PCol])^2 + (Chlib[j][10]-Peaks[1][PCol])^2)
			Res[4] = sqrt((Chlib[j][10]-Peaks[0][PCol])^2 + (Chlib[j][11]-Peaks[1][PCol])^2)
			Res[5] = sqrt((Chlib[j][11]-Peaks[0][PCol])^2 + (Chlib[j][13]-Peaks[1][PCol])^2)
			
			for(k=0;k<6;k+=1)
				LowSort(j, Res[k], k, Rnm)									//sort 3 lowest errors for
			endfor														//each combination
			
		endfor
			
		Make/o/n=(3,11,6) $Resid											// Make output Wave
		Wave rout = $Resid
	
		setdimlabel 1, 0, n, rout											// Label Data Columns
		setdimlabel 1, 1, m, rout
		setdimlabel 1, 2, Diameter, rout
		setdimlabel 1, 3, Residual, rout
		setdimlabel 1, 4, S11, rout
		setdimlabel 1, 5, S22, rout
		setdimlabel 1, 6, S33, rout
		setdimlabel 1, 7, S44, rout
		setdimlabel 1, 8, S55, rout
		setdimlabel 1, 9, S66, rout
		setdimlabel 1, 10, S77, rout
		
		for(n=0;n<3;n+=1)												// Write Data to output wave
		
			for(m=0;m<6;m+=1)
					
				rout[n][0][m] = Chlib[(Rnm[n][0][m])][0]
				rout[n][1][m] = Chlib[(Rnm[n][0][m])][1]
				rout[n][2][m] = Chlib[(Rnm[n][0][m])][3]
				rout[n][3][m] = Rnm[n][1][m]
				rout[n][4][m] = Chlib[(Rnm[n][0][m])][4]
				rout[n][5][m] = Chlib[(Rnm[n][0][m])][5]
				rout[n][6][m] = Chlib[(Rnm[n][0][m])][7]
				rout[n][7][m] = Chlib[(Rnm[n][0][m])][8]
				rout[n][8][m] = Chlib[(Rnm[n][0][m])][10]
				rout[n][9][m] = Chlib[(Rnm[n][0][m])][11]
				rout[n][10][m] = Chlib[(Rnm[n][0][m])][13]
			
			endfor
			
		endfor	
	
		if(disp==1)														// Display wave
			edit rout
			ModifyTable horizontalindex=2									// Display Labels
		endif
			
	endif
	
endif


end




Function ChiralMatch(Chlib, MS, nPeaks, Peaks, ResID, disp)
Wave Chlib, Peaks // Chiral Data library and wave of Resonances in ascending order
Variable MS, nPeaks, disp // Metal/Semic (0/1), # of peaks, Display Yes/No (1/0)
String ResID // Output Filename tag for Residual Analysis and Matches

Variable i, j, k, nmj, psize, n, m
String s1, s2, s3, s4, s5, s6, s7

s1 = "S11_"
s2 = "S22_"
s3 = "S33_"
s4 = "S44_"
s5 = "S55_"
s6 = "S66_"
s7 = "S77_"


psize = dimsize(Chlib, 0)

if(MS == 1)

	if(nPeaks == 2)
	
		make/o/n=6 Res
		make/o/n=(3,2,6) Rnm
		Rnm = 1
		
		//Print "Calculating Residuals for 2 peak Semiconducting CNT Matches..."
		
		for(j=0;j<psize;j+=1)
		
			Res[0] = sqrt((Chlib[j][3]-Peaks[0])^2 + (Chlib[j][4]-Peaks[1])^2)		// Calculate residuals for
			Res[1] = sqrt((Chlib[j][4]-Peaks[0])^2 + (Chlib[j][6]-Peaks[1])^2)		// all peak combinations
			Res[2] = sqrt((Chlib[j][6]-Peaks[0])^2 + (Chlib[j][7]-Peaks[1])^2)
			Res[3] = sqrt((Chlib[j][7]-Peaks[0])^2 + (Chlib[j][9]-Peaks[1])^2)
			Res[4] = sqrt((Chlib[j][9]-Peaks[0])^2 + (Chlib[j][10]-Peaks[1])^2)
			Res[5] = sqrt((Chlib[j][10]-Peaks[0])^2 + (Chlib[j][12]-Peaks[1])^2)
			
			for(k=0;k<6;k+=1)
				LowSort(j, Res[k], k, Rnm)									//sort 3 lowest errors for
			endfor														//each combination
			
		endfor
			
				
		Make/o/n=3 p1nm, p2nm
		Make/o/n=(3,6,6) $Resid
		Wave rout = $Resid
		
		Make/o/n=(3,6) Rout1
		setdimlabel 1, 0, n, Rout1	
		setdimlabel 1, 1, m, Rout1
		setdimlabel 1, 2, Diameter, Rout1
		setdimlabel 1, 3, Residual, Rout1
		
		duplicate/o Rout1, Rout2, Rout3, Rout4, Rout5, Rout6
		
		for(n=0;n<3;n+=1)
		
			for(m=0;m<6;m+=1)
					
				rout[n][0][m] = Chlib[(Rnm[n][0][m])][0]
				rout[n][1][m] = Chlib[(Rnm[n][0][m])][1]
				rout[n][2][m] = sqrt((0.246^2)*((rout[n][0][m]+rout[n][1][m])^2*(3/4) + (rout[n][0][m]-rout[n][1][m])^2*(1/4)))/pi
				rout[n][3][m] = Rnm[n][1][m]
				
				if(m == 0)
					setdimlabel 1, 4, S11, Rout1
					setdimlabel 1, 5, S22, Rout1			
					rout[n][4][m] = Chlib[(Rnm[n][0][m])][3]
					rout[n][5][m] = Chlib[(Rnm[n][0][m])][4]
		
			elseif(m == 1)
					setdimlabel 1, 4, S22, Rout2
					setdimlabel 1, 5, S33, Rout2
					rout[n][4][m] = Chlib[(Rnm[n][0][m])][4]
					rout[n][5][m] = Chlib[(Rnm[n][0][m])][6]
			
			elseif(m == 2)
					setdimlabel 1, 4, S33, Rout3
					setdimlabel 1, 5, S44, Rout3
					rout[n][4][m] = Chlib[(Rnm[n][0][m])][6]
					rout[n][5][m] = Chlib[(Rnm[n][0][m])][7]

			elseif(m == 3)
					setdimlabel 1, 4, S44, Rout4
					setdimlabel 1, 5, S55, Rout4
					rout[n][4][m] = Chlib[(Rnm[n][0][m])][7]
					rout[n][5][m] = Chlib[(Rnm[n][0][m])][9]

			elseif(m == 4)
					setdimlabel 1, 4, S55, Rout5
					setdimlabel 1, 5, S66, Rout5
					rout[n][4][m] = Chlib[(Rnm[n][0][m])][9]
					rout[n][5][m] = Chlib[(Rnm[n][0][m])][10]
		
			elseif(m == 5)
					setdimlabel 1, 4, S66, Rout6
					setdimlabel 1, 5, S77, Rout6
					rout[n][4][m] = Chlib[(Rnm[n][0][m])][10]
					rout[n][5][m] = Chlib[(Rnm[n][0][m])][12]

			endif
			
			endfor
			
		endfor
		
		
		Rout1 = rout[p][q][0]
		Rout2 = rout[p][q][1]
		Rout3 = rout[p][q][2]
		Rout4 =rout[p][q][3]
		Rout5 = rout[p][q][4]
		Rout6 =	rout[p][q][5]
		
		Duplicate/o Rout1, $(s1+s2+resid)
		Duplicate/o Rout2, $(s2+s3+resid)		
		Duplicate/o Rout3, $(s3+s4+resid)
		Duplicate/o Rout4, $(s4+s5+resid)
		Duplicate/o Rout5, $(s5+s6+resid)
		Duplicate/o Rout6, $(s6+s7+resid)
	
	
		if(disp==1)
			edit $(s1+s2+resid)
			ModifyTable horizontalindex=2
		
			edit $(s2+s3+resid)
			ModifyTable horizontalindex=2
		
			edit $(s3+s4+resid)
			ModifyTable horizontalindex=2
		
			edit $(s4+s5+resid)
			ModifyTable horizontalindex=2
		
			edit $(s5+s6+resid)
			ModifyTable horizontalindex=2
		
			edit $(s6+s7+resid)
			ModifyTable horizontalindex=2
		endif
			
	endif
	
endif


end



Function LowSort(nmj, Res, k, Reswave)
Variable nmj, Res, k
Wave Reswave

	if(Res < Reswave[0][1][k])
	
		Reswave[2][0][k] = Reswave[1][0][k]
		Reswave[2][1][k] = Reswave[1][1][k]
		Reswave[1][0][k] = Reswave[0][0][k]
		Reswave[1][1][k] = Reswave[0][1][k]
		Reswave[0][0][k] = nmj
		Reswave[0][1][k] = Res
	
	elseif(Res < Reswave[1][1][k])
		
		Reswave[2][0][k] = Reswave[1][0][k]
		Reswave[2][1][k] = Reswave[1][1][k]
		Reswave[1][0][k] = nmj
		Reswave[1][1][k] = Res
	
	elseif(Res < Reswave[2][1][k])
	
		Reswave[2][0][k] = nmj
		Reswave[2][1][k] = Res
	endif

end


Function ChiralSorter(nwav,mwav,pwav1, pwav2,bnwo)
Wave nwav, mwav, pwav1, pwav2
String bnwo

Variable n, m, nsize, msize, nmin, nmax, mmin, mmax
String nind, bn, bm, p1, p2
Wave temp1, temp2


nsize = dimsize(nwav,0)
msize = dimsize(mwav,0)

nmin = Wavemin(nwav)
nmax = Wavemax(nwav)
mmin = Wavemin(mwav)
mmax = Wavemax(mwav)

Variable i, j, nold, ndif

i = nmin
n = 0
nold = 0
bn = "n"
bm = "_m"
p1 = "_E33"
p2 = "_E44"
edit
display

do
	do
		n+=1
	while ((nwav[n] == i) && (n<(nsize-1)))
	
	nind = num2istr(i)	
	
	Make/o/n=(n-nold) temp1, temp2, ptemp1, ptemp2
	
	for (j=0;j<(n-nold);j+=1)
		
		temp1[j] = nwav[nold+j]
		temp2[j] = mwav[nold+j]
		ptemp1[j] = pwav1[nold+j]
		ptemp2[j] = pwav2[nold+j]
		
	endfor
	
	duplicate temp1, $(bn+nind+bnwo)
	duplicate temp2, $(bn+nind+bm+bnwo)
	duplicate ptemp1, $(bn+nind+p1+bnwo)
	duplicate ptemp2, $(bn+nind+p2+bnwo)
	
	appendtotable  $(bn+nind+bnwo),$(bn+nind+bm+bnwo),$(bn+nind+p1+bnwo),$(bn+nind+p2+bnwo)
	appendtograph $(bn+nind+p1+bnwo) vs $(bn+nind+p2+bnwo)
	
	i+=1
	nold = n

while (n<nsize)

end



Function Chiral3D(nwav,mwav,pwav, nmimage)
Wave nwav, mwav, pwav
String nmimage

Variable n, m, nsize, msize, nmin, nmax, mmin, mmax

nsize = dimsize(nwav,0)
msize = dimsize(mwav,0)

nmin = Wavemin(nwav)
nmax = Wavemax(nwav)
mmin = Wavemin(mwav)
mmax = Wavemax(mwav)

Make/o/n=((nmax-nmin),(mmax-mmin)) $nmimage
Wave nmi = $nmimage

for (n=0;n<nsize;n+=1)

	nmi[(nwav[n]-nmin)][(mwav[n]-mmin)] = pwav[n]
	
endfor

SetScale/I x (nmin), (nmax), "", nmi
SetScale/I y (mmin), (mmax), "", nmi

end


Function offsetres()
setdatafolder root:spectral:Avgnorm

string listofwaves = wavelist("*",";","")
string currentwavestr
variable index =0
variable peakval
do 
		currentwavestr = StringFromList(index, listofwaves)
		if ((strlen(currentwavestr) == 0) )
			break							// Ran out of waves
		endif
		
		wave currentwave = $currentwavestr
		peakval = wavemax(currentwave)
		currentwave /= peakval
		
		index += 1
while(1)

end




Function makePCabcs(d)
variable d
setdatafolder root:spectral:Calculated:PCtoAbCS

string listofwaves = wavelist("*",";","")
string currentwavestr
variable index =0
variable intval
variable evrange

wave intwave = intwave
intwave =0
do 
		setdatafolder root:spectral:Calculated:PCtoAbCS
		currentwavestr = StringFromList(index, listofwaves)
		if ((strlen(currentwavestr) == 0) )
			break							// Ran out of waves
		endif
			if(!stringmatch(currentwavestr, "intwave"))
			wave currentwave = $currentwavestr
			evrange = abs(pnt2x(currentwave,dimsize(currentwave,0)) - pnt2x(currentwave,0))//
			variable sigmaa = 7.6e-18*(eVrange/.93)
			
			sigmaa *= ((4*pi*d)/(sqrt(3)*(.249^2)))*1e3
			sigmaa *= 10^8
			//print evrange, sigmaa
			
			intwave =0
			//print nameofwave(currentwave)
			Integrate currentwave/D=intwave;DelayUpdate
			intwave = abs(intwave)
			intval = wavemax(intwave)
			//print sigmaa/intval
			
			setdatafolder root:spectral:Calculated:PCtoAbCS:normalized
			string newwavename = currentwavestr + "_norm"
			duplicate/o currentwave $newwavename
			wave newwave = $newwavename
			newwave *= sigmaa/intval
		endif
		
		//currentwave /= peakval
		
		index += 1
while(1)




end


///     Calculating predicted peaks

//This is from the atlas paper
Function Ek(n,m,p)
	variable n,m,p
	
	wave ek_params = $"root:spectral:Chiraldata:ek_param"
	
	variable vf = ek_params[p-1][0]*10^15
	variable eta = ek_params[p-1][1]
	variable bet = ek_params[p-1][2]
	
	
	variable i = geti(p)
	
	variable chiang = atan( (sqrt(3)*m)/((2*n)+m) )
	variable theta
	if(mod(n-m,3) ==1)
		theta = chiang + i*pi
	elseif(mod(n-m,3) ==2)
		theta = chiang + (i+1)*pi
	elseif(mod(n-m,3) ==0)
		theta = chiang 
	endif
	
	
	variable d = NTdiam(n,m)
	variable k = p*(2/(3*d))  //nm
	
	variable hbar = 6.58 * 10^-16 //eV s
	
	//print vf,bet,eta,theta
	
	return 2*hbar*vf*k + bet*k^2  + eta*(k^2)*cos(3*theta)


end


Function Enmp(n,m,p)
	variable p,n,m
	
	wave epdnm_params = $"root:spectral:Chiraldata:epdnm_param"
	
	variable alpha = epdnm_params[p-1][0]
	variable eta = epdnm_params[p-1][1]
	variable gam = epdnm_params[p-1][2]
	variable bet = epdnm_params[p-1][3]
	
	
	variable i = geti(p)
	
	
	variable chiang = atan( (sqrt(3)*m)/(2*n+m) )
	variable theta
	if(mod(n-m,3) ==1)
		theta = chiang + i*pi
	elseif(mod(n-m,3) ==2)
		theta = chiang + (i+1)*pi
	elseif(mod(n-m,3) ==0)
		theta = chiang 
	endif
	
	
	variable d = NTdiam(n,m)
	variable k = p*(2/(3*d))  //nm
	
	//print alpha, bet, eta,gam
	//print theta,d
	
	
	variable hbar = 6.58 * 10^-16 //eV s
	
	return alpha*k + bet*k*log(1.5*k) + (k^2)*(eta + gam*cos(3*theta))*cos(3*theta)
	
//	variable curv
//	
//	if(mod(n-m,3) ==0)
//		curv = 0.5*(k^2)*( (eta + gam*cos(3*theta))*cos(3*theta) + (eta + gam*cos(3*theta+pi))*cos(3*theta+pi) )
//	else
//		curv = 0.5*(k^2)*( (eta + gam*cos(3*theta))*cos(3*theta) )
//	endif
//	
//	return alpha*k + bet*k*log(1.5*k) + curv

end

Function geti(p)
	variable p
	variable i
	
	switch(p)
		case 1:
			i=1
			break
		case 2:
			i=2
			break
		case 3:
			i=1
			break
		case 4:
			i=3
			break
		case 5:
			i=4
			break
		case 6:
			i=2
			break
		case 7:
			i=5
			break
		case 8:
			i=6
			break
		case 9:
			i=3
			break
		case 10:
			i=7
			break
	endswitch
	
	return i

end




Function Both()
makeepd()
setdatafolder root:spectral:chiraldata
//wave CNTatlas_zero_sub = CNTatlas_zero_sub
//wave CNTatlas_zero_epd = CNTatlas_zero_epd

//wave CNTatlas_calc = CNTatlas_calc

//CNTatlas_zero_sub = CNTatlas_zero_epd - CNTatlas_calc
makeseperateres()

end 


Function makeseperateres()

setdatafolder root:spectral:chiraldata

wave atlas = CNTAtlas_calc

wave atlasorig = CNTAtlas_orig


setdatafolder root:spectral:chiraldata:reslines

variable size = dimsize(atlas,0)

make/n=(size)/o S11,S22,M11,S33,S44,M22,S55,S66,M33,S77
make/n=(size)/o Sd,Md
variable i,j

Variable SM,d
variable numsm=0
variable nummet=0
for(i=0;i<size;i=i+1)

SM = atlasorig[i][2] 
d = atlasorig[i][3] 
	if(SM)
	Sd[numsm] = d
	S11[numsm] = atlas[i][4]
	S22[numsm] = atlas[i][5]
	S33[numsm] = atlas[i][7]
	S44[numsm] = atlas[i][8]
	S55[numsm] = atlas[i][10]
	S66[numsm] = atlas[i][11]
	S77[numsm] = atlas[i][13]
	
	numsm +=1
	
	else
	Md[nummet] = d
	M11[nummet] = atlas[i][6]
	M22[nummet] = atlas[i][9]
	M33[nummet] = atlas[i][12]

	nummet +=1

	endif



endfor


Redimension/N=(numsm) S11,S22,S33,S44,S55,S66,S77,Sd

Redimension/N=(nummet) M11,M22,M33,Md

end



Function makeepd()

setdatafolder root:spectral:Chiraldata
wave CNTAtlas = CNTAtlas_zero

duplicate/o CNTAtlas CNTAtlas_calc

wave newatlas = CNTAtlas_calc

variable i,j

for(i=0;i<(dimsize(CNTAtlas,0)); i=i+1)

	for(j=0;j<dimsize(CNTAtlas,1); j=j+1)
	variable SM = newatlas[i][2] 
	//variable d = newatlas[i][3]
	variable n =newatlas[i][0]
	variable m =newatlas[i][1]
	if(j>3)
	
	if(SM)
	
		if(j !=6 && j != 9 && j !=12)
		
		newatlas[i][j] = enmp(n,m,j-3)
		//newatlas[i][j] = ek(n,m,j-3)
		endif
	
	else
		//cant get empirical formula to work right for ng tubes yet. 
		if(j ==6 || j == 9 || j ==12)
		
		newatlas[i][j] = enmp(n,m,j-3)
		//newatlas[i][j] = ek(n,m,j-3)
		endif
		
	endif
	
	endif
	
	
	endfor

endfor

end











Function diameterpeaks(d, evornm)   //this is from fitting lines to the chiral curves as a function of 1/d
	variable d 
	variable evornm
	
	make/o/n=6 diameterpeakwave
	
	diameterpeakwave[0] =200.35 + 1087*d
	diameterpeakwave[1] =138.96+ 586.42*d
	diameterpeakwave[2] =90.156+293.18*d
	diameterpeakwave[3] =136.85+215.38*d
	diameterpeakwave[4] =139.36+149.83*d
	diameterpeakwave[5] =114.92+136.25*d
	diameterpeakwave[6] =128.14+104.51*d
	
	
	if(evornm)
	diameterpeakwave = 1240/diameterpeakwave
	endif
	
	print diameterpeakwave
end