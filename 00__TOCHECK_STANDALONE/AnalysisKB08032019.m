%AnalysisKB08032019.m


cd /media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014

load('SleepScoring_OBGamma.mat')


load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataL/Spectrum12.mat')

StsdHpc=tsd(t*1E4,10*log10(Sp)); 
[Mhpc,S,tps]=AverageSpectrogram(StsdHpc,f,ts(End(REMEpoch)),200,1000);

load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataL/Spectrum27.mat')
StsdOccLpfc=tsd(t*1E4,10*log10(Sp));
load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataL/Spectrum29.mat')
StsdNoOccLpfc=tsd(t*1E4,10*log10(Sp));

[MOccLpfc,S,tps]=AverageSpectrogram(StsdOccLpfc,f,ts(End(REMEpoch)),200,1000);
[MNoOccLpfc,S,tps]=AverageSpectrogram(StsdNoOccLpfc,f,ts(End(REMEpoch)),200,1000);





figure, 
subplot(2,1,1), hold on, 
plot(fL,nanmean(Data(Restrict(StsdOccLpfc,Wake))),'k')
plot(fL,nanmean(Data(Restrict(StsdOccLpfc,SWSEpoch))),'b')
plot(fL,nanmean(Data(Restrict(StsdOccLpfc,REMEpoch))),'r')
subplot(2,1,2), hold on, 
plot(fL,nanmean(Data(Restrict(StsdNoOccLpfc,Wake))),'k')
plot(fL,nanmean(Data(Restrict(StsdNoOccLpfc,SWSEpoch))),'b')
plot(fL,nanmean(Data(Restrict(StsdNoOccLpfc,REMEpoch))),'r')

load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataH/Spectrum17.mat')
StsdOccH=tsd(t*1E4,10*log10(Sp));
load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataH/Spectrum8.mat')
StsdNoOccH=tsd(t*1E4,10*log10(Sp));
load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataL/Spectrum17.mat')
StsdOccL=tsd(t*1E4,10*log10(Sp));
load('/media/DataMOBsRAIDN/DataKB/Mouse106/OPTO-Mouse-106-02012014/SpectrumDataL/Spectrum8.mat')
StsdNoOccL=tsd(t*1E4,10*log10(Sp));

[MOccL,S,tps]=AverageSpectrogram(StsdOccL,f,ts(End(REMEpoch)),200,1000);
[MNoOccL,S,tps]=AverageSpectrogram(StsdNoOccL,f,ts(End(REMEpoch)),200,1000);

figure, 
subplot(2,2,1), hold on, 
plot(fL,nanmean(Data(Restrict(StsdOccL,Wake))),'k')
plot(fL,nanmean(Data(Restrict(StsdOccL,SWSEpoch))),'b')
plot(fL,nanmean(Data(Restrict(StsdOccL,REMEpoch))),'r')
subplot(2,2,2), hold on, 
plot(fH,nanmean(Data(Restrict(StsdOccH,Wake))),'k')
plot(fH,nanmean(Data(Restrict(StsdOccH,SWSEpoch))),'b')
plot(fH,nanmean(Data(Restrict(StsdOccH,REMEpoch))),'r')

subplot(2,2,3), hold on, 
plot(fL,nanmean(Data(Restrict(StsdNoOccL,Wake))),'k')
plot(fL,nanmean(Data(Restrict(StsdNoOccL,SWSEpoch))),'b')
plot(fL,nanmean(Data(Restrict(StsdNoOccL,REMEpoch))),'r')
subplot(2,2,4), hold on, 
plot(fH,nanmean(Data(Restrict(StsdNoOccH,Wake))),'k')
plot(fH,nanmean(Data(Restrict(StsdNoOccH,SWSEpoch))),'b')
plot(fH,nanmean(Data(Restrict(StsdNoOccH,REMEpoch))),'r')


Epoch=REMEpoch;
[r,p]=corrcoef([Data(Restrict(StsdNoOccL,Epoch)),Data(Restrict(StsdOccL,Epoch)) Data(Restrict(StsdNoOccLpfc,Epoch)),Data(Restrict(StsdOccLpfc,Epoch)),Data(Restrict(StsdHpc,Epoch))]);
figure, imagesc(r), axis xy, title('REM')






Epoch=REMEpoch;
[r,p]=corrcoef([Data(Restrict(StsdNoOccL,Epoch)),Data(Restrict(StsdOccL,Epoch)) Data(Restrict(StsdNoOccLpfc,Epoch)),Data(Restrict(StsdOccLpfc,Epoch)),Data(Restrict(StsdHpc,Epoch))]);
figure, imagesc(r), axis xy, title('REM - OB not occ, OB occ, PFC not occ, PFC occ, Hpc')
Epoch=SWSEpoch;
[r,p]=corrcoef([Data(Restrict(StsdNoOccL,Epoch)),Data(Restrict(StsdOccL,Epoch)) Data(Restrict(StsdNoOccLpfc,Epoch)),Data(Restrict(StsdOccLpfc,Epoch)),Data(Restrict(StsdHpc,Epoch))]);
figure, imagesc(r), axis xy, title('SWS - OB not occ, OB occ, PFC not occ, PFC occ, Hpc')
title('SWS')
Epoch=Wake;
[r,p]=corrcoef([Data(Restrict(StsdNoOccL,Epoch)),Data(Restrict(StsdOccL,Epoch)) Data(Restrict(StsdNoOccLpfc,Epoch)),Data(Restrict(StsdOccLpfc,Epoch)),Data(Restrict(StsdHpc,Epoch))]);
figure, imagesc(r), axis xy, title('Wake - OB not occ, OB occ, PFC not occ, PFC occ, Hpc')




