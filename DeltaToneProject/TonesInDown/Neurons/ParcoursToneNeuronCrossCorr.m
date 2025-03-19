%%ParcoursToneNeuronCrossCorr
% 14.09.2018 KJ
%
%
%   Look at the response of neurons to tones - PETH Cross-Corr
%
% see
%   GenerateTonePethNeuron ParcoursToneNeuronCrossCorrPlot
%   ParcoursRipplesNeuronCrossCorr



clear


Dir=PathForExperimentsDeltaSleepSpikes('RdmTone');
% Dir2=PathForExperimentsDeltaSleepSpikes('DeltaTone');
% Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);



%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tonepeth_res
    
    % tones
    try
        load('behavResources.mat', 'ToneEvent')
        ToneEvent;
    catch
        try
            load('DeltaSleepEvent.mat', 'TONEtime2')
            ToneEvent = ts(TONEtime2 + Dir.delay{p}*1E4) ;
        catch
            continue
        end
    end
    
    tonepeth_res.path{p}   = Dir.path{p};
    tonepeth_res.manipe{p} = Dir.manipe{p};
    tonepeth_res.name{p}   = Dir.name{p};
    tonepeth_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    %load Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('InfoNeuronsAll.mat', 'InfoNeurons')
    NumNeurons = find(strcmpi(InfoNeurons.structure,'PFCx'));
    load('SpikesToAnalyse/PFCx_Neurons.mat', 'number')
    NumNeurons=number;
    S = S(NumNeurons);
    tonepeth_res.infoneurons{p} = InfoNeurons; 
    
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
    
    
    %% Cross Corr for all tones
    MatTones = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneEvent), Range(S{i}),binsize_cc,nbins_cc);
        MatTones = [MatTones, C];
    end
    tonepeth_res.MatTones{p} = MatTones';
    tonepeth_res.t_corr{p} = B;
    
    %% Cross Corr in N23
    MatN2N3 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2N3 = [MatN2N3, C];
    end
    tonepeth_res.MatN2N3{p} = MatN2N3';    
    
    %% Cross Corr in N1
    MatN1 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, N1)), Range(S{i}),binsize_cc,nbins_cc);
        MatN1 = [MatN1, C];
    end
    tonepeth_res.MatN1{p} = MatN1';
    
    %% Cross Corr in N2
    MatN2 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, N2)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2 = [MatN2, C];
    end
    tonepeth_res.MatN2{p} = MatN2';
    tonepeth_res.t_corr{p} = B;
    
    %% Cross Corr in N3
    MatN3 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN3 = [MatN3, C];
    end
    tonepeth_res.MatN3{p} = MatN3';
    tonepeth_res.t_corr{p} = B;
    
    %% Cross Corr in REM
    MatREM = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, REM)), Range(S{i}),binsize_cc,nbins_cc);
        MatREM = [MatREM, C];
    end
    tonepeth_res.MatREM{p} = MatREM';
    
    %% Cross Corr in Wake
    MatWake = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, Wake)), Range(S{i}),binsize_cc,nbins_cc);
        MatWake = [MatWake, C];
    end
    tonepeth_res.MatWake{p} = MatWake';
    
end


%saving data
cd(FolderDeltaDataKJ)
save ParcoursToneNeuronCrossCorr.mat tonepeth_res binsize_cc nbins_cc


