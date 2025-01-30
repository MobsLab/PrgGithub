%%DeltaMultiChannelAnalysis
% 07.03.2018 KJ
%
%   Find which pair of PFCx channels is the best for the detection of delta/down
%   -> here the data are collected  
%
% see
%   DetectDeltaDepthMultiChannel DeltaSingleChannelAnalysis DeltaMultiChannelAnalysis2
%


% load
clear
load([FolderProjetDelta 'Data/DetectDeltaDepthMultiChannel.mat'])


for p=1:length(depth_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(depth_res.path{p})
    
    clearvars -except multi_res depth_res p 
    
    %% init
    %params
    intvDur = 1500; %150ms
    smoothing = 1;
    windowsize = 60E4; %60s
    
    %load
    load(fullfile(depth_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    load(fullfile(depth_res.path{p}, 'DownState.mat'), 'down_PFCx')
    down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;
    
    %intervals
    intervals_start = 0:windowsize:night_duration;    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% down density
    down_density = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        down_density(t) = length(Restrict(ts(down_tmp),intv))/60; %per sec
    end
    density.x = x_intervals';
    density.down = Smooth(down_density, smoothing);
     
    
    %loop over pair of channels
    for i=1:length(depth_res.deltas{p})
        DeltaEpoch = depth_res.deltas{p}{i};
        deltas_tmp = (Start(DeltaEpoch)+End(DeltaEpoch)) / 2;
        
        
        %% intersection delta waves and down states
        larger_delta_epochs = [Start(DeltaEpoch)-intvDur, End(DeltaEpoch)+intvDur];
        [status, ~, ~] = InIntervals(down_tmp,larger_delta_epochs);

        % count
        down_delta(i) = sum(status);
        down_only(i) = length(down_tmp) - down_delta(i);
        delta_only(i) = length(Start(DeltaEpoch)) - down_delta(i);
        
        
        %% density curves similarities
        
        %deltas density
        delta_density = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            delta_density(t) = length(Restrict(ts(deltas_tmp),intv))/60; %per sec
        end        
        density.delta{i} = Smooth(delta_density, smoothing);
    end
    
    %save
    multi_res.down_delta{p} = down_delta;
    multi_res.down_only{p} = down_only;
    multi_res.delta_only{p} = delta_only;
    
    multi_res.density{p} = density;

end

multi_res.path   = depth_res.path;
multi_res.manipe = depth_res.manipe;
multi_res.name   = depth_res.name;
multi_res.channels       = depth_res.channels;
multi_res.duo_channels   = depth_res.duo_channels;


%saving data
cd([FolderProjetDelta 'Data/'])
save DeltaMultiChannelAnalysis.mat multi_res intvDur smoothing windowsize


