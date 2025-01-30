function out = bload(fname, arg1, startpos, datasize, skip)
% loads a binary file
%
% usage:  bload(fname, [NumChannels SamplesToLoad], startpos, datasize, skip)
% starts reading from startpos BYTES into the file (not samples)
% datasize defaults to 'short'
% 'int16' is better than 'short'(Kenji's comment).'short' is also supported but hey are not guaranteed to the same size on all platforms.
%
% final argument "skip" allows you to repeatedly skip the specified number of bytes
% to read only certain channels - see fread.

if (nargin < 4)
	datasize = 'short';
end

if ~exist(fname,'file')
    error(sprintf('File %s does not exist!', fname));
end

fp = fopen(fname, 'r');

if (nargin >=3)
	status = fseek(fp, startpos, 'bof');
	if (status ~= 0)
		error('Error doing fseek');
	end
end

if (nargin >= 5)
	out = fread(fp, arg1, datasize, skip);
else
	out = fread(fp, arg1, datasize);
end;

fclose(fp);