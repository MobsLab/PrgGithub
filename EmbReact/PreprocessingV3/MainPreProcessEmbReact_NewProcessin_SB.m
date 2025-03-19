%mainPreProcessEmbReactSB

%% Sophie codes to use to organize and preprocess EmbReact project files
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step one
clear all
rmpath([dropbox '/Kteam/PrgMatlab/EmbReact/PreProcessing'])
GUI_StepOne_ExperimentInfo

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step two
clear all; load('ExpeInfo.mat');
ExpeInfo.PreProcessingInfo.TypeOfSystem='Intan';
save('ExpeInfo.mat')
% GenerateAllFolders_NewProcessin_SB % 
% GenerateAllFolders_Maze_RipInhib_BM
GenerateAllFolders_Maze_CH
disp('all folder should contain amplifier_MXXX.xml,amplifier_MXXX.dat,digitalin.dat ')
cd ..
save('AllFolderNames.mat','FolderName')

Fill_Folders_UMaze_RipInhib_Sleep

% Fill_Folders_UMaze_Short_Protocol_CH
% Fill_Folders_UMaze_CH

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step three
% Now call relevant NDM functions
load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end
ExecuteNDM_BM

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Launch step four
% % Now make matlab compatible files
for f=1:length(FolderName)
    
    cd([FolderName{f}])
    disp([FolderName{f}])
    try
        %   NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
        
        FileName=FolderName{f}(max(regexp(FolderName{f},filesep))+1:end);
        if isempty(findstr(FileName,'ProjectEmbReact'))
            All=regexp(FolderName{f},filesep);
            FileName=FolderName{f}(All(end-1)+1:end);
            FileName=strrep(FileName,filesep,'_');
        end
        
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


%% Delete amplifier_original if needed

for j = 1:length(FolderName)
    cd(FolderName{j});
    if (exist('amplifier_original.dat')>0)
        delete('amplifier_original.dat')
    end
end





