%mainPreProcessEmbReactSB

%% Sophie codes to use to organize and preprocess EmbReact project files
clear all
rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/EmbReact/PreProcessing')
GUI_StepOne_ExperimentInfo
GUI_StepTwo_RecordingInfo
% GetBasicInfoSB


GenerateAllFoldersEmbReactSB_FLXV2
disp('make sure all concatenations are done')
disp('all folder should contai, amplifier_MXXX.xml,amplifier_MXXX.dat,digitalin.dat ')
save('AllFolderNames.mat','FolderName')

% Now call relevant NDM functions
load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end
ExecuteNDM

% % Now make matlab compatible files
% load('AllFolderNames.mat')
% SaveFolderName = uigetdir('','please provide Mouse''s folder ');
% for f=1:length(FolderName)
%     FolderName{f}=[SaveFolderName,FolderName{f}];
% end

for f=4:length(FolderName)
    
    cd([FolderName{f}])
    try
    %   NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');


        FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
        if isempty(findstr(FileName,'ProjectEmbReact'))
            All=regexp(FolderName{f},filesep);
            FileName=FolderName{f}(All(end-1)+1:end);
            FileName=strrep(FileName,filesep,'_');
        end

        SetCurrentSession(FileName)
        MakeData_Main_SB
        clear FileName NewFolderName
    catch
        disp('error for this folder')
    end
end
