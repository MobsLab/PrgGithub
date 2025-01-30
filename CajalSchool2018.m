%Caja School 2018 

loadSubstageCajal


% clear
% close all
% loadSubstageCajal
% listChannel
% lfp=LFPs{1};
% CajalSchool2018
% lfp=LFPs{2};
% CajalSchool2018
% lfp=LFPs{3};
% CajalSchool2018
% lfp=LFPs{4};
% CajalSchool2018

load SpikeData
numNeurons=GetSpikesFromStructure('PFCx');
S=S(numNeurons);

load StateEpochSB Wake REMEpoch SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
WakeEpoch=Wake-TotalNoiseEpoch;

load SleepSubstages Epoch
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
WAKE=Epoch{5};

load Spindles
spi=ts(spindles_high_PFCx(:,2)*1E4);

try
load ripples
end



%%

tic

EpochSpiDetect=or(N2,N3);
%EpochSpiDetect=subset(N2,5:300);
dur=sum(End(EpochSpiDetect,'s')-Start(EpochSpiDetect,'s'));

Spi68 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[6 8],'threshold',[3,4]);
Spi810 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[8 10],'threshold',[3,4]);
Spi1012 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[10 12],'threshold',[3,4]);
Spi1214 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[12 14],'threshold',[3,4]);
Spi1416 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[14 16],'threshold',[3,4]);
Spi1618 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[16 18],'threshold',[3,4]);
Spi1820 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[18 20],'threshold',[3,4]);
Spi2022 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[20 22],'threshold',[3,4]);
Spi2224 = FindSpindlesKJ(lfp, EpochSpiDetect, 'frequency_band',[22 24],'threshold',[3,4]);

