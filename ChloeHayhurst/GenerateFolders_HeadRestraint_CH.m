%% Create HeadRestraint Folders

%% Make sure you have the right ExpeInfo

clear all
rmpath([dropbox '/Kteam/PrgMatlab/EmbReact/PreProcessing'])
GUI_StepOne_ExperimentInfo

%% Step Two - Create the folders

clear all; load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.TypeOfSystem='Intan';
save('ExpeInfo.mat')
mkdir(['HeadRestraint'])
SaveFolderName=uigetdir('','please provide mouse Folder')
HRFolder = uigetdir('','please provide HeadRestraint Folder')
cd('HeadRestraint')
Response = inputdlg({'Days of experiments'},...
    'Inputs for HeadRestraintFolders',1,{'[1,2,3,4,5]'});
Days=eval(Response{1})
FolderName = OrganizeFilesHeadRestraint_CH(ExpeInfo.nmouse, HRFolder, ExpeInfo, Days)
AllFold=length(FolderName)
cd(SaveFolderName)
save('FolderName.mat','FolderName')
disp ('Now Fill in your folders with correct files')

FillFolders_HR_CH

%% Process the files
cd(SaveFolderName)
load('FolderName.mat');
ExecuteNDM_CH

%% Make the LFP

for f=1:length(FolderName)
    
    cd([FolderName{f}])
    try
        %   NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
        
        FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
%         if isempty(findstr(FileName,'ProjectEmbReact'))
%             All=regexp(FolderName{f},filesep);
%             FileName=FolderName{f}(All(end-1)+1:end);
%             FileName=strrep(FileName,filesep,'_');
%         end
        
%         WriteExpeInfoToXml(ExpeInfo)
%         movefile('amplifier.xml',[FileName,'.xml'])
%         
        SetCurrentSession(FileName)
        MakeData_Main_SB
        MakeData_TTLInfo
        clear FileName NewFolderName
    catch
        disp('error for this folder')
    end
end









