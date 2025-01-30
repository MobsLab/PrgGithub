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

folder_tetrode = fullfile(folder, 'Spikes', ['tetrode' num2str(tetrode)]);


%% read cluster.csv
csv_clusters = tdfread(fullfile(folder_tetrode,'cluster_groups.csv'),'\t');
for i=1:size(csv_clusters.group,1)
    csv_group{i} = strtrim(csv_clusters.group(i,:));
end
noise_clusters = csv_clusters.cluster_id(strcmpi(csv_group,'noise'));
mua_clusters = csv_clusters.cluster_id(strcmpi(csv_group,'mua'));
good_clusters = csv_clusters.cluster_id(strcmpi(csv_group,'good')|strcmpi(csv_group,'unsorted'));


%% load data
spike_times = double(readNPY(fullfile(folder_tetrode,'spike_times.npy')));
spike_clusters = double(readNPY(fullfile(folder_tetrode,'spike_clusters.npy')));
spike_templates = double(readNPY(fullfile(folder_tetrode,'spike_templates.npy')));
templates = double(readNPY(fullfile(folder_tetrode,'templates.npy')));
templates_ind = double(readNPY(fullfile(folder_tetrode,'templates_ind.npy')));


%% new cluster number
%we only keep good clusters; mua is cluster 1 and noise is cluster 0
new_spike_clusters = spike_clusters;
for i=1:length(good_clusters)
   new_spike_clusters(spike_clusters==good_clusters(i))=i+1;   
end
new_spike_clusters(ismember(spike_clusters, noise_clusters))=0;
new_spike_clusters(ismember(spike_clusters, mua_clusters))=1;

list_clusters = unique(new_spike_clusters);
list_clusters(list_clusters==0)=[];
nb_clusters = length(list_clusters);

%% create SpîkeData and MeanWaveform.mat 

%tetrodeChannels
tetrodeChannels = templates_ind(1,:);

%S, TT and cellnames
TT = cell(0);
cellnames = cell(0);

ts_spike_times = spike_times / 2; %in 1E-4s
for clu=1:length(list_clusters)
    a = ts_spike_times(spike_clusters==list_clusters(clu));
    S{clu} = tsd(a,a);
    
    TT{clu} = [tetrode, list_clusters(clu)];
    cellnames{clu} = ['TT' num2str(tetrode) 'c' num2str(list_clusters(clu))];
end


%W
W=cell(0);
for clu=1:length(list_clusters)
    
    ind = unique(spike_templates(new_spike_clusters==list_clusters(clu))); %ind can contain several elements, and be null
    templ = squeeze(templates(ind(1)+1,:,:)); %add 1 and choose first elements
        
    %from n points to nb_points_waveform
    x = linspace(0, 1, size(templ,1));
    new_points = linspace(0, 1, nb_points_waveform);
    W{clu} = interp1(x,templ,new_points,'spline')';    
end


%% Write into .res and .clu
fileOut_name = strsplit(filename,'.');
fileOut_name = fullfile(folder,fileOut_name{1});

%files out
fileOut_res = fopen([fileOut_name '.res.' num2str(tetrode)], 'wt');
fileOut_clu = fopen([fileOut_name '.clu.' num2str(tetrode)], 'wt');

%data
times = spike_times;
group = new_spike_clusters;

%write
fprintf(fileOut_clu,'%d\n',nb_clusters);
fprintf(fileOut_res,'%d\n',times);
fprintf(fileOut_clu,'%d\n',group);
fclose(fileOut_res); 
fclose(fileOut_clu);


end









