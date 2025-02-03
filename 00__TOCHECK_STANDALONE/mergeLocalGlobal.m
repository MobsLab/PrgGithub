% Merge LocGlobAssignment

load LocalGlobalAssignment1

    
LocalDvtGlobDvtA1=LocalDvtGlobDvtA;
LocalDvtGlobDvtB1=LocalDvtGlobDvtB;

LocalDvtGlobStdA1=LocalDvtGlobStdA;
LocalDvtGlobStdB1=LocalDvtGlobStdB;

LocalStdGlobDvtA1=LocalStdGlobDvtA;
LocalStdGlobDvtB1=LocalStdGlobDvtB;

LocalStdGlobStdA1=LocalStdGlobStdA;
LocalStdGlobStdB1=LocalStdGlobStdB;

OmiAAAA1=OmiAAAA;
OmiBBBB1=OmiBBBB;

OmissionRareA1=OmissionRareA;
OmissionRareB1=OmissionRareB;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    

load LocalGlobalAssignment2

    
LocalDvtGlobDvtA2=LocalDvtGlobDvtA;
LocalDvtGlobDvtB2=LocalDvtGlobDvtB;

LocalDvtGlobStdA2=LocalDvtGlobStdA;
LocalDvtGlobStdB2=LocalDvtGlobStdB;

LocalStdGlobDvtA2=LocalStdGlobDvtA;
LocalStdGlobDvtB2=LocalStdGlobDvtB;

LocalStdGlobStdA2=LocalStdGlobStdA;
LocalStdGlobStdB2=LocalStdGlobStdB;

OmiAAAA2=OmiAAAA;
OmiBBBB2=OmiBBBB;

OmissionRareA2=OmissionRareA;
OmissionRareB2=OmissionRareB;

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>    
 
LocalDvtGlobDvtA=[LocalDvtGlobDvtA1;LocalDvtGlobDvtA2];
LocalDvtGlobDvtB=[LocalDvtGlobDvtB1;LocalDvtGlobDvtB2];

LocalDvtGlobStdA=[LocalDvtGlobStdA1;LocalDvtGlobStdA2];
LocalDvtGlobStdB=[LocalDvtGlobStdB1;LocalDvtGlobStdB2];

LocalStdGlobDvtA=[LocalStdGlobDvtA1;LocalStdGlobDvtA2];
LocalStdGlobDvtB=[LocalStdGlobDvtB1;LocalStdGlobDvtB2];

LocalStdGlobStdA=[LocalStdGlobStdA1;LocalStdGlobStdA2];
LocalStdGlobStdB=[LocalStdGlobStdB1;LocalStdGlobStdB2];

OmiAAAA=[OmiAAAA1;OmiAAAA2];
OmiBBBB=[OmiBBBB1;OmiBBBB2];

OmissionRareA=[OmissionRareA1;OmissionRareA2];
OmissionRareB=[OmissionRareB1;OmissionRareB2];



save LocalGlobalTotalAssignment LocalDvtGlobDvtA LocalDvtGlobDvtB LocalDvtGlobStdA LocalDvtGlobStdB LocalStdGlobDvtA LocalStdGlobDvtB LocalStdGlobStdA LocalStdGlobStdB OmiAAAA OmiBBBB OmissionRareA OmissionRareB
 



