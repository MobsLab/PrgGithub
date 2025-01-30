%%AssessShamEffectLocalGlobal
% 01.12.2018 KJ
%
%
%
%
% see
%   TonesInUpN2N3Effect AssessTonesEffectLocalGlobal
%


clear

Dir = PathForExperimentsShamLocalDown;
effect_periods = GetEffectPeriodDownTone(Dir);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res effect_periods
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};
    sham_res.tetrodes{p}   = Dir.tetrodes{p};

   
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
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    SHAMtime = Restrict(SHAMtime,NREM);
    sham_res.nb_sham{p} = length(SHAMtime);
    sham_tmp = Range(SHAMtime);
    
    
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
    
    %Sham
    ShamUp = Restrict(SHAMtime,GlobalUp);
    shamup_tmp = Range(ShamUp);
    ShamStrict = Restrict(SHAMtime,StrictLocals);
    shamstrict_tmp = Range(ShamStrict);
    

    %Sync Global Up 
    for t=1:length(shamup_tmp)
        intv = intervalSet(shamup_tmp(t)-windowsize, shamup_tmp(t));
        y_inters = tot_length(and(GlobalDown,intv)) / windowsize;
        y_union  = tot_length(and(UnionAllDown,intv)) / windowsize;
        if y_union==0
            shamup_sync(t) = 0;
        else
            shamup_sync(t) = y_inters/y_union;
        end
    end
    sham_res.up.sync_sham{p} =  shamup_sync;
    
    %Sync Strict Local 
    for t=1:length(shamstrict_tmp)
        intv = intervalSet(shamstrict_tmp(t)-windowsize, shamstrict_tmp(t));
        y_inters = tot_length(and(GlobalDown,intv)) / windowsize;
        y_union  = tot_length(and(UnionAllDown,intv)) / windowsize;
        if y_union==0
            shamstrict_sync(t) = 0;
        else
            shamstrict_sync(t) = y_inters/y_union;
        end
    end
    sham_res.strict.sync_sham{p} =  shamstrict_sync;
    
    
    %% Delay between sham and transitions
    
    
    %Sham in global UP - out of Union
    sham_res.up.strict_bef{p} = nan(length(shamup_tmp), 1);
    sham_res.up.strict_aft{p} = nan(length(shamup_tmp), 1);
    sham_res.up.global_bef{p} = nan(length(shamup_tmp), 1);
    sham_res.up.global_aft{p} = nan(length(shamup_tmp), 1);
    for i=1:length(shamup_tmp)
        st_bef = end_strict(find(end_strict<shamup_tmp(i),1,'last'));
        sham_res.up.strict_bef{p}(i) = shamup_tmp(i) - st_bef;
        
        end_aft = st_strict(find(st_strict>shamup_tmp(i),1));
        sham_res.up.strict_aft{p}(i) = end_aft - shamup_tmp(i);
        
        st_bef = end_global(find(end_global<shamup_tmp(i),1,'last'));
        sham_res.up.global_bef{p}(i) = shamup_tmp(i) - st_bef;
        
        end_aft = st_global(find(st_global>shamup_tmp(i),1));
        sham_res.up.global_aft{p}(i) = end_aft - shamup_tmp(i);
    end
    
    
    %Sham in local strict 
    sham_res.strict.strict_bef{p} = nan(length(shamstrict_tmp), 1);
    sham_res.strict.strict_aft{p} = nan(length(shamstrict_tmp), 1);
    sham_res.strict.global_bef{p} = nan(length(shamstrict_tmp), 1);
    sham_res.strict.global_aft{p} = nan(length(shamstrict_tmp), 1);
    for i=1:length(shamstrict_tmp)
        st_bef = st_strict(find(st_strict<shamstrict_tmp(i),1,'last'));
        sham_res.strict.strict_bef{p}(i) = shamstrict_tmp(i) - st_bef;
        
        end_aft = end_strict(find(end_strict>shamstrict_tmp(i),1));
        sham_res.strict.strict_aft{p}(i) = end_aft - shamstrict_tmp(i);
        
        st_bef = end_global(find(end_global<shamstrict_tmp(i),1,'last'));
        sham_res.strict.global_bef{p}(i) = shamstrict_tmp(i) - st_bef;
        
        end_aft = st_global(find(st_global>shamstrict_tmp(i),1));
        sham_res.strict.global_aft{p}(i) = end_aft - shamstrict_tmp(i);
    end
    
    
    %% Success to create a transition
    
    % In global Up - create global ?
    intv = [shamup_tmp+range_up(1) shamup_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(st_global, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.up.global.nb_transit{p} = length(intervals);
    sham_res.up.global.transit_rate{p} = length(intervals) / length(shamup_tmp);
    sham_res.up.global.success{p} = zeros(length(shamup_tmp),1);
    sham_res.up.global.success{p}(intervals)=1;
    
    % In global Up - create local strict ?
    intv = [shamup_tmp+range_up(1) shamup_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(st_strict, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.up.local.nb_transit{p} = length(intervals);
    sham_res.up.local.transit_rate{p} = length(intervals) / length(shamup_tmp);
    sham_res.up.local.success{p} = zeros(length(shamup_tmp),1);
    sham_res.up.local.success{p}(intervals)=1;
    
    
    % In strictly local - create global ?
    intv = [shamstrict_tmp+range_up(1) shamstrict_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(st_global, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.strict.global.nb_transit{p} = length(intervals);
    sham_res.strict.global.transit_rate{p} = length(intervals) / length(shamstrict_tmp);
    sham_res.strict.global.success{p} = zeros(length(shamstrict_tmp),1);
    sham_res.strict.global.success{p}(intervals)=1;
    
    
    
    % In strictly local - end local ?
    intv = [shamstrict_tmp+range_up(1) shamstrict_tmp+range_up(2)];    
    [~,intervals,~] = InIntervals(end_strict, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.strict.local.nb_transit{p} = length(intervals);
    sham_res.strict.local.transit_rate{p} = length(intervals) / length(shamstrict_tmp);
    sham_res.strict.local.success{p} = zeros(length(shamstrict_tmp),1);
    sham_res.strict.local.success{p}(intervals)=1;

    
    
    %% MUA response for sham 
    
    %In Global Up
    [m,~,tps] = mETAverage(Range(ShamUp), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.up.met_mua{p}(:,1) = tps; sham_res.up.met_mua{p}(:,2) = m;
    
    %In Strict Local
    [m,~,tps] = mETAverage(Range(ShamStrict), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.strict.met_mua{p}(:,1) = tps; sham_res.strict.met_mua{p}(:,2) = m;

    
    %% Sync
    for t=1:length(sham_tmp)
        intv_before = intervalSet(sham_tmp(t)-windowsize2, sham_tmp(t));
        inter_before = tot_length(and(GlobalDown,intv_before)) / windowsize2;
        union_before  = tot_length(and(UnionAllDown,intv_before)) / windowsize2;
        if union_before==0
            sync_before(t) = 0;
        else
            sync_before(t) = inter_before/union_before;
        end
        
        intv_after = intervalSet(sham_tmp(t), sham_tmp(t)+windowsize2);
        inter_after = tot_length(and(GlobalDown,intv_after)) / windowsize;
        union_after = tot_length(and(UnionAllDown,intv_after)) / windowsize;
        if union_after==0
            sync_after(t) = 0;
        else
            sync_after(t) = inter_after/union_after;
        end
        
        
    end
    sham_res.all.sync_before{p} =  sync_before;
    sham_res.all.sync_after{p} =  sync_after;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save AssessShamEffectLocalGlobal.mat sham_res effect_periods



