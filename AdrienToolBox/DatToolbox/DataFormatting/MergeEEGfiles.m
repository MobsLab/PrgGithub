function MergeEEGfiles(processdir)

% This function merges eeg files. It assumes that the xml file 
% fbasename/fbasename.xml containes the field "multiFileProcessing"
% 
% It produces fbasenane/fbasename.eeg. 
% 
% Also creates a DatSegments.txt file in which the length in timestamps
% (should be in 1/1250sec) of the successive files are saved
% From the root directory (in which there is fbasename_merged and
% the fbasename-XX, you can call MErgeEEGfiles(pwd)
%
% Adrien Peyrache 2011

datSegments = [];

[fbasename mergedir rootdir] = extractfbasename(processdir);
rootname = [mergedir filesep fbasename];
eegFname = [rootname '.eeg'];
xmlFname = [rootname '.xml'];

if ~exist(xmlFname,'file')
    error(['XML file ''' xmlfname ''' does not exist'])
end

xmldata = xml_load([rootname '.xml']);
segnames = xmldata.multiFileProcessing.files;
nChannels = str2double(xmldata.acquisitionSystem.nChannels);

disp('Merging EEG files...')
for ii=1:length(segnames)

    fname = segnames(ii).fileBaseName;
    fprintf('%s...\n',fname);
    fname = [fname filesep fname '.eeg'];
  
    if ii==1
        eval(['!cp ' fname ' ' eegFname ';']);
    else
        eval(['!cat ' fname ' >> ' eegFname ';']);
    end
    
    fl = FileLength(fname)/(2*nChannels);
    datSegments = [datSegments;fl];
    
end

fname = [mergedir filesep 'DatSegments.txt'];
dlmwrite(fname,datSegments,'precision','%9d');
