%%ParcoursCreateGangulyStimPeriod
% 05.09.2019 KJ
%
% Infos
%   Detect SO and delta waves as in the paper Kim, Gulati et Ganguly 2019 (Cell)
%
% see
%    CreateSoDeltaGanguly
%    


clear
Dir = PathForExperimentsFakeSlowWave;
Dir = PathForExperimentsBasalSleepSpike;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
%     if exist('GangulyStimPeriod.mat','file')==2
%         continue
%     end
    
    %% params
    freq_so = [0.1 4];
    minDuration = 150*10;
    maxDuration = 500*10;

    %% load
    %Epoch
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %PFCx channels
    load('ChannelsToAnalyse/PFCx_clusters.mat')
    channels_pfc = channels(clusters>=3);
    
    
    %% Detections for each channels
    
    for ch=1:length(channels_pfc)
        
        load(['LFPData/LFP' num2str(channels_pfc(ch))], 'LFP')
        LFPdeep = LFP;

        %% filtering
        EEG_deep = ResampleTSD(LFPdeep,100);
        FiltDeep = FilterForwardLFPBut(EEG_deep, freq_so, 4);        
        LFP_nrem = Restrict(FiltDeep, NREM);


        %% peaks, troughs, threshold
        tExtrema = peaks_tsd(LFP_nrem);
        tExtrema = Restrict(LFP_nrem, tExtrema);
        time_extrema = Range(tExtrema);
        y_extrema = Data(tExtrema);

        time_peaks = time_extrema(y_extrema>0);
        y_peaks = y_extrema(y_extrema>0);
        time_troughs = time_extrema(y_extrema<0);
        y_troughs = y_extrema(y_extrema<0);

        %Thresholds
        Th_peaks = prctile(y_peaks,85);
        Th_troughs = prctile(y_troughs,40);
        
        So_threshold(ch) = Th_peaks;
        up_threshold(ch) = Th_troughs;


        
        %% Stim times
        
        %So period
        idx = y_peaks>=Th_peaks;
        t_predetection = time_peaks(idx);
        y_predetection = y_peaks(idx);
        
        %below threshold
        StimPeriod = thresholdIntervals(LFP_nrem, Th_troughs, 'Direction', 'Below');
        stim_center = (Start(StimPeriod) + End(StimPeriod))/2;
        
        [status,intervals,~] = InIntervals(t_predetection, [stim_center-0.5e4 stim_center-0.15e4]);
        intervals = unique(intervals); intervals(intervals==0)=[];
        
        peak_so{ch} = t_predetection(status==1);
        trough_so{ch} = stim_center(intervals);
        trough_delta{ch} = stim_center(setdiff(1:length(stim_center), intervals));
        
        
        %% period
        [~,intervals,~] = InIntervals(trough_so{ch}, [Start(StimPeriod) End(StimPeriod)]);
        intervals = unique(intervals); intervals(intervals==0)=[];
        StimSo = subset(StimPeriod,intervals);
        
        [~,intervals,~] = InIntervals(trough_delta{ch}, [Start(StimPeriod) End(StimPeriod)]);
        intervals = unique(intervals); intervals(intervals==0)=[];
        StimDelta = subset(StimPeriod,intervals);
        

    end
    
    %% save
    save GangulyStimPeriod.mat channels_pfc So_threshold up_threshold peak_so trough_so trough_delta StimSo StimDelta
    
end





