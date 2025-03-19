% IsiTonesOnDownStates
% 19.07.2019 KJ
%
% Look at the effect of tones on the Intervals between down states
%
%


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
    
    tones_n2 = Range(ToneUpN2);
    tones_n3 = Range(ToneUpN3);
    tones_nrem = Range(ToneUpNREM);
    
    IntvTransitN2  = intervalSet(Range(ToneUpN2)+range_up(1), Range(ToneUpN2)+range_up(2));
    IntvTransitN3  = intervalSet(Range(ToneUpN3)+range_up(1), Range(ToneUpN3)+range_up(2));
    IntvTransitNREM  = intervalSet(Range(ToneUpNREM)+range_up(1), Range(ToneUpNREM)+range_up(2));
    
    tones_res.n2.nb_tones{p} = length(ToneUpN2);
    tones_res.n3.nb_tones{p} = length(ToneUpN3);
    tones_res.nrem.nb_tones{p} = length(ToneUpNREM);
    
    %% Success to create a transition
    
    %N2
    intv = [Start(IntvTransitN2) End(IntvTransitN2)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n2.success{p} = tones_n2(intervals);
    tones_res.n2.failed{p} = tones_n2(setdiff(1:length(tones_n2),intervals));
    
    %N3
    intv = [Start(IntvTransitN3) End(IntvTransitN3)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.n3.success{p} = tones_n3(intervals);
    tones_res.n3.failed{p} = tones_n3(setdiff(1:length(tones_n3),intervals));
    
    %NREM
    intv = [Start(IntvTransitNREM) End(IntvTransitNREM)];
    [~,intervals,~] = InIntervals(end_up, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    tones_res.nrem.success{p} = tones_nrem(intervals);
    tones_res.nrem.failed{p} = tones_nrem(setdiff(1:length(tones_nrem),intervals));

    
    %% ISI with tones
    
    %N2 success
    tones_tmp = tones_res.n2.success{p};
    isi_tones_down = nan(length(tones_tmp),3);
    for t=1:length(tones_tmp)
        next_down = st_down(find(st_down>tones_tmp(t), 3));
        prev_up = st_up(find(st_up<tones_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_tones_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    tones_res.n2.isi.success{p} = isi_tones_down;
    %N2 failed
    tones_tmp = tones_res.n2.failed{p};
    isi_tones_down = nan(length(tones_tmp),3);
    for t=1:length(tones_tmp)
        next_down = st_down(find(st_down>tones_tmp(t), 3));
        prev_up = st_up(find(st_up<tones_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_tones_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    tones_res.n2.isi.failed{p} = isi_tones_down;
    
    %N3 success
    tones_tmp = tones_res.n3.success{p};
    isi_tones_down = nan(length(tones_tmp),3);
    for t=1:length(tones_tmp)
        next_down = st_down(find(st_down>tones_tmp(t), 3));
        prev_up = st_up(find(st_up<tones_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_tones_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    tones_res.n3.isi.success{p} = isi_tones_down;
    %N3 failed
    tones_tmp = tones_res.n3.failed{p};
    isi_tones_down = nan(length(tones_tmp),3);
    for t=1:length(tones_tmp)
        next_down = st_down(find(st_down>tones_tmp(t), 3));
        prev_up = st_up(find(st_up<tones_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_tones_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    tones_res.n3.isi.failed{p} = isi_tones_down;
    
    %NREM success
    tones_tmp = tones_res.nrem.success{p};
    isi_tones_down = nan(length(tones_tmp),3);
    for t=1:length(tones_tmp)
        next_down = st_down(find(st_down>tones_tmp(t), 3));
        prev_up = st_up(find(st_up<tones_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_tones_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    tones_res.nrem.isi.success{p} = isi_tones_down;
    %NREM failed
    tones_tmp = tones_res.nrem.failed{p};
    isi_tones_down = nan(length(tones_tmp),3);
    for t=1:length(tones_tmp)
        next_down = st_down(find(st_down>tones_tmp(t), 3));
        prev_up = st_up(find(st_up<tones_tmp(t), 1, 'last'));
        for i=1:3
            try
                isi_tones_down(t,i)= next_down(i) - prev_up;
            end
        end
    end
    tones_res.nrem.isi.failed{p} = isi_tones_down;
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save IsiTonesOnDownStates.mat tones_res effect_periods binsize_mua minDuration 










