%%DetectDeltaDepthMultiChannel
%
% 31.01.2018 KJ
%
% see   
%   DetectDeltaDepthSingleChannel


Dir = PathForExperimentsBasalSleepSpike;


%% single channels
for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p depth_res
    
    depth_res.path{p}   = Dir.path{p};
    depth_res.manipe{p} = Dir.manipe{p};
    depth_res.name{p}   = Dir.name{p};
    depth_res.date{p}   = Dir.date{p};
    
    
    %% params
    freq_delta          = [1 12];
    thresh_std          = 2;
    min_duration_delta  = 50;
    
    
    %% load data

    % Epoch
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    end
    GoodEpoch=SWSEpoch-TotalNoiseEpoch;
    
    %PFC
    load('IdFigureData2.mat', 'channel_curves', 'structures_curves', 'peak_value')
    idx = strcmpi(structures_curves,'PFCx');
    channels = channel_curves(idx);
    peak_value = peak_value(idx);
    
    
    
    %keep only channels not too close
    [peak_value, idx] = sort(peak_value, 'descend');
    channels = channels(idx);
    
    current_value = peak_value(1);
    kept_idx = 1;
    thresh = 100;
    for i=2:length(peak_value)
        if peak_value(i) < current_value - thresh
            kept_idx = [kept_idx i];
            current_value = peak_value(i);
        end
    end
    peak_value = peak_value(kept_idx);
    channels = channels(kept_idx);
    
    %LFP
    Signals = cell(0);
    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end
    
    %couple of channel
    duo_channels = nchoosek(channels,2);
    
    
    %% Delta detection
    for i=1:size(duo_channels,1)
        ch_deep = find(channels==duo_channels(i,1));
        ch_sup  = find(channels==duo_channels(i,2));
        
        %normalize
        clear distance
        k=1;
        for j=0.1:0.1:4
            distance(k)=std(Data(Signals{ch_deep})-j*Data(Signals{ch_sup}));
            k=k+1;
        end
        Factor = find(distance==min(distance))*0.1;
        %resample & filter & positive value
        EEGsleepDiff = ResampleTSD(tsd(Range(Signals{ch_deep}),Data(Signals{ch_deep}) - Factor*Data(Signals{ch_sup})),100);        
        FiltLFP = FilterLFP(EEGsleepDiff, freq_delta, 1024);
        positive_filtered = max(Data(FiltLFP),0);
        %stdev
        std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
        % deltas
        thresh_delta = thresh_std * std_of_signal;
        all_cross_thresh = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_delta, 'Direction', 'Above');
        deltas = dropShortIntervals(all_cross_thresh, min_duration_delta * 10); % crucial element for noise detection.
        %Restrict    
        DeltaEpochs{i} = and(deltas, GoodEpoch);
    end
    
    %save
    depth_res.deltas{p}       = DeltaEpochs;
    depth_res.channels{p}     = channels;
    depth_res.duo_channels{p} = duo_channels;
    
end

%saving data
cd([FolderProjetDelta 'Data/'])
save DetectDeltaDepthMultiChannel.mat depth_res freq_delta thresh_std min_duration_delta








