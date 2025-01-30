%%QuantifFakeDetectionDeltaDurationDown
% 13.09.2019 KJ
%
%   
%
% see
%   CharacterisationDeltaDownStates
%   QuantifFakeDetectionDeltaDurationDownPlot
%


clear
Dir = PathForExperimentsBasalSleepSpike;

%% single channels
for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p quantif_res
    
    quantif_res.path{p}   = Dir.path{p};
    quantif_res.manipe{p} = Dir.manipe{p};
    quantif_res.name{p}   = Dir.name{p};
    quantif_res.date{p}   = Dir.date{p};
    
    
    %params
    binsize_mua = 10;
    duration_range = (40:20:300)*10;
    maxDurationDown = 800;
    hemisphere        = 0;
    marginsup         = 0.1e4;  
    
    
    %% load
    
    % Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    
    %cluster selection
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    
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
    ecogs = unique(ecogs);
    quantif_res.ecogs{p} = unique(ecogs);
    clusters(ismember(channels,ecogs))=1;
    
    %LFP load
    hemi_channel = cell(0);
    load(fullfile(Dir.path{p}, 'LFPData', 'InfoLFP.mat'))
    for ch=1:length(channels)
        hemi_channel{ch} = InfoLFP.hemisphere(InfoLFP.channel==channels(ch));
        hemi_channel{ch} = char(lower(hemi_channel{ch}));
        hemi_channel{ch} = hemi_channel{ch}(1);
        if clusters(ch)<=2
           negativepeak(ch)=1;
        else
            negativepeak(ch)=0;
        end
    end
    
    quantif_res.channels{p}     = channels;
    quantif_res.clusters{p}     = clusters;
    quantif_res.hemi_channel{p} = hemi_channel;
    
    
    %hemisphere
    load('DownState.mat', 'down_PFCx_r')
    if exist('down_PFCx_r','var')
        hemisphere=1;
    end
    
    %% load deltas
    
    %deltas
    load('DeltaWaves.mat', 'deltas_PFCx')
    %other hemisphere
    if hemisphere
        load('DeltaWaves.mat', 'deltas_PFCx_r')
        Delta_r = deltas_PFCx_r;
        load('DeltaWaves.mat', 'deltas_PFCx_l')
        Delta_l = deltas_PFCx_l;
    end
    
    %Delta detection
    for ch=1:length(channels)
        name_var = ['delta_ch_' num2str(channels(ch))];
        load('DeltaWavesChannels.mat', name_var)
        eval(['deltas = ' name_var ';'])
        %Restrict    
        deltas_chan{ch}  = and(deltas, NREM);
    end

    
    %% MUA and Down
    if hemisphere
        %Right
        MUA_r = GetMuaNeurons_KJ('PFCx_r', 'binsize',binsize_mua);
        AllDown_r = FindDownKJ(MUA_r, 'low_thresh', 0.5, 'minDuration', 20, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown_r = and(AllDown_r,NREM);
        
        %Left
        MUA_l = GetMuaNeurons_KJ('PFCx_l', 'binsize',binsize_mua);
        AllDown_l = FindDownKJ(MUA_l, 'low_thresh', 0.5, 'minDuration', 20, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown_l = and(AllDown_l,NREM);
        
    else
        MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
        AllDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', 20, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
        AllDown = and(AllDown,NREM);
    end
    
    
    %% Quantification intersection delta waves and down states
    for d=1:length(duration_range)
        if hemisphere %left and right
            %right                
            down_PFCx_r = dropShortIntervals(AllDown_r, duration_range(d));
            [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx_r, down_PFCx_r);
            quantif_res.multi.precision{p}(d,1) = Istat.precision;
            quantif_res.multi.recall{p}(d,1)    = Istat.recall;
            quantif_res.multi.fscore{p}(d,1)    = Istat.fscore;
            %left      
            down_PFCx_l = dropShortIntervals(AllDown_l, duration_range(d));
            [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx_l, down_PFCx_l);
            quantif_res.multi.precision{p}(d,2) = Istat.precision;
            quantif_res.multi.recall{p}(d,2)    = Istat.recall;
            quantif_res.multi.fscore{p}(d,2)    = Istat.fscore;

            for ch=1:length(quantif_res.channels{p})
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
                quantif_res.single.precision{p}(d,ch) = Istat.precision;
                quantif_res.single.recall{p}(d,ch)    = Istat.recall;
                quantif_res.single.fscore{p}(d,ch)    = Istat.fscore;
            end

        else
            down_PFCx = dropShortIntervals(AllDown, duration_range(d));
            [~,~,Istat] = GetIntersectionsEpochs(deltas_PFCx, down_PFCx);
            quantif_res.multi.precision{p}(d,1) = Istat.precision;
            quantif_res.multi.recall{p}(d,1)    = Istat.recall;
            quantif_res.multi.fscore{p}(d,1)    = Istat.fscore;

            for ch=1:length(quantif_res.channels{p})
                if negativepeak(ch)
                    larger_deltas = intervalSet(Start(deltas_chan{ch})-marginsup,End(deltas_chan{ch}));
                    [~,~,Istat] = GetIntersectionsEpochs(larger_deltas, down_PFCx);
                else
                    [~,~,Istat] = GetIntersectionsEpochs(deltas_chan{ch}, down_PFCx);
                end
                quantif_res.single.precision{p}(d,ch) = Istat.precision;
                quantif_res.single.recall{p}(d,ch)    = Istat.recall;
                quantif_res.single.fscore{p}(d,ch)    = Istat.fscore;
            end
        end
    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save QuantifFakeDetectionDeltaDurationDown.mat quantif_res duration_range

