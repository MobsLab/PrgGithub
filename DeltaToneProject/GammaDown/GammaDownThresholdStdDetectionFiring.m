%%GammaDownThresholdStdDetectionFiring
% 24.04.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   Look at the firing rate in function of the threshold
%   -> here the data are collected  
%
% see
%   DeltaThresholdStdDetectionFiring
%   GammaDownThresholdStdDetectionFiringPlot
%



% load
clear
Dir = PathForExperimentsBasalSleepSpike;


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
    
    freqGamma = [300 550];
    predectDur = 30;
    mergeGap = 10;
    minDuration = 50;
    maxDuration = 700;

    thD_list    = 1:0.5:4; %thresholds for detection

    binsize_mua = 10; %5ms
    binsize_met  = 5; %for mETAverage  
    nbBins_met   = 240; %for mETAverage
    
    
    %% load
    %Epoch
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
        GoodEpoch=SWSEpoch-TotalNoiseEpoch;
    catch
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
        GoodEpoch=SWSEpoch-TotalNoiseEpoch;
    end
    %down
    load(fullfile(Dir.path{p},'DownState.mat'), 'down_PFCx');
    
    
    %MUA
    try
        load(fullfile(Dir.path{p},'SpikesToAnalyse','PFCx_down.mat'), 'number')
    catch
        load(fullfile(Dir.path{p},'SpikesToAnalyse','PFCx_Neurons.mat'), 'number')
    end
    NumNeurons=number;
    MUA = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize_mua,'foldername', Dir.path{p});
    %number of neurons
    nb_neuron = length(NumNeurons);
    if nb_neuron==0
        continue
    end
    
    %Delta waves channels
    for ch=1:length(channels)
        load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channels(ch))])
        eval(['Deltas{ch} = delta_ch_' num2str(channels(ch)) ';'])
    end
    
    %PFC channels
    load('IdFigureData2.mat', 'channel_curves', 'structures_curves', 'peak_value')
    idx = find(strcmpi(structures_curves,'PFCx'));
    channel_curves = channel_curves(idx);
    peak_value = peak_value(idx);
    
    load('ChannelsToAnalyse/PFCx_locations.mat','channels')
    for ch=1:length(channels)
        peak_value_new(ch) = peak_value(channel_curves==channels(ch));
    end
    peak_value = peak_value_new;
    
    %save
    thresh_res.sws_duration{p} = tot_length(GoodEpoch)/1e4; %in sec
    
    thresh_res.peak_value{p} = peak_value;
    thresh_res.channels{p}   = channels;

    thresh_res.nb_neuron{p}  = nb_neuron;
    thresh_res.fr_sws{p}     = round(mean(full(Data(Restrict(MUA, SWSEpoch))), 1)*100,2); % firing rate for a bin of 10ms
    thresh_res.fr_upstate{p} = round(mean(full(Data(Restrict(MUA, (SWSEpoch-down_PFCx)))), 1)*100,2); % firing rate for a bin of 10ms
    
    
    %% SINGLE CHANNEL
    for ch=1:length(channels)

        load(['LFPData/LFP' num2str(channels(ch))], 'LFP')

        %filtered
        FiltLFP = FilterLFP(LFP, freqGamma, 1024);
        %stdev for threshold
        std_signal = mean(abs(Data(Restrict(FiltLFP, Deltas{ch}))));
        
        clear gamma_down 
        firing_rate = []; gamma_density = [];
        for i=1:length(thD_list)
            thresh_detect = thD_list(i) * std_signal;

            all_cross_thresh = thresholdIntervals(FiltLFP, thresh_detect, 'Direction', 'Below');
            gamma_epoch = dropShortIntervals(all_cross_thresh,predectDur * 10);            
            gamma_epoch = mergeCloseIntervals(gamma_epoch, mergeGap * 10); 
            gamma_epoch = dropShortIntervals(gamma_epoch, minDuration * 10); 
            gamma_epoch = dropLongIntervals(gamma_epoch, maxDuration * 10); 
            gamma_down{i} = and(gamma_epoch, GoodEpoch);

            gammadown_center = (Start(gamma_down{i}) + End(gamma_down{i}))/2;
            [met_y, ~, met_x] = mETAverage(gammadown_center, Range(MUA), Data(MUA), binsize_met, nbBins_met);
            firing_rate(i) = min(met_y);
            gamma_density(i) =  length(Start(gamma_down{i})) / (tot_length(GoodEpoch,'s'));
        end
        
        % save
        thresh_res.firing_rate{p}{ch}   = firing_rate;
        thresh_res.delta_density{p}{ch} = gamma_density;
        thresh_res.std_signal{p}(ch)    = std_signal;
        
    end

    

end


%saving data
cd(FolderDeltaDataKJ)
save GammaDownThresholdStdDetectionFiring.mat thresh_res binsize_mua binsize_met nbBins_met freqGamma minDuration maxDuration predectDur mergeGap thD_list


    
    