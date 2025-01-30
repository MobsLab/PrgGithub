% ProcessPhyNpyDataTetrode - process results from phy GUI (NPY files)
%
%  USAGE
%
%    [spike_times, spike_clusters] = ProcessPhyNpyDataTetrode(folder, filename,tetrode)
%
%    folder             spike file name (either .clu or .res)
%    filename           name of the .dat file of the record
%    tetrode            tetrode number
%
%  OUTPUT
%
%    spike_times        timestamps of the spikes
%    spike_clusters     cluster of the spikes
%
%  SEE
%
%


function [S, tetrodeChannels, TT, cellnames, W] = ProcessPhyNpyDataTetrode(folder,filename, tetrode)

%params
nb_points_waveform = 32;
folder_spike = fullfile(folder, 'Spikes');


%% read cluster.csv
csv_clusters = tdfread(fullfile(folder_spike,'cluster_groups.csv'),'\t');
for i=1:size(csv_clusters.group,1)
    csv_group{i} = strtrim(csv_clusters.group(i,:));
end
noise_clusters = csv_clusters.cluster_id(strcmpi(csv_group,'noise'));
mua_clusters = csv_clusters.cluster_id(strcmpi(csv_group,'mua'));
good_clusters = csv_clusters.cluster_id(strcmpi(csv_group,'good')|strcmpi(csv_group,'unsorted'));


%% load data
spike_times     = double(readNPY(fullfile(folder_spike,'spike_times.npy')));
spike_clusters  = double(readNPY(fullfile(folder_spike,'spike_clusters.npy')));
spike_templates = double(readNPY(fullfile(folder_spike,'spike_templates.npy')));
templates       = double(readNPY(fullfile(folder_spike,'templates.npy')));
pc_feature_ind  = double(readNPY(fullfile(folder_spike,'pc_feature_ind.npy')));
pc_features     = double(readNPY(fullfile(folder_spike,'pc_features.npy')));
channel_map     = double(readNPY(fullfile(folder_spike,'channel_map.npy')));


%% select tetrode in templates
load(fullfile(folder, 'chanMap.mat'),'tetrodes')
tetrode_channels = tetrodes{tetrode};

%templates of tetrode
idx_templates = IsmemberTetrodeTemplatesPhy(tetrode_channels, pc_feature_ind, channel_map);
new_pc_feature_ind  = pc_feature_ind(idx_templates);

%spikes of tetrode
idx_spikes = ismember(spike_templates,find(idx_templates));

new_spike_clusters  = spike_clusters(idx_spikes);
new_spike_times     = spike_times(idx_spikes);
new_spike_templates = spike_templates(idx_spikes);
good_clusters       = intersect(good_clusters,unique(new_spike_clusters));
new_pc_features     = pc_features(idx_spikes,:,:);


%% new cluster number
%we only keep good clusters; mua is cluster 1 and noise is cluster 0
temp = new_spike_clusters;
for i=1:length(good_clusters)
   temp(new_spike_clusters==good_clusters(i))=i+1;
end
temp(ismember(new_spike_clusters, noise_clusters))=0;
temp(ismember(new_spike_clusters, mua_clusters))=1;
new_spike_clusters = temp;

list_clusters = unique(new_spike_clusters);
list_clusters(list_clusters==0)=[];
nb_clusters = length(list_clusters);


%% create SpîkeData and MeanWaveform.mat 

%tetrodeChannels
tetrodeChannels = tetrode_channels;

%S, TT and cellnames
TT = cell(0);
cellnames = cell(0);

ts_spike_times = new_spike_times / 2; %in 1E-4s, because fs=20kHz
for clu=1:length(list_clusters)
    a = ts_spike_times(new_spike_clusters==list_clusters(clu));
    S{clu} = tsd(a,a);
    
    TT{clu} = [tetrode, list_clusters(clu)];
    cellnames{clu} = ['TT' num2str(tetrode) 'c' num2str(list_clusters(clu))];
end


%W
W=cell(0);
for clu=1:length(list_clusters)
    
    ind = unique(new_spike_templates(new_spike_clusters==list_clusters(clu))); %ind can contain several elements, and be null
    templ = squeeze(templates(ind(1)+1,:,:)); %add 1 and choose first elements
        
    %from n points to nb_points_waveform
    x = linspace(0, 1, size(templ,1));
    new_points = linspace(0, 1, nb_points_waveform);
    W{clu} = interp1(x,templ,new_points,'spline')';    
end


%% clu, res, spk and fet
load(fullfile(folder,'chanMap.mat'), 'chanMap')
nchannels = length(chanMap);
GenerateNeurosuiteSpikes(folder,filename, nchannels,  tetrode_channels, tetrode, new_spike_times, new_spike_clusters, new_pc_features, new_pc_feature_ind)


end









