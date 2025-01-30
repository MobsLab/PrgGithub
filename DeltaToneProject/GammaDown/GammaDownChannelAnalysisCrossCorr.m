%%GammaDownChannelAnalysisCrossCorr
% 24.04.2018 KJ
%
%   Compare gamma_down detection for each location of PFCx
%   -> here the data are collected  
%
% see
%   DetectGammaDownChannels DeltaSingleChannelAnalysisCrossCorr
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DetectGammaDownChannels.mat'))


for p=1:length(gamma_res.path)
    
    disp(' ')
    disp('****************************************************************')
    disp(gamma_res.path{p})
    
    clearvars -except gammacorr_res gamma_res p 
    
    gammacorr_res.path{p}   = gamma_res.path{p};
    gammacorr_res.manipe{p} = gamma_res.manipe{p};
    gammacorr_res.name{p}   = gamma_res.name{p};
    gammacorr_res.peak_value{p} = gamma_res.peak_value{p};
    gammacorr_res.channels{p}   = gamma_res.channels{p};
    
    
    %% init
    %params
    binsize = 10; %10ms
    nb_bins = 150;
    smoothing = 0;
    
    %load
    load(fullfile(gamma_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    load(fullfile(gamma_res.path{p}, 'DownState.mat'), 'down_PFCx')
    down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;
    start_down = Start(down_PFCx);

    if exist(fullfile(gamma_res.path{p}, 'Ripples.mat'),'file') == 2
        load(fullfile(gamma_res.path{p}, 'Ripples.mat'), 'Ripples')
        ripples_tmp = Ripples(:,2) * 10; 
        [corr_down_rip, t1] = CrossCorr(down_tmp, ripples_tmp, binsize, nb_bins);
        [corr_rip_down, t2] = CrossCorr(ripples_tmp, down_tmp, binsize, nb_bins);
        gammacorr_res.down_rip.x{p} = t1;
        gammacorr_res.down_rip.y{p} = Smooth(corr_down_rip,smoothing);
        gammacorr_res.rip_down.x{p} = t2;
        gammacorr_res.rip_down.y{p} = Smooth(corr_rip_down,smoothing);
        
        gammacorr_res.rip_down.nb{p} = length(ripples_tmp);
        gammacorr_res.down_rip.nb{p} = length(down_tmp);
    end
        
    
    %loop over pair of channels
    for i=1:length(gammacorr_res.channels{p})
        
        GammaDown = gamma_res.down{p}{i};
        gamma_tmp = (Start(GammaDown)+End(GammaDown)) / 2;
        start_gamma = Start(GammaDown);
        
        %% delta down
        [corr_down_gamma, t1] = CrossCorr(start_down, start_gamma, binsize, nb_bins);
        [corr_gamma_down, t2] = CrossCorr(start_gamma, start_down, binsize, nb_bins);
        
        gammacorr_res.down_gamma.x{p,i} = t1;
        gammacorr_res.down_gamma.y{p,i} = Smooth(corr_down_gamma,smoothing);
        gammacorr_res.gamma_down.x{p,i} = t2;
        gammacorr_res.gamma_down.y{p,i} = Smooth(corr_gamma_down,smoothing); 
        gammacorr_res.gamma_down.nb{p,i} = length(start_gamma);
        
        %% ripples down
        if exist('ripples_tmp','var')
            [corr_gamma_rip, t1] = CrossCorr(gamma_tmp, ripples_tmp, binsize, nb_bins);
            [corr_rip_gamma, t2] = CrossCorr(ripples_tmp, gamma_tmp, binsize, nb_bins);
            gammacorr_res.gamma_rip.x{p,i} = t1;
            gammacorr_res.gamma_rip.y{p,i} = Smooth(corr_gamma_rip,smoothing);
            gammacorr_res.rip_gamma.x{p,i} = t2;
            gammacorr_res.rip_gamma.y{p,i} = Smooth(corr_rip_gamma,smoothing);
        end
        
    end
    

end


%saving data
cd(FolderDeltaDataKJ)
save GammaDownChannelAnalysisCrossCorr.mat gammacorr_res 


