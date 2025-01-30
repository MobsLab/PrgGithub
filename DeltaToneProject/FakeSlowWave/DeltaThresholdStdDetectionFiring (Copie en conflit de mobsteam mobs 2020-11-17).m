%%DeltaThresholdStdDetectionFiring
% 20.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   Look at the firing rate in function of the threshold
%   -> here the data are collected  
%
% see
%   DeltaSingleChannelAnalysisFiringRate Figure1Detection
%   DeltaThresholdStdDetectionFiringPlot



% load
clear
Dir = PathForExperimentsDetectionDeltaFiringRate;

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p thresh_res
    
    thresh_res.path{p}   = Dir.path{p};
    thresh_res.manipe{p} = Dir.manipe{p};
    thresh_res.name{p}   = Dir.name{p};
    thresh_res.name{p}   = Dir.name{p};
    
    
    %% params
    freq_delta_multi = [1 12];
    freq_delta       = [1 4];
    thD_list         = 0.2:0.2:4; %thresholds for detection
    minDeltaDuration = 75;

    binsize_mua = 5; %20ms
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 400; %for mETAverage
    
    
    %% load
    %Epoch
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    %down
    load('DownState.mat', 'down_PFCx')
    
    %MUA
    try
        [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx_down', 'binsize',binsize_mua);
    catch
        [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    end
    
    %% Channels
    load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
    ch_deep = channel; clear channel
    
    if exist('ChannelsToAnalyse/PFCx_ecog.mat','file')==2
        load('ChannelsToAnalyse/PFCx_ecog.mat', 'channel')
        ch_sup = channel; clear channel
    elseif exist('ChannelsToAnalyse/PFCx_sup.mat','file')==2
        load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
        ch_sup = channel; clear channel
    else
        ch_sup = [];
    end
        
    
    %save
    thresh_res.sws_duration{p} = tot_length(NREM)/1e4; %in sec
    thresh_res.nb_neuron{p}  = nb_neurons;
    thresh_res.fr_sws{p}     = round(mean(full(Data(Restrict(MUA, NREM))), 1)*100,2); % firing rate for a bin of 10ms
    thresh_res.fr_upstate{p} = round(mean(full(Data(Restrict(MUA, (NREM-down_PFCx)))), 1)*100,2); % firing rate for a bin of 10ms
    
    
    %% DIFF
    clear delta_centers delta_epoch firing_rate delta_density
    
    %deep
    if exist('ChannelsToAnalyse/PFCx_deltadeep.mat','file')==2
        load ChannelsToAnalyse/PFCx_deltadeep
    else
        load ChannelsToAnalyse/PFCx_deep
    end
    load(['LFPData/LFP' num2str(channel)], 'LFP')
    DIFFdeep=LFP; clear LFP channel
    %sup
    if exist('ChannelsToAnalyse/PFCx_deltasup.mat','file')==2
        load ChannelsToAnalyse/PFCx_deltasup
    else
        load ChannelsToAnalyse/PFCx_sup
    end
    load(['LFPData/LFP' num2str(channel)], 'LFP')
    DIFFsup=LFP; clear LFP channel

    
    % find factor to increase EEGsup signal compared to EEGdeep
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(DIFFdeep)-i*Data(DIFFsup));
        k=k+1;
    end
    Factor=find(distance==min(distance))*0.1;
    % Difference between EEG deep and EEG sup (*factor)
    LFPdiff = tsd(Range(DIFFdeep),Data(DIFFdeep) - Factor*Data(DIFFsup));
    EEGDiff = ResampleTSD(LFPdiff,200); 

    FiltLFP = FilterLFP(EEGDiff, freq_delta_multi, 1024);
    positive_filtered = max(Data(FiltLFP),0);
    std_diff = std(positive_filtered(positive_filtered>0));
    signal_for_thresh = tsd(Range(EEGDiff), positive_filtered);
    
    clear delta_epoch
    firing_rate = []; firing_rate_norm = []; delta_density = [];
    for i=1:length(thD_list)
        thresh_delta = thD_list(i) * std_diff;

        all_cross_thresh = thresholdIntervals(signal_for_thresh, thresh_delta, 'Direction', 'Above');
        delta_epoch{i} = dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
        delta_epoch{i} = and(delta_epoch{i}, NREM);
        
        delta_center = (Start(delta_epoch{i}) + End(delta_epoch{i}))/2;
        [met_y, ~, met_x] = mETAverage(delta_center, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        firing_rate(i) = min(met_y);
        norm_met_y = met_y / mean(met_y(1:30));
        firing_rate_norm(i) = min(norm_met_y);
        delta_density(i) =  length(Start(delta_epoch{i})) / (tot_length(NREM,'s'));
    end
    
    
    % save
    thresh_res.diff.firing_rate{p}      = firing_rate;
    thresh_res.diff.firing_rate_norm{p} = firing_rate_norm;
    thresh_res.diff.delta_density{p}    = delta_density;
    
    
    %% DEEP CHANNEL
    load(['LFPData/LFP' num2str(ch_deep)], 'LFP')
    PFCdeep = LFP; clear LFP
        
    %filtered
    EEGsignal = ResampleTSD(PFCdeep,200); 
    FiltLFP = FilterLFP(EEGsignal, freq_delta, 1024);
    positive_filtered = max(Data(FiltLFP),0);
    %stdev
    std_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
    signal_for_thresh = tsd(Range(EEGsignal), positive_filtered);

    clear delta_epoch 
    firing_rate = []; firing_rate_norm = []; delta_density = [];
    for i=1:length(thD_list)
        thresh_delta = thD_list(i) * std_signal;

        all_cross_thresh = thresholdIntervals(signal_for_thresh, thresh_delta, 'Direction', 'Above');
        delta_epoch{i} = dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
        delta_epoch{i} = and(delta_epoch{i}, NREM);

        delta_center = (Start(delta_epoch{i}) + End(delta_epoch{i}))/2;
        [met_y, ~, met_x] = mETAverage(delta_center, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        firing_rate(i) = min(met_y);
        norm_met_y = met_y / mean(met_y(1:30));
        firing_rate_norm(i) = min(norm_met_y);
        delta_density(i) =  length(Start(delta_epoch{i})) / (tot_length(NREM,'s'));
    end

    % save
    thresh_res.deep.firing_rate{p}      = firing_rate;
    thresh_res.deep.firing_rate_norm{p} = firing_rate_norm;
    thresh_res.deep.delta_density{p}    = delta_density;
        

    %% SUP CHANNEL
    if ~isempty(ch_sup)         
        load(['LFPData/LFP' num2str(ch_sup)], 'LFP')
        PFCsup = LFP; clear LFP

        %filtered
        EEGsignal = ResampleTSD(PFCsup,200); 
        FiltLFP = FilterLFP(EEGsignal, freq_delta, 1024);
        positive_filtered = -min(Data(FiltLFP),0);
        %stdev
        std_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
        signal_for_thresh = tsd(Range(EEGsignal), positive_filtered);

        clear delta_epoch 
        firing_rate = []; firing_rate_norm = []; delta_density = [];
        for i=1:length(thD_list)
            thresh_delta = thD_list(i) * std_signal;

            all_cross_thresh = thresholdIntervals(signal_for_thresh, thresh_delta, 'Direction', 'Above');
            delta_epoch{i} = dropShortIntervals(all_cross_thresh,minDeltaDuration * 10); % crucial element for noise detection.
            delta_epoch{i} = and(delta_epoch{i}, NREM);

            delta_center = (Start(delta_epoch{i}) + End(delta_epoch{i}))/2;
            [met_y, ~, met_x] = mETAverage(delta_center, Range(MUA), Data(MUA), binsize_met, nbBins_met);
            firing_rate(i) = min(met_y);
            norm_met_y = met_y / mean(met_y(1:30));
            firing_rate_norm(i) = min(norm_met_y);
            delta_density(i) =  length(Start(delta_epoch{i})) / (tot_length(NREM,'s'));
        end

        % save
        thresh_res.sup.firing_rate{p}      = firing_rate;
        thresh_res.sup.firing_rate_norm{p} = firing_rate_norm;
        thresh_res.sup.delta_density{p}    = delta_density;
    end
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save DeltaThresholdStdDetectionFiring.mat thresh_res binsize_mua binsize_met nbBins_met freq_delta_multi freq_delta minDeltaDuration thD_list




