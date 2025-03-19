%%ParcoursRipplesNoDownNeuronCrossCorr
% 14.09.2018 KJ
%
%
%   Look at the response of neurons to ripples with no down before and after - PETH Cross-Corr
%
% see
%   GenerateRipplesPethNeuron ParcoursRipplesNoDownNeuronCrossCorrPlot
%



clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripnodown_res
    
    ripnodown_res.path{p}   = Dir.path{p};
    ripnodown_res.manipe{p} = Dir.manipe{p};
    ripnodown_res.name{p}   = Dir.name{p};
    ripnodown_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    %Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('InfoNeuronsAll.mat', 'InfoNeurons')
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
    S = S(NumNeurons);
    ripnodown_res.infoneurons{p} = InfoNeurons;
    
    % Substages
    try
        load('SleepSubstages.mat', 'Epoch')
        N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
    catch
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,~]=DefineSubStages(op,noise);
        N1 = Substages{1}; N2 = Substages{2}; N3 = Substages{3}; REM = Substages{4}; Wake = Substages{5}; NREM = Substages{7};
    end
    N2N3 = or(N2,N3);
    
    % ripples
    load('Ripples.mat')
    tRipples = ts(Ripples(:,2)*10);
    tstartRipples = ts(Ripples(:,1)*10);
    
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
    Epoch = CleanUpEpoch(up_PFCx-aftDown);
    Epoch = CleanUpEpoch(Epoch-befDown);
    
    tRipples = Restrict(tRipples, Epoch);  
    tstartRipples = Restrict(tstartRipples, Epoch); 
    
    ripnodown_res.nb_ripples{p} = length(tRipples);
    
    %% Cross Corr for all ripples
    MatRipples = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipples), Range(S{i}),binsize_cc,nbins_cc);
        MatRipples = [MatRipples, C];
    end
    ripnodown_res.MatRipples{p} = MatRipples';
    ripnodown_res.t_corr{p} = B;
    
    %% Cross Corr in N1
    MatN1 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N1)), Range(S{i}),binsize_cc,nbins_cc);
        MatN1 = [MatN1, C];
    end
    ripnodown_res.MatN1{p} = MatN1';
    
    %% Cross Corr in N2
    MatN2 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N2)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2 = [MatN2, C];
    end
    ripnodown_res.MatN2{p} = MatN2';
    
    %% Cross Corr in N3
    MatN3 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN3 = [MatN3, C];
    end
    ripnodown_res.MatN3{p} = MatN3';
    
    %% Cross Corr in N23
    MatN2N3 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2N3 = [MatN2N3, C];
    end
    ripnodown_res.MatN2N3{p} = MatN2N3';
    
    
    %% Cross Corr in REM
    MatREM = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, REM)), Range(S{i}),binsize_cc,nbins_cc);
        MatREM = [MatREM, C];
    end
    ripnodown_res.MatREM{p} = MatREM';
    
    
    %% Cross Corr in Wake
    MatWake = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, Wake)), Range(S{i}),binsize_cc,nbins_cc);
        MatWake = [MatWake, C];
    end
    ripnodown_res.MatWake{p} = MatWake';
    
end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursRipplesNoDownNeuronCrossCorr.mat ripnodown_res binsize_cc nbins_cc

