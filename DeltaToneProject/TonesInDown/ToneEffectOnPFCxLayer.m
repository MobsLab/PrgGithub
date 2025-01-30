%%ToneEffectOnPFCxLayer
% 12.04.2018 KJ
%
%
%
%
% see
%   ToneDuringDownStateEffect EndOfDownDeltaToneInside
%   DistribShamvsToneInDown FiguresTonesInDownPerRecordPlot
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

sham_distrib = 1;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res sham_distrib
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDuration = 40;
    
    %MUA & Down
    MUA_all = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua, 'depth',1); %2mS

    down_PFCx = FindDownKJ(MUA_all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);

    
    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = sort(TONEtime2 + Dir.delay{p}*1E4);
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);
    
    
    %% Tones in or out
    intwindow = 4000;
    aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

    %tones in and out down states
    Allnight = intervalSet(0,max(Range(MUA_all)));
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
    
    tones_res.tones_bef{p} = nan(length(tonesin_tmp), 1);
    tones_res.tones_aft{p} = nan(length(tonesin_tmp), 1);
    for i=1:length(tonesin_tmp)
        st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
        tones_res.tones_bef{p}(i) = tonesin_tmp(i) - st_bef;
        
        end_aft = end_down(find(end_down>tonesin_tmp(i),1));
        tones_res.tones_aft{p}(i) = end_aft - tonesin_tmp(i);
    end
    
    
    %% Create Sham 
    nb_sham = 3000;
    idx = randsample(length(st_down), nb_sham);
    sham_tmp = [];
        
    if sham_distrib %same distribution as tones for delay(start_down,sham)

        %distribution
        edges_delay = 0:50:4000;
        [y_distrib, x_distrib] = histcounts(tones_res.tones_bef{p}, edges_delay, 'Normalization','probability');
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
    
    
    %% MUA response for tones & sham
    
    for i=1:length(MUA)
        if isempty(MUA{i})
            continue
        end

        % In down
        [m,~,tps] = mETAverage(Range(ToneIn), Range(MUA{i}), Data(MUA{i}), binsize_met, nbBins_met);
        tones_res.met_inside{p,i}(:,1) = tps; tones_res.met_inside{p,i}(:,2) = m;
        tones_res.nb_inside{p,i} = length(ToneIn);
        % out of down
        [m,~,tps] = mETAverage(Range(ToneOut), Range(MUA{i}), Data(MUA{i}), binsize_met, nbBins_met);
        tones_res.met_out{p,i}(:,1) = tps; tones_res.met_out{p,i}(:,2) = m;
        tones_res.nb_out{p,i} = length(ToneOut);
        %sham in
        [m,~,tps] = mETAverage(Range(ShamIn), Range(MUA{i}), Data(MUA{i}), binsize_met, nbBins_met);
        tones_res.met_shamin{p,i}(:,1) = tps; tones_res.met_shamin{p,i}(:,2) = m;
        tones_res.nb_shamin{p,i} = length(ToneOut);


        %% MUA response to the end of down states
        % with
        [m,~,tps] = mETAverage(End(DownTone), Range(MUA{i}), Data(MUA{i}), binsize_met, nbBins_met);
        tones_res.met_with{p,i}(:,1) = tps; tones_res.met_with{p,i}(:,2) = m;
        tones_res.nb_with{p,i} = length(End(DownTone));

        % without
        [m,~,tps] = mETAverage(End(DownNo), Range(MUA{i}), Data(MUA{i}), binsize_met, nbBins_met);
        tones_res.met_without{p,i}(:,1) = tps; tones_res.met_without{p,i}(:,2) = m;
        tones_res.nb_without{p,i} = length(End(DownNo));

    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save ToneEffectOnPFCxLayer.mat tones_res sham_distrib binsize_met nbBins_met binsize_mua minDuration intwindow nb_sham



