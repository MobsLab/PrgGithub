%%RipplesInDownN2N3Effect
% 19.09.2018 KJ
%
%
%
%
% see
%   RipplesInUpN2N3Effect RipplesInDownN2N3Effect
%


clear

Dir=PathForExperimentsRipplesDown;

effect_periods = GetEffectPeriodUpRipples(Dir);

load(fullfile(FolderDeltaDataKJ,'RipplesInDownN2N3Effect.mat'))


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
     
    clearvars -except Dir p ripples_res effect_periods
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    range_down = effect_periods(p,:);    % after ripples in down
    binsize_mua = 2;
    
    minDuration = 40;
    
    %MUA & Down
    if strcmpi(Dir.name{p},'Mouse508')
        MUA = GetMuaNeurons_KJ('PFCx_r', 'binsize',binsize_mua);
    elseif strcmpi(Dir.name{p},'Mouse509')
        MUA = GetMuaNeurons_KJ('PFCx_l', 'binsize',binsize_mua);
    else
        MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    end
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    %ripples    
    [tRipples, RipplesEpoch] = GetRipples;
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% Create sham
    nb_sham = 7000;
    idx = randsample(length(st_down), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Ripples in - N2 & N3
    RipplesDownN2 = Restrict(Restrict(tRipples, N2), down_PFCx);
    RipplesDownN3 = Restrict(Restrict(tRipples, N3), down_PFCx);
    RipplesDownNREM = Restrict(Restrict(tRipples, NREM), down_PFCx);
    
    IntvTransitN2  = intervalSet(Range(RipplesDownN2)+range_down(1), Range(RipplesDownN2)+range_down(2));
    IntvTransitN3  = intervalSet(Range(RipplesDownN3)+range_down(1), Range(RipplesDownN3)+range_down(2));
    IntvTransitNREM  = intervalSet(Range(RipplesDownNREM)+range_down(1), Range(RipplesDownNREM)+range_down(2));
    
    ripples_res.n2.nb_ripples{p} = length(RipplesDownN2);
    ripples_res.n3.nb_ripples{p} = length(RipplesDownN3);
    ripples_res.nrem.nb_ripples{p} = length(RipplesDownNREM);
    
    
    %% Sham in - N2 & N3
    ShamDownN2 = Restrict(Restrict(ShamEvent, N2), down_PFCx);
    ShamDownN3 = Restrict(Restrict(ShamEvent, N3), down_PFCx);
    ShamDownNREM = Restrict(Restrict(ShamEvent, N3), down_PFCx);
    
    ShamTransitN2  = intervalSet(Range(ShamDownN2)+range_down(1), Range(ShamDownN2)+range_down(2));
    ShamTransitN3  = intervalSet(Range(ShamDownN3)+range_down(1), Range(ShamDownN3)+range_down(2));
    ShamTransitNREM  = intervalSet(Range(ShamDownNREM)+range_down(1), Range(ShamDownNREM)+range_down(2));
    
    ripples_res.n2.nb_sham{p} = length(ShamDownN2);
    ripples_res.n3.nb_sham{p} = length(ShamDownN3);
    ripples_res.nrem.nb_sham{p} = length(ShamDownNREM);
    
    
    %% Delay between ripples and transitions
    
    %N2
    ripplesin_tmp = Range(RipplesDownN2);
    ripples_res.n2.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.n2.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripples_res.n2.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripples_res.n2.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end

    %N3
    ripplesin_tmp = Range(RipplesDownN3);
    ripples_res.n3.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.n3.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripples_res.n3.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripples_res.n3.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %NREM
    ripplesin_tmp = Range(RipplesDownNREM);
    ripples_res.nrem.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.nrem.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        st_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        ripples_res.nrem.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>ripplesin_tmp(i),1));
        ripples_res.nrem.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
    end
    
    %% Delay between sham and transitions
    
    %N2
    shamin_tmp = Range(ShamDownN2);
    ripples_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripples_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        ripples_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        ripples_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end

    %N3
    shamin_tmp = Range(ShamDownN3);
    ripples_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripples_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        ripples_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        ripples_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamDownNREM);
    ripples_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    ripples_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        ripples_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        ripples_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
    %% Success to create a transition for TONES
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n2.nb_transit.ripples{p} = length(intervals);
    ripples_res.n2.transit_rate.ripples{p} = length(intervals) / ripples_res.n2.nb_ripples{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n3.nb_transit.ripples{p} = length(intervals);
    ripples_res.n3.transit_rate.ripples{p} = length(intervals) / ripples_res.n3.nb_ripples{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.nrem.nb_transit.ripples{p} = length(intervals);
    ripples_res.nrem.transit_rate.ripples{p} = length(intervals) / ripples_res.nrem.nb_ripples{p};
    
    %% Success to create a transition for SHAM
    
    %N2
    intv = [Start(ShamTransitN2) End(ShamTransitN2)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n2.nb_transit.sham{p} = length(intervals);
    ripples_res.n2.transit_rate.sham{p} = length(intervals) / ripples_res.n2.nb_sham{p};
    
    %N3
    intv = [Start(ShamTransitN3) End(ShamTransitN3)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.n3.nb_transit.sham{p} = length(intervals);
    ripples_res.n3.transit_rate.sham{p} = length(intervals) / ripples_res.n3.nb_sham{p};
    
    %NREM
    intv = [Start(ShamTransitNREM) End(ShamTransitNREM)];
    [~,intervals,~] = InIntervals(end_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    ripples_res.nrem.nb_transit.sham{p} = length(intervals);
    ripples_res.nrem.transit_rate.sham{p} = length(intervals) / ripples_res.nrem.nb_sham{p};
    
    
    %% MUA response for TONES
    
    %N2
    [m,~,tps] = mETAverage(Range(RipplesDownN2), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.n2.met_ripples{p}(:,1) = tps; ripples_res.n2.met_ripples{p}(:,2) = m;
    
    %N3
    [m,~,tps] = mETAverage(Range(RipplesDownN3), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.n3.met_ripples{p}(:,1) = tps; ripples_res.n3.met_ripples{p}(:,2) = m;
    
    %NREM
    [m,~,tps] = mETAverage(Range(RipplesDownNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.nrem.met_ripples{p}(:,1) = tps; ripples_res.nrem.met_ripples{p}(:,2) = m;
    
    
    %% MUA response for SHAM
    
    %N2
    [m,~,tps] = mETAverage(Range(ShamDownN2), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.n2.met_sham{p}(:,1) = tps; ripples_res.n2.met_sham{p}(:,2) = m;
    
    %N3
    [m,~,tps] = mETAverage(Range(ShamDownN3), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.n3.met_sham{p}(:,1) = tps; ripples_res.n3.met_sham{p}(:,2) = m;
    
    %NREM
    [m,~,tps] = mETAverage(Range(ShamDownNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.nrem.met_sham{p}(:,1) = tps; ripples_res.nrem.met_sham{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save RipplesInDownN2N3Effect.mat ripples_res binsize_met nbBins_met binsize_mua minDuration range_down



