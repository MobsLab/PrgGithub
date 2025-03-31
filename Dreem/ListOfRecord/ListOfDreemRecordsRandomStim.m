function Dir=ListOfDreemRecordsRandomStim(experiment)
%
%
%   see ListOfClinicalTrialDreem ListOfClinicalTrialDreemAnalyse
%



folder_record = FolderRandomStimRecords;

%% kusers condition
a=0;


a=a+1; Dir.filereference{a} = 173796;
Dir.date{a} = '08042018'; Dir.subject{a} = 'ChangleSwift'; Dir.age{a}= 34; % 08/04/2018 -> Subject ChangleSwift

a=a+1; Dir.filereference{a} = 178083;
Dir.date{a} = '10042018'; Dir.subject{a} = 'mehdi'; Dir.age{a}= 24;  % 10/04/2018 -> Subject mehdi

a=a+1; Dir.filereference{a} = 178139;
Dir.date{a} = '10042018'; Dir.subject{a} = 'cjacquemin'; Dir.age{a}= 26;  % 10/04/2018 -> Subject cjacquemin

a=a+1; Dir.filereference{a} = 175893;
Dir.date{a} = '09042018'; Dir.subject{a} = 'cjacquemin'; Dir.age{a}= 26;  % 09/04/2018 -> Subject cjacquemin


a=a+1; Dir.filereference{a} = 178043;
Dir.date{a} = '10042018'; Dir.subject{a} = 'KhartoumNorthDove'; Dir.age{a}= 25;  % 10/04/2018 -> Subject KhartoumNorthDove

a=a+1; Dir.filereference{a} = 174038;
Dir.date{a} = '08042018'; Dir.subject{a} = 'KhartoumNorthDove'; Dir.age{a}= 25;  % 08/04/2018 -> Subject KhartoumNorthDove

a=a+1; Dir.filereference{a} = 171700;
Dir.date{a} = '07042018'; Dir.subject{a} = 'KhartoumNorthDove'; Dir.age{a}= 25;  % 07/04/2018 -> Subject KhartoumNorthDove


%% %%%%%%%%%%%%%%%%%%%%%%%%%%
%Generic
if isfield(Dir,'filereference')
%% filenames ref
for i=1:length(Dir.filereference)
    Dir.filename{i}= [folder_record num2str(Dir.filereference{i}) '.h5'];
end


%% Condition
for i=1:length(Dir.filereference)
    Dir.condition{i}= experiment;
end       
end


end




