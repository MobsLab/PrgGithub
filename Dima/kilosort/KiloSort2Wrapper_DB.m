function savepath = KiloSort2Wrapper_DB(varargin)
% Creates channel map from Neuroscope xml files, runs KiloSort and
% writes output data to Neurosuite format or Phy.
% 
% USAGE
%
% KiloSortWrapper
% Run from data folder. File basenames must be the
% same as the name as current folder
%
% KiloSortWrapper(varargin)
% Check varargin description below when input parameters are parsed
%
% Dependencies:  KiloSort (https://github.com/cortex-lab/KiloSort)
% 
% Copyright (C) 2016 Brendon Watson and the Buzsakilab
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.


% Changed for Kilosort2 by Dmitri Bryzgalov in Jan 2020

tic

disp('Running Kilosort2 spike sorting with the Buzsaki lab wrapper')

%% Remove undesired path
rmpath(genpath([dropbox,'/Kteam/PrgMatlab/MuTE_onlineVersion/']));
rmpath(genpath([dropbox,'/Kteam/PrgMatlab/mvgc_v1.0/utils/legacy/rng/']));

%% Parsing inputs
p = inputParser;
basepath = cd;
cd(basepath)
try
    FilesList = dir(fullfile(pwd, '**', '*.cat.evt'));
    basename = FilesList.name;
catch
    basename = [];
end

addParameter(p,'basepath',basepath,@ischar)         % path to the folder containing the data
addParameter(p,'basename',basename,@ischar)         % file basenames (of the dat and xml files)
addParameter(p,'GPU_id',1,@isnumeric)               % Specify the GPU_id
addParameter(p,'SSD_path',[],@ischar)    % Path to SSD disk. Make it empty to disable SSD
addParameter(p,'CreateSubdirectory',1,@isnumeric)   % Puts the Kilosort output into a subfolder
addParameter(p,'performAutoCluster',0,@isnumeric)   % Performs PhyAutoCluster once Kilosort is complete when exporting to Phy
addParameter(p,'config','',@ischar)                 % Specify a configuration file to use from the ConfigurationFiles folder. e.g. 'Omid'
addParameter(p,'nmouse','882',@ischar)                 % Number of mouse - used to create a channel map (script should be created before) - % Changed by Dima Bryzgalov 25/04/2019

parse(p,varargin{:})

basepath = p.Results.basepath;
basename = p.Results.basename;
GPU_id = p.Results.GPU_id;
SSD_path = p.Results.SSD_path;
CreateSubdirectory = p.Results.CreateSubdirectory;
performAutoCluster = p.Results.performAutoCluster;
config = p.Results.config;
nmouse = p.Results.nmouse; % default



%% Checking if dat and xml files exist
if ~exist(fullfile(basepath,[basename,'.xml']))
    warning('KilosortWrapper  %s.xml file not in path %s',basename,basepath);
    return
elseif ~exist(fullfile(basepath,[basename,'.dat']))
    warning('KilosortWrapper  %s.dat file not in path %s',basename,basepath)
    return
end

%% Creates a channel map file
disp('Creating ChannelMapFile')
% createChannelMapFile_KSW(basepath,basename,'staggered');
eval(['[nb_groups, name_map] = channelmap_Mouse' nmouse '(basepath);']) % which channel map?

%% Loading configurations
% XMLFilePath = fullfile(basepath, [basename '.xml']);
% 
% if isempty(config)
%     disp('Running Kilosort with standard settings')
%     ops = KilosortConfiguration(XMLFilePath);
% else
%     disp('Running Kilosort with user specific settings')
%     config_string = str2func(['KiloSortConfiguration_' config_version]);
%     ops = config_string(XMLFilePath);
%     clear config_string;
% end

%create config file
ops = MakeConfigKS2_Mouse([basename '.dat'], basepath, 'TMult', 8, 'whiteningRange',8, 'ChanMapFile', name_map,'GPU_id',GPU_id);

%% % Checks SSD location for sufficient space
if isdir(SSD_path)
    FileObj = java.io.File(SSD_path);
    free_bytes = FileObj.getFreeSpace;
    dat_file = dir(fullfile(basepath,[basename,'.dat']));
    if dat_file.bytes*1.1<FileObj.getFreeSpace
        disp('Creating a temporary dat file on the SSD drive')
        ops.fproc = fullfile(SSD_path, [basename,'_temp_wh.dat']);
    else
        warning('Not sufficient space on SSD drive. Creating local dat file instead')
        ops.fproc = fullfile(basepath,'temp_wh.dat');
    end
else
    ops.fproc = fullfile(basepath,'temp_wh.dat');
end

%%
if ops.GPU
    disp('Initializing GPU')
    gpudev = gpuDevice(GPU_id); % initialize GPU (will erase any existing GPU arrays)
end
% if strcmp(ops.datatype , 'openEphys')
%    ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
% end

%% Lauches KiloSort2
disp('Running Kilosort2 pipeline')
disp('PreprocessingData')
% preprocess data to create temp_wh.dat
rez = preprocessDataSub(ops);
%
% NEW STEP TO DO DATA REGISTRATION
rez = datashift2(rez, 1); % last input is for shifting data

% ORDER OF BATCHES IS NOW RANDOM, controlled by random number generator
iseed = 1;
                 
% main tracking and template matching algorithm
rez = learnAndSolve8b(rez, iseed);

% OPTIONAL: remove double-counted spikes - solves issue in which individual spikes are assigned to multiple templates.
% See issue 29: https://github.com/MouseLand/Kilosort/issues/29
%rez = remove_ks2_duplicate_spikes(rez);

% final merges
rez = find_merges(rez, 1);

% final splits by SVD
rez = splitAllClusters(rez, 1);

% decide on cutoff
rez = set_cutoff(rez);
% eliminate widely spread waveforms (likely noise)
rez.good = get_good_units(rez);

fprintf('found %d good units \n', sum(rez.good>0))

% write to Phy
fprintf('Saving results to Phy  \n')
if CreateSubdirectory
    timestamp = ['Kilosort_' datestr(clock,'yyyy-mm-dd_HHMMSS')];
    savepath = fullfile(basepath, timestamp);
    mkdir(savepath);
    copyfile([basename '.xml'],savepath);
else
    savepath = fullfile(basepath);
end
rez.ops.basepath = basepath;
rez.ops.basename = basename;
rez.ops.savepath = savepath;
disp('Saving phy files')
rezToPhy(rez, savepath);

%% if you want to save the results to a Matlab file...

% discard features in final rez file (too slow to save)
rez.cProj = [];
rez.cProjPC = [];

% final time sorting of spikes, for apps that use st3 directly
[~, isort]   = sortrows(rez.st3);
rez.st3      = rez.st3(isort, :);

% Ensure all GPU arrays are transferred to CPU side before saving to .mat
rez_fields = fieldnames(rez);
for i = 1:numel(rez_fields)
    field_name = rez_fields{i};
    if(isa(rez.(field_name), 'gpuArray'))
        rez.(field_name) = gather(rez.(field_name));
    end
end

% save final results as rez2
fprintf('Saving final results in rez2  \n')
fname = fullfile(savepath, 'rez2.mat');
save(fname, 'rez', '-v7.3');

%% export Neurosuite files
if ops.export.neurosuite
    disp('Converting to Klusters format')
    load(fullfile(fullfile(basepath, timestamp),  'rez2.mat'));
    rez.ops.root = pwd;
    clustering_path = pwd;
    basename = rez.ops.basename;
    rez.ops.fbinary = fullfile(pwd, [basename,'.dat']);
    Kilosort2Neurosuite(rez)
    
end

%% Remove temporary file and resetting GPU
delete(ops.fproc);
if ops.GPU
%     reset(gpudev)
    gpuDevice([])
end
disp('Kilosort2 Processing complete')

%% Get the removed path back
addpath(genpath( [dropbox,'/Kteam/PrgMatlab/MuTE_onlineVersion/']))

toc