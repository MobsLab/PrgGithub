%%ParcoursCreateDeltaWavesMax
% 25.07.2013 KJ
%
%   Create deltawaves from deepest to most sup layers, no minimum durations
%
%
% see
%   MakeDeltaOnChannelsEvent CreateDeltaWavesSleep
%


clear
Dir = PathForExperimentsRandomTonesDelta;
% Dir = PathForExperimentsBasalSleepSpike;
Dir=PathForExperimentsRandomShamDelta;
Dir=PathForExperimentsDeltaCloseLoop('all')

%% 
for p=1:length(Dir.path)  
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    try
        load('DeltaWaves.mat', 'deltamax_PFCx')
    catch
        CreateSleepSignals('scoring','ob');
    end
    
    
    if exist('deltamax_PFCx','var')
        continue
    end
    
    
    %% params
    freq_delta = [1 12];
    thresh_std = 2;
    thresh_std2 = 1;
    min_duration = 40;


    %% load

    %channels
    %deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    ch_deep = channel;
    %sup
    try
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
        ch_sup = channel;
    catch
        load('ChannelsToAnalyse/PFCx_deltasup.mat', 'channel')
        ch_sup = channel;
    end

    
    %load
    load(['LFPData/LFP' num2str(ch_deep) '.mat'])
    PFCdeep = LFP;
    load(['LFPData/LFP' num2str(ch_sup) '.mat'])
    PFCsup = LFP;
    clear LFP
    

    %% Detect delta waves
    %normalize
    clear distance
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(PFCdeep)-i*Data(PFCsup));
        k=k+1;
    end
    Factor = find(distance==min(distance))*0.1;

    %resample & filter & positive value
    EEGsleepDiff = ResampleTSD(tsd(Range(PFCdeep),Data(PFCdeep) - Factor*Data(PFCsup)),100);
    Filt_diff = FilterLFP(EEGsleepDiff, freq_delta, 1024);
    pos_filtdiff = max(Data(Filt_diff),0);
    %stdev
    std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

    % deltas detection
    thresh_delta = thresh_std * std_diff;
    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
    center_detections = (Start(all_cross_thresh)+End(all_cross_thresh))/2;

    %thresholds start ends
    thresh_delta2 = thresh_std2 * std_diff;
    all_cross_thresh2 = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta2, 'Direction', 'Above');
    %intervals with dections inside
    [~,intervals,~] = InIntervals(center_detections, [Start(all_cross_thresh2), End(all_cross_thresh2)]);
    intervals = unique(intervals); intervals(intervals==0)=[];
    %selected intervals
    all_cross_thresh = subset(all_cross_thresh2,intervals);
    
    %save
    deltamax_PFCx = all_cross_thresh;
    save('DeltaWaves.mat', '-append','deltamax_PFCx')
    
    
end


