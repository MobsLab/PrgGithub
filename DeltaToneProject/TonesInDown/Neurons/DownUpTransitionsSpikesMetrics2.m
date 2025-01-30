%%DownUpTransitionsSpikesMetrics2
% 25.07.2018 KJ
%
%   Compute metrics on the transitions from Down to Up
%   - center of mass
%   - first spike
%
% see
%   PethNeuronsAtTransitions_KJ DownUpTransitionsSpikesMetrics1_Plot
%


clear

Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p metrics_res
    
    metrics_res.path{p}   = Dir.path{p};
    metrics_res.manipe{p} = Dir.manipe{p};
    metrics_res.name{p}   = Dir.name{p};
    metrics_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize_mua = 2;
    minDuration = 40;
    intv_success_up = 500; %50ms
    intvDur = 5000; % 500ms
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
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
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
    metrics_res.firingrate{p} = firingrate;
    

    %% Transitions
    ToneNREM = Restrict(ToneEvent, SWSEpoch);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    
    %Endogeneous and Induced Up
    intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
    [status,~,~] = InIntervals(st_up, intv_post_tones);
    UpEndo = subset(up_PFCx, find(~status));
    UpIndu = subset(up_PFCx, find(status));
    
    
    %% Cross corr
    for i=1:length(S)
        
        %Tones down>up
        [Ccindu{i}, Tindu] = CrossCorr(Start(UpIndu), Range(PoolNeurons(S,i)),2,300);

        %Endo
        [Ccendo{i}, Tendo] = CrossCorr(Start(UpEndo), Range(PoolNeurons(S,i)),2,300);
    end
    
    metrics_res.ccindu{p} = Ccindu;
    metrics_res.ccendo{p} = Ccendo;

    metrics_res.Tindu{p} = Tindu;
    metrics_res.Tendo{p} = Tendo;
    
end


%saving data
cd(FolderDeltaDataKJ)
save DownUpTransitionsSpikesMetrics2.mat metrics_res binsize_mua minDuration intv_success_up binsize nbins


