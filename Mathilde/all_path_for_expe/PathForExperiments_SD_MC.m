function Dir = PathForExperiments_SD_MC(experiment)

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)


%% Path
a=0;
I_CA=[];

%%
if strcmp(experiment,'BaselineSleep')
    % mouse1075
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1075_processed/SD_1075_Baseline2_201227_091547/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1107
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1107/20201227/BaselineSleep/SD_1107_Baseline2_201227_091547/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1112
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1112/20201227/BaselineSleep/SD_1112_Baseline2_201227_091547/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
   
    
%==========================================================================
%           "OUR CLASSIC" VERSION OF THE SOCIAL DEFEAT PROTOCOL
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%==========================================================================

elseif strcmp(experiment,'SensoryExposureCD1cage')

%mouse1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210520/SocialDefeat/SensoryExpoCD1cage/DREADD_1148_SD_sensory_CD1cage_210520_093520/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SensoryExpoCD1cage/DREADD_1149_SD_sensory_CD1cage_210520_093520/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210520/SocialDefeat/SensoryExpoCD1cage/DREADD_1150_SD_sensory_CD1cage_210520_093520/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210804/SocialDefeat/SensoryExpoCD1cage/DREADD_1217_SensoryExpoCD1cage_210804_091140/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210804/SocialDefeat/SensoryExpoCD1cage/DREADD_1218_SensoryExpoCD1cage_210804_091140/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210818/SocialDefeat/SensoryExpoCD1cage/DREADD_1219_SensoryExpoCD1cage_210818_093618/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %mouse 1220
%     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210818/SocialDefeat/SensoryExpoCD1cage/DREADD_1220_SensoryExpoCD1cage_210818_093618/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

elseif strcmp(experiment,'SensoryExposureC57cage')
    %mouse1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210520/SocialDefeat/SensoryExpoC57cage/DREADD_1148_SD_sensory_homecage_210520_100946/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SensoryExpoC57cage/DREADD_1149_SD_sensory_homecage_210520_100946/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210520/SocialDefeat/SensoryExpoC57cage/DREADD_1150_SD_sensory_homecage_210520_100946/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210804/SocialDefeat/SensoryExpoC57cage/DREADD_1217_SensoryExpoC57_210804_094026/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210804/SocialDefeat/SensoryExpoC57cage/DREADD_1218_SensoryExpoC57_210804_094026/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210818/SocialDefeat/SensoryExpoC57cage/DREADD_1219_SensoryExpoC57cage_210818_100314/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %mouse 1220
%     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210818/SocialDefeat/SensoryExpoC57cage/DREADD_1220_SensoryExpoC57cage_210818_100314/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SleepPostSD')
    %mouse1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210520/SocialDefeat/SleepPostSD/DREADD_1148_SleepPostSD_210520_103704/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SleepPostSD/DREADD_1149_SleepPostSD_210520_103704/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210520/SocialDefeat/SleepPostSD/DREADD_1150_SleepPostSD_210520_103704/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210804/SocialDefeat/SleepPostSD/DREADD_1217_SleepPostSD_210804_100450/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210804/SocialDefeat/SleepPostSD/DREADD_1218_SleepPostSD_210804_100450/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210818/SocialDefeat/SleepPostSD/DREADD_1219_SleepPostSD_210818_102638/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %mouse 1220
%     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210818/SocialDefeat/SleepPostSD/DREADD_1220_SleepPostSD_210818_102638/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

