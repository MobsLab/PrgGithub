%mainPreProcessNicotineETM_CH

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step one

clear all
GUI_StepOne_ExperimentInfo

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step two, generates all folders

clear all; load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.TypeOfSystem='Intan';
save('ExpeInfo.mat')
GenerateAllFolders_NicotineETM_CH
save('AllFolderNames.mat','FolderName')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step three, merges and creates LFP Data

load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end
ExecuteNDM_CH

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step four, loads and saves the LFP Data

for f=1:length(FolderName)
    
    cd([FolderName{f}])
    try
        FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
        if isempty(findstr(FileName,'NicotineETM'))
            All=regexp(FolderName{f},filesep);
            FileName=FolderName{f}(All(end-1)+1:end);
            FileName=strrep(FileName,filesep,'_');
        end
              
        SetCurrentSession(FileName)
        MakeData_Main_SB
        MakeData_TTLInfo
        clear FileName NewFolderName
    catch
        disp('error for this folder')
    end
end






