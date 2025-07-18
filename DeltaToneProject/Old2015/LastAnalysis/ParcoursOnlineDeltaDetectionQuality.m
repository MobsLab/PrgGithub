% ParcoursOnlineDeltaDetectionQuality

clear

% params
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
tbefore = 70; %time before down init, in ms
tafter = 70; %time after down end
%Delta
minDeltaDuration = 50;
freqDelta=[1 6];
thD_list = 0.2:0.2:3;

exp='DeltaToneAll';
Dir=PathForExperimentsDeltaSleep2016(exp);
    
a=0;
for manip=1:length(Dir.path)
    a = a + 1;
    disp('  ')
    disp(Dir.path{manip})
    disp(' ')
    cd(Dir.path{manip})
    
    %load data 
    error_loading = 0;
    try
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
        load DeltaSleepEvent
        online_deltas = ts(DeltaDetect);
    catch
        error_loading = 1;
    end
    
    if error_loading
        continue
    end


    Res.path{a} = Dir.path{manip};
    %% Find downstates
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
    
    Res.FRsws{a} = mean(full(Data(Restrict(Q, SWSEpoch))), 1); % firing rate for a bin of 10ms
    Res.FRwake{a} = mean(full(Data(Restrict(Q, Wake))), 1);
    
    %Down
    Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
    down_interval = [Start(Down) End(Down)];
    down_durations = End(Down) - Start(Down);
    largeDown = [Start(Down,'ms')-tbefore End(Down,'ms')+tafter];
    nb_down = length(down_interval);

    
    %% Match down vs online delta
    [status,interval,index] = InIntervals(Range(online_deltas,'ms'), largeDown);
    recalled_down = ismember(1:nb_down,unique(interval));
    
    Res.nbOnlineDelta{a} = length(status);
    Res.nbDown{a} = nb_down;
    Res.nbGoodOnlineDelta{a} = sum(status);
        
    
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
        deltas_off= Start(DeltaOffline,'ms')

        [status,interval,index] = InIntervals(Range(online_deltas,'ms'), deltas_off_intervals);
        recalled_delta{i} = ismember(1:length(deltas_off_intervals),unique(interval));

        precision(i) = sum(status) / length(status);
        recall(i) = sum(status) / size(deltas_off_intervals,1);

    end 
    
    Res.precisionOffOn{a} = precision;
    Res.recallOffOn{a} = recall;
      
end


%% Analyse down states and online delta
nb_manip = length(Res.path);
for a=1:nb_manip
    nb_online_delta = Res.nbOnlineDelta{a};
    nb_down = Res.nbDown{a};
    nb_good_online_delta = Res.nbGoodOnlineDelta{a};
    
    
    
    
end