%==========================================================================
%       "OUR CLASSIC" VERSION OF THE SOCIAL DEFEAT PROTOCOL and EPM
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
%  5' EPM
% sleep post social defeat and EPM
%==========================================================================
elseif strcmp(experiment,'Baseline_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240110/BaselineSleep/tetrodes_PFC_1542_BaselineSleep_240110_093549/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240110/BaselineSleep/tetrodes_PFC_1543_BaselineSleep_240110_093549/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
elseif strcmp(experiment,'SensoryExposureCD1cage_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1542_sensoryexpoCD1cage_240111_090708/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1543_sensoryexpoCD1cage_240111_090708/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SensoryExposureC57cage_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1542_sensoryexpoC57cage_240111_093432/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1543_sensoryexpoC57cage_240111_093432/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SleepPostSD_PostEPM_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SleepPostSDandEPM/tetrodes_PFC_1542_SleepPostSDandEPM_240111_103314/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SleepPostSDandEPM/tetrodes_PFC_1543_SleepPostSDandEPM_240111_103314/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

%%%%%%%%%%%%%%%% SECOND RUN %%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(experiment,'SensoryExposureCD1cage_secondSD_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1542_SensoryExpo_CD1cage_240124_090500/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1543_SensoryExpo_CD1cage_240124_090500/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SensoryExposureC57cage_secondSD_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1542_SensoryExpo_C57cage_240124_093223/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1543_SensoryExpo_C57cage_240124_093223/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SleepPostSD_PostEPM_secondSD_tetrodesPFC')
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SleepPostSDandEPM/tetrodes_PFC_1542_SleepPostSDandEPM_SecondRun_240124_102321/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SleepPostSDandEPM/tetrodes_PFC_1543_SleepPostSDandEPM_SecondRun_240124_102321/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
%%%%%%%%%%%%%%%% SECOND RUN WITH FIRST RUN WITH ONE SENSORY EXPOSURE IN CD1 cage %%%%%%%%%%%%%%%%%
elseif strcmp(experiment,'SensoryExposureCD1cage_secondSD_firstOneSensoryExpo_tetrodesPFC')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/SocialDefeat_SecondSD/SensoryExposure_CD1cage/tetrodes_PFC_1539_SensoryExpo_CD1cage_secondSD_240118_090958/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240118/SocialDefeat_SecondSD/SensoryExposure_CD1cage/tetrodes_PFC_1540_SensoryExpo_CD1cage_secondSD_240118_090958/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/SocialDefeat_SecondSD/SensoryExposure_CD1cage/tetrodes_PFC_1541_SensoryExpo_CD1cage_secondSD_240118_090958/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    

elseif strcmp(experiment,'SensoryExposureC57cage_secondSD_firstOneSensoryExpo_tetrodesPFC')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/SocialDefeat_SecondSD/SensoryExposure_C57cage/tetrodes_PFC_1539_SensoryExpo_C57cage_secondSD_240118_093536/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240118/SocialDefeat_SecondSD/SensoryExposure_C57cage/tetrodes_PFC_1540_SensoryExpo_C57cage_secondSD_240118_093536/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/SocialDefeat_SecondSD/SensoryExposure_C57cage/tetrodes_PFC_1541_SensoryExpo_C57cage_secondSD_240118_093536/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    

elseif strcmp(experiment,'SleepPostSD_PostEPM_secondSD_firstOneSensoryExpo_tetrodesPFC')
%     %mouse 1539    %MOUSE GOT UNPLUGGED DO NOT USE
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/SleepPostSDandEPM/'; 
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240118/SleepPostSDandEPM/tetrodes_PFC_1540_SleepPostSDandEPM_240118_104433/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/SleepPostSDandEPM/tetrodes_PFC_1541_SleepPostSDandEPM_240118_104433/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif strcmp(experiment,'SleepPostSD_SalineInj') %2nde SD
    %mouse 1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20211020/SocialDefeat/SleepPostSD/DREADD_1217_SleepPostSD_211020_100615/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20211020/SocialDefeat_secondRun/SleepPostSD/DREADD_1218_SleepPostSD_211020_100615/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1219/20211013/SocialDefeat_SecondRun/SleepPostSD/DREADD_1219_DREADD_PFC_SleepPostSD_211013_102037/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%==========================================================================
%            SECOND VERSION OF THE SOCIAL DEFEAT PROTOCOL 
% (sleep after stress / no association between sleep envnt and the stressor)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in CD1 cage w/ separator (sensory exposure)
% sleep post social defeat
%==========================================================================

elseif strcmp(experiment,'SensoryExposureCD1cage_PART1')
    %mouse 1387
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1387/20230220/SocialDefeat/SensoryExpoCD1cage_part1/OPTO_1387_sensoryexposureCDcage_part1_230220_091237/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1388
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1388/20230220/SocialDefeat/SensoryExpoCD1cage_part1/OPTO_1388_sensoryexposureCDcage_part1_230220_091237/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1389
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1389/20230227/SocialDefeat/SensoryExpoCD1cage_part1/OPTO_1389_sensoryexpoCD1cage_part1_230227_091837/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    %mouse 1390
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1390/20230227/SocialDefeat/SensoryExpoCD1cage_part1/OPTO_1390_sensoryexpoCD1cage_part1_230227_091837/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %mouse 1453
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1453/20230512/SocialDefeat_Safe/SensoryExpoCD1cage_part1/SLEEP-Mouse-1453-12052023_01/'; %% !! no Ephy
%     %mouse 1454
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1454/20230531/SocialDefeat_safe/SensoryExpoCD1cage_part1/SLEEP-Mouse-1460&1462&1454&1455-31052023_01/'; %% !! no Ephy
%     %mouse 1455
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1455/20230531/SocialDefeat_safe/SensoryExpoCD1cage_part1/SLEEP-Mouse-1460&1462&1454&1455-31052023_01/'; %% !! no Ephy
%     %mouse 1456
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1456/20230601/SocialDefeat_safe/SensoryExpoCD1cage_part1/SLEEP-Mouse-1460&1462&1456&1457-01062023_01/'; %% !! no Ephy
%     %mouse 1457
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1457/20230601/SocialDefeat_safe/SensoryExpoCD1cage_part1/SLEEP-Mouse-1460&1462&1456&1457-01062023_01/'; %% !! no Ephy
    

elseif strcmp(experiment,'SensoryExposureCD1cage_PART2')
    %mouse 1387
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1387/20230220/SocialDefeat/SensoryExpoCD1cage_part2/OPTO_1387_sensoryexposureCDcage_part2_230220_093333/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1388
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1388/20230220/SocialDefeat/SensoryExpoCD1cage_part2/OPTO_1388_sensoryexposureCDcage_part2_230220_093333/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1389
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1389/20230227/SocialDefeat/SensoryExpoCD1cage_part2/OPTO_1389_sensoryexpoCD1cage_part2_230227_094004/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    %mouse 1390
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1390/20230227/SocialDefeat/SensoryExpoCD1cage_part2/OPTO_1390_sensoryexpoCD1cage_part2_230227_094004/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %mouse 1453
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1453/20230512/SocialDefeat_Safe/SensoryExpoCD1cage_part2/SLEEP-Mouse-1453-12052023_02/'; %% !! no Ephy
%     %mouse 1454
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1454/20230531/SocialDefeat_safe/SensoryExpoCD1cage_part2/SLEEP-Mouse-1460&1462&1454&1455-31052023_02/'; %% !! no Ephy
%     %mouse 1455
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1455/20230531/SocialDefeat_safe/SensoryExpoCD1cage_part2/SLEEP-Mouse-1460&1462&1454&1455-31052023_02/'; %% !! no Ephy
%     %mouse 1456
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1456/20230601/SocialDefeat_safe/SensoryExpoCD1cage_part2/SLEEP-Mouse-1460&1462&1456&1457-01062023_02/'; %% !! no Ephy
%     %mouse 1457
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1457/20230601/SocialDefeat_safe/SensoryExpoCD1cage_part2/SLEEP-Mouse-1460&1462&1456&1457-01062023_02/'; %% !! no Ephy
    

elseif strcmp(experiment,'SleepPostSD_safe')
    %mouse 1387
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1387/20230220/SocialDefeat/SleepPostSD_SalineInjection/OPTO_1387_sleepPostSD_safe_230220_100140/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1388
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1388/20230220/SocialDefeat/SleepPostSD_SalineInjection/OPTO_1388_sleepPostSD_safe_230220_100140/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1389
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1389/20230227/SocialDefeat/SleepPostSD_SalineInjection/OPTO_1389_sleepPostSD_safe_230227_100647/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    %mouse 1390
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1390/20230227/SocialDefeat/SleepPostSD_SalineInjection/OPTO_1390_sleepPostSD_safe_230227_100647/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;


    
    
%==========================================================================
% VERSION OF THE SOCIAL DEFEAT PROTOCOL WITH ONE SENSORY EXPOSURE and EPM
% (sleep after stress / no association between sleep envnt and the stressor)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
%  5' EPM
% sleep post social defeat and EPM
%==========================================================================
elseif strcmp(experiment,'Baseline_oneSensoryExpo_tetrodesPFC')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240108/BaselineSleep/tetrodes_PFC_1539_baselineSleep_240108_092543/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240103/BaselineSleep/tetrodes_PFC_1540_BaselineSleep_240103_091129/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240108/BaselineSleep/tetrodes_PFC_1539_1541_1542_1543_baselineSleep_240108_092543/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
    
elseif strcmp(experiment,'SensoryExposureCD1cage_oneSensoryExposure_tetrodesPFC')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/SocialDefeat_oneSensoryExpo/SensoryExposure_CD1cage/tetrodes_PFC_1539_sensoryexpoCD1cage_240109_091153/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240104/SocialDefeat_oneSensoryExpo/SensoryExposure_CD1cage/tetrodes_PFC_1540_sensoryexpoCD1cage_240104_091322/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/SocialDefeat_oneSensoryExpo/SensoryExposure_CD1cage/tetrodes_PFC_1541_sensoryexpoCD1cage_240109_091153/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1075
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1075_processed/20201228/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy
    %mouse1107
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1107/20201228/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy
    %mouse 1112
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1112/20201228/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy


elseif strcmp(experiment,'SleepPostSD_oneSensoryExposure_PostEPM_tetrodesPFC')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/SleepPostSDandEPM/tetrodes_PFC_1539_SleepPostSDandEPM_240109_100801/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240104/SleepPostSDandEPM/tetrodes_PFC_1540_SleepPostSDandEPM_240104_095212/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/SleepPostSDandEPM/tetrodes_PFC_1541_SleepPostSDandEPM_240109_100801/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
%%Mathilde's mice : didn't go through EPM
elseif strcmp(experiment,'SleepPostSD_oneSensoryExposure_SalineInjection')
    %mouse 1075
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/Thierry_DATA/M1075_processed/20201228/SocialDefeat/SleepPostSD/SD_1075_SD1_201228_094818/'; %% protocole different (1seule expo snsorielle)
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/Thierry_DATA/M1107/20201228/SocialDefeat/SleepPostSD/SD_1107_SD1_201228_094818/'; %% protocole different (1seule expo snsorielle)
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse 1112 %DO NOT USE, WAS STUCK AND DIDN'T SLEEP
    a=a+1;Dir.path{a}{1}='/media/nas8/mobs/Thierry_DATA/M1112/20201228/SocialDefeat/SleepPostSD/SD_1112_SD1_201228_094818/'; %% protocole different (1seule expo snsorielle)
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;





%%THE SECTIONS BELOW USE NEURONAL MANIPULATIONS BASED ON OUR CLASSIC VERSION OF THE SOCIAL DEFEAT PROTOCOL  
    
%==========================================================================
%        inhibitory DREADD retro cre PFC-VLPO (cno 2.5MG/KG) AT 10AM)
%                     (WITH OUR CLASSIC VERSION)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%==========================================================================

    
elseif strcmp(experiment,'SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO')
    % mouse1245
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1245/20211221/SocialDefeat/SensoryExpoCD1cage/DREADD_PFC_VLPO_1245_SensoryExpoCD1cage_211221_090700/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1247
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1247/20211216/SocialDefeat/SensoryExpoCD1cage/DREADD_PFC_VLPO_1247_SneosryExposureCD1cage_211216_090953/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1248
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1248/20211216/SocialDefeat/SensoryExpoCD1cage/DREADD_PFC_VLPO_1248_SneosryExposureCD1cage_211216_090953/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220610/SensoryExposureCD1cage/DREADD_PFC_VLPO_1300_sensoryExpo_CD1cage_220610_091040/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220617/SensoryExposureCD1cage/DREADD_PFC_VLPO_1301_sensoryExpo_CD1cage_220617_091758/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220610/SensoryExposureCD1cage/DREADD_PFC_VLPO_1302_sensoryExpo_CD1cage_220610_091040/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220617/SensoryExposureCD1cage/DREADD_PFC_VLPO_1303_sensoryExpo_CD1cage_220617_091758/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    
    
elseif strcmp(experiment,'SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO')
    % mouse1245
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1245/20211221/SocialDefeat/SensoryExpoC57cage/DREADD_PFC_VLPO_1245_SensoryExpoC57cage_211221_093129/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1247
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1247/20211216/SocialDefeat/SensoryExpoC57cage/DREADD_PFC_VLPO_1247_SneosryExposureC57cage_211216_093628/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1248
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1248/20211216/SocialDefeat/SensoryExpoC57cage/DREADD_PFC_VLPO_1248_SneosryExposureC57cage_211216_093628/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220610/SensoryExposureC57cage/DREADD_PFC_VLPO_1300_sensoryExpo_C57cage_220610_093744/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220617/SensoryExposureC57cage/DREADD_PFC_VLPO_1301_sensoryExpo_C57cage_220617_094359/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220610/SensoryExposureC57cage/DREADD_PFC_VLPO_1302_sensoryExpo_C57cage_220610_093744/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220617/SensoryExposureC57cage/DREADD_PFC_VLPO_1303_sensoryExpo_C57cage_220617_094359/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 

    
elseif strcmp(experiment,'SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_CNOInjection')
%     % mouse1245
%     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1245/20211221/SocialDefeat/SleepPostSD_CNO/DREADD_PFC_VLPO_1245_SleepPostSD_CNO_211221_095754/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1247
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1247/20211216/SocialDefeat/SleepPostSD_CNO/DREADD_PFC_VLPO_1247_SleepPostSD_211216_100241/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1248
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1248/20211216/SocialDefeat/SleepPostSD_CNO/DREADD_PFC_VLPO_1248_SleepPostSD_211216_100241/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220610/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1300_sleepPostSD_220610_100538/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220617/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1301_sleepPostSD_220617_101046/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220610/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1302_sleepPostSD_220610_100538/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220617/SleepPostSD_CNOInjection/DREADD_PFC_VLPO_1303_sleepPostSD_220617_101046/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    
        
%==========================================================================
%        inhibitory DREADD retro cre PFC-VLPO (SALINE AT 10AM)
%                     (WITH OUR CLASSIC VERSION)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%==========================================================================

    
elseif strcmp(experiment,'SensoryExposureCD1cage_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC')
    % mouse1519
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1519/20231203/SocialDefeat/SensoryExposure_CD1cage/retroCre_PFC_VLPO_inhi_1519_sensoryExpoCD1cage_231203_090949/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1520
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1520/20231203/SocialDefeat/SensoryExposure_CD1cage/retroCre_PFC_VLPO_inhi_1520_sensoryExpoCD1cage_231203_090949/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1521
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1521/20231205/SocialDefeat/SensoryExposure_CD1cage/retroCre_PFC_VLPO_inhi_1521_sensoryExpoCD1cage_231205_091007/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1522
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1522/20231203/SocialDefeat/SensoryExposure_CD1cage/retroCre_PFC_VLPO_inhi_1522_sensoryExpoCD1cage_231203_090949/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1523
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1523/20231205/SocialDefeat/SensoryExposure_CD1cage/retroCre_PFC_VLPO_inhi_1523_sensoryExpoCD1cage_231205_091007/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
   
    
elseif strcmp(experiment,'SensoryExposureC57cage_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC')
    % mouse1519
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1519/20231203/SocialDefeat/SensoryExposure_C57cage/retroCre_PFC_VLPO_inhi_1519_sensoryExpoC57cage_231203_093719/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1520
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1520/20231203/SocialDefeat/SensoryExposure_C57cage/retroCre_PFC_VLPO_inhi_1520_sensoryExpoC57cage_231203_093719/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1521
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1521/20231205/SocialDefeat/SensoryExposure_C57cage/retroCre_PFC_VLPO_inhi_1521_sensoryExpoC57cage_231205_093455/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1522
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1522/20231203/SocialDefeat/SensoryExposure_C57cage/retroCre_PFC_VLPO_inhi_1522_sensoryExpoC57cage_231203_093719/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1523
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1523/20231205/SocialDefeat/SensoryExposure_C57cage/retroCre_PFC_VLPO_inhi_1523_sensoryExpoC57cage_231205_093455/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
   
    
elseif strcmp(experiment,'SleepPostSD_inhibDREADD_retroCre_PFC_VLPO_tetrodesPFC_SalineInjection')
    %mouse1519
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1519/20231203/SleepPostSD_SalineInjection/retroCre_PFC_VLPO_inhi_1519_sleepPostSD_231203_100734/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1520
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1520/20231203/SleepPostSD_SalineInjection/retroCre_PFC_VLPO_inhi_1520_sleepPostSD_231203_100734/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     % mouse1521                       %bad signals in HPC, couldn't score REM
%     a=a+1;Dir.path{a}{1}=''; 
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
%     % mouse1522                       %bad signals in HPC, couldn't score REM
%     a=a+1;Dir.path{a}{1}=''; 
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    % mouse1523
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1523/20231205/SleepPostSD_SalineInjection/retroCre_PFC_VLPO_inhi_1523_sleepPostSD_231205_095930/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
   
            
%==========================================================================
%        mCherry retro cre PFC-VLPO (cno 2.5MG/KG) AT 10AM)
%                     (WITH OUR CLASSIC VERSION)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%==========================================================================
    
