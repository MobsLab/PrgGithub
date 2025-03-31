%%CrossCorrRipplesDownStatesSubstage
% 18.09.2018 KJ
%
%
%   Look at the response of neurons to ripples - PETH Cross-Corr
%
% see
%   ParcoursRipplesNeuronCrossCorr
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
    
    clearvars -except Dir p ripdown_res
    
    ripdown_res.path{p}   = Dir.path{p};
    ripdown_res.manipe{p} = Dir.manipe{p};
    ripdown_res.name{p}   = Dir.name{p};
    ripdown_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 5;
    nbins_cc = 200;

    
    %% load
    
    load('SpikeData.mat', 'S')
    % Substages
    try
        load('SleepSubstages.mat', 'Epoch')
        Substages = Epoch;
    catch
        clear op NamesOp Dpfc Epoch noise
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        disp('Loading epochs from NREMepochsML.m')
        [Substages,NamesSubstages]=DefineSubStages(op,noise);
    end
    N1 = Substages{1}; N2 = Substages{2}; N3 = Substages{3}; REM = Substages{4}; Wake = Substages{5};
    N2N3 = or(N2,N3);
    NREM = or(N2N3,N1);
    
    % ripples
    load('Ripples.mat')
    tRipples = ts(Ripples(:,2)*10);
    
    %down states
    load('DownState.mat', 'down_PFCx')
    
    
    %% Cross-corr
    [ripdown_res.startdown{p}, ~] = CrossCorr(Range(tRipples), Start(down_PFCx), binsize_cc,nbins_cc);
    [ripdown_res.enddown{p}, B] = CrossCorr(Range(tRipples), End(down_PFCx), binsize_cc,nbins_cc);
    for s=1:5
        [ripdown_res.substage.startdown{p,s}, ~] = CrossCorr(Range(Restrict(tRipples, Substages{s})), Start(down_PFCx), binsize_cc,nbins_cc);
        [ripdown_res.substage.enddown{p,s}, B] = CrossCorr(Range(Restrict(tRipples, Substages{s})), End(down_PFCx), binsize_cc,nbins_cc);
    end
    ripdown_res.t_corr{p} = B;
    
end

%saving data
cd(FolderDeltaDataKJ)
save CrossCorrRipplesDownStatesSubstage.mat ripdown_res binsize_cc nbins_cc

