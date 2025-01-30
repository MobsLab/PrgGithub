%%GammaDownChannelAnalysis
% 24.04.2018 KJ
%
%   Compare gamma down detection for each location of PFCx
%   -> here the data are collected  
%
% see
%   DetectGammaDownChannels DeltaSingleChannelAnalysis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DetectGammaDownChannels.mat'))


for p=1:length(gamma_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(gamma_res.path{p})
    
    clearvars -except gamma_res p analyz_res
    
    analyz_res.path{p}   = gamma_res.path{p};
    analyz_res.manipe{p} = gamma_res.manipe{p};
    analyz_res.name{p}   = gamma_res.name{p};
    analyz_res.peak_value{p} = gamma_res.peak_value{p};
    analyz_res.channels{p} = gamma_res.channels{p};
    
    
    %% init
    %params
    intvDur     = 500; %50ms
    smoothing   = 1;
    windowsize  = 60E4; %60s
    hemisphere  = 0;
    
    %load
    load(fullfile(gamma_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %LFP channels 
    load(fullfile(gamma_res.path{p}, 'LFPData', 'InfoLFP.mat'))
    channels = gamma_res.channels{p};
    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
    end
    analyz_res.channels{p} = channels;
    peak_value = gamma_res.peak_value{p};
    
    
    %down
    load(fullfile(gamma_res.path{p}, 'DownState.mat'), 'down_PFCx')
    down_tmp_h = (Start(down_PFCx)+End(down_PFCx)) / 2;
    
    load(fullfile(gamma_res.path{p},'DownState.mat'), 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        down_tmp_r = (Start(down_PFCx_r)+End(down_PFCx_r)) / 2;
        hemisphere=1;
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
    
    
    if hemisphere
        down_density_r = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            down_density_r(t) = length(Restrict(ts(down_tmp_r),intv))/60; %per sec
        end
        down_density_r = Smooth(down_density_r, smoothing);
    end
     
    
    %loop over pair of channels
    for ch=1:length(analyz_res.channels{p})
        
        %events
        if hemisphere && strcmpi(hemi_channel{ch},'r') %right hemisphere
            down_tmp = down_tmp_r;
            density.down{ch} = down_density_r;
        else
            down_tmp = down_tmp_h;
            density.down{ch} = down_density_h;
        end
        GammaDown = gamma_res.down{p}{ch};
        gammadown_tmp = Start(GammaDown);
        
        
        %% intersection delta waves and down states
        larger_gamma_epochs = [Start(GammaDown)-intvDur, End(GammaDown)+intvDur];
        [status, ~, ~] = InIntervals(down_tmp,larger_gamma_epochs);
        % count
        down_gamma(ch) = sum(status);
        down_only(ch) = length(down_tmp) - down_gamma(ch);
        gamma_only(ch) = length(Start(GammaDown)) - down_gamma(ch);
        
        %% density curves
        
        %deltas density
        gamma_density = zeros(length(intervals_start),1);
        for t=1:length(intervals_start)
            intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
            gamma_density(t) = length(Restrict(ts(gammadown_tmp),intv))/60; %per sec
        end        
        density.gamma{ch} = Smooth(gamma_density, smoothing);
        
        %similarity
        ratio_decrease{ch}   = CompareDecreaseDensity(density.down{ch}, density.gamma{ch}, density.x);
        frechet_distance{ch} = DiscreteFrechetDist(density.down{ch}, density.gamma{ch});
        
    end
    
    
    %% save
    analyz_res.down_gamma{p} = down_gamma;
    analyz_res.down_only{p}  = down_only;
    analyz_res.gamma_only{p} = gamma_only;
    
    analyz_res.density.x{p} = density.x;
    analyz_res.density.down{p} = density.down;
    analyz_res.density.gamma{p} = density.gamma;
    
    analyz_res.density.distance{p} = frechet_distance;
    analyz_res.density.decrease{p} = ratio_decrease;

end


%saving data
load([FolderDeltaDataKJ 'DetectGammaDownChannels.mat'])
cd(FolderDeltaDataKJ)
save GammaDownChannelAnalysis.mat analyz_res intvDur smoothing windowsize freqGamma thresh predectDur mergeGap minDuration

    
     