elseif strcmp(experiment,'SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_CNOInjection')
    %mouse1423
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1423/20230404/SocialDefeat/SensoryExpoCD1cage/CTRL_PFC_VLPO_1423_sensoryExpoCD1cage_230404_091416/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1424
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1424/20230404/SocialDefeat/SensoryExpoCD1cage/CTRL_PFC_VLPO_1424_sensoryExpoCD1cage_230404_091416/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1425
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1425/20230405/SocialDefeat/SensoryExpoCD1cage/CTRL_PFC_VLPO_1425_sensoryExpoCD1cage_230405_091349/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1426
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1426/20230405/SocialDefeat/SensoryExpoCD1cage/CTRL_PFC_VLPO_1426_sensoryExpoCD1cage_230405_091349/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;  
    %%2nd batch
    % mouse1433
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1433/20230513/SocialDefeat_CNOInjection/SensoryExposureCD1cage/CTRL_1433_snsoryExpoCD1cage_230513_091244/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1434
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1434/20230513/SocialDefeat_CNOInjection/SensoryExposureCD1cage/CTRL_1434_snsoryExpoCD1cage_230513_091244/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1435
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1435/20230513/SocialDefeat_CNOInjection/SensoryExposureCD1cage/CTRL_1435_snsoryExpoCD1cage_230513_091244/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_CNOInjection')
    %mouse1423
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1423/20230404/SocialDefeat/SensoryExpoC57cage/CTRL_PFC_VLPO_1423_sensoryExpoC57cage_230404_093800/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1424
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1424/20230404/SocialDefeat/SensoryExpoC57cage/CTRL_PFC_VLPO_1424_sensoryExpoC57cage_230404_093800/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1425
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1425/20230405/SocialDefeat/SensoryExpoC57cage/CTRL_PFC_VLPO_1425_sensoryExpoC57cage_230405_093639/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1426
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1426/20230405/SocialDefeat/SensoryExpoC57cage/CTRL_PFC_VLPO_1426_sensoryExpoC57cage_230405_093639/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;  
    %%2nd batch
    % mouse1433
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1433/20230513/SocialDefeat_CNOInjection/SensoryExposureC57cage/CTRL_1433_snsoryExpoC57cage_230513_094118/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1434
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1434/20230513/SocialDefeat_CNOInjection/SensoryExposureC57cage/CTRL_1434_snsoryExpoC57cage_230513_094118/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1435
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1435/20230513/SocialDefeat_CNOInjection/SensoryExposureC57cage/CTRL_1435_snsoryExpoC57cage_230513_094118/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SleepPostSD_mCherry_retroCre_PFC_VLPO_CNOInjection')
    %mouse1423
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1423/20230404/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1423_Sleep_PostSD_230404_100429/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %mouse1424
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1424/20230404/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1424_Sleep_PostSD_230404_100429/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     % mouse1425
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1425/20230405/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1425_sleepPostSD_230405_100108/'; %%signaux hpc mauvais
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1426
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1426/20230405/SocialDefeat/SleepPostSD_CNO/CTRL_PFC_VLPO_1426_sleepPostSD_230405_100108/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %%2nd batch
    % mouse1433
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1433/20230513/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/CTRL_1433_sleepPostSD_230513_100916/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1434
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1434/20230513/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/CTRL_1434_sleepPostSD_230513_100916/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1435
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1435/20230513/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/CTRL_1435_sleepPostSD_230513_100916/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
%     % mouse
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBs191/retroCre_PFC_VLPO_inhi_1519_1520_1522_sleepPostSD_231203_100734/M1519/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     % mouse
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBs191/retroCre_PFC_VLPO_inhi_1519_1520_1522_sleepPostSD_231203_100734/M1520/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     % mouse
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBs191/retroCre_PFC_VLPO_inhi_1521_1523_sleepPostSD_231205_095930/M1523/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
%==========================================================================
%         mCherry retro cre PFC-VLPO (SALINE AT 10AM)
%                     (WITH OUR CLASSIC VERSION)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%==========================================================================

