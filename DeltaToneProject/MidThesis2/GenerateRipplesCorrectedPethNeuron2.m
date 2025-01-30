%%GenerateRipplesCorrectedPethNeuron2
% 13.09.2018 KJ
%
%
%   
%
% see
%   GenerateTonePethNeuron
%


clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);



for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
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
    
    % ripples
    load('Ripples.mat')
    tRipples = ts(Ripples(:,2)*10);
    
    %Down
    load('DownState.mat', 'down_PFCx')
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
    
    
    %% Cross Corr in N23
    MatRipples = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(tRipples), Range(S{i}),binsize_cc,nbins_cc);
        MatRipples = [MatRipples, C];
    end
    MatRipples = MatRipples';
    t_corr = B;
    
    %% Cross Corr in N23
    MatN2N3 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(tRipples, N2N3)), Range(S{i}),binsize_cc,nbins_cc);
        MatN2N3 = [MatN2N3, C];
    end
    MatN2N3 = MatN2N3';    
    
    %% Cross Corr in N1
    MatN1 = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(tRipples, N1)), Range(S{i}),binsize_cc,nbins_cc);
        MatN1 = [MatN1, C];
    end
    MatN1 = MatN1';
    
    %% Cross Corr in REM
    MatREM = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(tRipples, REM)), Range(S{i}),binsize_cc,nbins_cc);
        MatREM = [MatREM, C];
    end
    MatREM = MatREM';
    
    %% Cross Corr in Wake
    MatWake = [];
    for i=1:length(S)
        % PETH in Wake
        [C,B] = CrossCorr(Range(Restrict(tRipples, Wake)), Range(S{i}),binsize_cc,nbins_cc);
        MatWake = [MatWake, C];
    end
    MatWake = MatWake';
    
    
    %% save
    save NeuronRipplesCorrectedCC2.mat MatRipples MatN2N3 MatN1 MatREM MatWake t_corr
    
    
end



