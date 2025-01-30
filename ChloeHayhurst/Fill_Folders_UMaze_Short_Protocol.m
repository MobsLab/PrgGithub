% Script to fill the folders for UMaze. You still have to fill the
% calibration files

%% SHORT PROTOCOL

% The raw files have to be organized in this way :
%     - Sleep_Post
%     - Sleep_Pre
%     - All of the intan files (from habituation 24h pre to Extinction)

load('AllFolderNames.mat');
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for b=1:length(FolderName)
    FolderName{b} = [SaveFolderName,FolderName{b}];
end

source_UMaze = uigetdir('','please provide Maze folder');

files_UMaze = dir(fullfile(source_UMaze));

files_UMaze_names = {files_UMaze.name};
files_UMaze_names = sort(files_UMaze_names);
dir_UMaze = {files_UMaze.folder};
dir_UMaze_final = strcat(dir_UMaze, '/' ,files_UMaze_names);
n = 1;
dir_UMaze_final(n) = [];
dir_UMaze_final(n) = [];


% Sleep_Post

j=1;
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
    file_destination = FolderName{1,21}
    movefile(file_source,file_destination)
end

% Sleep_Pre

j = j+1

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}
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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,7};
    movefile(file_source,file_destination)
end


% Hab 1-4 + Hab blocked x2

j = j+1
z=1

for c = 1:6
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
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
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

z=8

% Test Pre

for c = 1:4
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
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
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Cond explo 1-3

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
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
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+3
    
end

% Cond Blocked Shock 1-3

j = 14

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
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
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+3
    
end


% Cond Blocked Safe 1-3

j = 15

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
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
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+3
    
end


% TestPost + Ext Blocked Shock 1

j = 22

z = 22

for c = 1:5
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
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
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Ext Blocked Safe 1

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,29}
    movefile(file_source,file_destination)
end

j = j+1

% Recall 1

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}
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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,32}
    movefile(file_source,file_destination)
end

j = j+1

% Ext Blocked Shock 2

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,27}
    movefile(file_source,file_destination)
end

j = j+1

% Ext Blocked Safe 2

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,30}
    movefile(file_source,file_destination)
end

j = j+1

% Recall 2

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,33}
    movefile(file_source,file_destination)
end

j = j+1

% Ext Blocked Shock 3

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,28}
    movefile(file_source,file_destination)
end

j = j+1

% Ext Blocked Safe  3

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

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

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,31}
    movefile(file_source,file_destination)
end

for d = 1:33
    rmdir(dir_UMaze_final{d})
end

% Extinction

% cd(dir_UMaze_final{j})
% source = dir_UMaze_final{j}
% files = dir(fullfile(source, '*.*'));
% files(n) = []
% files(n) = []
% if (exist('amplifier.nrs')>0 | exist('amplifier.xml')>0 | exist('auxiliary.nrs')>0 | exist('auxiliary.xml')>0)
%     delete('amplifier.nrs')
% end
% 
% if (exist('amplifier.xml')>0)
%     delete('amplifier.xml')
% end
% 
% if (exist('auxiliary.nrs')>0)
%     delete('auxiliary.nrs')
% end
% 
% if (exist('auxiliary.xml')>0)
%     delete('auxiliary.xml')
% end
% 
% for e = 1:numel(files)
%     file_source = fullfile(dir_UMaze_final{j}, files(e).name);
%     file_destination = FolderName{1,38}
%     movefile(file_source,file_destination)
% end


% Verify that all your folders have all desired intan files :

for f=1:33
    cd(FolderName{f});
    disp(FolderName{f})
    if exist('amplifier.dat')>0 && exist('auxiliary.dat')>0 && exist('digitalin.dat')>0 && exist('info.rhd')>0 && exist('supply.dat')>0 && exist('time.dat')>0
        disp('all good')
    else 
        disp('problem with this file')
    end  
end

% Fill matlab files

cd(SaveFolderName);

load('AllFolderNames.mat')
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
for b=1:length(FolderName)
    FolderName{b} = [SaveFolderName,FolderName{b}];
end


source_UMaze = uigetdir('','please provide Maze folder')

files_UMaze = dir(fullfile(source_UMaze))

files_UMaze_names = {files_UMaze.name}
files_UMaze_names = sort(files_UMaze_names)
dir_UMaze = {files_UMaze.folder}
dir_UMaze_final = strcat(dir_UMaze, '/' ,files_UMaze_names)
n = 1
dir_UMaze_final(n) = []
dir_UMaze_final(n) = []

% Hab 1 to 4 + Blocked Wall 1 and 2

j=1
z=1

for c = 1:6
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Ext Blocked Shock

j=7
z = 26

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+2
    
end

% Ext Blocked Safe

j=8

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+2
    
end

% Cond Explo

j = 13
z = 12

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Recall

j=16
z = 32

for c = 1:2
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Cond Wall Safe

j = 18
z = 18

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Cond Wall Shock

j = 21
z = 15

for c = 1:3
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Sleep Pre

j=24

cd(dir_UMaze_final{j})
source = dir_UMaze_final{j}

files = dir(fullfile(source, '*.*'));
files(n) = [];
files(n) = [];

for e = 1:numel(files)
    file_source = fullfile(dir_UMaze_final{j}, files(e).name);
    file_destination = FolderName{1,7}
    movefile(file_source,file_destination)
end

% Sleep Post + Test Post

j= 25
z = 21

for c = 1:5
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% TestPre

j= 30
z = 8

for c = 1:4
    cd(dir_UMaze_final{j})
    source = dir_UMaze_final{j}
    
    files = dir(fullfile(source, '*.*'));
    files(n) = [];
    files(n) = [];
    
    for e = 1:numel(files)
        file_source = fullfile(dir_UMaze_final{j}, files(e).name);
        file_destination = FolderName{1,z}
        movefile(file_source,file_destination)
    end
    
    
    z = z+1
    j = j+1
    
end

% Copy behav_Resources into the raw folder

cd(SaveFolderName);

for f=1:length(FolderName)
    cd(FolderName{f});
    disp(FolderName{f})
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    behavResources = strcat(FolderName{f},'/behavResources.mat');
    FigBilan = strcat(FolderName{f},'/FigBilan.png');
    TrObjLocalect = strcat(FolderName{f},'/TrObjLocalect.mat');
    destination = strcat(FolderName{f},'/raw');
    copyfile(behavResources, destination);
    movefile(FigBilan, destination)
    movefile(TrObjLocalect, destination)
end