elseif strcmp(experiment,'SensoryExposureCD1cage_mCherry_retroCre_PFC_VLPO_SalineInjection')
    % mouse1449
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1449/20230525/SocialDefeat_SalineInjection/SensoryExposureCD1cage/CTRL_1449_snsoryExpoCD1cage_230525_090930/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1450
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1450/20230525/SocialDefeat_SalineInjection/SensoryExposureCD1cage/CTRL_1450_snsoryExpoCD1cage_230525_090930/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1451
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1451/20230525/SocialDefeat_SalineInjection/SensoryExposureCD1cage/CTRL_1451_snsoryExpoCD1cage_230525_090930/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SensoryExposureC57cage_mCherry_retroCre_PFC_VLPO_SalineInjection')
    % mouse1449
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1449/20230525/SocialDefeat_SalineInjection/SensoryExposureC57cage/CTRL_1449_snsoryExpoC57cage_230525_093741/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1450
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1450/20230525/SocialDefeat_SalineInjection/SensoryExposureC57cage/CTRL_1450_snsoryExpoC57cage_230525_093741/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1451
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1451/20230525/SocialDefeat_SalineInjection/SensoryExposureC57cage/CTRL_1451_snsoryExpoC57cage_230525_093741/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
elseif strcmp(experiment,'SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection')
    % mouse1449
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1449/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1449_sleepPostSD_230525_100459/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1450
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1450/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1450_sleepPostSD_230525_100459/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%  %%%%%%%%%%%%%%%%%%   % mouse1451
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1451/20230525/SocialDefeat_SalineInjection/SleepPostSD_SalineInjection/CTRL_1451_sleepPostSD_230525_100459/'; %% bad hpc signals (similar to pfc/spindles leak?)
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
elseif strcmp(experiment,'SensoryExposureCD1cage_noDREADD_BM_mice_SalineInjection')
    % mouse1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1414/20230616/SocialDefeat_SalineInjection/SensoryExposureCD1cage/BM_1414_SensoryExposureCD1cage_230616_091141/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1416/20230616/SocialDefeat_SalineInjection/SensoryExposureCD1cage/BM_1416_SensoryExposureCD1cage_230616_091141/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1437/20230616/SocialDefeat_SalineInjection/SensoryExposureCD1cage/BM_1437_SensoryExposureCD1cage_230616_091141/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1415/20230707/SocialDefeat_SalineInjection/SensoryExposureCD1cage/BM_1415_sensoryExpoCD1cage_230707_091554/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1446/20230707/SocialDefeat_SalineInjection/SensoryExposureCD1cage/BM_1446_sensoryExpoCD1cage_230707_091554/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    

