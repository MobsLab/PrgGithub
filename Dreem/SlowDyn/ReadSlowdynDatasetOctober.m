% ReadSlowdynDatasetOctober
% 27.10.2018 KJ
%
%   Extract SlowDyn dataset information from xls
%
%   see 
%       ReadSlowdynDataset ReadSlowdynDataset3


clear

%params
filename_rec = fullfile(FolderSlowDyn,'dataset', 'records_of_users_in_selection_with_date.xlsx');

folder_record = FolderSlowDynRecords;
folder_record = '/media/mobsjunior/Elements/Dreem/SlowDyn/Records/';

%read
[~,~,raw]  = xlsread(filename_rec);

%% Dir
record_status = [0 ; cell2mat(raw(2:end, 19))];

Dir.filereference = raw(record_status==1, 3);
Dir.date = datetime(cell2mat(raw(record_status==1, 17)),'ConvertFrom','posixtime');
Dir.gender = raw(record_status==1, 11);
Dir.subject = raw(record_status==1, 10);
Dir.age = raw(record_status==1, 14);

for i=1:length(Dir.filereference)
    Dir.filename{i,1}= [folder_record num2str(Dir.filereference{i}) '.h5'];
end


%% saving data
cd(FolderSlowDyn)
save PathSlowDynOctober.mat Dir

