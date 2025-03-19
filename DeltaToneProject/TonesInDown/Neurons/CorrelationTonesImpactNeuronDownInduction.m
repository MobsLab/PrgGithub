%%CorrelationTonesImpactNeuronDownInduction
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

    
    %neuron info
    load('InfoNeuronsPFCx.mat', 'MatInfoNeurons', 'InfoNeurons')
    load('SpikeData.mat', 'S')
    
    % tones
    load('behavResources.mat', 'ToneEvent')
    
    % ripples
    load('Ripples.mat', 'Ripples')
    tRipples = ts(Ripples(:,2)*10);

    %substages
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')
    
    % info on neurons in InfoNeuronsPFCx.mat
    load('InfoNeuronsPFCx.mat', 'InfoNeurons')
    NumNeurons = InfoNeurons.NumNeurons; % same as above
    S = S(NumNeurons);

    
    %% firing rate
    fr = InfoNeurons.firingrate; % firing rate of each neurons of S_pfc
    layer = InfoNeurons.layer; % putative layer of each neurons of S_pfc
    putative = InfoNeurons.putative; % int or pyr (>0 for pyramidal, and negative for interneurons - this the probability given by Sophie)
    soloist = InfoNeurons.soloist; % soloïst or chorist (0 for chorist, 1 for soloïst)
    prefered_substages = InfoNeurons.substages; % prefered substages, if any (0 if none)
    
    
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
    
    
    %% Ripples
    RipplesNREM = Restrict(tRipples, SWSEpoch);
    RipplesDown = Restrict(RipplesNREM, down_PFCx);
    RipplesUp   = Restrict(RipplesNREM, up_PFCx);
    
    % Down to Up ?
    intv_post_rip = [Range(RipplesDown) Range(RipplesDown)+intv_success_up];
    [~,intervals,~] = InIntervals(st_up, intv_post_rip);
    intervals = unique(intervals); intervals(intervals==0)=[];
    RipplesDownUp = subset(RipplesDown, intervals);
    RipplesDownDown = subset(RipplesDown, setdiff(1:length(RipplesDown), intervals));
    % Up to Down ?
    intv_post_rip = [Range(RipplesUp) Range(RipplesUp)+intv_success_down];
    [~,intervals,~] = InIntervals(st_down, intv_post_rip);
    intervals = unique(intervals); intervals(intervals==0)=[];
    RipplesUpDown = subset(RipplesUp, intervals);
    RipplesUpUp = subset(RipplesUp, setdiff(1:length(RipplesUp), intervals));
    
    
    %% Cross correlogram
    
    for i=1:length(S)
        
        figure, hold on
        
        % up
        subplot(2,2,1), hold on
        [C,B] = CrossCorr(Range(ToneUpDown),Range(S{i}),10,100);
        h(1) = plot(B, Smooth(C,1), 'color','b');
        [C,B] = CrossCorr(Range(ToneUpUp),Range(S{i}),10,100);
        h(2) = plot(B, Smooth(C,1), 'color','r');
        line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
        legend(h, 'up>down', 'up>up');
        title('tones in Up'),

        % down
        subplot(2,2,2), hold on
        [C,B] = CrossCorr(Range(ToneDownUp),Range(S{i}),10,100);
        h(1) = plot(B, Smooth(C,1), 'color','b');
        [C,B] = CrossCorr(Range(ToneDownDown),Range(S{i}),10,100);
        h(2) = plot(B, Smooth(C,1), 'color','r');
        line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
        legend(h, 'down>up', 'down>down');
        title('tones in Down'),

        % up
        subplot(2,2,3), hold on
        [C,B] = CrossCorr(Range(RipplesUpDown),Range(S{i}),10,100);
        h(1) = plot(B, Smooth(C,1), 'color','b');
        [C,B] = CrossCorr(Range(RipplesUpUp),Range(S{i}),10,100);
        h(2) = plot(B, Smooth(C,1), 'color','r');
        line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
        legend(h, 'down>up', 'down>down');
        title('Ripples in up'),
        
        % down
        subplot(2,2,4), hold on
        [C,B] = CrossCorr(Range(RipplesDownUp),Range(S{i}),10,100);
        h(1) = plot(B, Smooth(C,1), 'color','b');
        [C,B] = CrossCorr(Range(RipplesDownDown),Range(S{i}),10,100);
        h(2) = plot(B, Smooth(C,1), 'color','r');
        line([0 0], get(gca,'ylim'), 'color', [0.7 0.7 0.7]),
        legend(h, 'down>up', 'down>down');
        title('Ripples in Down'),
        
        
        %% title
        title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' (neuron '  num2str(i) ')'];
        title_fig = [title_fig ' fr= ' num2str(round(fr(i),2)) 'Hz / layer ' num2str(layer(i))];
        if putative(i)>0
            title_fig = [title_fig ' / pyr '];
        else
            title_fig = [title_fig ' / int '];
        end
        if soloist(i)
            title_fig = [title_fig ' / soloist '];
        end
        
        filename_fig = ['ResponseNeurons_' Dir.name{p}  '_' Dir.date{p} '_neuron_' num2str(i)];
        filename_png = [filename_fig  '.png'];
        % suptitle
        suplabel(title_fig,'t');
        %save figure
        filename_png = fullfile(FolderFigureDelta,'IDfigures','TonesInDown','Neurons',filename_png);
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
        
        
    end
    
    
end





