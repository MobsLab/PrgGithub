%AnalysisKB04042019.m



load('SleepSubstages.mat')
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
Wake=Epoch{5};
swaPF=Epoch{8};
swaOB=Epoch{9};

[aft_cell,bef_cell]=transEpoch(N1,Wake);
SWSEpoch=or(or(N1,N2),N3);
SWEpoch=mergeCloseIntervals(SWSEpoch,1);

[SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(Wake,SWSEpoch,REM,15);

Stsd=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
f=Spectro{3};

figure, imagesc(Spectro{2}*1E4,Spectro{3},10*log10(Spectro{1}')), axis xy

[M,S,t]=AverageSpectrogram(Stsd,f,tps,binSize,nbBins,plo,smo,logplot)

[A,S,tps]=AverageNormalizedDurationTsd(Stsd,Wake,20,1);



