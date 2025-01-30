%%QuantifLocalDownSubstages
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    QuantifLocalDownSubstagesPlot
%


% clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p local_res
    
    local_res.path{p}   = Dir.path{p};
    local_res.manipe{p} = Dir.manipe{p};
    local_res.name{p}   = Dir.name{p};
    local_res.date{p}   = Dir.date{p};
    local_res.hemisphere{p}   = Dir.hemisphere{p};
    local_res.tetrodes{p} = Dir.tetrodes{p};
    
    
    %params
    minDurationLocal = 150*10; %100ms
    edges = 0:2:100;
    
    
    %% load

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %Stages
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    [N1, N2, N3, ~, ~] = GetSubstages;
    
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
    
    %Sync tsd
    load('LocalDownState.mat', 'tSyncLocalDown')
    
    
    %% Mean value in N1, N2, N3
    Substages = {N1,N2,N3};
    for s=1:length(Substages)
        
        %sync
        datasy = Data(Restrict(tSyncLocalDown, Substages{s}));
        [local_res.sync.y_hist{s}, local_res.sync.x_hist{s}] = histcounts(datasy*100, edges, 'Normalization','probability');
        local_res.sync.x_hist{s} = local_res.sync.x_hist{s}(1:end-1);
        
        meansync_sub = [];
        for i=1:length(Start(Substages{s}))
            meansync_sub(i,1) = mean(Data(Restrict(tSyncLocalDown, subset(Substages{s},i))))*100;
        end
        local_res.sync.meanvalue{p}(s) = nanmean(meansync_sub);
        
        %global
        local_res.global.occupancy{p}(s) = tot_length(and(GlobalDown,Substages{s})) / tot_length(Substages{s});
        local_res.global.density{p}(s) = length(Restrict(ts(Start(GlobalDown)), Substages{s})) / tot_length(Substages{s});

        %local
        for tt=1:nb_tetrodes
            local_res.local.occupancy{p,tt}(s) = tot_length(and(LocalDown{tt},Substages{s})) / tot_length(Substages{s});
            local_res.local.density{p,tt}(s) = length(Restrict(ts(Start(LocalDown{tt})), Substages{s})) / tot_length(Substages{s});
        end
        
        %union
        local_res.union.occupancy{p}(s) = tot_length(and(UnionAllDown,Substages{s})) / tot_length(Substages{s});
        local_res.union.density{p}(s) = length(Restrict(ts(Start(UnionAllDown)), Substages{s})) / tot_length(Substages{s});
    end
    
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save QuantifLocalDownSubstages.mat local_res







