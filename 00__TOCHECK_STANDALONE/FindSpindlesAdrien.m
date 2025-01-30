%FindSpindles - Find thalamic spindles (10-20Hz oscillations).
% 
%  USAGE
%
%    spindles = FindSpindles(samples,<options>)
%
%    samples        filtered LFP (one channel).
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'frequency'   sampling rate (in Hz) (default = 250Hz)
%     'show'        plot results (default = 'off')
%    =========================================================================
%
%  OUTPUT
%
%    spindles        for each spindle, [start_t end_t fqcy]
%

% Adrien Peyrache, 2012, adapted from Mickael Zugaro
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.

function spindles = FindSpindlesAdrien(samples,varargin)

% Default values
frequency = 250;
show = 'off';

% Check number of parameters
if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters (type ''help FindSpindles'' for details).');
end

%% Parameters
windowLength = floor(frequency/250*31);
minSpindlesLength = 400;
maxSpindlesLength = 3000;

minInterSpindlesInterval = 300;
% Spindle envoloppe must exceed lowThresholdFactor*stdev
lowThresholdFactor = 1.5;


% Parse parameter list
for i = 1:2:length(varargin)
	if ~isa(varargin{i},'char')
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help Findspindles'' for details).']);
	end
	switch(lower(varargin{i}))
		case 'frequency'
			frequency = varargin{i+1};
			if ~isa(frequency,'numeric') || length(frequency) ~= 1 || frequency <= 0
				error('Incorrect value for property ''frequency'' (type ''help FindSpindles'' for details).');
			end
		case 'show'
			show = varargin{i+1};
%  			if ~IsStringInList(show,'on','off'),
%  				error('Incorrect value for property ''show'' (type ''help FindSpindles'' for details).');
%  			end
        case 'lowth'
			lowThresholdFactor = varargin{i+1};
 			if ~isnumeric(lowThresholdFactor)
 				error('Incorrect value for property ''lowThresholdFactor'' (type ''help FindSpindles'' for details).');
 			end            
        otherwise
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help FindSpindles'' for details).']);
	end
end

spindles = [];

% Square and normalize signal
signal = samples;

squaredSignal = signal.^2;
window = ones(windowLength,1)/windowLength;
normalizedSquaredSignal = unity(Filter0(window,sum(squaredSignal,2)));

% Detect ripple periods by thresholding normalized squared signal
thresholded = normalizedSquaredSignal > lowThresholdFactor;
start = find(diff(thresholded)>0);
stop = find(diff(thresholded)<0);
if length(stop) == length(start)-1
	% Exclude last ripple if it is incomplete
	start = start(1:end-1);
end
if length(stop)-1 == length(start)
	% Exclude first ripple if it is incomplete
    stop = stop(2:end);
end


firstPass = [start,stop];
if isempty(firstPass)
	disp('Detection by thresholding failed');
	return
else
	disp(['After detection by thresholding: ' num2str(length(firstPass)) ' events.']);
end

% Merge spindles if inter-ripple period is too short
minInterSpindlesSamples = minInterSpindlesInterval/1000*frequency;
secondPass = [];
spin = firstPass(1,:);
for i = 2:size(firstPass,1)
	if firstPass(i,1) - spin(2) < minInterSpindlesSamples
		% Merge
		spin = [spin(1) firstPass(i,2)];
	else
		secondPass = [secondPass ; spin];
		spin = firstPass(i,:);
	end    
end
secondPass = [secondPass ; spin];
if isempty(secondPass)
	disp('Spindle merge failed');
    spin = [];
	return
else
	disp(['After spindle merge: ' num2str(length(secondPass)) ' events.']);
end


%added by A Peyrache - exclude spindles with a length<minSpindlesLength
start = secondPass(:,1);
stop = secondPass(:,2);
ix = 1;
while ix <= length(start)
	if (stop(ix) - start(ix) < minSpindlesLength/1000*frequency) || (stop(ix) - start(ix)  > maxSpindlesLength/1000*frequency);
		stop(ix) = [];
		start(ix) = [];
		ix = ix - 1;
	end
	ix = ix + 1;
end
clear ix;
secondPass = [start stop];
if isempty(secondPass)
	disp('Spindle merge failed');
    spin = [];
	return
else
	disp(['Afterelimination of short events: ' num2str(length(secondPass)) ' events.']);
end

% Average Frequency (by means of average inter-peak intervals) 
% Added  by A. Peyrache

fqcy = zeros(size(secondPass,1),1);

for i=1:size(secondPass,1)
	peakIx = LocalMinima(signal(secondPass(i,1):secondPass(i,2)),4,0);
    if ~isempty(peakIx)
        fqcy(i) = frequency/median(diff(peakIx));
       
    else
        warning('Weird...')
    end
end


% answer of this function...
spindles = [secondPass(:,1)/frequency secondPass(:,2)/frequency fqcy];

% Optionally, plot results
if strcmp(show,'on')
	%figure;
	time = (0:length(signal)-1)/frequency;
	subplot(3,1,1);hold on;
	plot(time,signal);
	subplot(3,1,2);hold on;
	plot(time,squaredSignal);
	subplot(3,1,3);hold on;
	plot(time,normalizedSquaredSignal);
	for i = 1:3
		subplot(3,1,i);
		yLim = ylim;
		for j=1:size(spindles,1)
			plot([spindles(j,1) spindles(j,1)],yLim,'g-');
			plot([spindles(j,2) spindles(j,2)],yLim,'r-');
			if i == 3
				plot([spindles(j,1) spindles(j,2)],[2 2],'k-');
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

[y0, z] = filter(b,1,x);

y = [y0(shift+1:end,:) ; z(1:shift,:)];

function U = unity(A)

meanA = mean(A);
stdA = std(A);

U = (A - repmat(meanA,size(A,1),1))./repmat(stdA,size(A,1),1);

