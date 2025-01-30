%CajalSchool2018

loadSubstageCajal
disp(' ')
numLFP=input('Choose the number of LFP: ');

LFPtemp=LoadLFPsCajal(numLFP);
LFP=LFPtemp{1};
ti=num2str(numLFP);

SpiO=ObservationSpindlesSingle(LFP,SWSEpoch,[10 15]); 

% 
% try
% clear LFP
% tempchPFCsp=load([res,'/ChannelsToAnalyse/PFCx_spindle.mat'],'channel');
% chPFCxsp=tempchPFCsp.channel;
% eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCxsp),'.mat'');']);
% ti='PFCx spindles';
% catch
%     clear LFP
% tempchPFCs=load([res,'/ChannelsToAnalyse/PFCx_sup.mat'],'channel');
% chPFCxsup=tempchPFCs.channel;
% eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCxsup),'.mat'');'])
% ti='PFCx sup';
% end

%%

tic

EpochSpiDetect=SWSEpoch;
%EpochSpiDetect=subset(N2,5:300);
dur=sum(End(EpochSpiDetect,'s')-Start(EpochSpiDetect,'s'))

Spi68 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[6 8]);
Spi810 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[8 10]);
Spi1012 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[10 12]);
Spi1214 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[12 14]);
Spi1416 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[14 16]);
Spi1618 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[16 18]);
Spi1820 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[18 20]);
Spi2022 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[20 22]);
Spi2224 = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',[22 24]);

