% IsiShamOnDownStates
% 19.07.2019 KJ
%
% Look at the effect of sham on the Intervals between down states
%
%


clear

Dir = PathForExperimentsRandomShamSpikes;
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
    binsize_mua = 2;
    minDuration = 40;
    range_up = effect_periods(p,:); % after tone in Up
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);

    %sham
    load('ShamSleepEventRandom.mat', 'SHAMtime')
    sham_res.nb_sham = length(SHAMtime);
    
    %substages
    load('SleepSubstages.mat','Epoch')
    N2 = Epoch{2} ; N3 = Epoch{3};
    NREM = or(or(N2,N3), Epoch{1});
    
    
    %% Sham in - N2 & N3
    ShamUpN2 = Restrict(Restrict(SHAMtime, N2), up_PFCx);
    ShamUpN3 = Restrict(Restrict(SHAMtime, N3), up_PFCx);
    ShamUpNREM = Restrict(Restrict(SHAMtime, NREM), up_PFCx);
    
    sham_n2 = Range(ShamUpN2);
    sham_n3 = Range(ShamUpN3);
    sham_nrem = Range(ShamUpNREM);
    
    IntvTransitN2  = intervalSet(Range(ShamUpN2)+range_up(1), Range(ShamUpN2)+range_up(2));
    IntvTransitN3  = intervalSet(Range(ShamUpN3)+range_up(1), Range(ShamUpN3)+range_up(2));
    IntvTransitNREM  = intervalSet(Range(ShamUpNREM)+range_up(1), Range(ShamUpNREM)+range_up(2));
    
    sham_res.n2.nb_sham{p} = length(ShamUpN2);
    sham_res.n3.nb_sham{p} = length(ShamUpN3);
    sham_res.nrem.nb_sham{p} = length(ShamUpNREM);
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n2.success{p} = sham_n2(intervals);
    sham_res.n2.failed{p} = sham_n2(setdiff(1:length(sham_n2),intervals));
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.n3.success{p} = sham_n3(intervals);
    sham_res.n3.failed{p} = sham_n3(setdiff(1:length(sham_n3),intervals));
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    sham_res.nrem.success{p} = sham_nrem(intervals);
    sham_res.nrem.failed{p} = sham_nrem(setdiff(1:length(sham_nrem),intervals));

    
    %% ISI with tones
    
    %N2 success
    sham_tmp = sham_res.n2.success{p};
    isi_sham_down = nan(length(sham_tmp),3);
    for t=1:length(sham_tmp)
        next_down = st_down(find(st_down>sham_tmp(t), 3));
        prev_up = st_up(find(st_up<sham_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_sham_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    sham_res.n2.isi.success{p} = isi_sham_down;
    %N2 failed
    sham_tmp = sham_res.n2.failed{p};
    isi_sham_down = nan(length(sham_tmp),3);
    for t=1:length(sham_tmp)
        next_down = st_down(find(st_down>sham_tmp(t), 3));
        prev_up = st_up(find(st_up<sham_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_sham_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    sham_res.n2.isi.failed{p} = isi_sham_down;
    
    %N3 success
    sham_tmp = sham_res.n3.success{p};
    isi_sham_down = nan(length(sham_tmp),3);
    for t=1:length(sham_tmp)
        next_down = st_down(find(st_down>sham_tmp(t), 3));
        prev_up = st_up(find(st_up<sham_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_sham_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    sham_res.n3.isi.success{p} = isi_sham_down;
    %N3 failed
    sham_tmp = sham_res.n3.failed{p};
    isi_sham_down = nan(length(sham_tmp),3);
    for t=1:length(sham_tmp)
        next_down = st_down(find(st_down>sham_tmp(t), 3));
        prev_up = st_up(find(st_up<sham_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_sham_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    sham_res.n3.isi.failed{p} = isi_sham_down;
    
    %NREM success
    sham_tmp = sham_res.nrem.success{p};
    isi_sham_down = nan(length(sham_tmp),3);
    for t=1:length(sham_tmp)
        next_down = st_down(find(st_down>sham_tmp(t), 3));
        prev_up = st_up(find(st_up<sham_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_sham_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    sham_res.nrem.isi.success{p} = isi_sham_down;
    %NREM failed
    sham_tmp = sham_res.nrem.failed{p};
    isi_sham_down = nan(length(sham_tmp),3);
    for t=1:length(sham_tmp)
        next_down = st_down(find(st_down>sham_tmp(t), 3));
        prev_up = st_up(find(st_up<sham_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_sham_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    sham_res.nrem.isi.failed{p} = isi_sham_down;
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save IsiShamOnDownStates.mat sham_res effect_periods binsize_mua minDuration 










