% ConvertSpikeH5toKlus - Convert results from spyking circus (hdf5) to .res and .clu files
%
%  USAGE
%
%    [times, group] = ConvertSpikeH5toKlus(filename, toWrite)
%
%    filename            spike file name (either .clu or .res)
%    toWrite (optional)  1 create .res and .clu file, 0 otherwise
%                        (default 0)
%
%  OUTPUT
%
%    The output is a list of (timestamp,group) t-uples.
%
%  SEE
%
%

%filename = 'Breath-Mouse-403-05122016.result-merged.hdf5';

function [times, group] = ConvertSpikeH5toKlus(filename, toWrite)

if ~exist('toWrite','var')
    toWrite = 1;
end


info = h5info(filename,'/spiketimes/');
templates_name = {info.Datasets.Name};

s=[];
for t=1:length(templates_name)
    spike_data = double(h5read(filename,['/spiketimes/' templates_name{t} '/']))';
    template_data = [spike_data t*ones(length(spike_data),1)];
    
    if isempty(s)
        s = template_data;
    else
        s = [s ; template_data];
    end
end

[~,idx] = sort(s(:,1));
s = s(idx,:);

times = s(:,1);
group = s(:,2);

%% Write into .res and .clu
if toWrite
    fileOut_name = strsplit(filename,'.');
    fileOut_name = fileOut_name{1};
    
    fileOut_res = fopen([fileOut_name '.res.1'], 'wt');
    fileOut_clu = fopen([fileOut_name '.clu.1'], 'wt');
    fprintf(fileOut_clu,'%d\n',max(group));
    for l=1:length(times)
       fprintf(fileOut_res,'%d\n',times(l));
       fprintf(fileOut_clu,'%d\n',group(l));
    end
    fclose(fileOut_res); 
    fclose(fileOut_clu);
end

end









