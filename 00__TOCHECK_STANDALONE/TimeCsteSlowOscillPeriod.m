function TimeCsteSlowOscillPeriod(num,b2,b,dropSh,limdrop)

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

try
    num;
catch
    num=5;
end

b=[1000, 100];
b2=100; % nombre de bins
dropSh=1; limdrop=3E4;
disp(' ')

try
    load DeltaPFCx   
    tDeltaT2;
    disp('***** Delta Prefrontal Cortex ********')
catch
    load DeltaPaCx  
    disp('***** Delta Parietal Cortex ********')
end
tref=tDeltaT2;

try
load RipplesdHPC25
rip=ts(dHPCrip(:,2)*1E4);
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

try
load StateEpochSB SWSEpoch
catch
load StateEpoch SWSEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
try
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
catch
try
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;  
catch
SWSEpoch=SWSEpoch-NoiseEpoch;
end
end
end


try
    load behavResources PreEpoch
    SWSEpoch=and(SWSEpoch,PreEpoch);
    SWSEpoch=mergeCloseIntervals(SWSEpoch,10);
end


res=pwd;
tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
chBulb=tempchBulb.channel;
eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
%disp('*****************  Bulb *********************')

[EpochSlow,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[5 6]);close
disp(' ')
disp(['Ratio Slow versus No Slow: ',num2str(val(num)),'%'])
disp(' ')


Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[H,Bh]=hist(End(Epoch,'s')-Start(Epoch,'s'),50);
Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[H2,Bh2]=hist(End(Epoch,'s')-Start(Epoch,'s'),50);
figure('color',[1 1 1]),
subplot(1,2,1),
plot(Bh,H/max(H),'ko-','linewidth',2), hold on, plot(Bh2,H2/max(H2),'ro-','linewidth',2)
set(gca,'xscale','log')
ylim([0 1.3])
Stsd=tsd(t*1E4,Sp);
subplot(1,2,2), hold on
Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
plot(f,mean(Data(Restrict(Stsd,Epoch))),'r','linewidth',2)
Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
plot(f,mean(Data(Restrict(Stsd,Epoch))),'k','linewidth',2)

set(gcf,'position',[1782         522         560         420])


figure('color',[1 1 1]),

b1=b(1); 
 Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(tref,Epoch)),b1,b2); C(B==0)=0;
subplot(2,4,1), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'r','linewidth',2)
end
title('No slow oscillations')

Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(tref,Epoch)),b1,b2); C(B==0)=0;
subplot(2,4,2),  bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'r','linewidth',2)
end
title('Slow oscillations')

 Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Start(Epoch),Start(Epoch),b1,b2); C(B==0)=0;
subplot(2,4,3),  bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'b','linewidth',2)
end
title('No slow oscillations')

Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Start(Epoch),Start(Epoch),b1,b2); C(B==0)=0;
subplot(2,4,4),  bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'b','linewidth',2)
end
title('Slow oscillations')


b1=b(2);
 Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(tref,Epoch)),b1,b2); C(B==0)=0;
subplot(2,4,5), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'r','linewidth',2)
end
title('No slow oscillations')

Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Range(Restrict(tref,Epoch)),Range(Restrict(tref,Epoch)),b1,b2); C(B==0)=0;
subplot(2,4,6),  bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'r','linewidth',2)
end
title('Slow oscillations')

 Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Start(Epoch),Start(Epoch),b1,b2); C(B==0)=0;
subplot(2,4,7),  bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'b','linewidth',2)
end
title('No slow oscillations')

Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Start(Epoch),Start(Epoch),b1,b2); C(B==0)=0;
subplot(2,4,8),  bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color',[0.7 0.7 0.7])
xlim([B(1) B(end)]/1E3)
try
    temp=tsd(B/1E3*1E4,C);
filtemp=FilterLFP(temp,[0.001 0.1]);
hold on, plot(Range(filtemp,'s'),Data(filtemp),'b','linewidth',2)
end
title('Slow oscillations')


set(gcf,'position',[2350         524         975         420])


try
Epoch=SWSEpoch-EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Range(Restrict(rip,Epoch)),Range(Restrict(tref,Epoch)),50,200);
figure('color',[1 1 1]), plot(B/1E3,C,'k-')
Epoch=EpochSlow{num};if dropSh, Epoch=dropShortIntervals(Epoch,limdrop); end
[C,B]=CrossCorr(Range(Restrict(rip,Epoch)),Range(Restrict(tref,Epoch)),50,200);
hold on, plot(B/1E3,C,'r-')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
set(gcf,'position',[1068         555         560         420])
end



