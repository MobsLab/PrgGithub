function Dir=ListOfDreemRecordsStimImpact(experiment)
%
%
%   see ListOfClinicalTrialDreem ListOfClinicalTrialDreemAnalyse
%


%Select all nights
if strcmpi(experiment,'study') || strcmpi(experiment,'all')
    Dir = ListOfDreemRecordsStimImpact('kusers');
    
    Dir2 = ListOfDreemRecordsStimImpact('happyfew');
    Dir = FusionListOfDreemRecord(Dir,Dir2);
    
    Dir2 = ListOfDreemRecordsStimImpact('highso');
    Dir = FusionListOfDreemRecord(Dir,Dir2);
    
    Dir2 = ListOfDreemRecordsStimImpact('internal');
    Dir = FusionListOfDreemRecord(Dir,Dir2);
    
    Dir2 = ListOfDreemRecordsStimImpact('external');
    Dir = FusionListOfDreemRecord(Dir,Dir2);
    

%Select one conditions
else
    folder_record = FolderStimImpactRecords;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kusers condition
    a=0;
    if strcmpi(experiment,'kusers')
        
        a=a+1; Dir.filereference{a} = 83448;
        Dir.date{a} = '30012018'; Dir.subject{a} = 'DehuiWolverine'; Dir.age{a}= 38; % 30/01/2018 -> Subject DehuiWolverine
        
        a=a+1; Dir.filereference{a} = 83800;
        Dir.date{a} = '31012018'; Dir.subject{a} = 'DehuiWolverine'; Dir.age{a}= 38;  % 31/01/2018 -> Subject DehuiWolverine
        
        
        a=a+1; Dir.filereference{a} = 84134;
        Dir.date{a} = '31012018'; Dir.subject{a} = 'YingkouApe'; Dir.age{a}= 71;  % 31/01/2018 -> Subject YingkouApe
        
        a=a+1; Dir.filereference{a} = 94558;
        Dir.date{a} = '19022018'; Dir.subject{a} = 'YingkouApe'; Dir.age{a}= 71;  % 19/02/2018 -> Subject YingkouApe
        
        a=a+1; Dir.filereference{a} = 85080;
        Dir.date{a} = '03022018'; Dir.subject{a} = 'YingkouApe'; Dir.age{a}= 71;  % 03/02/2018 -> Subject YingkouApe
        
        
        a=a+1; Dir.filereference{a} = 84393;
        Dir.date{a} = '01022018'; Dir.subject{a} = 'TengzhouTurtle'; Dir.age{a}= 33;  % 01/02/2018 -> Subject TengzhouTurtle
        
        a=a+1; Dir.filereference{a} = 83884;
        Dir.date{a} = '31012018'; Dir.subject{a} = 'TengzhouTurtle'; Dir.age{a}= 33;  % 31/01/2018 -> Subject TengzhouTurtle
        
        
        a=a+1; Dir.filereference{a} = 83262;
        Dir.date{a} = '29012018'; Dir.subject{a} = 'TongxiangCatfish'; Dir.age{a}= 51;  % 29/01/2018 -> Subject TongxiangCatfish
        
        a=a+1; Dir.filereference{a} = 82667;
        Dir.date{a} = '27012018'; Dir.subject{a} = 'TongxiangCatfish'; Dir.age{a}= 51;  % 27/01/2018 -> Subject TongxiangCatfish
        
        a=a+1; Dir.filereference{a} = 81009;
        Dir.date{a} = '20012018'; Dir.subject{a} = 'TongxiangCatfish'; Dir.age{a}= 51;  % 20/01/2018 -> Subject TongxiangCatfish
        
        
        a=a+1; Dir.filereference{a} = 84995;
        Dir.date{a} = '03022018'; Dir.subject{a} = 'JieyangWildebeest'; Dir.age{a}= 45;  % 03/02/2018 -> Subject JieyangWildebeest
        
        a=a+1; Dir.filereference{a} = 81695;
        Dir.date{a} = '23012018'; Dir.subject{a} = 'JieyangWildebeest'; Dir.age{a}= 45;  % 23/01/2018 -> Subject JieyangWildebeest
        
        a=a+1; Dir.filereference{a} = 148605;
        Dir.date{a} = '26032018'; Dir.subject{a} = 'JieyangWildebeest'; Dir.age{a}= 45;  % 26/03/2018 -> Subject JieyangWildebeest
        
        a=a+1; Dir.filereference{a} = 121680;
        Dir.date{a} = '12032018'; Dir.subject{a} = 'JieyangWildebeest'; Dir.age{a}= 45;  % 12/03/2018 -> Subject JieyangWildebeest
        
        a=a+1; Dir.filereference{a} = 97598;
        Dir.date{a} = '21022018'; Dir.subject{a} = 'JieyangWildebeest'; Dir.age{a}= 45;  % 21/02/2018 -> Subject JieyangWildebeest
        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% happyfew condition
    a=0;
    if strcmpi(experiment,'happyfew')
        
        a=a+1; Dir.filereference{a} = 94286;
        Dir.date{a} = '18022018'; Dir.subject{a} = 'HaichengRay'; Dir.age{a}= 66;  % 18/02/2018 -> Subject HaichengRay
        
        a=a+1; Dir.filereference{a} = 91397;
        Dir.date{a} = '15022018'; Dir.subject{a} = 'HaichengRay'; Dir.age{a}= 66;  % 15/02/2018 -> Subject HaichengRay
        
        a=a+1; Dir.filereference{a} = 90794;
        Dir.date{a} = '14022018'; Dir.subject{a} = 'HaichengRay'; Dir.age{a}= 66;  % 14/02/2018 -> Subject HaichengRay
        
        a=a+1; Dir.filereference{a} = 90028;
        Dir.date{a} = '13022018'; Dir.subject{a} = 'HaichengRay'; Dir.age{a}= 66;  % 13/02/2018 -> Subject HaichengRay
        
        a=a+1; Dir.filereference{a} = 85500;
        Dir.date{a} = '04022018'; Dir.subject{a} = 'HaichengRay'; Dir.age{a}= 66;  % 04/02/2018 -> Subject HaichengRay
        
        
        a=a+1; Dir.filereference{a} = 90492;
        Dir.date{a} = '15022018'; Dir.subject{a} = 'HubliDharwadClam'; Dir.age{a}= 49;  % 15/02/2018 -> Subject HubliDharwadClam
        
        a=a+1; Dir.filereference{a} = 86614;
        Dir.date{a} = '07022018'; Dir.subject{a} = 'HubliDharwadClam'; Dir.age{a}= 49;  % 07/02/2018 -> Subject HubliDharwadClam
        
        a=a+1; Dir.filereference{a} = 86140;
        Dir.date{a} = '06022018'; Dir.subject{a} = 'HubliDharwadClam'; Dir.age{a}= 49;  % 06/02/2018 -> Subject HubliDharwadClam
        
        
        
        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% highso condition
    a=0;
    if strcmpi(experiment,'highso')
        
        
        a=a+1; Dir.filereference{a} = 132874;
        Dir.date{a} = '18032018'; Dir.subject{a} = 'DhakaEmu'; Dir.age{a}= 29;  % 18/03/2018 -> Subject DhakaEmu
        
        a=a+1; Dir.filereference{a} = 138073;
        Dir.date{a} = '21032018'; Dir.subject{a} = 'DhakaEmu'; Dir.age{a}= 29;  % 21/03/2018 -> Subject DhakaEmu
        
        a=a+1; Dir.filereference{a} = 139893;
        Dir.date{a} = '22032018'; Dir.subject{a} = 'DhakaEmu'; Dir.age{a}= 29;  % 22/03/2018 -> Subject DhakaEmu
        
        
        
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%
    %% internal condition
    a=0;
    if strcmpi(experiment,'internal')
        
        a=a+1; Dir.filereference{a} = 165749;
        Dir.date{a} = '04042018'; Dir.subject{a} = 'artemis'; Dir.age{a}= 30;  % 04/04/2018 -> Subject artemis
        
        a=a+1; Dir.filereference{a} = 159618;
        Dir.date{a} = '01042018'; Dir.subject{a} = 'artemis'; Dir.age{a}= 30;  % 01/04/2018 -> Subject artemis
        
        a=a+1; Dir.filereference{a} = 146983;
        Dir.date{a} = '26032018'; Dir.subject{a} = 'artemis'; Dir.age{a}= 30;  % 26/03/2018 -> Subject artemis
        
        a=a+1; Dir.filereference{a} = 139998;
        Dir.date{a} = '22032018'; Dir.subject{a} = 'artemis'; Dir.age{a}= 30;  % 22/03/2018 -> Subject artemis
        

        a=a+1; Dir.filereference{a} = 165697;
        Dir.date{a} = '04042018'; Dir.subject{a} = 'arthur'; Dir.age{a}= 31;  % 04/04/2018 -> Subject arthur
        
        a=a+1; Dir.filereference{a} = 147371;
        Dir.date{a} = '26032018'; Dir.subject{a} = 'arthur'; Dir.age{a}= 31;  % 26/03/2018 -> Subject arthur
        
        a=a+1; Dir.filereference{a} = 139865;
        Dir.date{a} = '22032018'; Dir.subject{a} = 'arthur'; Dir.age{a}= 31;  % 22/03/2018 -> Subject arthur
        
        
        a=a+1; Dir.filereference{a} = 153767;
        Dir.date{a} = '29032018'; Dir.subject{a} = 'cjacquemin'; Dir.age{a}= 30;  % 29/03/2018 -> Subject cjacquemin
        
        
        a=a+1; Dir.filereference{a} = 139819;
        Dir.date{a} = '21032018'; Dir.subject{a} = 'jonathan'; Dir.age{a}= 40;  % 21/03/2018 -> Subject jonathan
        
        
        a=a+1; Dir.filereference{a} = 145201;
        Dir.date{a} = '25032018'; Dir.subject{a} = 'samantha'; Dir.age{a}= 25;  % 25/03/2018 -> Subject samantha
        
        a=a+1; Dir.filereference{a} = 81344;
        Dir.date{a} = '22012018'; Dir.subject{a} = 'samantha'; Dir.age{a}= 25;  % 22/01/2018 -> Subject samantha
        
        a=a+1; Dir.filereference{a} = 80573;
        Dir.date{a} = '19012018'; Dir.subject{a} = 'samantha'; Dir.age{a}= 25;  % 19/01/2018 -> Subject samantha
        
        a=a+1; Dir.filereference{a} = 80422;
        Dir.date{a} = '17012018'; Dir.subject{a} = 'samantha'; Dir.age{a}= 25;  % 17/01/2018 -> Subject samantha
        
        
        
    end
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%
    %% external condition
    a=0;
    if strcmpi(experiment,'external')
        
        a=a+1; Dir.filereference{a} = 153614;
        Dir.date{a} = '29032018'; Dir.subject{a} = 'KryviyRigHummingbird'; Dir.age{a}= 25;  % 29/03/2018 -> Subject KryviyRigHummingbird
%         
%         a=a+1; Dir.filereference{a} = 64636;
%         Dir.date{a} = '31072017'; Dir.subject{a} = 'TorinoFrog'; Dir.age{a}= 29;  % 31/07/2017 -> Subject TorinoFrog

%         a=a+1; Dir.filereference{a} = 63191;
%         Dir.date{a} = '17072017'; Dir.subject{a} = 'TorinoFrog'; Dir.age{a}= 29;  % 17/07/2017 -> Subject TorinoFrog
        
    end
    
    
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

end




