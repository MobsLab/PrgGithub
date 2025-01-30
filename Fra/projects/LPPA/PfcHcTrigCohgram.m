function A = PfcHcTrigCohgram(A)
params.Fs = 200;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 1;
movingwin = [2, 1];
win = [5 20];

A= getResource(A, 'PfcTrace');
A = getResource(A, 'HcTrace');
A = getResource(A, 'MazeInterval');
mazeInterval = mazeInterval{1};
A = getResource(A, 'StartTrial');
startTrial = startTrial{1};
A = getResource(A, 'CorrectError');
correctError= correctError{1};


A = registerResource(A, 'PfcHcStartTrialCohgram', 'tsdArray', {1,1},...
    'pfcHcStartTrialCohgram', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial']);
A = registerResource(A, 'PfcHcStartTrialCohgramFreq', 'numeric', {1,[]},...
    'pfcHcStartTrialCohgramFreq', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the frequencies']);
A = registerResource(A, 'PfcHcStartTrialCorrectCohgram', 'tsdArray', {1,1},...
    'pfcHcStartTrialCohgram', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial']);
A = registerResource(A, 'PfcHcStartTrialCorrectCohgramFreq', 'numeric', {1,[]},...
    'pfcHcStartTrialCohgramFreq', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the frequencies']);
A = registerResource(A, 'PfcHcStartTrialErrorCohgram', 'tsdArray', {1,1},...
    'pfcHcStartTrialCohgram', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial']);
A = registerResource(A, 'PfcHcStartTrialErrorCohgramFreq', 'numeric', {1,[]},...
    'pfcHcStartTrialCohgramFreq', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the frequencies ']);
cd(current_dir(A));

[p,dset,e] = fileparts(current_dir(A));
eegfname = [dset 'eeg' num2str(pfcTrace) '.mat'];
load(eegfname)
eval(['EEGpfc = EEG' num2str(pfcTrace), ';']);
eval(['clear EEG' num2str(pfcTrace) ';']);
EEGpfc = Restrict(EEGpfc, mazeInterval);
st = StartTime(EEGpfc);
et = EndTime(EEGpfc);

eegfname = [dset 'eeg' num2str(hcTrace) '.mat'];
load(eegfname)
eval(['EEGhc = EEG' num2str(hcTrace), ';']);
eval(['clear EEG' num2str(hcTrace) ';']);
EEGhc = Restrict(EEGhc, mazeInterval);


[startTrial, ix] = Restrict(startTrial, st+win(1)*10000, et-win(2)*10000);
ce = Data(correctError);
ce = ce(ix);

[t, ix] = Restrict(EEGpfc, startTrial);

sf = 1 / 2083.3333333333;
stTrial = ix * sf;




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




ixErr = find(ce==0);
ixCorr = find(ce==1);

dtPfc= createdatamatc(deegPfc, stTrial, params.Fs, win);
dtHc= createdatamatc(deegHc, stTrial, params.Fs, win);
[C,phi,S12,S1,S2,t,f]=cohgramc(deegPfc,deegHc,movingwin,params);
pfcHcStartTrialCohgramFreq = (f(:))';
pfcHcStartTrialCohgram = tsd((t-win(1))*10000,C); 
 
dtPfc= createdatamatc(deegPfc, stTrial(ixErr), params.Fs, win);
dtHc= createdatamatc(deegHc, stTrial(ixErr), params.Fs, win);
[C,phi,S12,S1,S2,t,f]=cohgramc(deegPfc,deegHc,movingwin,params);
pfcHcStartTrialErrorCohgramFreq = (f(:))';
pfcHcStartTrialErrorCohgram = tsd((t-win(1))*10000,C); 
 
dtPfc= createdatamatc(deegPfc, stTrial(ixCorr), params.Fs, win);
dtHc= createdatamatc(deegHc, stTrial(ixCorr), params.Fs, win);
[C,phi,S12,S1,S2,t,f]=cohgramc(deegPfc,deegHc,movingwin,params);
pfcHcStartTrialCorrectCohgramFreq = (f(:))';
pfcHcStartTrialCorrectCohgram = tsd((t-win(1))*10000,C); 
 
cd(parent_dir(A));
A = saveAllResources(A);
