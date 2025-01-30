function A = PfcHcCohgramByTrial(A)
params.Fs = 200;
params.fpass = [0 40];
params.err = [2, 0.95];
params.trialave = 0;
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


A = registerResource(A, 'PfcHcStartTrialByTrialCohgram', 'tsdArray', {1,1},...
    'pfcHcStartTrialByTrialCohgram', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, on a trial-by-trial basis']);
A = registerResource(A, 'PfcHcStartTrialByTrialCohgramFreq', 'numeric', {1,[]},...
    'pfcHcStartTrialByTrialCohgramFreq', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the frequencies']);
A = registerResource(A, 'PfcHcStartTrialByTrialCohgramTimes', 'numeric', {1,[]},...
    'pfcHcStartTrialByTrialCohgramTimes', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the times']);
A = registerResource(A, 'CohgramTrialsCorrectError', 'cell', {1, 1}, ...
   'cohgramTrialsCorrectError', '1 for correct trial 0 for error');
A = registerResource(A, 'PfcHcStartTrialByTrialCoherency', 'tsdArray', {1,1},...
    'pfcHcStartTrialByTrialCoherency', ...
    ['coherency  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, on a trial-by-trial basis']);
A = registerResource(A, 'PfcHcStartTrialByTrialCohgramFreq', 'numeric', {1,[]},...
    'pfcHcStartTrialByTrialCoherencyFreq', ...
    ['coherency gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the frequencies']);
A = registerResource(A, 'PfcHcStartTrialByTrialCohgramTimes', 'numeric', {1,[]},...
    'pfcHcStartTrialByTrialCoherencyTimes', ...
    ['coherency gram  between prefrontal and hippocampal EEG', ...
    'thiggered on startTrial, the times']);
A = registerResource(A, 'PfcStartTrialByTrialSpecgram', 'tsdArray', {1,1}, ...
    'pfcStartTrialByTrialSpecgram', ...
    ['spec gram of the prefrontal EEG, triggered by startTrial']);
A = registerResource(A, 'PfcStartTrialByTrialSpecgramFreq', 'numeric', {1,[]}, ...
    'pfcStartTrialByTrialSpecgramFreq', ...
    ['spec gram of the prefrontal EEG, triggered by startTrial, the frequencies']);
A = registerResource(A, 'PfcStartTrialByTrialSpecgram', 'tsdArray', {1,1}, ...
    'pfcStartTrialByTrialSpecgram', ...
    ['spec gram of the prefrontal EEG, triggered by startTrial, the times']);
A = registerResource(A, 'HcStartTrialByTrialSpecgram', 'tsdArray', {1,1}, ...
    'hcStartTrialByTrialSpecgram', ...
    ['spec gram of the hippocampal EEG, triggered by startTrial']);
A = registerResource(A, 'HcStartTrialByTrialSpecgramFreq', 'numeric', {1,[]}, ...
    'hcStartTrialByTrialSpecgramFreq', ...
    ['spec gram of the hippocampal EEG, triggered by startTrial, the frequencies']);
A = registerResource(A, 'HcStartTrialByTrialSpecgram', 'tsdArray', {1,1}, ...
    'hcStartTrialByTrialSpecgram', ...
    ['spec gram of the hippocampal EEG, triggered by startTrial, the times']);




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
cohgramTrialsCorrectError = (ce(:))';
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
[C,phi,S12,S1,S2,t,f]=cohgramc(dtPfc,dtHc,movingwin,params);
pfcHcStartTrialByTrialCohgramFreq = (f(:))';
pfcHcStartTrialByTrialCohgramTimes = (t(:))';

pfcHcStartTrialByTrialCohgram = tsd(Range(startTrial),permute(C, [3 1 2])); 

movingwin = [1,0.5];
[S,t,f,Serr]=mtspecgramc(dtPfc,movingwin,params);
pfcStartTrialByTrialSpecgram = tsd(Range(startTrial), permute(S, [3 1 2]));
pfcStartTrialByTrialSpecgramFreq = (f(:))';
pfcStartTrialByTrialSpecgramTimes = (t(:))';
[S,t,f,Serr]=mtspecgramc(dtHc,movingwin,params);
hcStartTrialByTrialSpecgram = tsd(Range(startTrial), permute(S, [3 1 2]));
hcStartTrialByTrialSpecgramFreq = (f(:))';
hcStartTrialByTrialSpecgramTimes = (t(:))';

%%%%%%%%%
win = [5 10]
dtPfc= createdatamatc(deegPfc, stTrial, params.Fs, win);
dtHc= createdatamatc(deegHc, stTrial, params.Fs, win);
[C,phi,S12,S1,S2,f,confC,phierr,Cerr]=coherencyc(dtPfc, dtHc,params);
pfcHcStartTrialByTrialCoherencyFreq = (f(:))';
pfcHcStartTrialByTrialCoherenctTimes = (t(:))';

C = C';
pfcHcStartTrialByTrialCoherency= tsd(Range(startTrial),C); 

cd(parent_dir(A));
A = saveAllResources(A);
%%%%%%%%

