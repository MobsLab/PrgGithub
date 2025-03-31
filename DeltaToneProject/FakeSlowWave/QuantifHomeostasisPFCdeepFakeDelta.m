%%QuantifHomeostasisPFCdeepFakeDelta
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    ParcoursHomeostasisSleepCycle QuantifHomeostasisPFCdeepFakeDeltaPlot
%    QuantifHomeostasisPFCdeepFakeDeltaPlot2
%    QuantifHomeostasisPFCdeepFakeDeltaPlotAll
%    


clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    homeo_res.path{p}   = Dir.path{p};
    homeo_res.manipe{p} = Dir.manipe{p};
    homeo_res.name{p}   = Dir.name{p};
    homeo_res.date{p}   = Dir.date{p};
    homeo_res.hemisphere{p}   = Dir.hemisphere{p};
    
    %params
    binsize_mua = 5*10; %5ms
    minDurationDown1 = 75;
    maxDurationDown = 800; %800ms
    windowsize_density = 60e4; %60s  


    %% load
    
    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    homeo_res.nrem{p} = NREM;

    new_st = Data(Restrict(NewtsdZT, ts(Start(NREM))));
    new_end = Data(Restrict(NewtsdZT, ts(End(NREM))));
    homeo_res.nremzt{p} = intervalSet(new_st, new_end);
    
    
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
    idx = clusters_pfc>=4;
    channels_pfc = channels_pfc(idx);    
    homeo_res.channels{p} = channels_pfc;
    homeo_res.clusters{p} = clusters_pfc(idx);
    
    %deltawaves
    load('DeltaWaves.mat', 'deltas_PFCx')
    DeltaDiff = deltas_PFCx;

    %Spikes
    load('SpikeData.mat', 'S');
    if ~isempty(Dir.hemisphere{p})
        load(['SpikesToAnalyse/PFCx_' Dir.hemisphere{p} '_Neurons.mat'])
    else
        load('SpikesToAnalyse/PFCx_Neurons.mat')
    end
    all_neurons = number;
    if ~isa(S,'tsdArray')
        S = tsdArray(S);
    end
    
    
    %% Global downstate
    MUA = MakeQfromS(S(all_neurons), binsize_mua);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown1, 'maxduration',maxDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    GlobalDown = and(GlobalDown,NREM);
    
    %save
    homeo_res.nb.down{p} = length(Start(GlobalDown));
    homeo_res.nb.allneurons{p} = length(all_neurons);
    
    
    %% delta diff homeostasis
    [~, ~, Hstat] = DensityOccupation_KJ(DeltaDiff, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo_res.diff.absolut.Hstat{p} = Hstat;
    %rescaled
    [~, ~, Hstat] = DensityOccupation_KJ(DeltaDiff, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    homeo_res.diff.rescaled.Hstat{p} = Hstat;

    
    %% global down 1 homeostasis
    [~, ~, Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo_res.down.absolut.Hstat{p} = Hstat;
    %rescaled
    [~, ~, Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    homeo_res.down.rescaled.Hstat{p} = Hstat;
    
    
    
    %% single channel delta waves 
    for ch=1:length(channels_pfc)
        
        %% delta waves of channel (signle channel detection)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channels_pfc(ch))])
        eval(['all_delta_ch = delta_ch_' num2str(channels_pfc(ch)) ';'])
        DeltaWavesCh{ch} = dropShortIntervals(and(all_delta_ch,NREM),75);
        
        %global delta and other delta 1 - for down > 75ms
        [GlobalDelta{ch}, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesCh{ch}, GlobalDown);
        OtherDelta{ch} = subset(DeltaWavesCh{ch}, setdiff(1:length(Start(DeltaWavesCh{ch})),idGlobDelta)');
    
        
        %% Homeostasie
        
        %global delta 1
        [~, ~, Hstat] = DensityOccupation_KJ(GlobalDelta{ch}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.delta.absolut.Hstat{p,ch} = Hstat;
        %rescaled
        [~, ~, Hstat] = DensityOccupation_KJ(GlobalDelta{ch}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
        homeo_res.delta.rescaled.Hstat{p,ch} = Hstat;
        
        %other delta 1
        [~, ~, Hstat] = DensityOccupation_KJ(OtherDelta{ch}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.other.absolut.Hstat{p,ch} = Hstat;
        %rescaled
        [~, ~, Hstat] = DensityOccupation_KJ(OtherDelta{ch}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
        homeo_res.other.rescaled.Hstat{p,ch} = Hstat;
        
        %SWA
        [~, ~, Hstat] = GetSWAchannel(channels_pfc(ch), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.swa.absolut.Hstat{p,ch} = Hstat;
        %rescaled
        [~, ~, Hstat] = GetSWAchannel(channels_pfc(ch), 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
        homeo_res.swa.rescaled.Hstat{p,ch} = Hstat;
        

        
    end
        
end



%saving data
cd(FolderDeltaDataKJ)
save QuantifHomeostasisPFCdeepFakeDelta2.mat homeo_res




   