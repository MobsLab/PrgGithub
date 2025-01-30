%%AssessTonesEffectLocalGlobal
% 01.12.2018 KJ
%
%
%
%
% see
%   TonesInUpN2N3Effect AssessShamEffectLocalGlobal
%   AssessTonesEffectLocalGlobalPlot
%


clear

Dir = PathForExperimentsTonesLocalDown;
effect_periods = GetEffectPeriodDownTone(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res effect_periods
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};
    tones_res.tetrodes{p}   = Dir.tetrodes{p};

   
    %params
    binsize_mua = 2;
    windowsize = 3e4;
    windowsize2 = 2e4;
    minDurationLocal = 100;
    range_up = effect_periods(p,:);
    
    binsize_met = 10;
    nbBins_met  = 80;

    %substages
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    ToneEvent = Restrict(ToneEvent,NREM);
    tones_res.nb_tones{p} = length(ToneEvent);
    tones_tmp = Range(ToneEvent);
    
    
    %% MUA and down
    
    %MUA
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    
    %Global Down
    load('DownState.mat', 'down_PFCx')
    GlobalDown = down_PFCx;
    st_global = Start(GlobalDown);
    end_global = End(GlobalDown);
    
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
    UnionAllDown = intervalSet([],[]);
    for tt=1:nb_tetrodes
        UnionAllDown = or(UnionAllDown,AllDown_local{tt});
    end
    UnionAllDown = CleanUpEpoch(dropLongIntervals(UnionAllDown, 1e4),1); %not more than 2sec
    
    %All strict local
    StrictLocals = intervalSet([],[]);
    for tt=1:nb_tetrodes
        StrictLocals = or(StrictLocals,LocalDown{tt});
    end
    StrictLocals = CleanUpEpoch(dropLongIntervals(UnionAllDown, 1e4),1); %not more than 2sec
    st_strict = Start(StrictLocals);
    end_strict = End(StrictLocals);
    
    
    %GlobalUp
    st_union = Start(UnionAllDown);
    end_union = End(UnionAllDown);
    GlobalUp = intervalSet(end_union(1:end-1), st_union(2:end));
    st_up = Start(GlobalUp);
    end_up = End(GlobalUp);
    
    %Tones
    TonesUp = Restrict(ToneEvent,GlobalUp);
    tonesup_tmp = Range(TonesUp);
    TonesStrict = Restrict(ToneEvent,StrictLocals);
    tonesstrict_tmp = Range(TonesStrict);
    

    %Sync Global Up 
    for t=1:length(tonesup_tmp)
        intv = intervalSet(tonesup_tmp(t)-windowsize, tonesup_tmp(t));
        y_inters = tot_length(and(GlobalDown,intv)) / windowsize;
        y_union  = tot_length(and(UnionAllDown,intv)) / windowsize;
        if y_union==0
            tonesup_sync(t) = 0;
        else
            tonesup_sync(t) = y_inters/y_union;
        end
    end
    tones_res.up.sync_tones{p} =  tonesup_sync;
    
    %Sync Strict Local 
    for t=1:length(tonesstrict_tmp)
        intv = intervalSet(tonesstrict_tmp(t)-windowsize, tonesstrict_tmp(t));
        y_inters = tot_length(and(GlobalDown,intv)) / windowsize;
        y_union  = tot_length(and(UnionAllDown,intv)) / windowsize;
        if y_union==0
            tonesstrict_sync(t) = 0;
        else
            tonesstrict_sync(t) = y_inters/y_union;
        end
    end
    tones_res.strict.sync_tones{p} =  tonesstrict_sync;
    
    
    %% Delay between tones and transitions
    
    
    %Tones in global UP - out of Union
    tones_res.up.strict_bef{p} = nan(length(tonesup_tmp), 1);
    tones_res.up.strict_aft{p} = nan(length(tonesup_tmp), 1);
    tones_res.up.global_bef{p} = nan(length(tonesup_tmp), 1);
    tones_res.up.global_aft{p} = nan(length(tonesup_tmp), 1);
    for i=1:length(tonesup_tmp)
        st_bef = end_strict(find(end_strict<tonesup_tmp(i),1,'last'));
        tones_res.up.strict_bef{p}(i) = tonesup_tmp(i) - st_bef;
        
        end_aft = st_strict(find(st_strict>tonesup_tmp(i),1));
        tones_res.up.strict_aft{p}(i) = end_aft - tonesup_tmp(i);
        
        st_bef = end_global(find(end_global<tonesup_tmp(i),1,'last'));
        tones_res.up.global_bef{p}(i) = tonesup_tmp(i) - st_bef;
        
        end_aft = st_global(find(st_global>tonesup_tmp(i),1));
        tones_res.up.global_aft{p}(i) = end_aft - tonesup_tmp(i);
    end
    
    
    %Tones in local strict 
    tones_res.strict.strict_bef{p} = nan(length(tonesstrict_tmp), 1);
    tones_res.strict.strict_aft{p} = nan(length(tonesstrict_tmp), 1);
    tones_res.strict.global_bef{p} = nan(length(tonesstrict_tmp), 1);
    tones_res.strict.global_aft{p} = nan(length(tonesstrict_tmp), 1);
    for i=1:length(tonesstrict_tmp)
        st_bef = st_strict(find(st_strict<tonesstrict_tmp(i),1,'last'));
        tones_res.strict.strict_bef{p}(i) = tonesstrict_tmp(i) - st_bef;
        
        end_aft = end_strict(find(end_strict>tonesstrict_tmp(i),1));
        tones_res.strict.strict_aft{p}(i) = end_aft - tonesstrict_tmp(i);
        
        st_bef = end_global(find(end_global<tonesstrict_tmp(i),1,'last'));
        tones_res.strict.global_bef{p}(i) = tonesstrict_tmp(i) - st_bef;
        
        end_aft = st_global(find(st_global>tonesstrict_tmp(i),1));
        tones_res.strict.global_aft{p}(i) = end_aft - tonesstrict_tmp(i);
    end
    
    
    %% Success to create a transition
    
    % In global Up - create global ?
    intv = [tonesup_tmp+range_up(1) tonesup_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(st_global, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.up.global.nb_transit{p} = length(intervals);
    tones_res.up.global.transit_rate{p} = length(intervals) / length(tonesup_tmp);
    tones_res.up.global.success{p} = zeros(length(tonesup_tmp),1);
    tones_res.up.global.success{p}(intervals)=1;
    
    % In global Up - create local strict ?
    intv = [tonesup_tmp+range_up(1) tonesup_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(st_strict, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.up.local.nb_transit{p} = length(intervals);
    tones_res.up.local.transit_rate{p} = length(intervals) / length(tonesup_tmp);
    tones_res.up.local.success{p} = zeros(length(tonesup_tmp),1);
    tones_res.up.local.success{p}(intervals)=1;
    
    
    % In strictly local - create global ?
    intv = [tonesstrict_tmp+range_up(1) tonesstrict_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(st_global, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.strict.global.nb_transit{p} = length(intervals);
    tones_res.strict.global.transit_rate{p} = length(intervals) / length(tonesstrict_tmp);
    tones_res.strict.global.success{p} = zeros(length(tonesstrict_tmp),1);
    tones_res.strict.global.success{p}(intervals)=1;
    
    
    
    % In strictly local - end local ?
    intv = [tonesstrict_tmp+range_up(1) tonesstrict_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(end_strict, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.strict.local.nb_transit{p} = length(intervals);
    tones_res.strict.local.transit_rate{p} = length(intervals) / length(tonesstrict_tmp);
    tones_res.strict.local.success{p} = zeros(length(tonesstrict_tmp),1);
    tones_res.strict.local.success{p}(intervals)=1;

    
    
    %% MUA response for tones by tetrodes
    
    %In Global Up
    [m,~,tps] = mETAverage(Range(TonesUp), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.up.met_mua{p}(:,1) = tps; tones_res.up.met_mua{p}(:,2) = m;
    
    %In Strict Local
    [m,~,tps] = mETAverage(Range(TonesStrict), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.strict.met_mua{p}(:,1) = tps; tones_res.strict.met_mua{p}(:,2) = m;

    
    %% Sync
    for t=1:length(tones_tmp)
        intv_before = intervalSet(tones_tmp(t)-windowsize2, tones_tmp(t));
        inter_before = tot_length(and(GlobalDown,intv_before)) / windowsize2;
        union_before  = tot_length(and(UnionAllDown,intv_before)) / windowsize2;
        if union_before==0
            sync_before(t) = 0;
        else
            sync_before(t) = inter_before/union_before;
        end
        
        intv_after = intervalSet(tones_tmp(t), tones_tmp(t)+windowsize2);
        inter_after = tot_length(and(GlobalDown,intv_after)) / windowsize;
        union_after = tot_length(and(UnionAllDown,intv_after)) / windowsize;
        if union_after==0
            sync_after(t) = 0;
        else
            sync_after(t) = inter_after/union_after;
        end
        
        
    end
    tones_res.all.sync_before{p} =  sync_before;
    tones_res.all.sync_after{p} =  sync_after;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save AssessTonesEffectLocalGlobal.mat tones_res effect_periods



