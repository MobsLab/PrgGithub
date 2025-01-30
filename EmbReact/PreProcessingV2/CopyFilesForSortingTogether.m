clear all
% OriginalLocationName = '/media/vador/DataMOBS89/Mouse775/';
% DateOfExperiment = '20180815';
% CopyLocation = '/media/vador/DataMOBS89/Mouse775/20180815/Mouse775_SpikeSortTogether/';
% MouseNum = '775';
% NumberOfSpikeGroups = 3;
% 

% OriginalLocationName = '/media/vador/DataMOBS89/Mouse777/';
% DateOfExperiment = '20180828';
% CopyLocation = '/media/vador/DataMOBS89/Mouse777/20180828/Mouse777_SpikeSortTogether/';
% MouseNum = '777';
% NumberOfSpikeGroups = 3;


OriginalLocationName = '/media/vador/DataMOBS89/Mouse779/';
DateOfExperiment = '20180807';
CopyLocation = '/media/vador/DataMOBS89/Mouse779/20180807/Mouse779_SpikeSortTogether/';
MouseNum = '779';
NumberOfSpikeGroups = 3;


% get all the foldernames
cd(OriginalLocationName)
load('AllFolderNames.mat')
GoodSess=strfind(FolderName,DateOfExperiment);
for f=1:length(FolderName)
    FolderName{f}=[OriginalLocationName,FolderName{f}];
end

% copy the ones for the UMaze day into folder
for g=1:length(GoodSess)
    if not(isempty(GoodSess{g}))
        
        cd(FolderName{g})
        NewFolderName=strrep(FolderName{g}(max(findstr(FolderName{g},'ProjectEmbReact')):end),'/','_');
        
        % the data is copied as .dat so as to be able to concatenate them
        disp(['cp ' NewFolderName '_SpikeRef.fil ' CopyLocation 'M' MouseNum '-' DateOfExperiment '-SpikesAllTogether-' num2str(g,'%02i') '.dat'])
        system(['cp ' NewFolderName '_SpikeRef.fil ' CopyLocation 'M' MouseNum '-' DateOfExperiment '-SpikesAllTogether-' num2str(g,'%02i') '.dat']) 
        
    end
end

cd(CopyLocation)
% merge them all
system(['ndm_concatenate ' 'M' MouseNum '-' DateOfExperiment '-SpikesAllTogether'])

% rename as .fil
system(['mv ' 'M' MouseNum '-' DateOfExperiment '-SpikesAllTogether.dat' ' M' MouseNum '-' DateOfExperiment '-SpikesAllTogether.fil'])

% get the spikes
system(['ndm_extractspikes ' 'M' MouseNum '-' DateOfExperiment '-SpikesAllTogether'])
system(['ndm_pca ' 'M' MouseNum '-' DateOfExperiment '-SpikesAllTogether'])

% do the clustering
Batches = ceil(NumberOfSpikeGroups/3);

for b = 1:Batches
    
    if b*3<=NumberOfSpikeGroups
       NumToDo = [(b-1)*3+1:(b-1)*3+3];
    else
       NumToDo = [(b-1)*3+1:NumberOfSpikeGroups];
    end
    
    StringToExecute = [];
    for nn = 1:length(NumToDo)
        StringToExecute = [StringToExecute 'KlustaKwiknew M' MouseNum '-' DateOfExperiment '-SpikesAllTogether ' num2str(NumToDo(nn)) ' & '];
    end
    
    system(StringToExecute)
    
end

