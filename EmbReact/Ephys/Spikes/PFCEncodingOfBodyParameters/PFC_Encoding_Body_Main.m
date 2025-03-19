

%% Codes to trigger PFC neurons on OB frequency

% used for CNRS
% conditionning sessions, just freezing,  saves to OBTuning_PFC, 2 to 6Hz
PFCNeurons_TriggeredOnOBFrequency.m


% without any conditionning session (so there won't be freezing) with or without sleep
% saves to PFCUnitFiringOnOBFrequencyAllSessBroadFreqNoSleep, 2 to 11Hz
PFCNeurons_TriggeredOnOBfrequencyAllStates

% without any conditionning session (so there won't be freezing) with or without sleep
% resamples to match speed distributions
% saves to PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep, 2 to 11Hz
PFCNeurons_TriggeredOnOBfrequencyAllStatesSpeedCorr


% without any conditionning session (so there won't be freezing) with or without sleep
% subsamples to get same number of bins for each OB frequency
% saves to PFCUnitFiringOnOBFrequencyAllSessBroadFreqNoSleepSubSample, 2 to 11Hz
PFCNeurons_TriggeredOnOBfrequencyAllStatesSubsampledCorr

% conditionning sessions, just freezing, 
% performs PCA on the OB spectrum and then uses this to look at neural
% responses
PFCNeurons_TriggeredOnOBPCA


%% Codes to trigger PFC neurons on heart rate
% conditionning sessions, just freezing,  saves to HRTuning_PFC, 8 to 13Hz
PFCNeurons_TriggeredOnHRFrequency.m



%% Codes relating PFC firing to HPC and OB frequencies
PFCUnits_OB_HPC_Frequency_EmbReact_SB



%% PFC units phase locked to heart 
% Nedd to clean this up, ca't find where the data was saved ti
SpikesModulationHR_SB 

%% Model heart and breathing with speed
AllOutput = LinearModelBodyVsSpeed('All')


%%%%
%% 
Parameter = {'HR','BR','HRV'};
Epoch = {'Freezing','Sleep','Wake','All'};
for p= 1:3
    for e = 3
        GetBodyTuningCurves_PFCNeurons_SB(Parameter{p}, Epoch{e})
    end
end


%% 
Parameter = {'HR','BR','HRV'};
Epoch = {'Freezing','Sleep','Wake','Wake_Explo'};
for p= 1:3
    for e = 4
        GetBodyTuningCurves_PFCNeurons_SB(Parameter{p}, Epoch{e})
    end
end