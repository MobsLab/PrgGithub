function [lfp,indices] = GetHighLFP(channels,varargin)

%GetHighLFP - Get local field potentials, with a higher sampling rate
%
%  Load local field potentials from disk (unlike spikes or positions, LFP data
%  is usually too large to keep in memory).
%
%  USAGE
%
%    [lfp,indices] = GetHighLFP(channels,<options>)
%
%    channels       list of channels to load (use keyword 'all' for all)
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'restrict'    list of time intervals to read from the LFP file
%     'select'      select channel by ID ('id', counted from 0 a la NeuroScope)
%                   or by number ('number', counted from 1 a la Matlab)
%                   (default = 'id')
%     'frequency'   sampling rate (in Hz, default = DATA.rates.lfp, from xml file)
%    =========================================================================
%
%  OUTPUT
%
%    lfp            list of (time,voltage1,...,voltageN) tuples
%    indices        for each tuple, the index of the interval it falls in
%
%  EXAMPLES
%
%    % channel ID 5 (= # 6), from 0 to 120 seconds
%    lfp = GetLFP(5,'restrict',[0 120]);
%    % same, plus from 240.2 to 265.23 seconds
%    lfp = GetLFP(5,'restrict',[0 120;240.2 265.23]);
%    % multiple channels
%    lfp = GetLFP([1 2 3 4 10 17],'restrict',[0 120]);
%    % channel # 3 (= ID 2), from 0 to 120 seconds
%    lfp = GetLFP(3,'restrict',[0 120],'select','number');

% Copyright (C) 2004-2011 by Michaël Zugaro 
% Adapted to get high frequency LFP
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

global DATA;
if isempty(DATA)
	error('No session defined (did you forget to call SetCurrentSession? Type ''help <a href="matlab:help Data">Data</a>'' for details).');
end

% Default values
intervals = [0 Inf];
select = 'id';
frequency = DATA.rates.lfp;

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters (type ''help <a href="matlab:help GetLFP">GetLFP</a>'' for details).');
end

% Parse parameter list
for i = 1:2:length(varargin)
  if ~ischar(varargin{i})
    error(['Parameter ' num2str(i+1) ' is not a property (type ''help <a href="matlab:help GetLFP">GetLFP</a>'' for details).']);
  end
  switch(lower(varargin{i}))
    case {'intervals','restrict'}
        intervals = varargin{i+1};
        if ~isdmatrix(intervals) || size(intervals,2) ~= 2
            error(['Incorrect value for property ''' lower(varargin{i}) ''' (type ''help <a href="matlab:help GetLFP">GetLFP</a>'' for details).']);
        end
    case 'select'
        select = lower(varargin{i+1});
        if ~isastring(select,'id','number')
            error('Incorrect value for property ''select'' (type ''help <a href="matlab:help GetLFP">GetLFP</a>'' for details).');
        end
    case 'frequency'
        frequency = varargin{i+1};
        if ~isdscalar(frequency,'>0')
            error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help GetLFP">GetLFP</a>'' for details).');
        end
    otherwise
      error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help GetLFP">GetLFP</a>'' for details).']);
  end
end

filename = [DATA.session.path '/' DATA.session.basename '.dat'];
if ~exist(filename,'file')
	error(['File ''' filename ''' not found.']);
end
nChannels = DATA.nChannels;
if isa(channels,'char') && strcmpi(channels,'all')
	channels = (1:nChannels)-1;
end

if strcmp(select,'id')
	channels = channels + 1;
end


nIntervals = size(intervals,1);
lfp = [];
indices = [];
for i = 1:nIntervals
	duration = (intervals(i,2)-intervals(i,1));
	start = intervals(i,1);
	% Load data
	data = LoadBinary(filename,'duration',duration,'frequency',frequency,'nchannels',nChannels,'start',start,'channels',channels);
	t = start:(1/frequency):(start+(length(data)-1)/frequency);t=t';
	lfp = [lfp ; t data];
	indices = [indices ; i*ones(size(t))];
end

