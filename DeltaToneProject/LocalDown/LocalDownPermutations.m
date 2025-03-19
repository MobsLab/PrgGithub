%%LocalDownPermutations
%
% 31.01.2018 KJ
%
% see
%   DownstatesPermutationsPlot 
%

clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


%% single channels
for p=1:length(Dir.path) 
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p down_res
    
    down_res.path{p}   = Dir.path{p};
    down_res.manipe{p} = Dir.manipe{p};
    down_res.name{p}   = Dir.name{p};
    down_res.date{p}   = Dir.date{p};
    down_res.date{p}   = Dir.hemisphere{p};
    
    
    %% params
    thresh0 = 0.7;
    mergeGap = 0; % merge
    predown_size = 0;
    duration_bins = 0:10:1500; %duration bins for downstates

    binsize_mua = 10;
    permutation_range = [10 20 30 50 80 100 200 300 500 800 1000]*10;
        
    
    %% load data

    % Epoch
    [NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    Wake = Wake - TotalNoiseEpoch;

    %Spikes
    load('SpikeData.mat', 'S');
    if ~isa(S,'tsdArray')
        S = tsdArray(S);
    end
    %Spike tetrode
    load('SpikesToAnalyse/PFCx_tetrodes.mat')
    NeuronTetrodes = numbers;
    nb_tetrodes = length(NeuronTetrodes);
    %all PFC neurons
    if ~isempty(Dir.hemisphere{p})
        load(['SpikesToAnalyse/PFCx_' Dir.hemisphere{p} '_Neurons.mat'])
    else
        load('SpikesToAnalyse/PFCx_Neurons.mat')
    end
    all_neurons = number;
    
    down_res.nb_tetrodes{p} = nb_tetrodes;
    
    
    %% MUA
    MUA = MakeQfromS(S(all_neurons), binsize_mua*10);
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

    %Tetrodes
    for tt=1:nb_tetrodes
        local_neurons{tt} = NeuronTetrodes{tt};
        %MUA & down
        MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua*10);
        MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
    end
    
    
    %% Global True Down distribution
    Qsws  = Restrict(MUA, NREM);
    Qwake = Restrict(MUA, Wake);
    
    % Mean firing rates
    nb_neuron = length(all_neurons);
    firingrates.sws = round(mean(full(Data(Qsws)), 1)*100,2); % firing rate for a bin of 10ms
    firingrates.wake = round(mean(full(Data(Qwake)), 1)*100,2); % firing rate for a bin of 10ms
    
    %find down
    AllDown = FindDownKJ(MUA, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
    DownSws = and(AllDown, NREM);
    DownWake = and(AllDown, Wake);
    downSws_dur = (End(DownSws) - Start(DownSws)) / 10; %ms
    downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

    %distributions
    nbDown.real.sws = zeros(1, length(duration_bins));
    nbDown.real.wake = zeros(1, length(duration_bins));
    for j=1:length(duration_bins)
        binvalue = duration_bins(j);
        nbDown.real.sws(j) = sum(downSws_dur==binvalue);
        nbDown.real.wake(j) = sum(downWake_dur==binvalue);
    end
    
    %save
    down_res.global.fr.sws{p} = firingrates.sws;
    down_res.global.fr.wake{p} = firingrates.wake;
    down_res.global.nb_neuron{p}  = nb_neuron;
    
    down_res.global.real.sws{p} = nbDown.real.sws;
    down_res.global.real.wake{p} = nbDown.real.wake;
    
    
    %% Local True Down distribution
    for tt=1:nb_tetrodes
        Qsws  = Restrict(MUA_local{tt}, NREM);
        Qwake = Restrict(MUA_local{tt}, Wake);

        % Mean firing rates
        nb_neuron = length(local_neurons{tt});
        firingrates.sws = round(mean(full(Data(Qsws)), 1)*100,2); % firing rate for a bin of 10ms
        firingrates.wake = round(mean(full(Data(Qwake)), 1)*100,2); % firing rate for a bin of 10ms

        %find down
        AllDown = FindDownKJ(MUA_local{tt}, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
        DownSws = and(AllDown, NREM);
        DownWake = and(AllDown, Wake);
        downSws_dur = (End(DownSws) - Start(DownSws)) / 10; %ms
        downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

        %distributions
        nbDown.real.sws = zeros(1, length(duration_bins));
        nbDown.real.wake = zeros(1, length(duration_bins));
        for j=1:length(duration_bins)
            binvalue = duration_bins(j);
            nbDown.real.sws(j) = sum(downSws_dur==binvalue);
            nbDown.real.wake(j) = sum(downWake_dur==binvalue);
        end

        %save
        down_res.local.fr.sws{p,tt}    = firingrates.sws;
        down_res.local.fr.wake{p,tt}   = firingrates.wake;
        down_res.local.nb_neuron{p,tt} = nb_neuron;

        down_res.local.real.sws{p,tt}  = nbDown.real.sws;
        down_res.local.real.wake{p,tt} = nbDown.real.wake;
    
    end
    
    %% Global With Permutations
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
            MUA = MakeQfromS(Sp, binsize_mua*10);
        else
            MUA = MakeQfromS(tsdArray(Sp),binsize_mua*10);
        end
        MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

        %find down       
        AllDown = FindDownKJ(MUA, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
        DownSws = and(AllDown, NREM);
        DownWake = and(AllDown, Wake);
        downSws_dur = (End(DownSws) - Start(DownSws)) / 10; %ms
        downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms
        
        %distributions
        nbDown.perm.sws = zeros(1, length(duration_bins));
        nbDown.perm.wake = zeros(1, length(duration_bins));
        for j=1:length(duration_bins)
            binvalue = duration_bins(j);
            nbDown.perm.sws(j) = sum(downSws_dur==binvalue);
            nbDown.perm.wake(j) = sum(downWake_dur==binvalue);
        end
        
        down_res.global.perm.sws{p,k}  = nbDown.perm.sws;
        down_res.global.perm.wake{p,k} = nbDown.perm.wake;
        
    end
    
    
    %% Local With Permutations
    for tt=1:nb_tetrodes
        for k=1:length(permutation_range)

            min_perm = -permutation_range(k);
            max_perm = permutation_range(k);

            Sp = S(local_neurons{tt}); % S permutated
            for i=1:length(Sp)
                perm = (max_perm-min_perm).* rand(1) + min_perm;
                spk = Range(Sp{i}) + perm; 
                Sp{i} = tsd(spk, spk);
            end

            %pool all neurons    
            if isa(Sp,'tsdArray')
                MUA = MakeQfromS(Sp, binsize_mua*10);
            else
                MUA = MakeQfromS(tsdArray(Sp),binsize_mua*10);
            end
            MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

            %find down       
            AllDown = FindDownKJ(MUA, 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', 1000, 'mergeGap', mergeGap, 'predown_size', predown_size);
            DownSws = and(AllDown, NREM);
            DownWake = and(AllDown, Wake);
            downSws_dur = (End(DownSws) - Start(DownSws)) / 10; %ms
            downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

            %distributions
            nbDown.perm.sws = zeros(1, length(duration_bins));
            nbDown.perm.wake = zeros(1, length(duration_bins));
            for j=1:length(duration_bins)
                binvalue = duration_bins(j);
                nbDown.perm.sws(j) = sum(downSws_dur==binvalue);
                nbDown.perm.wake(j) = sum(downWake_dur==binvalue);
            end

            down_res.local.perm.sws{p,tt}{k}  = nbDown.perm.sws;
            down_res.local.perm.wake{p,tt}{k} = nbDown.perm.wake;

        end
    end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save LocalDownPermutations.mat down_res binsize_mua permutation_range thresh0 mergeGap predown_size duration_bins

