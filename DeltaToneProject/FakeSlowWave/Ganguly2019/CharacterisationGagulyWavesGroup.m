%%CharacterisationGagulyWavesGroup
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
    %down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    
    %other hemisphere
    load('DownState.mat', 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
        st_down_r = Start(down_PFCx_r);
    end
    load('DownState.mat', 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
        st_down_l = Start(down_PFCx_l);
    end
    
    %deltas diff
    load('DeltaWaves.mat', 'deltas_PFCx')
    DeltaDiff = deltas_PFCx;
    st_diff = Start(DeltaDiff);
    center_diff = (Start(DeltaDiff) + End(DeltaDiff))/2;
    
    %other hemisphere
    load('DeltaWaves.mat', 'deltas_PFCx_r')
    if exist('deltas_PFCx_r','var')
        Diff_r = deltas_PFCx_r;
        st_diff_r = Start(Diff_r);
        center_diff_r = (Start(Diff_r) + End(Diff_r))/2;
    end
    load('DeltaWaves.mat', 'deltas_PFCx_l')
    if exist('deltas_PFCx_l','var')
        Diff_l = deltas_PFCx_l;
        st_diff_l = Start(Diff_l);
        center_diff_l = (Start(Diff_l) + End(Diff_l))/2;
    end
    
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
    
    %Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    load(fullfile(ganguly_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
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
    
    %hemisphere
    if hemisphere && exist('down_PFCx_r','var')
        MUA_r = GetMUAneurons('PFCx_r_Neurons.mat', 'binsize',binsize_mua);
    end
    if hemisphere && exist('down_PFCx_l','var')
        MUA_l = GetMUAneurons('PFCx_l_Neurons.mat', 'binsize',binsize_mua);
    end
    
    
    %% LFP meancurves
    for ch=1:length(channels_pfc)
        
        %Down
        if hemisphere
            if strcmpi(hemi_channel{ch},'r')
                down_PFCx_h = down_PFCx_r;
            elseif strcmpi(hemi_channel{ch},'l')
                down_PFCx_h = down_PFCx_l;
            end
            [m,~,tps] = mETAverage(Start(down_PFCx_h), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
            ganguly_res.met_lfp.st_down{p}{ch}(:,1) = tps; ganguly_res.met_lfp.st_down{p}{ch}(:,2) = m;
            
            [m,~,tps] = mETAverage(End(down_PFCx_h), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
            ganguly_res.met_lfp.end_down{p}{ch}(:,1) = tps; ganguly_res.met_lfp.end_down{p}{ch}(:,2) = m;
        else
            [m,~,tps] = mETAverage(Start(down_PFCx), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
            ganguly_res.met_lfp.st_down{p}{ch}(:,1) = tps; ganguly_res.met_lfp.st_down{p}{ch}(:,2) = m;
            
            [m,~,tps] = mETAverage(End(down_PFCx), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
            ganguly_res.met_lfp.end_down{p}{ch}(:,1) = tps; ganguly_res.met_lfp.end_down{p}{ch}(:,2) = m;
        end
        
        %SO
        [m,~,tps] = mETAverage(Start(So_pfc{ch}), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
        ganguly_res.met_lfp.so_down{p}{ch}(:,1) = tps; ganguly_res.met_lfp.so_down{p}{ch}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(So_up{ch}), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
        ganguly_res.met_lfp.so_up{p}{ch}(:,1) = tps; ganguly_res.met_lfp.so_up{p}{ch}(:,2) = m;
        
        %delta
        [m,~,tps] = mETAverage(Start(delta_detect{ch}), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
        ganguly_res.met_lfp.delta_start{p}{ch}(:,1) = tps; ganguly_res.met_lfp.delta_start{p}{ch}(:,2) = m;
        
        [m,~,tps] = mETAverage(Start(delta_up{ch}), Range(PFC{ch}), full(Data(PFC{ch})), binsize_met, nbBins_met);
        ganguly_res.met_lfp.delta_up{p}{ch}(:,1) = tps; ganguly_res.met_lfp.delta_up{p}{ch}(:,2) = m;
        
    end
    
    
    
    %% MUA mean curves for each channel
    if hemisphere %left and right
        %right               
        [m,~,tps] = mETAverage(center_diff_r, Range(MUA_r), full(Data(MUA_r)), binsize_met, nbBins_met);
        ganguly_res.met_mua.diff{p}{1}(:,1) = tps; ganguly_res.met_mua.diff{p}{1}(:,2) = m;
        %left               
        [m,~,tps] = mETAverage(center_diff_l, Range(MUA_l), full(Data(MUA_l)), binsize_met, nbBins_met);
        ganguly_res.met_mua.diff{p}{2}(:,1) = tps; ganguly_res.met_mua.diff{p}{2}(:,2) = m;
        
        for ch=1:length(channels_pfc)
            if strcmpi(hemi_channel{ch},'r')
                MUA_h = MUA_r;
            elseif strcmpi(hemi_channel{ch},'l')
                MUA_h = MUA_l;
            end
            %SO
            [m,~,tps] = mETAverage(center_sodown{ch}, Range(MUA_h), full(Data(MUA_h)), binsize_met, nbBins_met);
            ganguly_res.met_mua.so{p}{ch}(:,1) = tps; ganguly_res.met_mua.so{p}{ch}(:,2) = m;
            %delta ganguly
            [m,~,tps] = mETAverage(center_deltabegin{ch}, Range(MUA_h), full(Data(MUA_h)), binsize_met, nbBins_met);
            ganguly_res.met_mua.deltag{p}{ch}(:,1) = tps; ganguly_res.met_mua.deltag{p}{ch}(:,2) = m;
        end
    
    else
        %diff               
        [m,~,tps] = mETAverage(center_diff, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
        ganguly_res.met_mua.diff{p}{1}(:,1) = tps; ganguly_res.met_mua.diff{p}{1}(:,2) = m;
        for ch=1:length(channels_pfc)
            %SO
            [m,~,tps] = mETAverage(center_sodown{ch}, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
            ganguly_res.met_mua.so{p}{ch}(:,1) = tps; ganguly_res.met_mua.so{p}{ch}(:,2) = m;
            %delta ganguly
            [m,~,tps] = mETAverage(center_deltabegin{ch}, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
            ganguly_res.met_mua.deltag{p}{ch}(:,1) = tps; ganguly_res.met_mua.deltag{p}{ch}(:,2) = m;
        end
    end
    
    
    %% precision, recall, fscore 
    if hemisphere %left and right
        %right                
        [~,~,Istat] = GetIntersectionsEpochs(Diff_r, down_PFCx_r);
        ganguly_res.diff.precision{p}(1) = Istat.precision;
        ganguly_res.diff.recall{p}(1)    = Istat.recall;
        ganguly_res.diff.fscore{p}(1)    = Istat.fscore;
        %left                
        [~,~,Istat] = GetIntersectionsEpochs(Diff_l, down_PFCx_l);
        ganguly_res.diff.precision{p}(2) = Istat.precision;
        ganguly_res.diff.recall{p}(2)    = Istat.recall;
        ganguly_res.diff.fscore{p}(2)    = Istat.fscore;
        
        for ch=1:length(channels_pfc)
            if strcmpi(hemi_channel{ch},'r')
                down_PFCx_h = down_PFCx_r;
            elseif strcmpi(hemi_channel{ch},'l')
                down_PFCx_h = down_PFCx_l;
            end
            %SO
            [~,~,Istat] = GetIntersectionsEpochs(So_down{ch}, down_PFCx_h);
            ganguly_res.so.precision{p}(ch) = Istat.precision;
            ganguly_res.so.recall{p}(ch)    = Istat.recall;
            ganguly_res.so.fscore{p}(ch)    = Istat.fscore;
            %delta ganguly
            [~,~,Istat] = GetIntersectionsEpochs(delta_begin{ch}, down_PFCx_h);
            ganguly_res.deltag.precision{p}(ch) = Istat.precision;
            ganguly_res.deltag.recall{p}(ch)    = Istat.recall;
            ganguly_res.deltag.fscore{p}(ch)    = Istat.fscore;
        end
        
    else
        [~,~,Istat] = GetIntersectionsEpochs(DeltaDiff, down_PFCx);
        ganguly_res.diff.precision{p} = Istat.precision;
        ganguly_res.diff.recall{p}    = Istat.recall;
        ganguly_res.diff.fscore{p}    = Istat.fscore;
        
        for ch=1:length(channels_pfc)
            %SO
            [~,~,Istat] = GetIntersectionsEpochs(So_down{ch}, down_PFCx);
            ganguly_res.so.precision{p}(ch) = Istat.precision;
            ganguly_res.so.recall{p}(ch)    = Istat.recall;
            ganguly_res.so.fscore{p}(ch)    = Istat.fscore;
            %delta ganguly
            [~,~,Istat] = GetIntersectionsEpochs(delta_begin{ch}, down_PFCx);
            ganguly_res.deltag.precision{p}(ch) = Istat.precision;
            ganguly_res.deltag.recall{p}(ch)    = Istat.recall;
            ganguly_res.deltag.fscore{p}(ch)    = Istat.fscore;
            
        end
    end
    
    
    %% ripples during up
    for ch=1:length(channels_pfc)
        
        
        
    end
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save CharacterisationGagulyWavesGroup.mat ganguly_res  



