% ReadMemoryData
% 07.07.2017 KJ
%
% 
% 
% 
%   see 
%


clear

%params
conditions_names = {'sham','random','upphase'};
period = {'evening','morning'};

filename = [FolderClinicTrial 'BILAN_PAIRWISE_MEMORY.xlsx'];
[~,~,raw]  = xlsread(filename,'TCD');

%Subject
raw_subject = raw(4:23,1);
for i=1:length(raw_subject)
    subjects(i,1) = str2num(raw_subject{i}(2:end));
end

%word random
word{2,1} = raw(4:23,2); %evening
word{2,2} = raw(4:23,3); %morning

%word sham
word{1,1} = raw(4:23,4); %evening
word{1,2} = raw(4:23,5); %morning

%word sham
word{3,1} = raw(4:23,6); %evening
word{3,2} = raw(4:23,7); %morning


%saving data
cd(FolderPrecomputeDreem)
save MemoryData.mat subjects word conditions_names period

