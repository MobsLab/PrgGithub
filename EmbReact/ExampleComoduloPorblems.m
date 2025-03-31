cd /media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Cond/Cond5
clear all
Epoch=intervalSet(320*1e4,370*1e4);
load('B_Low_Spectrum.mat')
SptsdBLow=tsd(Spectro{2}*1e4,Spectro{1});
fLow=Spectro{3};
load('B_High_Spectrum.mat')
SptsdBHigh=tsd(Spectro{2}*1e4,Spectro{1});
fHigh=Spectro{3};
plot(Spectro{3},mean(Restrict(SptsdBLow,intervalSet(300*1e4,500*1e4))));
load(['LFPData/LFP',num2str(ch),'.mat'])
LowFreqRg=[2 20]
HighFreqRg=[30 200];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
[LowFreqVals,HighFreqVals,Dkl]=ComoduloVarBandwidth(Restrict(LFP,Epoch),Restrict(LFP,Epoch),LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,0)
figure
imagesc(LowFreqVals,HighFreqVals,(Dkl')), axis xy
hold on
meanSpec=mean(Restrict(SptsdBLow,Epoch));
plot(fLow,100*meanSpec/max(meanSpec)+50,'w','linewidth',3);
meanSpec=mean(Restrict(SptsdBHigh,Epoch));
plot(10*meanSpec/max(meanSpec)+3,fHigh,'k','linewidth',3);

[VFreq0,VFreq1,Comodulo]=comodulo(Restrict(LFP,Epoch),Restrict(LFP,Epoch),LowFreqRg,0);
figure
imagesc(VFreq0,VFreq1,(Comodulo)), axis xy
hold on
meanSpec=mean(Restrict(SptsdBLow,Epoch));
plot(fLow,100*meanSpec/max(meanSpec)+50,'w','linewidth',3);
meanSpec=mean(Restrict(SptsdBHigh,Epoch));
plot(10*meanSpec/max(meanSpec)+3,fHigh,'k','linewidth',3);



cd /media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Habituation
clear all
Epoch=intervalSet(430*1e4,480*1e4);
load('B_Low_Spectrum.mat')
SptsdBLow=tsd(Spectro{2}*1e4,Spectro{1});
fLow=Spectro{3};
load('B_High_Spectrum.mat')
SptsdBHigh=tsd(Spectro{2}*1e4,Spectro{1});
fHigh=Spectro{3};
load(['LFPData/LFP',num2str(ch),'.mat'])
LowFreqRg=[2 20]
HighFreqRg=[30 200];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
[LowFreqVals,HighFreqVals,Dkl]=ComoduloVarBandwidth(Restrict(LFP,Epoch),Restrict(LFP,Epoch),LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,0);
figure
imagesc(LowFreqVals,HighFreqVals,log(Dkl')), axis xy
hold on
meanSpec=mean(Restrict(SptsdBLow,Epoch));
plot(fLow,100*meanSpec/max(meanSpec)+50,'w','linewidth',3);
meanSpec=mean(Restrict(SptsdBHigh,Epoch));
plot(10*meanSpec/max(meanSpec)+3,fHigh,'k','linewidth',3);

[VFreq0,VFreq1,Comodulo]=comodulo(Restrict(LFP,Epoch),Restrict(LFP,Epoch),LowFreqRg,0);
figure
imagesc(VFreq0,VFreq1,(Comodulo)), axis xy
hold on
meanSpec=mean(Restrict(SptsdBLow,Epoch));
plot(fLow,100*meanSpec/max(meanSpec)+50,'w','linewidth',3);
meanSpec=mean(Restrict(SptsdBHigh,Epoch));
plot(10*meanSpec/max(meanSpec)+3,fHigh,'k','linewidth',3);




