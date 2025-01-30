%%CharacterisationDeltaDownStates
% 13.09.2019 KJ
%
%   
%
% see
%   LFPlayerInfluenceOnDetection LFPonDownStatesLayer DeltaSingleChannelAnalysis
%   LayerElectrodeDetectionMetrics FigureCharacterisationDeltaDownStates


% clear
Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p layer_res
    
    layer_res.path{p}   = Dir.path{p};
    layer_res.manipe{p} = Dir.manipe{p};
    layer_res.name{p}   = Dir.name{p};
    layer_res.date{p}   = Dir.date{p};
    
    
    %% params
    durRange          = [125 175] * 10; 
    binsize_met       = 5; %for mETAverage  
    nbBins_met        = 240; %for mETAverage 
    hemisphere        = 0;
    marginsup         = 0.1e4;  
    
    binsize_cc = 10; %10ms
    nb_binscc = 100;
    binsize_mua = 10;
        
    
    %% load data

    % Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    load(fullfile(layer_res.path{p}, 'IdFigureData2.mat'), 'night_duration')
    
    %LFP load
    Signals = cell(0); hemi_channel = cell(0);
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = char(lower(hemi_channel{ch}));
        hemi_channel{ch} = hemi_channel{ch}(1);
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end
    
    layer_res.channels{p}     = channels;
    layer_res.hemi_channel{p} = hemi_channel;
    
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
    layer_res.ecogs{p} = unique(ecogs);
    
    
    %Delta detection
    for ch=1:length(channels)
        name_var = ['delta_ch_' num2str(channels(ch))];
        load('DeltaWavesChannels.mat', name_var)
        eval(['deltas = ' name_var ';'])
        %Restrict    
        deltas_chan{ch}  = and(deltas, NREM);
        st_deltachan{ch} = Start(deltas_chan{ch});
        center_deltachan{ch} = (Start(deltas_chan{ch}) + End(deltas_chan{ch}) ) /2;
    end

    
    %% load events
    %down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    center_down = (End(down_PFCx) + Start(down_PFCx))/2;
    end_down = End(down_PFCx);
    down_durations = End(down_PFCx) - Start(down_PFCx);
    selected_down = st_down(down_durations>durRange(1) & down_durations<durRange(2));
    
    %other hemisphere
    load('DownState.mat', 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
        st_down_r = Start(down_PFCx_r);
        center_down_r = (End(down_PFCx_r) + Start(down_PFCx_r))/2;
        dur = End(down_PFCx_r) - Start(down_PFCx_r);
        selected_down_r = st_down_r(dur>durRange(1) & dur<durRange(2));
    end
    load('DownState.mat', 'down_PFCx_l')
    if exist('down_PFCx_l','var')
        hemisphere=1;
        st_down_l = Start(down_PFCx_l);
        center_down_l = (End(down_PFCx_l) + Start(down_PFCx_l))/2;
        dur = End(down_PFCx_l) - Start(down_PFCx_l);
        selected_down_l = st_down_l(dur>durRange(1) & dur<durRange(2));
    end
    
    
    %deltas
    load('DeltaWaves.mat', 'deltas_PFCx')
    st_delta = Start(deltas_PFCx);
    dur = End(deltas_PFCx) - Start(deltas_PFCx);
    selected_delta = st_delta(dur>durRange(1) & dur<durRange(2));
    center_delta = (End(deltas_PFCx) + Start(deltas_PFCx)) / 2;
    
    %other hemisphere
    load('DeltaWaves.mat', 'deltas_PFCx_r')
    if exist('deltas_PFCx_r','var')
        Delta_r = deltas_PFCx_r;
        st_delta_r = Start(Delta_r);
        center_delta_r = (End(Delta_r) + Start(Delta_r)) / 2;
        delta_durations_r = End(Delta_r) - Start(Delta_r);
        selected_delta_r = st_delta_r(delta_durations_r>durRange(1) & delta_durations_r<durRange(2));
    end
    load('DeltaWaves.mat', 'deltas_PFCx_l')
    if exist('deltas_PFCx_l','var')
        Delta_l = deltas_PFCx_l;
        st_delta_l = Start(Delta_l);
        center_delta_l = (End(Delta_l) + Start(Delta_l)) / 2;
        delta_durations_l = End(Delta_l) - Start(Delta_l);
        selected_delta_l = st_delta_l(delta_durations_l>durRange(1) & delta_durations_l<durRange(2));
    end
    
    
    %% MUA
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
    
    
    %% MEAN CURVES on Down   
    for ch=1:length(channels)
        %event for the hemisphere
        if hemisphere && strcmpi(hemi_channel{ch},'r') %right
            seldown = selected_down_r;
            seldelta = selected_delta_r;
        elseif hemisphere && strcmpi(hemi_channel{ch},'l') %left
            seldown = selected_down_l;
            seldelta = selected_delta_l;
        else 
            seldown = selected_down;
            seldelta = selected_delta;
        end
        
        %down
        [m,~,tps] = mETAverage(seldown, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
        meandown{ch}(:,1) = tps; meandown{ch}(:,2) = m;
        
        % negative of positive response
        x = tps; y = m;
        if sum(y(x>0 & x<=150))>0 
            negativepeak(ch) = 0;
        else
            negativepeak(ch) = 1;
        end
    end
    
    layer_res.down.meandown{p} = meandown;
    layer_res.down.nb{p}       = sum(selected_down);
    
    
    %% Mean MUA on deltas
    if hemisphere %left and right
        %right               
        [m,~,tps] = mETAverage(center_delta_r, Range(MUA_r), full(Data(MUA_r)), binsize_met, nbBins_met);
        layer_res.met_mua.multi{p}{1}(:,1) = tps; layer_res.met_mua.multi{p}{1}(:,2) = m;
        %left               
        [m,~,tps] = mETAverage(center_delta_l, Range(MUA_l), full(Data(MUA_l)), binsize_met, nbBins_met);
        layer_res.met_mua.multi{p}{2}(:,1) = tps; layer_res.met_mua.multi{p}{2}(:,2) = m;
        
        for ch=1:length(layer_res.channels{p})
            if strcmpi(hemi_channel{ch},'r')
                MUA_h = MUA_r;
            elseif strcmpi(hemi_channel{ch},'l')
                MUA_h = MUA_l;
            end
            [m,~,tps] = mETAverage(center_deltachan{ch}, Range(MUA_h), full(Data(MUA_h)), binsize_met, nbBins_met);
            layer_res.met_mua.single{p}{ch}(:,1) = tps; layer_res.met_mua.single{p}{ch}(:,2) = m;
        end
    
    else
        %diff               
        [m,~,tps] = mETAverage(center_delta, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
        layer_res.met_mua.multi{p}{1}(:,1) = tps; layer_res.met_mua.multi{p}{1}(:,2) = m;
        for ch=1:length(layer_res.channels{p})
            [m,~,tps] = mETAverage(center_deltachan{ch}, Range(MUA), full(Data(MUA)), binsize_met, nbBins_met);
            layer_res.met_mua.single{p}{ch}(:,1) = tps; layer_res.met_mua.single{p}{ch}(:,2) = m;
        end
        
    end
    
    
    %% Cross-corr
    if hemisphere %left and right
        %right 
        [layer_res.cc.multi{p}{1}(:,2), layer_res.cc.multi{p}{1}(:,1)] = CrossCorr(center_down_r, center_delta_r, binsize_cc, nb_binscc);
        %left 
        [layer_res.cc.multi{p}{2}(:,2), layer_res.cc.multi{p}{2}(:,1)] = CrossCorr(center_down_l, center_delta_l, binsize_cc, nb_binscc);
        for ch=1:length(layer_res.channels{p})
            if strcmpi(hemi_channel{ch},'r')
                [layer_res.cc.single{p}{ch}(:,2), layer_res.cc.single{p}{ch}(:,1)] = CrossCorr(center_down_r, center_deltachan{ch}, binsize_cc, nb_binscc);
            elseif strcmpi(hemi_channel{ch},'l')
                [layer_res.cc.single{p}{ch}(:,2), layer_res.cc.single{p}{ch}(:,1)] = CrossCorr(center_down_l, center_deltachan{ch}, binsize_cc, nb_binscc);
            end
        end
    else
        %diff
        [layer_res.cc.multi{p}{1}(:,2), layer_res.cc.multi{p}{1}(:,1)] = CrossCorr(center_down, center_delta, binsize_cc, nb_binscc);
        for ch=1:length(layer_res.channels{p})
            [layer_res.cc.single{p}{ch}(:,2), layer_res.cc.single{p}{ch}(:,1)] = CrossCorr(center_down, center_deltachan{ch}, binsize_cc, nb_binscc);
        end
    end
    
    
    %% Quantification intersection delta waves and down states
    if hemisphere %left and right
        %right                
        [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx_r, down_PFCx_r);
        layer_res.multi.precision{p}(1) = Istat.precision;
        layer_res.multi.recall{p}(1)    = Istat.recall;
        layer_res.multi.fscore{p}(1)    = Istat.fscore;
        %left                
        [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx_l, down_PFCx_l);
        layer_res.multi.precision{p}(2) = Istat.precision;
        layer_res.multi.recall{p}(2)    = Istat.recall;
        layer_res.multi.fscore{p}(2)    = Istat.fscore;
        
        for ch=1:length(layer_res.channels{p})
            if strcmpi(hemi_channel{ch},'r')
                down_PFCx_h = down_PFCx_r;
            elseif strcmpi(hemi_channel{ch},'l')
                down_PFCx_h = down_PFCx_l;
            end
            
            if negativepeak(ch)
                larger_deltas = intervalSet(Start(deltas_chan{ch})-marginsup,End(deltas_chan{ch}));
                [~,~,Istat] = GetIntersectionsEpochs(larger_deltas, down_PFCx_h);
            else
                [~,~,Istat] = GetIntersectionsEpochs(deltas_chan{ch}, down_PFCx_h);
            end
            layer_res.single.precision{p}(ch) = Istat.precision;
            layer_res.single.recall{p}(ch)    = Istat.recall;
            layer_res.single.fscore{p}(ch)    = Istat.fscore;
        end
        
    else
        [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx, down_PFCx);
        layer_res.multi.precision{p} = Istat.precision;
        layer_res.multi.recall{p}    = Istat.recall;
        layer_res.multi.fscore{p}    = Istat.fscore;
        
        for ch=1:length(layer_res.channels{p})
            if negativepeak(ch)
                larger_deltas = intervalSet(Start(deltas_chan{ch})-marginsup,End(deltas_chan{ch}));
                [~,~,Istat] = GetIntersectionsEpochs(larger_deltas, down_PFCx);
            else
                [~,~,Istat] = GetIntersectionsEpochs(deltas_chan{ch}, down_PFCx);
            end
            layer_res.single.precision{p}(ch) = Istat.precision;
            layer_res.single.recall{p}(ch)    = Istat.recall;
            layer_res.single.fscore{p}(ch)    = Istat.fscore;
        end
    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save CharacterisationDeltaDownStates.mat layer_res  




