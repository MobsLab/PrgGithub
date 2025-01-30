%%DetectGammaDownChannels
%
% 24.04.2018 KJ
%
%
% see
%   DetectDeltaDepthSingleChannel
%


Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p gamma_res
    
    gamma_res.path{p}   = Dir.path{p};
    gamma_res.manipe{p} = Dir.manipe{p};
    gamma_res.name{p}   = Dir.name{p};
    gamma_res.date{p}   = Dir.date{p};
    
    
    %% params
    thresh = 2.2;    
    freqGamma = [300 550];
    predectDur = 30;
    mergeGap = 10;
    minDuration = 50;
    maxDuration = 700;

    
    %% load data

    % Epoch
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
        GoodEpoch=SWSEpoch-TotalNoiseEpoch;
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
        GoodEpoch=SWSEpoch-TotalNoiseEpoch;
    end

    
    %PFC channels
    load('IdFigureData2.mat', 'channel_curves', 'structures_curves', 'peak_value')
    idx = find(strcmpi(structures_curves,'PFCx'));
    channel_curves = channel_curves(idx);
    peak_value = peak_value(idx);
    
    %peak value
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    for ch=1:length(channels)
        peak_value_new(ch) = peak_value(channel_curves==channels(ch));
    end
    peak_value = peak_value_new;
    
    %Delta waves channels
    for ch=1:length(channels)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channels(ch))])
        eval(['Deltas{ch} = delta_ch_' num2str(channels(ch)) ';'])
    end
    
    
    %% Delta detection
    for i=1:length(channels)

        load(['LFPData/LFP' num2str(channels(i))], 'LFP')
        Signals = LFP; 
        clear LFP
        
        %filtered
        FiltLFP = FilterLFP(Signals, freqGamma, 1024);
        
        %stdev
        std_signal = mean(abs(Data(Restrict(FiltLFP, Deltas{ch}))));
    
        all_cross_thresh = thresholdIntervals(FiltLFP, thresh*std_signal, 'Direction', 'Below');
        DeltaGamma = dropShortIntervals(all_cross_thresh, predectDur * 10); 
        DeltaGamma = mergeCloseIntervals(DeltaGamma, mergeGap * 10); 
        DeltaGamma = dropShortIntervals(DeltaGamma, minDuration * 10);
        DeltaGamma = dropLongIntervals(DeltaGamma, maxDuration * 10);
        %save
        gamma_res.down{p}{i} = and(DeltaGamma, SWSEpoch);
    end
    
    %save
    gamma_res.channels{p}   = channels;
    gamma_res.peak_value{p} = peak_value;
    
end

%saving data
cd(FolderDeltaDataKJ)
save DetectGammaDownChannels.mat gamma_res freqGamma thresh minDuration mergeGap predectDur








