%%ParcoursResponseRipplesTypeNeurons
% 08.01.2019 KJ
%
%
%   Look at the response of neurons to ripples/tones - PETH Cross-Corr (PLOT)
%
% see
%   ParcoursResponseTypeNeurons ParcoursRipplesNeuronCrossCorr
%




clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);



for p=1:length(Dir.path)

    %goto
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p resprip_res
    
    resprip_res.path{p}   = Dir.path{p};
    resprip_res.manipe{p} = Dir.manipe{p};
    resprip_res.name{p}   = Dir.name{p};
    resprip_res.date{p}   = Dir.date{p};

    %params
    binsize_cc = 2;
    nbins_cc = 400;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms


    %% load

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
    st_up = Start(up_PFCx);
    

    %% Ripples corrected
    intwindow = 3000;
    aftDown = intervalSet(st_down, end_down+intwindow);
    befDown = intervalSet(st_down-intwindow,st_down);
    %ripples in and out down states
    Epoch1 = CleanUpEpoch(up_PFCx-aftDown);
    Epoch2 = CleanUpEpoch(Epoch1-befDown);

    tRipplesBefCorr = Restrict(tRipples, Epoch1);  
    tRipplesCorr = Restrict(tRipples, Epoch2);  


    %% Cross Corr

    %All Ripples
    MatRipples = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipples), Range(S{i}),binsize_cc,nbins_cc);
        MatRipples = [MatRipples ; C'];
    end
    resprip_res.MatRipples{p} = MatRipples;

    %no down bef Ripples
    MatRipplesBef = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipplesBefCorr), Range(S{i}),binsize_cc,nbins_cc);
        MatRipplesBef = [MatRipplesBef ; C'];
    end
    resprip_res.MatRipplesBef{p} = MatRipplesBef;
    
    %no down around Ripples
    MatRipplesCorr = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipplesCorr), Range(S{i}),binsize_cc,nbins_cc);
        MatRipplesCorr = [MatRipplesCorr ; C'];
    end
    resprip_res.MatRipplesCorr{p} = MatRipplesCorr;
    
    %Transition Down>Up
    MatTransitDownUp = [];
    for i=1:length(S)
        % PETH in Wake
        jittervalues = randi(40,length(st_up),1) - 20;
        [C,B] = CrossCorr(st_up+jittervalues, Range(S{i}),binsize_cc,nbins_cc);
        MatTransitDownUp = [MatTransitDownUp ; C'];
    end
    resprip_res.MatTransitDownUp{p} = MatTransitDownUp;
    
    %Transition Up>Down
    MatTransitUpDown = [];
    for i=1:length(S)
        % PETH in Wake
        jittervalues = randi(40,length(st_down),1) - 20;
        [C,B] = CrossCorr(st_down+jittervalues, Range(S{i}),binsize_cc,nbins_cc);
        MatTransitUpDown = [MatTransitUpDown ; C'];
    end
    resprip_res.MatTransitUpDown{p} = MatTransitUpDown;
    
    resprip_res.t_corr{p} = B;


    %% Neuron info
    resprip_res.InfoNeuronClass{p} = InfoNeurons.putative(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
    resprip_res.InfoNeuronLayer{p} = InfoNeurons.layer(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
    resprip_res.InfoNeuronFR{p} = InfoNeurons.firingrate(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);

end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursResponseRipplesTypeNeurons.mat resprip_res binsize_cc nbins_cc intv_success_down intv_success_up

