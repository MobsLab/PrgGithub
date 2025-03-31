%LoadParameters - Load parameters from an XML file.
%
%  USAGE
%
%    parameters = LoadParameters(filename)
%
%    filename            parameter file name

% Copyright (C) 2004-2009 by Michaël Zugaro
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

function parameters = LoadParameters(filename)

if ~exist(filename),
	error(['File ''' filename ''' not found.']);
end
[pathname,basename] = fileparts(filename);
parameters.session.path = pathname;
parameters.session.name = basename;

if isempty(which('xmltree')),
	error('This function requires the <a href="http://www.artefact.tk/software/matlab/xml/">xmltree</a> toolbox by G. Flandin.');
end

parameters.nChannels = str2num(p.acquisitionSystem.nChannels);
parameters.nBits = str2num(p.acquisitionSystem.nBits);
parameters.rates.lfp = str2num(p.fieldPotentials.lfpSamplingRate);
parameters.rates.wideband = str2num(p.acquisitionSystem.samplingRate);
try
	parameters.rates.video = str2num(p.video.samplingRate);
	parameters.maxX = str2num(p.video.width);
	parameters.maxY = str2num(p.video.height);
catch
	parameters.rates.video = 0;
	parameters.maxX = 0;
	parameters.maxY = 0;
	disp('... warning: missing video parameters (set to zero)');
end
