%%DownstatesSubpopulationAnalysis
%
% 11.03.2018 KJ
%
% see
%   DownstatesPermutations
%

clear
Dir = PathForExperimentsDownState;
load(fullfile(FolderProjetDelta,'Data','DownstatesSubpopulationAnalysis.mat'))


%% single channels
for p=1:length(Dir.path) 
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p downsub_res
    
    downsub_res.path{p}   = Dir.path{p};
    downsub_res.manipe{p} = Dir.manipe{p};
    downsub_res.name{p}   = Dir.name{p};
    downsub_res.date{p}   = Dir.date{p};
    
    
    %% params
    thresh0 = 0.7;
    mergeGap = 0; % merge
    predown_size = 0;

    binsize = 10;
    permutation_range = [10 20 30 50 80 100 200 300 500 800 1000]*10;
    
    range_nbneurons = sort([2:4:42 2:4:42]);
        
    
    %% load data

    % Epoch
    if exist('SleepScoring_Accelero.mat','file')==2
        load SleepScoring_Accelero SWSEpoch Wake TotalNoiseEpoch
    elseif exist('SleepScoring_OBGamma.mat','file')==2
        load SleepScoring_OBGamma SWSEpoch Wake TotalNoiseEpoch
    else
        load StateEpochSB SWSEpoch Wake TotalNoiseEpoch
    end
    SWSEpoch = SWSEpoch - TotalNoiseEpoch;
    Wake     = Wake - TotalNoiseEpoch;
    
    %MUA
    load('SpikeData','S')
    if exist('SpikesToAnalyse/PFCx_down.mat','file')==2
        load SpikesToAnalyse/PFCx_down
    elseif exist('SpikesToAnalyse/PFCx_Neurons.mat','file')==2
        load SpikesToAnalyse/PFCx_Neurons
    elseif exist('SpikesToAnalyse/PFCx_MUA.mat','file')==2
        load SpikesToAnalyse/PFCx_MUA
    else
        number=[];
    end
    NumNeurons=number;
    clear number
    nb_neuron_all = length(NumNeurons);
    
    %load
    load('IdFigureData2.mat', 'night_duration');
    downsub_res.night_duration{p} = night_duration;
    
    
    %% MUA and firing rate
    %pool all neurons
    if isa(S,'tsdArray')
        MUA = MakeQfromS(S(NumNeurons), binsize*10);
    else
        MUA = MakeQfromS(tsdArray(S(NumNeurons)),binsize*10);
    end
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    Qsws  = Restrict(MUA, SWSEpoch);
    Qwake = Restrict(MUA, Wake);
    
    % Mean firing rates
    downsub_res.all.firingrate.sws{p}  = round(mean(full(Data(Qsws)), 1)*100,2); % firing rate for a bin of 10ms
    downsub_res.all.firingrate.wake{p} = round(mean(full(Data(Qwake)), 1)*100,2); % firing rate for a bin of 10ms
    downsub_res.all.nb_neuron{p}       = nb_neuron_all;
    
    
    %find real down       
    AllDown = FindDownKJ(MUA, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
    DownSws = and(AllDown, SWSEpoch);
    DownWake = and(AllDown, Wake);
    %save
    downsub_res.all.real.sws{p} = DownSws;
    downsub_res.all.real.wake{p} = DownWake;
    
    
    %% Make Permutations
    for k=1:length(permutation_range)
        
        min_perm = -permutation_range(k);
        max_perm = permutation_range(k);
        
        Sp = S; % S permutated
        for i=1:length(Sp)
            perm = (max_perm-min_perm).* rand(1) + min_perm;
            spk = Range(Sp{i}) + perm; 
            Sp{i} = tsd(spk, spk);
        end
    
        %pool all neurons    
        if isa(Sp,'tsdArray')
            MUA_perm = MakeQfromS(Sp, binsize*10);
        else
            MUA_perm = MakeQfromS(tsdArray(Sp),binsize*10);
        end
        MUA_perm = tsd(Range(MUA_perm), sum(full(Data(MUA_perm)),2));
        
        %down 
        AllDown = FindDownKJ(MUA_perm, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
        DownSws = and(AllDown, SWSEpoch);
        DownWake = and(AllDown, Wake);
        
        downsub_res.all.perm.sws{p,k} = DownSws;
        downsub_res.all.perm.wake{p,k} = DownWake;
        
        % keep Sp for next steps
        all_Sp{k} = Sp;
        
    end

    
    %% subpopulation of neurons
    for i=1:length(range_nbneurons)
        nb_neuron = range_nbneurons(i);
        if nb_neuron >= nb_neuron_all
            continue
        end
        
        %sub population of neurons
        sub_neurons = NumNeurons(randperm(nb_neuron_all,nb_neuron));
        
        %pool all neurons
        if isa(S,'tsdArray')
            MUA = MakeQfromS(S(sub_neurons), binsize*10);
        else
            MUA = MakeQfromS(tsdArray(S(sub_neurons)),binsize*10);
        end
        MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
        Qsws  = Restrict(MUA, SWSEpoch);
        Qwake = Restrict(MUA, Wake);
        
        %down 
        AllDown = FindDownKJ(MUA, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
        DownSws = and(AllDown, SWSEpoch);
        DownWake = and(AllDown, Wake);
        %save
        downsub_res.sub.real.sws{p,i} = DownSws;
        downsub_res.sub.real.wake{p,i} = DownWake;
        
        % Mean firing rates
        downsub_res.sub.firingrate.sws{p,i} = round(mean(full(Data(Qsws)), 1)*100,2); % firing rate for a bin of 10ms
        downsub_res.sub.firingrate.wake{p,i} = round(mean(full(Data(Qwake)), 1)*100,2); % firing rate for a bin of 10ms
        downsub_res.sub.nb_neuron{p,i}  = nb_neuron;

        
        
        %% permutations of sub-population
        
        for k=1:length(permutation_range)
            %already permuted
            Sp = all_Sp{k};

            %pool all neurons    
            if isa(Sp,'tsdArray')
                MUA_perm = MakeQfromS(Sp(sub_neurons), binsize*10);
            else
                MUA_perm = MakeQfromS(tsdArray(Sp(sub_neurons)),binsize*10);
            end
            MUA_perm = tsd(Range(MUA_perm), sum(full(Data(MUA_perm)),2));

            %down 
            AllDown = FindDownKJ(MUA_perm, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
            DownSws = and(AllDown, SWSEpoch);
            DownWake = and(AllDown, Wake);

            permsub_res.sws{p,i,k} = DownSws;
            permsub_res.wake{p,i,k} = DownWake;

        end

    end
    
    
end


%saving data
cd([FolderProjetDelta 'Data/'])
save DownstatesSubpopulationAnalysis.mat -v7.3 downsub_res binsize permutation_range thresh0 mergeGap predown_size range_nbneurons
save DownstatesSubpopulationAnalysis2.mat -v7.3 permsub_res








