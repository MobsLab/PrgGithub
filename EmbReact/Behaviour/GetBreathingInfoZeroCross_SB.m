function GetBreathingInfoZeroCross_SB(varargin)

% This funciont calcualtes the peak and trough of each breath by looking
% for the zero crossings

% INPUT
% LimAmpRealBreath :        Peaks and troughs that are smaller than this
% limit are excluded
% LimFreqRealBreath:        Peaks and troughs that come at higher frequency
% than this limit are excluded


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'limamprealbreath'
            LimAmpRealBreath = lower(varargin{i+1});
        case 'limfreqrealbreath'
            epoch_name = lower(varargin{i+1});
        LimFreqRealBreath
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


try, LimAmpRealBreath; catch,LimAmpRealBreath = 15;end
try, LimFreqRealBreath; catch,LimFreqRealBreath = 18;end

%% Get the respiration trace
load('ChannelsToAnalyse/Respi.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
FilLFP=FilterLFP((LFP),[0.1 20],1024);

%% find the troughs and peaks
% get zero crossings
[up,down] = ZeroCrossings([Range((FilLFP),'s'),Data((FilLFP))]);
tps = Range((FilLFP),'s');
dat= Data((FilLFP));
DownTimes = find(down);
UpTimes = find(up);
% for each crossing pair get the corresponding trough or peak
clear ind_peak ind_trough  val_peak val_trough
for k = 1 : length(DownTimes)-1
    if DownTimes(1)>UpTimes(1)
        [val_trough(k),ind_trough(k)] = min(dat(DownTimes(k):UpTimes(k+1)));
        [val_peak(k),ind_peak(k)] = max(dat(UpTimes(k):DownTimes(k)));
    else
        [val_trough(k),ind_trough(k)] = min(dat(DownTimes(k):UpTimes(k)));
        [val_peak(k),ind_peak(k)] = max(dat(UpTimes(k):DownTimes(k+1)));
    end
end
ind_peak = ind_peak + UpTimes(1:k)';
ind_trough = ind_trough + DownTimes(1:k)';
PKvals = dat(ind_peak); PKvals = PKvals(PKvals<prctile(PKvals,99.5));
TGvals = dat(ind_trough); TGvals = TGvals(TGvals>prctile(TGvals,0.5));

% deal with little troughs
if ind_trough(1)<ind_peak(1)
    ind_peak = [ind_trough(1)-1,ind_peak];
    val_peak = [NaN,val_peak];
end
if ind_trough(end)>ind_peak(end)
    ind_peak = [ind_peak,ind_trough(end)+1];
    val_peak = [val_peak,NaN];
end

t=1;
A = find(val_trough>-LimAmpRealBreath);
while not(isempty(A))
    [valmin,indmin] = min(val_peak([A(t);A(t)+1]));
    val_peak(A(t)-1+indmin) = [];
    ind_peak(A(t)-1+indmin) = [];
    val_trough(A(t)) = [];
    ind_trough(A(t)) = [];
    A = find(val_trough>-LimAmpRealBreath);
end

% deal with little peaks
if ind_peak(1)<ind_trough(1)
    ind_trough = [ind_peak(1)-1,ind_trough];
    val_trough = [NaN,val_trough];
end
if ind_peak(end)>ind_trough(end)
    ind_trough = [ind_trough,ind_peak(end)+1];
    val_trough = [val_trough,NaN];
end

t=1;
A = find(val_peak<LimAmpRealBreath);
while not(isempty(A))
    [valmin,indmin] = max(val_trough([A(t);A(t)+1]));
    val_trough(A(t)-1+indmin) = [];
    ind_trough(A(t)-1+indmin) = [];
    
    val_peak(A(t)) = [];
    ind_peak(A(t)) = [];
    A = find(val_peak<LimAmpRealBreath);
end

% deal with close peaks
PeakTimes_temp = tps(ind_peak);
PeakVals_temp = dat(ind_peak);
A = find(diff(tps(ind_peak))<(1/LimFreqRealBreath));  try,A(end) = []; end
while not(isempty(A))
    TroughToDel = find(tps(ind_trough)>PeakTimes_temp(A(t)) & tps(ind_trough)<PeakTimes_temp(A(t)+1));
    [val,ind] = min([PeakVals_temp(A(t)),PeakVals_temp(A(t)+1)]);
    PeakToDel = A(t)+ind-1;
    
    val_trough(TroughToDel) = [];
    ind_trough(TroughToDel) = [];
    
    val_peak(PeakToDel) = [];
    ind_peak(PeakToDel) = [];
    PeakTimes_temp = tps(ind_peak);
    PeakVals_temp = dat(ind_peak);
    A = find(diff(tps(ind_peak))<(1/LimFreqRealBreath)); try,A(end) = []; end
end

% deal with close troughs
TroughTimes_temp = tps(ind_trough);
TroughVals_temp = dat(ind_trough);
A = find(diff(tps(ind_trough))<(1/LimFreqRealBreath));  try,A(end) = []; end
while not(isempty(A))
    PeakToDel= find(tps(ind_peak)>TroughTimes_temp(A(t)) & tps(ind_peak)<TroughTimes_temp(A(t)+1));
    [val,ind] = max([TroughVals_temp(A(t)),TroughVals_temp(A(t)+1)]);
    TroughToDel  = A(t)+ind-1;
    
    val_trough(TroughToDel) = [];
    ind_trough(TroughToDel) = [];
    
    val_peak(PeakToDel) = [];
    ind_peak(PeakToDel) = [];
    TroughTimes_temp = tps(ind_trough);
    TroughVals_temp = dat(ind_trough);
    A = find(diff(tps(ind_trough))<(1/LimFreqRealBreath));  try,A(end) = []; end
end

% Get it all together
BreathTimes = tps(ind_trough);
Breathtsd=ts(BreathTimes*1e4);
Troughtsd = tsd(tps(ind_trough)*1e4,dat(ind_trough));
Peaktsd = tsd(tps(ind_peak)*1e4,dat(ind_peak));
FrequencyVal=1./diff(BreathTimes);
FrequencyTime=BreathTimes(1:end-1);
FreqInt=interp1(FrequencyTime,FrequencyVal,[min(FrequencyTime):0.05:max(FrequencyTime)]);
Frequecytsd=tsd([min(FrequencyTime):0.05:max(FrequencyTime)]*1e4,FreqInt');


save('BreathingInfo_ZeroCross.mat','Frequecytsd','Troughtsd','Peaktsd','Breathtsd','PKvals','TGvals')

end


%% Maybe complete code with this

% Calculate tidal volume
% integer between two zerocross
% for ii=2:length(BreathTimes)-1
%     try
%         LitEp=intervalSet(max(BreathTimes(ii)*1e4-1*1e4,0),BreathTimes(ii)*1e4);
%         LitDat=Data(Restrict(FilLFP,LitEp));
%         LitTps=Range(Restrict(FilLFP,LitEp));
%         Strtime=LitTps(find(LitDat>0,1,'last'));
%         LitEp=intervalSet(BreathTimes(ii)*1e4,BreathTimes(ii)*1e4+1*1e4);
%         LitDat=Data(Restrict(FilLFP,LitEp));
%         LitTps=Range(Restrict(FilLFP,LitEp));
%         Stptime=LitTps(find(LitDat>0,1,'first'));
%         IntegerBetwZC(ii)=-trapz(Data(Restrict(FilLFP,intervalSet(Strtime,Stptime))));
%     catch
%         IntegerBetwZC(ii)=NaN;
%     end
% end
% 
% TidalVal=IntegerBetwZC(2:end);
% TidTime=BreathTimes(2:end-1)';
% TidInt=interp1(TidTime,TidalVal,[min(FrequencyTime):0.05:max(FrequencyTime)]);
% TidalVolumtsd=tsd([min(FrequencyTime):0.05:max(FrequencyTime)]*1e4,TidInt');
% 
% fig=figure;
% subplot(411)
% hold on
% [hl,hp]=boundedline(Range(Frequecytsd,'s'),runmean(Data(Frequecytsd),10),ones(2,length(Data(Frequecytsd)))','alpha','k','transparency',0.2);
% delete(hl)
% subplot(412)
% plot(Range(TidalVolumtsd,'s'),Data(TidalVolumtsd))
% ylim([0 3e4])
% subplot(413)
% plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
% plot(Range(Restrict(FilLFP,Ep),'s'),Data(Restrict(FilLFP,Ep)),'r')
% line([Range((Breathtsd),'s') Range((Breathtsd),'s')]',[Range((Breathtsd),'s')*0+min(ylim) Range((Breathtsd),'s')*0+max(ylim)]'),'k'
% xlim([0 20]+800)
% ylim([-500 500])
% subplot(414)
% plot(Range(FilLFP,'s'),Data(FilLFP),'k'), hold on
% plot(Range(Restrict(FilLFP,BreathNoiseEpoch),'s'),Data(Restrict(FilLFP,BreathNoiseEpoch)),'r')
% ylim([-1e3 1e3])
% %     pause
% saveas(fig,'BreathingAnalysis.png')
% clf