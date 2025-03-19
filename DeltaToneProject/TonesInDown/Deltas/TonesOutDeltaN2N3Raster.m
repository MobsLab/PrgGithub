%%TonesOutDeltaN2N3Raster
% 25.07.2019 KJ
%
%
% see
%   TonesInDownN2N3Raster
%

clear

Dir = PathForExperimentsRandomTonesDelta;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tonesras_res
    
    tonesras_res.path{p}   = Dir.path{p};
    tonesras_res.manipe{p} = Dir.manipe{p};
    tonesras_res.name{p}   = Dir.name{p};
    tonesras_res.date{p}   = Dir.date{p};
    
    %params
    t_start      =  -1e4; %1s
    t_end        = 1e4; %1s
    
    freq_delta = [1 12];
    thresh_std = 2;
    thresh_std2 = 1;
    min_duration = 75; %for deltas
    maxDuration = 30e4; %for up states
    
    %sleep stage
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [~, N2, N3] = GetSubstages;
    
    %tones in deltas
    load('behavResources.mat', 'ToneEvent')
    tonesras_res.nb_tones = length(ToneEvent);
    
    %deep
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCdeep = LFP;
    %sup
    try
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
    catch
        load('ChannelsToAnalyse/PFCx_deltasup.mat', 'channel')
    end
    load(['LFPData/LFP' num2str(channel) '.mat'])
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

    % crucial element for noise detection.
    DeltaOffline = dropShortIntervals(all_cross_thresh, min_duration * 10);
    all_deltas_PFCx = and(DeltaOffline, NREM);
    %delay for the shift between down and delta
    deltas_PFCx = all_deltas_PFCx;
    st_deltas = Start(deltas_PFCx);
    end_deltas = End(deltas_PFCx);
    
    %Up
    up_PFCx = intervalSet(end_deltas(1:end-1), st_deltas(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Tones in - N2 & N3
    ToneUpN2 = Restrict(Restrict(ToneEvent, N2), up_PFCx);
    ToneUpN3 = Restrict(Restrict(ToneEvent, N3), up_PFCx);
    ToneUpNREM = Restrict(Restrict(ToneEvent, NREM), up_PFCx);
    
    tones_res.n2.nb_tones{p} = length(ToneUpN2);
    tones_res.n3.nb_tones{p} = length(ToneUpN3);
    tones_res.nrem.nb_tones{p} = length(ToneUpNREM);
    
    
    %% Rasters    
    tonesras_res.n2.rasters{p}  = RasterMatrixKJ(PFCdeep, ToneUpN2, t_start, t_end);
    tonesras_res.n3.rasters{p}  = RasterMatrixKJ(PFCdeep, ToneUpN3, t_start, t_end);
    tonesras_res.nrem.rasters{p}  = RasterMatrixKJ(PFCdeep, ToneUpNREM, t_start, t_end);
    
    
    %% orders

    %N2
    tonesin_tmp = Range(ToneUpN2);
    tonesras_res.n2.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.n2.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tonesras_res.n2.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tonesras_res.n2.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %N3
    tonesin_tmp = Range(ToneUpN3);
    tonesras_res.n3.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.n3.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tonesras_res.n3.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tonesras_res.n3.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %NREM
    tonesin_tmp = Range(ToneUpNREM);
    tonesras_res.nrem.before{p} = nan(length(tonesin_tmp), 1);
    tonesras_res.nrem.after{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)        
        st_bef = st_deltas(find(st_deltas<tonesin_tmp(i),1,'last'));
        tonesras_res.nrem.before{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>tonesin_tmp(i),1));
        tonesras_res.nrem.after{p}(i) = end_aft - tonesin_tmp(i);
    end
    

end

%saving data
cd(FolderDeltaDataKJ)
save TonesOutDeltaN2N3Raster.mat -v7.3 tonesras_res t_start t_end





