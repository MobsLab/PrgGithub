
% MakeConfigKS_Mouse
% 12.01.2018 KJ
%
% Create configuration files for KiloSort automatic spike sorting
%
%
%INPUTS
% filename:     name of the data file ('dat')
% folder:       directory of the data
% 
%
%
%


function ops = MakeConfigKS_Mouse(filename, folder, varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'tmult'
            templatemultiplier = lower(varargin{i+1});
            if mod(templatemultiplier,2)~=0
                error('Incorrect value for property ''TMult'', should be a multiple of 2.');
            end
        case 'whiteningrange'
            whiteningRange = lower(varargin{i+1});
            if whiteningRange<1
                error('Incorrect value for property ''whiteningRange''.');
            end
        case 'chanmapfile'
            name_map = varargin{i+1};
            if ~ischar(name_map)
                error('Incorrect value for property ''ChanMapFile''.');
            end
        case 'gpu_id'
            gpu_id = varargin{i+1};
            if ~isnumeric(gpu_id)
                error('Incorrect value for property ''Gpu_id''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('templatemultiplier','var')
    templatemultiplier = 8; % 8 times more templates created than Nchan
end
if ~exist('whiteningRange','var')
    whiteningRange = 4;
end
if ~exist('name_map','var')
    name_map = 'chanMap.mat';
end
if ~exist('gpu_id','var')
    gpu_id = 1;
end


%% From Wrapper

% Loads xml parameters (Neuroscope)
xml = LoadXml([filename(1:end-3) 'xml']);
% Define rootpath
rootpath = fileparts([filename(1:end-3) 'xml']);


%% CONFIG

ops.GPU                 = gpu_id; % whether to run this code on an Nvidia GPU (much faster, mexGPUall first)		
ops.parfor              = 1; % whether to use parfor to accelerate some parts of the algorithm		
ops.verbose             = 1; % whether to print command line progress		
ops.showfigures         = 1; % whether to plot figures during optimization		
		
ops.datatype            = 'dat';  % binary ('dat', 'bin') or 'openEphys'		
ops.fbinary             = fullfile(folder, filename);	
ops.fproc               = fullfile(folder, 'temp_wh.dat'); % residual from RAM of preprocessed data	
ops.fs                  = 20000; % Sampling rate

% define the channel map as a filename (string) or simply an array		
ops.chanMap             = fullfile(folder, name_map); % make this file using createChannelMapFile.m		
ops.criterionNoiseChannels = 0.2; % fraction of "noise" templates allowed to span all channel groups (see createChannelMapFile for more info).

load(fullfile(folder,name_map))
ops.NchanTOT            = length(connected); % total number of channels

ops.Nchan = sum(connected>1e-6); % number of active channels
		
ops.Nfilt = ops.Nchan*templatemultiplier - mod(ops.Nchan*templatemultiplier,32); % number of filters to use (2-4 times more than Nchan, should be a multiple of 32)

ops.nt0 = round(1.6*ops.fs/1000); % window width in samples. 1.6ms at 20kH corresponds to 32 samples

ops.nNeighPC            = min([16 ops.Nchan]);  % visualization only (Phy): number of channnels to mask the PCs, leave empty to skip (12)		
ops.nNeigh              = min([16 ops.Nchan]);  % visualization only (Phy): number of neighboring templates to retain projections of (16)		
		
% options for channel whitening		
ops.whitening           = 'full';              % type of whitening (default 'full', for 'noSpikes' set options for spike detection below)		
ops.nSkipCov            = 1;                   % compute whitening matrix from every N-th batch (1)		
ops.whiteningRange      = whiteningRange;       % how many channels to whiten together (Inf for whole probe whitening, should be fine if Nchan<=32)		
		
% define the channel map as a filename (string) or simply an array		
ops.chanMap             = fullfile(folder, name_map); % make this file using createChannelMapFile.m		
ops.criterionNoiseChannels = 0.2; % fraction of "noise" templates allowed to span all channel groups (see createChannelMapFile for more info). 		
		
% other options for controlling the model and optimization		
ops.Nrank               = 3;        % matrix rank of spike template model (3)		
ops.nfullpasses         = 6;        % number of complete passes through data during optimization (6)		
ops.maxFR               = 20000;    % maximum number of spikes to extract per batch (20000)		
ops.fshigh              = 500;      % frequency for high pass filtering		
% ops.fslow             = 8000;     % frequency for low pass filtering (optional)
ops.ntbuff              = 64;       % samples of symmetrical buffer for whitening and spike detection		
ops.scaleproc           = 200;      % int16 scaling of whitened data		
ops.NT                  = 32*1024+ ops.ntbuff;  % this is the batch size (try decreasing if out of memory) 		
% for GPU should be multiple of 32 + ntbuff		
		
% the following options can improve/deteriorate results. 		
% when multiple values are provided for an option, the first two are beginning and ending anneal values, 		
% the third is the value used in the final pass. 		
ops.Th               = [6 10 10];       % threshold for detecting spikes on template-filtered data ([6 12 12])		
ops.lam              = [12 40 40];       % large meoooans amplitudes are forced around the mean ([10 30 30])		
ops.nannealpasses    = 4;               % should be less than nfullpasses (4)		
ops.momentum         = 1./[20 400];     % start with high momentum and anneal (1./[20 1000])		
ops.shuffle_clusters = 1;               % allow merges and splits during optimization (1)		
ops.mergeT           = .1;              % upper threshold for merging (.1)		
ops.splitT           = .1;              % lower threshold for splitting (.1)		
		
% options for initializing spikes from data		
ops.initialize      = 'fromData';   %'fromData' or 'no'		
ops.spkTh           = -6;      % spike threshold in standard deviations (4)		
ops.loc_range       = [3  1];  % ranges to detect peaks; plus/minus in time and channel ([3 1])		
ops.long_range      = [30  6]; % ranges to detect isolated peaks ([30 6])		
ops.maskMaxChannels = 5;       % how many channels to mask up/down ([5])		
ops.crit            = .65;     % upper criterion for discarding spike repeates (0.65)		
ops.nFiltMax        = 10000;   % maximum "unique" spikes to consider (10000)		
		
% load predefined principal components (visualization only (Phy): used for features)		
dd                  = load(fullfile(dropbox, '/Kteam/PrgMatlab/KiloSort/configFiles/PCspikes2.mat')); % you might want to recompute this from your own data
%dd                  = load(fullfile('Dropbox/Kteam/PrgMatlab/KiloSort/configFiles/PCspikes2.mat')); % you might want to recompute this from your own data
%TODO use mfilename('fullpath')
ops.wPCA            = dd.Wi(:,1:7);   % PCs 		
		
% options for posthoc merges (under construction)		
ops.fracse  = 0.1; % binning step along discriminant axis for posthoc merges (in units of sd)		
ops.epu     = Inf;		
		
ops.ForceMaxRAMforDat   = 30e9; % maximum RAM the algorithm will try to use; on Windows it will autodetect.

% Saving xml content to ops strucuture
ops.xml = xml;

% Specify if the output should be exported to Phy and/or Neurosuite
ops.export.phy = 0;
ops.export.neurosuite = 1;


end
