function savepath = KiloSortWrapper3_DB(varargin)
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

tic

disp('Running Kilosort3 spike sorting with the Buzsaki lab wrapper')

%% Remove undesired path
rmpath(genpath([dropbox,'/Kteam/PrgMatlab/MuTE_onlineVersion/']));

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
addParameter(p,'CreateSubdirectory',1,@isnumeric)   % Puts the Kilosort output into a subfolder
addParameter(p,'nmouse','081',@ischar) % Number of mouse - used to create a channel map (script should be created before) - % Changed by Dima Bryzgalov 25/04/2019

parse(p,varargin{:})

basepath = p.Results.basepath;
basename = p.Results.basename;
GPU_id = p.Results.GPU_id;
CreateSubdirectory = p.Results.CreateSubdirectory;
nmouse = p.Results.nmouse; % default

%% Checking if dat and xml files exist
if ~exist(fullfile(basepath,[basename,'.xml']))
    error('KilosortWrapper  %s.xml file not in path %s',basename,basepath);
elseif ~exist(fullfile(basepath,[basename,'.dat']))
    error('KilosortWrapper  %s.dat file not in path %s',basename,basepath)
end

%% Creates a channel map file
disp('Creating ChannelMapFile')
eval(['[nb_groups, name_map] = channelmap_Mouse' nmouse '(basepath);']) % which channel map?

%% Loading configurations
%create config file
ops = MakeConfigKS_Mouse_kilosort3([basename '.dat'], basepath, 'ChanMapFile', name_map);

%% Add more parameters
ops.trange = [0 Inf]; % time range to sort
ops.fproc = fullfile(basepath,'temp_wh.dat');

%% Load channel map
fs = dir(fullfile(basepath, 'chanMap_*.mat'));
if ~isempty(fs)
    ops.chanMap = fullfile(basepath, fs(1).name);
else
    error('No chan Map file!')
end
load(fullfile(basepath,fs(1).name));

ops.NchanTOT  = length(connected); % total number of channels
ops.Nchan = sum(~connected); % number of active channels

%%
if ops.GPU
    disp('Initializing GPU')
    gpudev = gpuDevice(GPU_id); % initialize GPU (will erase any existing GPU arrays)
end
if strcmp(ops.datatype , 'openEphys')
   ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
end

%% Lauches KiloSort3
disp('Running Kilosort pipeline')
disp('PreprocessingData')

rez = preprocessDataSub(ops); % preprocess data and extract spikes for initialization
rez = datashift2(rez, 1);

[rez, st3, tF] = extract_spikes(rez);

rez = template_learning(rez, tF, st3);

[rez, st3, tF] = trackAndSort(rez);

rez = final_clustering(rez, tF, st3);

rez = find_merges(rez, 1);

% %% Here we try to improve quality (remove if bad)
% % final splits by SVD
% rez = splitAllClusters(rez, 1);
% 
% % decide on cutoff
% rez = set_cutoff(rez);
% % eliminate widely spread waveforms (likely noise)
% rez.good = get_good_units(rez);
% 
% fprintf('found %d good units \n', sum(rez.good>0))

%% save matlab results file

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
disp('Saving rez file')
% rez = merge_posthoc2(rez);
save(fullfile(savepath,  'rez.mat'), 'rez', '-v7.3');

%% export python results file for Phy
if ops.export.phy
    disp('Converting to Phy format')
    rezToPhy2(rez, savepath);
end

%% export Neurosuite files
if ops.export.neurosuite
    disp('Converting to Klusters format')
    load(fullfile(savepath,  'rez.mat'))
    rez.ops.root = pwd;
    clustering_path = pwd;
    basename = rez.ops.basename;
%     rez.ops.fbinary = fullfile(pwd, [basename,'.dat']);
    
    writeNPY(rez.ops.kcoords, fullfile(clustering_path, 'channel_shanks.npy'));

%     phy_export_units(clustering_path,basename);
end

%% Remove temporary file and resetting GPU
delete(ops.fproc);
if ops.GPU
    reset(gpudev)
    gpuDevice([])
end
disp('Kilosort Processing complete')

%% Get the removed path back
addpath(genpath( [dropbox,'/Kteam/PrgMatlab/MuTE_onlineVersion/']))

toc