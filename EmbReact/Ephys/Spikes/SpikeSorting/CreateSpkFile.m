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

function CreateSpkFile(filename,SpikeTime,nChannels,ChannelsTetrode,NewName,varargin)
%channels in neuroscope language
precision = 'int16';
skip = 0;
frequency = 20000;
overwrite=0; %keeps original file called _original
WaveformSamples=32;
PeakSample=14;

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
    fidW=fopen(fullfile(pathstr,NewName),'w');
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

% check start and stop

start = round((SpikeTime(1)*frequency-PeakSample)*nChannels*sizeInBytes);
status = fseek(fidR,start,'bof');
if status ~= 0,
    fclose(fidR);
    if overwrite==0 fclose(fidW); end
    error('Could not start reading (possible reasons include trying to read past the end of the file).');
end

stop = round((SpikeTime(end)*frequency+WaveformSamples-PeakSample)*nChannels*sizeInBytes);
status = fseek(fidR,stop,'bof');
if status ~= 0,
    fclose(fidR);
    if overwrite==0 fclose(fidW); end
    error('Could not start reading (possible reasons include trying to read past the end of the file).');
end

% For large amounts of data, read chunk by chunk


for sp=1:length(SpikeTime)
    status = fseek(fidR,(SpikeTime(sp)*frequency-PeakSample)*nChannels*sizeInBytes,'bof');
    d = fread(fidR,[nChannels WaveformSamples],precision,skip);
    d=d';
    d= d(:,ChannelsTetrode+1);
    fwrite(fidW,d',precision);
end

%close
fclose(fidR);
if overwrite==0 fclose(fidW); end



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
