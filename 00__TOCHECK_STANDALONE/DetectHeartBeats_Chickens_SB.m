function [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_Chickens_SB(LFP,NoiseEpoch,Options,plo)
%
% This function returns the time of individual heartbeats
%
% INPUT
%   LFP : LFP of EKG recording
%
% OUTPUT
%   Times : times of beats
%
% From time to time the algorithm misses a beat, I suggest you define the
% instantaneous heartbeat sthg liks this : movmedian(diff(Times/1e4),5)
%
%
%Author: Sophie Bagur
%

%% Suggested input options
try
    Options.TemplateThreshStd;
catch
    Options.TemplateThreshStd=2;
end
try
    Options.BeatThreshStd;
catch
    Options.BeatThreshStd=1.5;
end


%% Important parameters
FilterBand = [30 200];
TemplateDuration = 20; %ms
SnipDur = 1; %s
MinBeatSep = 0.05; % ms, so heart rate cannot be above 20Hz
TemplateThreshStd = Options.TemplateThreshStd; % value used to threshold to get the template for convolution
BeatThreshStd = Options.BeatThreshStd; % value used to threshold to final beats


%% init

TotalEpoch = intervalSet(0,max(Range(LFP)));
LFPtemp = Restrict(LFP,TotalEpoch-NoiseEpoch);
Filt_LFP_High = FilterLFP(LFPtemp,FilterBand,1024);
litEpoch = intervalSet(min(Range(Filt_LFP_High)), min(min(Range(Filt_LFP_High))+300*1e4,max(Range(Filt_LFP_High))));
x_data = Range(Restrict(Filt_LFP_High,litEpoch));
y_data = Data(Restrict(Filt_LFP_High,litEpoch));


%% convolve and find match
xmx = findpeaks(y_data, std(y_data) * TemplateThreshStd);
[MR,TR] = PlotRipRaw(Filt_LFP_High, x_data(xmx.loc)/1e4, TemplateDuration,1,0);

Template = MR(:,2);
ConvSigForNoise = tsd(Range(Filt_LFP_High), conv(Data(Filt_LFP_High),Template,'same') .* conv(Data(Filt_LFP_High), Template, 'same'));
STDLim=std(Data(ConvSigForNoise));
% Filt_LFP_High = FilterLFP(LFP,FilterBand,1024); Commented on 03.04.18 by Dima. If you uncomment this line, template will be convoluted 
% with whole set of data including noise
ConvSig = tsd(Range(Filt_LFP_High), conv(Data(Filt_LFP_High),Template,'same') .* conv(Data(Filt_LFP_High), Template, 'same'));

NumSnips = ceil(max(Range(Filt_LFP_High,'s'))/SnipDur);
Times=[]; Vals=[];

for i=1:NumSnips
    LocEpoch = intervalSet((i-1)*SnipDur*1e4,(i)*SnipDur*1e4);
    LocalSigConv = Restrict(ConvSig,LocEpoch);
    LocalSig = Restrict(Filt_LFP_High,LocEpoch);
    if not(isempty(Data(LocalSigConv)))
        x_data = Range(LocalSigConv);
        y_data = Data(LocalSig);
        xmx = findpeaks(Data(LocalSigConv),STDLim*BeatThreshStd);
%         xmx.loc = xmx.loc(y_data(xmx.loc)>std(y_data)*BeatThreshStd);
        Times = [Times;x_data(xmx.loc)];
        Vals = [Vals;y_data(xmx.loc)];
    end
end


%% Get rid of too close peaks
TimeDiff = diff(Times);
problempts = find(TimeDiff<MinBeatSep*1e4);
while (not(isempty(problempts)))
    ToExclude = [];
    for k=1:length(problempts)
        ToCompare = [Vals(problempts(k)),Vals(problempts(k)+1)];
        [~, ind] = min(ToCompare);
        ToExclude(k) = problempts(k)+ind-1;
    end
    Times(ToExclude) = [];
    Vals(ToExclude) = [];
    TimeDiff = diff(Times);
    problempts = find(TimeDiff<MinBeatSep*1e4);
end

HeartRate = tsd(Times(1:end-1),1./movmedian(diff(Times/1e4),10));
BadEpoch = thresholdIntervals(HeartRate,5,'Direction','Below');
BadEpoch = mergeCloseIntervals(BadEpoch,2*1e4);
BadEpoch = intervalSet(Start(BadEpoch)-1e4,Stop(BadEpoch)+1e4);
GoodEpoch = TotalEpoch-BadEpoch;

%% PLOT 

if plo
    subplot(211)
    plot(Range(LFP,'s'),Data(LFP)), hold on
    plot(Range(Filt_LFP_High,'s'),Data(Filt_LFP_High)), hold on
    plot(Times(1:end)/1e4,Vals(1:end),'*')
    xlabel('time (s)'), ylabel('EKG')
    xlim([30 40]) 

    subplot(212)
    plot(Range(HeartRate,'s'),Data(HeartRate))
    xlabel('time (s)'), ylabel('Heart Rate - Hz')

    
end


end