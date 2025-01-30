
% MakeConfigKS_Mouse_kilosort three
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


function ops = MakeConfigKS_Mouse_kilosort3(filename, folder, varargin)
%
% Modified from the function of Adrien Peyrache (github.com/PeyracheLab/KilosortWrapper)
% by Dima Bryzgalov (github.com/bryzgalovdm), MOBS team, Paris, France
%

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
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

%check if exist and assign default value if noted
if ~exist('whiteningRange','var')
    whiteningRange = 32;
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

%% CONFIG

ops.GPU                 = gpu_id; % whether to run this code on an Nvidia GPU (much faster, mexGPUall first)		

ops.datatype            = 'dat';  % binary ('dat', 'bin') or 'openEphys'		
ops.fbinary             = fullfile(folder, filename);	
ops.fproc               = fullfile(folder, 'temp_wh.dat'); % residual from RAM of preprocessed data	
ops.fs                  = 20000; % Sampling rate

% define the channel map as a filename (string) or simply an array		
ops.chanMap             = fullfile(folder, name_map); % make this file using createChannelMapFile.m		
		
ops.nt0 = round(1.6*ops.fs/1000); % window width in samples. 1.6ms at 20kH corresponds to 32 samples

% ops.nNeighPC            = min([16 ops.Nchan]);  % visualization only (Phy): number of channnels to mask the PCs, leave empty to skip (12)		
% ops.nNeigh              = min([16 ops.Nchan]);  % visualization only (Phy): number of neighboring templates to retain projections of (16)		
		
% frequency for high pass filtering (150)
ops.fshigh = 300;   

% threshold on projections (like in Kilosort1, can be different for last pass like [10 4])
ops.Th = [10 4];  

% how important is the amplitude penalty (like in Kilosort1, 0 means not used, 10 is average, 50 is a lot) 
ops.lam = 10;  

% splitting a cluster at the end requires at least this much isolation for each sub-cluster (max = 1)
ops.AUCsplit = 0.9; 

% minimum spike rate (Hz), if a cluster falls below this for too long it gets removed
ops.minFR = 1/25; 

% number of samples to average over (annealed from first to second value) 
ops.momentum = [20 400]; 

% spatial constant in um for computing residual variance of spike
ops.sigmaMask = 30; 

% threshold crossings for pre-clustering (in PCA projection space)
ops.ThPre = 8; 

% spatial scale for datashift kernel
ops.sig = 20;

% type of data shifting (0 = none, 1 = rigid, 2 = nonrigid)
ops.nblocks = 0;


%% danger, changing these settings can lead to fatal errors
% options for determining PCs
ops.spkTh           = -6;      % spike threshold in standard deviations (-6)
ops.reorder         = 1;       % whether to reorder batches for drift correction. 
ops.nskip           = 25;  % how many batches to skip for determining spike PCs

ops.GPU                 = 1; % has to be 1, no CPU version yet, sorry
% ops.Nfilt               = 1024; % max number of clusters
ops.nfilt_factor        = 4; % max number of clusters per good channel (even temporary ones)
ops.ntbuff              = 64;    % samples of symmetrical buffer for whitening and spike detection
ops.NT                  = 64*1024+ ops.ntbuff; % must be multiple of 32 + ntbuff. This is the batch size (try decreasing if out of memory). 
ops.whiteningRange      = whiteningRange; % number of channels to use for whitening each channel
ops.nSkipCov            = 25; % compute whitening matrix from every N-th batch
ops.scaleproc           = 200;   % int16 scaling of whitened data
ops.nPCs                = 3; % how many PCs to project the spikes into
ops.useRAM              = 0; % not yet available

%%
ops.ForceMaxRAMforDat   = 30e9; % maximum RAM the algorithm will try to use; on Windows it will autodetect.

% Saving xml content to ops strucuture
ops.xml = xml;

% Specify if the output should be exported to Phy and/or Neurosuite
ops.export.phy = 1;
ops.export.neurosuite = 1;


end
