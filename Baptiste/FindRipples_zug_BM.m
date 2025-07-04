function [ripples,sd,bad] = FindRipples_zug(filtered,varargin)

% =========================================================================
%                            FindRipples_zug
% =========================================================================
% 
% USAGE: [ripples,sd,bad] = FindRipples_zug(filtered,<options>)
%
% DESCRIPTION:  Detect and save ripples using square-root value followed by
%               a normalization of power of the LFP. 
%               Part of MOBs' CreateSleepSignal pipeline.
%
%               Ripples are detected using the normalized squared signal (NSS) by
%               thresholding the baseline, merging neighboring events, thresholding
%               the peaks, and discarding events with excessive duration.
%               Thresholds are computed as multiples of the standard deviation of
%               the NSS. Alternatively, one can use explicit values, typically obtained
%               from a previous call.
%
%               This code was derived from FindSpindles.m originally written by M. Zugaro 
%               (see ref below). It was adapted for the MOBs pipeline 
%               by S. Laventure (2021-01).
%
% =========================================================================
% INPUTS: 
%    __________________________________________________________________
%       Properties          Description                     Default
%    __________________________________________________________________
%
%       filtered        lfp time and signal ([time signal]). 
%                       Time in second.              
%
%       <varargin>          optional list of property-value pairs (see table below)
%
%     'thresholds'      thresholds for ripple beginning/end and peak, in multiples
%                       of the stdev (default = [2 5])
%     'durations'       minimum inter-ripple interval, and minimum and maximum
%                       ripple durations, in ms (default = [30 20 100])
%     'baseline'        interval used to compute normalization (default = all)
%     'restrict'        same as 'baseline' (for backwards compatibility)
%     'frequency'       sampling rate (in Hz) (default = 1250Hz)
%     'stdev'           reuse previously computed stdev
%     'noise'           noisy ripple-band filtered channel used to exclude ripple-
%                       like noise (events also present on this channel are
%                       discarded)
%
% =========================================================================
% OUTPUT:
%    __________________________________________________________________
%       Properties          Description                   
%    __________________________________________________________________
%
%       ripples             [start(in s) peak(in s) end(in s) duration(in ms) 
%                           frequency peak-amplitude]   
%       sd                  standard value of LFP
%       bad                 removed ripples from detection
% =========================================================================
% VERSIONS
%   Copyright (C) 2004-2011 by Michaël Zugaro, 2016 Ralitsa Todorova (vectorized secondPass),
%   initial algorithm by Hajime Hirase
%   Adapted for MOBs pipeline by S. Laventure - 2021-01 (extract frequency and peak-amplitude)
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 3 of the License, or
%   (at your option) any later version.
%
% =========================================================================
% SEE   CreateSpindlesSleep CreateDownStatesSleep CreateDeltaWavesSleep
%       FindRipples_zug FindRipples FindRipples_abs CreateRipplesSleep
%       FilterLFP
% =========================================================================

% Default values
frequency = 1250;
restrict = [];
sd = [];
lowThresholdFactor = 2; % Ripple envoloppe must exceed lowThresholdFactor*stdev
highThresholdFactor = 5; % Ripple peak must exceed highThresholdFactor*stdev
minInterRippleInterval = 30; % in ms
minRippleDuration = 20; % in ms
maxRippleDuration = 100; % in ms
noise = [];

% Check number of parameters
if nargin < 1 | mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
end

