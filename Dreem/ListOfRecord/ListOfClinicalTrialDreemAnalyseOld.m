function Dir=ListOfClinicalTrialDreemAnalyse(experiment)
%
%
%   see ListOfClinicalTrialDreem ListOfClinicalTrialDreemAnalyseOld
%


%Select all nights
if strcmpi(experiment,'study') || strcmpi(experiment,'all')
    Dir1 = ListOfClinicalTrialDreemAnalyse('Sham');
    Dir2 = ListOfClinicalTrialDreemAnalyse('Random');
    Dir3 = ListOfClinicalTrialDreemAnalyse('UpPhase');
    
    Dir1 = FusionListOfClinicalTrial(Dir1,Dir2);    
    Dir = FusionListOfClinicalTrial(Dir1,Dir3);

%Select one conditions
else
    Dir.folder_record = FolderClinicRecords;
    Dir.folder_process = FolderProcessDreem;

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Sham condition
    a=0;
    if strcmpi(experiment,'Sham')
        
        %resync not ok
%         a=a+1; Dir.filereference{a} = 28450;
%         Dir.date{a} = '26092016'; Dir.night{a} = 2; Dir.subject{a} = 2;  % 26/09/2016 -> Subject 2
%         Dir.channel_sw{a} = [1 2 7 10];
%         
        a=a+1; Dir.filereference{a} = 26655;
        Dir.date{a} = '10102016'; Dir.night{a} = 4; Dir.subject{a} = 3;  % 10/10/2016 -> Subject 3
        Dir.channel_sw{a} = [1 7 10];
        
        %resync not ok
%         a=a+1; Dir.filereference{a} = 27939;
%         Dir.date{a} = '10102016'; Dir.night{a} = 4; Dir.subject{a} = 4;  % 10/10/2016 -> Subject 4
%         Dir.channel_sw{a} = [1 2 7 10];
        
        %bad quality
        a=a+1; Dir.filereference{a} = 29245;
        Dir.date{a} = '03102016'; Dir.night{a} = 3; Dir.subject{a} = 5;  % 03/10/2016 -> Subject 5
        Dir.channel_sw{a} = [1 2 10];
        
        a=a+1; Dir.filereference{a} = 28188;
        Dir.date{a} = '27092016'; Dir.night{a} = 2; Dir.subject{a} = 7;  % 27/09/2016 -> Subject 7
        Dir.channel_sw{a} = [2 7 10];
        
        %resync not ok
%         a=a+1; Dir.filereference{a} = 27027; %43795
%         Dir.date{a} = '27092016'; Dir.night{a} = 2; Dir.subject{a} = 8;  % 27/09/2016 -> Subject 8
%         Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28453;
        Dir.date{a} = '11102016'; Dir.night{a} = 4; Dir.subject{a} = 9;  % 11/10/2016 -> Subject 9
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 29258;
        Dir.date{a} = '11102016'; Dir.night{a} = 4; Dir.subject{a} = 10;  % 11/10/2016 -> Subject 10
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27942;
        Dir.date{a} = '04102016'; Dir.night{a} = 3; Dir.subject{a} = 11;  % 04/10/2016 -> Subject 11
        Dir.channel_sw{a} = [1 2 10];
        
        a=a+1; Dir.filereference{a} = 26826;
        Dir.date{a} = '04102016'; Dir.night{a} = 3; Dir.subject{a} = 12;  % 04/10/2016 -> Subject 12
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28185;
        Dir.date{a} = '28092016'; Dir.night{a} = 2; Dir.subject{a} = 13;  % 28/09/2016 -> Subject 13
        Dir.channel_sw{a} = [7 10];
        
        a=a+1; Dir.filereference{a} = 26832;
        Dir.date{a} = '28092016'; Dir.night{a} = 2; Dir.subject{a} = 14;  % 28/09/2016 -> Subject 14
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28170;
        Dir.date{a} = '12102016'; Dir.night{a} = 4; Dir.subject{a} = 16;  % 12/10/2016 -> Subject 16
        Dir.channel_sw{a} = 1;
        
        a=a+1; Dir.filereference{a} = 28428;
        Dir.date{a} = '05102016'; Dir.night{a} = 3; Dir.subject{a} = 17;  % 05/10/2016 -> Subject 17
        Dir.channel_sw{a} = [1 2 10];
        
        a=a+1; Dir.filereference{a} = 28463;
        Dir.date{a} = '29092016'; Dir.night{a} = 2; Dir.subject{a} = 19;  % 29/09/2016 -> Subject 19
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27916;
        Dir.date{a} = '29092016'; Dir.night{a} = 2; Dir.subject{a} = 20;  % 29/09/2016 -> Subject 20
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28433;
        Dir.date{a} = '13102016'; Dir.night{a} = 4; Dir.subject{a} = 21;  % 13/10/2016 -> Subject 21
        Dir.channel_sw{a} = [1 7 10];
        
        %bad quality
