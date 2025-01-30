function SpindlePhase(datasets)

parent_dir = '~/Data/LPPA/';
%  eeg_dir = '/media/DataExt3/Data/'

cd(parent_dir);
A = Analysis(pwd);

fileN = 'SpindlesPhaseModulation.mat';
dataDir = '/media/DataExt3/Data/';

for i=1:length(datasets)

  try

    A = getResource(A,'SpikeData',datasets{i});

    T = zeros(2,1);

    A = getResource(A,'Sleep1DeltaEpoch',datasets{i});
    A = getResource(A,'Sleep1SpindleEpoch',datasets{i});
    swsEpoch{1} = union(sleep1DeltaEpoch{1},sleep1SpindleEpoch{1});
    T(1) = sum(Data(length(swsEpoch{1},'min')));

    A = getResource(A,'Sleep2DeltaEpoch',datasets{i});
    A = getResource(A,'Sleep2SpindleEpoch',datasets{i});
    swsEpoch{2} = union(sleep2DeltaEpoch{1},sleep2SpindleEpoch{1});
    T(2) = sum(Data(length(swsEpoch{1},'min')));

    [dummy, ds dummy] = fileparts(datasets{i});

    if any(T>4) 

      spindlePhaseLocal_S1 = {};
      spindlePhaseLocal_S2 = {};

      spindleTroughsLocal_S1 = {};
      spindleTroughsLocal_S2 = {};

      spindlePeaksLocal_S1 = {};
      spindlePeaksLocal_S2 = {};

      spindleEpochLocal_S1 = {};
      spindleEpochLocal_S2 = {};

      for t=1:4
  
	fname = [datasets{i} filesep ds 'eeg' num2str(t) '.mat'];
	if ~exist(fname)
	  if exist([fname '.gz'])
	    eval(['!gunzip ' fname '.gz'])
	  end
	end

	load(fname);
	eval(['eeg = EEG' num2str(t)]);
	eval(['clear EEG' num2str(t)]);
	eval(['!gzip ' fname ' &'])

	dEeg = Data(eeg);
	dEeg = resample(dEeg,1,10);
	rg = Range(eeg);
	rg = rg(1:10:end);
	eeg = tsd(rg,dEeg);
	rg = Range(eeg,'s');
	f = 1/median(diff(rg));

	eegR{1} = Restrict(eeg,swsEpoch{1});
	eegR{2} = Restrict(eeg,swsEpoch{2});

	clear dEeg eeg;

	for s=1:2

	  if T(s) > 4

	    b = fir1(96,[10 15]/(f/2));
	    dEegF = filtfilt(b,1,Data(eegR{s}));
	    dEegF = zscore(dEegF);
	    dEegFabs = abs(dEegF);
	    dEegFabs = convn(dEegFabs,gausswin(20),'same')/sum(gausswin(20));
	    env = tsd(Range(eegR{s}),dEegFabs);
	    
	    spindleEpoch = thresholdIntervals(env,1);
	    spindleEpoch = mergeCloseIntervals(spindleEpoch,1000);
	    spindleEpoch = dropShortIntervals(spindleEpoch,5000);
	    spindleEpoch = dropLongIntervals(spindleEpoch,100000);
	    spindleEpoch = mergeCloseIntervals(spindleEpoch,5000);

	    h = hilbert(dEegF);

	    eegF = tsd(Range(eegR{s}),dEegF);
	    eegF = Restrict(eegF,spindleEpoch);
	    dEegF = Data(eegF);
	    d1 = [0;diff(dEegF)];
	    d2 = [diff(dEegF);0];
	    pks = find(d1<0 & d2>0); % "classical" extracellular peaks (our recordings are inversed)
	    trs = find(d1>0 & d2<0); %idem 

	    rg = Range(eegF);
	    spindlePks = tsd(rg(pks),dEegF(pks));
	    spindleTrs = tsd(rg(trs),dEegF(trs));

	    st = Start(spindleEpoch);
	    st = Restrict(spindlePks,ts(st),'align','closest');

	    spindleEpoch = intervalSet(Range(st),End(spindleEpoch));
  
	    ph = atan2(imag(h),real(h)); %0 rad, 'classical' troughs, pi rad. 'classical' peaks

	    ph = tsd(Range(eegR{s}),ph);
	    Sspin = Restrict(S,spindleEpoch);

	    phS = {};

	    for c=1:length(Sspin)
	      phS = [phS;{Restrict(ph,Sspin{c})}];
	    end

	    eval(['spindlePhaseLocal_S' num2str(s) '{' num2str(t) '} = phS;']);
	    eval(['spindleEpochLocal_S' num2str(s) '{' num2str(t) '} = spindleEpoch;']);
	    eval(['spindleTroughsLocal_S' num2str(s) '{' num2str(t) '} = spindleTrs;']);
	    eval(['spindlePeaksLocal_S' num2str(s) '{' num2str(t) '} = spindlePks;']);
	  
	  end

	end

      end

      save([datasets{i} filesep fileN],'spindlePhaseLocal_S1','spindlePhaseLocal_S2','spindleEpochLocal_S1','spindleEpochLocal_S2',... 
	'spindleTroughsLocal_S1','spindleTroughsLocal_S2','spindlePeaksLocal_S1','spindlePeaksLocal_S2');

    end

  catch
    warning(lasterr)
  end
end