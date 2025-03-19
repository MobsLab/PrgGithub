%%ParcoursDownNeuronCrossCorr
% 18.09.2018 KJ
%
%
%   Look at the response of neurons to down states - PETH Cross-Corr
%
% see
%   GenerateRipplesPethNeuron ParcoursRipplesNeuronCrossCorr
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
    
    clearvars -except Dir p downpeth_res
    
    downpeth_res.path{p}   = Dir.path{p};
    downpeth_res.manipe{p} = Dir.manipe{p};
    downpeth_res.name{p}   = Dir.name{p};
    downpeth_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    %Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('InfoNeuronsAll.mat', 'InfoNeurons')
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
    S = S(NumNeurons);
    downpeth_res.infoneurons{p} = InfoNeurons; 

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
    
    % down states
    load('DownState.mat', 'down_PFCx')
    st_down  = Start(down_PFCx);
    end_down = End(down_PFCx);
    
    
    %% Cross Corr for all down states
    MatStartDown = [];
    MatEndDown = [];
    for i=1:length(S)
        [C,B] = CrossCorr(st_down, Range(S{i}),binsize_cc,nbins_cc);
        MatStartDown = [MatStartDown, C];
        [C,B] = CrossCorr(end_down, Range(S{i}),binsize_cc,nbins_cc);
        MatEndDown = [MatEndDown, C];
    end
    downpeth_res.MatStartDown{p} = MatStartDown';
    downpeth_res.MatEndDown{p} = MatEndDown';
    downpeth_res.t_corr{p} = B;
    
    %% Cross Corr in N2
    MatStartN2 = [];
    MatEndN2 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(ts(st_down), N2)), Range(S{i}),binsize_cc,nbins_cc);
        MatStartN2 = [MatStartN2, C];
        [C,B] = CrossCorr(Range(Restrict(ts(end_down), N2)), Range(S{i}),binsize_cc,nbins_cc);
        MatEndN2 = [MatEndN2, C];
    end
    downpeth_res.MatStartN2{p} = MatStartN2';
    downpeth_res.MatEndN2{p} = MatEndN2';
    downpeth_res.t_corr{p} = B;
    
    %% Cross Corr in N3
    MatStartN3 = [];
    MatEndN3 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(ts(st_down), N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatStartN3 = [MatStartN3, C];
        [C,B] = CrossCorr(Range(Restrict(ts(end_down), N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatEndN3 = [MatEndN3, C];
    end
    downpeth_res.MatStartN3{p} = MatStartN3';
    downpeth_res.MatEndN3{p} = MatEndN3';
    downpeth_res.t_corr{p} = B;
    
    %% Cross Corr in N2-N3
    MatStartN2N3 = [];
    MatEndN2N3 = [];
    for i=1:length(S)
        [C,B] = CrossCorr(Range(Restrict(ts(st_down), N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatStartN2N3 = [MatStartN2N3, C];
        [C,B] = CrossCorr(Range(Restrict(ts(end_down), N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatEndN2N3 = [MatEndN2N3, C];
    end
    downpeth_res.MatStartN2N3{p} = MatStartN2N3';
    downpeth_res.MatEndN2N3{p} = MatEndN2N3';
    downpeth_res.t_corr{p} = B;
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save ParcoursDownNeuronCrossCorr.mat downpeth_res binsize_cc nbins_cc

