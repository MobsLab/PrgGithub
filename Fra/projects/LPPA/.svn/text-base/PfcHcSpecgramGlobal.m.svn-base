function A = PfcHcSpecgramGlobal(A)

A= getResource(A, 'PfcTrace');
A = getResource(A, 'HcTrace');
A = getResource(A, 'MazeInterval');
A = getResource(A, 'Vs');
Vs = Vs{1};

mazeInterval = mazeInterval{1};
A = registerResource(A, 'PfcSpecgram', 'tsdArray', {1,1},...
    'pfcSpecgram', ...
    ['specgram  for prefrontal  EEG', ...
    'for the entire maze period']);

A = registerResource(A, 'HcSpecgram', 'tsdArray', {1,1},...
    'hcSpecgram', ...
    ['specgram  for hippocampal  EEG', ...
    'for the entire maze period']);


cd(current_dir(A));

[p,dset,e] = fileparts(current_dir(A));
eegfname = [dset 'eeg' num2str(pfcTrace) '.mat'];
load(eegfname)
eval(['EEGpfc = EEG' num2str(pfcTrace), ';']);
eval(['clear EEG' num2str(pfcTrace) ';']);
EEGpfc = Restrict(EEGpfc, mazeInterval);
st = StartTime(EEGpfc);
FsOrig = 1 / median(diff(Range(EEGpfc, 's')));
times = Range(EEGpfc);

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

[S,t,f,Serr]=mtspecgramc(deegPfc,movingwin,params);

PfcHcSpecgramFreq = f;
save /home/fpbatta/Data/LPPA/PfcHcSpecgramFreq PfcHcSpecgramFreq
%keyboard
%all this fuss is necessary to accommodate for EEG recordigns with possible
%gaps in them 


t1 = 0:(1/FsOrig):((1/FsOrig)*(length(times)-1));
[t2, ix] = Restrict(ts(t1), t-movingwin(1)/2);
times = times(ix);
 
 pfcSpecgram = tsd(times, S);

 [S,t,f,Serr]=mtspecgramc(deegHc,movingwin,params);
 hcSpecgram = tsd(times, S);

 

cd(parent_dir(A));
A = saveAllResources(A);
