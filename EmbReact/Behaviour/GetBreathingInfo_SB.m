function GetBreathingInfo_SB(filename)

cd(filename)

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

fig=figure;
subplot(411)
hold on
[hl,hp]=boundedline(Range(Frequecytsd,'s'),runmean(Data(Frequecytsd),10),ones(2,length(Data(Frequecytsd)))','alpha','k','transparency',0.2);
delete(hl)
subplot(412)
plot(Range(TidalVolumtsd,'s'),Data(TidalVolumtsd))
ylim([0 3e4])
subplot(413)
plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'r')
line([Range((Breathtsd),'s') Range((Breathtsd),'s')]',[Range((Breathtsd),'s')*0+min(ylim) Range((Breathtsd),'s')*0+max(ylim)]'),'k'
xlim([0 20]+800)
ylim([-500 500])
subplot(414)
plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
plot(Range(Restrict(FilLFP,BreathNoiseEpoch),'s'),Data(Restrict(FilLFP,BreathNoiseEpoch)),'r')
ylim([-1e3 1e3])
%     pause
saveas(fig,'BreathingAnalysis.png')
clf
save('BreathingInfo.mat','Frequecytsd','Breathtsd','TidalVolumtsd','BreathNoiseEpoch')
save('BreathingInfo.mat','Frequecytsd','Breathtsd','BreathNoiseEpoch')

end


%% Need to integrate this zero croass method
% % 50second period
% 
% LimRealBreath = 15;
% Ep = intervalSet(1e4*1e4,1.3e4*1e4);
% [up,down] = ZeroCrossings([Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep))]);
% tps = Range(Restrict(FilLFP,Ep),'s');
% dat= Data(Restrict(FilLFP,Ep));
% DownTimes = find(down);
% UpTimes = find(up);
% clear ind_peak ind_trough  val_peak val_trough
% for k = 1 : length(DownTimes)-1
%     if DownTimes(1)>UpTimes(1)
%         [val_trough(k),ind_trough(k)] = min(dat(DownTimes(k):UpTimes(k+1)));
%         [val_peak(k),ind_peak(k)] = max(dat(UpTimes(k):DownTimes(k)));
%     else
%         [val_trough(k),ind_trough(k)] = min(dat(DownTimes(k):UpTimes(k)));
%         [val_peak(k),ind_peak(k)] = max(dat(UpTimes(k):DownTimes(k+1)));
%     end
% end
% ind_peak = ind_peak + UpTimes(1:k)';
% ind_trough = ind_trough + DownTimes(1:k)';
% 
% 
% % dela with little troughs
% if ind_trough(1)<ind_peak(1)
%     ind_peak = [ind_trough(1)-1,ind_peak];
%     val_peak = [NaN,val_peak];
% end
% if ind_trough(end)>ind_peak(end)
%     ind_peak = [ind_peak,ind_trough(end)+1];
%     val_peak = [val_peak,NaN];
% end
% 
% 
% t=1;
%     A = find(val_trough>-LimRealBreath);
% while not(isempty(A))
%     [valmin,indmin] = min(val_peak([A(t);A(t)+1]));
%     val_peak(A(t)-1+indmin) = [];
%     ind_peak(A(t)-1+indmin) = [];
%     val_trough(A(t)) = [];
%     ind_trough(A(t)) = [];
%     A = find(val_trough>-LimRealBreath);
% end
% 
% 
% % dela with little peaks
% if ind_peak(1)<ind_trough(1)
%     ind_trough = [ind_peak(1)-1,ind_trough];
%     val_trough = [NaN,val_trough];
% end
% if ind_peak(end)>ind_trough(end)
%     ind_trough = [ind_trough,ind_peak(end)+1];
%     val_trough = [val_trough,NaN];
% end
% 
% t=1;
%     A = find(val_peak<LimRealBreath);
% while not(isempty(A))
%     [valmin,indmin] = max(val_trough([A(t);A(t)+1]));
%     val_trough(A(t)-1+indmin) = [];
%     ind_trough(A(t)-1+indmin) = [];
%     
%     val_peak(A(t)) = [];
%     ind_peak(A(t)) = [];
%     A = find(val_peak<LimRealBreath);
% end
% 
% clf
% plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'linewidth',4)
% hold on
% plot(tps(ind_trough),dat(ind_trough),'k*','MarkerSize',20)
% plot(tps(ind_peak),dat(ind_peak),'r*','MarkerSize',20)