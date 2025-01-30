%%ResponseOfInterPyr
% 08.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   FigNeuronsPutativeResponse3 ParcoursRipplesNeuronCrossCorr
%



clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaTone');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);



for p=1:length(Dir.path)

    %goto
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p

    %params
    binsize_cc = 2;
    nbins_cc = 400;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms


    %% load
    % tones
    load('behavResources.mat', 'ToneEvent')
    ToneEvent;

    %load Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('InfoNeuronsAll.mat', 'InfoNeurons')
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
    S = S(NumNeurons);

    % Substages
    load('SleepSubstages.mat', 'Epoch')
    N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
    N2N3 = or(N2,N3);

    % ripples
    load('Ripples.mat','tRipples')
    if ~exist('tRipples','var')
        load('Ripples.mat','Ripples')
        tRipples = ts(Ripples(:,2)*10);
    end

    %MUA & Down
    binsize_mua = 2;
    minDuration = 50;
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));


    %% Ripples corrected
    intwindow = 5000;
    aftDown = intervalSet(end_down, end_down+intwindow);
    befDown = intervalSet(st_down-intwindow,st_down);
    %ripples in and out down states
    Epoch1 = CleanUpEpoch(up_PFCx-befDown);
    Epoch2 = CleanUpEpoch(Epoch1-aftDown);

    tRipplesBefCorr = Restrict(tRipples, Epoch1);  
    tRipplesCorr = Restrict(tRipples, Epoch2);  


    %% Tones
    ToneNREM = Restrict(ToneEvent, NREM);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    ToneUp   = Restrict(ToneNREM, up_PFCx);

    st_up = Start(up_PFCx);
    st_down = Start(down_PFCx);

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


    %% Cross Corr

    %All Ripples
    MatRipples = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipples), Range(S{i}),binsize_cc,nbins_cc);
        MatRipples = [MatRipples ; C'];
    end
    Zripples = zscore(MatRipples,[],2);

    %no down bef Ripples
    MatRipplesBef = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipplesBefCorr), Range(S{i}),binsize_cc,nbins_cc);
        MatRipplesBef = [MatRipplesBef ; C'];
    end
    ZripplesBef = zscore(MatRipplesBef,[],2);

    %no down around Ripples
    MatRipplesCorr = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipplesCorr), Range(S{i}),binsize_cc,nbins_cc);
        MatRipplesCorr = [MatRipplesCorr ; C'];
    end
    ZripplesCorr = zscore(MatRipplesCorr,[],2);


    %Tones Up>Up
    MatTonesUpUP = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneUpUp), Range(S{i}),binsize_cc,nbins_cc);
        MatTonesUpUP = [MatTonesUpUP ; C'];
    end
    ZtonesUpUp = zscore(MatTonesUpUP,[],2);

    %Tones Up>Down
    MatTonesUpDown = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneUpDown), Range(S{i}),binsize_cc,nbins_cc);
        MatTonesUpDown = [MatTonesUpDown ; C'];
    end
    ZtonesUpDown = zscore(MatTonesUpDown,[],2);

    %Tones Down>Up
    MatTonesDownUp = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneDownUp), Range(S{i}),binsize_cc,nbins_cc);
        MatTonesDownUp = [MatTonesDownUp ; C'];
    end
    ZtonesDownUp = zscore(MatTonesDownUp,[],2);

    t_corr=B;


    %% Neuron info
    InfoNeuronClass = InfoNeurons.putative(strcmpi(InfoNeurons.structure,'PFCx'));
    InfoNeuronLayer = InfoNeurons.layer(strcmpi(InfoNeurons.structure,'PFCx'));
    InfoNeuronFR = InfoNeurons.firingrate(strcmpi(InfoNeurons.structure,'PFCx'));

    %class
    neuronClass{1} = find(InfoNeuronClass>0);
    neuronClass{2} = find(InfoNeuronClass<0);
    %layer
    for l=1:5
        neuronLayer{l} = find(InfoNeuronLayer==l);
    end
    %firing rate
    neuronFR{1} = find(InfoNeuronFR<=7);
    neuronFR{2} = find(InfoNeuronFR>7);


    %% Plot 1 - Int/Pyr
    colori_neur = {[0.13 0.54 0.13],'b','r','k'};
    fontsize=13;

    figure, hold on

    %response ripples
    subplot(2,3,1), hold on 

    for i=1:length(neuronClass)
        hold on, h(i) = plot(t_corr,runmean(mean(Zripples(neuronClass{i},:)),2),'color', colori_neur{i});
    end
    set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    legend(h,'pyramidal','interneuron')
    title('on ripples')

    %response ripples no down before
    subplot(2,3,2), hold on 

    for i=1:length(neuronClass)
        hold on, h(i) = plot(t_corr,runmean(mean(ZripplesBef(neuronClass{i},:)),2),'color', colori_neur{i});
    end
    set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    title('ripples no down before')

    %response ripples no down around
    subplot(2,3,3), hold on 

    for i=1:length(neuronClass)
        hold on, h(i) = plot(t_corr,runmean(mean(ZripplesCorr(neuronClass{i},:)),2),'color', colori_neur{i});
    end
    set(gca, 'xlim',[-400 400],'xticklabel',{}, 'fontsize',fontsize),
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    title('ripples no down around')


    %response tones up>up
    subplot(2,3,4), hold on 

    for i=1:length(neuronClass)
        hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpUp(neuronClass{i},:)),2),'color', colori_neur{i});
    end
    set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    title('on tones up>up')

    %response tones up>down
    subplot(2,3,5), hold on 

    for i=1:length(neuronClass)
        hold on, h(i) = plot(t_corr,runmean(mean(ZtonesUpDown(neuronClass{i},:)),2),'color', colori_neur{i});
    end
    set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    title('on tones up>down')

    %response tones down>up
    subplot(2,3,6), hold on 

    for i=1:length(neuronClass)
        hold on, h(i) = plot(t_corr,runmean(mean(ZtonesDownUp(neuronClass{i},:)),2),'color', colori_neur{i});
    end
    set(gca, 'xlim',[-400 400], 'fontsize',fontsize),
    line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7], 'linewidth',1),
    title('on tones down>up')


    suplabel([Dir.name{p} ' - ' Dir.date{p}], 't');

end




