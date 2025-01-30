function FolderName=OrganizeFilesEmbReactNewProtocolSB(MouseNum,Date,SaveFolderName,ChannelsToAnalyseLocation,InfoLFP,ExpeInfo,answer,answerdigin,XMLToCopy,XMLToCopySpike)
% This organizes the files for the new protocol
AllFold=1;
if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

BaseName='ProjectEmbReact_M';
ExperimentalConditions={'Habituation24HPre' 'Habituation' 'HabituationBlockedShock' 'HabituationBlockedSafe' 'SleepPre' 'TestPre' 'UMazeCondExplo' 'UMazeCondBlockedShock' 'UMazeCondBlockedSafe' ...
    'SleepPost' 'TestPost'  'ExtinctionBlockedShock' 'ExtinctionBlockedSafe' 'Extinction'};
IsSleep=[0,0,0,0,1,0,0,0,0,1,0,0,0,0];

for e=1:length(ExperimentalConditions)
    cd(SaveFolderName)
    ExpeInfo.SessionType=ExperimentalConditions{e};
    ExpeInfo.SleepSession=IsSleep(e);
    
    mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}]);
    cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}])
    if strcmp(ExperimentalConditions{e},'TestPre')
        for i=1:4
            mkdir(['TestPre',num2str(i)])
            cd(['TestPre',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'TestPost')
        for i=1:4
            mkdir(['TestPost',num2str(i)])
            cd(['TestPost',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
        
    elseif strcmp(ExperimentalConditions{e},'Habituation24HPre')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'Habituation')
        for i=1:2
            mkdir(['Hab',num2str(i)])
            cd(['Hab',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondExplo')
        for i=1:3
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedShock')
        for i=1:3
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'UMazeCondBlockedSafe')
        for i=1:3
            mkdir(['Cond',num2str(i)])
            cd(['Cond',num2str(i)])
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
