%%DeltaStructureLayer
%
% 23.01.2018 KJ
%


Dir = PathForExperimentsBasalSleepSpike;


for p=1:length(Dir.path)   
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p layer_res
    
    layer_res.path{p}   = Dir.path{p};
    layer_res.manipe{p} = Dir.manipe{p};
    layer_res.name{p}   = Dir.name{p};
    
    
    %% params
    freq_delta          = [1 12];
    thresh_std          = 2;
    min_duration_delta  = 75;

    durations   = [150 250] * 10; %in ts, for mean curve on down state
    windowsize1 = [0 200]; %for PlotRipRaw, LFP on Down
    windowsize2 = [-200 300]; %for PlotRipRaw, MUA on delta
    
    
    %% load data

    % Epoch
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    end
    GoodEpoch=SWSEpoch-TotalNoiseEpoch;

    %MUA
    disp('load MUA...')
    load SpikeData
    if exist('SpikesToAnalyse/PFCx_down.mat','file')==2
        load SpikesToAnalyse/PFCx_down
    elseif exist('SpikesToAnalyse/PFCx_Neurons.mat','file')
        load SpikesToAnalyse/PFCx_Neurons
    elseif exist('SpikesToAnalyse/PFCx_MUA.mat','file')
        load SpikesToAnalyse/PFCx_MUA
    else
        number=[];
    end
    NumNeurons=number;
    T=PoolNeurons(S,NumNeurons);
    clear ST
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    binsize = 5;
    MUA = MakeQfromS(ST,binsize*10);
    clear ST T 
    MUA = tsd(Range(MUA), full(Data(MUA)));
    max_mua = max(Data(Restrict(MUA, GoodEpoch)));
    normMUA = tsd(Range(MUA), Data(MUA) / max_mua);


    %LFP 
    Signals = cell(0);
    channels = GetDifferentLocationStructure('PFCx');

    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')
        Signals{ch} = LFP; clear LFP
    end

    %down
    load('DownState.mat', 'down_PFCx')
    Down = down_PFCx;
    start_down = Start(Down);
    down_durations = End(Down) - Start(Down);
    selected_down = start_down(down_durations>durations(1) & down_durations<durations(2));
    
    
    %% Amplitude on down    
    for i=1:length(channels)
        meancurves = PlotRipRaw(Signals{i}, selected_down/1E4, windowsize1,0,0);
        if sum(meancurves)>0
            peak_lfp(i) = max(meancurves(:,2));
        else
            peak_lfp(i) = min(meancurves(:,2));
        end
    end


    %% deltas detection
    for i=1:length(channels)
        %filtered
        FiltLFP = FilterLFP(Signals{i}, freq_delta, 1024);
        if peak_lfp(i)>0
            positive_filtered = max(Data(FiltLFP),0);
        else
            positive_filtered = -min(Data(FiltLFP),0);
        end
        %stdev
        std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
        % deltas
        thresh_delta = thresh_std * std_of_signal;
        all_cross_thresh = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_delta, 'Direction', 'Above');
        deltas = dropShortIntervals(all_cross_thresh, min_duration_delta * 10); % crucial element for noise detection.
        %Restrict    
        DeltaOffline{i} = and(deltas, GoodEpoch);
    end

    %MUA min value on delta
    for i=1:length(channels)
        center_deltas = (Start(DeltaOffline{i}) + End(DeltaOffline{i})) / 2;
        
        meancurves = PlotRipRaw(normMUA, center_deltas/1E4, windowsize2,0,0);
        mua_trough(i) = min(meancurves(:,2));
    end
    
    
    %% save
    layer_res.mua_trough{p} = mua_trough;
    layer_res.peak_lfp{p} = peak_lfp;
    layer_res.channels{p} = channels;

end

%saving data
cd([FolderProjetDelta 'Data/'])
save DeltaStructureLayer.mat layer_res freq_delta thresh_std min_duration_delta durations


    
    