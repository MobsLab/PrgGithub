% ProcessKSToNeursuite - process results from phy GUI (NPY files)
%
%  USAGE
%
%    ProcessKSToNeursuite(folder, filename,tetrode)
%
%    folder             spike file name (either .clu or .res)
%    filename           name of the .dat file of the record
%    tetrode            tetrode number
%
%
%  SEE
%
%


function ProcessKSToNeursuite(folder,filename, tetrode, nmouse)

%params
folder_spike = fullfile(folder, 'Spikes_Kilosort');

%% load data
spike_times     = double(readNPY(fullfile(folder_spike,'spike_times.npy')));
spike_clusters  = double(readNPY(fullfile(folder_spike,'spike_clusters.npy')));
spike_templates = double(readNPY(fullfile(folder_spike,'spike_templates.npy')));
pc_feature_ind  = double(readNPY(fullfile(folder_spike,'pc_feature_ind.npy')));
pc_features     = double(readNPY(fullfile(folder_spike,'pc_features.npy')));
channel_map     = double(readNPY(fullfile(folder_spike,'channel_map.npy')));


%% select tetrode in templates
load(fullfile(folder, ['chanMap_M' num2str(nmouse) '.mat']),'groups')
tetrode_channels = groups{tetrode};

%templates of tetrode
idx_templates = IsmemberTetrodeTemplatesPhy(tetrode_channels, pc_feature_ind, channel_map);
new_pc_feature_ind  = pc_feature_ind(idx_templates);

%spikes of tetrode
idx_spikes = ismember(spike_templates,find(idx_templates));
new_spike_clusters  = spike_clusters(idx_spikes);
new_spike_times     = spike_times(idx_spikes);
new_pc_features     = pc_features(idx_spikes,:,:);


%% clu, res, spk and fet
load(fullfile(folder,['chanMap_M' num2str(nmouse) '.mat']), 'chanMap')
nchannels = length(chanMap);
GenerateNeurosuiteSpikes(folder,filename, nchannels,  tetrode_channels, tetrode, new_spike_times, new_spike_clusters, new_pc_features, new_pc_feature_ind)


end









