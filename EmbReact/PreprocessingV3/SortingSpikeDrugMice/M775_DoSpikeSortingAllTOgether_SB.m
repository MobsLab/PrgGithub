%M775
clear all
MouseNum = 775;
FileNames=GetAllMouseTaskSessions(MouseNum);
% Get rid of wo habituation sessions 24hours earlier
FileNames(find(~cellfun(@isempty,strfind(FileNames,'24HPre')))) = [];
CopyLocation = '/media/mobsmorty/DataMOBS89/Mouse775/20180815/Mouse775_SpikeSortTogether/'


% copy the ones for the UMaze day into folder
for g=1:length(FileNames)
    
    FileNames{g} = strrep(FileNames{g},'/media/nas4/ProjetEmbReact/','/media/mobsmorty/DataMOBS89/');
    
    cd(FileNames{g})
    load('ExpeInfo.mat')
    FolderName =  dir('*.dat');
    for i = 1:length(FolderName)
        if not(isempty(strfind(FolderName(i).name,'M775')))
            FolderNameToUse = FolderName(i).name;
        end
    end
    BaseFileName = FolderNameToUse(1:end-4);
    
    % the data is copied as .dat so as to be able to concatenate them
    disp(['cp ' BaseFileName '.fil ' CopyLocation 'M' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-SpikesAllTogether-' num2str(g,'%02i') '.dat'])
    system(['cp ' BaseFileName '.fil ' CopyLocation 'M' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date)  '-SpikesAllTogether-' num2str(g,'%02i') '.dat'])
    
end

cd(CopyLocation)
% merge them all
system(['ndm_concatenate ' 'M'  num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date)  '-SpikesAllTogether'])

% rename as .fil
system(['mv ' 'M' num2str(ExpeInfo.nmouse)  '-' num2str(ExpeInfo.date)  '-SpikesAllTogether.dat' ' M' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date)  '-SpikesAllTogether.fil'])

% get the spikes
system(['ndm_extractspikes ' 'M' num2str(ExpeInfo.nmouse)  '-' num2str(ExpeInfo.date)  '-SpikesAllTogether'])
system(['ndm_pca ' 'M' num2str(ExpeInfo.nmouse)  '-' num2str(ExpeInfo.date)  '-SpikesAllTogether'])

% do the clustering
NumberOfSpikeGroups = ExpeInfo.SpikeGroupInfo.SpikeGroupNum;
Batches = ceil(NumberOfSpikeGroups/3);

for b = 1:Batches
    
    if b*3<=NumberOfSpikeGroups
        NumToDo = [(b-1)*3+1:(b-1)*3+3];
    else
        NumToDo = [(b-1)*3+1:NumberOfSpikeGroups];
    end
    
    StringToExecute = [];
    for nn = 1:length(NumToDo)
        StringToExecute = [StringToExecute 'KlustaKwiknew M' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date)  '-SpikesAllTogether ' num2str(NumToDo(nn)) ' & '];
    end
    
    system(StringToExecute)
    
end