function FolderName=OrganizeFilesNicotineETMCH(MouseNum,Date,SaveFolderName,ExpeInfo)
% This organizes the files for the Nicotine ETM
AllFold=1;
if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

BaseName='NicotineETM_M';
ExperimentalConditions={'ClosedArm' 'OpenArm'};

cd([SaveFolderName filesep num2str(Date)])
mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_Sleep']);
cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_Sleep']);
MakeIntFiles;

cd([SaveFolderName filesep num2str(Date)])
mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_ETM']);


for e=1:length(ExperimentalConditions)
    cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_ETM']);
    ExpeInfo.SessionType=ExperimentalConditions{e};
    %     ExpeInfo.SleepSession=IsSleep(e);
    
    mkdir([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}]);
    cd([BaseName,num2str(MouseNum),'_',num2str(Date),'_',ExperimentalConditions{e}])
    if strcmp(ExperimentalConditions{e},'ClosedArm')
        for i=1:5
            mkdir(['Sess',num2str(i)])
            cd(['Sess',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    elseif strcmp(ExperimentalConditions{e},'OpenArm')
        for i=1:5
            mkdir(['Sess',num2str(i)])
            cd(['Sess',num2str(i)])
            ExpeInfo.SessionNumber=i; % if repeated sessions ie conditionning; 0 otherwise
            MakeIntFiles;
            cd ..
        end
    end
cd([SaveFolderName filesep num2str(Date)])
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