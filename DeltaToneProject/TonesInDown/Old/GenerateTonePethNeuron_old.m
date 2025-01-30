%%GenerateTonePethNeuron
% 11.09.2018 KJ
%
%
%   
%
% see
%   
%


clear

Dir = PathForExperimentsDeltaSleepSpikes('DeltaTone');
Dir = CheckPathForExperiment_KJ(Dir);


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    
    %params
    t_start = -5000;
    t_end   = 5000;
    binsize_peth = 50;
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    load('SpikeData.mat', 'S')
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
    
    % tones
    load('behavResources.mat', 'ToneEvent')
    
    
    %% Cross Corr in N23
    MatTones = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(ToneEvent), Range(S{i}),binsize_cc,nbins_cc);
        MatTones = [MatTones, C];
    end
    MatTones = MatTones';
    t_corr = B;
    
    %% Cross Corr in N23
    MatN2N3 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2N3 = [MatN2N3, C];
    end
    MatN2N3 = MatN2N3';    
    
    %% Cross Corr in N1
    MatN1 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, N1)), Range(S{i}),binsize_cc,nbins_cc);
        MatN1 = [MatN1, C];
    end
    MatN1 = MatN1';
    
    %% Cross Corr in REM
    MatREM = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, REM)), Range(S{i}),binsize_cc,nbins_cc);
        MatREM = [MatREM, C];
    end
    MatREM = MatREM';
    
    %% Cross Corr in Wake
    MatWake = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(ToneEvent, Wake)), Range(S{i}),binsize_cc,nbins_cc);
        MatWake = [MatWake, C];
    end
    MatWake = MatWake';
    
    
    %% save
    save NeuronToneCC.mat MatTones MatN2N3 MatN1 MatREM MatWake t_corr
    
    
end



