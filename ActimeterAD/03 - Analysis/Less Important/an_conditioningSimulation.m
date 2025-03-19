% conditioning simulation
%   This script do a quick offline simulation of a SWExperiment_sleepConditioning
%   and count the number of stimulations.
%
% developed for the ProjetSLEEPcontrol-Antoine project
% by antoine.delhomme@espci.fr
%

%% Load data
a = Activity(38, 4);

% Get the sleep scoring (smoothed scoring with corrected beginning and
% ending of events.
[sleepScoring, timeStamps] = a.computeSleepScoring();

%% Det parameters of the simulation
% Those parameters are set in SWExperiment_sleepTest

% Probability that a stimulation is triggered
stimProba = 1;
% Probability that the stimulation is effectively performed
%   Here, the probability is corrected as only sleep to wake transitions
%   (or wake to sleep transitions) are triggered.
effStimProba = 1/2;

%% Count the number of transitions

% Get events
evt = xor((1 + sleepScoring(1:end-1))/2, (1 + sleepScoring(2:end)));
% Count events
nbOfEvt = length(find(evt > 0));

% Do an estimation of stimulations
nbOfStim = round(nbOfEvt * stimProba * effStimProba);

% If possible, get the true number of stimulations
nbOfStim_true = length( find(a.evts == a.SWc.EVT_SOUND_STIM));

% Printing
fprintf('nb of stim: %d (true: %d)\n', nbOfStim, nbOfStim_true);