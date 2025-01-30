function A = Analysis(A)

%Parameters

b = fir1(96,[0.1 0.3]);
peakStdRatio = 5;
thresStdRatio = 2;

A = getResource(A,'CellNames');
A = getResource(A,'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};
A = getResource(A,'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
A = getResource(A,'MazeEpoch');
mazeEpoch = mazeEpoch{1};

A = registerResource(A, 'MidRipS1', 'tsdArray', {1, 2}, ...
    'midRipS1', ['array (2 TT) of ts of sleep1 ripples at peak']);

A = registerResource(A, 'StRipS1', 'tsdArray', {1, 2}, ...
    'stRipS1', ['ts of sleep1 ripples starts']);

A = registerResource(A, 'EndRipS1', 'tsdArray', {1, 2}, ...
    'endRipS1', ['ts of end sleep1 ripples ends']);

A = registerResource(A, 'MidRipS2', 'tsdArray', {1, 2}, ...
    'midRipS2', ['ts of sleep2 ripples at peak']);

A = registerResource(A, 'StRipS2', 'tsdArray', {1, 2}, ...
    'stRipS2', ['ts of sleep2 ripples starts']);

A = registerResource(A, 'EndRipS2', 'tsdArray', {1, 2}, ...
    'endRipS2', ['ts of end sleep2 ripples ends']);

[p,dataset,e] = fileparts(current_dir(A));
clear p e;


stRipS1 = {};
midRipS1 = {};
endRipS1 = {};

stRipS2 = {};
midRipS2 = {};
endRipS2 = {};

for i=1:2

		
	%load EEG
	eegfname = [current_dir(A) filesep dataset 'eeg' num2str(i+4) '.mat'];
	if exist([eegfname '.gz'])
		display(['unzipping file ' eegfname]);
		eval(['!gunzip ' eegfname '.gz']);
	end
	load(eegfname)
	display(['zipping file ' eegfname]);
	eval(['!gzip ' eegfname]);	
	

	eval(['eegHc1 = Restrict(EEG' num2str(i+4) ',sleep1Epoch);'])
	eval(['eegHc2 = Restrict(EEG' num2str(i+4) ',sleep2Epoch);'])
	
	eval(['clear EEG' num2str(i+4)]);
	
	%Filter EEG and find Ripples
	
	eegFilt = filtfilt(b,1,Data(eegHc1));
	sigma = std(eegFilt);
	eegFilt = tsd(Range(eegHc1),eegFilt);
	[stRipS1{i} midRipS1{i} endRipS1{i}] = findRipples(eegFilt,peakStdRatio*sigma,thresStdRatio*sigma);
	
	clear eegFilt eegHc1
	
	eegFilt = filtfilt(b,1,Data(eegHc2));
	sigma = std(eegFilt);
	eegFilt = tsd(Range(eegHc2),eegFilt);
	[stRipS2{i} midRipS2{i} endRipS2{i}] = findRipples(eegFilt,peakStdRatio*sigma,thresStdRatio*sigma);

	
	clear eegFilt eegHc2

end

%  keyboard

stRipS1 = tsdArray(stRipS1);
midRipS1 = tsdArray(midRipS1);
endRipS1 = tsdArray(endRipS1);

stRipS2 = tsdArray(stRipS2);
midRipS2 = tsdArray(midRipS2);
endRipS2 = tsdArray(endRipS2);


A = saveAllResources(A);


