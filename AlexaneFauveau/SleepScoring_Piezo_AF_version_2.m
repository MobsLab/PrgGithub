%% Version 2 du Sleep Scoring Piezo 


function [WakeEpoch_Piezo, SleepEpoch_Piezo] = SleepScoring_Piezo_AF_version_2(Piezo_Mouse_tsd, LFP_Folder)

% Create the smooth_actimetry tsd :
Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(Piezo_Mouse_tsd))),50)); % smooth time =3s


% Get the threshold: 
actimetry_thresh = GetGammaThresh(Data(Smooth_actimetry), 1);
actimetry_thresh = exp(actimetry_thresh);

% Create the Sleep Epoch 
minduration = 3;
SleepEpoch_Piezo = thresholdIntervals(Smooth_actimetry, actimetry_thresh, 'Direction','Below');
SleepEpoch_Piezo = mergeCloseIntervals(SleepEpoch_Piezo, 2*1e4);
SleepEpoch_Piezo = dropShortIntervals(SleepEpoch_Piezo, minduration*1e4);
TotalEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
WakeEpoch_Piezo = TotalEpoch - SleepEpoch_Piezo;

Short_sleep_during_wake = SandwichEpoch(SleepEpoch_Piezo, WakeEpoch_Piezo, 90*1e4, 10*1e4);
SleepEpoch_Piezo = SleepEpoch_Piezo-Short_sleep_during_wake;
WakeEpoch_Piezo = TotalEpoch - SleepEpoch_Piezo;

WakeEPoch_without_microwake = dropShortIntervals(WakeEpoch_Piezo, 3*1e4);
MicroWakeEpoch = WakeEpoch_Piezo - WakeEPoch_without_microwake


% Plot the data 
fig = figure;
subplot(211)
plot(Range(Smooth_actimetry,'s')/60 , Data(Smooth_actimetry))
hold on
plot(Range(Restrict(Smooth_actimetry,SleepEpoch_Piezo),'s')/60 , Data(Restrict(Smooth_actimetry,SleepEpoch_Piezo)))
xlabel('Temps en min')
legend('Wake','Sleep')
title('Sleep Scoring des données d actimétrie smoothées')

subplot(212)
plot(Range(Piezo_Mouse_tsd,'s')/60 , Data(Piezo_Mouse_tsd))
hold on
plot(Range(Restrict(Piezo_Mouse_tsd,SleepEpoch_Piezo),'s')/60 , Data(Restrict(Piezo_Mouse_tsd,SleepEpoch_Piezo)))
xlabel('Temps en min')
title('Sleep Scoring des données d actimétrie')

save([LFP_Folder 'PiezoData_SleepScoring_v2.mat'],'SleepEpoch_Piezo','WakeEpoch_Piezo','Smooth_actimetry','Piezo_Mouse_tsd', 'actimetry_thresh')












