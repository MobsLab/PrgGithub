%quantif_tone_effect_delay

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
load StateEpochSB SWSEpoch Wake
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
load('DeltaSleepEvent.mat', 'TONEtime2_SWS')

delay = 1400; %in 1E-4s
ToneEvent = Restrict(ts(TONEtime2_SWS + delay),SWSEpoch);
tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + 3000);  % Tone and its window where an effect could be observed
nb_tones = length(ToneEvent);

%params
freqDelta = [1 6];
thD = 2;
thDeep = 2.4;
minDeltaDuration = 50;
binsize=10;
thresh0 = 0.7;
minDownDur = 100;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;

t_before = -30000; %in 1E-4s
t_after = 20000; %in 1E-4s


%% Multi-Unit activity and down
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Q = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
down_tmp = Start(Down) + (End(Down)-Start(Down)) / 2;
start_down = Start(Down);


%% Signals
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


%% deltas
%diff
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
deltas_tmp = Start(DeltaOffline) + (End(DeltaOffline)-Start(DeltaOffline)) / 2;
start_deltas = Start(DeltaOffline);


%% ordered data
tones_tmp = Range(ToneEvent);

%delta
last_delta_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    idx_delta_before = find(deltas_tmp < tones_tmp(i), 1, 'last');
    last_delta_tone(i) = tones_tmp(i) - deltas_tmp(idx_delta_before);
    
end
[delay_delta_sort, idx_delta_sort] = sort(last_delta_tone, 'ascend');

%down states
last_down_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    idx_down_before = find(down_tmp < tones_tmp(i), 1, 'last');
    last_down_tone(i) = tones_tmp(i) - down_tmp(idx_down_before);
    
end
[delay_down_sort, idx_down_sort] = sort(last_down_tone, 'ascend');



%% Check if delta or down state after tone
induce_delta = zeros(nb_tones, 1);
induce_down = zeros(nb_tones, 1);

[status,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
tone_success = unique(interval);
induce_delta(tone_success(2:end)) = 1;
induce_delta = induce_delta(idx_delta_sort);

[status,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
tone_success = unique(interval);
induce_down(tone_success(2:end)) = 1;
induce_down = induce_down(idx_down_sort);


%% quantification and bar plot
group_size = 50;

tone_effect_delta = nan(group_size,floor(length(idx_delta_sort)/group_size));
for i=1:numel(tone_effect_delta)
   tone_effect_delta(i) = induce_delta(i); 
end

tone_effect_down = nan(group_size,floor(length(idx_down_sort)/group_size));
for i=1:numel(tone_effect_delta)
   tone_effect_down(i) = induce_down(i); 
end


%plot
figure('Color',[1 1 1]), hold on,

[R,S,E]=MeanDifNan(tone_effect_delta);
subplot(1,2,1), errorbar(R,E,'+','Color','k'),
hold on, bar(R,'k'), title('delta waves')
hold on, xlim([0 size(tone_effect_delta,2)+1]), ylim([0 1])

[R,S,E]=MeanDifNan(tone_effect_down);
subplot(1,2,2), errorbar(R,E,'+','Color','k'),
hold on, bar(R,'k'), title('down states')
hold on, xlim([0 size(tone_effect_down,2)+1]), ylim([0 1])













% %Figure and Peth
% 
% figure, [fh, rasterAx, histAx, MUA_SingleTone] = ImagePETHOrdered(Q, ToneEvent, idx_delta_sort, t_before, t_after);
% hold on, title('MUA diff tone SWS')
% 
% figure, [fh, rasterAx, histAx, LFP_SingleTone] = ImagePETHOrdered(EEGsleepDiff, ToneEvent, idx_delta_sort, t_before, t_after);
% hold on, title('LFP diff tone SWS')
% 
% %
% MUA_tone = Restrict(MUA_SingleTone, intv_delta_effect);
% LFP_tone = Restrict(LFP_SingleTone, intv_delta_effect);
% mua_data = Data(MUA_tone);
% diff_data = Data(LFP_tone);
% 
% 
% for d=1:length(delay_group)-1
%     mua_subset = mua_data(:,delay_group(d)+1, delay_group(d+1));
%     diff_subset = diff_data(:, delay_group(d)+1, delay_group(d+1));
% 
%     
%     
% end















