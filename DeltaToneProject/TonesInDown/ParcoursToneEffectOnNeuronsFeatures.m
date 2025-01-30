%%ParcoursToneEffectOnNeuronsFeatures
% 21.06.2018 KJ
%
%
% see
%   ParcoursToneEffectOnNeurons ToneEffectOnNeurons
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p effect_res
    
    effect_res.path{p}   = Dir.path{p};
    effect_res.manipe{p} = Dir.manipe{p};
    effect_res.name{p}   = Dir.name{p};
    effect_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2;
    minDuration = 40;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);

    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %duration
    load('IdFigureData2.mat', 'night_duration')
    Allnight = intervalSet(0,night_duration);
    
    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    
    %ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    
    
    %% Tones
    ToneNREM = Restrict(ToneEvent, SWSEpoch);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    ToneUp   = Restrict(ToneNREM, up_PFCx);

    % Up to Down ?
    intv_post_tones = [Range(ToneUp) Range(ToneUp)+intv_success_down];
    [~,intervals,~] = InIntervals(st_down, intv_post_tones);
    intervals = unique(intervals); intervals(intervals==0)=[];
    ToneUpDown = subset(ToneUp, intervals);
    ToneUpUp = subset(ToneUp, setdiff(1:length(ToneUp), intervals));

    
    %% Create sham
    nb_sham=4000;
    sham_tmp = [];
    for i=1:nb_sham
        timetone = randsample(tones_tmp, 1);
        sham_tmp = [sham_tmp;timetone + (rand-0.5)*4e4];
    end
    sham_tmp = sort(sham_tmp);
    
    
    %% spikes
    load('SpikeData.mat', 'neuronsLayers','S')
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    NumNeurons = number;
    neuronsLayers = neuronsLayers(NumNeurons);
    S = S(NumNeurons);
    

    %% correlo
    
    %Tones & Ripples
    for i=1:length(S)
        
        firingrate(i) = (length(Restrict(S{i},SWSEpoch))/tot_length(SWSEpoch)) *1e4; %in Hz

        %all tones BASELINE
        [CT, ~] = CrossCorr(tones_tmp, Range(PoolNeurons(S,i)),10,400);
        baseline = CT(1:90);
        
        %tones up>down
        [CcFeat.updown(i,:), xtones.updown] = CrossCorr(Range(ToneUpDown), Range(PoolNeurons(S,i)),10,100);
        CcFeat.updown(i,:) = (CcFeat.updown(i,:) - mean(baseline)) / std(baseline);
        
        %tones up>up
        [CcFeat.upup(i,:), xtones.upup] = CrossCorr(Range(ToneUpUp), Range(PoolNeurons(S,i)),10,100);
        CcFeat.upup(i,:) = (CcFeat.upup(i,:) - mean(baseline)) / std(baseline);
        
        %tones down
        [CcFeat.down(i,:), xtones.down] = CrossCorr(Range(ToneDown), Range(PoolNeurons(S,i)),10,100);
        CcFeat.down(i,:) = (CcFeat.down(i,:) - mean(baseline)) / std(baseline);
        
        %tones ripples
        [CcFeat.ripples(i,:), xtones.ripples] = CrossCorr(Range(RipplesEvent), Range(PoolNeurons(S,i)),10,100);
        CcFeat.ripples(i,:) = (CcFeat.ripples(i,:) - mean(baseline)) / std(baseline);

    end
    
    %Sham
    for i=1:length(S)

        %all tones
        [CT, ~] = CrossCorr(sham_tmp, Range(PoolNeurons(S,i)),10,400);
        baselinesham = CT(1:50);

        %all tones
        [Ccsham(i,:), xsham] = CrossCorr(sham_tmp, Range(PoolNeurons(S,i)),10,100);
        Ccsham(i,:) = (Ccsham(i,:) -mean(baselinesham)) / std(baselinesham);

    end

    
    %% save
    effect_res.firingrate{p} = firingrate;
    effect_res.ccfeat{p}     = CcFeat;
    effect_res.ccsham{p}     = Ccsham;
    effect_res.baseline{p}   = baseline;
    effect_res.nb_neurons{p} = length(NumNeurons);

end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursToneEffectOnNeuronsFeatures.mat effect_res binsize_mua minDuration intv_success_down intv_success_up





