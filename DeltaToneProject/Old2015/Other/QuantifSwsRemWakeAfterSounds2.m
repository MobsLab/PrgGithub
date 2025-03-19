function [MM,D]=QuantifSwsRemWakeAfterSounds2

clear tone1
clear tone2
clear detectD
clear detectNoD

load StateEpochSB SWSEpoch Wake REMEpoch
load DeltaSleepEvent

%% FIND RIPPLES
disp(' ')
disp('   ________ FIND RIPPLES ________ ')

clear dHPCrip
clear rip
res=pwd;

try
    load RipplesdHPC25
    dHPCrip;
catch
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel'); % changed by Marie 3june2015
    chHPC=tempchHPC.channel;
    eval(['tempLoad=load([res,''/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
    eegRip=tempLoad.LFP;
    [dHPCrip,EpochRip]=FindRipplesKarimSB(eegRip,SWSEpoch,[2 5]);
    save([res,'/RipplesdHPC25.mat'],'dHPCrip','EpochRip','chHPC');
            clear dHPCrip EpochRip chHPC
end

load RipplesdHPC25
rip=ts(dHPCrip(:,2)*1E4);



a=1;
for i=1:length(TONEtime1)
id=find(TONEtime2>TONEtime1(i));
if TONEtime2(id(1))-TONEtime1(i)<0.2E4
tone2(a)=TONEtime2(id(1));
tone1(a)=TONEtime1(i);
a=a+1;
end
end
tone1=tone1';
tone2=tone2';

a=1;b=1;
for i=1:length(DeltaDetect)
    id=find(tone1>DeltaDetect(i));
    if tone1(id)-DeltaDetect(i)<0.1E4
    detectD(a)=DeltaDetect(i);
    a=a+1;
    end
    
    if tone1(id)-DeltaDetect(i)>0.6E4
    detectNoD(b)=DeltaDetect(i);
    b=b+1;
    end
    
end


% LongTones=FindLongPeriodsEvents(tone1,60);
LongTones=FindLongPeriodsEvents(tone1,100);



SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
[SleepStagesC3, SWSEpochC3, REMEpochC3, WakeC3, Noise, TotalNoiseEpoch]=CleanSleepStages;


NoSleepEpoch=or(TotalNoiseEpoch,WakeC3);
NoSleepEpoch=mergeCloseIntervals(NoSleepEpoch,100E4);
rg=Range(SleepStagesC3);
TotalEpoch=intervalSet(rg(1),rg(end));
LongSWS1=TotalEpoch-NoSleepEpoch;

LongSWS2=FindLongPeriodsEpoch(SWSEpoch,[100 300]);
LongSWS=or(LongSWS1,LongSWS2);

hold on, line([Start(LongTones,'s') End(LongTones,'s')],[0 0],'color','g','linewidth',2)
hold on, line([Start(LongSWS,'s') End(LongSWS,'s')],[0.5 0.5],'color','c','linewidth',2)

try
    load PeriodsDeltaSounds Epoch1 Epoch2 Epoch3 Epoch4 Epoch5
    Epoch1;
catch
title('Epoch1')
tps=ginput;
Epoch1=intervalset(tps(1)*1E4,tps(2)*1E4);
title('Epoch2')
tps=ginput;
Epoch2=intervalset(tps(1)*1E4,tps(2)*1E4);
title('Epoch3')
tps=ginput;
Epoch3=intervalset(tps(1)*1E4,tps(2)*1E4);
title('Epoch4')
tps=ginput;
Epoch4=intervalset(tps(1)*1E4,tps(2)*1E4);
title('Epoch5')
tps=ginput;
Epoch5=intervalset(tps(1)*1E4,tps(2)*1E4);
title(' ')
save PeriodsDeltaSounds Epoch1 Epoch2 Epoch3 Epoch4 Epoch5
end


load newDeltaPFCx
Dpfc=ts(tDelta);
load newDeltaPaCx
Dpac=ts(tDelta);


MM(1)=length(Range(Restrict(Dpfc,and(SWSEpoch,Epoch1))))/sum(End(and(SWSEpoch,Epoch1),'s')-Start(and(SWSEpoch,Epoch1),'s'));
MM(2)=length(Range(Restrict(Dpfc,and(SWSEpoch,Epoch2))))/sum(End(and(SWSEpoch,Epoch2),'s')-Start(and(SWSEpoch,Epoch2),'s'));
MM(3)=length(Range(Restrict(Dpfc,and(SWSEpoch,Epoch3))))/sum(End(and(SWSEpoch,Epoch3),'s')-Start(and(SWSEpoch,Epoch3),'s'));
MM(4)=length(Range(Restrict(Dpfc,and(SWSEpoch,Epoch4))))/sum(End(and(SWSEpoch,Epoch4),'s')-Start(and(SWSEpoch,Epoch4),'s'));
MM(5)=length(Range(Restrict(Dpfc,and(SWSEpoch,Epoch5))))/sum(End(and(SWSEpoch,Epoch5),'s')-Start(and(SWSEpoch,Epoch5),'s'));

MM(6)=length(Range(Restrict(Dpac,and(SWSEpoch,Epoch1))))/sum(End(and(SWSEpoch,Epoch1),'s')-Start(and(SWSEpoch,Epoch1),'s'));
MM(7)=length(Range(Restrict(Dpac,and(SWSEpoch,Epoch2))))/sum(End(and(SWSEpoch,Epoch2),'s')-Start(and(SWSEpoch,Epoch2),'s'));
MM(8)=length(Range(Restrict(Dpac,and(SWSEpoch,Epoch3))))/sum(End(and(SWSEpoch,Epoch3),'s')-Start(and(SWSEpoch,Epoch3),'s'));
MM(9)=length(Range(Restrict(Dpac,and(SWSEpoch,Epoch4))))/sum(End(and(SWSEpoch,Epoch4),'s')-Start(and(SWSEpoch,Epoch4),'s'));
MM(10)=length(Range(Restrict(Dpac,and(SWSEpoch,Epoch5))))/sum(End(and(SWSEpoch,Epoch5),'s')-Start(and(SWSEpoch,Epoch5),'s'));

MM(11)=length(Range(Restrict(rip,and(SWSEpoch,Epoch1))))/sum(End(and(SWSEpoch,Epoch1),'s')-Start(and(SWSEpoch,Epoch1),'s'));
MM(12)=length(Range(Restrict(rip,and(SWSEpoch,Epoch2))))/sum(End(and(SWSEpoch,Epoch2),'s')-Start(and(SWSEpoch,Epoch2),'s'));
MM(13)=length(Range(Restrict(rip,and(SWSEpoch,Epoch3))))/sum(End(and(SWSEpoch,Epoch3),'s')-Start(and(SWSEpoch,Epoch3),'s'));
MM(14)=length(Range(Restrict(rip,and(SWSEpoch,Epoch4))))/sum(End(and(SWSEpoch,Epoch4),'s')-Start(and(SWSEpoch,Epoch4),'s'));
MM(15)=length(Range(Restrict(rip,and(SWSEpoch,Epoch5))))/sum(End(and(SWSEpoch,Epoch5),'s')-Start(and(SWSEpoch,Epoch5),'s'));

bin1=10;bin2=200;
[C1a,B1a]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch1))),Range(Restrict(rip,and(SWSEpoch,Epoch1))),bin1,bin2);
[C1b,B1b]=CrossCorr(Range(Restrict(Dpac,and(SWSEpoch,Epoch1))),Range(Restrict(rip,and(SWSEpoch,Epoch1))),bin1,bin2);
[C1c,B1c]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch1))),Range(Restrict(Dpac,and(SWSEpoch,Epoch1))),bin1,bin2);