[m1sp,s1,tps1]=mETAverage(Spi68(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m2sp,s2,tps2]=mETAverage(Spi810(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m3sp,s3,tps3]=mETAverage(Spi1012(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m4sp,s3,tps3]=mETAverage(Spi1214(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m5sp,s3,tps3]=mETAverage(Spi1416(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m6sp,s3,tps3]=mETAverage(Spi1618(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m7sp,s3,tps3]=mETAverage(Spi1820(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m8sp,s3,tps3]=mETAverage(Spi2022(:,2)*1E4,Range(LFP),Data(LFP),1,1500);
[m9sp,s3,tps3]=mETAverage(Spi2224(:,2)*1E4,Range(LFP),Data(LFP),1,1500);

figure, 
subplot(5,2,1), hold on, 
plot(tps2,m1sp,'color',[0.2 0 0])
plot(tps2,m2sp,'color',[0.3 0 0])
plot(tps2,m3sp,'color',[0.4 0 0])
plot(tps2,m4sp,'color',[0.5 0 0])
plot(tps2,m5sp,'color',[0.6 0 0])
plot(tps2,m6sp,'color',[0.7 0 0])
plot(tps2,m7sp,'color',[0.8 0 0])
plot(tps2,m8sp,'color',[0.9 0 0])
plot(tps2,m9sp,'color',[1 0 0])

subplot(5,2,2), hold on, plot(tps2,m1sp,'k'), ylabel('68'),ylim([-2000 2000])
subplot(5,2,3), hold on, plot(tps2,m2sp,'k'), ylabel('810'),ylim([-2000 2000])
subplot(5,2,4), hold on, plot(tps2,m3sp,'k'), ylabel('1012'),ylim([-2000 2000])
subplot(5,2,5), hold on, plot(tps2,m4sp,'k'), ylabel('1214'),ylim([-2000 2000])
subplot(5,2,6), hold on, plot(tps2,m5sp,'k'), ylabel('1416'),ylim([-2000 2000])
subplot(5,2,7), hold on, plot(tps2,m6sp,'k'), ylabel('1618'),ylim([-2000 2000])
subplot(5,2,8), hold on, plot(tps2,m7sp,'k'), ylabel('1820'),ylim([-2000 2000])
subplot(5,2,9), hold on, plot(tps2,m8sp,'k'), ylabel('2022'),ylim([-2000 2000])
subplot(5,2,10), hold on, plot(tps2,m9sp,'k'), ylabel('2224'),ylim([-2000 2000])

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

toc

%%

%%

yn=input('keep doing figures ? (y/n): ','s');

if yn=='y'
    
tref=End(down_PFCx);
[Cd1,B]=CrossCorr(tref, Spi68(:,1)*1E4,100,100);
[Cd2,B]=CrossCorr(tref, Spi810(:,1)*1E4,100,100);
[Cd3,B]=CrossCorr(tref, Spi1012(:,1)*1E4,100,100);
[Cd4,B]=CrossCorr(tref, Spi1214(:,1)*1E4,100,100);
[Cd5,B]=CrossCorr(tref, Spi1416(:,1)*1E4,100,100);
[Cd6,B]=CrossCorr(tref, Spi1618(:,1)*1E4,100,100);
[Cd7,B]=CrossCorr(tref, Spi1820(:,1)*1E4,100,100);
[Cd8,B]=CrossCorr(tref, Spi2022(:,1)*1E4,100,100);

figure, 
subplot(5,2,[1,3]), hold on,
plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0])
plot(B/1E3,runmean(Cd2,2),'color',[0.4 0 0])
plot(B/1E3,runmean(Cd3,2),'color',[0.5 0 0])
plot(B/1E3,runmean(Cd4,2),'color',[0.6 0 0],'linewidth',2)
plot(B/1E3,runmean(Cd5,2),'color',[0.7 0 0])
plot(B/1E3,runmean(Cd6,2),'color',[0.8 0 0])
plot(B/1E3,runmean(Cd7,2),'color',[0.9 0 0])
plot(B/1E3,runmean(Cd8,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spi vs End Down')
subplot(5,2,2), hold on,plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('68')
subplot(5,2,4), hold on,plot(B/1E3,runmean(Cd2,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('810')
subplot(5,2,5), hold on,plot(B/1E3,runmean(Cd3,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1012')
subplot(5,2,6), hold on,plot(B/1E3,runmean(Cd4,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1214')
subplot(5,2,7), hold on,plot(B/1E3,runmean(Cd5,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1416')
subplot(5,2,8), hold on,plot(B/1E3,runmean(Cd6,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1618')
subplot(5,2,9), hold on,plot(B/1E3,runmean(Cd7,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1820')
subplot(5,2,10), hold on,plot(B/1E3,runmean(Cd8,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('2022')



tref=Start(down_PFCx);
[Cd1,B]=CrossCorr(tref, Spi68(:,1)*1E4,100,100);
[Cd2,B]=CrossCorr(tref, Spi810(:,1)*1E4,100,100);
[Cd3,B]=CrossCorr(tref, Spi1012(:,1)*1E4,100,100);
[Cd4,B]=CrossCorr(tref, Spi1214(:,1)*1E4,100,100);
[Cd5,B]=CrossCorr(tref, Spi1416(:,1)*1E4,100,100);
[Cd6,B]=CrossCorr(tref, Spi1618(:,1)*1E4,100,100);
[Cd7,B]=CrossCorr(tref, Spi1820(:,1)*1E4,100,100);
[Cd8,B]=CrossCorr(tref, Spi2022(:,1)*1E4,100,100);

figure, 
subplot(5,2,[1,3]), hold on,
plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0])
plot(B/1E3,runmean(Cd2,2),'color',[0.4 0 0])
plot(B/1E3,runmean(Cd3,2),'color',[0.5 0 0])
plot(B/1E3,runmean(Cd4,2),'color',[0.6 0 0],'linewidth',2)
plot(B/1E3,runmean(Cd5,2),'color',[0.7 0 0])
plot(B/1E3,runmean(Cd6,2),'color',[0.8 0 0])
plot(B/1E3,runmean(Cd7,2),'color',[0.9 0 0])
plot(B/1E3,runmean(Cd8,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spi vs Start Down')
subplot(5,2,2), hold on,plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('68')
subplot(5,2,4), hold on,plot(B/1E3,runmean(Cd2,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('810')
subplot(5,2,5), hold on,plot(B/1E3,runmean(Cd3,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1012')
subplot(5,2,6), hold on,plot(B/1E3,runmean(Cd4,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1214')
subplot(5,2,7), hold on,plot(B/1E3,runmean(Cd5,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1416')
subplot(5,2,8), hold on,plot(B/1E3,runmean(Cd6,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1618')
subplot(5,2,9), hold on,plot(B/1E3,runmean(Cd7,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1820')
subplot(5,2,10), hold on,plot(B/1E3,runmean(Cd8,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('2022')



tref=End(deltas_PFCx);
[Cd1,B]=CrossCorr(tref, Spi68(:,1)*1E4,100,100);
[Cd2,B]=CrossCorr(tref, Spi810(:,1)*1E4,100,100);
[Cd3,B]=CrossCorr(tref, Spi1012(:,1)*1E4,100,100);
[Cd4,B]=CrossCorr(tref, Spi1214(:,1)*1E4,100,100);
[Cd5,B]=CrossCorr(tref, Spi1416(:,1)*1E4,100,100);
[Cd6,B]=CrossCorr(tref, Spi1618(:,1)*1E4,100,100);
[Cd7,B]=CrossCorr(tref, Spi1820(:,1)*1E4,100,100);
[Cd8,B]=CrossCorr(tref, Spi2022(:,1)*1E4,100,100);

figure, 
subplot(5,2,[1,3]), hold on,
plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0])
plot(B/1E3,runmean(Cd2,2),'color',[0.4 0 0])
plot(B/1E3,runmean(Cd3,2),'color',[0.5 0 0])
plot(B/1E3,runmean(Cd4,2),'color',[0.6 0 0],'linewidth',2)
plot(B/1E3,runmean(Cd5,2),'color',[0.7 0 0])
plot(B/1E3,runmean(Cd6,2),'color',[0.8 0 0])
plot(B/1E3,runmean(Cd7,2),'color',[0.9 0 0])
plot(B/1E3,runmean(Cd8,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spi vs End Delta')
subplot(5,2,2), hold on,plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('68')
subplot(5,2,4), hold on,plot(B/1E3,runmean(Cd2,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('810')
subplot(5,2,5), hold on,plot(B/1E3,runmean(Cd3,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1012')
subplot(5,2,6), hold on,plot(B/1E3,runmean(Cd4,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1214')
subplot(5,2,7), hold on,plot(B/1E3,runmean(Cd5,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1416')
subplot(5,2,8), hold on,plot(B/1E3,runmean(Cd6,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1618')
subplot(5,2,9), hold on,plot(B/1E3,runmean(Cd7,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1820')
subplot(5,2,10), hold on,plot(B/1E3,runmean(Cd8,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('2022')



tref=Start(deltas_PFCx);
[Cd1,B]=CrossCorr(tref, Spi68(:,1)*1E4,100,100);
[Cd2,B]=CrossCorr(tref, Spi810(:,1)*1E4,100,100);
[Cd3,B]=CrossCorr(tref, Spi1012(:,1)*1E4,100,100);
[Cd4,B]=CrossCorr(tref, Spi1214(:,1)*1E4,100,100);
[Cd5,B]=CrossCorr(tref, Spi1416(:,1)*1E4,100,100);
[Cd6,B]=CrossCorr(tref, Spi1618(:,1)*1E4,100,100);
[Cd7,B]=CrossCorr(tref, Spi1820(:,1)*1E4,100,100);
[Cd8,B]=CrossCorr(tref, Spi2022(:,1)*1E4,100,100);

figure, 
subplot(5,2,[1,3]), hold on,
plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0])
plot(B/1E3,runmean(Cd2,2),'color',[0.4 0 0])
plot(B/1E3,runmean(Cd3,2),'color',[0.5 0 0])
plot(B/1E3,runmean(Cd4,2),'color',[0.6 0 0],'linewidth',2)
plot(B/1E3,runmean(Cd5,2),'color',[0.7 0 0])
plot(B/1E3,runmean(Cd6,2),'color',[0.8 0 0])
plot(B/1E3,runmean(Cd7,2),'color',[0.9 0 0])
plot(B/1E3,runmean(Cd8,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spi vs Start Delta')
subplot(5,2,2), hold on,plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('68')
subplot(5,2,4), hold on,plot(B/1E3,runmean(Cd2,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('810')
subplot(5,2,5), hold on,plot(B/1E3,runmean(Cd3,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1012')
subplot(5,2,6), hold on,plot(B/1E3,runmean(Cd4,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1214')
subplot(5,2,7), hold on,plot(B/1E3,runmean(Cd5,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1416')
subplot(5,2,8), hold on,plot(B/1E3,runmean(Cd6,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1618')
subplot(5,2,9), hold on,plot(B/1E3,runmean(Cd7,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1820')
subplot(5,2,10), hold on,plot(B/1E3,runmean(Cd8,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('2022')



try
tref=Range(rip);
[Cd1,B]=CrossCorr(tref, Spi68(:,1)*1E4,100,100);
[Cd2,B]=CrossCorr(tref, Spi810(:,1)*1E4,100,100);
[Cd3,B]=CrossCorr(tref, Spi1012(:,1)*1E4,100,100);
[Cd4,B]=CrossCorr(tref, Spi1214(:,1)*1E4,100,100);
[Cd5,B]=CrossCorr(tref, Spi1416(:,1)*1E4,100,100);
[Cd6,B]=CrossCorr(tref, Spi1618(:,1)*1E4,100,100);
[Cd7,B]=CrossCorr(tref, Spi1820(:,1)*1E4,100,100);
[Cd8,B]=CrossCorr(tref, Spi2022(:,1)*1E4,100,100);

figure, hold on,
subplot(5,2,[1,3]), hold on,
plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0])
plot(B/1E3,runmean(Cd2,2),'color',[0.4 0 0])
plot(B/1E3,runmean(Cd3,2),'color',[0.5 0 0])
plot(B/1E3,runmean(Cd4,2),'color',[0.6 0 0],'linewidth',2)
plot(B/1E3,runmean(Cd5,2),'color',[0.7 0 0])
plot(B/1E3,runmean(Cd6,2),'color',[0.8 0 0])
plot(B/1E3,runmean(Cd7,2),'color',[0.9 0 0])
plot(B/1E3,runmean(Cd8,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spi vs Ripples')
subplot(5,2,2), hold on,plot(B/1E3,runmean(Cd1,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('68')
subplot(5,2,4), hold on,plot(B/1E3,runmean(Cd2,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('810')
subplot(5,2,5), hold on,plot(B/1E3,runmean(Cd3,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1012')
subplot(5,2,6), hold on,plot(B/1E3,runmean(Cd4,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1214')
subplot(5,2,7), hold on,plot(B/1E3,runmean(Cd5,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1416')
subplot(5,2,8), hold on,plot(B/1E3,runmean(Cd6,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1618')
subplot(5,2,9), hold on,plot(B/1E3,runmean(Cd7,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('1820')
subplot(5,2,10), hold on,plot(B/1E3,runmean(Cd8,2),'color',[0.3 0 0]), yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7]), ylabel('2022')


end



if 1
    
[C11,B]=CrossCorr(Spi1214(:,1)*1E4,Spi68(:,1)*1E4,100,100);
[C12,B]=CrossCorr(Spi1214(:,1)*1E4,Spi810(:,1)*1E4,100,100);
[C13,B]=CrossCorr(Spi1214(:,1)*1E4,Spi1012(:,1)*1E4,100,100);
[C14,B]=CrossCorr(Spi1214(:,1)*1E4,Spi1416(:,1)*1E4,100,100);
[C15,B]=CrossCorr(Spi1214(:,1)*1E4,Spi1618(:,1)*1E4,100,100);
[C16,B]=CrossCorr(Spi1214(:,1)*1E4,Spi1820(:,1)*1E4,100,100);
[C17,B]=CrossCorr(Spi1214(:,1)*1E4,Spi2022(:,1)*1E4,100,100);
[C18,B]=CrossCorr(Spi1214(:,1)*1E4,Spi2224(:,1)*1E4,100,100);

[C,B]=CrossCorr(Spi1214(:,1)*1E4,Spi1214(:,1)*1E4,100,100);

figure, 
subplot(5,2,1:2), hold on,
plot(B/1E3,runmean(C11,2),'color',[0.3 0 0])
plot(B/1E3,runmean(C12,2),'color',[0.4 0 0])
plot(B/1E3,runmean(C13,2),'color',[0.5 0 0])
plot(B/1E3,runmean(C14,2),'color',[0.6 0 0],'linewidth',2)
plot(B/1E3,runmean(C15,2),'color',[0.7 0 0])
plot(B/1E3,runmean(C16,2),'color',[0.8 0 0])
plot(B/1E3,runmean(C17,2),'color',[0.9 0 0])
plot(B/1E3,runmean(C18,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(5,2,3), hold on,
plot(B/1E3,runmean(C11,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,4), hold on,
plot(B/1E3,runmean(C12,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,5), hold on,
plot(B/1E3,runmean(C13,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,6), hold on,
plot(B/1E3,runmean(C14,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,7), hold on,
plot(B/1E3,runmean(C15,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,8), hold on,
plot(B/1E3,runmean(C16,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,9), hold on,
plot(B/1E3,runmean(C17,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(5,2,10), hold on,
plot(B/1E3,runmean(C18,2),'color',[1 0 0])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
end

end

disp(' ')
disp('----------------')
disp(' ')
disp(pwd)
disp(' ')
disp(ti)
disp(' ')
disp(listChannel)
disp(' ')