elseif strcmp(experiment,'SensoryExposureC57cage_noDREADD_BM_mice_SalineInjection')
    % mouse1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1414/20230616/SocialDefeat_SalineInjection/SensoryExposureC57cage/BM_1414_SensoryExposureC57cage_230616_093850/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1416/20230616/SocialDefeat_SalineInjection/SensoryExposureC57cage/BM_1416_SensoryExposureC57cage_230616_093850/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1437/20230616/SocialDefeat_SalineInjection/SensoryExposureC57cage/BM_1437_SensoryExposureC57cage_230616_093850/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1415/20230707/SocialDefeat_SalineInjection/SensoryExposureC57cage/BM_1415_sensoryExpoC57cage_230707_093947/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1446/20230707/SocialDefeat_SalineInjection/SensoryExposureC57cage/BM_1446_sensoryExpoC57cage_230707_093947/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SleepPostSD_noDREADD_BM_mice_SalineInjection')
% %  %%%%%%%%%%%%%%%   % mouse1414
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1414/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1414_SleepPostSD_saline_230616_100541/'; %%signaux hpc pas terribles
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1416/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1416_SleepPostSD_saline_230616_100541/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1437/20230616/SocialDefeat_SalineInjection/SleepPostSD_SalineInjecton/BM_1437_SleepPostSD_saline_230616_100541/';%%%%%%%%%%%%%%%%%%!!sans celleci 3e point wake stat
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    % mouse1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1415/20230707/SocialDefeat_SalineInjection/SleepPostSD_SlaineInjection/BM_1415_sleepPstSD_230707_100431/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %mouse1446
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS183/BM_1415_1446_sleepPstSD_230707_100431/1446/';%%%%%%%%%%%%%%%% figure poster sans
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
%==========================================================================
%              noDREADD mice (Baptiste's) (cno 2.5MG/KG)
%                      (WITH OUR CLASSIC VERSION)
%
%==========================================================================
    
elseif strcmp(experiment,'SensoryExposureCD1cage_noDREADD_BM_mice_CNOInjection')
    % mouse1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1439/20230602/SocialDefeat_CNOInjection/SensoryExposureCD1cage/BM_1439_sensoryExpoCD1cage_230602_091305/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1440/20230602/SocialDefeat_CNOInjection/SensoryExposureCD1cage/BM_1440_sensoryExpoCD1cage_230602_091305/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1417/20230609/SocialDefeat_CNOInjection/SensoryExposureCD1cage/BM_1417_sensoryExpoCD1cage_230609_091132/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1418/20230609/SocialDefeat_CNOInjection/SensoryExposureCD1cage/BM_1418_sensoryExpoCD1cage_230609_091132/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1448/20230609/SocialDefeat_CNOInjection/SensoryExposureCD1cage/BM_1448_sensoryExpoCD1cage_230609_091132/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SensoryExposureC57cage_noDREADD_BM_mice_CNOInjection')
    % mouse1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1439/20230602/SocialDefeat_CNOInjection/SensoryExposureC57cage/BM_1439_sensoryExpoC57cage_230602_093629/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1440/20230602/SocialDefeat_CNOInjection/SensoryExposureC57cage/BM_1440_sensoryExpoC57cage_230602_093629/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
        % mouse1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1417/20230609/SocialDefeat_CNOInjection/SensoryExposureC57cage/BM_1417_sensoryExpoC57cage_230609_094031/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1418/20230609/SocialDefeat_CNOInjection/SensoryExposureC57cage/BM_1418_sensoryExpoC57cage_230609_094031/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1448/20230609/SocialDefeat_CNOInjection/SensoryExposureC57cage/BM_1448_sensoryExpoC57cage_230609_094031/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SleepPostSD_noDREADD_BM_mice_CNOInjection')
    % mouse1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1439/20230602/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1439_sleepPostSD_230602_100213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1440/20230602/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1440_sleepPostSD_230602_100213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
 %%%%   % mouse1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1417/20230609/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1417_sleepPostSD_230609_100843/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1418/20230609/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1418_sleepPostSD_230609_100843/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1448/20230609/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/BM_1448_sleepPostSD_230609_100843/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
%==========================================================================
%              inhibitory DREADD in PFC (cno 2.5MG/KG) AT 10AM
%                      (WITH OUR CLASSIC VERSION)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%==========================================================================

elseif strcmp(experiment,'SensoryExposureCD1cage_inhibDREADD_PFC_CNOInjection')
    % mouse1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210527/SocialDefeat_CNOInjection/SensoryExposureCD1cage/DREADD_1196_SD_SensoryCD1cage_210527_092351/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210527/SocialDefeat_CNOInjection/SensoryExposureCD1cage/DREADD_1197_SD_SensoryCD1cage_210527_092351/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1235
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1235/20211013/SocialDefeat_CNOInjection/SensoryExposureCD1cage/DREADD_PFC_1235_SensoryExpoCD1cage_211013_092607/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211006/SocialDefeat/SensoryExpoCD1cage/DREADD_PFC_1237_SensoryExpoCD1cage_211006_093551/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211006/SocialDefeat/SensoryExpoCD1cage/DREADD_PFC_1238_SensoryExpoCD1cage_211006_093551/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SensoryExposureC57cage_inhibDREADD_PFC_CNOInjection')
    % mouse1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210527/SocialDefeat_CNOInjection/SensoryExposureC57cage/DREADD_1196_SD_SensoryHomecage_210527_095329/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210527/SocialDefeat_CNOInjection/SensoryExposureC57cage/DREADD_1197_SD_SensoryHomecage_210527_095329/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1235
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1235/20211013/SocialDefeat_CNOInjection/SEnsoryExposureC57cage/DREADD_PFC_1235_SensoryExpoC57cage_211013_095206/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211006/SocialDefeat/SensoryExpoC57cage/DREADD_PFC_1237_SensoryExpoC57cage_211006_100228/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211006/SocialDefeat/SensoryExpoC57cage/DREADD_PFC_1238_SensoryExpoC57cage_211006_100228/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
        
elseif strcmp(experiment,'SleepPostSD_inhibDREADD_PFC_CNOInjection')
    % mouse1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210527/SocialDefeat_CNOInjection/SleepPostSD_inhibitionPFC/DREADD_1196_SD_SleepPostSD_210527_101817/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210527/SocialDefeat_CNOInjection/SleepPostSD_inhibitionPFC/DREADD_1197_SD_SleepPostSD_210527_101817/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1235
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1235/20211013/SocialDefeat_CNOInjection/SleepPostSD_CNOInjection/DREADD_PFC_1235_SleepPostSD_211013_102037/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211006/SocialDefeat/SleepPostSD/DREADD_PFC_1237_SleepPostSD_211006_102815/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211006/SocialDefeat/SleepPostSD/DREADD_PFC_1238_SleepPostSD_211006_102815/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
%==========================================================================
%        inhibitory DREADD in CRH neurons in the VLPO (cno 2.5MG/KG) AT 10AM)
%                     (WITH OUR CLASSIC VERSION)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%========================================================================== 
elseif strcmp(experiment,'SensoryExposureCD1cage_inhibDREADD_CRH_VLPO_CNOInjection')
    % mouse1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1488_sensoryExposure_CD1cage_231107_091404/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1489_SensoryExposure_CD1cage_231107_091404/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1510_SensoryExposure_CD1cage_231109_091143/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1511_SensoryExposure_CD1cage_231109_091143/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1512_SensoryExposure_CD1cage_231109_091143/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SensoryExposureC57cage_inhibDREADD_CRH_VLPO_CNOInjection')
    % mouse1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1488_SensoryExposure_C57cage_231107_094124/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1489_SensoryExposure_C57cage_231107_094124/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1510_SensoryExposure_C57cage_231109_093848/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1511_SensoryExposure_C57cage_231109_093848/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1512_SensoryExposure_C57cage_231109_093848/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection')
    % mouse1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SleepPostSD_CNOInjection/CRH_inhib_1488_SleepPstSD_cno_231107_100503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SleepPostSD_CNOInjection/CRH_inhib_1489_SleepPstSD_cno_231107_100503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SleepPostSD_CNOInjection/CRH_inhib_1510_SleepPostSD_cno_231109_100320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SleepPostSD_CNOInjection/CRH_inhib_1511_SleepPostSD_cno_231109_100320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SleepPostSD_CNOInjection/CRH_inhib_1512_SleepPostSD_cno_231109_100320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