[C2a,B1a]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch2))),Range(Restrict(rip,and(SWSEpoch,Epoch2))),bin1,bin2);
[C2b,B1b]=CrossCorr(Range(Restrict(Dpac,and(SWSEpoch,Epoch2))),Range(Restrict(rip,and(SWSEpoch,Epoch2))),bin1,bin2);
[C2c,B1c]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch2))),Range(Restrict(Dpac,and(SWSEpoch,Epoch2))),bin1,bin2);

[C3a,B1a]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch3))),Range(Restrict(rip,and(SWSEpoch,Epoch3))),bin1,bin2);
[C3b,B1b]=CrossCorr(Range(Restrict(Dpac,and(SWSEpoch,Epoch3))),Range(Restrict(rip,and(SWSEpoch,Epoch3))),bin1,bin2);
[C3c,B1c]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch3))),Range(Restrict(Dpac,and(SWSEpoch,Epoch3))),bin1,bin2);

[C4a,B1a]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch4))),Range(Restrict(rip,and(SWSEpoch,Epoch4))),bin1,bin2);
[C4b,B1b]=CrossCorr(Range(Restrict(Dpac,and(SWSEpoch,Epoch4))),Range(Restrict(rip,and(SWSEpoch,Epoch4))),bin1,bin2);
[C4c,B1c]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch4))),Range(Restrict(Dpac,and(SWSEpoch,Epoch4))),bin1,bin2);

[C5a,B1a]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch5))),Range(Restrict(rip,and(SWSEpoch,Epoch5))),bin1,bin2);
[C5b,B1b]=CrossCorr(Range(Restrict(Dpac,and(SWSEpoch,Epoch5))),Range(Restrict(rip,and(SWSEpoch,Epoch5))),bin1,bin2);
[C5c,B1c]=CrossCorr(Range(Restrict(Dpfc,and(SWSEpoch,Epoch5))),Range(Restrict(Dpac,and(SWSEpoch,Epoch5))),bin1,bin2);



[C5rip,B1a]=CrossCorr(tone1,Range(Restrict(rip,and(SWSEpoch,SWSEpoch))),bin1,bin2);
[C5Dpfc,B1b]=CrossCorr(tone1,Range(Restrict(Dpfc,and(SWSEpoch,SWSEpoch))),bin1,bin2);
[C5Dpac,B1c]=CrossCorr(tone1,Range(Restrict(Dpac,and(SWSEpoch,SWSEpoch))),bin1,bin2);

[C5rip,B1a]=CrossCorr(DeltaDetect,Range(Restrict(rip,and(SWSEpoch,SWSEpoch))),bin1,bin2);
[C5Dpfc,B1b]=CrossCorr(DeltaDetect,Range(Restrict(Dpfc,and(SWSEpoch,SWSEpoch))),bin1,bin2);
[C5Dpac,B1c]=CrossCorr(DeltaDetect,Range(Restrict(Dpac,and(SWSEpoch,SWSEpoch))),bin1,bin2);

smo=4;
figure('color',[1 1 1])
hold on, plot(B1a/1E3,smooth(C5rip,smo),'k')
hold on, plot(B1a/1E3,smooth(C5Dpfc,smo),'b')
hold on, plot(B1a/1E3,smooth(C5Dpac,smo),'g')


figure('color',[1 1 1])
hold on, plot(B1a/1E3,smooth(C1a,smo),'k')
hold on, plot(B1a/1E3,smooth(C2a,smo),'b')
hold on, plot(B1a/1E3,smooth(C3a,smo),'g')
hold on, plot(B1a/1E3,smooth(C4a,smo),'r')
hold on, plot(B1a/1E3,smooth(C5a,smo),'m')

keyboard



