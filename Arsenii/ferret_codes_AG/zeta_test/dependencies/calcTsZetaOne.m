function [vecRefT,vecRealDiff,vecRealFrac,vecRealFracLinear,cellRandT,cellRandDiff,dblZetaP,dblZETA,intZETALoc] = ...
		calcTsZetaOne(vecTraceT,vecTraceAct,vecEventStarts,dblUseMaxDur,intResampNum,boolDirectQuantile,dblJitterSize,boolStitch,dblSuperResFactor)
	%calcTsZeta Calculates neuronal responsiveness index zeta for timeseries data
	%[vecRefT,vecRealDiff,vecRealFrac,vecRealFracLinear,cellRandT,cellRandDiff,dblZetaP,dblZETA,intZETALoc] = ...
	%	calcTsZetaOne(vecTraceT,vecTraceAct,vecEventStarts,dblUseMaxDur,intResampNum,boolDirectQuantile,dblJitterSize,boolStitch,dblSuperResFactor)
	
	%% check inputs and pre-allocate error output
	vecRefT = [];
	vecRealDiff = [];
	vecRealFrac = [];
	vecRealFracLinear = [];
	cellRandT = [];
	cellRandDiff = [];
	dblZetaP = 1;
	dblZETA = 0;
	intZETALoc = nan;
	
	%check parallel
	objPool = gcp('nocreate');
	if isempty(objPool) || ~isprop(objPool,'NumWorkers') || objPool.NumWorkers < 4
		boolUseParallel = false;
	else
		boolUseParallel = true;
	end
	
	%% reduce data
	if size(vecEventStarts,2)>2,error([mfilename ':IncorrectMatrixForm'],'Incorrect input form for vecEventStarts; size must be [m x 1] or [m x 2]');end
	%discard leading/lagging data
	vecEventStarts = vecEventStarts(:,1);
	dblPreUse = -dblUseMaxDur*dblJitterSize;
	dblPostUse = dblUseMaxDur*(dblJitterSize+1);
	
	dblStartT = min(vecEventStarts) + dblPreUse*2;
	dblStopT = max(vecEventStarts) + dblPostUse*2;
	indRemoveEntries = (vecTraceT < dblStartT) | (vecTraceT > dblStopT);
	vecTraceT(indRemoveEntries) = [];
	vecTraceAct(indRemoveEntries) = [];
	
	%rescale
	dblMin = min(vecTraceAct);
	dblMax = max(vecTraceAct);
	dblRange = (dblMax-dblMin);
	if dblRange == 0
		dblRange = 1;
		warning([mfilename ':ZeroVar'],'Input data has zero variance');
	end
	vecTraceAct = (vecTraceAct-dblMin)./dblRange;
	
	%% build pseudo data, stitching stimulus periods
	if boolStitch
		[vecPseudoT,vecPseudoTrace,vecPseudoStartT] = getPseudoTimeSeries(vecTraceT,vecTraceAct,vecEventStarts,dblUseMaxDur);
	else
		vecPseudoT = vecTraceT;
		vecPseudoTrace = vecTraceAct;
		vecPseudoStartT = vecEventStarts;
	end
	
	%stitch trials
	vecPseudoTrace = vecPseudoTrace - min(vecPseudoTrace(:));
	if numel(vecPseudoT) < 3
		return;
	end
	
	
	%% get trial responses
	[vecRealDiff,vecRealFrac,vecRealFracLinear,vecRefT] = ...
		getTraceOffsetOne(vecPseudoT,vecPseudoTrace,vecPseudoStartT',dblUseMaxDur,dblSuperResFactor);
	[dblMaxD,intZETALoc]= max(abs(vecRealDiff));
	intSamples = numel(vecRealDiff);
	intTrials = numel(vecPseudoStartT);
	dblSampHz = 1/max(diff(vecPseudoT));
	dblSampsPerDur = dblSampHz*dblUseMaxDur;
	
	%check if stimulus times are aligned with sample times
	if all(ismember(vecPseudoStartT,vecPseudoT))
		dblSuperResFactorOrRefT = vecRefT;
	else
		dblSuperResFactorOrRefT = dblSuperResFactor;
	end
	
	%% run bootstraps; try parallel, otherwise run normal loop
	% run pre-set number of iterations
	cellRandT = cell(1,intResampNum);
	cellRandDiff = cell(1,intResampNum);
	vecMaxRandD = nan(1,intResampNum);
	vecStartOnly = vecPseudoStartT(:);
	intJitterDistro=2;
	if intJitterDistro == 1
		vecJitterPerTrial = dblJitterSize*linspace(-dblUseMaxDur,dblUseMaxDur,intTrials)';
		matJitterPerTrial = nan(intTrials,intResampNum);
		for intResampling=1:intResampNum
			matJitterPerTrial(:,intResampling) = vecJitterPerTrial(randperm(numel(vecJitterPerTrial)));
		end
	else
		%uniform jitters between dblJitterSize*[-tau, +tau]
		matJitterPerTrial = nan(intTrials,intResampNum);
		for intResampling=1:intResampNum
			matJitterPerTrial(:,intResampling) = dblJitterSize*dblUseMaxDur*((rand(size(vecStartOnly))-0.5)*2);
		end
	end
	
	%discretize jitters if dblFs > intResampNum
	vecStepT = unique(diff(vecRefT));
	if dblSampsPerDur > intResampNum && numel(vecStepT)==1
		matJitterPerTrial=round(matJitterPerTrial/vecStepT(1))*vecStepT(1);
	end
	
	%% this part is only to check if matlab and python give the same exact results
	% unfortunately matlab's randperm() and numpy's np.random.permutation give different outputs even with
	% identical seeds and identical random number generators, so I've had to load in a table of random values here...
	boolTest = false;
	if boolTest
		fprintf('Loading deterministic jitter data for comparison with python\n')
		warning([mfilename ':DebugMode'],'set boolTest to false in calcTsZetaOne.m to suppress this warning')
		load('C:\Code\Python\zetapy\unit_tests\matJitterPerTrialTsZeta.mat');
		
		%reset rng
		rng(1,'mt19937ar');
	end
	
	%% run bootstraps
	if boolUseParallel
		parfor intResampling=1:intResampNum
			%% get random subsample
			vecStimUseOnTime = vecStartOnly + matJitterPerTrial(:,intResampling);
			
			%get temp offset
			[vecRandDiff,vecThisFrac,vecThisFracLinear,vecRandT] = getTraceOffsetOne(vecPseudoT,vecPseudoTrace,vecStimUseOnTime,dblUseMaxDur,dblSuperResFactorOrRefT);
			
			%assign data
			cellRandT{intResampling} = vecRandT;
			cellRandDiff{intResampling} = vecRandDiff - mean(vecRandDiff);
			vecMaxRandD(intResampling) = max(abs(cellRandDiff{intResampling}));
		end
	else
		for intResampling=1:intResampNum
			%% get random subsample
			vecStimUseOnTime = vecStartOnly + matJitterPerTrial(:,intResampling);
			
			%get temp offset
			[vecRandDiff,vecThisFrac,vecThisFracLinear,vecRandT] = getTraceOffsetOne(vecPseudoT,vecPseudoTrace,vecStimUseOnTime,dblUseMaxDur,dblSuperResFactorOrRefT);
			
			%assign data
			cellRandT{intResampling} = vecRandT;
			cellRandDiff{intResampling} = vecRandDiff - mean(vecRandDiff);
			vecMaxRandD(intResampling) = max(abs(cellRandDiff{intResampling}));
		end
	end
	
	%% calculate significance
	vecMaxRandD = vecMaxRandD(~isnan(vecMaxRandD));
	if numel(vecMaxRandD) < 3
		warning([mfilename ':DataTooSparse'],"Data is too sparse for jittering control; defaulting to p=1.0");
		dblZetaP = 1.0;
		dblZETA = 0;
	else
		[dblZetaP,dblZETA] = getZetaP(dblMaxD,vecMaxRandD,boolDirectQuantile);
	end
end

