%%LFPonDownStatesLayerGamma
%
% 24.04.2018 KJ
%
% see
%   LFPonDownStatesLayer 
%


clear
Dir = PathForExperimentsBasalSleepSpike;
load(fullfile(FolderDeltaDataKJ, 'DetectGammaDownChannels.mat'))



%% 
for p=1:length(Dir.path)  
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p layergam_res Substages gamma_res
    
    layergam_res.path{p}   = Dir.path{p};
    layergam_res.manipe{p} = Dir.manipe{p};
    layergam_res.name{p}   = Dir.name{p};
    layergam_res.date{p}   = Dir.date{p};
    
    
    %% params
    durations1   = [50 100] * 10; %in ts, for mean curve on down state
    durations2   = [100 200] * 10; 
    durations3   = [200 300] * 10;
    durations4   = [300 400] * 10;
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage 
    preripples_window = 5000; %500ms
    hemisphere = 0;
    
    
    %% load data
    
    %Substages
    load('SleepSubstages.mat','Epoch')
    for sub=1:5
        Substages{p,sub} = Epoch{sub};
    end

    %LFP 
    Signals = cell(0); hemi_channel = cell(0);
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))

    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = lower(hemi_channel{ch}(1));
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end
    
    
    %% Amplitude on down/delta   
    for i=1:length(channels)  
        
        %deltas of channel
        GammaDown = gamma_res.down{p}{i};
        start_gamma_ch = Start(GammaDown);
        gamma_durations = End(GammaDown) - Start(GammaDown);
        selected_gamma1 = start_gamma_ch(gamma_durations>durations1(1) & gamma_durations<durations1(2));
        selected_gamma2 = start_gamma_ch(gamma_durations>durations2(1) & gamma_durations<durations2(2));
        selected_gamma3 = start_gamma_ch(gamma_durations>durations3(1) & gamma_durations<durations3(2));
        selected_gamma4 = start_gamma_ch(gamma_durations>durations4(1) & gamma_durations<durations4(2));
        
        [m,~,tps] = mETAverage(selected_gamma1, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meangamma1{i}(:,1) = tps; meangamma1{i}(:,2) = m;
        [m,~,tps] = mETAverage(selected_gamma2, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meangamma2{i}(:,1) = tps; meangamma2{i}(:,2) = m;
        [m,~,tps] = mETAverage(selected_gamma3, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meangamma3{i}(:,1) = tps; meangamma3{i}(:,2) = m;
        [m,~,tps] = mETAverage(selected_gamma4, Range(Signals{i}), Data(Signals{i}), binsize_met, nbBins_met);
        meangamma4{i}(:,1) = tps; meangamma4{i}(:,2) = m;
        
    end
    
    
    %% save
    
    layergam_res.meangamma1{p} = meangamma1;
    layergam_res.meangamma2{p} = meangamma2;
    layergam_res.meangamma3{p} = meangamma3;
    layergam_res.meangamma4{p} = meangamma4;
    
    layergam_res.channels{p} = channels;
    
end

%saving data
cd(FolderDeltaDataKJ)
save LFPonDownStatesLayerGamma.mat layergam_res Substages durations1 durations2 durations3 durations4 binsize_met nbBins_met


    
    