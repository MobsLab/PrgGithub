%%TonesInUpN2N3Effect
% 18.09.2018 KJ
%
%
%
%
% see
%   FiguresTonesInUpPerRecord ShamInUpN2N3Effect TonesInDownN2N3Effect
%   RipplesInUpN2N3Effect


clear

Dir = PathForExperimentsRandomTonesSpikes;
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
    binsize_mua = 2;
    
    minDuration = 40;
    maxDuration = 30e4;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_res.nb_tones = length(ToneEvent);
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% Tones in - N2 & N3
    ToneUpN2 = Restrict(Restrict(ToneEvent, N2), up_PFCx);
    ToneUpN3 = Restrict(Restrict(ToneEvent, N3), up_PFCx);
    ToneUpNREM = Restrict(Restrict(ToneEvent, NREM), up_PFCx);
    
    IntvTransitN2  = intervalSet(Range(ToneUpN2)+range_up(1), Range(ToneUpN2)+range_up(2));
    IntvTransitN3  = intervalSet(Range(ToneUpN3)+range_up(1), Range(ToneUpN3)+range_up(2));
    IntvTransitNREM  = intervalSet(Range(ToneUpNREM)+range_up(1), Range(ToneUpNREM)+range_up(2));
    
    tones_res.n2.nb_tones{p} = length(ToneUpN2);
    tones_res.n3.nb_tones{p} = length(ToneUpN3);
    tones_res.nrem.nb_tones{p} = length(ToneUpNREM);
    
    
    %% Delay between tones and transitions
    
    %N2
    tonesin_tmp = Range(ToneUpN2);
    tones_res.n2.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.n2.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_up(find(st_up<tonesin_tmp(i),1,'last'));
        tones_res.n2.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>tonesin_tmp(i),1));
        tones_res.n2.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end

    %N3
    tonesin_tmp = Range(ToneUpN3);
    tones_res.n3.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.n3.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_up(find(st_up<tonesin_tmp(i),1,'last'));
        tones_res.n3.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>tonesin_tmp(i),1));
        tones_res.n3.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %NREM
    tonesin_tmp = Range(ToneUpNREM);
    tones_res.nrem.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.nrem.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_up(find(st_up<tonesin_tmp(i),1,'last'));
        tones_res.nrem.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>tonesin_tmp(i),1));
        tones_res.nrem.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n2.nb_transit{p} = length(intervals);
    tones_res.n2.transit_rate{p} = length(intervals) / tones_res.n2.nb_tones{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n3.nb_transit{p} = length(intervals);
    tones_res.n3.transit_rate{p} = length(intervals) / tones_res.n3.nb_tones{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.nrem.nb_transit{p} = length(intervals);
    tones_res.nrem.transit_rate{p} = length(intervals) / tones_res.nrem.nb_tones{p};
    
    
    %% MUA response for tones
    
    %N2
    [m,~,tps] = mETAverage(Range(ToneUpN2), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.n2.met_inside{p}(:,1) = tps; tones_res.n2.met_inside{p}(:,2) = m;
    
    %N3
    [m,~,tps] = mETAverage(Range(ToneUpN3), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.n3.met_inside{p}(:,1) = tps; tones_res.n3.met_inside{p}(:,2) = m;
    
    %NREM
    [m,~,tps] = mETAverage(Range(ToneUpNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.nrem.met_inside{p}(:,1) = tps; tones_res.nrem.met_inside{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TonesInUpN2N3Effect.mat tones_res binsize_met nbBins_met binsize_mua minDuration range_up



