%%DeltaSingleChannelAnalysis
% 07.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   -> here the data are collected  
%
% see
%   DetectDeltaDepthSingleChannel DeltaSingleChannelAnalysis2 DeltaMultiChannelAnalysis
%


% load
% clear
load(fullfile(FolderDeltaDataKJ, 'DetectDeltaDepthSingleChannel.mat'))


for p=1:length(depth_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(depth_res.path{p})
    
    clearvars -except single_res depth_res p freq_delta thresh_std min_duration_delta
    
    single_res.path{p}   = depth_res.path{p};
    single_res.manipe{p} = depth_res.manipe{p};
    single_res.name{p}   = depth_res.name{p};
    single_res.peak_value{p} = depth_res.peak_value{p};
    
    
    %% init
    %params
    intvDur_deep = 0*10; %0ms
    intvDur_sup = 10*10; %10ms
    smoothing = 1;
    windowsize = 60E4; %60s
    hemisphere=0;
    
    %load
    load(fullfile(depth_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %LFP channels 
    load(fullfile(depth_res.path{p}, 'LFPData', 'InfoLFP.mat'))
    channels = depth_res.channels{p};
    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
    end
    %add -1 to channels (multi layer detection)
    channels(end+1) = -1;
    hemi_channel{end+1} = 'n';
    single_res.channels{p} = channels;
    peak_value = [depth_res.peak_value{p} 100]; % add multilayer
    
    
    %down
    load(fullfile(depth_res.path{p}, 'DownState.mat'), 'down_PFCx')
    down_tmp_h = (Start(down_PFCx)+End(down_PFCx)) / 2;
    
    load(fullfile(depth_res.path{p},'DownState.mat'), 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        down_tmp_r = (Start(down_PFCx_r)+End(down_PFCx_r)) / 2;
        hemisphere=1;
    end
    load(fullfile(depth_res.path{p},'DownState.mat'), 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        down_tmp_l = (Start(down_PFCx_l)+End(down_PFCx_l)) / 2;
        hemisphere=1;
    end
    
    %delta
    load(fullfile(depth_res.path{p}, 'DeltaWaves.mat'), 'deltas_PFCx')
    multidelta_tmp = (Start(deltas_PFCx)+End(deltas_PFCx)) / 2;
    if strcmpi(single_res.name{p},'Mouse508')
        load(fullfile(depth_res.path{p}, 'DeltaWaves.mat'), 'deltas_PFCx_l')
        multidelta_tmp = (Start(deltas_PFCx_l)+End(deltas_PFCx_l)) / 2;
    end
    
    %intervals
    intervals_start = 0:windowsize:night_duration;    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    %% down density
    down_density_h = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        down_density_h(t) = length(Restrict(ts(down_tmp_h),intv))/60; %per sec
    end
    density.x = x_intervals';
    down_density_h = Smooth(down_density_h, smoothing);
    
    
    if hemisphere && exist('down_tmp_r','var')
        down_density_r = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            down_density_r(t) = length(Restrict(ts(down_tmp_r),intv))/60; %per sec
        end
        down_density_r = Smooth(down_density_r, smoothing);
    end
    if hemisphere && exist('down_tmp_l','var')
        down_density_l = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            down_density_l(t) = length(Restrict(ts(down_tmp_l),intv))/60; %per sec
        end
        down_density_l = Smooth(down_density_l, smoothing);
    end
    
    
    %loop over pair of channels
    for ch=1:length(single_res.channels{p})
        
        %events
        if channels(ch)==-1 %multi-layer           
            down_tmp = down_tmp_h;
            density.down{ch} = down_density_h;
            DeltaEpoch = deltas_PFCx;
            deltas_tmp = multidelta_tmp;
            if strcmpi(single_res.name{p},'Mouse508')
                down_tmp = down_tmp_l;
                density.down{ch} = down_density_l;
                DeltaEpoch = deltas_PFCx_l;
                deltas_tmp = multidelta_tmp;
            end
        else
            if hemisphere && strcmpi(hemi_channel{ch},'r') %right hemisphere
                down_tmp = down_tmp_r;
                density.down{ch} = down_density_r;
            elseif hemisphere && strcmpi(hemi_channel{ch},'l') %left hemisphere
                down_tmp = down_tmp_l;
                density.down{ch} = down_density_l;
            else
                down_tmp = down_tmp_h;
                density.down{ch} = down_density_h;
            end
            DeltaEpoch = depth_res.deltas{p}{ch};
            deltas_tmp = (Start(DeltaEpoch)+End(DeltaEpoch)) / 2;
        end
        
        
        %% intersection delta waves and down states
        if peak_value(ch)>0
            intvDur = intvDur_deep;
        else
            intvDur = intvDur_sup;
        end
        larger_delta_epochs = [Start(DeltaEpoch)-intvDur, End(DeltaEpoch)+intvDur];
        [status, ~, ~] = InIntervals(down_tmp,larger_delta_epochs);
        % count
        down_delta(ch) = sum(status);
        down_only(ch) = length(down_tmp) - down_delta(ch);
        delta_only(ch) = length(Start(DeltaEpoch)) - down_delta(ch);
        
        %% density curves
        
        %deltas density
        delta_density = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            delta_density(t) = length(Restrict(ts(deltas_tmp),intv))/60; %per sec
        end        
        density.delta{ch} = Smooth(delta_density, smoothing);
        
        %similarity
        ratio_decrease{ch}   = CompareDecreaseDensity(density.down{ch}, density.delta{ch}, density.x);
        frechet_distance{ch} = DiscreteFrechetDist(density.down{ch}, density.delta{ch});
        
    end
    
    
    %% save
    single_res.down_delta{p} = down_delta;
    single_res.down_only{p}  = down_only;
    single_res.delta_only{p} = delta_only;
    
    single_res.density.x{p} = density.x;
    single_res.density.down{p} = density.down;
    single_res.density.delta{p} = density.delta;
    
    single_res.density.distance{p} = frechet_distance;
    single_res.density.decrease{p} = ratio_decrease;

end


%saving data
cd(FolderDeltaDataKJ)
save DeltaSingleChannelAnalysis.mat single_res intvDur smoothing windowsize


