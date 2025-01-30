%Findspindles - Find spindles (100~200Hz oscillations).
%
%  USAGE
%
%    [spindles,stdev,noise] = Findspindles(filtered,<options>)
%
%    spindles are detected using the normalized squared signal (NSS) by
%    thresholding the baseline, merging neighboring events, thresholding
%    the peaks, and discarding events with excessive duration.
%    Thresholds are computed as multiples of the standard deviation of
%    the NSS. Alternatively, one can use explicit values, typically obtained
%    from a previous call.
%
%    filtered       ripple-band filtered LFP (one channel).
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'thresholds'  thresholds for ripple beginning/end and peak, in multiples
%                   of the stdev (default = [1.5 5])
%     'durations'   min inter-spindle interval & min and max spindle duration, in ms
%                   (default = [100 400 3000])
%     'restrict'    interval used to compute normalization (default = all)
%     'frequency'   sampling rate (in Hz) (default = 1250Hz)
%     'stdev'       reuse previously computed stdev
%     'show'        plot results (default = 'off')
%     'noise'       noisy spindle-band filtered channel used to exclude spindle-
%                   like noise (events also present on this channel are
%                   discarded)
%    =========================================================================
%
%  OUTPUT
%
%    spindles       for each spindle, [start_t peak_t end_t peakNormalizedPower]
%    stdev          standard deviation of the NSS (can be reused subsequently)
%    noise          spindle-like activity recorded simultaneously on the noise
%                   channel (for debugging info)
%
%  SEE
%
%    See also FilterLFP, spindlestats, SaveRippleEvents, Plotspindlestats.

% Copyright (C) 2004-2010 by Michaël Zugaro, initial algorithm by Hajime Hirase
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

function [spindles, SWA, stdev, bad] = FindspindlesMarie(filtered,varargin)

% Default values
frequency = round(1/median(diff(filtered(:,1))));
% frequency = 1250;
show = 'off';
restrict = [];
stdev = [];
lowThresholdFactor = 1.5; % Ripple envoloppe must exceed lowThresholdFactor*stdev
highThresholdFactor = 5; % Ripple peak must exceed highThresholdFactor*stdev
minInterSpindleInterval = 100; % in ms
minSpindleDuration = 400; % in ms
maxSpindleDuration = 3000; % in ms
noise = [];

% Check number of parameters
if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
end

% Check parameter sizes
if ~isdmatrix(filtered) || size(filtered,2) ~= 2
	error('Parameter ''filtered'' is not a Nx2 matrix (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
end

% Parse parameter list
for i = 1:2:length(varargin)
	if ~ischar(varargin{i})
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).']);
	end
	switch(lower(varargin{i}))
		case 'thresholds'
			thresholds = varargin{i+1};
