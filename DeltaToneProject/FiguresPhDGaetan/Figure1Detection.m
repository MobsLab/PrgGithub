% Figure1Detection
% 03.12.2016 KJ
%
% Collect data to plot the figures from the Figure1.pdf of Gaetan PhD
% 
% 
%   see Figure1DetectionPlot 
%



Dir = PathForExperimentsBasalSleepSpike;

%params
freqDeltaDetection = [1 6];
minDeltaDuration = 50; %50ms
thD_list = 0.2:0.2:4; %thresholds for detection
binsize_mua = 5;
binsize_MET = 10;
nb_bins_MET = 200;


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)


    %% Load

    %Epoch
    if exist('SleepScoring_Accelero.mat','file')==2
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    elseif exist('SleepScoring_OBGamma.mat','file')==2
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    end
    GoodEpoch=SWSEpoch-TotalNoiseEpoch;
    
    %down
    load('DownState.mat', 'down_PFCx')

    %PFC deep
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    PFCdeep=LFP;
    clear LFP channel
    %PFC sup
    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    PFCsup=LFP;
    clear LFP channel
    %PFC diff
    try
        load ChannelsToAnalyse/PFCx_deltadeep
        eval(['load LFPData/LFP',num2str(channel)])
        DIFFdeep=LFP;
        clear LFP channel
    catch
        DIFFdeep = PFCdeep;
    end
    try
        load ChannelsToAnalyse/PFCx_deltasup
        eval(['load LFPData/LFP',num2str(channel)])
        DIFFsup=LFP;
        clear LFP channel
    catch
        DIFFsup = PFCsup;
    end
      
    %MUA
    try
        load(fullfile('SpikesToAnalyse','PFCx_down.mat'), 'number')
    catch
        load(fullfile('SpikesToAnalyse','PFCx_Neurons.mat'), 'number')
    end
    NumNeurons=number;
    load('SpikeData.mat', 'S')  
    if isa(S,'tsdArray')
        MUA = MakeQfromS(S(NumNeurons), binsize_mua*10);
    else
        MUA = MakeQfromS(tsdArray(S(NumNeurons)),binsize_mua*10);
    end
    MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
    
    %number of neurons
    nb_neuron = length(NumNeurons);
    if nb_neuron==0
        continue
    end

    figure1_res.path{p}   = Dir.path{p};
    figure1_res.manipe{p} = Dir.manipe{p};
    figure1_res.name{p}   = Dir.name{p};
    
    figure1_res.nb_neuron{p}  = nb_neuron;
    figure1_res.fr_sws{p}     = round(mean(full(Data(Restrict(MUA, SWSEpoch))), 1)*100,2); % firing rate for a bin of 10ms
    figure1_res.fr_upstate{p} = round(mean(full(Data(Restrict(MUA, (SWSEpoch-down_PFCx)))), 1)*100,2); % firing rate for a bin of 10ms

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Detections
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% DIFF
    clear delta_centers delta_epoch firing_rate delta_density

    % find factor to increase EEGsup signal compared to EEGdeep
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(DIFFdeep)-i*Data(DIFFsup));
        k=k+1;
    end
    Factor=find(distance==min(distance))*0.1;
    % Difference between EEG deep and EEG sup (*factor)
    LFPdiff = tsd(Range(DIFFdeep),Data(DIFFdeep) - Factor*Data(DIFFsup));
    EEGsleepDiff = ResampleTSD(LFPdiff,200); 

    Filt_EEGdiff = FilterLFP(EEGsleepDiff, freqDeltaDetection, 1024);
    Filt_EEGdiff = Restrict(Filt_EEGdiff,GoodEpoch);
    abs_lfpdiff_value = max(Data(Filt_EEGdiff),0);
    std_diff = std(abs_lfpdiff_value(abs_lfpdiff_value>0));
    signal_for_thresh = tsd(Range(Restrict(EEGsleepDiff,GoodEpoch)), abs_lfpdiff_value);

    for i=1:length(thD_list)
        thresh_delta = thD_list(i) * std_diff;

        all_cross_thresh = thresholdIntervals(signal_for_thresh, thresh_delta, 'Direction', 'Above');
        DeltaEpoch = dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
        delta_epoch{i} = intervalSet(Start(DeltaEpoch), End(DeltaEpoch));
    end
    delta_centers = (Start(delta_epoch{thD_list==2}) + End(delta_epoch{thD_list==2}))/2;

    % data to plot
    [Mmua_y, ~, Mmua_x] = mETAverage(delta_centers, Range(MUA), Data(MUA), binsize_MET, nb_bins_MET);
    [Mdiff_y, ~, Mdiff_x] = mETAverage(delta_centers, Range(LFPdiff), Data(LFPdiff), binsize_MET, nb_bins_MET);

    for i=1:length(thD_list)
        delta_center = (Start(delta_epoch{i}) + End(delta_epoch{i}))/2;
        [met_y, ~, met_x] = mETAverage(delta_center, Range(MUA), Data(MUA), binsize_MET, nb_bins_MET);
        firing_rate(i) = min(met_y);
        delta_density(i) =  length(Start(delta_epoch{i})) / (tot_length(GoodEpoch,'s'));
    end

    % store
    figure1_res.graphA1.diff.x{p} = Mmua_x;
    figure1_res.graphA1.diff.y{p} = Mmua_y;
    figure1_res.graphA2.diff.x{p} = Mdiff_x;
    figure1_res.graphA2.diff.y{p} = Mdiff_y;
    figure1_res.graphB.diff.x{p} = thD_list;
    figure1_res.graphB.diff.y{p} = firing_rate;
    figure1_res.graphC.diff.x{p} = thD_list;
    figure1_res.graphC.diff.y{p} = delta_density;


    %% DEEP
    clear delta_centers delta_epoch firing_rate delta_density

    EEGsleepD = ResampleTSD(PFCdeep,200);
    Filt_EEGd = FilterLFP(EEGsleepD, freqDeltaDetection, 1024);
    Filt_EEGd = Restrict(Filt_EEGd,GoodEpoch);
    abs_lfpdiff_value = max(Data(Filt_EEGd),0);
    std_diff = std(abs_lfpdiff_value(abs_lfpdiff_value>0));
    signal_for_thresh = tsd(Range(Restrict(EEGsleepD,GoodEpoch)), abs_lfpdiff_value);

    for i=1:length(thD_list)
        thresh_delta = thD_list(i) * std_diff;

        all_cross_thresh = thresholdIntervals(signal_for_thresh, thresh_delta, 'Direction', 'Above');
        DeltaEpoch = dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
        delta_epoch{i} = intervalSet(Start(DeltaEpoch), End(DeltaEpoch));
    end
    delta_centers = (Start(delta_epoch{thD_list==2}) + End(delta_epoch{thD_list==2}))/2;

    % data to plot
    [Mmua_y, ~, Mmua_x] = mETAverage(delta_centers,  Range(MUA), Data(MUA), binsize_MET, nb_bins_MET);
    [Mdeep_y, ~, Mdeep_x] = mETAverage(delta_centers, Range(PFCdeep), Data(PFCdeep), binsize_MET, nb_bins_MET);

    for i=1:length(thD_list)
        delta_center = (Start(delta_epoch{i}) + End(delta_epoch{i}))/2;
        [met_y, ~, met_x] = mETAverage(delta_center, Range(MUA), Data(MUA), binsize_MET, nb_bins_MET);
        firing_rate(i) = min(met_y);
        delta_density(i) =  length(Start(delta_epoch{i})) / (tot_length(GoodEpoch,'s'));
    end

    % store
    figure1_res.graphA1.deep.x{p} = Mmua_x;
    figure1_res.graphA1.deep.y{p} = Mmua_y;
    figure1_res.graphA2.deep.x{p} = Mdeep_x;
    figure1_res.graphA2.deep.y{p} = Mdeep_y;
    figure1_res.graphB.deep.x{p} = thD_list;
    figure1_res.graphB.deep.y{p} = firing_rate;
    figure1_res.graphC.deep.x{p} = thD_list;
    figure1_res.graphC.deep.y{p} = delta_density;


    %% SUP
    clear delta_centers delta_epoch firing_rate delta_density

    EEGsleepS = ResampleTSD(PFCsup,200);
    Filt_EEGs = FilterLFP(EEGsleepS, freqDeltaDetection, 1024);
    Filt_EEGs = Restrict(Filt_EEGs,GoodEpoch);
    abs_lfpdiff_value = max(-1*Data(Filt_EEGs),0); %we take the opposite value of the EEG sup, because we detect trough
    std_diff = std(abs_lfpdiff_value(abs_lfpdiff_value>0));
    signal_for_thresh = tsd(Range(Restrict(EEGsleepS,GoodEpoch)), abs_lfpdiff_value);

    for i=1:length(thD_list)
        thresh_delta = thD_list(i) * std_diff;

        all_cross_thresh = thresholdIntervals(signal_for_thresh, thresh_delta, 'Direction', 'Above');
        DeltaEpoch = dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
        delta_epoch{i} = intervalSet(Start(DeltaEpoch), End(DeltaEpoch));
    end
    delta_centers = (Start(delta_epoch{thD_list==2}) + End(delta_epoch{thD_list==2}))/2;

    % data to plot
    [Mmua_y, ~, Mmua_x] = mETAverage(delta_centers,  Range(MUA), Data(MUA), binsize_MET, nb_bins_MET);
    [Msup_y, ~, Msup_x] = mETAverage(delta_centers, Range(PFCsup), Data(PFCsup), binsize_MET, nb_bins_MET);

    for i=1:length(thD_list)
        delta_center = (Start(delta_epoch{i}) + End(delta_epoch{i}))/2;
        [met_y, ~, met_x] = mETAverage(delta_center, Range(MUA), Data(MUA), binsize_MET, nb_bins_MET);
        firing_rate(i) = min(met_y);
        delta_density(i) =  length(Start(delta_epoch{i})) / (tot_length(GoodEpoch,'s'));
    end

    % store
    figure1_res.graphA1.sup.x{p} = Mmua_x;
    figure1_res.graphA1.sup.y{p} = Mmua_y;
    figure1_res.graphA2.sup.x{p} = Msup_x;
    figure1_res.graphA2.sup.y{p} = Msup_y;
    figure1_res.graphB.sup.x{p} = thD_list;
    figure1_res.graphB.sup.y{p} = firing_rate;
    figure1_res.graphC.sup.x{p} = thD_list;
    figure1_res.graphC.sup.y{p} = delta_density;
    
end

%saving data
cd([FolderProjetDelta 'Data/']) 
save Figure1Detection.mat figure1_res










