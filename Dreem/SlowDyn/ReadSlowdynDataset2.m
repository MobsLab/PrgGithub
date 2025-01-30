% ReadSlowdynDataset2
% 30.05.2018 KJ
%
%   Extract SlowDyn dataset information from xls
%
%   see 
%       ReadSlowdynDataset


clear

%params
filename = [FolderSlowDyn 'Slowdyn_dataset_sorted.xlsx'];
folder_record = FolderSlowDynRecords;

%read
[~,~,raw]  = xlsread(filename);

%% Dir
record_status = [0 ; cell2mat(raw(2:end, 12))];

Dir.filereference = raw(record_status==1, 3);
Dir.date = datetime(cell2mat(raw(record_status==1, 4)),'ConvertFrom','posixtime');
Dir.gender = raw(record_status==1, 7);
Dir.subject = raw(record_status==1, 8);
Dir.age = raw(record_status==1, 10);

for i=1:length(Dir.filereference)
    Dir.filename{i,1}= [folder_record num2str(Dir.filereference{i}) '.h5'];
end


%% saving data
cd(FolderSlowDyn)
save PathSlowDyn2.mat Dir