% 			if ~isivector(thresholds,'#2','>0'),
% 				error('Incorrect value for property ''thresholds'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
% 			end
			lowThresholdFactor = thresholds(1);
			highThresholdFactor = thresholds(2);
		case 'durations'
			durations = varargin{i+1};
% 			if ~isivector(durations,'#3','>0'),
% 				error('Incorrect value for property ''durations'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
% 			end
			minInterSpindleInterval = durations(1);
			minSpindleDuration = durations(2);
            maxSpindleDuration = durations(3);
		case 'frequency'
			frequency = varargin{i+1};
			if ~isdscalar(frequency,'>0')
				error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
			end
		case 'show'
			show = varargin{i+1};
			if ~isstring_FMAToolbox(show,'on','off')
				error('Incorrect value for property ''show'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
			end
		case 'restrict'
			restrict = varargin{i+1};
			if ~isempty(restrict) && ~isdvector(restrict,'#2','<')
				error('Incorrect value for property ''restrict'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
			end
		case 'stdev'
			stdev = varargin{i+1};
			if ~isdscalar(stdev,'>0')
				error('Incorrect value for property ''stdev'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
			end
		case 'noise'
			noise = varargin{i+1};
			if ~isdmatrix(noise) || size(noise,1) ~= size(filtered,1) || size(noise,2) ~= 2
				error('Incorrect value for property ''noise'' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).');
			end
        otherwise
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help Findspindles">Findspindles</a>'' for details).']);
	end
end

warning('off','all')

% Parameters
windowLength = frequency/1250*11;

%% 

% Square and normalize signal
signal = filtered(:,2);
squaredSignal = signal.^2;
window = ones(windowLength,1)/windowLength;
keep = [];
if ~isempty(restrict)
	keep = filtered(:,1)>=restrict(1)&filtered(:,1)<=restrict(2);
end

[normalizedSquaredSignal,stdev] = unity(Filter0(window,sum(squaredSignal,2)),stdev,keep);
temp = tsd(filtered(:,1)*1E4,smooth(normalizedSquaredSignal,10));
t = FindLocalMax(temp);
normalizedSquaredSignal = Data(Restrict(t,temp));


% Detect ripple periods by thresholding normalized squared signal
thresholded = normalizedSquaredSignal > lowThresholdFactor;
start = find(diff(thresholded)>0);
stop = find(diff(thresholded)<0);
% Exclude last ripple if it is incomplete
if length(stop) == length(start)-1
	start = start(1:end-1);
end
% Exclude first ripple if it is incomplete
if length(stop)-1 == length(start)
    stop = stop(2:end);
end
% Correct special case when both first and last spindles are incomplete
if start(1) > stop(1)
	stop(1) = [];
	start(end) = [];
end
firstPass = [start,stop];
% if isempty(firstPass)
% 	disp('Detection by thresholding failed');
% 	return
% else
% % 	disp(['After detection by thresholding: ' num2str(length(firstPass)) ' events.']);
% end


iniMark=[start,stop];

firstPassBis = [];
for i = 1:size(firstPass,1)

    OverPeriod=find(normalizedSquaredSignal([firstPass(i,1):firstPass(i,2)])>lowThresholdFactor);   %+(highThresholdFactor-lowThresholdFactor)/2);
	if length(OverPeriod)/length(normalizedSquaredSignal([firstPass(i,1):firstPass(i,2)]))>0.8        %& MeanPeriod> (lowThresholdFactor +highThresholdFactor/3)
		firstPassBis = [firstPassBis ; firstPass(i,:)];
	end
end
% if isempty(firstPassBis)
% 	disp('Over threshold percetage limitation thresholding failed.');
% 	return
% else
% 	disp(['After over threshold percetage limitation: ' num2str(length(firstPassBis)) ' events.']);
% end




% Merge spindles if inter-ripple period is too short
minInterspindlesamples = minInterSpindleInterval/1000*frequency;
secondPass = [];
ripple = firstPassBis(1,:);
for i = 2:size(firstPassBis,1)
	if firstPassBis(i,1) - ripple(2) < minInterspindlesamples
		% Merge
		ripple = [ripple(1) firstPass(i,2)];
	else
		secondPass = [secondPass ; ripple];
		ripple = firstPassBis(i,:);
	end
end
secondPass = [secondPass ; ripple];
% if isempty(secondPass)
% 	disp('Ripple merge failed');
% 	return
% else
% 	disp(['After ripple merge: ' num2str(length(secondPass)) ' events.']);
% end

% Discard spindles with a peak power < highThresholdFactor
thirdPass = [];
for i = 1:size(secondPass,1)
	[maxValue, ~] = max(normalizedSquaredSignal([secondPass(i,1):secondPass(i,2)]));
    %MeanPeriod=mean(normalizedSquaredSignal([secondPass(i,1):secondPass(i,2)]));
    OverPeriod=(normalizedSquaredSignal([secondPass(i,1):secondPass(i,2)]));
    
	if maxValue > highThresholdFactor && length(find(OverPeriod>lowThresholdFactor+0.75))/length(find(normalizedSquaredSignal( secondPass(i,1):secondPass(i,2) )))>0.6        %& MeanPeriod> (lowThresholdFactor +highThresholdFactor/3)

        thirdPass = [thirdPass ; secondPass(i,:)];
	end
end
% if isempty(thirdPass)
% 	disp('Peak thresholding failed.');
% 	return
% else
% 	disp(['After peak thresholding: ' num2str(length(thirdPass)) ' events.']);
% end


clear start
clear stop

% Detect HIGH ripple periods by thresholding normalized squared signal
thresholded = normalizedSquaredSignal > highThresholdFactor;
start = find(diff(thresholded)>0);
stop = find(diff(thresholded)<0);
% Exclude last ripple if it is incomplete
if length(stop) == length(start)-1
	start = start(1:end-1);
end
% Exclude first ripple if it is incomplete
if length(stop)-1 == length(start)
    stop = stop(2:end);
end
% Correct special case when both first and last spindles are incomplete
if start(1) > stop(1)
	stop(1) = [];
	start(end) = [];
end
lastPass = [start,stop];


clear tdeb
clear tfin

val=sort([start;stop]);
a=1;

limlm=1.5E3;
for ll=1:length(start)
    if length(find(val>start(ll)&val<start(ll)+limlm))>7
        tdeb(a) = start(ll)/1250;
        tfin(a) = max(stop(stop<start(ll)+limlm))/1250;
        a=a+1;
    end
end


try            
    for i=1:size(tdeb,1)
        try
            starttemp=find(start>=tdeb(i)&start<=tfin(i));
            stoptemp=find(stop>=tdeb(i)&stop<=tfin(i));
            if stoptemp(end)-stoptemp(end-1)>1E4
                tfin(i)=stoptemp(end-1);
            end     
            if starttemp(2)-starttemp(1)>1E4
                tdeb(i)=starttemp(2);
            end 
        end
    end  
end



mergeTh=0.3E4;

try
    if ~isempty(tdeb)>0

        FourthPass=floor([tdeb' tfin']*1250);

        temp1=intervalSet(thirdPass(:,1)/1250*1E4,thirdPass(:,2)/1250*1E4);
        temp2=intervalSet(FourthPass(1,1)/1250*1E4,FourthPass(1,2)/1250*1E4);  

        for i=2:size(FourthPass,1)
            temp2=or(temp2,intervalSet(FourthPass(i,1)/1250*1E4,FourthPass(i,2)/1250*1E4));  
        end

        temp2=mergeCloseIntervals(temp2,1);

        clear FourthPass
        FourthPass(:,1)=Start(temp2)*1250/1E4;
        FourthPass(:,2)=End(temp2)*1250/1E4;
% 
%         disp(['After Burst of high peak thresholding: ' num2str(length(FourthPass)) ' events.']);

        temp3=or(temp1,temp2);
        temp3=mergeCloseIntervals(temp3,mergeTh);


        ThirdPass(:,1)=Start(temp3)*1250/1E4;
        ThirdPass(:,2)=End(temp3)*1250/1E4;
        clear temp1 temp2 temp3
        thirdPass=round(ThirdPass);
    end
end

%
temp4=intervalSet(thirdPass(:,1)/1250*1E4,thirdPass(:,2)/1250*1E4);
temp4=mergeCloseIntervals(temp4,mergeTh);
FithPass(:,1)=Start(temp4)*1250/1E4;
FithPass(:,2)=End(temp4)*1250/1E4;
clear temp4

thirdPass=round(FithPass);
    

peakNormalizedPower = [];
for i = 1:size(thirdPass,1)
	[maxValue, ~] = max(normalizedSquaredSignal([thirdPass(i,1):thirdPass(i,2)]));
    peakNormalizedPower = [peakNormalizedPower ; maxValue];
end

% Detect negative peak position for each ripple
peakPosition = zeros(size(thirdPass,1),1);
for i=1:size(thirdPass,1)
	[~, minIndex] = min(signal(thirdPass(i,1):thirdPass(i,2)));
	peakPosition(i) = minIndex + thirdPass(i,1) - 1;
end

% Detect instantaneous frequency
fqcy = zeros(size(thirdPass,1),1);

for i=1:size(thirdPass,1)
	peakIx = LocalMinima(signal(thirdPass(i,1):thirdPass(i,2)),4,0);
    if ~isempty(peakIx)
        fqcy(i) = frequency/median(diff(peakIx));
    else
%         warning('Weird...')
    end
end
time = filtered(:,1);
% Detect instantaneous frequency
fqcy2 = zeros(size(thirdPass,1),1);
for i=1:size(thirdPass,1)
    [up, ~] = ZeroCrossings([time([thirdPass(i,1):thirdPass(i,2)]'),(signal(thirdPass(i,1):thirdPass(i,2)))]);
    if ~isempty(up)
            fqcy2(i,1) = sum(up)/(length(up)/frequency);
                   fqcy2(i,2) = length(up);
        else
%             warning('Weird...')
    end
end


% Discard spindles that are way too long
time = filtered(:,1);

spindles = [time(thirdPass(:,1)) time(peakPosition) time(thirdPass(:,2)) peakNormalizedPower fqcy fqcy2];
duration = spindles(:,3)-spindles(:,1);

spindles(duration>maxSpindleDuration/1000,:) = [];

% Discard spindles that are way too short
duration = spindles(:,3)-spindles(:,1);
spindles(duration<minSpindleDuration/1000,:) = [];

% disp(['After duration test: ' num2str(size(spindles,1)) ' events.']);




% If a noisy channel was provided, find ripple-like events and exclude them
bad = [];
if ~isempty(noise)
	% Square and pseudo-normalize (divide by signal stdev) noise
	squaredNoise = noise(:,2).^2;
	window = ones(windowLength,1)/windowLength;
	normalizedSquaredNoise = unity(Filter0(window,sum(squaredNoise,2)),stdev,[]);
	excluded = logical(zeros(size(spindles,1),1));
	% Exclude spindles when concomittent noise crosses high detection threshold
	previous = 1;
	for i = 1:size(spindles,1)
		j = FindInInterval(noise,[spindles(i,1),spindles(i,3)],previous);
		previous = j(2);
		if any(normalizedSquaredNoise(j(1):j(2))>highThresholdFactor)
			excluded(i) = 1;
		end
	end
	bad = spindles(excluded,:);
	spindles = spindles(~excluded,:);
% 	disp(['After noise removal: ' num2str(size(spindles,1)) ' events.']);
end






try
    start2=[firstPass(:,1);FourthPass(:,1)];
    stop2=[firstPass(:,2);FourthPass(:,2)];
catch
    start2=firstPass(:,1);
    stop2=firstPass(:,2);  
end


val2=sort([start2;stop2]);
a=1;

try
    limlm=2E3;
    for ll=1:length(start2)
        if length(find(val2>start2(ll)&val2<start2(ll)+limlm))>5
            tdeb2(a)=start2(ll)/1250;
            tfin2(a)=max(stop2(stop2<start2(ll)+limlm))/1250;
            a=a+1;
        end
    end

    if  ~isempty(tdeb2)
        tempF=floor([tdeb2' tfin2']*1250);
        temp2F=intervalSet(tempF(1,1)/1250*1E4,tempF(1,2)/1250*1E4);  
        for i=2:size(tempF,1)
            temp2F=or(temp2F,intervalSet(tempF(i,1)/1250*1E4,tempF(i,2)/1250*1E4));  
        end
        temp2F=mergeCloseIntervals(temp2F,1E4);
        temp2F=dropShortIntervals(temp2F,0.5E4);
        SWA(:,1)=Start(temp2F)*1250/1E4;
        SWA(:,2)=End(temp2F)*1250/1E4;
        SWA=[time(round(SWA(:,1))) time(round(SWA(:,2)))];
        SWAEpoch=intervalSet(SWA(:,1)*1E4,SWA(:,2)*1E4);

    end

catch
    SWA=[];
end




          
                
end
 




function y = Filter0(b,x)

if size(x,1) == 1
	x = x(:);
end


if mod(length(b),2)~=1
	
mod(length(b),2)
error('filter order should be odd');
end

shift = (length(b)-1)/2;

[y0 z] = filter(b,1,x);

y = [y0(shift+1:end,:) ; z(1:shift,:)];
end

function [U,stdA] = unity(A,sd,restrict)

if ~isempty(restrict)
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

end



