


%DRUG EXPERIMENT
SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'SleepPre_PreDrug' 'SleepPost_PreDrug' 'SleepPost_PostDrug'};

Dir_All_mice= Dir;

for mice=1:length(Dir.path)
    
    path_to_use = Dir_All_mice.path{1, mice}{1, 1}  ;
    newStr = extractBetween(path_to_use,'Mouse','/');
    Mouse_numb= ['Mouse' newStr{1}];
    mkdir(Mouse_numb)
    
%     cd([pwd filesep Mouse_numb])
%     
%      date = extractBetween(path_to_use,[Mouse_numb filesep],'/');
% %     mkdir(date)
%      
%      Folder_Name = extractBetween(path_to_use,[Mouse_numb filesep],'/');

    
    
end


for mice=11:length(Dir.path)
    try
        path_to_use = Dir_All_mice.path{1, mice}{1, 1}  ;
        newStr = extractBetween(path_to_use,'Mouse','/');
        Mouse_numb= ['Mouse' newStr{1}];
        %mkdir(Mouse_numb)
        
        %cd([pwd filesep Mouse_numb])
        
        date = extractBetween(path_to_use,[Mouse_numb filesep],'/');
        %     mkdir(date)
        
        %   Folder_Name = extractBetween(path_to_use,[Mouse_numb filesep],'/');
        
        path_date=extractBetween(path_to_use,'/',date)
        cd([filesep path_date{1}])
        
        Path_to_go = ['/media/mobsmorty/One Touch/Data_KB/' Mouse_numb]
        
        copyfile('AllFolderNames.mat',Path_to_go)
        
    end
    
    cd('/media/mobsmorty/One Touch/Data_KB')
end



for mice=29:length(Dir.path)
    try
        path_to_use = Dir_All_mice.path{1, mice}{1, 1}  ;
        newStr = extractBetween(path_to_use,'Mouse','/');
        Mouse_numb= ['Mouse' newStr{1}];
        %mkdir(Mouse_numb)
        
        cd([pwd filesep Mouse_numb])
        
        load('AllFolderNames.mat')
        
        ExpeInfo.date=Dir.ExpeInfo{1, mice}{1, 1}.date  ;
        mkdir(num2str(ExpeInfo.date))
        


BaseName='ProjectEmbReact_M';
ExperimentalConditions={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre',...
    'TestPre_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'SleepPost',...
    'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'Recall_PostDrug'};



MouseNum = Dir.ExpeInfo{1, mice}{1, 1}.nmouse  ;
Date = Dir.ExpeInfo{1, mice}{1, 1}.date;
SaveFolderName=[cd filesep Date];

for e=1:length(ExperimentalConditions)
    cd(SaveFolderName)
    ExpeInfo.SessionType=ExperimentalConditions{e};
    
    mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}]);
    cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}])
    if strcmp(ExperimentalConditions{e},'TestPre_PreDrug')
        for i=1:4
            mkdir(['TestPre',num2str(i)])
            cd(['TestPre',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'TestPost_PostDrug')
        for i=1:4
            mkdir(['TestPost',num2str(i)])
            cd(['TestPost',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Habituation24HPre_PreDrug')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Habituation_PreDrug')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondExplo_PreDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedShock_PreDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedSafe_PreDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondExplo_PostDrug')
        for i=1:3
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedShock_PostDrug')
        for i=1:3
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedSafe_PostDrug')
        for i=1:3
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
        elseif strcmp(ExperimentalConditions{e},'ExtinctionBlockedShock_PostDrug')
        for i=1:2
            mkdir(['Ext',num2str(i)])
            cd(['Ext',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
        elseif strcmp(ExperimentalConditions{e},'ExtinctionBlockedSafe_PostDrug')
        for i=1:2
            mkdir(['Ext',num2str(i)])
            cd(['Ext',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Recall_PostDrug')
        for i=1
            mkdir(['Recall',num2str(i)])
            cd(['Recall',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            ;
            cd ..
        end
        
    else
        ;
        ExpeInfo.SessionNumber=0; % if repeated sessions ie conditionning; 0 otherwise
    end
end



    end
    cd('/media/mobsmorty/One Touch/Data_KB')
    
end





















