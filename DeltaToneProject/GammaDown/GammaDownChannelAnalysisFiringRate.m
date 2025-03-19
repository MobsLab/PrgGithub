%%GammaDownChannelAnalysisFiringRate
% 24.04.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   -> here the data are collected  
%
% see
%   DeltaSingleChannelAnalysisFiringRate DetectGammaDownChannels AnalysisLayerGammaDetectionDown
%


% load
load(fullfile(FolderDeltaDataKJ, 'DetectGammaDownChannels.mat'))


for p=1:length(gamma_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(gamma_res.path{p})
    
    clearvars -except gammafr_res gamma_res p 
    
    gammafr_res.path{p}   = gamma_res.path{p};
    gammafr_res.manipe{p} = gamma_res.manipe{p};
    gammafr_res.name{p}   = gamma_res.name{p};
    gammafr_res.peak_value{p} = gamma_res.peak_value{p};
    gammafr_res.channels{p} = gamma_res.channels{p};
    
    
    %% init
    %params
    binsize = 10; %20ms
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage
    hemisphere=0;
    
    %load
    load(fullfile(gamma_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %LFP channels 
    load(fullfile(gamma_res.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(gamma_res.channels{p})
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==gamma_res.channels{p}(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
    end
    hemi_channel{end+1}='l';
    
    %down
    load(fullfile(gamma_res.path{p}, 'DownState.mat'), 'down_PFCx')
    down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;
    %other hemisphere
    load(fullfile(gamma_res.path{p},'DownState.mat'), 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
    end
    
    %MUA
    try
        load(fullfile(gamma_res.path{p},'SpikesToAnalyse','PFCx_down.mat'), 'number')
    catch
        load(fullfile(gamma_res.path{p},'SpikesToAnalyse','PFCx_Neurons.mat'), 'number')
    end
    NumNeurons=number;
    MUA = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize,'foldername', gamma_res.path{p});

    %hemisphere
    if hemisphere
        load(fullfile(gamma_res.path{p},'SpikesToAnalyse','PFCx_r_Neurons.mat'), 'number')
        NumNeurons=number;
        MUA_r = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize,'foldername', gamma_res.path{p});
    end
    
    
    %% curves
    
    %down mean curves
    [m,~,tps] = mETAverage(down_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    gammafr_res.down{p}(:,1) = tps; gammafr_res.down{p}(:,2) = m;
    
    
    %loop over pair of channels
    for ch=1:length(gammafr_res.channels{p})
        
        GammaDown = gamma_res.down{p}{ch};
        gamma_tmp = (Start(GammaDown)+End(GammaDown))/2;
        
        %deltas
        if hemisphere && strcmpi(hemi_channel{ch},'r')
            [m,~,tps] = mETAverage(gamma_tmp, Range(MUA_r), Data(MUA_r), binsize_met, nbBins_met);
        else
            [m,~,tps] = mETAverage(gamma_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        end
        gammafr_res.gamma{p}{ch}(:,1) = tps; gammafr_res.gamma{p}{ch}(:,2) = m;
        
    end
    

end


%saving data
cd(FolderDeltaDataKJ)
save GammaDownChannelAnalysisFiringRate.mat gammafr_res binsize_met binsize_met


