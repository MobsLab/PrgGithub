function A = AdrienData(A)
% A = AdrienData(A) extracts data in a "flattened" format
%
% for each dataset it makes a file AdrienData.mat containing
% cellnames: a cell array with the nmaes of the cells (TTx_y, etc)
% S: a tsdArray with all the spike trains, in the same order as cellnames
% if you don't want ot use the tsdArray class, it looks as a struct with
% the C field containing oa cell array wil all the ts objects (if you don't
% want to use the ts class, jusst get the list of spike times as a vector
% in the t field of each object
% startTrial, trialOutcome (tsd objects with the start and end times of each
% trial) the data of trial Outcome are 0 for right arm adn 1 for the left
% arm
% Sleep1Epoch, Sleep2Epoch, MazeEpoch: intervalSet objects (with a Start
% and an End field) for the three behavioral epochs
% XS, YS smoothed position data (tsd objects
% EEGpfc EEGHc, tsds with the EEG prefrotnal and hippocampal

A = getResource(A, 'PosXS');
XS = XS{1};
A = getResource(A, 'PosYS');
YS = YS{1};
A = getResource(A, 'CellNames');
A = getResource(A, 'SpikeData');

A= getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};

A = getResource(A, 'StartTrial');
startTrial = startTrial{1};

A= getResource(A, 'PfcTrace');
A = getResource(A, 'HcTrace');



cd(current_dir(A));
[p,dset,e] = fileparts(current_dir(A));
eegfname = [dset 'eeg' num2str(pfcTrace) '.mat'];
if exist([eegfname '.gz'])
    display(['unzipping file ' eegfname]);
    eval(['!gunzip ' eegfname '.gz']);
    isZip = true;
end
load(eegfname)
if isZip
    eval(['!gzip ' eegfname ]);
    isZip = false;
end
eval(['EEGpfc = EEG' num2str(pfcTrace), ';']);
eval(['clear EEG' num2str(pfcTrace) ';']);


eegfname = [dset 'eeg' num2str(hcTrace) '.mat'];
if exist([eegfname '.gz'])
    display(['unzipping file ' eegfname]);
    eval(['!gunzip ' eegfname '.gz']);
    isZip = true;
end
load(eegfname)
if isZip
    eval(['!gzip ' eegfname ]);
    isZip = false;
end
eval(['EEGhc = EEG' num2str(hcTrace), ';']);
eval(['clear EEG' num2str(hcTrace) ';']);


save AdrienData cellnames S trialOutcome startTrial XS YS EEGpfc EEGhc

cd(parent_dir(A));
