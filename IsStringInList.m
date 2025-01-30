%IsStringInList - Test if the parameter is among a list of admissible strings.
%
%  USAGE
%
%    test = IsStringInList(x,string1,...,stringN)
%
%    x              item to test
%    string1...N    list of admissible strings


% Copyright (C) 2004-2006 by Michael Zugaro
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.

function test = IsStringInList(x,varargin)

if ~isa(x,'char'),
	test = false;
	return;
end

test = true;
for i = 1:length(varargin),
	if strcmp(x,varargin{i}), return; end
end

test = false;
