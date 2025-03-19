%%DownstatesPermutations
%
% 31.01.2018 KJ
%
% see
%   DownstatesPermutationsPlot PathForExperimentsDownstatePermutation
%

clear
Dir = PathForExperimentsDownstatePermutation;


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
    
    try
        load('NeuronClassification.mat', 'UnitID')
        down_res.neuronClass{p} = sign(UnitID(NumNeurons,1));
    catch
        down_res.neuronClass{p} = [];
    end
        
    
    
    %% True Down distribution
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    Qsws  = Restrict(MUA, NREM);
    Qwake = Restrict(MUA, Wake);
    
    % Mean firing rates
    nb_neuron = length(NumNeurons);
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
    down_res.firingrate.sws{p} = firingrates.sws;
    down_res.firingrate.wake{p} = firingrates.wake;
    down_res.nb_neuron{p}  = nb_neuron;
    
    down_res.real.sws{p} = nbDown.real.sws;
    down_res.real.wake{p} = nbDown.real.wake;
    
    
    %% With Permutations
    
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
        
        down_res.perm.sws{p,k}  = nbDown.perm.sws;
        down_res.perm.wake{p,k} = nbDown.perm.wake;
        
    end
    
end


%saving data
cd(FolderDeltaDataKJ)
save DownstatesPermutations.mat down_res binsize_mua permutation_range thresh0 mergeGap predown_size duration_bins








