%SplitSpkFile - for binary file: the values of specified channels will
%                    be substracted by the values of the reference channel
%                    and a copy of the original file will be saved
%                    (if 'overwrite' is 1,no original fill saved)
%
%  USAGE
%
%    LoadBinary(filename, chnnels_to_treat, Reference_channel <options>)
%
%    filename           file to read
%    chnnels_to_treat   channels to treat
%    Reference_channel  the reference channel
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'duration'    duration to read (in s) (default = Inf)
%     'frequency'   sampling rate (in Hz) (default = 20kHz)
%     'start'       position to start reading (in s) (default = 0)
%     'nChannels'   number of data channels in the file (default = 32)
%     'channels'    channels to read (default = all)
%     'precision'   sample precision (default = 'int16')
%     'overwrite'   if overwrite the original file.(default = 0, in this
%                   case,a copy of original file will be saved with name:
%                   filename_original.ext
%    =========================================================================

% This programme is base on the 'LoadBinary' wrote by Michaël Zugaro
% Kejian, Laboratoires MOBS, ESPCI-ParisTech 08.04.2015

function SplitFetFile(filename,start,stop,varargin)
%channels in neuroscope language
precision = 'int16';
skip = 0;
frequency = 20000;
overwrite=0; %keeps original file called _original

%% parametres
% Parse options
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+3) ' is not a property (type ''help <a href="matlab:help SplitSpkFile">SplitSpkFile</a>'' for details).']);
    end
    switch(lower(varargin{i})),
        case 'frequency',
            frequency = varargin{i+1};
            if ~isdscalar(frequency,'>0'),
                error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help SplitSpkFile">SplitSpkFile</a>'' for details).');
            end
        case 'precision',
            precision = varargin{i+1};
            if ~isstring(precision),
                error('Incorrect value for property ''precision'' (type ''help <a href="matlab:help SplitSpkFile">SplitSpkFile</a>'' for details).');
            end
        case 'WaveformSamples',
            WaveformSamples = varargin{i+1};
            if ~isdscalar(overwrite),
                error('Incorrect value for property ''WaveformSamples'', (type ''help <a href="matlab:help SplitSpkFile">SplitSpkFile</a>'' for details).');
            end
        case 'overwrite',
            overwrite = varargin{i+1};
            if ~isdscalar(overwrite),
                error('Incorrect value for property ''overwrite'', (type ''help <a href="matlab:help SplitSpkFile">SplitSpkFile</a>'' for details).');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help SplitSpkFile">SplitSpkFile</a>'' for details).']);
    end
end

sizeInBytes = 0;
switch precision,
    case {'uchar','unsigned char','schar','signed char','int8','integer*1','uint8','integer*1'},
        sizeInBytes = 1;
    case {'int16','integer*2','uint16','integer*2'},
        sizeInBytes = 2;
    case {'int32','integer*4','uint32','integer*4','single','real*4','float32','real*4'},
        sizeInBytes = 4;
    case {'int64','integer*8','uint64','integer*8','double','real*8','float64','real*8'},
        sizeInBytes = 8;
end

