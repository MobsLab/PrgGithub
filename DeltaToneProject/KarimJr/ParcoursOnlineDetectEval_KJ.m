%ParcoursOnlineDetectEval_KJ


clear

prefix = '/home/karim/Documents/'; 
%prefix = '/Volumes/';

%% Path
a=0;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse243'];  % Mouse 243 - delay 200ms 
Dir.delay{a}=0.2; Dir.mouse{a}=243;
% a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244']; % Mouse 244 - Day Rdm Tone (delay 200ms!! of M243 detection)
% Dir.delay{a}=0.2; Dir.mouse{a}=244;

nb_records = a;

% Selected Mice
selected_mice = [243 244];

% params
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
tbefore = 50; %time before down init, in ms
tafter = 50; %time after down end
%Delta
minDeltaDuration = 50;
freqDelta=[1 5];
thD_list = 0.2:0.2:3;

precision_down = zeros(1,a);
recall_down = zeros(1,a);
precision_delta = zeros(a,length(thD_list));
recall_delta = zeros(a,length(thD_list));

% Loop over all experiments
for manip=1:length(Dir.path)
    %current folder with experiment data
    if ~ismember(Dir.mouse{manip}, selected_mice)
       continue 
    end
    disp('  ')
    disp(Dir.path{manip})
    disp(' ')
    cd(Dir.path{manip})
    tit = Dir.path{manip};
    
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
    load DeltaSleepEvent
    online_deltas = ts(DeltaDetect_SWS);
    
    
    %% Find downstates
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
    largeDown = [Start(Down,'ms')-tbefore End(Down,'ms')+tafter];
    
    
    %% Match down vs online delta
    [status,interval,index] = InIntervals(Range(online_deltas)/10,largeDown);
    recalled_down = ismember(1:length(down_interval),unique(interval));

    precision_down(manip) = sum(status) / length(status);
    recall_down(manip) = sum(status) / size(down_interval,1);
    recalled_down_durations{manip} = down_durations(recalled_down); 


    %% Offline deltas
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
        k=k+1;
    end
    Factor=find(distance==min(distance))*0.1;

    %Diff
    EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
    Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
    Filt_diff = Restrict(Filt_diff,SWSEpoch);
    pos_filtdiff = max(Data(Filt_diff),0);
    std_diff = std(pos_filtdiff(pos_filtdiff>0));  %std that determines thresholds

    precision = zeros(1,length(thD_list));
    recall = zeros(1,length(thD_list));

    for i=1:length(thD_list)
        thD = thD_list(i);
        thresh_delta = thD * std_diff;

        all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
        DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
        deltas_off_intervals = [Start(DeltaOffline,'ms') End(DeltaOffline,'ms')];

        [status,interval,index] = InIntervals(Range(online_deltas)/10, deltas_off_intervals);
        %recalled_delta{manip, i} = ismember(1:length(deltas_off_intervals),unique(interval));

        precision_delta(manip, i) = sum(status) / length(status);
        recall_delta(manip, i) = sum(status) / size(deltas_off_intervals,1);

    end
    
    
end





