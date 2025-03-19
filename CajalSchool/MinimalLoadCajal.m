%MinimalLoadCajal

chPFCxsup=input('Choose the number of LFP PFCx superficial: ');
chPFCxdeep=input('Choose the number of LFP PFCx deep: ');
chHpc=input('Choose the number of LFP Hpc rip: ');

clear LFPs
clear LFP
clear S

res=pwd;
disp(pwd)

try
load StateEpochSB Wake REMEpoch SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
WakeEpoch=Wake-TotalNoiseEpoch;
catch
load SleepScoring_OBGamma Wake REMEpoch SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
WakeEpoch=Wake-TotalNoiseEpoch; 
end


load SleepSubstages
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
WAKE=Epoch{5};

EpochForDelta=SWSEpoch;
EpochForDelta=or(N2,N3);

LFPs=LoadLFPsCajal([chPFCxsup chPFCxdeep chHpc]);
try
    LFPs=tsdArray(LFPs);
end

nsup=1;
ndeep=2;

rg=Range(LFPs{1},'s');

Delta=FindDeltaCajal(chPFCxdeep,chPFCxsup,EpochForDelta,2);
DeltaDeep=FindDeltaCajal(chPFCxdeep,[],EpochForDelta,2);
DeltaSup=FindDeltaCajal([],chPFCxsup,EpochForDelta,2);

Spi=ObservationSpindlesSingle(LFPs{nsup},EpochForDelta,[10 15]); 
