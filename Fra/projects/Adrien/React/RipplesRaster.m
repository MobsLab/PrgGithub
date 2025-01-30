function A = Analysis(A)


%Parameters

b = fir1(96,[0.1 0.3]);
binSizeMaze = 1000;

A = getResource(A,'SpikeData');
nbCells = length(S);

A = getResource(A,'CellNames');
A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};
A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
A = getResource(A,'MazeEpoch');
mazeEpoch = mazeEpoch{1};


cd(current_dir(A));
dset = current_dataset(A);
[dummy1,dataset,dummy2] = fileparts(current_dir(A));


%load EEG

eegfname = [dataset 'eeg5.mat'];
if exist([eegfname '.gz'])
    display(['unzipping file ' eegfname]);
    eval(['!gunzip ' eegfname '.gz']);
    isZip = true;
end
load(eegfname)

eeg5 = Restrict(EEG5,sleep2Epoch);

clear EEG1 EEG5

%Filter EEG and find Ripples

eegSFilt = filtfilt(b,1,Data(eeg5));
sigma = std(eegSFilt);
eegSFilt = tsd(Range(eeg5),eegSFilt);
[stRip midRip2 endRip] = findRipples(eegSFilt,5*sigma,2*sigma);
midRip2 = Range(midRip2);

clear eegS b dset stRip endRip dataDir 

Q = makeQfromS(S,10);


spwTriggCells = sparse(length(midRip2),100);
deegRipples = zeros(length(midRip2),209);

for i=1:length(midRip2)

	dQtmp = Data(Restrict(Q,midRip2(i)-500,midRip2(i)+500,'align','closest'));
	spwTriggCells(i,:) = sparse(sum(dQtmp'));
	deeg = Data(Restrict(eegSFilt,midRip2(i)-500,midRip2(i)+500,'align','closest'));
%  	keyboard
	deegRipples(i,:) = deeg';
end



figure(1),clf
plotyy([1:100],sum(spwTriggCells),[1:209],mean(deegRipples));

keyboard;