%==========================================================================
%        inhibitory DREADD in CRH neurons in the VLPO (saline AT 10AM)
%                     (WITH OUR CLASSIC VERSION _ SECOND Social Defeat)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
% sleep post social defeat
%========================================================================== 
elseif strcmp(experiment,'SensoryExposureCD1cage_inhibDREADD_CRH_VLPO_SalineInjection_secondrun')
    % mouse1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1488_sensoryExpoCD1cage2_231207_091417/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231207/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1489_sensoryExpoCD1cage2_231207_091417/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1510_sensoryExpoCD1cage_231130_091317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1511_sensoryExpoCD1cage_231130_091317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231130/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1512_sensoryExpoCD1cage_231130_091317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SensoryExposureC57cage_inhibDREADD_CRH_VLPO_SalineInjection_secondrun')
    % mouse1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1488_sensoryExpoC57cage2_231207_094019/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231207/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1489_sensoryExpoC57cage2_231207_094019/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1510_sensoryExpoC57cage_231130_093950/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1511_sensoryExpoC57cage_231130_093950/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231130/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1512_sensoryExpoC57cage_231130_093950/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SleepPostSD_inhibDREADD_CRH_VLPO_SalineInjection_secondrun')
    % mouse1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1488_sleepPostSD_saline_231207_100409/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1510_sleepPostSD_saline_231130_100457/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1511_sleepPostSD_saline_231130_100457/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % mouse1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1511_sleepPostSD_saline_231130_100457/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
