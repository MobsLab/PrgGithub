%%CrossCorrNeuronsRipplesResponse_KJ
% 19.09.2018 KJ
%
%
%   Cross-correlogram between population of neurons
%
% see
%   ParcoursRipplesNeuronCrossCorr NeuronsResponseToRipples_KJ ClassifyNeuronsResponseToRipples
%   



clear

Dir = PathForExperimentsSleepRipplesSpikes('all');
Dir = CheckPathForExperiment_KJ(Dir);
load(fullfile(FolderDeltaDataKJ,'ParcoursRipplesNeuronCrossCorr.mat'))


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ccneur_res rippeth_res
    
    ccneur_res.path{p}   = Dir.path{p};
    ccneur_res.manipe{p} = Dir.manipe{p};
    ccneur_res.name{p}   = Dir.name{p};
    ccneur_res.date{p}   = Dir.date{p};
    ccneur_res.neuronClass{p} = rippeth_res.neuronClass{p};
    
    %params
    binsize_cc = 1;
    nbins_cc = 200;
    binsize_mua = 2;
    minDuration = 40;
    intvDur = 200; %300ms
    

    %% load
    
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
    N1 = Substages{1}; N2 = Substages{2}; N3 = Substages{3}; REM = Substages{4}; Wake = Substages{5}; NREM = Substages{7};
    N2N3 = or(N2,N3);
    SleepEpoch = or(N2N3, or(N1,REM));
    
    
    %% Spikes
    
    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 
    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    
    ccneur_res.nb_down{p} = length(st_down);
    
    %Spikes of PFCx
    load('SpikeData.mat', 'S')
    load('SpikesToAnalyse/PFCx_Neurons.mat', 'number')
    NumNeurons = number;
    S = S(NumNeurons);

    %Pool by class
    for i=1:4
        Sc{i} = PoolNeurons(S, find(rippeth_res.neuronClass{p}==i));
    end
        
    %infos neurons
    ccneur_res.fr_all{p}  = mean(Data(Restrict(MUA,SleepEpoch))) / (binsize_mua/1000);
    ccneur_res.nb_all{p}  = length(NumNeurons);
    for i=1:4
        ccneur_res.fr_neurons{p,i}  = length(Restrict(Sc{i},SleepEpoch)) / (tot_length(SleepEpoch)/1E4);
        ccneur_res.nb_neurons{p,i}  = sum(rippeth_res.neuronClass{p}==i);
    end
    
    %%  Correlogram
    
    %whole night
    [ccneur_res.nightCc{p}, B] = CrossCorr(Range(Sc{2}), Range(Sc{3}), binsize_cc,nbins_cc);
    
    %Restrict to substages
    for s=1:5
        [ccneur_res.substagesCc{p,s}, B] = CrossCorr(Range(Restrict(Sc{2}, Substages{s})), Range(Sc{3}), binsize_cc,nbins_cc);
    end
    
    %pre_down
    intvPreDown = CleanUpEpoch(intervalSet(st_down-intvDur, st_down), 1);
    [ccneur_res.predown{p}, B] = CrossCorr(Range(Restrict(Sc{2}, intvPreDown)), Range(Sc{3}), binsize_cc,nbins_cc);
    
    %post-down
    intvPostDown = CleanUpEpoch(intervalSet(end_down, end_down+intvDur), 1);
    [ccneur_res.postdown{p}, B] = CrossCorr(Range(Restrict(Sc{2}, intvPostDown)), Range(Sc{3}), binsize_cc,nbins_cc);
    
    ccneur_res.t_corr{p} = B;
    
end

%saving data
cd(FolderDeltaDataKJ)
save CrossCorrNeuronsRipplesResponse_KJ.mat ccneur_res binsize_cc nbins_cc binsize_mua minDuration intvDur


