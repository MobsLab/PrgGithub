%INTANfilter
% 21.06.2019 t.balenbois@gmail.com
%
% filteredData = INTANfilter(data)
% filteredData = INTANfilter(data, -0.146)
% filteredData = INTANfilter(data, -0.146, 250, 30000)
% 
% This function returns a filtered version of the data. 
% The filter is identical to the one used in the MOBSinterface software.
% It is also the same as in the regular INTAN software, 
%   but with a different default frequency.
%
%
%INPUT
%  data              : data to be filtered, as an array of size (nChannels, nSamples).
%  state             : (optional) if data is fed in batches, state at the end of previous batch. 
%                                 default zeros(size(data,1))
%  cutOffFreq        : (optional) cutoff frequency of filter. 
%                                 default 350
%  sampleFreq        : (optional) sample frequency of the original signal. 
%                                 default 20000
%
%
%OUTPUT
%  filteredData      : filtered data using highpass first order filter
%  state             : state of the filter[ at the end of this batch
%
%
%ASSUMPTIONS
%  none
%

function [filteredData,state]=INTANfilter(data, state, cutOffFreq, sampleFreq)

	if ~exist('state','var')
		state=zeros(1,size(data,1));
	end
	if ~exist('cutOffFreq','var')
		cutOffFreq=350;
	end
	if ~exist('sampleFreq','var')
		sampleFreq=20000;
	end

	a = exp(-2*pi* cutOffFreq / sampleFreq);
	b = 1 - a;

	if (size(state,2) == 1) && (size(data,1) ~= 1)
		state = state';
	end
	if size(state,2) ~= size(data,1)
		error('the state variable must have the same size as the number of channels.')
	end

	filteredData = zeros(size(data));

	nChannels = size(data,1);
	nSample = size(data,2);
	for c = 1:nChannels
		for t = 1:nSample
			filteredData(c,t) = data(c,t) - state(c);
			state(c) = a * state(c) + b * data(c,t);
		end
	end
end

