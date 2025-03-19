function OrganizeFilesEmbReactSB(MouseNum,Date,SaveFolderName,ChannelsToAnalyseLocation,InfoLFP,ExpeInfo)

if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

BaseName='ProjectEmbReact_M';
ExperimentalConditions={'EPM','Habituation' 'SleepPre' 'TestPre' 'UMazeCond' 'SleepPost' 'TestPost' 'Extinction'...
    'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest'};
IsSleep=[0,1,0,0,1,0,0,0,1,0,1,0];

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
    elseif strcmp(ExperimentalConditions{e},'UMazeCond')
        for i=1:5
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
        mkdir('raw')
        mkdir('LFPData')
        mkdir('ChannelsToAnalyse')
        save('LFPData/InfoLFP.mat','InfoLFP')
        copyfile(ChannelsToAnalyseLocation,...
            [cd filesep 'ChannelsToAnalyse/']);
        save('ExpeInfo.mat','ExpeInfo');
    end
end