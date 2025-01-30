clear all
GetBasicInfoSB

ChannelsToAnalyseLocation=uigetdir('','please provide ChannelsToAnalyzeFolder')
[InfoLFPFile,PathName]=uigetfile('','please show the InfoLFP file')
load([PathName InfoLFPFile])
[makeDataInputsFile,PathName]=uigetfile('','please show the MakeDataInputs file')
load([PathName makeDataInputsFile])

Response = inputdlg({'Mouse Number','Stim Type (PAG,Eyeshock,MFB)','ExperimentDay','CalibrationDay','BaselineSleepDays',...
    'Ripples','DeltaPF [sup (delta down) deep (delta up)]','SpindlePF','Calibration Int','Calibration dur','DrugInjected'},'Inputs for EMbrReactFolders',1);
% Mouse and date info
ExpeInfo.nmouse=eval(Response{1});
Dates.BigExpe=eval(Response{3});
Dates.Calibration=eval(Response{4});
ExpeInfo.DrugInjected=eval(Response{11});

% Ephys info
ExpeInfo.StimElecs=Response{2}; % PAG or MFB or Eyeshock
ExpeInfo.Ripples=eval(Response{6}); % give channel
ExpeInfo.DeltaPF=eval(Response{7}); % give sup (delta down) the deep (delta up)
ExpeInfo.SpindlePF=eval(Response{8}); % give channel

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

ExpeInfo.date=Dates.Calibration;
ExpeInfo.SleepSession=1;
ExpeInfo.SessionType='SleepPlethysmo';
save('ExpeInfo.mat','ExpeInfo');

MakeData_Main_SB


SleepScoring_Accelero_OBgamma

if exist('SpikeData.mat')>0
    CreateSpikeToAnalyse_KJ
    load('MeanWaveform.mat')
    [UnitID,AllParamsNew,WFInfo,BestElec,figid] = MakeData_ClassifySpikeWaveforms(W,'/home/vador/Dropbox/Kteam',1)
end

%% Sleep event
CreateSleepSignals('recompute',0,'scoring','accelero');

%% Substages
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','accelero');
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
save('SleepSubstages', 'Epoch', 'NameEpoch')

%% Id figure 1
MakeIDSleepData('recompute',1);
PlotIDSleepData
saveas(1,'IDFig1.png')
close all

%% Id figure 2
MakeIDSleepData2('recompute',1);
PlotIDSleepData2
saveas(1,'IDFig2.png')
close all