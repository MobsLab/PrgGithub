function [dblZetaP,sZETA] = zetatstest(vecTime,vecData,matEventTimes,dblUseMaxDur,intResampNum,intPlot,boolDirectQuantile,dblJitterSize,boolStitch,dblSuperResFactor)
	%zetatstest Calculates responsiveness index zeta for timeseries data
	%syntax: [dblZetaP,sZETA] = zetatstest(vecTime,vecData,vecEventTimes,dblUseMaxDur,intResampNum,intPlot,boolDirectQuantile,dblJitterSize,boolStitch,dblSuperResFactor)
	%	input:
	%	- vecTime [N x 1]: time (s) corresponding to entries in vecValue
	%	- vecData [N x 1]: data values (e.g., calcium imaging dF/F0)
	%	- vecEventTimes [T x 1]: event on times (s), or [T x 2] including event off times
	%	- dblUseMaxDur: scalar (s), ignore all values beyond this duration after stimulus onset
	%								[default: median of trial start to trial start]
	%	- intResampNum: integer, number of resamplings (default: 100)
	%	- intPlot: integer, plotting switch (0=none, 1=traces only, 2=activity heat map as well) (default: 0)
	%	- boolDirectQuantile; boolean, switch to use the empirical
	%							null-distribution rather than the Gumbel approximation (default: false)
	%	- dblJitterSize: scalar, sets the temporal jitter window relative to dblUseMaxDur (default: 2)
	%	- boolStitch; boolean, use data-stitching to ensure continuous time (default: true)
	%	- dblSuperResFactor; scalar, upsampling of data when calculating zeta (default: 100)
	%
	%	output:
	%	- dblZetaP; Zenith of Event-based Time-locked Anomalies: responsiveness p-value
	%	- sZETA; structure with fields:
	%		- dblZetaP; p-value corresponding to ZETA
	%		- dblZETA; ZETA responsiveness statistic
	%		- dblD; temporal deviation value underlying ZETA
	%		- vecTimeSR; timestamps for upscaled data
	%		- matDataSR; upscaled data values
	%		- dblPeakT; time corresponding to ZETA
	%		- intPeakIdx; entry corresponding to ZETA
	%		- dblMeanZ; z-score based on mean-rate stim/base difference
	%		- dblMeanP; p-value based on mean-rate stim/base difference
	%		- vecMu_Dur; within-stimulus values used in mean-rate difference calculation
	%		- vecMu_Pre; outside-stimulus values used in mean-rate difference calculation
	%		- vecTime: timestamps of entries (corresponding to vecD)
	%		- vecD; temporal deviation vector of data
	%		- cellRandT; reference time vectors for randomly jittered data
	%		- cellRandDiff; deviation vectors for randomly jittered data
	%
	%v1.4 - rev20231019

	%Version history:
	%0.9 - 2021 October 29
	%	Created by Jorrit Montijn
	%1.0 - 2022 January 31
	%	Removed non-interpolating procedures [by JM]
	%1.1 - 2023 August 24
	%	Small changes, including changing output name of dblP to dblZetaP to conform to zetatest and
	%	clarify what it is the p-value of [by JM] 
	%1.2 - 2023 August 25
	%	Changed default jitter window to -2 to +2, same as zetatest [by JM] 
	%1.3 - 2023 September 21
	%	Improved computation time, now computes at about 66% duration
	%1.4 - 2023 October 19
	%	Updated outputs and documentation
	
	%% prep data
	%ensure orientation
	vecTime = vecTime(:);
	[vecTime,vecReorder] = sort(vecTime);
	vecData = vecData(:);
	vecData = vecData(vecReorder);
	
	%calculate stim/base difference?
	boolStopSupplied = false;
	dblMeanZ = nan;
	if size(matEventTimes,2) > 2
		matEventTimes = matEventTimes';
	end
	if size(matEventTimes,2) == 2
		boolStopSupplied = true;
	end
	
	%trial dur
	if ~exist('dblUseMaxDur','var') || isempty(dblUseMaxDur)
		dblUseMaxDur = min(diff(matEventTimes(:,1)));
	end
	if numel(dblUseMaxDur)>1
		dblUseMaxDurTtest = dblUseMaxDur(2);
		dblUseMaxDur = dblUseMaxDur(1);
	end
		
	%get resampling num
	if ~exist('intResampNum','var') || isempty(intResampNum)
		intResampNum = 250;
	end
	
	%get boolPlot
	if ~exist('intPlot','var') || isempty(intPlot)
		intPlot = 0;
	end
	
	%get boolVerbose
	if ~exist('boolDirectQuantile','var') || isempty(boolDirectQuantile)
		boolDirectQuantile = false;
	end
	
	%get dblJitterSize
	if ~exist('dblJitterSize','var') || isempty(dblJitterSize)
		dblJitterSize = 2; %original:1
	end
	assert(dblJitterSize>0,[mfilename ':WrongJitterInput'], sprintf('dblJitterSize must be a positive scalar, you requested %.3f',dblJitterSize));
	
	%get boolStitch
	if ~exist('boolStitch','var') || isempty(boolStitch)
		boolStitch = true;
	end

	%get dblJitterSize
	if ~exist('dblSuperResFactor','var') || isempty(dblSuperResFactor)
		dblSuperResFactor = 100; %original:100
	end
	
	%sampling interval
	dblSamplingInterval = median(diff(vecTime));
	
	%% build onset/offset vectors
	vecEventStarts = matEventTimes(:,1);
	
	%% check data length
	dblDataT0 = min(vecTime);
	dblReqT0 = min(vecEventStarts) - dblJitterSize*dblUseMaxDur;
	if dblDataT0 > dblReqT0
		warning([mfilename ':InsufficientDataLength'],"leading data preceding first event is insufficient for maximal jittering. You can suppress this warning using warning('off','zetatstest:InsufficientDataLength')")
	end
	dblDataT_end = max(vecTime);
	dblReqT_end = max(vecEventStarts) + dblJitterSize*dblUseMaxDur + dblUseMaxDur;
	if dblDataT_end < dblReqT_end
		warning([mfilename ':InsufficientDataLength'],"lagging data after last event is insufficient for maximal jittering. You can suppress this warning using warning('off','zetatstest:InsufficientDataLength')")
	end
	if vecEventStarts(1) < vecTime(1) || vecEventStarts(end) > vecTime(end)
		error([mfilename ':InsufficientDataLength'],"Event times supplied outside of time-series data. Please check your inputs and/or remove invalid events.")
	end
	
    %% get timeseries zeta
	[vecRefT,vecRealDiff,vecRealFrac,vecRealFracLinear,cellRandT,cellRandDiff,dblZetaP,dblZETA,intZETALoc] = ...
		calcTsZetaOne(vecTime,vecData,vecEventStarts,dblUseMaxDur,intResampNum,boolDirectQuantile,dblJitterSize,boolStitch,dblSuperResFactor);
	
	%get location
	dblMaxDTime = vecRefT(intZETALoc);
	dblD = vecRealDiff(intZETALoc);
	
	%% calculate mean-rate difference
	intMaxRep = size(vecEventStarts,1);
	vec2ndAct = zeros(intMaxRep,1);
	vec1stAct = zeros(intMaxRep,1);
	if boolStopSupplied
		%pre-allocate
		vecEventStops = matEventTimes(:,2);
		intTimeNum = numel(vecTime);
		if ~exist('dblUseMaxDurTtest','var') || isempty(dblUseMaxDurTtest)
			dblUseMaxDurTtest = dblUseMaxDur;
		end
		
		%go through trials to build spike time vector
		for intEvent=1:intMaxRep
			%% get original times
			dblStimStartT = vecEventStarts(intEvent);
			dblStimStopT = vecEventStops(intEvent);
			dblBaseStopT = dblStimStartT + dblUseMaxDurTtest;
			
			intStartT = max([1 find(vecTime > dblStimStartT,1) - 1]);
			intStopT = min([intTimeNum find(vecTime > dblStimStopT,1) + 1]);
			intEndT = min([intTimeNum find(vecTime > dblBaseStopT,1) + 1]);
			vecSelectFrames2 = (intStopT+1):intEndT;
			vecSelectFrames1 = intStartT:intStopT;
			
			%% get data
			vecUseTrace1 = vecData(vecSelectFrames1);
			vecUseTrace2 = vecData(vecSelectFrames2);
			
			%% get activity
			vec1stAct(intEvent) = mean(vecUseTrace1);
			vec2ndAct(intEvent) = mean(vecUseTrace2);
		end
		
		%get metrics
		indUseTrials = ~isnan(vec2ndAct) & ~isnan(vec1stAct);
		vecMu1 = vec1stAct(indUseTrials);
		vecMu2 = vec2ndAct(indUseTrials);
		[h,dblMeanP]=ttest(vecMu1,vecMu2);
		dblMeanZ = -norminv(dblMeanP/2);
	end
	
	%% get SR data
	if nargout > 1 || intPlot
		%set tol
		if dblSuperResFactor == 1
			vecRef2T = vecRefT;
		else
			dblSampInterval = median(diff(vecTime));
			dblTol = dblSampInterval/dblSuperResFactor;
			vecRef2T = uniquetol(vecRefT,dblTol);
		end
		
		%build interpolated data
		matTracePerTrialSR = getInterpolatedTimeSeries(vecTime,vecData,vecEventStarts(:,1),vecRef2T);
		indRemPoints = vecRef2T<0 | vecRef2T>dblUseMaxDur;
		vecRef2T(indRemPoints) = [];
		matTracePerTrialSR(:,indRemPoints)=[];
		vecMeanTrace = nanmean(matTracePerTrialSR,1)';
		vecSemTrace = nanstd(matTracePerTrialSR,[],1)'/sqrt(intMaxRep);
	end
	
	%% plot
	if intPlot
		%plot maximally 100 traces
		intPlotIters = min([numel(cellRandDiff) 100]);
		
		%maximize figure
		figure;
		drawnow;
		try
			try
				%try new method
				h = handle(gcf);
				h.WindowState = 'maximized';
			catch
				%try old method with javaframe (deprecated as of R2021)
				sWarn = warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
				drawnow;
				jFig = get(handle(gcf), 'JavaFrame');
				jFig.setMaximized(true);
				drawnow;
				warning(sWarn);
			end
		catch
		end
		
		if intPlot > 1
			[vecRefT2,matTracePerTrial] = getTraceInTrial(vecTime,vecData,vecEventStarts,dblSamplingInterval,dblUseMaxDur);
			subplot(2,3,1)
			imagesc(vecRefT2,1:size(matTracePerTrial,1),matTracePerTrial);
			colormap(hot);
			xlabel('Time after event (s)');
			ylabel('Trial #');
			title('Z-scored activation');
			fixfig;
			grid off;
		end
		
		%plot
		subplot(2,3,2)
		sOpt = struct;
		sOpt.handleFig =-1;
		sOpt.vecWindow = [0 dblUseMaxDur];
		[vecMean,vecSEM,vecWindowBinCenters] = doPEP(vecTime,vecData,vecEventStarts(:,1),sOpt);
		errorbar(vecWindowBinCenters,vecMean,vecSEM);
		%ylim([0 max(get(gca,'ylim'))]);
		title(sprintf('Mean value over trials'));
		xlabel('Time after event (s)');
		ylabel('Trace value');
		fixfig
		
		subplot(2,3,3)
		plot(vecRefT,vecRealFrac)
		hold on
		plot(vecRefT,vecRealFracLinear,'color',[0.5 0.5 0.5]);
		hold off
		title(sprintf('Real data'));
		xlabel('Time after event (s)');
		ylabel('Fractional position of value in trial');
		fixfig
		
		subplot(2,3,4)
		cla;
		hold all
		for intIter=1:intPlotIters
			plot(cellRandT{intIter},cellRandDiff{intIter},'Color',[0.5 0.5 0.5]);
		end
		plot(vecRefT,vecRealDiff,'Color',lines(1));
		hold off
		xlabel('Time after event (s)');
		ylabel('Data deviation');
		if boolStopSupplied
			title(sprintf('T-ZETA=%.3f (p=%.3f), z(mean)=%.3f (p=%.3f)',dblZETA,dblZetaP,dblMeanZ,dblMeanP));
		else
			title(sprintf('T-ZETA=%.3f (p=%.3f)',dblZETA,dblZetaP));
		end
		fixfig
		
		if intPlot > 1
			subplot(2,3,5)
			imagesc(vecRef2T,1:size(matTracePerTrialSR,1),matTracePerTrialSR);
			colormap(hot);
			xlabel('Time after event (s)');
			ylabel('Trial #');
			fixfig;
			grid off;
			
			subplot(2,3,6)
			plot(vecRef2T,vecMeanTrace,'color',lines(1));
			hold on
			plot(vecRef2T,vecMeanTrace+vecSemTrace,'--','color',lines(1));
			plot(vecRef2T,vecMeanTrace-vecSemTrace,'--','color',lines(1));
			hold off
			xlabel('Time after event (s)');
			ylabel('Data value');
			fixfig;
			grid off;
		end
	end
	
	%% build optional output structure
	if nargout > 1
		sZETA = struct;
		sZETA.dblZetaP = dblZetaP;
		sZETA.dblZETA = dblZETA;
		sZETA.dblD = dblD;
		sZETA.vecTimeSR = vecRef2T;
		sZETA.matDataSR = matTracePerTrialSR;
		
		sZETA.dblPeakT = dblMaxDTime;
		sZETA.intPeakIdx = intZETALoc;
		if boolStopSupplied
			sZETA.dblMeanZ = dblMeanZ;
			sZETA.dblMeanP = dblMeanP;
			sZETA.vecMu_Dur = vecMu1;
			sZETA.vecMu_Pre = vecMu2;
		end
		sZETA.vecTime = vecTime;
		sZETA.vecD = vecRealDiff;
		sZETA.cellRandT = cellRandT;
		sZETA.cellRandDiff = cellRandDiff;
	end
end
