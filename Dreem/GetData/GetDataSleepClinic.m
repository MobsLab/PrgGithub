function [sleep_efficiency, sol, waso] = GetDataSleepClinic(StageEpochs, stage_epoch_duration)
%   [sleep_efficiency, sol, waso] = GetDataSleepClinic(Hypnograms)
%
% INPUT:
% - StageEpochs                 Hypnograms
%
% - stage_epoch_duration        (optional) duration of sleep epochs in 1E-4s
%                               (default 30s i.e 30E4)
%
%
% OUTPUT:
% - sleep_efficiency:           Total Sleep Time / Time In Bed
% - sol:                        first two sleep stage consecutives
% - waso:                       Wake After Sleep Onset
%
%
% INFO
%
%       see 
%           GetHypnogramClinic
%


%% CHECK INPUTS

if nargin < 1,
  error('Incorrect number of parameters.');
end
if isempty(StageEpochs),
  error('StageEpochs is empty.');
end


if ~exist('stage_epoch_duration','var')
    stage_epoch_duration = 30E4;
end

%Epochs
Sleep_Epochs = or(or(StageEpochs{1},StageEpochs{2}),or(StageEpochs{3},StageEpochs{4}));
All_night = or(Sleep_Epochs,StageEpochs{5});
    
    
    
%% SOL - Sleep onset latency
epochs_durations = End(Sleep_Epochs) - Start(Sleep_Epochs);
stage_start = Start(Sleep_Epochs);
first_two_period = stage_start(epochs_durations >= 2*stage_epoch_duration);

if ~isempty(first_two_period)
    sol = first_two_period(1);
else
    sol = nan;
end
    
%% WASO - number of wake period after sleep onset
wake_starts = Start(StageEpochs{5});
wake_durations = End(StageEpochs{5}) - Start(StageEpochs{5});
if ~isnan(sol)
    wake_after_so = wake_starts>sol; 
    waso = wake_durations(wake_after_so);
    waso = sum(waso(1:end-1)); %remove last wake period = awakening
    
else
    waso = nan;
end

%% Sleep Efficiency (= TST/TIB)
% Total Sleep Time / Time In Bed

TST = tot_length(Sleep_Epochs);
TIB = tot_length(All_night);
sleep_efficiency = TST / TIB ;


end


