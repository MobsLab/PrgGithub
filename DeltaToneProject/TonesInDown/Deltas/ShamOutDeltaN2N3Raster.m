%%ShamOutDeltaN2N3Raster
% 25.07.2019 KJ
%
%
% see
%   ShamInUpN2N3Raster ShamOutDeltaN2N3Effect
%

clear

Dir=PathForExperimentsRandomShamDelta;


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p shamras_res
    
    shamras_res.path{p}   = Dir.path{p};
    shamras_res.manipe{p} = Dir.manipe{p};
    shamras_res.name{p}   = Dir.name{p};
    shamras_res.date{p}   = Dir.date{p};
    
    %params
    t_start      = -1e4; %1s
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
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham = length(SHAMtime);
    
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
    ShamUpN2 = Restrict(Restrict(SHAMtime, N2), up_PFCx);
    ShamUpN3 = Restrict(Restrict(SHAMtime, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(SHAMtime, NREM), up_PFCx);
    
    shamras_res.n2.nb_tones{p} = length(ShamUpN2);
    shamras_res.n3.nb_tones{p} = length(ShamUpN3);
    shamras_res.nrem.nb_tones{p} = length(ShamUpNREM);
    
    
    %% Rasters    
    shamras_res.n2.rasters{p}  = RasterMatrixKJ(PFCdeep, ShamUpN2, t_start, t_end);
    shamras_res.n3.rasters{p}  = RasterMatrixKJ(PFCdeep, ShamUpN3, t_start, t_end);
    shamras_res.nrem.rasters{p}  = RasterMatrixKJ(PFCdeep, ShamUpNREM, t_start, t_end);
    
    
    %% orders

    %N2
    shamin_tmp = Range(ShamUpN2);
    shamras_res.n2.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n2.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        shamras_res.n2.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        shamras_res.n2.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %N3
    shamin_tmp = Range(ShamUpN3);
    shamras_res.n3.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.n3.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        shamras_res.n3.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        shamras_res.n3.after{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamUpNREM);
    shamras_res.nrem.before{p} = nan(length(shamin_tmp), 1);
    shamras_res.nrem.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)        
        st_bef = st_deltas(find(st_deltas<shamin_tmp(i),1,'last'));
        shamras_res.nrem.before{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_deltas(find(end_deltas>shamin_tmp(i),1));
        shamras_res.nrem.after{p}(i) = end_aft - shamin_tmp(i);
    end
    

end

%saving data
cd(FolderDeltaDataKJ)
save ShamOutDeltaN2N3Raster.mat -v7.3 shamras_res t_start t_end





