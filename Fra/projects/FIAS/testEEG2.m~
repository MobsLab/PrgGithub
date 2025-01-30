
outcomeIntervalBegin = 20000;
outcomeIntervalEnd = 40000;


trials = intervalSet(Range(trialOutcome)-outcomeIntervalBegin, Range(trialOutcome)+outcomeIntervalEnd);

EEGIntervalHc = Restrict(EEGhc, trials);

% Filtering EEG trace with a band pass filter in the range of ripples
filtSpec = fdesign.bandpass('N,FC1,FC2')
setspecs(filtSpec, 20, 0.3, 1);

filtEEGIntervalHc = tsd(Range(EEGIntervalHc),filter(butter(filtSpec),Data(EEGIntervalHc)));

clear filtSpec

%Filtering EEG trace with a high pass filter > 5Hz to leave slow oscillation and keep sharp waves
filtSpec = fdesign.bandpass('N,FC')
setspecs(filtSpec, 50, 0.01, 0.1);

highEEGIntervalHc = tsd(Range(EEGIntervalHc),filter(butter(filtSpec),Data(EEGIntervalHc)));

stopTrials = Stop(trials);
startTrials = Start(trials);
outCome = Range(trialOutcome);

%for t=1:length(trialOutcome)
t = length(trialOutcome)

	intervalOutcome = intervalSet(startTrials(t),stopTrials(t));
	time = Range(Restrict(EEGIntervalHc,intervalOutcome));
	dataEEGIntervalHc = Data(Restrict(EEGIntervalHc,intervalOutcome));
	dataFiltEEGIntervalHc = Data(Restrict(filtEEGIntervalHc,intervalOutcome));
	dataHighEEGIntervalHc = Data(Restrict(highEEGIntervalHc,intervalOutcome));

	figure(1)
	%plot(time,dataEEGIntervalHc,time,dataFiltEEGIntervalHc,'red',time,dataHighEEGIntervalHc,'green')
	plot(time-startTrials(t),dataFiltEEGIntervalHc,'red',time-startTrials(t),dataHighEEGIntervalHc,'green')
	line([outCome(t)-startTrials(t) outCome(t)-startTrials(t)],[max(max(dataEEGIntervalHc)) min(min(dataEEGIntervalHc))])
	%keyboard
	pause(2)

%end

clear time t stopTrials startTrials outCome intervalOutcome%dataEEGIntervalHc dataFiltEEGIntervalHc