clear
load('H_Low_Spectrum.mat')
StsdHpc=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
load('B_Low_Spectrum.mat')
StsdOB=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
load('PFCx_Low_Spectrum.mat')
StsdPFC=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
load SleepScoring_OBGamma Wake REMEpoch SWSEpoch
[SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(Wake,SWSEpoch,REMEpoch,15);
[A1,S,tps]=AverageNormalizedDurationTsd(StsdHpc,SleepCycle2,50,1);
[A2,S,tps]=AverageNormalizedDurationTsd(StsdPFC,SleepCycle2,50,1);
[A3,S,tps]=AverageNormalizedDurationTsd(StsdOB,SleepCycle2,50,1);
figure, 
subplot(3,1,1), imagesc(A1), axis xy
subplot(3,1,2), imagesc(A2), axis xy
subplot(3,1,3), imagesc(A3), axis xy

try
load('SleepSubstages.mat')
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
Wake=Epoch{5};

catch
    [features, Namesfeatures, EpochSleep, noiseEpoch] = FindNREMfeatures('scoring','accelero');
    [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch, varargin);
end

load('DeltaWaves.mat')

clear C
for i=1:length(st)
    C(i,:)=CrossCorr(st(id(i)),Start(deltas_PFCx),200,500);
end



st=Start(N1);
en=End(N1); 
dur=End(N1)-Start(N1);
[BE,id]=sort(dur);

C2=sqrt((C-10).^2)/10;
figure, imagesc(C2)
colormap(gray)

idx=find(dur>4);

figure, [fh,sq,sweeps] = RasterPETH(ts(Start(deltas_PFCx)), ts(st(idx)), -150000, +250000,'BinSize',5000,'Markers',{ts(en(idx))},'MarkerTypes',{'ro','r'});



st=Start(N2);
en=End(N2); 
dur=End(N2)-Start(N2);
idx=find(dur>4);
figure, [fh,sq,sweeps] = RasterPETH(ts(Start(deltas_PFCx)), ts(st(idx)), -150000, +250000,'BinSize',5000,'Markers',{ts(en(idx))},'MarkerTypes',{'ro','r'});

%-------------------------------------------------------------------------

load('DeltaWaves.mat')
load('SleepSubstages.mat')
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
Wake=Epoch{5};

tpsEvents=deltas_PFCx;

try
    load('DownState.mat'); tpsEvents=down_PFCx;
end

a=60; b=500;
[Cn1s,B]=CrossCorr(Start(N1),Start(tpsEvents),a,b);
[Cn2s,B]=CrossCorr(Start(N2),Start(tpsEvents),a,b);
[Cn3s,B]=CrossCorr(Start(N3),Start(tpsEvents),a,b);
[Cres,B]=CrossCorr(Start(REM),Start(tpsEvents),a,b);
[Cwas,B]=CrossCorr(Start(Wake),Start(tpsEvents),a,b);

[Cn1e,B]=CrossCorr(End(N1),Start(tpsEvents),a,b);
[Cn2e,B]=CrossCorr(End(N2),Start(tpsEvents),a,b);
[Cn3e,B]=CrossCorr(End(N3),Start(tpsEvents),a,b);
[Cree,B]=CrossCorr(End(REM),Start(tpsEvents),a,b);
[Cwae,B]=CrossCorr(End(Wake),Start(tpsEvents),a,b);

figure, 
subplot(5,2,1), plot(B/1E3,Cn1s,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,2), plot(B/1E3,Cn1e,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,3), plot(B/1E3,Cn2s,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,4), plot(B/1E3,Cn2e,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,5), plot(B/1E3,Cn3s,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,6), plot(B/1E3,Cn3e,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,7), plot(B/1E3,Cres,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,8), plot(B/1E3,Cree,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,9), plot(B/1E3,Cwas,'k'), hold on, line([0 0],ylim,'color','r')
subplot(5,2,10), plot(B/1E3,Cwae,'k'), hold on, line([0 0],ylim,'color','r')


%------------------------------------------------------------------------

load('DeltaWaves.mat')
load('SleepSubstages.mat')
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
Wake=Epoch{5};

tpsEvents=deltas_PFCx;
[h1,b1]=hist(diff(Start(and(tpsEvents,N1))),[0:200:10E4]);
[h2,b2]=hist(diff(Start(and(tpsEvents,N2))),[0:200:10E4]);
[h3,b3]=hist(diff(Start(and(tpsEvents,N3))),[0:200:10E4]);
figure, 
subplot(1,2,1), hold on, stairs(b1,h1,'b'),stairs(b2,h2,'k'), stairs(b3,h3,'r'),xlim([0 4E4])
subplot(1,2,2), hold on, plot(b1,runmean(h1,1),'b'),plot(b2,runmean(h2,1),'k'), plot(b3,runmean(h3,1),'r'),xlim([0 4E4])

