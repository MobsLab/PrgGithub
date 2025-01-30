% S: Spikes
% NumNeurons: cells to select
% SWSEpoch
% binsize: bin size for MUA computation
% minDownDuration: minimum duration to classify as a downstate
% thresh: value of the threshold to cross to detect a downstate
% thresh_mode: firing rate(1), mean rate percent(2), max rate percent(3)
% LFPsup
% LFPdeep

%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

%Args
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
coeffLim = 0.4;  % to detect delta associated with a down, even a little bit out of the down
%Delta
minDeltaDuration = 75;
freqDelta=[1 5];


%%%%%%%%%%%%%%%%%%%
% Find downstates
%%%%%%%%%%%%%%%%%%%
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Q = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Q, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
down_interval = [Start(Down) End(Down)];
down_durations = End(Down) - Start(Down);
large_down_intv = [down_interval(:,1)-down_durations*coeffLim down_interval(:,2)+down_durations*coeffLim];

%thresholds for detection
thD_list = 0.2:0.2:3;


%%%%%%%%%%%%%%%%%%%
% Precision and recall, function of thD, for deep-factor*sup
%%%%%%%%%%%%%%%%%%%
% find factor to increase EEGsup signal compared to EEGdeep
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
% Difference between EEG deep and EEG sup (*factor)
EEGsleepD=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100); 

Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
Filt_EEGd = Restrict(Filt_EEGd,SWSEpoch);
abs_lfpdiff_value = max(Data(Filt_EEGd),0);

std_diff = std(abs_lfpdiff_value(abs_lfpdiff_value>0));
precision = zeros(1,length(thD_list));
recall = zeros(1,length(thD_list));
recalled_down = zeros(length(thD_list),length(down_interval));

for i=1:length(thD_list)
    thD = thD_list(i);
    thresh_delta = thD * std_diff;

    all_cross_thresh=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,SWSEpoch)), abs_lfpdiff_value),thresh_delta,'Direction','Above');
    DeltaEpoch=dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
    DurDelta=tsd(Start(DeltaEpoch) + (End(DeltaEpoch) - Start(DeltaEpoch))/2,End(DeltaEpoch,'ms') - Start(DeltaEpoch,'ms'));
    deltas_center = Range(DurDelta);

    [status,interval,index] = InIntervals(deltas_center,large_down_intv);
    recalled_down(i,:) = ismember(1:length(down_interval),unique(interval));
    
    precision(i) = sum(status) / length(status);
    recall(i) = sum(status) / size(down_interval,1);
    
end


result_diff = [thD_list; precision;recall];
recalled_diff = recalled_down;

%%%%%%%%%%%%%%%%%%%
% Precision and recall, function of thD, for PFC_deep
%%%%%%%%%%%%%%%%%%%
EEGsleepD=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep)),100); 
Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
Filt_EEGd = Restrict(Filt_EEGd,SWSEpoch);
abs_lfpd_value = max(Data(Filt_EEGd),0);

std_diff = std(abs_lfpd_value(abs_lfpd_value>0));
precision = zeros(1,length(thD_list));
recall = zeros(1,length(thD_list));
recalled_down = zeros(length(thD_list),length(down_interval));

for i=1:length(thD_list)
    thD = thD_list(i);
    thresh_delta = thD * std_diff;

    all_cross_thresh=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,SWSEpoch)), abs_lfpd_value),thresh_delta,'Direction','Above');
    DeltaEpoch=dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
    DurDelta=tsd(Start(DeltaEpoch) + (End(DeltaEpoch) - Start(DeltaEpoch))/2,End(DeltaEpoch,'ms') - Start(DeltaEpoch,'ms'));
    deltas_center = Range(DurDelta);

    [status,interval,index] = InIntervals(deltas_center,down_interval);
    recalled_down(i,:) = ismember(1:length(down_interval),unique(interval));
    
    precision(i) = sum(status) / length(status);
    recall(i) = sum(status) / size(down_interval,1);
    
end

result_deep = [thD_list; precision;recall];
recalled_deep = recalled_down;

