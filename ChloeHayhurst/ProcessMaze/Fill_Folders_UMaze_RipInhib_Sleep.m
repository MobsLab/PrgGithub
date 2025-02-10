% Script to fill the folders for UMaze. You still have to fill the
% calibration files

%% RIP SLEEP PROTOCOL

% The raw files have to be organized in this way :
%     - Sleep_Post_Post
%     - Sleep_Post_Pre
%     - Sleep_Pre
%     - All of the intan files (from habituation 24h pre to Extinction)
%     - All of the matlab files, there should be in order : Hab _03, BlockedWall_09, Cond_06,
% CondWallSafe/Shock_04, SleepSession_02, TestPost_07, TestPre_03


load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for b=1:length(FolderName)
    FolderName{b} = [SaveFolderName,FolderName{b}];
end

source_UMaze = uigetdir('','please provide Maze folder')

files_UMaze = dir(fullfile(source_UMaze));

files_UMaze_names = {files_UMaze.name};
files_UMaze_names = sort(files_UMaze_names);
dir_UMaze = {files_UMaze.folder};
dir_UMaze_final = strcat(dir_UMaze, '/' ,files_UMaze_names);
c = 0;
n=1;
dir_UMaze_final(n) = [];
dir_UMaze_final(n) = [];


for j = 1:46
    List_for_loop_FillFolders_Maze_1
    
    cd(dir_UMaze_final{j});
    source = dir_UMaze_final{j};
    files = dir(fullfile(source, '*.*'));
    
    if (exist('amplifier.nrs')>0 | exist('amplifier.xml')>0 | exist('auxiliary.nrs')>0 | exist('auxiliary.xml')>0)
        delete('amplifier.nrs')
    end
    
    if (exist('amplifier.xml')>0)
        delete('amplifier.xml')
    end
    
    if (exist('auxiliary.nrs')>0)
        delete('auxiliary.nrs')
    end
    
    if (exist('auxiliary.xml')>0)
        delete('auxiliary.xml')
    end
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for k = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(k).name);
        file_destination = FolderName{1,z};
        movefile(file_source,file_destination);
    end
end

% Verify that your folders have all desired intan files :

for f=1:46
    cd(FolderName{f});
    disp(FolderName{f})
    if exist('amplifier.dat')>0 && exist('auxiliary.dat')>0 && exist('digitalin.dat')>0 && exist('info.rhd')>0 && exist('supply.dat')>0 && exist('time.dat')>0
        disp('all good')
    else 
        disp('problem with this file')
    end  
end


for d = 1:46
    rmdir(dir_UMaze_final{d})
end


% Fill matlab files

cd(SaveFolderName);

load('AllFolderNames.mat')
% SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for b=1:length(FolderName)
    FolderName{b} = [SaveFolderName,FolderName{b}];
end

% source_UMaze = uigetdir('','please provide Maze folder');

files_UMaze = dir(fullfile(source_UMaze));

files_UMaze_names = {files_UMaze.name};
files_UMaze_names = sort(files_UMaze_names);
dir_UMaze = {files_UMaze.folder};
dir_UMaze_final = strcat(dir_UMaze, '/' ,files_UMaze_names);
n = 1;
c = 1;
dir_UMaze_final(n) = [];
dir_UMaze_final(n) = [];



for c = 1:46
    List_for_loop_FillFolders_Maze_1
    cd(dir_UMaze_final{c});
    source = dir_UMaze_final{c};
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{c}, files(e).name);
        file_destination = FolderName{1,y};
        movefile(file_source,file_destination);
    end
end

% Copy behav_Resources into the raw folder

cd(SaveFolderName);

for f=1:46
    cd(FolderName{f});
    disp(FolderName{f})
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    behavResources = strcat(FolderName{f},'/behavResources.mat');
    FigBilan = strcat(FolderName{f},'/FigBilan.png');
    TrObjLocalect = strcat(FolderName{f},'/TrObjLocalect.mat');
    destination = strcat(FolderName{f},'/raw');
    copyfile(behavResources, destination);
    movefile(FigBilan, destination);
    movefile(TrObjLocalect, destination);
end


for f=1:46
    cd(FolderName{f});
    disp(FolderName{f})
    if exist('behavResources.mat')>0
        disp('all good')
    else 
        disp('problem with this file')
    end  
end

% 
% 
% for f=1:46
%     cd(FolderName{f});
%     disp(FolderName{f})
%     try
%         delete('behavResources.mat')
%         delete('F04072024-0000.avi')
%         delete('behavResources_SB.mat')
%         delete('SpeedCorrected.mat')
%         cd(strcat(FolderName{f},'/raw'))
%         delete('FigBilan.png')
%         delete('TrObjLocalect.mat')
%         delete('behavResources.mat')
%     end
% end
