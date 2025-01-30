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
    
    
    %ECOG ?
    ecogs = [];
    if exist('ChannelsToAnalyse/PFCx_ecog.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog.mat','channel')
        ecogs = [ecogs channel];
    end
    if exist('ChannelsToAnalyse/PFCx_ecog_right.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog_right.mat','channel')
        ecogs = [ecogs channel];
    end
    if exist('ChannelsToAnalyse/PFCx_ecog_left.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog_left.mat','channel')
        ecogs = [ecogs channel];
    end
    
    depth_res.ecogs{p} = unique(ecogs);
    
    
    %% Delta detection
    for i=1:length(channels)
        name_var = ['delta_ch_' num2str(channels(i))];
        load('DeltaWavesChannels.mat', name_var)
        eval(['deltas = ' name_var ';'])
        
        %Restrict    
        depth_res.deltas{p}{i} = and(deltas, NREM);
    end
    
    %save
    depth_res.channels{p}   = channels;
    depth_res.peak_value{p} = peak_value;
    
end

%saving data
cd(FolderDeltaDataKJ)
save DetectDeltaDepthSingleChannel.mat depth_res 