%%%%%%%%%%%%%%%%%%%
% Precision and recall, function of thD, for PFC_sup
%%%%%%%%%%%%%%%%%%%
EEGsleepD=ResampleTSD(tsd(Range(LFPsup),Data(LFPsup)),100); 
Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
Filt_EEGd = Restrict(Filt_EEGd,SWSEpoch);
abs_lfps_value = max(-Data(Filt_EEGd),0);

std_diff = std(abs_lfps_value(abs_lfps_value>0));
precision = zeros(1,length(thD_list));
recall = zeros(1,length(thD_list));
recalled_down = zeros(length(thD_list),length(down_interval));

for i=1:length(thD_list)
    thD = thD_list(i);
    thresh_delta = thD * std_diff;

    all_cross_thresh=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,SWSEpoch)), abs_lfps_value),thresh_delta,'Direction','Above');
    DeltaEpoch=dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
    DurDelta=tsd(Start(DeltaEpoch) + (End(DeltaEpoch) - Start(DeltaEpoch))/2,End(DeltaEpoch,'ms') - Start(DeltaEpoch,'ms'));
    deltas_center = Range(DurDelta);

    [status,interval,index] = InIntervals(deltas_center,down_interval);
    recalled_down(i,:) = ismember(1:length(down_interval),unique(interval));
    
    precision(i) = sum(status) / length(status);
    recall(i) = sum(status) / size(down_interval,1);
    
    
end

result_sup = [thD_list; precision;recall];
recalled_sup = recalled_down;


%Analysis of recall: thresholds and down duration
threshMax_diff = zeros(1,size(recalled_diff,2));
for i=1:size(recalled_diff,2)
    down_vec = recalled_diff(:,i);
    if sum(down_vec)>0
        threshMax_diff(i) = find(down_vec==1,1,'last');
    else
        threshMax_diff(i) = 0;
    end

end

threshMax_deep = zeros(1,size(recalled_deep,2));
for i=1:size(recalled_deep,2)
    down_vec = recalled_deep(:,i);
    if sum(down_vec)>0
        threshMax_deep(i) = find(down_vec==1,1,'last');
    else
        threshMax_deep(i) = 0;
    end

end

threshMax_sup = zeros(1,size(recalled_sup,2));
for i=1:size(recalled_sup,2)
    down_vec = recalled_sup(:,i);
    if sum(down_vec)>0
        threshMax_sup(i) = find(down_vec==1,1,'last');
    else
        threshMax_sup(i) = 0;
    end

end


%Correlation threshold and down duration
mean_thr_deltadiffDur = zeros(1,length(thD_list) + 1);
std_thr_deltadiffDur = zeros(1,length(thD_list) + 1);
for i=0:length(thD_list)
    th_deltaDur = down_durations(threshMax_diff==i);
    mean_thr_deltadiffDur(i+1) = mean(th_deltaDur);
    std_thr_deltadiffDur(i+1) = std(th_deltaDur);
end

mean_thr_deltadeepDur = zeros(1,length(thD_list) + 1);
std_thr_deltadeepDur = zeros(1,length(thD_list) + 1);
for i=0:length(thD_list)
    th_deltaDur = down_durations(threshMax_deep==i);
    mean_thr_deltadeepDur(i+1) = mean(th_deltaDur);
    std_thr_deltadeepDur(i+1) = std(th_deltaDur);
end

mean_thr_deltasupDur = zeros(1,length(thD_list) + 1);
std_thr_deltasupDur = zeros(1,length(thD_list) + 1);
for i=0:length(thD_list)
    th_deltaDur = down_durations(threshMax_sup==i);
    mean_thr_deltasupDur(i+1) = mean(th_deltaDur);
    std_thr_deltasupDur(i+1) = std(th_deltaDur);
end

%plot
figure, hold on
subplot(2,2,1), hold on
bar([0 thD_list], mean_thr_deltadiffDur)
title('Diff Deep-Sup')
subplot(2,2,2), hold on
bar([0 thD_list], mean_thr_deltadeepDur)
title('Deep')
subplot(2,2,3), hold on
bar([0 thD_list], mean_thr_deltasupDur)
title('Sup')

