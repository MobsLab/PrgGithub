%%DownUpTransitionsSpikesMetrics1
% 13.07.2018 KJ
%
%   Compute metrics on the transitions from Down to Up
%   - center of mass
%   - first spike
%
% see
%   PethNeuronsAtTransitions_KJ DownUpTransitionsSpikesMetrics1_Plot FirstSecondhalfNightSpikeMetrics
%   DownUpTransitionsSpikesMetrics2
%


clear

Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p transit_res
    
    transit_res.path{p}   = Dir.path{p};
    transit_res.manipe{p} = Dir.manipe{p};
    transit_res.name{p}   = Dir.name{p};
    transit_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize_mua = 2;
    minDuration = 40;
    intv_success_up = 500; %50ms
    intvDur = 8000; % 500ms
    binsize = 2;
    nbins = 100;

    %Spikes
    load('SpikeData.mat')
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    S = S(number);
    
    %tone impact
    load('NeuronTones', 'Ctones', 'xtones', 'Csham', 'xsham', 'NumNeurons', 'neuronsLayers')
    
    %neuron info
    load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    
    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    

    %% MUA

    %MUA
    MUA.all  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA.all, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %%Firingrate
    for i=1:length(S)
        firingrate(i) = (length(Restrict(S{i},SWSEpoch))/tot_length(SWSEpoch)) *1e4; %in Hz
    end
    transit_res.firingrate{p} = firingrate;
    

    %% Transitions
    ToneNREM = Restrict(ToneEvent, SWSEpoch);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    
    %Endogeneous and Induced Up
    intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
    [status,~,~] = InIntervals(st_up, intv_post_tones);
    UpEndo = subset(up_PFCx, find(~status));
    UpIndu = subset(up_PFCx, find(status));
    
    
    %% PETH
        
    warning off
    for i=1:length(S)
        [speth.indu.y{i}, ~, speth.indu.x{i}, ~, ~] = PETH_KJ(Range(S{i}), Start(UpIndu), binsize, nbins);
        [speth.endo.y{i}, ~, speth.endo.x{i}, ~, ~] = PETH_KJ(Range(S{i}), Start(UpEndo), binsize, nbins);
    end
    warning on
    
    transit_res.speth{p} = speth;
    
    
    %% Metrics    
    
    %endo
    stup_endo = Start(UpEndo);
    transit_res.endo.first{p} = nan(length(stup_endo), length(S));
    transit_res.endo.meansp{p} = nan(length(stup_endo), length(S));
    for i=1:length(stup_endo)
        if mod(i,1000)==0
           disp(i) 
        end
        for n=1:length(S)
            spik = Range(S{n});
            try
                idx = find(spik >= stup_endo(i) & spik < stup_endo(i)+intvDur);
                transit_res.endo.first{p}(i,n) = stup_endo(i) - min(spik(idx));
                transit_res.endo.meansp{p}(i,n) = stup_endo(i) - mean(spik(idx));
            end
        end
    end
    
    %indu
    stup_indu = Start(UpIndu);
    transit_res.indu.first{p} = nan(length(stup_indu), length(S));
    transit_res.indu.meansp{p} = nan(length(stup_indu), length(S));
    for i=1:length(stup_indu)
        for n=1:length(S)
            spik = Range(S{n});
            try
                idx = find(spik >= stup_indu(i) & spik < stup_indu(i)+intvDur);
                transit_res.indu.first{p}(i,n) = stup_indu(i) - min(spik(idx));
                transit_res.indu.meansp{p}(i,n) = stup_indu(i) - mean(spik(idx));
            end
            
        end
    end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save DownUpTransitionsSpikesMetrics1.mat transit_res binsize_mua minDuration intv_success_up binsize nbins


