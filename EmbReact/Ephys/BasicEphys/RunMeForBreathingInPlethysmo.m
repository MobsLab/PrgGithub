load('ChannelsToAnalyse/Respi.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
FilLFP=FilterLFP((LFP),[1 30],1024);

% Breathing Noise
BreathNoiseEpoch=thresholdIntervals(FilLFP,500);
BreathNoiseEpoch=mergeCloseIntervals(BreathNoiseEpoch,5*1e4);
BreathNoiseEpoch2=thresholdIntervals(FilLFP,-500,'Direction','Below');
BreathNoiseEpoch2=mergeCloseIntervals(BreathNoiseEpoch2,5*1e4);
BreathNoiseEpoch=or(BreathNoiseEpoch,BreathNoiseEpoch2);

% Get Breathing Frequency
zr = hilbert(-Data(FilLFP));
phzr = atan2(imag(zr), real(zr));
phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
phaseTsd = tsd(Range(FilLFP), phzr);
Ep=thresholdIntervals(phaseTsd,0.1,'Direction','Below');
% this parameter used to be 40 by default but if breathing parameters
% are too different it needs to be adjusted
Ep2=thresholdIntervals(FilLFP,-40,'Direction','Below');
Ep=and(Ep,Ep2);
Ep=mergeCloseIntervals(Ep,0.05*1e4);
BreathTimes=Start(Ep,'s');
Breathtsd=ts(BreathTimes*1e4);
FrequencyVal=1./diff(BreathTimes);
FrequencyTime=BreathTimes(1:end-1);
FreqInt=interp1(FrequencyTime,FrequencyVal,[min(FrequencyTime):0.05:max(FrequencyTime)]);
Frequecytsd=tsd([min(FrequencyTime):0.05:max(FrequencyTime)]*1e4,FreqInt');

% Calculate tidal volume
% integer between two zerocross
for ii=2:length(BreathTimes)-1
    try
        LitEp=intervalSet(max(BreathTimes(ii)*1e4-1*1e4,0),BreathTimes(ii)*1e4);
        LitDat=Data(Restrict(FilLFP,LitEp));
        LitTps=Range(Restrict(FilLFP,LitEp));
        Strtime=LitTps(find(LitDat>0,1,'last'));
        LitEp=intervalSet(BreathTimes(ii)*1e4,BreathTimes(ii)*1e4+1*1e4);
        LitDat=Data(Restrict(FilLFP,LitEp));
        LitTps=Range(Restrict(FilLFP,LitEp));
        Stptime=LitTps(find(LitDat>0,1,'first'));
        IntegerBetwZC(ii)=-trapz(Data(Restrict(FilLFP,intervalSet(Strtime,Stptime))));
    catch
        IntegerBetwZC(ii)=NaN;
    end
end

TidalVal=IntegerBetwZC(2:end);
TidTime=BreathTimes(2:end-1)';
TidInt=interp1(TidTime,TidalVal,[min(FrequencyTime):0.05:max(FrequencyTime)]);
TidalVolumtsd=tsd([min(FrequencyTime):0.05:max(FrequencyTime)]*1e4,TidInt');
fig=figure(1);
clf
subplot(411)
hold on
[hl,hp]=boundedline(Range(Frequecytsd,'s'),runmean(Data(Frequecytsd),10),ones(2,length(Data(Frequecytsd)))','alpha','k','transparency',0.2);
delete(hl)
title('Breathing frequency (Hz)')
subplot(412)
plot(Range(TidalVolumtsd,'s'),Data(TidalVolumtsd))
ylim([0 3e4])
title('Tidal Volume')
subplot(413)
plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'r')
line([Range((Breathtsd),'s') Range((Breathtsd),'s')]',[Range((Breathtsd),'s')*0+min(ylim) Range((Breathtsd),'s')*0+max(ylim)]'),'k'
xlim([0 20]+30)
title('raw signal with detected breaths')
subplot(414)
plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
plot(Range(Restrict(FilLFP,BreathNoiseEpoch),'s'),Data(Restrict(FilLFP,BreathNoiseEpoch)),'r')
ylim([-1e3 1e3])
title('raw signal')
saveas(fig,'BreathingAnalysis.png')
clf
save('BreathingInfo.mat','Frequecytsd','Breathtsd','TidalVolumtsd','BreathNoiseEpoch')
clear Frequecytsd Breathtsd TidalVolumtsd IntegerBetwZC TidalVal TidTime TidInt FrequencyVal FrequencyTime FreqInt FilLFP BreathTimes BreathNoiseEpoch BreathNoiseEpoch2


