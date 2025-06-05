% including all spatial frequency
clear all
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/VisualTuningByVarAndPeriod';
mkdir(SaveFolder)
cd /media/nas8-2/AllenBrain_VisualData/visual_coding_psth_output_mat/
SessionNames = dir;
SessionNames = SessionNames(3:end); % not .mat


for mm = 1:length(SessionNames)
    load(SessionNames(mm).name)
    
    % Get visual data set parameters
    Orientations = unique(stimulus_info_per_trial.orientation);
    SpatialFrequency = unique(stimulus_info_per_trial.spatial_frequency);
    TimeBins = [find(psth_time_bin_centers>0,1,'first') : find(psth_time_bin_centers>0.25,1,'first')];
    BinSize = median(diff(psth_time_bin_centers));
    
    Opts.Num_bootstraps = 100;
    Opts.NeuronBins = [0:10];
    Opts.ParamBinLims = Orientations;
    Opts.ParamBinLims(end+1) = 180;
    Opts.Num_bootstraps = 100;
    Opts.TempBinsize = 0.25;
    
    
    % Orientation tuning for each spatial frequency
    
    
    for neur = 1:size(psth_data_all_trials,1)
        spike_dat = [];
        VarOfInterest = [];
        for sp = 1 : length(SpatialFrequency)
            for or = 1:length(Orientations)
                GoodTrials = find(stimulus_info_per_trial.orientation == Orientations(or) & stimulus_info_per_trial.spatial_frequency == SpatialFrequency(sp));
                
                spike_dat = [spike_dat,squeeze(nansum(psth_data_all_trials(neur,GoodTrials,TimeBins),3))];
                VarOfInterest = [VarOfInterest,squeeze(nanmean(psth_data_all_trials(sp,GoodTrials,TimeBins),3))*0+Orientations(or)];
                
            end
        end
        [TuningCurves{mm}{neur},MutInfo{mm}{neur},CorrInfo{mm}{neur},...
            MutInfo_rand{mm}{neur},CorrInfo_rand{mm}{neur}] = GetTuningCurveDescriptions(spike_dat',VarOfInterest',Opts);
        
    end
    
end

save([SaveFolder filesep 'OrientationTuning_All_Vis_0.2s_6ParamBinNumber.mat'],'TuningCurves','MutInfo','CorrInfo','MutInfo_rand',...
    'CorrInfo_rand','Opts')


% separating all spatial frequency
clear all
SaveFolder = '/media/DataMOBsRAIDN/PFC_InteroceptiveTuning/VisualTuningByVarAndPeriod';
mkdir(SaveFolder)
cd /media/nas8-2/AllenBrain_VisualData/visual_coding_psth_output_mat/
SessionNames = dir;
SessionNames = SessionNames(3:end); % not .mat


for mm = 1:length(SessionNames)
    load(SessionNames(mm).name)
    
    % Get visual data set parameters
    Orientations = unique(stimulus_info_per_trial.orientation);
    SpatialFrequency = unique(stimulus_info_per_trial.spatial_frequency);
    TimeBins = [find(psth_time_bin_centers>0,1,'first') : find(psth_time_bin_centers>0.25,1,'first')];
    BinSize = median(diff(psth_time_bin_centers));
    
    Opts.Num_bootstraps = 100;
    Opts.NeuronBins = [0:10];
    Opts.ParamBinLims = Orientations;
    Opts.ParamBinLims(end+1) = 180;
    Opts.Num_bootstraps = 100;
    Opts.TempBinsize = 0.25;
    
    
    % Orientation tuning for each spatial frequency
    
    
    for neur = 1:size(psth_data_all_trials,1)
        for sp = 1 : length(SpatialFrequency)
            spike_dat = [];
            VarOfInterest = [];
            for or = 1:length(Orientations)
                GoodTrials = find(stimulus_info_per_trial.orientation == Orientations(or) & stimulus_info_per_trial.spatial_frequency == SpatialFrequency(sp));
                
                spike_dat = [spike_dat,squeeze(nansum(psth_data_all_trials(neur,GoodTrials,TimeBins),3))];
                VarOfInterest = [VarOfInterest,squeeze(nanmean(psth_data_all_trials(sp,GoodTrials,TimeBins),3))*0+Orientations(or)];
                
            end
            [TuningCurves{mm}{neur}{sp},MutInfo{mm}{neur}{sp},CorrInfo{mm}{neur}{sp},...
                MutInfo_rand{mm}{neur}{sp},CorrInfo_rand{mm}{neur}{sp}] = GetTuningCurveDescriptions(spike_dat',VarOfInterest',Opts);
            
        end
        
    end
    
end

save([SaveFolder filesep 'SpatfreqOrientationTuning_All_Vis_0.2s_6ParamBinNumber.mat'],'TuningCurves','MutInfo','CorrInfo','MutInfo_rand',...
    'CorrInfo_rand','Opts')

