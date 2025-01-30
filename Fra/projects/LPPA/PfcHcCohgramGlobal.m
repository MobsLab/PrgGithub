function A = PfcHcCohgramGlobal(A)

A= getResource(A, 'PfcTrace');
A = getResource(A, 'HcTrace');
A = getResource(A, 'MazeInterval');
mazeInterval = mazeInterval{1};
A = registerResource(A, 'PfcHcCohgram', 'tsdArray', {1,1},...
    'pfcHcCohgram', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'for the entire maze period'])



cd(current_dir(A));

[p,dset,e] = fileparts(current_dir(A));
eegfname = [dset 'eeg' num2str(pfcTrace) '.mat'];
load(eegfname)
eval(['EEGpfc = EEG' num2str(pfcTrace), ';']);
eval(['clear EEG' num2str(pfcTrace) ';']);
EEGpfc = Restrict(EEGpfc, mazeInterval);
st = StartTime(EEGpfc);


eegfname = [dset 'eeg' num2str(hcTrace) '.mat'];
load(eegfname)
eval(['EEGhc = EEG' num2str(hcTrace), ';']);
eval(['clear EEG' num2str(hcTrace) ';']);
EEGhc = Restrict(EEGhc, mazeInterval);

dp = Data(EEGpfc);
clear EEGpfc
dh = Data(EEGhc);
clear EEGhc

m = min(length(dp), length(dh));
dp = dp(1:m);
dh = dh(1:m);
deegPfc = resample(dp, 600, 6250);
deegHc = resample(dh, 600, 6250);
clear dp dh
params.Fs = 200;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;
movingwin = [2, 1];

[C,phi,S12,S1,S2,t,f]=cohgramc(deegPfc,deegHc,movingwin,params);
pfcHcCohgram = tsd(t*10000+st, C);


cd(parent_dir(A));
A = saveAllResources(A);
