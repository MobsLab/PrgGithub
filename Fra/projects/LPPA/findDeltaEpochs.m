function A =findDeltaEpochs(A)

%  don't work for all sessions, now it loads from SleepSpecgramGloabl.mat in each directory
%  %  A = getResource(A, 'Sleep1Specgram');
%  %  A = getResource(A, 'Sleep2Specgram');
%  %  A = getResource(A, 'SleepSpecgramFreq');

cd(current_dir(A))
load('SleepSpecgramGlobal.mat')
cd(parent_dir(A));

A = getResource(A, 'Sleep1Epoch');
sleep1Epoch = sleep1Epoch{1};
A = getResource(A, 'Sleep2Epoch');
sleep2Epoch = sleep2Epoch{1};

A = registerResource(A, 'Sleep1DeltaAmp', 'tsdArray', {1,1}, ...
    'sleep1DeltaAmp', ...
    ['log-amplitude of delta (0.5-4 Hz) in sleep 1 in best cortical EEG'],'mfile');

A = registerResource(A, 'Sleep2DeltaAmp', 'tsdArray', {1,1}, ...
    'sleep2DeltaAmp', ...
    ['log-amplitude of delta (0.5-4 Hz) in sleep 2 in best cortical EEG'],'mfile');

A = registerResource(A, 'Sleep1SpindleAmp', 'tsdArray', {1,1}, ...
    'sleep1SpindleAmp', ...
    ['log-amplitude of spindles (8-20 Hz) in sleep 1 in best cortical EEG'],'mfile');

A = registerResource(A, 'Sleep2SpindleAmp', 'tsdArray', {1,1}, ...
    'sleep2SpindleAmp', ...
    ['log-amplitude of spindle (8-20 Hz) in sleep 2 in best cortical EEG'],'mfile');

A = registerResource(A, 'Sleep1DeltaEpochs', 'cell', {1,1}, ...
    'sleep1DeltaEpochs', ...
    ['intervals of high delta amplitude in sleep 1'],'mfile');

A = registerResource(A, 'Sleep2DeltaEpochs', 'cell', {1,1}, ...
    'sleep2DeltaEpochs', ...
    ['intervals of high delta amplitude in sleep 2'],'mfile');


freqDelta = find(sleepSpecgramFreq > 0.5 & sleepSpecgramFreq < 4);
freqSpindle = find(sleepSpecgramFreq > 8 & sleepSpecgramFreq < 20);

ok=0;

while ~ok

	figure(1), clf
	figure(2), clf
	figure(3), clf
	%for tr = 1:6
	for tr = 4
		[p,dset,e] = fileparts(current_dir(A));
		
		eegfname = [dset 'eeg' num2str(tr) '.mat'];
		cd(current_dir(A));
		if exist([eegfname '.gz'])
			display(['unzipping file ' eegfname]);
			eval(['!gunzip ' eegfname '.gz']);
		end
		load(eegfname);
		cd(parent_dir(A));
		eval(['EEG = EEG' num2str(tr), ';']);
		eval(['clear EEG' num2str(tr) ';']);
		
		S = Data(sleep1Specgram{tr});
		sDelta = log10(sum(S(:,freqDelta), 2)+eps);
		sDelta = tsd(Range(sleep1Specgram{tr}), sDelta);
		sDsleep1{tr} = sDelta;
		sSpindle = log10(sum(S(:,freqSpindle), 2)+eps);
		sSpindle = tsd(Range(sleep1Specgram{tr}), sSpindle);
		sSsleep1{tr} = sSpindle;
		
		times = Range(sleep1Specgram{tr}, 's');
		figure(1), clf
		imagesc(times, sleepSpecgramFreq, log10(abs(S')+eps)); axis xy
		
		figure(2), clf
		plot(Range(sDelta, 's'), Data(sDelta))
		hold on
		plot(Range(sSpindle, 's'), Data(sSpindle), 'r')
		figure(3), clf
		EEGs = Restrict(EEG, sleep1Epoch);
		plot(Range(EEGs, 's'), Data(EEGs))
		figure(1), sdur = get(gca, 'xlim');
		figure(2), set(gca, 'xlim', sdur);
		figure(3), set(gca, 'xlim', sdur);
		
		
		display('sleep1');
		tr
		figure(2)
		gg = ginput(1);
		gThr = gg(2);
		sEpoch = subset(sDelta, find(Data(sDelta) > gThr));
		mm = median(diff(Range(sDelta))) * 0.51;
		sEpoch = intervalSet((Range(sEpoch) - mm), (Range(sEpoch) + mm));
		sEpoch = union(sEpoch, intervalSet([],[]));
		sleep1DEpoch{tr} = sEpoch;
		figure(2)
		sdr = Restrict(sDelta, sEpoch);
		plot(Range(sdr, 's'), Data(sdr), 'g.', 'MarkerSize', 5);
		figure(3), hold on 
		es = Restrict(EEGs, sEpoch);
		plot(Range(es, 's'), Data(es), 'g')
		%    keyboard
		
		S = Data(sleep2Specgram{tr});
		sDelta = log10(sum(S(:,freqDelta), 2)+eps);
		sDelta = tsd(Range(sleep2Specgram{tr}), sDelta);
		sDsleep2{tr} = sDelta;
		sSpindle = log10(sum(S(:,freqSpindle), 2)+eps);
		sSpindle = tsd(Range(sleep2Specgram{tr}), sSpindle);
		sSsleep2{tr} = sSpindle;
		
		times = Range(sleep2Specgram{tr}, 's');
		figure(1), clf
		imagesc(times, sleepSpecgramFreq, log10(abs(S')+eps)); axis xy
		figure(2), clf
		plot(Range(sDelta, 's'), Data(sDelta))
		hold on
		plot(Range(sSpindle, 's'), Data(sSpindle), 'r')
		figure(3), clf
		EEGs = Restrict(EEG, sleep2Epoch);
		plot(Range(EEGs, 's'), Data(EEGs))
		
		figure(1), sdur = get(gca, 'xlim');
		figure(2), set(gca, 'xlim', sdur);
		figure(3), set(gca, 'xlim', sdur);
		
		display('sleep2');
		tr
		figure(2)
		gg = ginput(1);
		gThr = gg(2);
		sEpoch = subset(sDelta, find(Data(sDelta)  > gThr));
		mm = median(diff(Range(sDelta))) * 0.51;
		sEpoch = intervalSet((Range(sEpoch) - mm), (Range(sEpoch) + mm));
		sEpoch = union(sEpoch, intervalSet([],[]));
		sleep2DEpoch{tr} = sEpoch;
		figure(2)
		sdr = Restrict(sDelta, sEpoch);
		plot(Range(sdr, 's'), Data(sdr), 'g.', 'MarkerSize', 5);
		figure(3), hold on 
		es = Restrict(EEGs, sEpoch);
		plot(Range(es, 's'), Data(es), 'g' )
		%    keyboard
	end
	
	ok = (questdlg('Is is ok for you?') == 'Y');
	
end;

%bestEeg = input('Which is the best EEG?');
bestEeg = 4;
sleep1DeltaAmp = sDsleep1{bestEeg};
sleep1SpindleAmp = sSsleep1{bestEeg};
sleep1DeltaEpochs = sleep1DEpoch{bestEeg};
sleep2DeltaAmp = sDsleep2{bestEeg};
sleep2SpindleAmp = sSsleep2{bestEeg};
sleep2DeltaEpochs = sleep2DEpoch{bestEeg};

A = saveAllResources(A);