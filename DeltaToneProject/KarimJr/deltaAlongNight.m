%deltaAlongNight

clear 
%load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch Wake REMEpoch
clear number

%% detection of delta waves
minDeltaDuration = 75;
freqDelta=[1 5];
thD = 2;
tlarge = 1000;

%diff between deep and sup
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

%threshold crossing
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
large_deltas = intervalSet(Start(DeltaOffline)-tlarge, End(DeltaOffline)+tlarge);


%% Up durations across the night
up_start = End(large_deltas);
up_end = Start(large_deltas);
up_duration = up_end(2:end) - up_start(1:end-1);
up_start = up_start(1:end-1);
up_start(up_duration > 10*1E4) = [];
up_duration(up_duration > 10*1E4) = [];


% for n = 1:length(up_duration)
%     if n <= 200
%         y(n) = mean(up_duration(1:n));
%     else
%         y(n) = mean(up_duration(n-199:n));
%     end
% end

%Across night
night_duration = max(Range(LFPsup))/(3600*10000);
night_tmp = 0:60*1E4:max(Range(LFPsup)); %one timestamp every minute
meanUpDur = zeros(length(night_tmp),1);

hw_size = 200E4;
for i=1:length(meanUpDur)
   up_window = up_duration(up_start>night_tmp(i)-hw_size & up_start<night_tmp(i)+hw_size); 
   meanUpDur(i) = mean(up_window);
end
meanUpDur(isnan(meanUpDur))=10*1E4;
meanUpDur = meanUpDur/10; %in s

%REM episode
start_rem = Start(REMEpoch)/ 60E4;  %in min
end_rem = End(REMEpoch)/ 60E4;  %in min

%plot
figure, hold on
plot(1:length(meanUpDur), meanUpDur), hold on
y1 = get(gca,'ylim');
for r=1:length(start_rem)
    line([start_rem(r) start_rem(r)],y1, 'Color','g')
    line([end_rem(r) end_rem(r)],y1, 'Color','r')
end



%% Delta amplitude across the night

nb_deltas = length(length(large_deltas));
delta_ampli = zeros(1,nb_deltas);
for i=1:nb_deltas
    subDelta = subset(large_deltas,i);
    delta_ampli(i) = max(Data(Restrict(LFPsup, subDelta)));
end
delta_start = Start(large_deltas);

meanDeltaAmp = zeros(length(night_tmp),1);
hw_size = 60E4;
for i=1:length(meanDeltaAmp)
   amp_window = delta_ampli(delta_start>night_tmp(i)-hw_size & delta_start<night_tmp(i)+hw_size); 
   meanDeltaAmp(i) = mean(amp_window);
end
meanDeltaAmp(isnan(meanDeltaAmp))=0;

figure, hold on
plot(1:length(meanDeltaAmp), meanDeltaAmp), hold on
y1 = get(gca,'ylim');
for r=1:length(start_rem)
    line([start_rem(r) start_rem(r)],y1, 'Color','g')
    line([end_rem(r) end_rem(r)],y1, 'Color','r')
end


%% 












