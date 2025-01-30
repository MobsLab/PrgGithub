%%FiguresRipplesInUpCorrectedPerRecord
% 18.06.2018 KJ
%
%   same as FiguresRipplesInUpPerRecord, but corrected with no down
%   states before
%
%
% see
%   FiguresTonesInUpPerRecord FiguresRipplesInUpPerRecord
%


clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);

sham_distrib = 1;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p figure_res sham_res sham_distrib
    
    figure_res.path{p}   = Dir.path{p};
    figure_res.manipe{p} = Dir.manipe{p};
    figure_res.name{p}   = Dir.name{p};
    figure_res.date{p}   = Dir.date{p};

   
    %params
    binsize_mua = 2;
    maxDuration = 10e4;
    t_start     = -2e4; %1s
    t_end       = 2e4; %1s
    
    %SWSEpoch
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    
    %Down
    load('DownState.mat', 'down_PFCx')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    
    
    %% Ripples/Sham in or out
    intwindow = 5000;
    aftDown = intervalSet(Start(down_PFCx), End(down_PFCx)+intwindow);
    
    %ripples in and out down states
    RipplesIn = Restrict(RipplesEvent, CleanUpEpoch(up_PFCx-aftDown));
    
    %Up with or without
    intv_up = [Start(up_PFCx) End(up_PFCx)];
    [~,intv_with,~] = InIntervals(ripples_tmp, intv_up);
    intv_with = unique(intv_with);
    intv_with(intv_with==0) = [];
    
    intv_without = setdiff(1:length(Start(up_PFCx)), intv_with);
    
    UpRipples = intervalSet(intv_up(intv_with,1),intv_up(intv_with,2));
    UpNo   = intervalSet(intv_up(intv_without,1),intv_up(intv_without,2));
    
    
    %% Delay between ripples/sham and down

    %ripples in
    ripplesin_tmp = Range(RipplesIn);
    
    figure_res.ripples_bef{p} = nan(length(ripplesin_tmp), 1);
    figure_res.ripples_aft{p} = nan(length(ripplesin_tmp), 1);
    figure_res.ripples_post{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        try
            st_bef = st_up(find(st_up<ripplesin_tmp(i),1,'last'));
            figure_res.ripples_bef{p}(i) = ripplesin_tmp(i) - st_bef;
        end
        try
            end_aft = end_up(find(end_up>ripplesin_tmp(i),1));
            figure_res.ripples_aft{p}(i) = end_aft - ripplesin_tmp(i);
        end
        try
            up_post = st_up(find(st_up>ripplesin_tmp(i),1));
            figure_res.ripples_post{p}(i) = up_post - ripplesin_tmp(i);
        end
    end
    
      %% Create sham
        
    if sham_distrib %same distribution as ripples for delay(start_down,sham)
        
        st_upno = Start(UpNo);
        end_upno = End(UpNo);
        durations_no = End(UpNo)-Start(UpNo); 
        sham_tmp = [];

        delay_generated = repmat(figure_res.ripples_bef{p}, [3 1]);
        delays = delay_generated(randperm(length(delay_generated)));

        while ~isempty(delays)        
            idx = randsample(find(durations_no>delays(1)),1);
            min_tmp = st_upno(idx);
            duree  = end_upno(idx)-st_upno(idx);

            sham_tmp = [sham_tmp min_tmp+delays(1)];
            delays = delays(2:end);
        end

        shamin_tmp = sort(sham_tmp);
        ShamIn = ts(shamin_tmp);
        
    else %uniform sham
        nb_sham = 7000;
        idx = randsample(length(st_up), nb_sham);
        sham_tmp = [];
    
        for i=1:length(idx)
            min_tmp = st_up(idx(i));
            duree = end_up(idx(i))-st_up(idx(i));
            sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
        end
    end
    
    %sham in and out down states
    shamin_tmp = sort(sham_tmp);
    ShamIn = Restrict(ts(shamin_tmp), CleanUpEpoch(up_PFCx-aftDown));
    shamin_tmp = Range(ShamIn);
    
    
    %% Delay between sham and down
    
    %sham in     
    figure_res.sham_bef{p} = [];
    figure_res.sham_aft{p} = [];
    figure_res.sham_post{p} = [];
    for i=1:length(shamin_tmp)
        st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
        end_aft = end_up(find(end_up>shamin_tmp(i),1));
        up_post = st_up(find(st_up>shamin_tmp(i),1));
        
        if ~isempty(st_bef) && ~isempty(end_aft) && ~isempty(up_post) 
            figure_res.sham_bef{p}  = [figure_res.sham_bef{p}  ; shamin_tmp(i) - st_bef];
            figure_res.sham_aft{p}  = [figure_res.sham_aft{p}  ; end_aft - shamin_tmp(i)];
            figure_res.sham_post{p} = [figure_res.sham_post{p} ; up_post - shamin_tmp(i)];
        end
        
    end
    
    
    %% Rasters
    sham_res.rasters.inside{p}  = RasterMatrixKJ(MUA, ShamIn, t_start, t_end);
    
    
    %% orders
    %sham in up
    sham_res.inside.before{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.after{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postup{p} = nan(length(shamin_tmp), 1);
    sham_res.inside.postdown{p} = nan(length(shamin_tmp), 1);
    
    for i=1:length(shamin_tmp)     
        try
            st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
            sham_res.inside.before{p}(i) = shamin_tmp(i) - st_bef;
        end
        try
            end_aft = end_up(find(end_up>shamin_tmp(i),1));
            sham_res.inside.after{p}(i) = end_aft - shamin_tmp(i);
        end
        try
            up_post = st_up(find(st_up>shamin_tmp(i),1));
            sham_res.inside.postup{p}(i) = up_post - shamin_tmp(i);
        end
        try
            down_post = st_down(find(st_down>shamin_tmp(i),1));
            sham_res.inside.postdown{p}(i) = down_post - shamin_tmp(i);
        end
    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save FiguresRipplesInUpCorrectedPerRecord.mat figure_res sham_res binsize_mua maxDuration sham_distrib
if sham_distrib
    save FiguresRipplesInUpCorrectedPerRecord_2.mat figure_res sham_res binsize_mua maxDuration sham_distrib
else
    save FiguresRipplesInUpCorrectedPerRecord.mat figure_res sham_res binsize_mua maxDuration sham_distrib
end

