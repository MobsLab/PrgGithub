%CheckClinicFiles

clear


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% List of files


% PathList
Dir=ListOfClinicalTrialDreem('all');
path_list = sort(cell2mat(Dir.filereference'));

% PathList for Analysis
Dir=ListOfClinicalTrialDreemAnalyse('all');
path_list_analyse = sort(cell2mat(Dir.filereference'));

% Records
cd(FolderClinicRecords)
d=dir('*.h5');
records_h5 = {d(:).name};
records_h5 = sort(records_h5);
record_list=[];

for i=1:length(records_h5)
    fileref = str2num(records_h5{i}(1:end-3));
    record_list = [record_list; fileref];
end
record_list = sort(record_list);


% Hypnograms
cd(FolderClinicHypnogram)
d=dir('*.h5');
hypno_h5 = {d(:).name};
hypno_h5 = sort(hypno_h5);
hypno_list=[];

for i=1:length(records_h5)
    try
        fileref = str2num(hypno_h5{i}(1:end-3));
        hypno_list = [hypno_list; fileref];
    end
end
hypno_list = sort(hypno_list);


% Virtual Channels
cd(FolderClinicVirtual)
d=dir('*.h5');
virtual_h5 = {d(:).name};
virtual_h5 = sort(virtual_h5);
virtual_list=[];

for i=1:length(virtual_h5)
    fileref = str2num(virtual_h5{i}(1:end-3));
    virtual_list = [virtual_list; fileref];
end
virtual_list = sort(virtual_list);


%clear
clear Dir d records_h5 hypno_h5 virtual_h5 fileref i

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check differences

% path-analyses not in path
pathanalyse_notin_path = path_list_analyse(~ismember(path_list_analyse,path_list));

% path not in records
path_notin_records = path_list(~ismember(path_list,record_list));

%hypno not in records
hypno_notin_records = hypno_list(~ismember(hypno_list,record_list));

%virtual channels not in records
virtual_notin_records = virtual_list(~ismember(virtual_list,record_list));

%hypno_notin_virtual
hypno_notin_virtual = hypno_list(~ismember(hypno_list,virtual_list));
%virtual_notin_hypno
virtual_notin_hypno = virtual_list(~ismember(virtual_list,hypno_list));


%hypno_notin_path
hypno_notin_path = hypno_list(~ismember(hypno_list,path_list));
%virtual_notin_path
virtual_notin_path = virtual_list(~ismember(virtual_list,path_list));


%path not in hypno
path_notin_hypno = path_list(~ismember(path_list,hypno_list));
%path not in virtual
path_notin_virtual = path_list(~ismember(path_list,virtual_list));






