%%DeltaReboundAfterWake
% 18.03.2019 KJ
%
% Infos
%   
%
% see
%   
%   


Dir = PathForExperimentsBasalSleepSpike;
Dir = PathForExperimentsDeltaSleepSpikes('all');

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    rebound_res.path{p}   = Dir.path{p};
    rebound_res.manipe{p} = Dir.manipe{p};
    rebound_res.name{p}   = Dir.name{p};
    rebound_res.date{p}   = Dir.date{p};

    
    %% load
    [NREM, REM, Wake] = GetSleepScoring('scoring','ob');
    delta_waves = GetDeltaWaves('area','PFCx');
    down_PFCx = GetDownStates('area','PFCx');
    try
        load('IdFigureData2.mat', 'night_duration')
    catch
        load('LFPData/LFP0.mat')
        night_duration = max(Range(LFP));
    end
%     down_PFCx = dropShortIntervals(down_PFCx,1000);
%     delta_waves = dropShortIntervals(delta_waves,750);
    
    
    %% density
    %params       
    windowsize = 60E4; %60s
    intervals_start = 0:windowsize:night_duration;
    x_intervals = (intervals_start + windowsize/2)/(3600E4);

    %down states
    start_down = ts(Start(down_PFCx));
    density_down = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        density_down(t) = length(Restrict(start_down,intv))/60; %per sec
    end
    
    %delta waves
    start_delta = ts(Start(delta_waves));
    density_delta = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t) - windowsize,intervals_start(t) + windowsize);
        density_delta(t) = length(Restrict(start_delta,intv))/120; %per sec
    end
    
    %smooth
%     density_down = runmean(density_down,2);
%     density_delta = runmean(density_delta,2);
    
    %%
    
    
    figure, plot(x_intervals, density_delta)
    
    
end

%
% %saving data
% cd(FolderDeltaDataKJ)
% save DeltaReboundAfterWake.mat rebound_res 






