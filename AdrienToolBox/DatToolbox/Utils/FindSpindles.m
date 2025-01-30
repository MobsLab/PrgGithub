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

function spindles = FindSpindles(samples,varargin)

% Default values
frequency = 250;
show = 'off';

% Check number of parameters
if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters (type ''help FindSpindles'' for details).');
end

% Parameters
windowLength = floor(frequency/250*31);
minSpindlesLength = 400;
maxSpindlesLength = 15000; 


minInterSpindlesInterval = 600;
% Spindle envoloppe must exceed lowThresholdFactor*stdev
% lowThresholdFactor = 1.5;
lowThresholdFactor = 1;

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
%normalizedSquaredSignal = unity(Filter0(window,sum(squaredSignal,2)));

normalizedSquaredSignal = SmoothDec(unity(Filter0(window,sum(squaredSignal,2))),25);


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


%added by A Peyrache - exclude spindles whos length<minSpindlesLength
start = secondPass(:,1);
stop = secondPass(:,2);
ix = 1;
while ix <= length(start)
	if (stop(ix) - start(ix) < minSpindlesLength/1000*frequency) %|| (stop(ix) - start(ix)  > maxSpindlesLength/1000*frequency);
		stop(ix) = [];
		start(ix) = [];
		ix = ix - 1;
	end
	ix = ix + 1;
end
clear ix;
thirdPass = [start stop];
if isempty(thirdPass)
	disp('Spindle merge failed');
    spin = [];
	return
else
	disp(['After elimination of short events: ' num2str(length(thirdPass)) ' events.']);
end



% Remove ripple periods by thresholding average squared signal

start = thirdPass(:,1);
stop = thirdPass(:,2);

thh=1*1E6;
clear A
a=1;
ix = 1;
while ix <= length(start)
    A(a)=mean(squaredSignal(start(ix):stop(ix)));
    temp=squaredSignal(start(ix):stop(ix));
    [BE,idd]=sort(temp);
    B(a)=mean(floor(temp(floor(end/2):end)));a=a+1;
	if mean(floor(temp(floor(end/2):end)))<thh   
% 	if mean(squaredSignal(start(ix):stop(ix)))<1.5E6
		stop(ix) = [];
		start(ix) = [];
		ix = ix - 1;
	end
	ix = ix + 1;
end


% figure(2), clf, 
% subplot(2,1,1),hist(B,[0:1E5: 10E6]),xlim([0 10E6])
% yl=ylim;
% hold on, line([thh thh],yl,'color','r')
% subplot(2,1,2),hist(A,[0:1E5: 10E6]),xlim([0 10E6])
% yl=ylim;
% hold on, line([thh thh],yl,'color','r')



clear ix;
FourthPass = [start stop];

% 
% if length(thirdPass)>3&length(FourthPass)==0  
%     FourthPass=thirdPass;
%     disp('removing low amplitude too excessive');
% end


FourthPass=thirdPass;


if isempty(FourthPass)
	disp('removing low amplitude failed');
    spin = [];
	return
else
	disp(['After removing low amplitude events: ' num2str(length(FourthPass)) ' events.']);
end




% Average Fqcy (by means of average inter-peak intervals) Added  by A
% Peyrache

fqcy = zeros(size(FourthPass,1),1);

for i=1:size(FourthPass,1)
	peakIx = LocalMinima(signal(FourthPass(i,1):FourthPass(i,2)),4,0);
    if ~isempty(peakIx)
        fqcy(i) = frequency/median(diff(peakIx));
       
    else
        warning('Weird...')
    end
end


% anser of this function...
spindles = [FourthPass(:,1)/frequency FourthPass(:,2)/frequency fqcy];

% Optionally, plot results
if strcmp(show,'on')
	figure(1);clf
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
				plot([spindles(j,1) spindles(j,2)],[lowThresholdFactor lowThresholdFactor],'k-');
			end
        end
       
               for j=1:size(thirdPass,1)
			plot([thirdPass(j,1)/frequency thirdPass(j,1)/frequency],[yLim(2)/2 yLim(2)],'c-');
			plot([thirdPass(j,2)/frequency thirdPass(j,2)/frequency],[yLim(2)/2 yLim(2)],'m-');
			if i == 3
				plot([thirdPass(j,1)/frequency thirdPass(j,2)/frequency],[3 3],'k-');
			end
        end
         
                
    end
    hold on, line([time(1) time(end)],[lowThresholdFactor lowThresholdFactor],'color','m')
    %plot(time,normalizedSquaredSignal2,'r');
    keyboard
    
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

