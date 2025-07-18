%FindRipples - Find hippocampal ripples (~200Hz oscillations).
% 
%  USAGE
%
%    ripples = FindRipples(samples,<options>)
%
%    samples        ripple-band filtered LFP (one channel).
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'frequency'   sampling rate (in Hz) (default = 1250Hz)
%     'show'        plot results (default = 'off')
%    =========================================================================
%
%  OUTPUT
%
%    ripples        for each ripple, [start_t peak_t end_t peakNormalizedPower]
%

% Copyright (C) 2004-2006 by Michaël Zugaro, adapted from Hajime Hirase, modified by A Peyrache
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.

function ripples = FindRipples(samples,varargin)

% Default values
frequency = 1250;
show = 'off';

% Check number of parameters
if nargin < 1 | mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters (type ''help FindRipples'' for details).');
end

%  % Check parameter sizes
%  if size(samples,2) ~= 2,
%  	error('Parameter ''samples'' is not a Nx2 matrix (type ''help FindRipples'' for details).');
%  end

% Parse parameter list
for i = 1:2:length(varargin),
	if ~isa(varargin{i},'char'),
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help FindRipples'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'frequency',
			frequency = varargin{i+1};
			if ~isa(frequency,'numeric') | length(frequency) ~= 1 | frequency <= 0,
				error('Incorrect value for property ''frequency'' (type ''help FindRipples'' for details).');
			end
		case 'show',
			show = varargin{i+1};
%  			if ~IsStringInList(show,'on','off'),
%  				error('Incorrect value for property ''show'' (type ''help FindRipples'' for details).');
%  			end
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help FindRipples'' for details).']);
	end
end

% Parameters
windowLength = floor(frequency/1250*11);
minRippleLength = 20;
maxRippleLength = 250;
minInterRippleInterval = 30;
% Ripple envoloppe must exceed lowThresholdFactor*stdev
lowThresholdFactor = 3;
% Ripple peak must exceed highThresholdFactor*stdev
highThresholdFactor = 7;

% Square and normalize signal
signal = samples; %(:,2);
squaredSignal = signal.^2;
window = ones(windowLength,1)/windowLength;
normalizedSquaredSignal = unity(Filter0(window,sum(squaredSignal,2)));

% Detect ripple periods by thresholding normalized squared signal
thresholded = normalizedSquaredSignal > lowThresholdFactor;
start = find(diff(thresholded)>0);
stop = find(diff(thresholded)<0);
if length(stop) == length(start)-1,
	% Exclude last ripple if it is incomplete
	start = start(1:end-1);
end
if length(stop)-1 == length(start)
	% Exclude first ripple if it is incomplete
    stop = stop(2:end);
end

%added by A Peyrache - exclude ripples whos length<minRippleLength

ix = 1;
while ix < length(start)
	
	if (stop(ix) - start(ix) < minRippleLength/1000*frequency) || (stop(ix) - start(ix)  > maxRippleLength/1000*frequency);
		stop(ix) = [];
		start(ix) = [];
		ix = ix - 1;
	end
	ix = ix + 1;
end
clear ix;

firstPass = [start,stop];
if isempty(firstPass),
	disp('Detection by thresholding failed');
	return
else
	disp(['After detection by thresholding: ' num2str(length(firstPass)) ' events.']);
end

% Merge ripples if inter-ripple period is too short
minInterRippleSamples = minInterRippleInterval/1000*frequency;
secondPass = [];
ripple = firstPass(1,:);
for i = 2:size(firstPass,1)
	if firstPass(i,1) - ripple(2) < minInterRippleSamples,
		% Merge
		ripple = [ripple(1) firstPass(i,2)];
	else
		secondPass = [secondPass ; ripple];
		ripple = firstPass(i,:);
	end    
end
secondPass = [secondPass ; ripple];
if isempty(secondPass),
	disp('Ripple merge failed');
	return
else
	disp(['After ripple merge: ' num2str(length(secondPass)) ' events.']);
end

% Discard ripples with a peak power < highThresholdFactor
thirdPass = [];
peakNormalizedPower = [];
for i = 1:size(secondPass,1)
	[maxValue,maxIndex] = max(normalizedSquaredSignal([secondPass(i,1):secondPass(i,2)]));
	if maxValue > highThresholdFactor,
		thirdPass = [thirdPass ; secondPass(i,:)];
		peakNormalizedPower = [peakNormalizedPower ; maxValue];
	end
end
if isempty(thirdPass),
	disp('Peak thresholding failed.');
	return
else
	disp(['After peak thresholding: ' num2str(length(thirdPass)) ' events.']);
end

% Detect negative peak position for each ripple
peakPosition = zeros(size(thirdPass,1),1);
for i=1:size(thirdPass,1),
	[minValue,minIndex] = min(signal(thirdPass(i,1):thirdPass(i,2)));
	peakPosition(i) = minIndex + thirdPass(i,1) - 2;
end

% anser of this function...
ripples = [thirdPass(:,1)/frequency peakPosition/frequency thirdPass(:,2)/frequency peakNormalizedPower];

% Optionally, plot results
if strcmp(show,'on'),
	figure;
	time = (0:length(signal)-1)/frequency;
	subplot(3,1,1);hold on;
	plot(time,signal);
	subplot(3,1,2);hold on;
	plot(time,squaredSignal);
	subplot(3,1,3);hold on;
	plot(time,normalizedSquaredSignal);
	for i = 1:3,
		subplot(3,1,i);
		yLim = ylim;
		for j=1:size(ripples,1),
			plot([ripples(j,1) ripples(j,1)],yLim,'g-');
			plot([ripples(j,2) ripples(j,2)],yLim,'k-');
			plot([ripples(j,3) ripples(j,3)],yLim,'r-');
			if i == 3,
				plot([ripples(j,1) ripples(j,3)],[ripples(j,4) ripples(j,4)],'k-');
			end
		end
	end
end

function y = Filter0(b, x)

if size(x,1) == 1
	x = x(:);
end

if mod(length(b),2)~=1
	error('filter order should be odd');
end

shift = (length(b)-1)/2;

[y0 z] = filter(b,1,x);

y = [y0(shift+1:end,:) ; z(1:shift,:)];

function U = unity(A)

meanA = mean(A);
stdA = std(A);

U = (A - repmat(meanA,size(A,1),1))./repmat(stdA,size(A,1),1);