%         a=a+1; Dir.filereference{a} = 28459;
%         Dir.date{a} = '13102016'; Dir.night{a} = 4; Dir.subject{a} = 22;  % 13/10/2016 -> Subject 22
%         Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 20986;
        Dir.date{a} = '06102016'; Dir.night{a} = 2; Dir.subject{a} = 23;  % 06/10/2016 -> Subject 23
        Dir.channel_sw{a} = [1 2 7 10];
        
        %bad quality
%         a=a+1; Dir.filereference{a} = 29266;
%         Dir.date{a} = '03102016'; Dir.night{a} = 3; Dir.subject{a} = 24;  % 03/10/2016 -> Subject 24
%         Dir.channel_sw{a} = [1 2 7 10];
        
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Random condition
    a=0;
    if strcmpi(experiment,'Random')
        a=a+1; Dir.filereference{a} = 29257; %28441
        Dir.date{a} = '03102016'; Dir.night{a} = 3; Dir.subject{a} = 2;  % 03/10/2016 -> Subject 2
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 26823;
        Dir.date{a} = '26092016'; Dir.night{a} = 2; Dir.subject{a} = 3;  % 26/09/2016 -> Subject 3
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 29247;
        Dir.date{a} = '26092016'; Dir.night{a} = 2; Dir.subject{a} = 4;  % 26/09/2016 -> Subject 4
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28461;
        Dir.date{a} = '18102016'; Dir.night{a} = 4; Dir.subject{a} = 5;  % 18/10/2016 -> Subject 5
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 26663;
        Dir.date{a} = '04102016'; Dir.night{a} = 3; Dir.subject{a} = 7;  % 04/10/2016 -> Subject 7
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28182;
        Dir.date{a} = '04102016'; Dir.night{a} = 3; Dir.subject{a} = 8;  % 04/10/2016 -> Subject 8
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27922;
        Dir.date{a} = '27092016'; Dir.night{a} = 2; Dir.subject{a} = 9;  % 27/09/2016 -> Subject 9
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28184;
        Dir.date{a} = '27092016'; Dir.night{a} = 2; Dir.subject{a} = 10;  % 27/09/2016 -> Subject 10
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27925;
        Dir.date{a} = '17102016'; Dir.night{a} = 4; Dir.subject{a} = 11;  % 17/10/2016 -> Subject 11
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27041;
        Dir.date{a} = '18102016'; Dir.night{a} = 4; Dir.subject{a} = 12;  % 18/10/2016 -> Subject 12
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28189;
        Dir.date{a} = '05102016'; Dir.night{a} = 3; Dir.subject{a} = 13;  % 05/10/2016 -> Subject 13
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 26833; %25428
        Dir.date{a} = '05102016'; Dir.night{a} = 3; Dir.subject{a} = 14;  % 05/10/2016 -> Subject 14
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28084;
        Dir.date{a} = '28092016'; Dir.night{a} = 2; Dir.subject{a} = 16;  % 28/09/2016 -> Subject 16
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27033;
        Dir.date{a} = '12102016'; Dir.night{a} = 4; Dir.subject{a} = 17;  % 12/10/2016 -> Subject 17
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27913; %25440
        Dir.date{a} = '06102016'; Dir.night{a} = 3; Dir.subject{a} = 19;  % 06/10/2016 -> Subject 19
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27920;
        Dir.date{a} = '06102016'; Dir.night{a} = 3; Dir.subject{a} = 20;  % 06/10/2016 -> Subject 20
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28444;
        Dir.date{a} = '29092016'; Dir.night{a} = 2; Dir.subject{a} = 21;  % 29/09/2016 -> Subject 21
        Dir.channel_sw{a} = [1 2 7 10];
        
        %bad quality
