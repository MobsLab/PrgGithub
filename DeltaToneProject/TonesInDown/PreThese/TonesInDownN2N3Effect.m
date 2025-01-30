%%TonesInDownN2N3Effect
% 18.09.2018 KJ
%
%
%
%
% see
%   FiguresTonesInDownPerRecord ShamInDownN2N3Effect TonesInUpN2N3Effect
%


clear

Dir = PathForExperimentsRandomTonesSpikes;


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    range_down = [0 50]*10;   % [0-50ms] after tone in Down
    binsize_mua = 2;
    
    minDuration = 40;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_res.nb_tones = length(ToneEvent);
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% Tones in - N2 & N3
    ToneDownN2 = Restrict(Restrict(ToneEvent, N2), down_PFCx);
    ToneDownN3 = Restrict(Restrict(ToneEvent, N3), down_PFCx);
    ToneDownNREM = Restrict(Restrict(ToneEvent, NREM), down_PFCx);
    
    IntvTransitN2    = intervalSet(Range(ToneDownN2)+range_down(1), Range(ToneDownN2)+range_down(2));
    IntvTransitN3    = intervalSet(Range(ToneDownN3)+range_down(1), Range(ToneDownN3)+range_down(2));
    IntvTransitNREM  = intervalSet(Range(ToneDownNREM)+range_down(1), Range(ToneDownNREM)+range_down(2));
    
    tones_res.n2.nb_tones{p}   = length(ToneDownN2);
    tones_res.n3.nb_tones{p}   = length(ToneDownN3);
    tones_res.nrem.nb_tones{p} = length(ToneDownNREM);
    
    
    %% Delay between tones and transitions
    
    %N2
    tonesin_tmp = Range(ToneDownN2);
    tones_res.n2.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.n2.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_res.n2.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tones_res.n2.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end

    %N3
    tonesin_tmp = Range(ToneDownN3);
    tones_res.n3.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.n3.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_res.n3.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tones_res.n3.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    %NREM
    tonesin_tmp = Range(ToneDownNREM);
    tones_res.nrem.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.nrem.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_res.nrem.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tones_res.nrem.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n2.nb_transit{p} = length(intervals);
    tones_res.n2.transit_rate{p} = length(intervals) / tones_res.n2.nb_tones{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n3.nb_transit{p} = length(intervals);
    tones_res.n3.transit_rate{p} = length(intervals) / tones_res.n3.nb_tones{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.nrem.nb_transit{p} = length(intervals);
    tones_res.nrem.transit_rate{p} = length(intervals) / tones_res.nrem.nb_tones{p};
    
    
    %% MUA response for tones
    
    %N2
    [m,~,tps] = mETAverage(Range(ToneDownN2), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.n2.met_inside{p}(:,1) = tps; tones_res.n2.met_inside{p}(:,2) = m;
    
    %N3
    [m,~,tps] = mETAverage(Range(ToneDownN3), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.n3.met_inside{p}(:,1) = tps; tones_res.n3.met_inside{p}(:,2) = m;
    
    %NREM
    [m,~,tps] = mETAverage(Range(ToneDownNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.nrem.met_inside{p}(:,1) = tps; tones_res.nrem.met_inside{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TonesInDownN2N3Effect.mat tones_res binsize_met nbBins_met binsize_mua minDuration range_down



