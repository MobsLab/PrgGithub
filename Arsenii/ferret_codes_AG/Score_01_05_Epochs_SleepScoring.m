% ScoreEpochs_SleepScoring
% 18.10.2024 AG
%
% [Epoch_S1, Epoch_S2] = Score_01_05_Epochs_SleepScoring(SleepEpoch, Epoch_01_05, minduration, Info_OB)
%
% This function takes as input Sleep and Epoch_01_05 to make the final
% epochs of S1 (high 0.1-0.5 Hz) and S2 (low 0.1-0.5 Hz)
%
%
%
%%INPUTS
%
% SleepEpoch        : Sleep Epoch
% Epoch_01_05       : epoch of high 0.1-0.5Hz activity in OB
% minduration       : minimum duration of events
%
%
%%OUTPUT
%
% Epoch_S1          : Intersection of Sleep and high 0.1-0.5Hz epoch (Epoch_01_05), drop intervals less than min_duration
% Epoch_S2          : Sleep that is not Epoch_S1
%
%
%%SEE
%   SleepScoringOBGamma
%


function [Epoch_S1, Epoch_S2] = ...
    Score_01_05_Epochs_SleepScoring(SleepEpoch, Epoch_01_05, minduration, Info_OB)

try
    thresh_01_05 = Info_OB.thresh_01_05;
catch
    load('StateEpochSB.mat', 'Info_OB')
    thresh_01_05 = Info_OB.thresh_01_05;
end

%% Definition of vigilance states

% define S1 as overlap of sleep and Epoch_01_05 that lasts more than 3s
disp('          ...defining S1 (high 0.1-0.5Hz power)')
Epoch_S1 = and(SleepEpoch,Epoch_01_05);
Epoch_S1 = mergeCloseIntervals(Epoch_S1,minduration*1e4);
Epoch_S1 = dropShortIntervals(Epoch_S1,minduration*1e4);

% define S2 as sleep that is not S1
disp('          ...defining S2 (low 0.1-0.5Hz power)')
Epoch_S2 = SleepEpoch-Epoch_S1;

end


