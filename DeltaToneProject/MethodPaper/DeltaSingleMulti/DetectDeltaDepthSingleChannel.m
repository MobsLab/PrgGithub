%%DetectDeltaDepthSingleChannel
%
% 31.01.2018 KJ
%
%
% see
%   DetectDeltaDepthMultiChannel DeltaSingleChannelAnalysis DeltaSingleChannelAnalysis2
%


Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p depth_res
    
    depth_res.path{p}   = Dir.path{p};
    depth_res.manipe{p} = Dir.manipe{p};
    depth_res.name{p}   = Dir.name{p};
    depth_res.date{p}   = Dir.date{p};
    
    
    %% params
    freq_delta          = [1 4];
    min_duration_delta  = 50;
    thresh_std = 2;

    
    %% load data

    % Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    
    %PFC channels
    load('IdFigureData2.mat', 'channel_curves', 'structures_curves', 'peak_value')
    idx = find(strcmpi(structures_curves,'PFCx'));
    channel_curves = channel_curves(idx);
    peak_value = peak_value(idx);
    
    
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    for ch=1:length(channels)
        peak_value_new(ch) = peak_value(channel_curves==channels(ch));
    end
    peak_value = peak_value_new;
    
    
    %% Delta detection
    for i=1:length(channels)

        load(['LFPData/LFP' num2str(channels(i))], 'LFP')
        Signals = LFP; 
        clear LFP
        
        %filtered
        FiltLFP = FilterLFP(Signals, freq_delta, 1024);
        if peak_value(i)>0
            positive_filtered = max(Data(FiltLFP),0);
        else
            positive_filtered = -min(Data(FiltLFP),0);
        end
        %stdev
        std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
        % deltas
        thresh_delta = thresh_std * std_of_signal;
        all_cross_thresh = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_delta, 'Direction', 'Above');
        deltas = dropShortIntervals(all_cross_thresh, min_duration_delta * 10); % crucial element for noise detection.
        %Restrict    
        depth_res.deltas{p}{i} = and(deltas, NREM);
    end
    
    %save
    depth_res.channels{p}   = channels;
    depth_res.peak_value{p} = peak_value;
    
end

%saving data
cd(FolderDeltaDataKJ)
save DetectDeltaDepthSingleChannel.mat depth_res freq_delta thresh_std min_duration_delta