%         a=a+1; Dir.filereference{a} = 27931;
%         Dir.date{a} = '29092016'; Dir.night{a} = 2; Dir.subject{a} = 22;  % 29/09/2016 -> Subject 22
%         Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27022;
        Dir.date{a} = '13102016'; Dir.night{a} = 3; Dir.subject{a} = 23;  % 13/10/2016 -> Subject 23
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28293; %25460
        Dir.date{a} = '10102016'; Dir.night{a} = 4; Dir.subject{a} = 24;  % 10/10/2016 -> Subject 24
        Dir.channel_sw{a} = [1 2 7 10];
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Up Phase condition
    a=0;
    if strcmpi(experiment,'UpPhase')
        a=a+1; Dir.filereference{a} = 28455;
        Dir.date{a} = '10102016'; Dir.night{a} = 4; Dir.subject{a} = 2;  % 10/10/2016 -> Subject 2
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27024;
        Dir.date{a} = '03102016'; Dir.night{a} = 3; Dir.subject{a} = 3;  % 03/10/2016 -> Subject 3
        Dir.channel_sw{a} = [1 2 7 10];
        
        %error ?
        a=a+1; Dir.filereference{a} = 29265;
        Dir.date{a} = '03102016'; Dir.night{a} = 3; Dir.subject{a} = 4;  % 03/10/2016 -> Subject 4
        Dir.channel_sw{a} = [1 2 7 10];
        
        %error ?
        a=a+1; Dir.filereference{a} = 27921;
        Dir.date{a} = '26092016'; Dir.night{a} = 2; Dir.subject{a} = 5;  % 26/09/2016 -> Subject 5
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 26664;
        Dir.date{a} = '11102016'; Dir.night{a} = 4; Dir.subject{a} = 7;  % 11/10/2016 -> Subject 7
        Dir.channel_sw{a} = [1 2 7 10];
        
        %TODO
        a=a+1; Dir.filereference{a} = 29267;
        Dir.date{a} = '11102016'; Dir.night{a} = 4; Dir.subject{a} = 8;  % 11/10/2016 -> Subject 8
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28187;
        Dir.date{a} = '04102016'; Dir.night{a} = 3; Dir.subject{a} = 9;  % 04/10/2016 -> Subject 9
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 26671;
        Dir.date{a} = '04102016'; Dir.night{a} = 3; Dir.subject{a} = 10;  % 04/10/2016 -> Subject 10
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27924;
        Dir.date{a} = '27092016'; Dir.night{a} = 2; Dir.subject{a} = 11;  % 27/09/2016 -> Subject 11
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27926;
        Dir.date{a} = '11102016'; Dir.night{a} = 2; Dir.subject{a} = 12;  %  11/10/2016 -> Subject 12
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28169;
        Dir.date{a} = '12102016'; Dir.night{a} = 4; Dir.subject{a} = 13;  % 12/10/2016 -> Subject 13
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27937;
        Dir.date{a} = '12102016'; Dir.night{a} = 4; Dir.subject{a} = 14;  % 12/10/2016 -> Subject 14
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 29264;
        Dir.date{a} = '05102016'; Dir.night{a} = 2; Dir.subject{a} = 16;  % 05/10/2016 -> Subject 16
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27912;
        Dir.date{a} = '28092016'; Dir.night{a} = 2; Dir.subject{a} = 17;  % 28/09/2016 -> Subject 17
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27914;
        Dir.date{a} = '13102016'; Dir.night{a} = 4; Dir.subject{a} = 19;  % 13/10/2016 -> Subject 19
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28425;
        Dir.date{a} = '13102016'; Dir.night{a} = 4; Dir.subject{a} = 20;  % 13/10/2016 -> Subject 20
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 28177;
        Dir.date{a} = '06102016'; Dir.night{a} = 3; Dir.subject{a} = 21;  % 06/10/2016 -> Subject 21
        Dir.channel_sw{a} = [1 2 7 10];
        
        %awful
        a=a+1; Dir.filereference{a} = 27038;
        Dir.date{a} = '06102016'; Dir.night{a} = 3; Dir.subject{a} = 22;  % 06/10/2016 -> Subject 22
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27919;
        Dir.date{a} = '17102016'; Dir.night{a} = 4; Dir.subject{a} = 23;  % 17/10/2016 -> Subject 23
        Dir.channel_sw{a} = [1 2 7 10];
        
        a=a+1; Dir.filereference{a} = 27936;
        Dir.date{a} = '26092016'; Dir.night{a} = 2; Dir.subject{a} = 24;  % 26/09/2016 -> Subject 24
        Dir.channel_sw{a} = [1 2 7 10];
        
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Generic
    if isfield(Dir,'filereference')
        %% filenames ref
        for i=1:length(Dir.filereference)
            Dir.filename{i}= [Dir.folder_record num2str(Dir.filereference{i}) '.h5'];
        end

        %% Process folder
        for i=1:length(Dir.filereference)
            Dir.processing{i}= [Dir.folder_process num2str(Dir.filereference{i}) '/'];
        end

        %% Condition
        for i=1:length(Dir.filereference)
            Dir.condition{i}= experiment;
        end       
    end

end

end




