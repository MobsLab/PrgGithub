% GenerateNeurosuiteSpikes - create clu, res, spk and fet
%
%  USAGE
%
%    GenerateNeurosuiteSpikes(folder,filename, nchannels,  tetrode_channels, tetrode_number, spike_times, spike_clusters)
%
%    folder             spike file name (either .clu or .res)
%    filename           name of the .dat file of the record
%    nchannels          number of channels in the dat
%    tetrode_channels   channel of the tetrode
%    tetrode_number     number of the tetrode
%    spike_times        timestamps of the spikes
%    spike_times        timestamps of the spikes
%
%
%
%  SEE
%
%


function GenerateNeurosuiteSpikes(folder,filename, nchannels,  tetrode_channels, tetrode_number, spike_times, spike_clusters, pc_features, pc_feature_ind)

%% params 
sbefore = 14;%samples before/after for spike extraction
safter  = 18;%... could read from SpkGroups in xml
nElec = length(tetrode_channels);

%filenames
mkdir(fullfile(folder,'phytoneurosuite'));
fileOut_name = strsplit(filename,'.');
file_name = fullfile(folder ,fileOut_name{1});
fileOut_name = fullfile(fullfile(folder,'phytoneurosuite') ,fileOut_name{1});

spkname = [fileOut_name '.spk.' num2str(tetrode_number)];
fetname = [fileOut_name '.fet.' num2str(tetrode_number)];
resname = [fileOut_name '.res.' num2str(tetrode_number)];
cluname = [fileOut_name '.clu.' num2str(tetrode_number)];




%% spk
dat = memmapfile([file_name '.fil'],'Format','int16');
dat = reshape(dat.Data,nchannels,[]);
dat = dat(tetrode_channels+1,:);

tsampsperwave   = (sbefore+safter);
valsperwave     = tsampsperwave * nElec;

wvranges        = zeros(length(spike_times),1);
wvpowers        = zeros(1,length(spike_times));
fid         = fopen(spkname,'w'); 
    
for j=1:length(spike_times)
    try       
        wvforms = dat(:,spike_times(j)-sbefore+1:spike_times(j)+safter);        
        wvforms = wvforms - repmat(median(wvforms')',1,sbefore+safter);
        wvforms = wvforms(:);
    catch
        disp('Error extracting spikes');
        wvforms = zeros(valsperwave,1);
    end
    fwrite(fid,wvforms,'int16');

    %some processing for fet file
    wvaswv = reshape(wvforms,tsampsperwave,nElec);
    wvranges(j) = max(range(wvaswv));
    wvpowers(j) = mean(sqrt(sum(wvaswv.^2)));

    if rem(j,100000) == 0
        disp([num2str(j) ' out of ' num2str(length(spike_times)) ' done'])
    end
end
fclose(fid);
clear fid dat

wvranges = wvranges';


%% fet

% for each template, rearrange the channels to reflect the shank order
tdx = [];
for tn = 1:length(unique(spike_clusters))
    tTempPCOrder = pc_feature_ind(tn,:); % channel sequence used for pc storage for this template
    for k = 1:length(tetrode_channels)
        i = find(tTempPCOrder==tetrode_channels(k));
        if ~isempty(i)
            tdx(tn,k) = i;
        else
            tdx(tn,k) = nan;
        end
    end
end

% initialize fet file
fets    = zeros(length(spike_clusters),size(pc_features,2),nElec);

%for each cluster/template id, grab at once all spikes in that group
%and rearrange their features to match the shank order
allshankclu = unique(spike_clusters);

for tc = 1:length(allshankclu)
    tsc     = allshankclu(tc);
    cluIx   = find(spike_clusters==tsc);
    tforig  = pc_features(cluIx,:,:);%the subset of spikes with this clu ide
    tfnew   = tforig; %will overwrite

    ii      = tdx(tc,:);%handling nan cases where the template channel used was not in the shank
    gixs    = ~isnan(ii);%good vs bad channels... those shank channels that were vs were not found in template pc channels
    bixs    = isnan(ii);
    g       = ii(gixs);

    tfnew(:,:,gixs) = tforig(:,:,g);%replace ok elements
    tfnew(:,:,bixs) = 0;%zero out channels that are not on this shank
    try
        fets(cluIx,:,:) = tfnew(:,:,1:nElec);
    catch
        keyboard
    end
end
%extract for relevant spikes only...
% and heurstically on d3 only take fets for one channel for each original channel in shank... even though kilosort pulls 12 channels of fet data regardless
tfet1 = squeeze(fets(:,1,1:nElec));%lazy reshaping
tfet2 = squeeze(fets(:,2,1:nElec));
tfet3 = squeeze(fets(:,3,1:nElec));
fets = cat(2,tfet1,tfet2,tfet3)';%     fets = h5read(tkwx,['/channel_groups/' num2str(shank) '/features_masks']);

%mean activity per spike
wvpowers = round(32*zscore(wvpowers));
wvranges = round(32*zscore(wvranges));
fets = cat(1,double(fets),double(wvpowers),double(wvranges),double(spike_times'));
fets = fets';

%write
SaveFetIn(fetname,fets);


%% generate .res and .clu
%files out
fileOut_res = fopen(resname, 'wt');
fileOut_clu = fopen(cluname, 'wt');

nb_clusters = sum(unique(spike_clusters)>0);

%write
fprintf(fileOut_res,'%d\n',spike_times);

fprintf(fileOut_clu,'%d\n',nb_clusters);
fprintf(fileOut_clu,'%d\n',spike_clusters);
fclose(fileOut_res); 
fclose(fileOut_clu);


end


function SaveFetIn(FileName, Fet, BufSize)

if nargin<3 || isempty(BufSize)
    BufSize = inf;
end

nFeatures = size(Fet, 2);
formatstring = '%d';
for ii=2:nFeatures
  formatstring = [formatstring,'\t%d'];
end
formatstring = [formatstring,'\n'];

outputfile = fopen(FileName,'w');
fprintf(outputfile, '%d\n', nFeatures);

if isinf(BufSize)
  
  temp = [round(100* Fet(:,1:end-1)) round(Fet(:,end))];
    fprintf(outputfile,formatstring,temp');
else
    nBuf = floor(size(Fet,1)/BufSize)+1;
    
    for i=1:nBuf 
        BufInd = [(i-1)*nBuf+1:min(i*nBuf,size(Fet,1))];
        temp = [round(100* Fet(BufInd,1:end-1)) round(Fet(BufInd,end))];
        fprintf(outputfile,formatstring,temp');
    end
end
fclose(outputfile);
end
