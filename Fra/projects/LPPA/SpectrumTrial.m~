function A = SpectrumTrial(A)

A = getResource(A, 'MazeInterval');
mazeInterval = mazeInterval{1};
A = getResource(A, 'StartTrial');
startTrial = startTrial{1};

A = getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};

A = getResource(A, 'PostReward');
postReward = postReward{1};


A = getResource(A, 'CorrectError');
correctError= correctError{1};




A = registerResource(A, 'SpectrumMaze', 'cell', {7,1}, ...
    'spectrumMaze', ...
   ['powerspectrum (0-40Hz) for the six EEG channels for the whole period on othe maze ',...
   'seventh element is the frequencies']);

A = registerResource(A, 'SpectrumTrials', 'cell', {7,1}, ...
    'spectrumTrials', ...
   ['powerspectrum for the six EEG channels for the trials',...
   'seventh element is the frequencies']);


trials = intervalSet(startTrial, trialOutcome);

params.Fs = 200;
params.fpass = [0 40];
params.err = [1 0.95];
params.trialave = 0;

cd(current_dir(A));

[p,dset,e] = fileparts(current_dir(A));

spectrumMaze = cell(7,1);
spectrumTrials = cell(7,1);

for neeg = 1:6
    eegfname = [dset 'eeg' num2str(neeg) '.mat'];
    load(eegfname)
    eval(['EEG = EEG' num2str(neeg), ';']);
    eval(['clear EEG' num2str(neeg) ';']);
    EEG = Restrict(EEG, mazeInterval);
    EEGrest = Restrict(EEG, trials);
    deeg1 = resample(Data(EEGrest), 600, 6250);
    [spectrumTrials{neeg},f,Serr]=mtspectrumsegc(deeg1,2, params);
    deeg1 = resample(Data(EEG), 600, 6250);
    [spectrumMaze{neeg},f,Serr]=mtspectrumsegc(deeg1,2, params);
    
end

spectrumMaze{7} = f;
spectrumTrials{7} = f;


cd(parent_dir(A));
A = saveAllResources(A);