%==========================================================================
%           "OUR CLASSIC" VERSION OF THE SOCIAL DEFEAT PROTOCOL 
%                     followed by EPM (no sleep)
%           
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
%  5' EPM
%==========================================================================

elseif strcmp(experiment,'SensoryExposureCD1cage_behavOnly')
    %mouse1429
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1429/20230403/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy
    %mouse1430
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1430/20230403/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy
    %mouse1431
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1431/20230403/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy
    %mouse1432
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1432/20230403/SocialDefeat/SensoryExpoCD1cage/'; %% !! no Ephy
    

elseif strcmp(experiment,'SensoryExposureC57cage_behavOnly')
    %mouse1429
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1429/20230403/SocialDefeat/SensoryExpoC57cage/'; %% !! no Ephy
    %mouse1430
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1430/20230403/SocialDefeat/SensoryExpoC57cage/'; %% !! no Ephy
    %mouse1431
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1431/20230403/SocialDefeat/SensoryExpoC57cage/'; %% !! no Ephy
    %mouse1432
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1432/20230403/SocialDefeat/SensoryExpoC57cage/'; %% !! no Ephy

    
    
    
    
elseif strcmp(experiment,'compare_scoring_basal')
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240108/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240108/BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'compare_scoring_SD')
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/SleepPostSDandEPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/SleepPostSDandEPM/';
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
