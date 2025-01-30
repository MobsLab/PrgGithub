function Dir=PathForExperiments_Opto_MC(experiment)

% INPUT:
% name of the experiment.
% possible choices:
%'PFC_Baseline_20Hz'
%'PFC_Stim_20Hz': optogenetic protocol (stimulations: 20Hz 30s)
%'PFC_Sham_20Hz': optogenetic procotol in mice with ChR2 but with light OFF
%'PFC_Control_20Hz': optogenetic protocol in mice without ChR2

% this pathforexperiment also includes the septum experiments (same as
% previously but for Septum-VLPO pathway.
%'Septum_Baseline_20Hz' ??
%'Septum_Sham_20Hz'
%'Septum_Stim_20Hz'

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manip) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperiments_MC('BASAL');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
%lHav
% 
%   restrict Dir to mice or group:
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246])
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'})
% Dir=RestrictPathForExperiment(Dir,'Group','OBX')
%
% similar functions:
% PathForExperimentFEAR.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m PathForExperimentsKBnew.m
% PathForExperimentsML.m

%% Path
a=0;
I_CA=[];

%%
if strcmp(experiment,'PFC_Baseline')
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/20180215/M648_Baselinesleep_180215_095425/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M675_processed/20180215/M675_Baseline_180215/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M733_processed/20180524/M733_Baseline_ProtoSleep_1min_180524_103728/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1076
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/20200727/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1109
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1109/20200924/BaselineSleep/Opto_PFC_VLPO_1109_Baseline_200924_091530/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    
elseif strcmp(experiment,'PFC_Control_20Hz')
    %Mouse1075
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1075_processed/Opto_PFC_VLPO_1075_OptoSleep_Control_200703_092733/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1111
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1111/20201001/Sleep_OptoStimulation20Hz30s/Opto_PFC_VLPO_1111_OptoSleep20Hz_30s_201001_090048/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1112
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1112/20200930/Sleep_OptoStimulation20Hz30s/Opto_PFC_VLPO_1112_Opto20Hz_30s_200930_122249/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse1179
%     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1179/20210324/Sleep_OptoStimulation20Hz30s/OPTO_1179_optoStim20Hz30s_210324_085109/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1180
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1180/20210325/Sleep_OptoStimulation20Hz30s/OPTO_1180_optoStim20Hz30s_210325_090709/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1181
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1181/20210326/Sleep_OptoStimulation20Hz30s/OPTO_1181_optoStim20Hz30s_210326_090432/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    
elseif strcmp(experiment,'PFC_Stim_20Hz')
    %Mouse648
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M648_processed/20180216/M648_opto20Hz_180216_094032/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse675
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M675_processed/20180219/M675_Optostim20Hz_180219/VLPO_675_Optostim20Hz_180219_102539/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse733
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M733_processed/20180511/M733_Stim_ProtoSleep_1min_180511_103535/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
   %Mouse1074
   a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1074_processed/20200630/Opto_PFC_VLPO_1074_OptoSleep_200630_091210/';
   load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1076
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1076_processed/20200702/Opto_PFC_VLPO_1076_OptoSleep_200702_094338/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1109
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1109/20200925/Sleep_OptoStimulation20Hz30s/Opto_PFC_VLPO_1109_OptoSleep20Hz_30s_Sleep_200925_092218/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1136
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1136/20201210/Sleep_OptoStimulation20Hz30s/OPTO_1136_opto20Hz30s_201210_090446/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse 
    %Mouse1137
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1137/20201209/Sleep_OptoStimulations20Hz30s/OPTO_1137_opto20Hz30s_201209_092118/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse     
     
    
        %Mouse1388
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1388_20Hz30s_wake_1389_baseline_221213_093357/1388/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse  
    
    
elseif strcmp(experiment,'stim_wake')
%     %Mouse1367
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS167/OPTO_1367_opto20Hz30s_220926_081120/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
%     %Mouse1369
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS167/OPTO_1369_opto20Hz30s_220923_081901/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
%     %Mouse1370
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS167/OPTO_1370_opto20Hz30s_220927_082509/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    
    
    %Mouse1387
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1387_20Hz30s_wake_221216_082529/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1388
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1388_20Hz30s_wake_1389_baseline_221213_093357/1388/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse    
    %Mouse1389
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1389_20Hz30s_wake_1390_baseline_221214_083333/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1390
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1390_20Hz30s_wake_1387_baseline_221215_082051/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse


elseif strcmp(experiment,'sham_wake')
%     %Mouse1367
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS167/OPTO_1367_sham_221003_081431/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
%     %Mouse1369
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS167/OPTO_1369_sham_220928_083039/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
%     %Mouse1370
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS167/OPTO_1370_sham_221005_081349/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    
    
    
    %Mouse1387
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1387_sham_wake_221222_085054/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1388
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1388_sham_wake_221220_082308/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse    
    %Mouse1389
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1389_sham_wake_221219_082708/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse
    %Mouse1390
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS175/OPTO_1390_sham_wake_221221_083448/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse    
    
    
    
%==========================================================================
%                         SEPTUM-VLPO EXPERIMENTS   
%==========================================================================

elseif strcmp(experiment,'Septum_Sham_20Hz')
    %Mouse1052
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052Sham200526/1052_Baseline3_200526_095043/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1055
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1055_processed/M1055_Sham_60Hz_20Hz_interstim120sSleep_200602_100150/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'Septum_Stim_20Hz')
    %Mouse1052 12 juin 2020
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1052_processed/M1052_OptoStim20Hz60s_REM_200612_103911/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1055 22 mai 2020
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1055_processed/M1055_OptoStimSleep20Hz60sInter2min_200522_092650/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
%==========================================================================
%                         SST EXPERIMENTS   
%==========================================================================
elseif strcmp(experiment,'SST_Stim_20Hz')
    %Mouse1332
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1341_BaselineSleep_1332_opto20Hz30s_220721_090119/1332/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1333
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1340_BaselineSleep_1333_opto20Hz30s_220719_091042/1333/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1340
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1332_BaselineSleep_1340_opto20Hz30s_220720_092548/1340/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1341
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1341_opto20Hz30s_220722_091429/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SST_Sham_20Hz')
    %Mouse1332
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1332_sham_220726_085614/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1333
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1333_sham_220727_085052/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1340
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1340_sham_220728_085506/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1341
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS165/OPTO_1341_sham_220729_090030/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;


else
    error('Invalid name of experiment')
end



%% Get mice names
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    temp=strfind(Dir.path{i}{1},'M');
    if isempty(temp)
        Dir.name{i}=Dir.path{i}{1}(strfind(Dir.path{i}{1},'Mouse'):strfind(Dir.path{i}{1},'Mouse')+7);
    else
        Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+4)];
        if sum(isstrprop(Dir.path{i}{1}(temp+1:temp+4),'alphanum'))<4
            Dir.name{i}=['Mouse',Dir.path{i}{1}(temp+1:temp+3)];
        end
    end
end



end
