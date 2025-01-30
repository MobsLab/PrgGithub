clear all;

load('AllFolderNames.mat');

SaveFolderName = uigetdir('', 'please provide Mouse folder ');
for f=1:length(FolderName)
    FolderName{f} = [SaveFolderName,FolderName{f}];
end

for f=1:length(FolderName)
    cd(FolderName{f});
    disp(FolderName{f})
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    RefSubtraction_multi('auxiliary.dat',6,2,'RIGHT',[],[],[0:2],'WRONG',[],[],[3:5]);
    delete('auxiliary_WRONG.dat');
    delete('auxiliary_original.dat');
    currentFileName = 'auxiliary_RIGHT.dat';
    currentFilePath = FolderName{f};
    newFileName = 'auxiliary.dat';
    currentFullPath = fullfile(currentFilePath, currentFileName);
    newFullPath = fullfile(currentFilePath, newFileName);
    movefile(currentFullPath, newFileName);
    
    if exist (newFullPath, 'file') == 2
        disp('File renamed successfully');
    else
        disp('Error renaming new file');
    end
   
end
















