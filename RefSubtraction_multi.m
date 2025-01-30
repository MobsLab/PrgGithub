 %RefSubtraction_multi - for binary file(.dat): the values of specified channels will
%                    be substracted by the values of the reference channel
%                    and a copy of the original file will be saved by
%                    default. Version multi: one file can be splitted into 
%                    several files, with respectively his name, channels to
%                    proceed, channel of ref, and channels to keep (if no
%                    channels to keep > [])
%
%  USAGE
%
%    RefSubtraction_multi(filename, nChannels,nSouris,
%                         'souris1', chs_to_treat, ref, chs_to_keep,
%                         'souris2', chs_to_treat, ref, chs_to_keep,
%                         ...
%                         <options>)
%
%    filename           file to read
%    nChannels          number of channels in the file
%    nSouris            number of files you want to produce
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'duration'    duration to read (in s) (default = Inf)
%     'frequency'   sampling rate (in Hz) (default = 20kHz)
%     'start'       position to start reading (in s) (default = 0)
%     'precision'   sample precision (default = 'int16')
%     'overwrite'   if overwrite the original file.(default = 0, in this
%                   case,a copy of original file will be saved with name:
%                   filename_original.ext
%    =========================================================================

% This programme is base on the 'LoadBinary' wrote by Michaël Zugaro
% Kejian, Laboratoires MOBS, ESPCI-ParisTech 08.04.2015

function RefSubtraction_multi(filename,nChannels,nSouris,varargin)
%channels in neuroscope language


%check format of first parametres
if ~(isa(nChannels,'double') & round(nChannels)==nChannels)
    error('format error for nChannels');
end

if ~(isa(nSouris,'double') & round(nSouris)==nSouris)
    error('format error for nSouris, it should be an integer');
% else
%     if (nSouris<1 || nSouris>4)
%         error('nSouris should be between 1 and 4')
%     end
end


%defaut settings
start = 0;
precision = 'int16';
skip = 0;
duration = Inf;
frequency = 20000;
channels = 1:nChannels; % to load all channels, it's more efficient
[pathstr,name,ext]=fileparts(filename);
overwrite=0; %keeps original file and change name to _original





%% parametres varargin


% Parse options

for i=1:4:nSouris*4
    indice=ceil(i/4);
    
    %check format
    if ~isempty(varargin{i+1})
        if ~(isa(varargin{i+1},'double') & round(varargin{i+1})==varargin{i+1})
            error(['format error for chs_to_treat, for mouse ',num2str(indice)]);
        end
    end
    
    if ~isempty(varargin{i+2})
        if ~(isa(varargin{i+2},'double') & length(varargin{i+2})==1 & round(varargin{i+2})==varargin{i+2})
            error(['format error for chs_ref, for mouse ',num2str(indice)]);
        end
    end
    
    if ~isempty(varargin{i+3})
        if ~(isa(varargin{i+3},'double') & round(varargin{i+3})==varargin{i+3})
            error(['format error for chs_to_keep, for mouse ',num2str(indice)]);
        end
    end
    
    
    
    %check parametres consistency, only continue if chs_to_proceed and chs_ref are not
    %empty, or they are empty but chs_to_keep is not  
    if ~((length(varargin{i+1})==0 & length(varargin{i+2})==0 & length(varargin{i+3}~=0)) || (length(varargin{i+1})~=0 & length(varargin{i+2})==1))
        error(['parametres in mouse ',num2str(indice),' does not make sense, please verify']);
    end
    
    
    %begin to entre varargin in variables structures
    output_name{indice}=varargin{i};
    
    %add 1 to conform to the notation in matlab
    chs_to_preceed{indice}=varargin{i+1}+1;
    chs_ref{indice}=varargin{i+2}+1;
    
%     if (isscalar(varargin{i+2}) & round(varargin{i+2})==varargin{i+2})
%         chs_ref{indice}=varargin{i+2}+1;
%     else
%         error('ref should be an integer')
%     end
    
    chs_to_keep{indice}=varargin{i+3}+1;
end

for i = nSouris*4+1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+3) ' is not a property (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'duration'
            duration = varargin{i+1};
            if ~isdscalar(duration,'>=0')
                error('Incorrect value for property ''duration'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'frequency'
            frequency = varargin{i+1};
            if ~isdscalar(frequency,'>0')
                error('Incorrect value for property ''frequency'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'start'
            start = varargin{i+1};
            if ~isdscalar(start)
                error('Incorrect value for property ''start'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
            if start < 0, start = 0; end
        case 'precision'
            precision = varargin{i+1};
            if ~isstring(precision)
                error('Incorrect value for property ''precision'' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        case 'overwrite'
            overwrite = varargin{i+1};
            if ~isdscalar(overwrite),
                error('Incorrect value for property ''overwrite'', (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help RefSubtraction">RefSubtraction</a>'' for details).']);
    end
end


% Check consistency between channel IDs and number of channels
if any(channels>nChannels),
    error('Cannot load specified channels (listed channel IDs inconsistent with total number of channels).');
end

sizeInBytes = 0;
switch precision
    case {'uchar','unsigned char','schar','signed char','int8','integer*1','uint8','integer*1'}
        sizeInBytes = 1;
    case {'int16','integer*2','uint16','integer*2'}
        sizeInBytes = 2;
    case {'int32','integer*4','uint32','integer*4','single','real*4','float32','real*4'}
        sizeInBytes = 4;
    case {'int64','integer*8','uint64','integer*8','double','real*8','float64','real*8'}
        sizeInBytes = 8;
end

if ~exist(filename),
    error(['File ''' filename ''' not found.']);
end




%% begin
tic

%open files to writes (nbr of nSouris), and file to read

fidR=fopen(filename,'r');
for i=1:nSouris
    if exist(fullfile(pathstr,[name,'_',output_name{i},'.new']))==2  % delete possible existing working file due to previous wrong command
        delete(fullfile(pathstr,[name,'_',output_name{i},'.new']));
        %display(['working on all new ',fullfile(pathstr,[name,'_',output_name{i},'.new'])]);
    end
        fidW{i}=fopen(fullfile(pathstr,[name,'_',output_name{i},'.new']),'w');
    if fidW{i} == -1
        error(['Cannot write ',fullfile(pathstr,[name,'_',output_name{i},'_REF',num2str(Ref-1),ext]),'.']);
    end
end


if fidR == -1
    error(['Cannot read ',filename,'.']);
end



% Position file index for reading
start = floor(start*frequency)*nChannels*sizeInBytes;
status = fseek(fidR,start,'bof');
if status ~= 0 %if fail
    fclose(fidR);
    for i=1:nSouris
        fclose(fidW{i});
    end
    error('Could not start reading (possible reasons include trying to read past the end of the file).');
end


% determinate the real duration of the file
if isinf(duration),
    % Determine number of samples when duration is 'inf'
    fileStart = ftell(fidR); %start entred
    status = fseek(fidR,0,'eof'); %end
    if status ~= 0,
        fclose(fidR);
        for i=1:nSouris
            fclose(fidW{i});
        end
        error('Error reading the data file (possible reasons include trying to read past the end of the file).');
    end
    fileStop = ftell(fidR);
    nSamplesPerChannel = (fileStop-fileStart)/nChannels/sizeInBytes;
    duration = nSamplesPerChannel/frequency;
    frewind(fidR);
    status = fseek(fidR,start,'bof');
    if status ~= 0,
        fclose(fidR);
        for i=1:nSouris
            fclose(fidW{i});
        end
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
    current_p=0;
    for j = 1:nChunks,
        d = LoadBinaryChunk(fidR,'frequency',frequency,'nChannels',nChannels,'channels',channels,'duration',durationPerChunk,'skip',skip);
        [m,n] = size(d);
        if m == 0, break; end
        
        for i=1:nSouris %preceed individually every mouse data and write with preceeded data and data to keep into a same file
            if length(chs_ref{i})~=0 %if length===0, means no treatement needed
                d(:,chs_to_preceed{i})=d(:,chs_to_preceed{i})-d(:,chs_ref{i})*ones(1,length(chs_to_preceed{i})); % to have the same dimension by using a multiplication of ones
                towrite=d(:,sort([chs_to_preceed{i},chs_to_keep{i}]));
            else %if no ref (means no chs to treat), then to write only the chs to keep
                towrite=d(:,chs_to_keep{i});
            end
            
            fwrite(fidW{i},towrite',precision);
        end
        
        %display finish percentage
        p=(j-1)/nChunks;
        if p>=current_p
            disp(' ')
            display([num2str(current_p*100),'%']);
            current_p=current_p+0.1;
        end
    end
    % If the data size is not a multiple of the chunk size, read the remainder
    remainder = duration - nChunks*durationPerChunk;
    if remainder ~= 0,
        d = LoadBinaryChunk(fidR,'frequency',frequency,'nChannels',nChannels,'channels',channels,'duration',remainder,'skip',skip);
        [m,n] = size(d);
        if m ~= 0,
            for i=1:nSouris %preceed individually every mouse data and write with preceeded data and data to keep into a same file
                if length(chs_ref{i})~=0 %if length===0, means no treatement needed
                    d(:,chs_to_preceed{i})=d(:,chs_to_preceed{i})-d(:,chs_ref{i})*ones(1,length(chs_to_preceed{i})); % to have the same dimension by using a multiplication of ones
                    towrite=d(:,sort([chs_to_preceed{i},chs_to_keep{i}]));
                else
                    towrite=d(:,chs_to_keep{i});
                end
                
                fwrite(fidW{i},towrite',precision);
            end
        end
    end
else
    d = fread(fidR,[nChannels frequency*duration],precision);
    d=d';
    for i=1:nSouris %preceed individually every mouse data and write with preceeded data and data to keep into a same file
        if length(chs_ref{i})~=0 %if length===0, means no treatement needed
            d(:,chs_to_preceed{i})=d(:,chs_to_preceed{i})-d(:,chs_ref{i})*ones(1,length(chs_to_preceed{i})); % to have the same dimension by using a multiplication of ones
            towrite=d(:,sort([chs_to_preceed{i},chs_to_keep{i}]));
        else
            towrite=d(:,chs_to_keep{i});
        end
        
        fwrite(fidW{i},towrite',precision);
    end
end

%close
fclose(fidR);
for i=1:nSouris
    fclose(fidW{i});
end

%rename
if overwrite == 0
    if exist(fullfile(pathstr,[name,'_original',ext]))~=2 % if there is not already a copy file
        display([filename,' renamed to ', fullfile(pathstr,[name,'_original',ext])]);
        movefile(filename, fullfile(pathstr,[name,'_original',ext])); %original file rename to _original
    end
end
    
for i=1:nSouris
    movefile(fullfile(pathstr,[name,'_',output_name{i},'.new']),fullfile(pathstr,[name,'_',output_name{i},ext])); % new preceeded files renamed to original file's name
end

%delete
if overwrite == 1 %to delete the original file, do this at the end to ensure all has suceeded before deleting
    delete(filename);
    display([filename,' deleted']);
end


display('Done!find the proceeded files at the same path');
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
test = isa(x,'double') & isscalar(x); % test=1 if x is scalar and double

% Ignore NaN
x = x(~isnan(x));

% Test: integers?
test = test & round(x)==x; %test=1 x is scalar, double, and integer 

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





