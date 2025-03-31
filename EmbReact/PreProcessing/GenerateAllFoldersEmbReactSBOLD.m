clear all
BaseName='ProjectEmbReact_M';
% To fill in - general mouse information
SaveFolderName=uigetdir('','please provide Save Folder')
if ~(SaveFolderName(end)==filesep),SaveFolderName=[SaveFolderName filesep]; end
ChannelsToAnalyseLocation=uigetdir('','please provide ChannelsToAnalyzeFolder')
if ~(ChannelsToAnalyseLocation(end)==filesep),ChannelsToAnalyseLocation=[ChannelsToAnalyseLocation filesep]; end
[InfoLFPFile,PathName]=uigetfile('','please show the InfoLFP file')
load([PathName InfoLFPFile])

answer = inputdlg({'Mouse Number','Stim Type (PAG,Eyeshock,MFB)','ExperimentDay','CalibrationDay','BaselineSleepDays',...
    'Ripples','DeltaPF [sup (delta down) deep (delta up)]','SpindlePF'},'Inputs for EMbrReactFolders',1);
% Mouse and date info
ExpeInfo.nmouse=eval(answer{1});
Dates.BigExpe=eval(answer{3});
Dates.Calibration=eval(answer{4});
Dates.BaselineSleep=eval(answer{5});

% Ephys info
ExpeInfo.StimElecs=answer{2}; % PAG or MFB or Eyeshock
ExpeInfo.Ripples=eval(answer{6});; % give channel
ExpeInfo.DeltaPF=eval(answer{7});; % give sup (delta down) the deep (delta up)
ExpeInfo.SpindlePF=eval(answer{8});; % give channel

% Implantation info
ExpeInfo.RecordElecs=InfoLFP;

cd(ChannelsToAnalyseLocation)
FileInfo=dir('*.mat');
for f=1:size(FileInfo,1)
    load(FileInfo(f).name)
    eval(['ExpeInfo.ChannelsToAnalyse.',FileInfo(f).name(1:end-4),'=channel;'])
end


% Mouse characteristics
ExpeInfo.VirusInjected={};
ExpeInfo.OptoStimulation=0;
ExpeInfo.StimulationInt=0;
ExpeInfo.MouseStrain='C57Bl6';


%% Create folders for the task
if not(isempty(Dates.BigExpe))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.BigExpe;
    mkdir(num2str(ExpeInfo.date))
    OrganizeFilesEmbReactSB(ExpeInfo.nmouse,ExpeInfo.date,[SaveFolderName num2str(ExpeInfo.date) filesep],ChannelsToAnalyseLocation,InfoLFP,ExpeInfo)
    disp('Now fill in your folders with correct files')
end

%% Create folders for the calibration
if not(isempty(Dates.Calibration))
    cd(SaveFolderName)
    ExpeInfo.date=Dates.Calibration;
    mkdir(num2str(ExpeInfo.date))
    StimInt=[0,1,2,3,4];
    StimDur=[200,200,200,200,200];
    ExpeInfo.SleepSession=0;
    ExpeInfo.SessionType='Calibration';
    for e=1:length(StimInt)
        cd([SaveFolderName num2str(ExpeInfo.date) filesep])
        mkdir([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_Calibration_',num2str(StimInt(e)),'V_',num2str(StimDur(e)),'ms']);
        cd([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_Calibration_',num2str(StimInt(e)),'V_',num2str(StimDur(e)),'ms']);
        ExpeInfo.StimulationInt=StimInt(e);
        ExpeInfo.SessionNumber=e;
        mkdir('raw')
        mkdir('LFPData')
        mkdir('ChannelsToAnalyse')
        save('LFPData/InfoLFP.mat','InfoLFP')
        copyfile(ChannelsToAnalyseLocation,...
            [cd filesep 'ChannelsToAnalyse/']);
        save('ExpeInfo.mat','ExpeInfo');
        cd ..
    end
    disp('Now fill in your folders with correct files')
end

%% Create folders for baseline sleep

if not(isempty(Dates.BaselineSleep))
    for k=1:length(Dates.BaselineSleep)
        cd(SaveFolderName)
        ExpeInfo.date=Dates.BaselineSleep(k);
        mkdir(num2str(ExpeInfo.date))
        ExpeInfo.StimulationInt=0;
        ExpeInfo.SessionNumber=0;
        ExpeInfo.SessionType='BaselineSleep';
        ExpeInfo.SleepSession=1;
        cd([SaveFolderName num2str(ExpeInfo.date) filesep])
        mkdir([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_BaselineSleep'])
        cd([BaseName,num2str(ExpeInfo.nmouse),'_',num2str(ExpeInfo.date),'_BaselineSleep'])
        mkdir('raw')
        mkdir('LFPData')
        mkdir('ChannelsToAnalyse')
        save('LFPData/InfoLFP.mat','InfoLFP')
        copyfile(ChannelsToAnalyseLocation,...
            [cd filesep 'ChannelsToAnalyse/']);
        save('ExpeInfo.mat','ExpeInfo');
        cd ..
    end
    disp('Now fill in your folders with correct files')
end

