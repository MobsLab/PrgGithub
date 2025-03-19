%%PethNeuronsAtTransitions_KJ
% 29.06.2018 KJ
%
%
%   Look at the response of neurons on transitions
%
% see
%   AssessToneEffectMUAtype 
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
    
    clearvars -except Dir p peth_res
    
    peth_res.path{p}   = Dir.path{p};
    peth_res.manipe{p} = Dir.manipe{p};
    peth_res.name{p}   = Dir.name{p};
    peth_res.date{p}   = Dir.date{p};


    %% init
    %params
    binsize = 2;
    nbins = 100;
    t_end = 2500; %250ms
    binsize_mua = 2;
    minDuration = 40;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms

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
    

    %% responding neurons
    Cdiff = Ctones.out - Csham;
    Ct_std = std(Ctones.out,[],2);
    idt = xtones.out>0 & xtones.out<100;

    for i=1:length(neuronsLayers)
        effect_peak(i,1) = max(Cdiff(i,idt));
        effect_mean(i,1) = mean(Cdiff(i,idt));
        
        t_peak(i,1) = max(Ctones.out(i,idt));
        t_mean(i,1) = mean(Ctones.out(i,idt));
    end

    idn_excit = effect_peak>4 & t_peak>3*Ct_std;
    idn_inhib = effect_mean<-1 & t_mean <-1;
    idn_neutral = (effect_mean>0 & effect_peak<3.5) & (t_mean>0 & t_peak<3*Ct_std);
    
    responses = nan(length(NumNeurons),1);
    responses(idn_excit) = 1;
    responses(idn_inhib) = -1;
    responses(idn_neutral) = 0;
    
    excited_neurons = NumNeurons(responses==1);
    neutral_neurons = NumNeurons(responses==0);
    inhibit_neurons = NumNeurons(responses==-1);


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

    
    %% Tones
    ToneNREM = Restrict(ToneEvent, SWSEpoch);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    ToneUp   = Restrict(ToneNREM, up_PFCx);
    
    % Down to Up ?
    intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
    [~,intervals,~] = InIntervals(st_up, intv_post_tones);
    intervals = unique(intervals); intervals(intervals==0)=[];
    ToneDownUp = subset(ToneDown, intervals);
    ToneDownDown = subset(ToneDown, setdiff(1:length(ToneDown), intervals));
    % Up to Down ?
    intv_post_tones = [Range(ToneUp) Range(ToneUp)+intv_success_down];
    [~,intervals,~] = InIntervals(st_down, intv_post_tones);
    intervals = unique(intervals); intervals(intervals==0)=[];
    ToneUpDown = subset(ToneUp, intervals);
    ToneUpUp = subset(ToneUp, setdiff(1:length(ToneUp), intervals));
    

    %% Transitions
    
    %Endogeneous and Induced Down
    intv_post_tones = [Range(ToneUp) Range(ToneUp)+intv_success_down];
    [status,~,~] = InIntervals(st_down, intv_post_tones);
    DownEndo = subset(down_PFCx, find(~status));
    DownIndu = subset(down_PFCx, find(status));
    
    %Endogeneous and Induced Up
    intv_post_tones = [Range(ToneDown) Range(ToneDown)+intv_success_up];
    [status,~,~] = InIntervals(st_up, intv_post_tones);
    UpEndo = subset(up_PFCx, find(~status));
    UpIndu = subset(up_PFCx, find(status));
    
    
    %% PETH
    
    warning off
    for i=1:length(S)
        disp(i)
        [speth.indu.y{i}, SM, speth.indu.x{i}, center, R] = PETH_KJ(Range(S{i}), Start(UpIndu), binsize, nbins);
        [speth.endo.y{i}, SM, speth.endo.x{i}, center, R] = PETH_KJ(Range(S{i}), Start(UpEndo), binsize, nbins);
    end
    warning on
    
    peth_res.speth{p} = speth;
    
end


%saving data
cd(FolderDeltaDataKJ)
save PethNeuronsAtTransitions_KJ.mat peth_res binsize_mua binsize nbins t_end minDuration intv_success_down intv_success_up


