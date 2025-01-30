function Dir=ListOfOctaveRecords
%
%
%   see ListOfDreemRecordsStimImpact
%


folder_record = FolderOctaveRecords;
%Select all nights
a=0;

a=a+1; Dir.filereference{a} = 149985;
Dir.date{a} = '06032018'; Dir.subject{a} = 'hjourde'; Dir.age{a}= 23;  % 06/03/2018 -> Subject hjourde
          
a=a+1; Dir.filereference{a} = 105482;
Dir.date{a} = '27022018'; Dir.subject{a} = 'valentin'; Dir.age{a}= 23;  % 27/02/2018 -> Subject valentin

a=a+1; Dir.filereference{a} = 103137;
Dir.date{a} = '23022018'; Dir.subject{a} = 'eden'; Dir.age{a}= 26;  % 23/02/2018 -> Subject eden

a=a+1; Dir.filereference{a} = 103105;
Dir.date{a} = '20022018'; Dir.subject{a} = 'pierre'; Dir.age{a}= 38;  % 20/02/2018 -> Subject pierre
    

%% Generic
if isfield(Dir,'filereference')
    %filenames ref
    for i=1:length(Dir.filereference)
        Dir.filename{i}= [folder_record num2str(Dir.filereference{i}) '.h5'];
    end
    
    %Condition
    for i=1:length(Dir.filereference)
        Dir.condition{i}= 'Octave';
    end       
end

end






