%%OccurenceRipplesFakeDeltaDownSup
% 16.09.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaDeep OccurenceRipplesFakeDeltaDownSupPlot
% 
% 

clear
Dir = PathForExperimentsFakeSlowWave('hemisup');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    ripples_res.hemisphere{p} = Dir.hemisphere{p};
    
    %params
    binsize_cc = 5; %10ms
    nb_binscc = 400; 


    %% load
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %Ripples  
    [tRipples, ~] = GetRipples;
    
    %PFC channels
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    load('LFPData/InfoLFP.mat', 'InfoLFP')
    if ~isempty(Dir.hemisphere{p})
        channels_pfc = [];
        clusters_pfc = [];
        for ch=1:length(channels)
            hemisphere = lower(InfoLFP.hemisphere{InfoLFP.channel==channels(ch)}(1));
            if strcmpi(hemisphere, Dir.hemisphere{p})
                channels_pfc = [channels_pfc channels(ch)];
                clusters_pfc = [clusters_pfc clusters(ch)];
            end
        end
    else
        channels_pfc = channels;
        clusters_pfc = clusters;
    end
    idx = clusters_pfc<=2;
    channels_pfc = channels_pfc(idx);    
    ripples_res.channels{p} = channels_pfc;
    ripples_res.clusters{p} = clusters_pfc(idx);
    
    %Deltawaves
    if ~isempty(Dir.hemisphere{p})
        load('DeltaWaves.mat', ['deltas_PFCx_' Dir.hemisphere{p}])
        eval(['DeltaDiff = and(deltas_PFCx_' Dir.hemisphere{p} ',NREM);'])
    else
        load('DeltaWaves.mat', 'deltas_PFCx')
        DeltaDiff = deltas_PFCx;
    end
    
    
    %Global downstate
    if ~isempty(Dir.hemisphere{p})
        load('DownState.mat', ['down_PFCx_' Dir.hemisphere{p}])
        eval(['GlobalDown = and(down_PFCx_' Dir.hemisphere{p} ',NREM);'])
    else
        load('DownState.mat', 'down_PFCx')
        GlobalDown = and(down_PFCx,NREM);
    end
    
    %save
    ripples_res.nb.diff{p} = length(Start(DeltaDiff));
    ripples_res.nb.down{p} = length(Start(GlobalDown));
    ripples_res.nb.ripples{p} = length(tRipples);
    
    
    %% cross corr 
    
    %with delta diff
    [ripples_res.diff.global{p}(:,2), ripples_res.diff.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(DeltaDiff), binsize_cc, nb_binscc);
    
    %with down
    [ripples_res.down.global{p}(:,2), ripples_res.down.global{p}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDown), binsize_cc, nb_binscc);
    
    
    %% deltas
     for ch=1:length(channels_pfc)
        
        %% delta waves of channel (signle channel detection)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channels_pfc(ch))])
        eval(['a = delta_ch_' num2str(channels_pfc(ch)) ';'])
        DeltaWavesCh{ch} = a;
        
        %global delta and other delta 1 - for down > 75ms
        [GlobalDelta{ch}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesCh{ch}, GlobalDown);
        OtherDelta{ch} = subset(DeltaWavesCh{ch}, setdiff(1:length(Start(DeltaWavesCh{ch})),idGlobDelta)');
        
        
        ripples_res.nb.delta{p,ch} = length(Start(GlobalDelta{ch}));
        ripples_res.nb.other{p,ch} = length(Start(OtherDelta{ch}));
        
        %cross corr with deltas
        [ripples_res.delta.global{p,ch}(:,2), ripples_res.delta.global{p,ch}(:,1)] = CrossCorr(Range(tRipples), Start(GlobalDelta{ch}), binsize_cc, nb_binscc);        
        [ripples_res.delta.other{p,ch}(:,2), ripples_res.delta.other{p,ch}(:,1)] = CrossCorr(Range(tRipples), Start(OtherDelta{ch}), binsize_cc, nb_binscc);
        
        %Cross-corr diff /real
        [ripples_res.diff_real{p,ch}(:,2), ripples_res.diff_real{p,ch}(:,1)] = CrossCorr(Start(DeltaDiff), Start(GlobalDelta{ch}), binsize_cc, nb_binscc);
        [ripples_res.real_diff{p,ch}(:,2), ripples_res.real_diff{p,ch}(:,1)] = CrossCorr(Start(GlobalDelta{ch}), Start(DeltaDiff), binsize_cc, nb_binscc);
        
     end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesFakeDeltaDownSup.mat ripples_res

