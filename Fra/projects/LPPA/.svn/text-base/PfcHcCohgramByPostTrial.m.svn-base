function A = PfcHcCohgramByPostTrial(A)
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
A = getResource(A, 'PostReward');
postReward = postReward{1};
A = getResource(A, 'CorrectError');
correctError= correctError{1};


A = registerResource(A, 'PfcHcPostRewardByTrialCohgram', 'tsdArray', {1,1},...
    'pfcHcPostRewardByTrialCohgram', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on PostReward, on a trial-by-trial basis']);
A = registerResource(A, 'PfcHcPostRewardByTrialCohgramFreq', 'numeric', {1,[]},...
    'pfcHcPostRewardByTrialCohgramFreq', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on PostReward, the frequencies']);
A = registerResource(A, 'PfcHcPostRewardByTrialCohgramTimes', 'numeric', {1,[]},...
    'pfcHcPostRewardByTrialCohgramTimes', ...
    ['coherence gram  between prefrontal and hippocampal EEG', ...
    'thiggered on PostReward, the times']);
A = registerResource(A, 'CohgramTrialsCorrectError', 'cell', {1, 1}, ...
   'cohgramTrialsCorrectError', '1 for correct trial 0 for error');
A = registerResource(A, 'PfcHcPostRewardByTrialCoherency', 'tsdArray', {1,1},...
    'pfcHcPostRewardByTrialCoherency', ...
    ['coherency  between prefrontal and hippocampal EEG', ...
    'thiggered on PostReward, on a trial-by-trial basis']);
A = registerResource(A, 'PfcHcPostRewardByTrialCohgramFreq', 'numeric', {1,[]},...
    'pfcHcPostRewardByTrialCoherencyFreq', ...
    ['coherency gram  between prefrontal and hippocampal EEG', ...
    'thiggered on PostReward, the frequencies']);
A = registerResource(A, 'PfcHcPostRewardByTrialCohgramTimes', 'numeric', {1,[]},...
    'pfcHcPostRewardByTrialCoherencyTimes', ...
    ['coherency gram  between prefrontal and hippocampal EEG', ...
    'thiggered on PostReward, the times']);
A = registerResource(A, 'PfcPostRewardByTrialSpecgram', 'tsdArray', {1,1}, ...
    'pfcPostRewardByTrialSpecgram', ...
    ['spec gram of the prefrontal EEG, triggered by PostReward']);
A = registerResource(A, 'PfcPostRewardByTrialSpecgramFreq', 'numeric', {1,[]}, ...
    'pfcPostRewardByTrialSpecgramFreq', ...
    ['spec gram of the prefrontal EEG, triggered by PostReward, the frequencies']);
A = registerResource(A, 'PfcPostRewardByTrialSpecgram', 'tsdArray', {1,1}, ...
    'pfcPostRewardByTrialSpecgram', ...
    ['spec gram of the prefrontal EEG, triggered by PostReward, the times']);
A = registerResource(A, 'HcPostRewardByTrialSpecgram', 'tsdArray', {1,1}, ...
    'hcPostRewardByTrialSpecgram', ...
    ['spec gram of the hippocampal EEG, triggered by PostReward']);
A = registerResource(A, 'HcPostRewardByTrialSpecgramFreq', 'numeric', {1,[]}, ...
    'hcPostRewardByTrialSpecgramFreq', ...
    ['spec gram of the hippocampal EEG, triggered by PostReward, the frequencies']);
A = registerResource(A, 'HcPostRewardByTrialSpecgram', 'tsdArray', {1,1}, ...
    'hcPostRewardByTrialSpecgram', ...
    ['spec gram of the hippocampal EEG, triggered by PostReward, the times']);




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


[postReward, ix] = Restrict(postReward, st+win(1)*10000, et-win(2)*10000);
ce = Data(correctError);
ce = ce(ix);
cohgramTrialsCorrectError = (ce(:))';
[t, ix] = Restrict(EEGpfc, postReward);

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
pfcHcPostRewardByTrialCohgramFreq = (f(:))';
pfcHcPostRewardByTrialCohgramTimes = (t(:))';

pfcHcPostRewardByTrialCohgram = tsd(Range(postReward),permute(C, [3 1 2])); 

movingwin = [1,0.5];
[S,t,f,Serr]=mtspecgramc(dtPfc,movingwin,params);
pfcPostRewardByTrialSpecgram = tsd(Range(postReward), permute(S, [3 1 2]));
pfcPostRewardByTrialSpecgramFreq = (f(:))';
pfcPostRewardByTrialSpecgramTimes = (t(:))';
[S,t,f,Serr]=mtspecgramc(dtHc,movingwin,params);
hcPostRewardByTrialSpecgram = tsd(Range(postReward), permute(S, [3 1 2]));
hcPostRewardByTrialSpecgramFreq = (f(:))';
hcPostRewardByTrialSpecgramTimes = (t(:))';

%%%%%%%%%
win = [5 10]
dtPfc= createdatamatc(deegPfc, stTrial, params.Fs, win);
dtHc= createdatamatc(deegHc, stTrial, params.Fs, win);
[C,phi,S12,S1,S2,f,confC,phierr,Cerr]=coherencyc(dtPfc, dtHc,params);
pfcHcPostRewardByTrialCoherencyFreq = (f(:))';
pfcHcPostRewardByTrialCoherenctTimes = (t(:))';

C = C';
pfcHcPostRewardByTrialCoherency= tsd(Range(postReward),C); 

cd(parent_dir(A));
A = saveAllResources(A);
%%%%%%%%

