clear all
BaseName='ProjectEmbReact_M';
% To fill in - general mouse information
SaveFolderName=uigetdir('','please provide Save Folder')
cd(SaveFolderName)
load('ExpeInfo.mat')

if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end

Response = inputdlg({'ExperimentDay','CalibrationDay','BaselineSleepDays','Calibration Int','Calibration dur','DrugInjected'},...
    'Inputs for EMbrReactFolders',1,{'YYYYMMDD','YYYYMMDD','{''YYYYMMDD'',''YYYYMMDD''}','[0,1,1.5,2,2.5,3]','[200,200,200,200,200,200]','DIAZEPAM/MIDAZOLAM/FLUOXETINE/SALINE'});

% Mouse and date info
Dates.BigExpe=(Response{1});
Dates.Calibration=(Response{2});
Dates.BaselineSleep=(Response{3});
StimInt=eval(Response{4});
StimDur=eval(Response{5});
ExpeInfo.DrugInjected=(Response{6});


%% Create folders for the task
if not(isempty(Dates.BigExpe))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.BigExpe;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.RecordingRoom =  'UMaze';
   % FolderName=OrganizeFilesEmbReact_PAG_Mice_BM2(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
   % FolderName=OrganizeFilesEmbReact_SecondDay_BM(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
%    FolderName=OrganizeFilesEmbReactNewProtocolSB_FLXbisV2(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
    FolderName=OrganizeFilesEmbReactNewProtocolBM(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
  %  FolderName=OrganizeFilesEmbReactNewProtocol_VeryShort_BM(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
  %  FolderName=OrganizeFilesEmbReact_MFB_Mice_BM(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ExpeInfo)
    disp('Now fill in your folders with correct files')
end
AllFold=length(FolderName)+1;

%% Create folders for the calibration
if not(isempty(Dates.Calibration))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.Calibration;
    mkdir(num2str(ExpeInfo.date))
    ExpeInfo.SleepSession=0;
    ExpeInfo.SessionType='Calibration';
    ExpeInfo.RecordingRoom =  'SmallOpenField';
    
    for e=1:length(StimInt)
        cd([SaveFolderName num2str(ExpeInfo.date) filesep])
        mkdir([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_Calibration_',strrep(num2str(StimInt(e)),'.',','),'V_',num2str(StimDur(e)),'ms']);
        cd([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_Calibration_',strrep(num2str(StimInt(e)),'.',','),'V_',num2str(StimDur(e)),'ms']);
        
        ExpeInfo.StimulationInt=StimInt(e);
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

%% Create folders for baseline sleep

if not(isempty(Dates.BaselineSleep))
    Dates.BaselineSleep = eval(Dates.BaselineSleep)
    for k=1:length(Dates.BaselineSleep)
        cd(SaveFolderName)
        ExpeInfo.date=Dates.BaselineSleep{k};
        mkdir(num2str(ExpeInfo.date))
        ExpeInfo.StimulationInt=0;
        ExpeInfo.SessionNumber=0;
        ExpeInfo.SessionType='BaselineSleep';
        ExpeInfo.RecordingRoom =  'Homecage';
        ExpeInfo.SleepSession=1;
        cd([SaveFolderName num2str(ExpeInfo.date) filesep])
        mkdir([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_BaselineSleep'])
        cd([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_BaselineSleep'])
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


