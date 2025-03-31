% ReadSlowdynDataset
% 30.05.2018 KJ
%
%   Extract SlowDyn dataset information from xls
%
%   see 
%


clear

%params
filename = [FolderSlowDyn 'Slowdyn_dataset.xlsx'];
folder_record = FolderSlowDynRecords;

%read
[~,~,raw]  = xlsread(filename);

%% Dir
Dir.filereference = raw(2:end, 3);
Dir.date = datetime(cell2mat(raw(2:end, 4)),'ConvertFrom','posixtime');
Dir.gender = raw(2:end, 7);
Dir.subject = raw(2:end, 8);
Dir.age = raw(2:end, 10);

for i=1:length(Dir.filereference)
    Dir.filename{i,1}= [folder_record num2str(Dir.filereference{i}) '.h5'];
end


%% saving data
cd(FolderSlowDyn)
save PathSlowDyn.mat Dir

