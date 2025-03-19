%%DeltaSingleChannelAnalysisCrossCorr
% 12.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   -> here the data are collected  
%
% see
%   DetectDeltaDepthSingleChannel DeltaSingleChannelAnalysis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DetectDeltaDepthSingleChannel.mat'))


for p=1:8%length(depth_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(depth_res.path{p})
    
    clearvars -except singcor_res depth_res p 
    
    singcor_res.path{p}   = depth_res.path{p};
    singcor_res.manipe{p} = depth_res.manipe{p};
    singcor_res.name{p}   = depth_res.name{p};
    singcor_res.peak_value{p} = depth_res.peak_value{p};
    %add -1 to channels (multi layer detection)
    try
        channels = [depth_res.channels{p} -1];
    catch
        channels = [depth_res.channels{p}' -1];
    end
    singcor_res.channels{p} = channels;
    
    
    %% init
    %params
    binsize = 10; %10ms
    nb_bins = 150;
    smoothing = 0;
    hemisphere = 0;
    
    %% Load
    load(fullfile(depth_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %Substages
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring('foldername', depth_res.path{p});
    NREM = NREM - TotalNoiseEpoch;
    
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
        down_tmp_r = (Start(down_PFCx_r)+End(down_PFCx_r)) / 2;
    end
    load(fullfile(depth_res.path{p},'DownState.mat'), 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
        down_tmp_l = (Start(down_PFCx_l)+End(down_PFCx_l)) / 2;
    end
    %deltas
    load(fullfile(depth_res.path{p}, 'DeltaWaves.mat'), 'deltas_PFCx')
    multidelta_tmp = (Start(deltas_PFCx)+End(deltas_PFCx)) / 2;
    
    %ripples
    if exist(fullfile(depth_res.path{p}, 'Ripples.mat'),'file') == 2
        [tRipples, ~] = GetRipples('foldername', depth_res.path{p});
        ripples_tmp = Range(Restrict(tRipples, NREM));

        [corr_down_rip, t1] = CrossCorr(down_tmp, ripples_tmp, binsize, nb_bins);
        [corr_rip_down, t2] = CrossCorr(ripples_tmp, down_tmp, binsize, nb_bins);
        singcor_res.down_rip.x{p} = t1;
        singcor_res.down_rip.y{p} = Smooth(corr_down_rip,smoothing);
        singcor_res.rip_down.x{p} = t2;
        singcor_res.rip_down.y{p} = Smooth(corr_rip_down,smoothing);
        
        singcor_res.rip_down.nb{p} = length(ripples_tmp);
        singcor_res.down_rip.nb{p} = length(down_tmp);
    end
    
    
    %% Loop over pair of channels
    for i=1:length(singcor_res.channels{p})
        
        if channels(i)~=-1
            DeltaEpoch = depth_res.deltas{p}{i};
            deltas_tmp = (Start(DeltaEpoch)+End(DeltaEpoch)) / 2;
        else
            deltas_tmp = multidelta_tmp;
        end
        
        %% delta down
        if hemisphere && strcmpi(hemi_channel{ch},'r')
            [corr_down_delta, t1] = CrossCorr(down_tmp_r, deltas_tmp, binsize, nb_bins);
            [corr_delta_down, t2] = CrossCorr(deltas_tmp, down_tmp_r, binsize, nb_bins);
        elseif hemisphere && strcmpi(hemi_channel{ch},'l')
            [corr_down_delta, t1] = CrossCorr(down_tmp_l, deltas_tmp, binsize, nb_bins);
            [corr_delta_down, t2] = CrossCorr(deltas_tmp, down_tmp_l, binsize, nb_bins);
        else
            [corr_down_delta, t1] = CrossCorr(down_tmp, deltas_tmp, binsize, nb_bins);
            [corr_delta_down, t2] = CrossCorr(deltas_tmp, down_tmp, binsize, nb_bins);
        end
        
        
        
        singcor_res.down_delta.x{p,i} = t1;
        singcor_res.down_delta.y{p,i} = Smooth(corr_down_delta,smoothing);
        singcor_res.delta_down.x{p,i} = t2;
        singcor_res.delta_down.y{p,i} = Smooth(corr_delta_down,smoothing); 
        singcor_res.delta_down.nb{p,i} = length(deltas_tmp);
        
        %% ripples down
        if exist('ripples_tmp','var')
            [corr_delta_rip, t1] = CrossCorr(deltas_tmp, ripples_tmp, binsize, nb_bins);
            [corr_rip_delta, t2] = CrossCorr(ripples_tmp, deltas_tmp, binsize, nb_bins);
            singcor_res.delta_rip.x{p,i} = t1;
            singcor_res.delta_rip.y{p,i} = Smooth(corr_delta_rip,smoothing);
            singcor_res.rip_delta.x{p,i} = t2;
            singcor_res.rip_delta.y{p,i} = Smooth(corr_rip_delta,smoothing);
        end
        
    end
    

end


%saving data
cd(FolderDeltaDataKJ)
save DeltaSingleChannelAnalysisCrossCorr.mat singcor_res 


