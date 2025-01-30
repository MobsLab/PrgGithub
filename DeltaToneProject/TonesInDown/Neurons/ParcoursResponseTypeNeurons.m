%%ParcoursResponseTypeNeurons
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
    
    clearvars -except Dir p resp_res
    
    resp_res.path{p}   = Dir.path{p};
    resp_res.manipe{p} = Dir.manipe{p};
    resp_res.name{p}   = Dir.name{p};
    resp_res.date{p}   = Dir.date{p};

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
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
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
    intwindow = 4000;
    aftDown = intervalSet(end_down, end_down+intwindow);
    befDown = intervalSet(st_down-intwindow,st_down);
    %ripples in and out down states
    Epoch1 = CleanUpEpoch(up_PFCx-aftDown);
    Epoch2 = CleanUpEpoch(Epoch1-befDown);

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
    resp_res.MatRipples{p} = MatRipples;

    %no down bef Ripples
    MatRipplesBef = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipplesBefCorr), Range(S{i}),binsize_cc,nbins_cc);
        MatRipplesBef = [MatRipplesBef ; C'];
    end
    resp_res.MatRipplesBef{p} = MatRipplesBef;
    
    %no down around Ripples
    MatRipplesCorr = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipplesCorr), Range(S{i}),binsize_cc,nbins_cc);
        MatRipplesCorr = [MatRipplesCorr ; C'];
    end
    resp_res.MatRipplesCorr{p} = MatRipplesCorr;
    

    %Tones Up>Up
    MatTonesUpUP = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneUpUp), Range(S{i}),binsize_cc,nbins_cc);
        MatTonesUpUP = [MatTonesUpUP ; C'];
    end
    resp_res.MatTonesUpUP{p} = MatTonesUpUP;

    %Tones Up>Down
    MatTonesUpDown = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneUpDown), Range(S{i}),binsize_cc,nbins_cc);
        MatTonesUpDown = [MatTonesUpDown ; C'];
    end
    resp_res.MatTonesUpDown{p} = MatTonesUpDown;

    %Tones Down>Up
    MatTonesDownUp = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneDownUp), Range(S{i}),binsize_cc,nbins_cc);
        MatTonesDownUp = [MatTonesDownUp ; C'];
    end
    resp_res.MatTonesDownUp{p} = MatTonesDownUp;

    
    %Transition Down>Up
    MatTransitDownUp = [];
    for i=1:length(S)
        % PETH in Wake
        jittervalues = randi(100,length(st_up),1) - 50;
        [C,B] = CrossCorr(st_up+jittervalues, Range(S{i}),binsize_cc,nbins_cc);
        MatTransitDownUp = [MatTransitDownUp ; C'];
    end
    resp_res.MatTransitDownUp{p} = MatTransitDownUp;
    
    %Transition Up>Down
    MatTransitUpDown = [];
    for i=1:length(S)
        % PETH in Wake
        jittervalues = randi(100,length(st_down),1) - 50;
        [C,B] = CrossCorr(st_down+jittervalues, Range(S{i}),binsize_cc,nbins_cc);
        MatTransitUpDown = [MatTransitUpDown ; C'];
    end
    resp_res.MatTransitUpDown{p} = MatTransitUpDown;
    
    resp_res.t_corr{p} = B;


    %% Neuron info
    resp_res.InfoNeuronClass{p} = InfoNeurons.putative(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
    resp_res.InfoNeuronLayer{p} = InfoNeurons.layer(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
    resp_res.InfoNeuronFR{p} = InfoNeurons.firingrate(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);

end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursResponseTypeNeurons.mat resp_res binsize_cc nbins_cc intv_success_down intv_success_up


