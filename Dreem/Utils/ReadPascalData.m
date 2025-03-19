% ReadPascalData
% 18.07.2017 KJ
%
% 
% 
% 
%   see 
%


clear

%% Import 
filename = [FolderClinicTrial '16_SMP_EEG_NUIT_stat_analysed_V2.xlsx'];
[~,~,raw]  = xlsread(filename,'data_stat');
raw = raw(2:end,:);

Dir=ListOfClinicalTrialDreemAnalyse('study');

%column
raw_subject = raw(:,1);
raw_parameter = raw(:,2);
raw_value = cell2mat(raw(:,4));
raw_conditions = raw(:,5);


%Subject
for i=1:length(raw_subject)
    num_subjects(i,1) = str2num(raw_subject{i}(2:end));
end

%unique
parameters = unique(raw_parameter);
conditions = unique(raw_conditions);
subjects = unique(num_subjects);

%% data

for i=1:length(parameters)
    for subj=1:length(subjects)
        for cond=1:length(conditions)
            idx = strcmpi(conditions{cond}, raw_conditions) & strcmpi(parameters{i}, raw_parameter) & subjects(subj)==num_subjects;
            data{i}(subj,cond) = raw_value(idx);
        end
    end
end



%saving data
cd(FolderPrecomputeDreem)
save ReadPascalData.mat parameters conditions subjects data

