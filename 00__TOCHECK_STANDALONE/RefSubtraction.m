%RefSubtraction - for binary file: the values of specified channels will
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

function RefSubtraction(filename,chs_to_treat,Ref,varargin)%,start,nChannels,precision,duration,frequency)
%channels in neuroscope language
start = 0;
nChannels = 32;
precision = 'int16';
skip = 0;
duration = Inf;
frequency = 20000;
channels=[];
overwrite=0; %keeps original file called _original
chs_to_keep=chs_to_treat;
%chs_to_treat = [0:7]+1;
%Ref=23+1;
%filename='FEAR-Mouse-248-26032015.fil';


%% parametres

%addpath('c:\Kejian_workfile_0403_copydat\necessary_files');

% Parse options
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+3) ' is not a property (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).']);
    end
    switch(lower(varargin{i})),
        case 'duration',
            duration = varargin{i+1};
            if ~isdscalar(duration,'>=0'),
                error('Incorrect value for property ''duration'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'frequency',
            frequency = varargin{i+1};
            if ~isdscalar(frequency,'>0'),
                error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'start',
            start = varargin{i+1};
            if ~isdscalar(start),
                error('Incorrect value for property ''start'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
            if start < 0, start = 0; end
        case 'nchannels',
            nChannels = varargin{i+1};
            if ~isiscalar(nChannels,'>0'),
                error('Incorrect value for property ''nChannels'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'channels',
            channels = varargin{i+1};
            if ~isivector(channels,'>=0'),
                error('Incorrect value for property ''channels'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'precision',
            precision = varargin{i+1};
            if ~isstring(precision),
                error('Incorrect value for property ''precision'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'chs_to_keep'
            chs_to_keep= varargin{i+1};
        case 'overwrite',
            overwrite = varargin{i+1};
            if ~isdscalar(overwrite),
                error('Incorrect value for property ''overwrite'', (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).']);
    end
end

%change the numbers of channnels to the matlab based
chs_to_treat = chs_to_treat+1;
chs_to_keep=chs_to_keep+1;
Ref=Ref+1;


% load all channels, it's more efficient
if isempty(channels),
    channels = 1:nChannels;
end

% Check consistency between channel IDs and number of channels
if any(channels>nChannels),
    error('Cannot load specified channels (listed channel IDs inconsistent with total number of channels).');
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
start = floor(start*frequency)*nChannels*sizeInBytes;
status = fseek(fidR,start,'bof');
if status ~= 0,
    fclose(fidR);
    if overwrite==0 fclose(fidW); end
    error('Could not start reading (possible reasons include trying to read past the end of the file).');
end


% determinate the real duration of the file
if isinf(duration),
    % Determine number of samples when duration is 'inf'
    fileStart = ftell(fidR); %start entred
    status = fseek(fidR,0,'eof'); %end
    if status ~= 0,
        fclose(fidR);
        if overwrite==0 fclose(fidW); end
        error('Error reading the data file (possible reasons include trying to read past the end of the file).');
    end
    fileStop = ftell(fidR);
    nSamplesPerChannel = (fileStop-fileStart)/nChannels/sizeInBytes;
    duration = nSamplesPerChannel/frequency;
    frewind(fidR);
    status = fseek(fidR,start,'bof');
    if status ~= 0,
        fclose(fidR);
        if overwrite==0 fclose(fidW); end
        error('Could not start reading (possible reasons include trying to read past the end of the file).');
    end
else
    nSamplesPerChannel = round(frequency*duration);
    if nSamplesPerChannel ~= frequency*duration,
        %  		disp(['Warning: rounding duration (' num2str(duration,'%.15g') ' -> ' num2str(nSamplesPerChannel/frequency,'%.15g') ')']);
        duration = nSamplesPerChannel/frequency;
    end
end



% For large amounts of data, read chunk by chunk

maxSamplesPerChunk = 100000;
nSamples = nChannels*nSamplesPerChannel;
if nSamples > maxSamplesPerChunk,
    % Determine chunk duration and number of chunks
    nSamplesPerChunk = floor(maxSamplesPerChunk/nChannels)*nChannels;
    durationPerChunk = nSamplesPerChunk/frequency/nChannels;
    nChunks = floor(duration/durationPerChunk);
    % Read all chunks
    i = 1;
    for j = 1:nChunks,
        d = LoadBinaryChunk(fidR,'frequency',frequency,'nChannels',nChannels,'channels',channels,'duration',durationPerChunk,'skip',skip);
        [m,n] = size(d);
        if m == 0, break; end
        d(:,chs_to_treat)=d(:,chs_to_treat)-d(:,Ref)*ones(1,length(chs_to_treat)); % to have the same dimension by using a multiplication of ones
        %             % added SB
        if length(chs_to_keep)~=nChannels
            allchans=[1:nChannels];
            
            allchans(chs_to_keep)=[];
            d(:,allchans)=[];
        end
        %             %
        
        fwrite(fidW,d',precision);
    end
    % If the data size is not a multiple of the chunk size, read the remainder
    remainder = duration - nChunks*durationPerChunk;
    if remainder ~= 0,
        d = LoadBinaryChunk(fidR,'frequency',frequency,'nChannels',nChannels,'channels',channels,'duration',remainder,'skip',skip);
        [m,n] = size(d);
        if m ~= 0,
            d(:,chs_to_treat)=d(:,chs_to_treat)-d(:,Ref)*ones(1,length(chs_to_treat));
            %             % added SB
            if length(chs_to_keep)~=nChannels
                allchans=[1:nChannels];
                allchans(chs_to_keep)=[];
                d(:,allchans)=[];
            end
            %             %
            fwrite(fidW,d',precision);
        end
    end
else
    d = fread(fidR,[nChannels frequency*duration],precision);
    d=d';
    d(:,chs_to_treat)=d(:,chs_to_treat)-d(:,Ref)*ones(1,length(chs_to_treat));
    % added SB
    if length(chs_to_keep)~=nChannels
    allchans=[1:nChannels];
    allchans(chs_to_keep)=[];
    d(:,allchans)=[];
    end
    %
    fwrite(fidW,d',precision);
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

function data = LoadBinaryChunk(fid,varargin)

% Default values
start = 0;
fromCurrentIndex = true;
nChannels = 1;
precision = 'int16';
duration = 1;
frequency = 20000;
channels = [];

if nargin < 1 | mod(length(varargin),2) ~= 0,
    error('Incorrect number of parameters (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
end

% Parse options
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+3) ' is not a property (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).']);
    end
    switch(lower(varargin{i})),
        case 'duration',
            duration = varargin{i+1};
            if ~isdscalar(duration,'>=0'),
                error('Incorrect value for property ''duration'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
        case 'frequency',
            frequency = varargin{i+1};
            if ~isdscalar(frequency,'>0'),
                error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
        case 'start',
            start = varargin{i+1};
            fromCurrentIndex = false;
            if ~isdscalar(start),
                error('Incorrect value for property ''start'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
            if start < 0, start = 0; end
        case 'nchannels',
            nChannels = varargin{i+1};
            if ~isiscalar(nChannels,'>0'),
                error('Incorrect value for property ''nChannels'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
        case 'channels',
            channels = varargin{i+1};
            if ~isivector(channels,'>=0'),
                error('Incorrect value for property ''channels'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
        case 'precision',
            precision = varargin{i+1};
            if ~isstring(precision),
                error('Incorrect value for property ''precision'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
        case 'skip',
            skip = varargin{i+1};
            if ~isiscalar(skip,'>=0'),
                error('Incorrect value for property ''skip'' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help LoadBinaryChunk">LoadBinaryChunk</a>'' for details).']);
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

% Position file index for reading
if ~fromCurrentIndex,
    start = floor(start*frequency)*nChannels*sizeInBytes;
    status = fseek(fid,start,'bof');
    if status ~= 0,
        error('Could not start reading (possible reasons include trying to read a closed file or past the end of the file).');
    end
end

% Read data chunck
if skip ~= 0,
    data = fread(fid,[nChannels frequency*duration],precision,skip);
else
    data = fread(fid,[nChannels frequency*duration],precision);
end;
data=data';

% Keep only required channels
if ~isempty(channels) & ~isempty(data),
    data = data(:,channels);
end
end





