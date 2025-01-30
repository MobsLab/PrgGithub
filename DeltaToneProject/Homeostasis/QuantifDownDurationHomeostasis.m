%%QuantifDownDurationHomeostasis
% 17.09.2018 KJ
%
% Infos
%   quantification of the decrease of down states in function of their duration
%
% see
%   TestDownDurationDensity
%


Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    homeo_res.path{p}   = Dir.path{p};
    homeo_res.manipe{p} = Dir.manipe{p};
    homeo_res.name{p}   = Dir.name{p};
    homeo_res.date{p}   = Dir.date{p};
    
    %params
    down_duration{1} = [75 100];
    down_duration{2} = [100 150];
    down_duration{3} = [150 200];
    down_duration{4} = [200 250];
    down_duration{5} = [250 1000];
    
    
    %% load
    %SWS
    try
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    end
    
    %down states
    load('DownState.mat','down_PFCx')
    
    %night duration
    load LFPData/LFP0
    night_duration = max(Range(LFP));
    clear LFP
    
    
    %% params       
    smoothing = 2;
    windowsize = 60E4; %60s
    intervals_start = 0:windowsize:night_duration;
    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% evolution

    %start deltas of various durations, restrict to SWS    
    for i=1:length(down_duration)
        min_dur = down_duration{i}(1) * 10;
        max_dur = down_duration{i}(2) * 10;
        DownDur = dropLongIntervals(dropShortIntervals(down_PFCx, min_dur), max_dur);
        start_down{i} = Restrict(ts(Start(DownDur)),SWSEpoch);
    end
    
    
    %% density
    
    for i=1:length(down_duration)
        density_down{i} = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            density_down{i}(t) = length(Restrict(start_down{i},intv))/60; %per sec
        end
        %smooth
        smooth_density{i} = Smooth(density_down{i}, smoothing);
        smooth_density{i} = density_down{i}/mean(density_down{i});
        
        %regression
        idx_down = smooth_density{i} > max(smooth_density{i})/8;
        [homeo_res.p_multi{p,i},~] = polyfit(x_intervals(idx_down), smooth_density{i}(idx_down)', 1);
        
        %save
        homeo_res.x_density{p,i} = x_intervals;
        homeo_res.y_density{p,i} = density_down{i};
        homeo_res.smooth_density{p,i} = smooth_density{i};
    end
        
    
end

%saving data
cd(FolderDeltaDataKJ)
save QuantifDownDurationHomeostasis.mat homeo_res down_duration smoothing windowsize







