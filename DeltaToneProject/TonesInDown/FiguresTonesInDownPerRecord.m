%%FiguresTonesInDownPerRecord
% 06.04.2018 KJ
%
%
%
%
% see
%   ToneDuringDownStateEffect EndOfDownDeltaToneInside
%   DistribShamvsToneInDown FiguresTonesInDownPerRecordPlot
%


clear

Dir = PathForExperimentsRandomTonesSpikes;

sham_distrib = 0;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p figure_res sham_distrib
    
    figure_res.path{p}   = Dir.path{p};
    figure_res.manipe{p} = Dir.manipe{p};
    figure_res.name{p}   = Dir.name{p};
    figure_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDuration = 20;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    tones_tmp = Range(ToneEvent);
    
    
    %% Tones in or out
    intwindow = 4000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA)));
    ToneIn = Restrict(ToneEvent, down_PFCx);
    ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));
    
    %Down with or without
    intv_down = [Start(down_PFCx) End(down_PFCx)];
    [~,intv_with,~] = InIntervals(tones_tmp, intv_down);
    intv_with = unique(intv_with);
    intv_with(intv_with==0) = [];
    
    intv_without = setdiff(1:length(Start(down_PFCx)), intv_with);
    
    DownTone = intervalSet(intv_down(intv_with,1),intv_down(intv_with,2));
    DownNo   = intervalSet(intv_down(intv_without,1),intv_down(intv_without,2));
    
    
    %% Delay between tones and down

    %tones in
    tonesin_tmp = Range(ToneIn);
    
    figure_res.tones_bef{p} = nan(length(tonesin_tmp), 1);
    figure_res.tones_aft{p} = nan(length(tonesin_tmp), 1);
    figure_res.tones_post{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        figure_res.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        figure_res.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
        
        down_post = st_down(find(st_down>tonesin_tmp(i),1));
        figure_res.tones_post{p}(i) = down_post - tonesin_tmp(i);
    end
    
    
    %% Create Sham 
    nb_sham = 3000;
    idx = randsample(length(st_down), nb_sham);
    sham_tmp = [];
        
    if sham_distrib %same distribution as tones for delay(start_down,sham)

        %distribution
        edges_delay = 0:50:4000;
        [y_distrib, x_distrib] = histcounts(figure_res.tones_bef{p}, edges_delay, 'Normalization','probability');
        x_distrib = x_distrib(1:end-1) + diff(x_distrib);
        delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);

        for i=1:length(idx)
            min_tmp = st_down(idx(i));
            duree  = end_down(idx(i))-st_down(idx(i));
            delays = randsample(delay_generated,1);

            if delays<duree
                sham_tmp = [sham_tmp min_tmp+delays];
            end
        end
    
    else %uniform sham
        for i=1:length(idx)
            min_tmp = st_down(idx(i));
            duree = end_down(idx(i))-st_down(idx(i));
            sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
        end
    end
    
    shamin_tmp = sort(sham_tmp);
    ShamIn = ts(shamin_tmp);
    
    
    %% Delay between sham and down
    figure_res.sham_bef{p} = nan(length(shamin_tmp), 1);
    figure_res.sham_aft{p} = nan(length(shamin_tmp), 1);
    figure_res.sham_post{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        figure_res.sham_bef{p}(i) = shamin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>shamin_tmp(i),1));
        figure_res.sham_aft{p}(i) = end_aft - shamin_tmp(i);
        
        down_post = st_down(find(st_down>shamin_tmp(i),1));
        figure_res.sham_post{p}(i) = down_post - shamin_tmp(i);
    end
    
    
    %% MUA response for tones & sham
    
    % In down
    [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    figure_res.met_inside{p}(:,1) = tps; figure_res.met_inside{p}(:,2) = m;
    figure_res.nb_inside{p} = length(ToneIn);
    % out of down
    [m,~,tps] = mETAverage(Range(ToneOut), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    figure_res.met_out{p}(:,1) = tps; figure_res.met_out{p}(:,2) = m;
    figure_res.nb_out{p} = length(ToneOut);
    %sham in
    [m,~,tps] = mETAverage(Range(ShamIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    figure_res.met_shamin{p}(:,1) = tps; figure_res.met_shamin{p}(:,2) = m;
    figure_res.nb_shamin{p} = length(ToneOut);
    
    
    %% MUA response to the end of down states
    % with
    [m,~,tps] = mETAverage(End(DownTone), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    figure_res.met_with{p}(:,1) = tps; figure_res.met_with{p}(:,2) = m;
    figure_res.nb_with{p} = length(End(DownTone));
    
    % without
    [m,~,tps] = mETAverage(End(DownNo), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    figure_res.met_without{p}(:,1) = tps; figure_res.met_without{p}(:,2) = m;
    figure_res.nb_without{p} = length(End(DownNo));
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
if sham_distrib
    save FiguresTonesInDownPerRecord_2.mat figure_res sham_distrib binsize_met nbBins_met binsize_mua minDuration intwindow nb_sham
else
    save FiguresTonesInDownPerRecord.mat figure_res sham_distrib binsize_met nbBins_met binsize_mua minDuration intwindow nb_sham
end


