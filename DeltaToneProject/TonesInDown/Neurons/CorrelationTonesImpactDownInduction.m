%%CorrelationTonesImpactDownInduction
% 11.09.2018 KJ
%
%
%   
%
% see
%   
%


clear

Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);


for p=1:4%length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    
    %% init
    %params
    binsize_mua = 2;
    minDuration = 40;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms
    binsize_met = 2;
    nbBins_met  = 400;

    %tone impact
    load('TonePeth.mat', 'MatPeth')
    load(fullfile(FolderDeltaDataKJ, 'neuronResponseTones.mat'), 'responses')
    
    try
        excited_neurons = find(responses.Big{p}==1);
    catch
        excited_neurons = find(responses.N2{p}==1 & responses.N3{p}==1);
    end
    inhibit_neurons = find(responses.N2{p}==-1 | responses.N3{p}==-1 | responses.Up{p}==-1);
    
    neutral_neurons = setdiff(1:length(responses.N2{p}), sort([excited_neurons;inhibit_neurons]));
    
    %neuron info
    load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')
    load('SpikeData.mat', 'S')
    
    % tones
    load('behavResources.mat', 'ToneEvent')

    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    
    
    %% MUA

    %MUA
    MUA.all  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    MUA.excited = GetMuaNeurons_KJ(excited_neurons, 'binsize',binsize_mua); 
    MUA.neutral = GetMuaNeurons_KJ(neutral_neurons, 'binsize',binsize_mua);
    MUA.inhibit = GetMuaNeurons_KJ(inhibit_neurons, 'binsize',binsize_mua);

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
    
    
    %% Cross correlogram
    
    figure, hold on
    
    
    % all
    subplot(2,2,1), hold on
    [m,sem,tps] = mETAverage(Range(ToneUpDown), Range(MUA.all), Data(MUA.all), binsize_met, nbBins_met);
    h(1) = plot(tps, m, 'color','b');
    [m,sem,tps] = mETAverage(Range(ToneUpUp), Range(MUA.all), Data(MUA.all), binsize_met, nbBins_met);
    h(2) = plot(tps, m, 'color','r');
    line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
    legend(h, 'success', 'failed');
    title('all neurons'),
    
    % excited
    subplot(2,2,2), hold on
    [m,sem,tps] = mETAverage(Range(ToneUpDown), Range(MUA.excited), Data(MUA.excited), binsize_met, nbBins_met);
    h(1) = plot(tps, m, 'color','b');
    [m,sem,tps] = mETAverage(Range(ToneUpUp), Range(MUA.excited), Data(MUA.excited), binsize_met, nbBins_met);
    h(2) = plot(tps, m, 'color','r');
    line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
    legend(h, 'success', 'failed');
    title('excited neurons'),
    
    % neutral
    subplot(2,2,3), hold on
    [m,sem,tps] = mETAverage(Range(ToneUpDown), Range(MUA.neutral), Data(MUA.neutral), binsize_met, nbBins_met);
    h(1) = plot(tps, m, 'color','b');
    [m,sem,tps] = mETAverage(Range(ToneUpUp), Range(MUA.neutral), Data(MUA.neutral), binsize_met, nbBins_met);
    h(2) = plot(tps, m, 'color','r');
    line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
    legend(h, 'success', 'failed');
    title('neutral neurons'),
    
    % inhibit
    subplot(2,2,4), hold on
    [m,sem,tps] = mETAverage(Range(ToneUpDown), Range(MUA.inhibit), Data(MUA.inhibit), binsize_met, nbBins_met);
    h(1) = plot(tps, m, 'color','b');
    [m,sem,tps] = mETAverage(Range(ToneUpUp), Range(MUA.inhibit), Data(MUA.inhibit), binsize_met, nbBins_met);
    h(2) = plot(tps, m, 'color','r');
    line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
    legend(h, 'success', 'failed');
    title('inhibit neurons'),
    
    
    figure, hold on
    for i=1:length(excited_neurons)
        subplot(1,2,1), hold on
        [C,B] = CrossCorr(Range(ToneUpUp),Range(S{excited_neurons(i)}),10,100);
        plot(B/1E3,C,'k'), hold on
        subplot(1,2,2), hold on
        [C,B] = CrossCorr(Range(ToneUpDown),Range(S{excited_neurons(i)}),10,100);
        plot(B/1E3,C,'k'), hold on
        
    end
    
    
end