[Ca,B]=CrossCorr(Spi68(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Cb,B]=CrossCorr(Spi810(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Cc,B]=CrossCorr(Spi1012(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Cd,B]=CrossCorr(Spi1214(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Ce,B]=CrossCorr(Spi1416(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Cf,B]=CrossCorr(Spi1618(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Cg,B]=CrossCorr(Spi1820(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Ch,B]=CrossCorr(Spi2022(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);
[Ci,B]=CrossCorr(Spi2224(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),3,600);

figure, 
subplot(6,2,1),hold on,
plot([7:2:23],[length(Spi68), length(Spi810),length(Spi1012),length(Spi1214),length(Spi1416),length(Spi1618),length(Spi1820),length(Spi2022),length(Spi2224)]/dur,'ko-','linewidth',2)
subplot(6,2,[2,4]),hold on,
plot(B/1E3,runmean(Ca,2),'color',[0.4 0 0])
plot(B/1E3,runmean(Cb,2),'color',[0.5 0 0])
plot(B/1E3,runmean(Cc,2),'color',[0.6 0 0])
plot(B/1E3,runmean(Cd,2),'color',[0.7 0 0])
plot(B/1E3,runmean(Ce,2),'color',[0.8 0 0])
plot(B/1E3,runmean(Cf,2),'color',[0.9 0 0])
plot(B/1E3,runmean(Cg,2),'color',[1 0 0])

subplot(6,2,3),plot(B/1E3,runmean(Ca,2),'k'), ylabel('68')
subplot(6,2,5),plot(B/1E3,runmean(Cb,2),'k'), ylabel('810')
subplot(6,2,6),plot(B/1E3,runmean(Cc,2),'k'), ylabel('1012')
subplot(6,2,7),plot(B/1E3,runmean(Cd,2),'k'), ylabel('1214')
subplot(6,2,8),plot(B/1E3,runmean(Ce,2),'k'), ylabel('1416')
subplot(6,2,9),plot(B/1E3,runmean(Cf,2),'k'), ylabel('1618')
subplot(6,2,10),plot(B/1E3,runmean(Cg,2),'k'), ylabel('1820')
subplot(6,2,11),plot(B/1E3,runmean(Ch,2),'k'), ylabel('2022')
subplot(6,2,12),plot(B/1E3,runmean(Ci,2),'k'), ylabel('2224')


[m68,s,tps]=mETAverage(Spi68(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m810,s,tps]=mETAverage(Spi810(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m1012,s,tps]=mETAverage(Spi1012(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m1214,s,tps]=mETAverage(Spi1214(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m1416,s,tps]=mETAverage(Spi1416(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m1618,s,tps]=mETAverage(Spi1618(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m1820,s,tps]=mETAverage(Spi1820(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m2022,s,tps]=mETAverage(Spi2022(:,2)*1E4,Range(lfp),Data(lfp),1,2000);
[m2224,s,tps]=mETAverage(Spi2224(:,2)*1E4,Range(lfp),Data(lfp),1,2000);

figure, 
subplot(6,2,1),hold on,
plot([7:2:23],[max(m68)-min(m68) max(m810)-min(m810) max(m1012)-min(m1012) max(m1214)-min(m1214) max(m1416)-min(m1416) max(m1618)-min(m1618) max(m1820)-min(m1820) max(m2022)-min(m2022) max(m2224)-min(m2224)],'ko-','linewidth',2)
subplot(6,2,[2,4]),hold on,
plot(tps,runmean(m68,2),'color',[0.2 0 0])
plot(tps,runmean(m810,2),'color',[0.3 0 0])
plot(tps,runmean(m1012,2),'color',[0.4 0 0])
plot(tps,runmean(m1214,2),'color',[0.5 0 0])
plot(tps,runmean(m1416,2),'color',[0.6 0 0])
plot(tps,runmean(m1618,2),'color',[0.7 0 0])
plot(tps,runmean(m1820,2),'color',[0.8 0 0])
plot(tps,runmean(m2022,2),'color',[0.9 0 0])
plot(tps,runmean(m2224,2),'color',[1 0 0])

subplot(6,2,3),plot(tps,runmean(m68,2),'k'), ylabel('68')
subplot(6,2,5),plot(tps,runmean(m810,2),'k'), ylabel('810')
subplot(6,2,6),plot(tps,runmean(m1012,2),'k'), ylabel('1012')
subplot(6,2,7),plot(tps,runmean(m1214,2),'k'), ylabel('1214')
subplot(6,2,8),plot(tps,runmean(m1416,2),'k'), ylabel('1416')
subplot(6,2,9),plot(tps,runmean(m1618,2),'k'), ylabel('1618')
subplot(6,2,10),plot(tps,runmean(m1820,2),'k'), ylabel('1820')
subplot(6,2,11),plot(tps,runmean(m2022,2),'k'), ylabel('2022')
subplot(6,2,12),plot(tps,runmean(m2224,2),'k'), ylabel('2224')





[m68,s,tps]=mETAverage(Spi68(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m810,s,tps]=mETAverage(Spi810(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m1012,s,tps]=mETAverage(Spi1012(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m1214,s,tps]=mETAverage(Spi1214(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m1416,s,tps]=mETAverage(Spi1416(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m1618,s,tps]=mETAverage(Spi1618(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m1820,s,tps]=mETAverage(Spi1820(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m2022,s,tps]=mETAverage(Spi2022(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);
[m2224,s,tps]=mETAverage(Spi2224(:,2)*1E4,Range(LFPs{2}),Data(LFPs{2}),1,2000);

figure, 
subplot(6,2,1),hold on,
plot([7:2:23],[max(m68)-min(m68) max(m810)-min(m810) max(m1012)-min(m1012) max(m1214)-min(m1214) max(m1416)-min(m1416) max(m1618)-min(m1618) max(m1820)-min(m1820) max(m2022)-min(m2022) max(m2224)-min(m2224)],'ko-','linewidth',2)

subplot(6,2,3),hold on,plot(tps,runmean(m68,2),'k'), ylabel('68')
subplot(6,2,5),hold on,plot(tps,runmean(m810,2),'k'), ylabel('810')
subplot(6,2,6),hold on,plot(tps,runmean(m1012,2),'k'), ylabel('1012')
subplot(6,2,7),hold on,plot(tps,runmean(m1214,2),'k'), ylabel('1214')
subplot(6,2,8),hold on,plot(tps,runmean(m1416,2),'k'), ylabel('1416')
subplot(6,2,9),hold on,plot(tps,runmean(m1618,2),'k'), ylabel('1618')
subplot(6,2,10),hold on,plot(tps,runmean(m1820,2),'k'), ylabel('1820')
subplot(6,2,11),hold on,plot(tps,runmean(m2022,2),'k'), ylabel('2022')
subplot(6,2,12),hold on,plot(tps,runmean(m2224,2),'k'), ylabel('2224')


[m68,s,tps]=mETAverage(Spi68(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m810,s,tps]=mETAverage(Spi810(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m1012,s,tps]=mETAverage(Spi1012(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m1214,s,tps]=mETAverage(Spi1214(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m1416,s,tps]=mETAverage(Spi1416(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m1618,s,tps]=mETAverage(Spi1618(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m1820,s,tps]=mETAverage(Spi1820(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m2022,s,tps]=mETAverage(Spi2022(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);
[m2224,s,tps]=mETAverage(Spi2224(:,2)*1E4,Range(LFPs{3}),Data(LFPs{3}),1,2000);

subplot(6,2,1),hold on,
plot([7:2:23],[max(m68)-min(m68) max(m810)-min(m810) max(m1012)-min(m1012) max(m1214)-min(m1214) max(m1416)-min(m1416) max(m1618)-min(m1618) max(m1820)-min(m1820) max(m2022)-min(m2022) max(m2224)-min(m2224)],'bo-','linewidth',2)

subplot(6,2,3),hold on,plot(tps,runmean(m68,2),'b'), ylabel('68')
subplot(6,2,5),hold on,plot(tps,runmean(m810,2),'b'), ylabel('810')
subplot(6,2,6),hold on,plot(tps,runmean(m1012,2),'b'), ylabel('1012')
subplot(6,2,7),hold on,plot(tps,runmean(m1214,2),'b'), ylabel('1214')
subplot(6,2,8),hold on,plot(tps,runmean(m1416,2),'b'), ylabel('1416')
subplot(6,2,9),hold on,plot(tps,runmean(m1618,2),'b'), ylabel('1618')
subplot(6,2,10),hold on,plot(tps,runmean(m1820,2),'b'), ylabel('1820')
subplot(6,2,11),hold on,plot(tps,runmean(m2022,2),'b'), ylabel('2022')
subplot(6,2,12),hold on,plot(tps,runmean(m2224,2),'b'), ylabel('2224')


[m68,s,tps]=mETAverage(Spi68(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m810,s,tps]=mETAverage(Spi810(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m1012,s,tps]=mETAverage(Spi1012(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m1214,s,tps]=mETAverage(Spi1214(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m1416,s,tps]=mETAverage(Spi1416(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m1618,s,tps]=mETAverage(Spi1618(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m1820,s,tps]=mETAverage(Spi1820(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m2022,s,tps]=mETAverage(Spi2022(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);
[m2224,s,tps]=mETAverage(Spi2224(:,2)*1E4,Range(LFPs{4}),Data(LFPs{4}),1,2000);

subplot(6,2,1),hold on,
plot([7:2:23],[max(m68)-min(m68) max(m810)-min(m810) max(m1012)-min(m1012) max(m1214)-min(m1214) max(m1416)-min(m1416) max(m1618)-min(m1618) max(m1820)-min(m1820) max(m2022)-min(m2022) max(m2224)-min(m2224)],'ro-','linewidth',2)
subplot(6,2,3),hold on,plot(tps,runmean(m68,2),'r'), ylabel('68')
subplot(6,2,5),hold on,plot(tps,runmean(m810,2),'r'), ylabel('810')
subplot(6,2,6),hold on,plot(tps,runmean(m1012,2),'r'), ylabel('1012')
subplot(6,2,7),hold on,plot(tps,runmean(m1214,2),'r'), ylabel('1214')
subplot(6,2,8),hold on,plot(tps,runmean(m1416,2),'r'), ylabel('1416')
subplot(6,2,9),hold on,plot(tps,runmean(m1618,2),'r'), ylabel('1618')
subplot(6,2,10),hold on,plot(tps,runmean(m1820,2),'r'), ylabel('1820')
subplot(6,2,11),hold on,plot(tps,runmean(m2022,2),'r'), ylabel('2022')
subplot(6,2,12),hold on,plot(tps,runmean(m2224,2),'r'), ylabel('2224')



toc

%%
if 0
[Cn1,B]=CrossCorr(Range(Restrict(spi,N1)),Range(PoolNeurons(S,1:length(S))),3,600);
[Cn2,B]=CrossCorr(Range(Restrict(spi,N2)),Range(PoolNeurons(S,1:length(S))),3,600);
[Cn3,B]=CrossCorr(Range(Restrict(spi,N3)),Range(PoolNeurons(S,1:length(S))),3,600);
[Crem,B]=CrossCorr(Range(Restrict(spi,REM)),Range(PoolNeurons(S,1:length(S))),3,600);
[Cwake,B]=CrossCorr(Range(Restrict(spi,WAKE)),Range(PoolNeurons(S,1:length(S))),3,600);


figure, hold on,
plot(B/1E3,runmean(Cn1,2),'r')
plot(B/1E3,runmean(Cn2,2),'m')
plot(B/1E3,runmean(Cn3,2),'b')
plot(B/1E3,runmean(Crem,2),'k')
plot(B/1E3,runmean(Cwake,2),'g')

end
