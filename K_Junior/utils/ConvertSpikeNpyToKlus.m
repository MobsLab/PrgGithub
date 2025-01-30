% ConvertSpikeNpyToKlus - Convert results from phy GUI (npy) to .res and .clu files
%
%  USAGE
%
%    [times, group] = ConvertSpikeNpyToKlus(directory, toWrite)
%
%    directory              spike file name (either .clu or .res)
%    toWrite (optional)     1 create .res and .clu file, 0 otherwise
%                           (default 0)
%
%  OUTPUT
%
%    The output is a list of (timestamp,group) t-uples.
%
%  SEE
%
%

%directory = '/media/mobsjunior/Data2/DataMobs/BreathDeltaFeedback/Mice-403-451/20161212/Mouse403/SpikeSorting/Breath-Mouse-403-12122016/Breath-Mouse-403-12122016-merged.GUI';

function [spike_times, spike_clusters] = ConvertSpikeNpyToKlus(directory,filename)

%params
nb_points_waveform = 32;

%go to folder
cd(directory)


%% read cluster.csv
csv_clusters = tdfread('cluster_groups.csv','\t');
for i=1:size(csv_clusters.group,1)
    csv_group{i} = strtrim(csv_clusters.group(i,:));
end
noise_clusters = find(strcmpi(csv_group,'noise'));
mua_clusters = find(strcmpi(csv_group,'mua'));
good_clusters = find(strcmpi(csv_group,'good'));


%% load data
templates = double(readNPY('templates.npy'));
spike_times = double(readNPY('spike_times.npy'));
spike_clusters = double(readNPY('spike_clusters.npy'));
spike_templates = double(readNPY('spike_templates.npy'));

try
    templates_ind = double(readNPY('templates_ind.npy'));
catch
    templates_ind = zeros(size(templates,1),size(templates,3));
    for t=1:size(templates,1)
        templ = squeeze(templates(t,:,:));
        idx = find(any(templ,1))-1;
        templates_ind(t,1:length(idx))=idx;
    end
    templates_ind(:,~any(templates_ind))=[];
end

templates = templates(good_clusters,:,:);
templates_ind = templates_ind(good_clusters,:);

spike_times = spike_times(ismember(spike_clusters, good_clusters));
spike_clusters = spike_clusters(ismember(spike_templates, good_clusters));
spike_templates = spike_templates(ismember(spike_templates, good_clusters));

for i=1:length(good_clusters)
   spike_clusters(spike_clusters==good_clusters(i))=i;
   spike_templates(spike_templates==good_clusters(i))=i;
end


%% create MeanWaveform.mat
%W
for i=1:length(templates_ind)
    templ = squeeze(templates(i,:,:));
    templ = templ(:,any(templ));
    
    %from n points to nb_points_waveform
    x = linspace(0, 1, size(templ,1));
    new_points = linspace(0, 1, nb_points_waveform);
    W{i} = interp1(x,templ,new_points,'spline')';    
end

%cellnames
tetrodes = unique(templates_ind,'rows');
[~,idx] = sort(tetrodes(:,1));
tetrodes = tetrodes(idx,:);

nb_channels = zeros(1,size(tetrodes,1));
for t=1:size(tetrodes,1)
    id = 0;
    for i=1:length(templates_ind)
        if templates_ind(i,:)==tetrodes(t,:);
            id=id+1;
            cellnames{i} = ['TT' num2str(t) 'c' num2str(id)];
            nb_channels(t) = size(W{i},1);
            templates_tetrode(i) = t;
        end
    end
end


%% SpikeData

%tetrodeChannels
for t=1:size(tetrodes,1)
    tetrodeChannels{t} = tetrodes(t,1:nb_channels(t));
end

%S
ts_spike_times = spike_times / 2; %in 1E-4s
for clu=1:length(good_clusters)
    a = ts_spike_times(spike_clusters==clu);
    S{clu} = tsd(a,a);
end
S=tsdArray(S);



%% save
save Waveforms W cellnames
save SpikeData S cellnames tetrodeChannels


%% Write into .res and .clu
if exist('filename','var')
    fileOut_name = strsplit(filename,'.');
    fileOut_name = fileOut_name{1};
        
    for t=1:size(tetrodes,1)
        %files out
        fileOut_res = fopen([fileOut_name '.res.' num2str(t)], 'wt');
        fileOut_clu = fopen([fileOut_name '.clu.' num2str(t)], 'wt');
        
        %data
        tetrode_clusters = find(templates_tetrode==t);
        times = spike_times(ismember(spike_clusters,tetrode_clusters));
        group = spike_clusters(ismember(spike_clusters,tetrode_clusters));
        
        new_groups = unique(group);
        for ng=1:length(new_groups)
            group(group==new_groups(ng))=ng+1; 
        end
        
        %write
        fprintf(fileOut_clu,'%d\n',max(group));
        fprintf(fileOut_res,'%d\n',times);
        fprintf(fileOut_clu,'%d\n',group);
        fclose(fileOut_res); 
        fclose(fileOut_clu);
    end
end


end









