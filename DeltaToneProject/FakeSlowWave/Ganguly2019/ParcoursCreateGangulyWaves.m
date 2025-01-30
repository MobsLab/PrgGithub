%%ParcoursCreateGangulyWaves
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
    
%     if exist('GangulyWaves.mat','file')==2
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
        FiltDeep = FilterLFP(EEG_deep, freq_so, 1024);
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


        %% predetection
        zero_crossings = Range(threshold(LFP_nrem, 0, 'Crossing', 'Rising', 'InitialPoint', 1));
        Predetections = intervalSet(zero_crossings(1:end-1), zero_crossings(2:end));
        Predetections = dropShortIntervals(Predetections,300*10);
        Predetections = dropLongIntervals(Predetections,1e4);


        %% Detections of all waves with negative thresholding

        %negative threshold
        idx_troughs = y_troughs<Th_troughs;
        time_troughs = time_troughs(idx_troughs);
        y_troughs = y_troughs(idx_troughs);

        %intervals with dections inside
        st_predetect = Start(Predetections);
        end_predetect = End(Predetections);
        [~,intervals,index] = InIntervals(time_troughs, [st_predetect end_predetect]);
        intervals = unique(intervals); intervals(intervals==0)=[];

        twaves_troughs = time_troughs(index==1);
        AllWaves = subset(Predetections,intervals);


        %% look at peaks 
        idwave_peaks = nan(1,length(twaves_troughs));
        for i=1:length(twaves_troughs)    
            a = twaves_troughs(i) - time_peaks;
            try
                idwave_peaks(i) = find(a>minDuration & a<maxDuration & y_peaks>Th_peaks,1,'last');
            end
        end

        %SO
        So_pfc{ch} = subset(AllWaves,find(~isnan(idwave_peaks)));
        %delta waves
        delta_detect{ch} = subset(AllWaves,find(isnan(idwave_peaks)));
        
        
        %% Up states
        positive_intervals = thresholdIntervals(LFP_nrem, 0, 'Direction', 'Below');
        
        So_up{ch} = and(So_pfc{ch},positive_intervals);
        delta_up{ch} = and(delta_detect{ch},positive_intervals);
        

    end
    
    %% save
    save GangulyWaves.mat -append channels_pfc So_pfc delta_detect So_up delta_up So_threshold up_threshold
    
end





