%%QuantifHomeostasisSwaRealFake
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta
%    QuantifHomeostasisPFCdeepFakeDeltaPlot
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
    windowsize_density = 60e4; %60s  
    binsize_mua = 5;
    

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
    idx = clusters_pfc>=3;
    channels_pfc = channels_pfc(idx);    
    homeo_res.channels{p} = channels_pfc;
    homeo_res.clusters{p} = clusters_pfc(idx);
    
    %Deltawaves
    if ~isempty(Dir.hemisphere{p})
        load('DeltaWaves.mat', ['deltas_PFCx_' Dir.hemisphere{p}])
        eval(['DeltaDiff = deltas_PFCx_' Dir.hemisphere{p}]);
    else
        load('DeltaWaves.mat', 'deltas_PFCx')
        DeltaDiff = deltas_PFCx;
    end
    DeltaDiff = and(DeltaDiff,NREM);
    homeo_res.nb.diff{p} = length(Start(DeltaDiff));
    
    %Down
    if ~isempty(Dir.hemisphere{p})
        load('DownState.mat', ['down_PFCx_' Dir.hemisphere{p}])
        eval(['GlobalDown = down_PFCx_' Dir.hemisphere{p}]);
    else
        load('DownState.mat', 'down_PFCx')
        GlobalDown = down_PFCx;
    end
    GlobalDown = and(GlobalDown,NREM);
    homeo_res.nb.down{p} = length(Start(GlobalDown));
    
    
    %% Delta diff homeostasis
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
    
        
        %% Homeostasis
        
        %global delta
        [~, ~, Hstat] = DensityOccupation_KJ(GlobalDelta{ch}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
        homeo_res.delta.absolut.Hstat{p,ch} = Hstat;
        %rescaled
        [~, ~, Hstat] = DensityOccupation_KJ(GlobalDelta{ch}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
        homeo_res.delta.rescaled.Hstat{p,ch} = Hstat;
        
        %other delta
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
save QuantifHomeostasisSwaRealFake.mat homeo_res






   