%%ShamInUpStartEndSleep
% 02.12.2019 KJ
%
%
%
% see
%   FiguresTonesInUpPerRecord ShamInUpN2N3Effect TonesInDownN2N3Effect
%   RipplesInUpN2N3Effect


clear

Dir = PathForExperimentsShamStartEndSpikes;
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

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    range_up = effect_periods(p,:);
    binsize_mua = 5;
    
    maxDuration = 30e4;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.all.nb_sham{p} = length(SHAMtime);
    sham_tmp = Range(SHAMtime);
    limit_startend = Dir.center{p};
    sham_begin = sham_tmp(sham_tmp<limit_startend);
    sham_end   = sham_tmp(sham_tmp>limit_startend);
    
    %substages
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    
    
    %% Tones in Up
    ShamBegin = Restrict(Restrict(ts(sham_begin), NREM), up_PFCx);
    ShamEnd   = Restrict(Restrict(ts(sham_end), NREM), up_PFCx);    
    IntvTransitBegin = intervalSet(Range(ShamBegin)+range_up(1), Range(ShamBegin)+range_up(2));
    IntvTransitEnd   = intervalSet(Range(ShamEnd)+range_up(1), Range(ShamEnd)+range_up(2));

    sham_res.begin.nb_tones{p} = length(ShamBegin);
    sham_res.end.nb_tones{p}   = length(ShamEnd);
    
    
    %% Success to create a transition
    
    %Begin
    intv = [Start(IntvTransitBegin) End(IntvTransitBegin)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.begin.nb_transit{p} = length(intervals);
    sham_res.begin.transit_rate{p} = length(intervals) / sham_res.begin.nb_tones{p};
    
    %End
    intv = [Start(IntvTransitEnd) End(IntvTransitEnd)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.end.nb_transit{p} = length(intervals);
    sham_res.end.transit_rate{p} = length(intervals) / sham_res.end.nb_tones{p};
    
    
    %% MUA response for sham
    [m,~,tps] = mETAverage(Range(ShamBegin), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.begin.met_mua{p}(:,1) = tps; sham_res.begin.met_mua{p}(:,2) = m;
    
    [m,~,tps] = mETAverage(Range(ShamEnd), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.end.met_mua{p}(:,1) = tps; sham_res.end.met_mua{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ShamInUpStartEndSleep.mat sham_res


