%DownAfterSound

clear
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
load('DeltaSleepEvent.mat', 'TONEtime1')


% params
frequency_sampling = 1250;
mua_binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 1000;
mergeGap = 10; % merge
predown_size = 50;
window_eff = 300;
window_size = 10000; %10s

%get lfp
EEGdeep = ResampleTSD(LFPdeep,frequency_sampling);
EEGsup = ResampleTSD(LFPsup,frequency_sampling);
EEGdiff = tsd(Range(EEGdeep), Data(EEGdeep)-Data(EEGsup));


%% get downstate
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,mua_binsize*10); %binsize*10 to be in E-4s
%Down
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');

%data for plot
down_start = Start(Down,'ms');
down_duration = (End(Down,'ms') - Start(Down,'ms'));

%Sounds
nb_tones = length(TONEtime1);
ToneEvent = ts(TONEtime1);
tone_interval = [Range(ToneEvent, 'ms') Range(ToneEvent, 'ms') + window_eff];
tone_start = Range(ToneEvent);
[status,interval,index] = InIntervals(Start(Down,'ms'), tone_interval);
good_sounds = unique(interval);
good_sounds = good_sounds(2:end);
bad_sounds = setdiff(1:length(tone_interval), good_sounds);

%Dataset
training = cell(0);
for i=1:nb_tones
    if mod(i,1000)==0
        disp(i)
    end
    subEpoch = intervalSet(tone_start(i) - window_size * 10, tone_start(i));
    
    sub_deep = Restrict(EEGdeep, subEpoch);
    sub_sup = Restrict(EEGsup, subEpoch);
    training{i} = [Data(sub_sup)' ; Data(sub_deep)'];

end


%Format data set for hdf5
data_label = zeros(1, nb_tones);
data_label(good_sounds) = 1;
data_sup = zeros(length(training),length(training{1}));
data_deep = zeros(length(training),length(training{1}));
for i=1:length(training)
    if mod(i,1000)==0
        disp(i)
    end
    data_sup(i,:) = training{i}(1,:);
    data_deep(i,:) = training{i}(2,:);
end
%Write
hdf5write('tone_mouse244_1.h5', '/eeg_sup', data_sup);
hdf5write('tone_mouse244_1.h5', '/eeg_deep', data_deep, 'WriteMode', 'append');
hdf5write('tone_mouse244_1.h5', '/tone_label', data_label, 'WriteMode', 'append');


