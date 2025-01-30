%%RipplesDuringGangulyDelta
% 22.11.2019 KJ
%
%   
%
% see
%   CharacterisationDiffDownStates 
%
%



Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p ganguly_res
    
    ganguly_res.path{p}   = Dir.path{p};
    ganguly_res.manipe{p} = Dir.manipe{p};
    ganguly_res.name{p}   = Dir.name{p};
    ganguly_res.date{p}   = Dir.date{p};
    
    
    %% params
    binsize_mua = 10;
    hemisphere = 0;
    binsize_met = 5; %for mETAverage  
    nbBins_met = 240; %for mETAverage 
    
    
    %% load events
    
    %Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    load(fullfile(ganguly_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
       
    %down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);

    
    %Ganguly waves
    load('GangulyWaves.mat','So_pfc','delta_detect','So_up','delta_up','channels_pfc') 
    for ch=1:length(channels_pfc)
        So_down{ch} = CleanUpEpoch(So_pfc{ch} - So_up{ch});
        delta_begin{ch} = CleanUpEpoch(delta_detect{ch} - delta_up{ch});
        
        center_sodown{ch} = (Start(So_down{ch}) + End(So_down{ch}))/2;
        center_deltabegin{ch} = (Start(delta_begin{ch}) + End(delta_begin{ch}))/2;
    end
   
    %ripples
    [tRipples, RipplesEpoch] = GetRipples;
    
    
    %% load
    
    
    
    %clusters & hemisphere
    hemi_channel = cell(0);
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(channels_pfc)
        ganguly_res.clusters{p}(ch) = clusters(channels==channels_pfc(ch));
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels_pfc(ch));
        hemi_channel{ch} = char(lower(hemi_channel{ch}));
        hemi_channel{ch} = hemi_channel{ch}(1);
    end
    clusters = ganguly_res.clusters{p};
    ganguly_res.channels{p} = channels_pfc;
    
    %LFP
    for ch=1:length(channels_pfc)
        load(['LFPData/LFP' num2str(channels_pfc(ch)) '.mat'])
        PFC{ch} = LFP;
    end
    
    %MUA
    try
        load(fullfile('SpikesToAnalyse','PFCx_down.mat'), 'number')
    catch
        load(fullfile('SpikesToAnalyse','PFCx_Neurons.mat'), 'number')
    end
    MUA = GetMUAneurons(number, 'binsize',binsize_mua);
    
    %hemisphdere
    if hemisphere && exist('down_PFCx_r','var')
        MUA_r = GetMUAneurons('PFCx_r_Neurons.mat', 'binsize',binsize_mua);
    end
    if hemisphere && exist('down_PFCx_l','var')
        MUA_l = GetMUAneurons('PFCx_l_Neurons.mat', 'binsize',binsize_mua);
    end
    
    
    %% LFP meancurves
    for ch=1:length(channels_pfc)
        
        %SO
        [m,~,tps] = mETAverage(Start(So_pfc{ch}), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
        ganguly_res.met_lfp.so_down{p}{ch}(:,1) = tps; ganguly_res.met_lfp.so_down{p}{ch}(:,2) = m;
        
        
    end
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save RipplesDuringGangulyDelta.mat ganguly_res  

