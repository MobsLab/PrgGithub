%M875
clear all
MouseNum = 875;
FileNames=GetAllMouseTaskSessions(MouseNum);
% Get rid of wo habituation sessions 24hours earlier
FileNames(find(~cellfun(@isempty,strfind(FileNames,'24HPre')))) = [];
CopyLocation = '/media/mobsmorty/4917988F5608D075/Mouse875/SpikeSorting/'


% copy the ones for the UMaze day into folder
for g=2:length(FileNames)
    
    FileNames{g} = strrep(FileNames{g},'/media/nas4/ProjetEmbReact/','/media/mobsmorty/4917988F5608D075/');
    
    cd(FileNames{g})
    load('ExpeInfo.mat')
    FolderName =  dir('*.dat');
    for i = 1:length(FolderName)
        if not(isempty(strfind(FolderName(i).name,num2str(MouseNum))))
            FolderNameToUse = FolderName(i).name;
        end
    end
    BaseFileName = FolderNameToUse(1:end-4);

    % Do subtraction
        if ExpeInfo.PreProcessingInfo.DoSpikes
            
            % Do subtraction if necessary
            if sum(ExpeInfo.SpikeGroupInfo.UseForElecSub)>0
                
                % get the electrodes to make the subtraction on
                ElecPerformSub = [];
                for sp = 1:length(ExpeInfo.SpikeGroupInfo.UseForElecSub)
                    if ExpeInfo.SpikeGroupInfo.UseForElecSub(sp) ==1
                        ElecPerformSub = [ElecPerformSub,str2num(ExpeInfo.SpikeGroupInfo.ChanNames{sp})];
                    end
                end
                
                % New version with different reference channels
                LeftOverChannels = 0:ExpeInfo.PreProcessingInfo.TotalChannels-1;
                ToDel = [];
                numtet = 1;
                for tet = 1:length(ExpeInfo.SpikeGroupInfo.ChanNames)
                    if ~isempty(ExpeInfo.SpikeGroupInfo.ElecsToSub{tet})
                        ChannelsToPerfSub{numtet} = str2num(ExpeInfo.SpikeGroupInfo.ChanNames{tet});
                        ChannelsToAverageForSub{numtet} = str2num(ExpeInfo.SpikeGroupInfo.ElecsToSub{tet});
                        ToDel = [ToDel, str2num(ExpeInfo.SpikeGroupInfo.ChanNames{tet})];
                        
                        numtet =  numtet +1;
                    end
                end
                LeftOverChannels(ismember(LeftOverChannels,ToDel)) = [];
                
                RefSubtraction_GroupByGroup([BaseFileName '.dat'],ExpeInfo.PreProcessingInfo.TotalChannels,1,'SpikeRef', ...
                    ChannelsToPerfSub, ChannelsToAverageForSub, LeftOverChannels);
                system(['mv ' BaseFileName '_original.dat ' BaseFileName '.dat'])
                copyfile([BaseFileName '.xml'], [BaseFileName '_SpikeRef.xml'])
                
                
                % Do the preprcessing steps
                system(['ndm_hipass ' BaseFileName '_SpikeRef'])
        end
    end
    
       
    % the data is copied as .dat so as to be able to concatenate them
    disp(['cp ' BaseFileName '_SpikeRef.fil ' CopyLocation 'M' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-SpikesAllTogether-' num2str(g,'%02i') '.dat'])
    system(['cp ' BaseFileName '_SpikeRef.fil ' CopyLocation 'M' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-SpikesAllTogether-' num2str(g,'%02i') '.dat'])
    
end

cd(CopyLocation)
% merge them all
system(['ndm_concatenate ' 'M'  num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-SpikesAllTogether'])

% rename as .fil
system(['mv ' 'M' num2str(ExpeInfo.nmouse)  '-' ExpeInfo.date '-SpikesAllTogether.dat' ' M' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-SpikesAllTogether.fil'])

% get the spikes
system(['ndm_extractspikes ' 'M' num2str(ExpeInfo.nmouse)  '-' ExpeInfo.date '-SpikesAllTogether'])
system(['ndm_pca ' 'M' num2str(ExpeInfo.nmouse)  '-' ExpeInfo.date '-SpikesAllTogether'])

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
        StringToExecute = [StringToExecute 'KlustaKwiknew M' num2str(ExpeInfo.nmouse) '-' ExpeInfo.date '-SpikesAllTogether ' num2str(NumToDo(nn)) ' & '];
    end
    
    system(StringToExecute)
    
end