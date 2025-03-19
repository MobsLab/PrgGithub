load('FolderName.mat');
SaveFolderName = uigetdir('', 'please provide Mouse''s folder ');
% for b=1:length(FolderName)
%     FolderName{b} = [SaveFolderName,FolderName{b}];
% end

source_HR = uigetdir('','please provide HR folder')

files_HR = dir(fullfile(source_HR))

files_HR_names = {files_HR.name}
files_HR_names = sort(files_HR_names)
dir_HR = {files_HR.folder}
dir_HR_final = strcat(dir_HR, '/' ,files_HR_names)
n = 1
dir_HR_final(n) = []
dir_HR_final(n) = []

j=1

for j = 1:length(FolderName)

cd(dir_HR_final{j});
source = dir_HR_final{j}; 
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
    file_source = fullfile(dir_HR_final{j}, files(k).name);
    file_destination = FolderName{1,j};
    movefile(file_source,file_destination);
end

j = j+1


end















