function [vecRate,sMSD] = getMultiScaleDeriv(vecT,vecV,dblSmoothSd,dblMinScale,dblBase,dblMeanRate,dblUseMaxDur,boolUseParallel)
	%getMultiScaleDeriv Returns multi-scale derivative. Syntax:
	%   [vecRate,sMSD] = getMultiScaleDeriv(vecT,vecV,dblSmoothSd,dblMinScale,dblBase,dblMeanRate,dblUseMaxDur,boolUseParallel)
	%Required input:
	%	- vecT [N x 1]: timestamps (e.g., spike times)
	%	- vecV [N x 1]: values (e.g., z-scores)
	%
	%Optional inputs:
	%	- dblSmoothSd: Gaussian SD of smoothing kernel (in # of samples) [default: 2]
	%	- dblMinScale: minimum derivative scale in seconds [default: 1/1000]
	%	- dblBase: base for exponential scale step size [default: 1.5]
	%	- dblMeanRate: mean spiking rate to normalize vecRate (optional)
	%	- dblUseMaxDur: trial duration to normalize vecRate (optional)
	%	- boolUseParallel: use parallel processing (optional) [default: true if pool is active, otherwise false; can decrease performance, so be cautious!]
	%
	%Outputs:
	%	- vecRate; Instantaneous spiking rate
	%	- sMSD; structure with fields:
	%		- vecRate; instantaneous spiking rates (like a PSTH)
	%		- vecT; time-points corresponding to vecRate (same as input vecT)
	%		- vecM; Mean of multi-scale derivatives
	%		- vecScale; timescales used to calculate derivatives
	%		- matMSD; multi-scale derivatives matrix
	%		- vecV; values on which vecRate is calculated (same as input vecV)
	%
	%Version history:
	%1.0 - January 24 2020
	%	Created by Jorrit Montijn - split from previous getMultiScaleDeriv.
	%1.1 - February 26 2020
	%	Added instantaneous spiking rate rescaling [by JM]
	%1.1.1 - January 10 2022
	%	Changed plotting behavior to create new figure when intPlot==1 if gca is not empty [by JM]
	%1.1.2 - May 17 2023
	%	Compiled calcMSD() as mex-file & modified parfor to increase computation speed [by JM]
	%1.1.3 - May 26 2023
	%	Changed default parallel-processing behaviour & compiled calcSingleMSD() as mex-file.
	%	GPU computation is now within try-catch block, so CPU-only pipeline works as well [by JM]
	%1.1.4 - May 30 2023
	%	Removed artificial points at t=0 and t=dblUseMaxDur [by JM]
	%1.2 - June 6 2023
	%	Fixed small temporal asymmetry of MSD calculation [by JM]
	%1.2.1 - July 24 2023
	%	Fixed crash if mex-file is unusable (i.e., non-windows systems) and parallel processing is
	%	requested [by JM] 
    %1.2.2 - August 22 2023
	%	Changed max scale from B log(max(vecT)/10) to B log(range(vecT)/10); shouldn't have an
    %	effect in most cases, as min(vecT) is always 0 unless this function is used directly [by JM] 

	%% set default values
	if ~exist('dblSmoothSd','var') || isempty(dblSmoothSd)
		dblSmoothSd = 2;
	end
	if ~exist('dblBase','var') || isempty(dblBase)
		dblBase = 1.5;
	end
	if ~exist('dblMinScale','var') || isempty(dblMinScale)
		dblMinScale = round(log(1/1000) / log(dblBase));
	end
	if ~exist('dblMeanRate','var') || isempty(dblMeanRate)
		dblMeanRate = 1;
	end
	if ~exist('dblUseMaxDur','var') || isempty(dblUseMaxDur)
		dblUseMaxDur = range(vecT);
	end
	if ~exist('boolUseParallel','var') || isempty(boolUseParallel)
		objPool = gcp('nocreate');
		if isempty(objPool) || ~isprop(objPool,'NumWorkers') || objPool.NumWorkers < 4
			boolUseParallel = false;
		else
			boolUseParallel = true;
		end
	end

	%% reorder just in case
	[vecT,vecReorder] = sort(vecT(:),'ascend');
	vecV = vecV(vecReorder);
	vecV = vecV(:);
	indRem = vecT==0 | vecT==dblUseMaxDur;%points at 0 and 1 are artificial
	vecT(indRem) = [];
	vecV(indRem) = [];

	%% get multi-scale derivative
	dblMaxScale = log(range(vecT)/10) / log(dblBase);
	vecExp = dblMinScale:dblMaxScale;
	vecScale=dblBase.^vecExp;
	intScaleNum = numel(vecScale);
	intN = numel(vecT);
	matMSD = zeros(intN,intScaleNum);
	if boolUseParallel
		try
			parfor intScaleIdx=1:intScaleNum
				dblScale = vecScale(intScaleIdx);
				%run through all points
				matMSD(:,intScaleIdx) = calcSingleMSD_mex(dblScale,vecT,vecV);
			end
		catch
			parfor intScaleIdx=1:intScaleNum
				dblScale = vecScale(intScaleIdx);
				%run through all points
				matMSD(:,intScaleIdx) = calcSingleMSD(dblScale,vecT,vecV);
			end
		end
	else
		try
			for intScaleIdx=1:intScaleNum
				dblScale = vecScale(intScaleIdx);
				%run through all points
				matMSD(:,intScaleIdx) = calcSingleMSD_mex(dblScale,vecT,vecV);
			end
		catch
			for intScaleIdx=1:intScaleNum
				dblScale = vecScale(intScaleIdx);
				%run through all points
				matMSD(:,intScaleIdx) = calcSingleMSD(dblScale,vecT,vecV);
			end
		end
	end

	%% smoothing
	if dblSmoothSd > 0
		vecFilt = normpdf(-2*ceil(dblSmoothSd):2*ceil(dblSmoothSd),0,dblSmoothSd)';
		vecFilt = vecFilt./sum(vecFilt);
		%pad array
		matMSD = padarray(matMSD,floor(size(vecFilt)/2),'replicate');

		%filter
		try
			matMSD = conv2(gpuArray(matMSD),gpuArray(vecFilt),'valid');
		catch
			matMSD = conv2(matMSD,vecFilt,'valid');
		end
	end
	%mean
	vecM = mean(gather(matMSD),2);

	%weighted average of vecM by inter-spike intervals
	dblMeanM = (1/dblUseMaxDur)*sum(((vecM(1:(end-1)) + vecM(2:end))/2).*diff(vecT));

	%rescale to real firing rates
	vecRate = dblMeanRate * ((vecM + 1/dblUseMaxDur)/(dblMeanM + 1/dblUseMaxDur));

	%% build output
	if nargout > 1
		sMSD = struct;
		sMSD.vecRate = vecRate;
		sMSD.vecT = vecT;
		sMSD.vecM = vecM;
		sMSD.vecScale = vecScale;
		sMSD.matMSD = matMSD;
		sMSD.vecV = vecV;
	end
end
function vecMSD = calcSingleMSD(dblScale,vecT,vecV)
	intN = numel(vecT);
	vecMSD = zeros(intN,1);

	%run through all points
	for intS=1:intN
		%select points within window
		dblT = vecT(intS);
		dblMinEdge = dblT - dblScale/2;
		dblMaxEdge = dblT + dblScale/2;
		indCompMin = vecT > dblMinEdge;
		intIdxMinT = find(indCompMin,1,'first');
		if isempty(intIdxMinT)
			intIdxMinT=1;
		else
			intIdxMinT = intIdxMinT(1);
		end
		indCompMax = vecT > dblMaxEdge;
		intIdxMaxT = find(indCompMax,1,'first');
		if isempty(intIdxMaxT)
			intIdxMaxT=intN;
		else
			intIdxMaxT = intIdxMaxT(1)-1;
		end
		if (intIdxMinT > intIdxMaxT)
			dblD=0;
		else
			if (intIdxMinT == intIdxMaxT) && (intIdxMinT > 1) && (intIdxMinT < intN)
				intIdxMaxT=intIdxMinT+1;
				intIdxMinT=intIdxMinT-1;
			end
			dbl_dT = max([dblScale (vecT(intIdxMaxT) - vecT(intIdxMinT))]);
			dblD = (vecV(intIdxMaxT) - vecV(intIdxMinT))/dbl_dT;
		end

		%select points within window
		vecMSD(intS) = dblD;
	end
end