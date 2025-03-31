% ReadSlowdynDatasetSfrms
% 16.11.2018 KJ
%
%   Extract SlowDyn dataset information from xls
%
%   see 
%       ReadSlowdynDataset ReadSlowdynDataset3 ReadSlowdynDatasetOctober


clear

%params
filename_rec1 = fullfile(FolderSlowDyn,'dataset', 'Slowdyn_dataset_sorted.xlsx');
filename_rec2 = fullfile(FolderSlowDyn,'dataset', 'records_of_users_in_selection_with_date.xlsx');

try
    cd(FolderSlowDynRecords)
    folder_record = FolderSlowDynRecords;
catch
    try
        cd('/media/karim/Elements/Dreem/SlowDyn/Records/')
        folder_record = '/media/karim/Elements/Dreem/SlowDyn/Records/';
    catch
        try
            cd('/media/mobsjunior/Elements/Dreem/SlowDyn/Records/')
            folder_record = '/media/mobsjunior/Elements/Dreem/SlowDyn/Records/';
        catch
            cd('/media/mobsjunior/Data2/Dreem/Slowdyn/Records/')
            folder_record = '/media/mobsjunior/Data2/Dreem/Slowdyn/Records/';
        end
    end
end


%% Dataset1

[~,~,raw]  = xlsread(filename_rec1);
record_status = [0 ; cell2mat(raw(2:end, 12))];

Dir1.filereference = raw(record_status==1, 3);
Dir1.date = datetime(cell2mat(raw(record_status==1, 4)),'ConvertFrom','posixtime');
Dir1.gender = raw(record_status==1, 7);
Dir1.subject = raw(record_status==1, 8);
Dir1.age = raw(record_status==1, 10);

for i=1:length(Dir1.filereference)
    Dir1.filename{i,1}= [folder_record num2str(Dir1.filereference{i}) '.h5'];
end

%% Dataset2

[~,~,raw]  = xlsread(filename_rec2);
record_status = [0 ; cell2mat(raw(2:end, 19))];

Dir2.filereference = raw(record_status==1, 3);
Dir2.date = datetime(cell2mat(raw(record_status==1, 17)),'ConvertFrom','posixtime');
Dir2.gender = raw(record_status==1, 11);
Dir2.subject = raw(record_status==1, 12);
Dir2.age = raw(record_status==1, 14);

for i=1:length(Dir2.filereference)
    Dir2.filename{i,1}= [folder_record num2str(Dir2.filereference{i}) '.h5'];
end


%% Merge and clean
Dir = FusionListOfDreemRecord(Dir1,Dir2);
list_record = [];
list_idx = [];
for i=1:length(Dir.filereference)
    if ~ismember(Dir.filereference{i},list_record) && exist(Dir.filename{i},'file')==2
        list_record = [list_record ; Dir.filereference{i}];
        list_idx = [list_idx ; i];
    end
end

dir_attr = fieldnames(Dir);
for i=1:length(dir_attr)
    Dir.(dir_attr{i}) = Dir.(dir_attr{i})(list_idx);
end


%%
% filestatus = fullfile(FolderSlowDyn,'dataset','RecordSFRMS.xlsx');
% [~,~,raw]  = xlsread(filestatus);
% good_status = [0 ; cell2mat(raw(2:end,7))==1];
% good_rec = cell2mat(raw(good_status==1,1));
% 
% 
% %all record
% all_rec = cell2mat(Dir.filereference);
% list_idx = ismember(all_rec,good_rec);
% dir_attr = fieldnames(Dir);
% for i=1:length(dir_attr)
%     newDir.(dir_attr{i}) = Dir.(dir_attr{i})(list_idx);
% end
% Dir=newDir;


%%
% load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))
% for p=1:length(Dir.filereference)
%     Dir.filename{p} = fullfile(folder_record,[num2str(Dir.filereference{p}) '.h5']);
% end

%% saving data
cd(FolderSlowDyn)
save PathSlowDynSfrms.mat Dir