if ~exist(filename),
    error(['File ''' filename ''' not found.']);
end

% if overwrite ~=0 & ~=1
%     error('overwrite should be 0 or 1')
% end


%% begin
tic

[pathstr,name,ext]=fileparts(filename);


if overwrite == 0
    fidR=fopen(filename,'r');
    fidW=fopen(fullfile(pathstr,[name,'.new']),'w');
else
    fidR=fopen(filename,'r+');
    fidW=fidR;
end

if fidR == -1
    error(['Cannot read ',filename,'.']);
end

if fidW == -1
    error(['Cannot write ',fullfile(pathstr,[name,'_REF',num2str(Ref-1),ext]),'.']);
end

% Position file index for reading
start = (start-1)*nChannelsTetrode*sizeInBytes*WaveformSamples;
status = fseek(fidR,start,'bof');
if status ~= 0,
    fclose(fidR);
    if overwrite==0 fclose(fidW); end
    error('Could not start reading (possible reasons include trying to read past the end of the file).');
end

% Position file index for reading
stop = (stop)*nChannelsTetrode*sizeInBytes*WaveformSamples;
status = fseek(fidR,stop,'bof');
if status ~= 0,
    fclose(fidR);
    if overwrite==0 fclose(fidW); end
    error('Could not start reading (possible reasons include trying to read past the end of the file).');
end

% For large amounts of data, read chunk by chunk
maxSamplesPerChunk = 100000;
SamplesPerSpike=nChannelsTetrode*sizeInBytes*WaveformSamples;
nSamples = stop-start;
keyboard
if nSamples > maxSamplesPerChunk,
    % Determine chunk duration and number of chunks
    
    nSamplesPerChunk = floor(maxSamplesPerChunk/SamplesPerSpike)*SamplesPerSpike;
    nChunks = floor(nSamples/nSamplesPerChunk);
    for j = 1:nChunks,
        status = fseek(fidR,start+(j-1)*nSamplesPerChunk,'bof');
        d = fread(fidR,nSamplesPerChunk,precision);
        fwrite(fidW,d,precision);
    end
    
    % If the data size is not a multiple of the chunk size, read the remainder
    remainder = nSamples - nChunks*nSamplesPerChunk;
    if remainder ~= 0,
        status = fseek(fidR,start+nChunks*nSamplesPerChunk,'bof');
        d = fread(fidR,remainder,precision);
        fwrite(fidW,d,precision);
    end
else
    status = fseek(fidR,start,'bof');
    d = fread(fidR,nSamples,precision);
    fwrite(fidW,d,precision);
end

%close
fclose(fidR);
if overwrite==0 fclose(fidW); end

%rename
if overwrite == 0
    if exist(fullfile(pathstr,[name,'_original',ext]))~=2 % if there is not already a copy file
        display(filename);
        display(fullfile(pathstr,[name,'_original',ext]));
        movefile(filename, fullfile(pathstr,[name,'_original',ext]));
    end
    movefile(fullfile(pathstr,[name,'.new']),fullfile(pathstr,[name,ext]));
end

display('done!find the treated file at the same path');
toc
end



%% Local support functions

function test = isdscalar(x,varargin)

% Check number of parameters
if nargin < 1,
    error('Incorrect number of parameters (type ''help <a href="matlab:help isdscalar">isdscalar</a>'' for details).');
end

% Test: double, scalar
test = isa(x,'double') & isscalar(x);

% Ignore NaN
x = x(~isnan(x));

% Optional tests
for i = 1:length(varargin),
    try
        if ~eval(['x' varargin{i} ';']), test = false; end
    catch err
        error(['Incorrect test ''' varargin{i} ''' (type ''help <a href="matlab:help isdscalar">isdscalar</a>'' for details).']);
    end
end
end

function test = isiscalar(x,varargin)

% Check number of parameters
if nargin < 1,
    error('Incorrect number of parameters (type ''help <a href="matlab:help isiscalar">isiscalar</a>'' for details).');
end

% Test: double, scalar
test = isa(x,'double') & isscalar(x);

% Ignore NaN
x = x(~isnan(x));

% Test: integers?
test = test & round(x)==x;

% Optional tests
for i = 1:length(varargin),
    try
        if ~eval(['x' varargin{i} ';']), test = false; end
    catch err
        error(['Incorrect test ''' varargin{i} ''' (type ''help <a href="matlab:help isiscalar">isiscalar</a>'' for details).']);
    end
end
end


function test = isivector(x,varargin)

% Check number of parameters
if nargin < 1,
    error('Incorrect number of parameters (type ''help <a href="matlab:help isivector">isivector</a>'' for details).');
end

% Test: double, vector
test = isa(x,'double') & isvector(x);

% Ignore NaNs
x = x(~isnan(x));

% Test: integers?
test = test & all(round(x)==x);

% Optional tests
for i = 1:length(varargin),
    try
        if varargin{i}(1) == '#',
            if length(x) ~= str2num(varargin{i}(2:end)), test = false; return; end
        elseif isstring(varargin{i},'>','>=','<','<='),
            dx = diff(x);
            if ~eval(['all(0' varargin{i} 'dx);']), test = false; return; end
        else
            if ~eval(['all(x' varargin{i} ');']), test = false; return; end
        end
    catch err
        error(['Incorrect test ''' varargin{i} ''' (type ''help <a href="matlab:help isivector">isivector</a>'' for details).']);
    end
end
end


function test = isstring(x,varargin)

% Check number of parameters
if nargin < 1,
    error('Incorrect number of parameters (type ''help <a href="matlab:help isstring">isstring</a>'' for details).');
end

test = true;

if ~ischar(x),
    test = false;
    return;
end

if isempty(varargin), return; end

for i = 1:length(varargin),
    if strcmp(x,varargin{i}), return; end
end

test = false;
end
