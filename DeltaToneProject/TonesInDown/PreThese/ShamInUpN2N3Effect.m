%%ShamInUpN2N3Effect
% 18.09.2018 KJ
%
%
%
%
% see
%   TonesInUpN2N3Effect ShamInDownN2N3Effect ShamInUpN2N3Raster
%



clear

Dir=PathForExperimentsRandomShamSpikes;


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p sham_res
    
    sham_res.path{p}   = Dir.path{p};
    sham_res.manipe{p} = Dir.manipe{p};
    sham_res.name{p}   = Dir.name{p};
    sham_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    range_up = [30 100]*10;    % [30-100ms] after tone in Up
    binsize_mua = 2;
    
    minDuration = 40;
    maxDuration = 30e4;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham = length(SHAMtime);
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% Sham in - N2 & N3 & NREM
    ShamUpN2 = Restrict(Restrict(SHAMtime, N2), up_PFCx);
    ShamUpN3 = Restrict(Restrict(SHAMtime, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(SHAMtime, NREM), up_PFCx);
    
    IntvTransitN2  = intervalSet(Range(ShamUpN2)+range_up(1), Range(ShamUpN2)+range_up(2));
    IntvTransitN3  = intervalSet(Range(ShamUpN3)+range_up(1), Range(ShamUpN3)+range_up(2));
    IntvTransitNREM  = intervalSet(Range(ShamUpNREM)+range_up(1), Range(ShamUpNREM)+range_up(2));
    
    sham_res.n2.nb_sham{p} = length(ShamUpN2);
    sham_res.n3.nb_sham{p} = length(ShamUpN3);
    sham_res.nrem.nb_sham{p} = length(ShamUpNREM);
    
    
    %% Delay between sham and transitions
    
    %N2
    shamin_tmp = Range(ShamUpN2);
    sham_res.n2.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.n2.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.n2.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.n2.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end

    %N3
    shamin_tmp = Range(ShamUpN3);
    sham_res.n3.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.n3.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.n3.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.n3.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    %NREM
    shamin_tmp = Range(ShamUpNREM);
    sham_res.nrem.sham_bef{p} = nan(length(shamin_tmp), 1);
    sham_res.nrem.sham_aft{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        sham_res.nrem.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        sham_res.nrem.sham_aft{p}(i) = end_aft - shamin_tmp(i);
    end
    
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n2.nb_transit{p} = length(intervals);
    sham_res.n2.transit_rate{p} = length(intervals) / sham_res.n2.nb_sham{p};
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n3.nb_transit{p} = length(intervals);
    sham_res.n3.transit_rate{p} = length(intervals) / sham_res.n3.nb_sham{p};
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.nrem.nb_transit{p} = length(intervals);
    sham_res.nrem.transit_rate{p} = length(intervals) / sham_res.nrem.nb_sham{p};
    
    
    %% MUA response for sham
    
    %N2
    [m,~,tps] = mETAverage(Range(ShamUpN2), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.n2.met_inside{p}(:,1) = tps; sham_res.n2.met_inside{p}(:,2) = m;
    
    %N3
    [m,~,tps] = mETAverage(Range(ShamUpN3), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.n3.met_inside{p}(:,1) = tps; sham_res.n3.met_inside{p}(:,2) = m;
    
    %NREM
    [m,~,tps] = mETAverage(Range(ShamUpNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    sham_res.nrem.met_inside{p}(:,1) = tps; sham_res.nrem.met_inside{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ShamInUpN2N3Effect.mat sham_res binsize_met nbBins_met binsize_mua minDuration maxDuration range_up



