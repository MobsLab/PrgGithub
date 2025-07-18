%%ParcoursRipplesNeuronCrossCorr
% 14.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr
%
% see
%   GenerateRipplesPethNeuron ParcoursRipplesNeuronCrossCorrPlot
%   NeuronsResponseToTones_KJ NeuronsResponseToRipples_KJ
%   ParcoursToneNeuronCrossCorr



clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p rippeth_res
    
    rippeth_res.path{p}   = Dir.path{p};
    rippeth_res.manipe{p} = Dir.manipe{p};
    rippeth_res.name{p}   = Dir.name{p};
    rippeth_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    %load Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('InfoNeuronsAll.mat', 'InfoNeurons')
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx')' & InfoNeurons.ismua==0);
    S = S(NumNeurons);
    rippeth_res.infoneurons{p} = InfoNeurons;
    
    % Substages
    try
        load('SleepSubstages.mat', 'Epoch')
        N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7};
    catch
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
        N1 = Substages{1}; N2 = Substages{2}; N3 = Substages{3}; REM = Substages{4}; Wake = Substages{5}; NREM = Substages{7};
    end
    N2N3 = or(N2,N3);
    
    % ripples
    [tRipples, ~] = GetRipples;
    
    
    %% Cross Corr for all ripples
    MatRipples = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(tRipples), Range(S{i}),binsize_cc,nbins_cc);
        MatRipples = [MatRipples, C];
    end
    rippeth_res.MatRipples{p} = MatRipples';
    rippeth_res.t_corr{p} = B;
    
    %% Cross Corr in N1
    MatN1 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N1)), Range(S{i}),binsize_cc,nbins_cc);
        MatN1 = [MatN1, C];
    end
    rippeth_res.MatN1{p} = MatN1';
    
    %% Cross Corr in N2
    MatN2 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N2)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2 = [MatN2, C];
    end
    rippeth_res.MatN2{p} = MatN2';
    
    %% Cross Corr in N3
    MatN3 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN3 = [MatN3, C];
    end
    rippeth_res.MatN3{p} = MatN3';
    
    %% Cross Corr in N23
    MatN2N3 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2N3 = [MatN2N3, C];
    end
    rippeth_res.MatN2N3{p} = MatN2N3';
    
    
    %% Cross Corr in REM
    MatREM = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, REM)), Range(S{i}),binsize_cc,nbins_cc);
        MatREM = [MatREM, C];
    end
    rippeth_res.MatREM{p} = MatREM';
    
    
    %% Cross Corr in Wake
    MatWake = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(tRipples, Wake)), Range(S{i}),binsize_cc,nbins_cc);
        MatWake = [MatWake, C];
    end
    rippeth_res.MatWake{p} = MatWake';
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursRipplesNeuronCrossCorr.mat rippeth_res binsize_cc nbins_cc

