function FolderName=OrganizeFilesEmbReact_PAG_Mice_BM(MouseNum,Date,SaveFolderName,ExpeInfo)
% This organizes the files for the new protocol
AllFold=1;
if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

BaseName='ProjectEmbReact_M';
ExperimentalConditions={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'TestPre_PreDrug' 'UMazeCondExplo_PreDrug', ...
    'Recover_From_Drug' 'UMazeCondExplo_PostDrug',...
    'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'Recall_PostDrug'};

IsSleep=zeros(12,1);
IsSleep(8)=1;

for e=1:length(ExperimentalConditions)
    cd(SaveFolderName)
    ExpeInfo.SessionType=ExperimentalConditions{e};
    ExpeInfo.SleepSession=IsSleep(e);
    
    mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}]);
    cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}])
    if strcmp(ExperimentalConditions{e},'Habituation24HPre_PreDrug')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Habituation_PreDrug')
        for i=1:4
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'TestPre_PreDrug')
        for i=1:4
            mkdir(['TestPre',num2str(i)])
            cd(['TestPre',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'TestPost_PostDrug')
        for i=1:4
            mkdir(['TestPost',num2str(i)])
            cd(['TestPost',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondExplo_PreDrug')
        for i=1:7
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondExplo_PostDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'ExtinctionBlockedShock_PostDrug')
        for i=1:4
            mkdir(['Ext',num2str(i)])
            cd(['Ext',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'ExtinctionBlockedSafe_PostDrug')
        for i=1:4
            mkdir(['Ext',num2str(i)])
            cd(['Ext',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Recall_PostDrug')
        for i=1:3
            mkdir(['Recall',num2str(i)])
            cd(['Recall',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
        
    else
        MakeIntFiles;
        ExpeInfo.SessionNumber=0; % if repeated sessions ie conditionning; 0 otherwise
    end
end

    function MakeIntFiles
        save makedataBulbeInputs
        mkdir('raw')
        
        % Create the xml
        WriteExpeInfoToXml(ExpeInfo)
        %% create lfp and channels to analyse folders
        InfoLFP = ExpeInfo.InfoLFP;
        mkdir('LFPData')
        save('LFPData/InfoLFP.mat','InfoLFP')
        
        
        mkdir('ChannelsToAnalyse');
        if isfield(ExpeInfo,'ChannelToAnalyse')
            AllStructures = fieldnames(ExpeInfo.ChannelToAnalyse);
            for stru=1:length(AllStructures)
                channel = ExpeInfo.ChannelToAnalyse.(AllStructures{stru});
                save(['ChannelsToAnalyse/',AllStructures{stru},'.mat'],'channel');
            end
        end
        
        
        save('ExpeInfo.mat','ExpeInfo');
        FolderName{AllFold}=cd;
        AllFold=AllFold+1;
    end

end
