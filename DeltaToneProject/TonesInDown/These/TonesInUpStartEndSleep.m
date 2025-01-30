%%TonesInUpStartEndSleep
% 18.09.2018 KJ
%
%
%
%
% see
%   FiguresTonesInUpPerRecord ShamInUpN2N3Effect TonesInDownN2N3Effect
%   RipplesInUpN2N3Effect


clear

Dir = PathForExperimentsTonesStartEndSpikes;
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
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_res.all.nb_tones{p} = length(ToneEvent);
    tones_tmp = Range(ToneEvent);
    limit_startend = Dir.center{p};
    tones_begin = tones_tmp(tones_tmp<limit_startend);
    tones_end   = tones_tmp(tones_tmp>limit_startend);
    
    %substages
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM-TotalNoiseEpoch;
    
    
    %% Tones in Up
    TonesBegin = Restrict(Restrict(ts(tones_begin), NREM), up_PFCx);
    TonesEnd   = Restrict(Restrict(ts(tones_end), NREM), up_PFCx);    
    IntvTransitBegin = intervalSet(Range(TonesBegin)+range_up(1), Range(TonesBegin)+range_up(2));
    IntvTransitEnd   = intervalSet(Range(TonesEnd)+range_up(1), Range(TonesEnd)+range_up(2));

    tones_res.begin.nb_tones{p} = length(TonesBegin);
    tones_res.end.nb_tones{p}   = length(TonesEnd);
    
    
    %% Success to create a transition
    
    %Begin
    intv = [Start(IntvTransitBegin) End(IntvTransitBegin)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.begin.nb_transit{p} = length(intervals);
    tones_res.begin.transit_rate{p} = length(intervals) / tones_res.begin.nb_tones{p};
    
    %End
    intv = [Start(IntvTransitEnd) End(IntvTransitEnd)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.end.nb_transit{p} = length(intervals);
    tones_res.end.transit_rate{p} = length(intervals) / tones_res.end.nb_tones{p};
    
    
    %% MUA response for tones
    [m,~,tps] = mETAverage(Range(TonesBegin), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.begin.met_mua{p}(:,1) = tps; tones_res.begin.met_mua{p}(:,2) = m;
    
    [m,~,tps] = mETAverage(Range(TonesEnd), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.end.met_mua{p}(:,1) = tps; tones_res.end.met_mua{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TonesInUpStartEndSleep.mat tones_res


