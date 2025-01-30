clear all
BaseName='ProjectEmbReact_M';
% To fill in - general mouse information
SaveFolderName=uigetdir('','please provide Save Folder')
cd(SaveFolderName)
load('ExpeInfo.mat')

if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

Response = inputdlg({'CalibrationVHCDay','CalibrationEyelidDay','ExperimentDay','Calibration VHC Int','Calibration VHC dur','Calibration Eyelid Int','Calibration Eyelid dur'},...
    'Inputs for EMbrReactFolders',1,{'YYYYMMDD','YYYYMMDD','YYYYMMDD','[20,0,.5,1,1.5,2,2.5,3]','[1,1,1,1,1,1,1,1]','[0,1,1.5,2,2.5,3]','[200,200,200,200,200,200]'});

% Mouse and date info
Dates.CalibrationVHC=(Response{1});
Dates.CalibrationEyelid=(Response{2});
Dates.BigExpe=(Response{3});
StimIntVHC=eval(Response{4});
StimDurVHC=eval(Response{5});
StimIntEyelid=eval(Response{6});
StimDurEyelid=eval(Response{7});


%% Create folders for the task
if not(isempty(Dates.BigExpe))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.BigExpe;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.RecordingRoom =  'UMaze';
%     FolderName=OrganizeFilesEmbReactAtropineProtocol_CH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
    FolderName=OrganizeFilesEmbReactNewProtocolSB_FLXbisV2(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
%     FolderName=OrganizeFilesEmbReactRipInhibSleep_CH(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
end
AllFold=length(FolderName)+1;

%% Create folders for eyelid calib
if not(isempty(Dates.CalibrationEyelid))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.CalibrationEyelid;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.SleepSession=0;
    ExpeInfo.SessionType='Calibration';
    ExpeInfo.RecordingRoom =  'SmallOpenField';
    
    for e=1:length(StimIntEyelid)
        cd([SaveFolderName num2str(ExpeInfo.date) filesep])
        mkdir([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_CalibrationEyelid_',strrep(num2str(StimIntEyelid(e)),'.',','),'V_',num2str(StimDurEyelid(e)),'ms']);
        cd([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_CalibrationEyelid_',strrep(num2str(StimIntEyelid(e)),'.',','),'V_',num2str(StimDurEyelid(e)),'ms']);
        
        ExpeInfo.StimulationInt=StimIntEyelid(e);
        ExpeInfo.SessionNumber=e;
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
        cd ..
    end
    disp('Now fill in your folders with correct files')
end


for f=1:length(FolderName)
    FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
end




%% Create folders for VHC calib
if not(isempty(Dates.CalibrationVHC))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.CalibrationVHC;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.SleepSession=0;
    ExpeInfo.SessionType='Calibration';
    ExpeInfo.RecordingRoom =  'SmallOpenField';
    
    for e=1:length(StimIntVHC)
        cd([SaveFolderName num2str(ExpeInfo.date) filesep])
        mkdir([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_CalibrationVHC_',strrep(num2str(StimIntVHC(e)),'.',','),'V_',num2str(StimDurVHC(e)),'ms']);
        cd([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_CalibrationVHC_',strrep(num2str(StimIntVHC(e)),'.',','),'V_',num2str(StimDurVHC(e)),'ms']);
        
        ExpeInfo.StimulationInt=StimIntVHC(e);
        ExpeInfo.SessionNumber=e;
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
        cd ..
    end
    disp('Now fill in your folders with correct files')
end

for f=1:length(FolderName)
    FolderName{f}=strrep(FolderName{f},SaveFolderName,'/');
end