% Check parameter sizes
if ~isdmatrix(filtered) | size(filtered,2) ~= 2,
	error('Parameter ''filtered'' is not a Nx2 matrix (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
end

% Parse parameter list
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'thresholds',
			thresholds = varargin{i+1};
			if ~isdvector(thresholds,'#2','>0'),
				error('Incorrect value for property ''thresholds'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
			end
			lowThresholdFactor = thresholds(1);
			highThresholdFactor = thresholds(2);
		case 'durations',
			durations = varargin{i+1};
			if ~isdvector(durations,'#2','>0') && ~isdvector(durations,'#3','>0'),
				error('Incorrect value for property ''durations'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
			end
			if length(durations) == 2,
				minInterRippleInterval = durations(1);
				maxRippleDuration = durations(2);
			else
				minInterRippleInterval = durations(1);
				minRippleDuration = durations(2);
				maxRippleDuration = durations(3);
			end
		case 'frequency',
			frequency = varargin{i+1};
			if ~isdscalar(frequency,'>0'),
				error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
			end
		case 'show',
			show = varargin{i+1};
			if ~isastring(show,'on','off'),
				error('Incorrect value for property ''show'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
			end
		case 'restrict',
			restrict = varargin{i+1};
% 			if isempty(restrict) 
% 				error('Incorrect value for property ''restrict'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
% 			end
		case 'stdev',
			sd = varargin{i+1};
% 			if isempty(restrict) & ~isdvector(restrict,'#2','<'),
% 				error('Incorrect value for property ''stdev'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
% 			end
		case 'noise',
			noise = varargin{i+1};
			if ~isdmatrix(noise) | size(noise,1) ~= size(filtered,1) | size(noise,2) ~= 2,
				error('Incorrect value for property ''nFilspoise'' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).');
			end
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help FindRipples">FindRipples</a>'' for details).']);
	end
end

% Parameters
windowLength = round(frequency/1250*11);

% Restrict to a specific epoch if necessary
if ~isempty(restrict)
    Data_tsd = tsd(filtered(:,1)*1e4 , filtered(:,2));
    Data_tsd_Restricted = Restrict(Data_tsd , restrict);
    filtered = [Range(Data_tsd_Restricted)/1e4 Data(Data_tsd_Restricted)];
end

time = filtered(:,1);
signal = filtered(:,2);
squaredSignal = signal.^2;

window = ones(windowLength,1)/windowLength;

% Square and normalize signal
if ~isempty(sd) % if you provide mean and std values of an acquired signal, will be normalized differently
    squaredSignal_pre = squaredSignal-nanmean(squaredSignal);
    normalizedSquaredSignal = squaredSignal_pre/sd;
%     if ~isempty(restrict)
%         lowThresholdFactor = lowThresholdFactor*1.5;  % manually modified
%     else
%         lowThresholdFactor = lowThresholdFactor*3.5;  % manually modified
%     end
    sd=std(squaredSignal);
else
    [normalizedSquaredSignal,sd] = unity(Filter0(window,sum(squaredSignal,2)),[],[]);
end

% Detect ripple periods by thresholding normalized squared signal
thresholded = normalizedSquaredSignal > lowThresholdFactor;
start = find(diff(thresholded)>0);
stop = find(diff(thresholded)<0);
% Exclude last ripple if it is incomplete
if length(stop) == length(start)-1,
	start = start(1:end-1);
end
% Exclude first ripple if it is incomplete
if length(stop)-1 == length(start),
    stop = stop(2:end);
end
% Correct special case when both first and last ripples are incomplete
if start(1) > stop(1),
	stop(1) = [];
	start(end) = [];
end
firstPass = [start,stop];
if isempty(firstPass),
	disp('  Step 1: Detection by thresholding failed');
	return
else
	disp(['  Step 1: After detection by thresholding: ' num2str(length(firstPass)) ' events.']);
end

% Merge ripples if inter-ripple period is too short (unless this would yield too long a ripple)
secondPass = firstPass;
iri = time(secondPass(2:end,1)) - time(secondPass(1:end-1,2));
duration = time(secondPass(2:end,2)) - time(secondPass(1:end-1,1));
toMerge = iri<minInterRippleInterval/1000 & duration<maxRippleDuration/1000;
while any(toMerge),
    % Get indices of first ripples in pairs to be merged
    rippleStart = strfind([0 toMerge'],[0 1])';
    % Incorporate second ripple into first in all pairs
    rippleEnd = rippleStart+1;
    secondPass(rippleStart,2) = secondPass(rippleEnd,2);
    % Remove second ripples and loop
    secondPass(rippleEnd,:) = [];
    iri = time(secondPass(2:end,1)) - time(secondPass(1:end-1,2));
    duration = time(secondPass(2:end,2)) - time(secondPass(1:end-1,1));
    toMerge = iri<minInterRippleInterval/1000 & duration<maxRippleDuration/1000;
end

if isempty(secondPass),
	disp('  Step 2: Ripple merge failed');
	return
else
	disp(['  Step 2: After ripple merge: ' num2str(length(secondPass)) ' events.']);
end

% Discard ripples with a peak power < highThresholdFactor
thirdPass = [];
peakNormalizedPower = [];
for i = 1:size(secondPass,1)
	maxValue = max(normalizedSquaredSignal([secondPass(i,1):secondPass(i,2)]));
	if maxValue > highThresholdFactor,
		thirdPass = [thirdPass ; secondPass(i,:)];
		peakNormalizedPower = [peakNormalizedPower ; maxValue];
	end
end
if isempty(thirdPass),
	disp('  Step 3: Peak thresholding failed.');
% 	return
else
	disp(['  Step 3: After peak thresholding: ' num2str(length(thirdPass)) ' events.']);
end

% Detect negative peak position for each ripple
peakPosition = zeros(size(thirdPass,1),1);
for i=1:size(thirdPass,1),
	[~,minIndex] = min(signal(thirdPass(i,1):thirdPass(i,2)));
	peakPosition(i) = minIndex + thirdPass(i,1) - 1;
end

% Discard ripples that are way too short
ripples = [time(thirdPass(:,1)) time(peakPosition) time(thirdPass(:,2)) peakNormalizedPower];
duration = ripples(:,3)-ripples(:,1);
ripples(duration<minRippleDuration/1e3,:) = [];
disp(['  Step 4: After min duration test: ' num2str(size(ripples,1)) ' events.']);

% Discard ripples that are way too long
duration = ripples(:,3)-ripples(:,1);
ripples(duration>maxRippleDuration/1e3,:) = [];
disp(['  Step 5: After max duration test: ' num2str(size(ripples,1)) ' events.']);

% If a noisy channel was provided, find ripple-like events and exclude them
bad = [];
if ~isempty(noise),
	% Square and pseudo-normalize (divide by signal stdev) noise
	squaredNoise = noise(:,2).^2;
	window = ones(windowLength,1)/windowLength;
	normalizedSquaredNoise = unity(Filter0(window,sum(squaredNoise,2)),sd,[]);
	excluded = logical(zeros(size(ripples,1),1));
	% Exclude ripples when concomittent noise crosses high detection threshold
	previous = 1;
	for i = 1:size(ripples,1),
		j = FindInInterval(noise,[ripples(i,1),ripples(i,3)],previous);
		previous = j(2);
		if any(normalizedSquaredNoise(j(1):j(2))>highThresholdFactor),
			excluded(i) = 1;
		end
	end
	bad = ripples(excluded,:);
	ripples = ripples(~excluded,:);
	disp(['  Step 6: After noise removal: ' num2str(size(ripples,1)) ' events.']);
end

%% -----------------------------------
% Extract peak amplitude and frequency 
% (also add duration in ms)
% added by S. Laventure 2021-01
LFP = tsd(time*1E4,signal);
FiltLFP = FilterLFP(LFP, [120 220], 1024);
FinalRipplesEpoch = intervalSet(ripples(:,1)*1E4,ripples(:,3)*1E4);

% find peak-to-peak amplitude
func_amp = @(a) measureOnSignal(a,'amplitude_p2p');
if ~isempty(Start(FinalRipplesEpoch)) % add by BM on 19/04/2022
    [amp, ~, ~] = functionOnEpochs(FiltLFP, FinalRipplesEpoch, func_amp); %,'uniformoutput',false);
end

% Detect instantaneous frequency 
st_ss = ripples(:,1)*1E4;
en_ss = ripples(:,3)*1E4;
freq = zeros(length(st_ss),1);
for i=1:length(st_ss)
    peakIx = LocalMaxima(resample(Data(Restrict(FiltLFP,intervalSet(st_ss(i),en_ss(i)))) , 30 , 1) , 4 ,0); % resample ripples data to be 30 times more detailed, find maxima rather than minima where spikes are
    if ~isempty(peakIx)
        freq(i) = frequency/(median(diff(peakIx))/30);
    end
end
% add duration, frequency and peak amplitude (normalized peak amplitude is discarded)
if not(isempty(Start(FinalRipplesEpoch)))
    ripples(:,4) = Stop(FinalRipplesEpoch,'ms')-Start(FinalRipplesEpoch,'ms');
    ripples(:,5) = freq;
    ripples(:,6) = amp;
else
    ripples(:,4) = NaN;
    ripples(:,5) = NaN;
    ripples(:,6) = NaN;
end
%% -----------------------------------

function y = Filter0(b,x)

if size(x,1) == 1,
	x = x(:);
end

if mod(length(b),2) ~= 1,
	error('filter order should be odd');
end

shift = (length(b)-1)/2;

[y0 z] = filter(b,1,x);

y = [y0(shift+1:end,:) ; z(1:shift,:)];

function [U,stdA] = unity(A,sd,restrict)

if ~isempty(restrict),
	meanA = mean(A(restrict));
	stdA = std(A(restrict));
else
	meanA = mean(A);
	stdA = std(A);
end
if ~isempty(sd),
	stdA = sd;
end

U = (A - meanA)/stdA;

