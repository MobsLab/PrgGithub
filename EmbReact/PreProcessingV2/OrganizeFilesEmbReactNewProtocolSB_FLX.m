function FolderName=OrganizeFilesEmbReactNewProtocolSB_FLX(MouseNum,Date,SaveFolderName,ChannelsToAnalyseLocation,InfoLFP,ExpeInfo,answer,answerdigin,XMLToCopy,XMLToCopySpike)
% This organizes the files for the new protocol
AllFold=1;
if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

BaseName='ProjectEmbReact_M';
ExperimentalConditions={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
    'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
    'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
    'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

IsSleep=zeros(18,1);
IsSleep(5)=1;IsSleep(10)=1;IsSleep(14)=1;

for e=1:length(ExperimentalConditions)
    cd(SaveFolderName)
    ExpeInfo.SessionType=ExperimentalConditions{e};
    ExpeInfo.SleepSession=IsSleep(e);
    
    mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}]);
    cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}])
    if strcmp(ExperimentalConditions{e},'TestPre_PreDrug')
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
    elseif strcmp(ExperimentalConditions{e},'Habituation24HPre_PreDrug')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Habituation_PreDrug')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondExplo_PreDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedShock_PreDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedSafe_PreDrug')
        for i=1:2
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
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedShock_PostDrug')
        for i=1:2
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedSafe_PostDrug')
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
        
    else
        MakeIntFiles;
        ExpeInfo.SessionNumber=0; % if repeated sessions ie conditionning; 0 otherwise
    end
end

    function MakeIntFiles
        save makedataBulbeInputs answer answerdigin
        mkdir('raw')
        mkdir('LFPData')
        mkdir('ChannelsToAnalyse')
        save('LFPData/InfoLFP.mat','InfoLFP')
        copyfile(ChannelsToAnalyseLocation,...
            [cd filesep 'ChannelsToAnalyse/']);
        save('ExpeInfo.mat','ExpeInfo');
        copyfile(XMLToCopy)
        copyfile(XMLToCopySpike)
        FolderName{AllFold}=cd;
        AllFold=AllFold+1;
    end

end
