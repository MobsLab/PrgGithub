%GetEventsAttentional - Get all Attentional events.
%
%  USAGE
%
%    events = GetEventsAttentional(selection,<options>)
%
%    selection      optional list of event descriptions; see examples below
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'output'      'times' returns the event times, 'indices' returns a
%                   list of matching row indices, 'logical' returns a
%                   list of matching row logical indices, and 'descriptions'
%                   returns a list of descriptions (default = 'times')
%    =========================================================================
%
%  EXAMPLES
%
%    % Get all event descriptions
%    evt = GetEvents('output','descriptions');
%
%    % Get all event times
%    evt = GetEvents;
%
%    % Get timestamps of events with description 'Ripple' or 'Sharp Wave'
%    evt = GetEvents({'Ripple','Sharp Wave'});
%
%    % Get indices of events with description 'Ripple'
%    idx = GetEvents({'Ripple'},'output','indices');
%    % When there is only one regexp, the {} can be omitted:
%    idx = GetEvents('Ripple','output','indices');
%
%    % Get logical indices of events with description starting with any letter
%    % but 'R' and ending with ' beginning'
%    m = GetEvents({'[^R].* beginning'},'output','logical');
%
%  NOTE
%
%    Type 'help regexp' for details on pattern matching using regular expressions.

% Copyright (C) 2004-2010 by Michaël Zugaro
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

function events17 = GetEventsAttentional(varargin)

global DATA;
if isempty(DATA),
	error('No session defined (did you forget to call SetCurrentSession? Type ''help <a href="matlab:help Data">Data</a>'' for details).');
end

% Default values
output = 'times';

if mod(length(varargin),2) ~= 0,
	selection = varargin{1};
	if isa(selection,'char'), selection = {selection}; end
	varargin = {varargin{2:end}};
else
	selection = [];
end

% Parse options
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i+firstIndex) ' is not a property (type ''help <a href="matlab:help GetEvents">GetEvents</a>'' for details).']);
	end
	switch(lower(varargin{i})),
		case 'output',
			output = lower(varargin{i+1});
			if ~isstring(output,'times','indices','logical','descriptions'),
				error('Incorrect value for property ''output'' (type ''help <a href="matlab:help GetEvents">GetEvents</a>'' for details).');
			end
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help GetEvents">GetEvents</a>'' for details).']);
	end
end

% Events channel #17 : stimulation
events17 = DATA.events17;
if isempty(events17.time), return; end

% Selected events only
nPatterns = length(selection);
if nPatterns == 0,
	selected = logical(ones(size(events17.time)));
else
	selected = logical(zeros(size(events17.time)));
	for i = 1:nPatterns,
		pattern = ['^' selection{i} '$'];
		matches = GetMatches(regexp(events.description,pattern));
		selected = selected | matches;
	end
end
if strcmp(output,'times'),
	events17 = events17.time(selected,:);
elseif strcmp(output,'indices'),
	events17 = find(selected);
elseif strcmp(output,'logical'),
	events17 = selected;
elseif strcmp(output,'descriptions'),
	events17 = unique({events17.description{selected}})';
end

% Events channel #18 : Standard tone presentation
events18 = DATA.events18;
if isempty(events18.time), return; end

% Selected events only
nPatterns = length(selection);
if nPatterns == 0,
	selected = logical(ones(size(events18.time)));
else
	selected = logical(zeros(size(events18.time)));
	for i = 1:nPatterns,
		pattern = ['^' selection{i} '$'];
		matches = GetMatches(regexp(events.description,pattern));
		selected = selected | matches;
	end
end
if strcmp(output,'times'),
	events18 = events18.time(selected,:);
elseif strcmp(output,'indices'),
	events18 = find(selected);
elseif strcmp(output,'logical'),
	events18 = selected;
elseif strcmp(output,'descriptions'),
	events18 = unique({events18.description{selected}})';
end


% Events channel #19 : Standard tone presentation
events19 = DATA.events19;
if isempty(events19.time), return; end

% Selected events only
nPatterns = length(selection);
if nPatterns == 0,
	selected = logical(ones(size(events19.time)));
else
	selected = logical(zeros(size(events19.time)));
	for i = 1:nPatterns,
		pattern = ['^' selection{i} '$'];
		matches = GetMatches(regexp(events.description,pattern));
		selected = selected | matches;
	end
end
if strcmp(output,'times'),
	events19 = events19.time(selected,:);
elseif strcmp(output,'indices'),
	events19 = find(selected);
elseif strcmp(output,'logical'),
	events19 = selected;
elseif strcmp(output,'descriptions'),
	events19 = unique({events19.description{selected}})';
end

% Events channel #20 : Standard tone presentation
events20 = DATA.events20;
if isempty(events20.time), return; end

% Selected events only
nPatterns = length(selection);
if nPatterns == 0,
	selected = logical(ones(size(events20.time)));
else
	selected = logical(zeros(size(events20.time)));
	for i = 1:nPatterns,
		pattern = ['^' selection{i} '$'];
		matches = GetMatches(regexp(events.description,pattern));
		selected = selected | matches;
	end
end
if strcmp(output,'times'),
	events20 = events20.time(selected,:);
elseif strcmp(output,'indices'),
	events20 = find(selected);
elseif strcmp(output,'logical'),
	events20 = selected;
elseif strcmp(output,'descriptions'),
	events20 = unique({events20.description{selected}})';
end

% Events channel #21 : Standard tone presentation
events21 = DATA.events21;
if isempty(events21.time), return; end

% Selected events only
nPatterns = length(selection);
if nPatterns == 0,
	selected = logical(ones(size(events21.time)));
else
	selected = logical(zeros(size(events21.time)));
	for i = 1:nPatterns,
		pattern = ['^' selection{i} '$'];
		matches = GetMatches(regexp(events.description,pattern));
		selected = selected | matches;
	end
end
if strcmp(output,'times'),
	events21 = events21.time(selected,:);
elseif strcmp(output,'indices'),
	events21 = find(selected);
elseif strcmp(output,'logical'),
	events21 = selected;
elseif strcmp(output,'descriptions'),
	events21 = unique({events21.description{selected}})';
end


function m = GetMatches(c)

m = zeros(length(c),1);
for i = 1:length(c),
	m(i) = ~isempty(c{i});
end