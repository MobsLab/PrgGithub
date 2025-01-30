% StimImpactCorrelogramTrainStim
% 23.05.2018 KJ
%
% tones success rate and slow waves density
%   -> collect and save
%
%   see 
%       QuantifStimImpactSuccessSwDensity
%

clear

%Dir
Dir = ListOfDreemRecordsStimImpact('all');
    
%params
durations = [-3000 3000];

p=25;

%% load signals
[eeg, ~, stimulations, StageEpochs, ~] = GetRecordDreem(Dir.filename{p});

%stimulations
[tones_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);


[~, ~] = PlotEventTriggeredCorrelogram(eeg{1}, ts(stim_train(:,1)), durations, 'smooth', [0.5 0.5], 'pmax', 0.05);


