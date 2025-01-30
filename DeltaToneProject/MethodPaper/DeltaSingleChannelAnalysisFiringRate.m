%%DeltaSingleChannelAnalysisFiringRate
% 12.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   -> here the data are collected  
%
% see
%   DetectDeltaDepthSingleChannel DeltaSingleChannelAnalysis
%


% load
load(fullfile(FolderDeltaDataKJ, 'DetectDeltaDepthSingleChannel.mat'))


for p=1:length(depth_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(depth_res.path{p})
    
    clearvars -except singfr_res depth_res p 
    
    singfr_res.path{p}   = depth_res.path{p};
    singfr_res.manipe{p} = depth_res.manipe{p};
    singfr_res.name{p}   = depth_res.name{p};
    singfr_res.peak_value{p} = depth_res.peak_value{p};
    %add -1 to channels (multi layer detection)
    try
        channels = [depth_res.channels{p} -1];
    catch
        channels = [depth_res.channels{p}' -1];
    end
    singfr_res.channels{p} = channels;
    
    
    %% init
    %params
    binsize = 10; %20ms
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage
    hemisphere=0;
    
    %load
    load(fullfile(depth_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %LFP channels 
    load(fullfile(depth_res.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(depth_res.channels{p})
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==depth_res.channels{p}(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
    end
    hemi_channel{end+1}='n';
    
    %down
    load(fullfile(depth_res.path{p}, 'DownState.mat'), 'down_PFCx')
    down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;
    %other hemisphere
    load(fullfile(depth_res.path{p},'DownState.mat'), 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
    end
    load(fullfile(depth_res.path{p},'DownState.mat'), 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
    end
    
    %delta
    load(fullfile(depth_res.path{p}, 'DeltaWaves.mat'), 'deltas_PFCx')
    multidelta_tmp = (Start(deltas_PFCx)+End(deltas_PFCx)) / 2;
    
    %MUA
    try
        load(fullfile(depth_res.path{p},'SpikesToAnalyse','PFCx_down.mat'), 'number')
    catch
        load(fullfile(depth_res.path{p},'SpikesToAnalyse','PFCx_Neurons.mat'), 'number')
    end
    NumNeurons=number;
    MUA = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize,'foldername', singfr_res.path{p});
    %hemisphere
    if hemisphere && exist('down_PFCx_r','var')
        load(fullfile(depth_res.path{p},'SpikesToAnalyse','PFCx_r_Neurons.mat'), 'number')
        NumNeurons=number;
        load(fullfile(depth_res.path{p},'SpikeData.mat'), 'S')  
        MUA_r = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize,'foldername', singfr_res.path{p});
    end
    if hemisphere && exist('down_PFCx_l','var')
        load(fullfile(depth_res.path{p},'SpikesToAnalyse','PFCx_l_Neurons.mat'), 'number')
        NumNeurons=number;
        load(fullfile(depth_res.path{p},'SpikeData.mat'), 'S')  
        MUA_l = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize,'foldername', singfr_res.path{p});
    end
    
    %% curves
    
    %down mean curves
    [m,~,tps] = mETAverage(down_tmp, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
    singfr_res.down{p}(:,1) = tps; singfr_res.down{p}(:,2) = m;
    
    
    %loop over pair of channels
    for ch=1:length(singfr_res.channels{p})
        
        if channels(ch)~=-1
            DeltaEpoch = depth_res.deltas{p}{ch};
            deltas_tmp = (Start(DeltaEpoch)+End(DeltaEpoch)) / 2;
        else
            DeltaEpoch = deltas_PFCx;
            deltas_tmp = multidelta_tmp;
        end
        
        %deltas
        if hemisphere && strcmpi(hemi_channel{ch},'r')
            [m,~,tps] = mETAverage(deltas_tmp, Range(MUA_r), full(Data(MUA_r)), binsize_met, nbBins_met);
        elseif hemisphere && strcmpi(hemi_channel{ch},'l')
            [m,~,tps] = mETAverage(deltas_tmp, Range(MUA_l), full(Data(MUA_l)), binsize_met, nbBins_met);
        else
            [m,~,tps] = mETAverage(deltas_tmp, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
        end
        singfr_res.deltas{p}{ch}(:,1) = tps; singfr_res.deltas{p}{ch}(:,2) = m;
        
    end
    

end


%saving data
cd(FolderDeltaDataKJ)
save DeltaSingleChannelAnalysisFiringRate.mat singfr_res binsize_met binsize_met


