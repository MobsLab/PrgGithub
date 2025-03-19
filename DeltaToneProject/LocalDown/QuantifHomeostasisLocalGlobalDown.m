%%QuantifHomeostasisLocalGlobalDown
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta ParcoursHomeostasieLocalDeltaOccupancy
%    QuantifHomeostasisLocalGlobalDownPlot


% clear
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
    homeo_res.tetrodes{p} = Dir.tetrodes{p};
    
    %params
    minDurationLocal = 100*10; %100ms
    windowsize_density = 60e4; %60s  

    
    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %NREM in ZT
    new_st = Data(Restrict(NewtsdZT, ts(Start(NREM))));
    new_end = Data(Restrict(NewtsdZT, ts(End(NREM))));
    %check duration
    event_dur = End(NREM) - Start(NREM);
    new_event_dur = new_end - new_st;
    event_ok = new_event_dur<1.3*event_dur;
    %new events Epoch
    NREMzt = intervalSet(new_st(event_ok), new_end(event_ok));


    %% Down

    %Global
    if ~isempty(Dir.hemisphere{p})
        load('DownState.mat', ['down_PFCx_' Dir.hemisphere{p}])
        eval(['GlobalDown = down_PFCx_' Dir.hemisphere{p} ';']);
    else
        load('DownState.mat', 'down_PFCx')
        GlobalDown = down_PFCx;
    end
    
    
    %Local
    load('LocalDownState.mat', 'all_local_PFCx')
    all_local_PFCx = all_local_PFCx(Dir.tetrodes{p});
    nb_tetrodes = length(all_local_PFCx);
    for tt=1:nb_tetrodes
        %distinguish local and global
        [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(all_local_PFCx{tt}, GlobalDown);
        LocalDown{tt} = subset(all_local_PFCx{tt}, setdiff(1:length(Start(all_local_PFCx{tt})), idAlocal)');
        LocalDown{tt} = dropShortIntervals(and(LocalDown{tt},NREM), minDurationLocal);
        
        AllDown_local{tt} = dropShortIntervals(and(all_local_PFCx{tt},NREM), minDurationLocal);
    end
    
    %Union
    UnionAllDown = AllDown_local{1};
    for tt=2:nb_tetrodes
        UnionAllDown = or(UnionAllDown,AllDown_local{tt});
    end
    UnionAllDown = CleanUpEpoch(dropLongIntervals(UnionAllDown, 1e4),1); %not more than 2sec
    
    
    %% Homeostasis

    %Global
    [~, ~, Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',0);
    homeo_res.global.absolut.Hstat{p} = Hstat;
    [~, ~, Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    homeo_res.global.rescaled.Hstat{p} = Hstat;
    
    %Union
    [~, ~, Hstat] = DensityOccupation_KJ(UnionAllDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',0);
    homeo_res.union.absolut.Hstat{p} = Hstat;
    [~, ~, Hstat] = DensityOccupation_KJ(UnionAllDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
    homeo_res.union.rescaled.Hstat{p} = Hstat;
    
    
    %Local
    for tt=1:nb_tetrodes        
        [~, ~, Hstat] = DensityOccupation_KJ(LocalDown{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',0);
        homeo_res.local.absolut.Hstat{p,tt} = Hstat;
        [~, ~, Hstat] = DensityOccupation_KJ(LocalDown{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
        homeo_res.local.rescaled.Hstat{p,tt} = Hstat;
        
        [~, ~, Hstat] = DensityOccupation_KJ(AllDown_local{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',0);
        homeo_res.all_local.absolut.Hstat{p,tt} = Hstat;
        [~, ~, Hstat] = DensityOccupation_KJ(AllDown_local{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);
        homeo_res.all_local.rescaled.Hstat{p,tt} = Hstat;
    end    
    
    
    %% Ratio
    
    %compute ratio
    union.x_intervals = homeo_res.union.absolut.Hstat{p}.x_intervals;
    union.y_density = homeo_res.union.absolut.Hstat{p}.y_density;
    
    downglobal.x_intervals = homeo_res.global.absolut.Hstat{p}.x_intervals;
    downglobal.y_density = homeo_res.global.absolut.Hstat{p}.y_density;

    ratio.x_density = union.x_intervals*3600e4;
    ratio.y_density = downglobal.y_density ./ (union.y_density+0.1);
    ratio.y_density(union.y_density==0) = 0; 
    
    %homeostasis
    Hstat = HomestasisStat_KJ(ratio.x_density, ratio.y_density, NREMzt, 4,'rescale',0);
    homeo_res.ratio.absolut.Hstat{p} = Hstat;
    Hstat = HomestasisStat_KJ(ratio.x_density, ratio.y_density, NREMzt, 4,'rescale',2);
    homeo_res.ratio.rescaled.Hstat{p} = Hstat;
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save QuantifHomeostasisLocalGlobalDown.mat homeo_res









