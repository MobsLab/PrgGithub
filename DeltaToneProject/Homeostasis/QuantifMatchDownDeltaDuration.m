%%QuantifMatchDownDeltaDuration
% 17.09.2018 KJ
%
% Infos
%   Find the best delta waves minimum duration to match down states of a
%   minimum duration
% 
% see
%   TestDownDurationDensity
%


Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1%:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p match_res
    
    match_res.path{p}   = Dir.path{p};
    match_res.manipe{p} = Dir.manipe{p};
    match_res.name{p}   = Dir.name{p};
    match_res.date{p}   = Dir.date{p};
    
    %params
    down_mindur = [75 100 125 150];
    delta_mindur = [50 75 100 125 150];
    smoothing = 1;
    windowsize = 60E4; %60s
    intvsize = (25:25:200)*10; %size of windows for intersection
    
    
    %% load
    %SWS
    try
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    end
    
    %down states 
    load('DownState.mat','down_PFCx')
    %delta waves
    load('DeltaWaves.mat', 'deltas_PFCx')
    
    %night duration
    load('IdFigureData2.mat', 'night_duration')
    if ~exist('night_duration','var')
        load LFPData/LFP0
        night_duration = max(Range(LFP));
        clear LFP
    end
    %intervals
    intervals_start = 0:windowsize:night_duration;    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% match - precision/recall/f1-score
    for d=1:length(down_mindur)
        %remove short down
        downDur = dropShortIntervals(down_PFCx, down_mindur(d));
        
        for m=1:length(delta_mindur)
            %remove short deltas
            deltaDur = dropShortIntervals(deltas_PFCx, delta_mindur(m));
            deltas_tmp = (Start(deltaDur)+End(deltaDur)) / 2;

            %intersection for each interval size tolerance
            for i=1:length(intvsize)
                down_around = [Start(downDur)-intvsize(i), End(downDur)+intvsize(i)];
                [status, ~, ~] = InIntervals(deltas_tmp, down_around);
                down_delta(i) = sum(status);
                down_only(i) = length(Start(down_PFCx)) - down_delta(i);
                delta_only(i) = length(deltas_tmp) - down_delta(i);
            end

            %precision
            d_precision{d,m} = down_delta ./ (down_delta + delta_only);
            %recall
            d_recall{d,m}    = down_delta ./ (down_delta + down_only);
            %F1-score
            f1score{d,m}     = 2 .* d_precision{d,m} .* d_recall{d,m} ./ (d_precision{d,m} + d_recall{d,m});

        end
    end
    
    %save
    match_res.precision{p}  = d_precision;
    match_res.recall{p}     = d_recall;
    match_res.f1score{p}    = f1score;
    
    
    %% Density and similarity
    for d=1:length(down_mindur)
        %remove short down
        downDur = dropShortIntervals(down_PFCx, down_mindur(d));
        
        for m=1:length(delta_mindur)
            %remove short deltas
            deltaDur = dropShortIntervals(deltas_PFCx, delta_mindur(m));
            deltas_tmp = (Start(deltaDur)+End(deltaDur)) / 2;
            
            
            
        end
    end
    
    %% Cross-corr
    for d=1:length(down_mindur)
        %remove short down
        downDur = dropShortIntervals(down_PFCx, down_mindur(d));
        down_center = (Start(downDur)+End(downDur)) / 2;
        
        for m=1:length(delta_mindur)
            %remove short deltas
            deltaDur = dropShortIntervals(deltas_PFCx, delta_mindur(m));
            deltas_center = (Start(deltaDur)+End(deltaDur)) / 2;
            
            
            
        end
    end
    
    
    
end
% 
% %saving data
% cd(FolderDeltaDataKJ)
% save QuantifMatchDownDeltaDuration.mat match_res down_mindur delta_mindur
% 
% 
% 





