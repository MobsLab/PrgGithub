function Dir = PathForExperiments_DREADD_MC(experiment)

% INPUT:
% name of the experiment.

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
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

%%
%==========================================================================
%    Exitatory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (2.5MG/KG) at 1PM
%==========================================================================

if strcmp(experiment,'exciDREADD_CRH_VLPO_BaselineSleep')
    %%big volume of virus injection in the  VLPO (100nl)
    %Mouse 1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210203/BaselineSleep/DREADD_1148_Baseline4_210203_090602/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1149 %%%%COMMENT FOR BASALINE VS SALINE CODE
%     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210203/BaselineSleep/'; %% !! sleep scoring à corriger
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210203/BaselineSleep/DREADD_1150_Baseline4_210203_090602/'; %% !! sleep scoring à corriger
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %%small volume of virus injection in the  VLPO (50nl)
    % Mouse 1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210720/BaselineSleep/DREADD_1217_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210720/BaselineSleep/DREADD_1218_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210720/BaselineSleep/DREADD_1219_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1220
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210720/BaselineSleep/DREADD_1220_Baseline3_210720_090213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_SalineInjection_1pm')
    %%big volume of virus injection in the  VLPO (100nl)
    % Mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201222/Sleep_SalineInjection/DREADD_1105_NaCl_201022_090908/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201020/Sleep_SalineInjection/DREADD_1106_Nacl_201020_085532/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210204/Sleep_SalineInjection/DREADD_1148_Nacl_210204_090352/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210204/Sleep_SalineInjection/DREADD_1149_Nacl_210204_090352/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210413/Sleep_SalineInjection/DREAD_1150_Nacl_210413_085226/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%small volume of virus injection in the  VLPO (50nl)
    % Mouse 1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210721/Sleep_SalineInjection/DREADD_1217_Nacl_210721_085502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210721/Sleep_SalineInjection/DREADD_1218_Nacl_210721_085502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210721/Sleep_SalineInjection/DREADD_1219_Nacl_210721_085502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1220
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210721/Sleep_SalineInjection/DREADD_1220_Nacl_210721_085502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%small volume of virus injection in the  VLPO (50nl) - BATCH 2 (w/ Alice Descamps)
    % Mouse 1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20221212/Sleep_SalineInjection/DREADD_PFC_VLPO_1371_saline_221212_082822/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20221212/Sleep_SalineInjection/DREADD_PFC_VLPO_1372_saline_221212_082822/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20221130/Sleep_SalineInjection/DREADD_PFC_VLPO_1373_Saline_221130_082006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20221130/Sleep_SalineInjection/DREADD_PFC_VLPO_1374_Saline_221130_082006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_CNOInjection_1pm') %%correction sleep scor thresh on 1st part done (decembre 2021)
    %%big volume of virus injection in the  VLPO (100nl)
    % Mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201013/Sleep_CNOInection/DREADD_1105_CNO_201013_090425/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201016/Sleep_CNOInjection/DREADD_1106_CNO_201016_090240/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210224/Sleep_CNOInjection/DREADD_1148_CNO_210224_090824/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210224/Sleep_CNOInjection/DREADD_1149_CNO_210224_090824/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210204/Sleep_CNOInjection/DREADD_1150_CNO_210204_090352/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%small volume of virus injection in the  VLPO (50nl)
    % Mouse 1217
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1217/20210728/Sleep_CNOInjection/DREADD_1217_CNO_210728_085940/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1218
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1218/20210728/Sleep_CNOInjection/DREADD_1218_CNO_210728_085940/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1219
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1219/20210811/DREADD_1219_CNO_210811_085619/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1220
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1220/20210728/Sleep_CNOInjection/DREADD_1220_CNO_210728_085940/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%small volume of virus injection in the  VLPO (50nl) - BATCH 2 (w/ Alice Descamps)
    % Mouse 1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20221130/Sleep_CNOInjection/DREADD_PFC_VLPO_1371_CNO_221130_082006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20221130/Sleep_CNOInjection/DREADD_PFC_VLPO_1372_CNO_221130_082006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20221208/Sleep_CNOInjection/DREADD_PFC_VLPO_1373_CNO_221208_082231/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20221208/Sleep_CNOInjection/DREADD_PFC_VLPO_1374_CNO_221208_082231/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_CNOInjection_1pm_recovery') %recording the day after the cno injection
    % Mouse 1148
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1148/20210129/Sleep_Recovery/DREADD_1148_recov_210129_090255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1149
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1149/20210129/Sleep_Recovery/DREADD_1149_recov_210129_090255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1150
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1150/20210129/Sleep_Recovery/DREADD_1150_recov_210129_090255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
%==========================================================================
%                exitatory DREADD in VLPO CRH neurons
%             Protocole with one injection (1MG/KG) at 1PM
%==========================================================================
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_SalineInjection_1mg_1pm')
    % Mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201222/Sleep_SalineInjection/DREADD_1105_NaCl_201022_090908/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201020/Sleep_SalineInjection/DREADD_1106_Nacl_201020_085532/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_CNOInjection_1mg_1pm')
    % Mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201020/Sleep_CNOIjnection/DREADD_1105_CNO1mg_201020_085532/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201022/Sleep_CNOInjection/DREADD_1106_CNO1mg_201022_090908/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
%==========================================================================
%                  exitatory DREADD in VLPO CRH neurons
%                Protocole with two injections (9AM and 1PM)
%==========================================================================
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_SalineInjections_9am_1pm')
    % Mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201007/Sleep_SalineInjection/DREADD_1105_Nacl_201007_090739/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201008/Sleep_SalineInjection/DREADD_1106_Nacl_201008_090541/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_CNOInjections_9am_1pm')
    % Mouse 1105
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1105/20201008/Sleep_CNO_TwoInjection/DREADD_1105_CNO_201008_090541/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1106
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1106/20201007/Sleep_CNO_TwoInjection/DREADD_1106_CNO_201007_090739/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
%==========================================================================
%               exitatory DREADD in VLPO CRH neurons
%    Protocole sleep post EPM with one injection (2.5MG/KG) at 9AM
%==========================================================================
    %%Alice's mice
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_SalineInjection_9am_SleepPostEPM')
    %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20230125/SleepPostEPM_SalineInjection/DREADD_CRH_VLPO_1371_saline_sleepPostEPM_230125_100723/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20230125/SleepPostEPM_SalineInjection/DREADD_CRH_VLPO_1372_saline_sleepPostEPM_230125_100723/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20230130/SleepPostEPM_SalineInjection/DREADD_CRH_VLPO_1373_saline_sleepPostEPM_230130_100625/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20230130/SleepPostEPM_SalineInjection/DREADD_CRH_VLPO_1374_saline_sleepPostEPM_230130_100625/';
    
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_CNOInjection_9am_SleepPostEPM')
    %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20230202/SleepPostEPM_CNOInjection/DREADD_CRH_VLPO_1371_cno_sleepPostEPM_230202_101623/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20230202/SleepPostEPM_CNOInjection/DREADD_CRH_VLPO_1372_cno_sleepPostEPM_230202_101623/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20230126/SleepPostEPM_CNOInjection/DREADD_CRH_VLPO_1373_cno_sleepPostEPM_230126_100827/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20230126/SleepPostEPM_CNOInjection/DREADD_CRH_VLPO_1374_cno_sleepPostEPM_230126_100827/';
    
    
%==========================================================================
%    Inhibitory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (2.5MG/KG) at 10AM
%==========================================================================
    
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_BaselineSleep')
%     %Mouse 1488 %%%%COMMENT FOR BASALINE VS SALINE CODE
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS182/CRH_inhi_1488_1489_baselineSleep5_231017_083842/M1488/'; %sleepscoring à corriger %update quand sur serveur
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS182/CRH_inhi_1488_1489_baselineSleep5_231017_083842/M1489/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS182/CRH_inhi_1488_1510_1511_1512_baselineSleep_231026_084141/M1510/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS182/CRH_inhi_1488_1510_1511_1512_baselineSleep_231026_084141/M1511/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS182/CRH_inhi_1488_1510_1511_1512_baselineSleep_231026_084141/M1512/'; %sleepscoring à corriger %update quand sur serveur
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
   
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_SalineInjection_10am')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231018/Sleep_SalineInjection_10h/CRH_inhi_1488_saline_10h_231018_100350/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231018/Sleep_SalineInjection_10h/CRH_inhi_1489_saline_10h_231018_100350/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231027/Sleep_SalineInjection_10h/CRH_inhi_1510_saline_10h_231027_100938/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231027/Sleep_SalineInjection_10h/CRH_inhi_1511_saline_10h_231027_100938/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231027/Sleep_SalineInjection_10h/CRH_inhi_1512_saline_10h_231027_100938/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_CNOInjection_10am')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231027/Sleep_CNOInjection_10h/CRH_inhi_1488_cno_10h_231027_100938/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231025/Sleep_CNOInjection_10h/CRH_inhi_1489_sleep_cno_10h_231025_100714/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231025/Sleep_CNOInjection_10h/CRH_inhi_1510_sleep_cno_10h_231025_100714/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231025/Sleep_CNOInjection_10h/CRH_inhi_1511_sleep_cno_10h_231025_100714/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231025/Sleep_CNOInjection_10h/CRH_inhi_1512_sleep_cno_10h_231025_100714/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
%==========================================================================
%    Inhibitory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (2.5MG/KG) at 1PM
%==========================================================================
    
   
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_SalineInjection_1pm')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231105/Sleep_SalineInjection_13h/CRH_inhi_1488_saline_13h_231105_091503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231101/Sleep_SalineInjection_13h/CRH_inhi_1489_saline_13h_231101_084331/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231101/Sleep_SalineInjection_13h/CRH_inhi_1510_saline_13h_231101_084331/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231101/Sleep_SalineInjection_13h/CRH_inhi_1511_saline_13h_231101_084331/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231101/Sleep_SalineInjection_13h/CRH_inhi_1512_saline_13h_231101_084331/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'inhibDREADD_CRH_VLPO_CNOInjection_1pm')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231028/Sleep_CNOInjection_13h/CRH_inhi_1488_cno_13h_231028_090140/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231028/Sleep_CNOInjection_13h/CRH_inhi_1489_cno_13h_231028_090140/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231106/Sleep_CNOInjection_13h/CRH_inhi_1510_cno_13h_231106_090104/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231105/Sleep_CNOInjection_13h/CRH_inhi_1511_cno_13h_231105_091503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231105/Sleep_CNOInjection_13h/CRH_inhi_1512_cno_13h_231105_091503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;




%==========================================================================
%   inhibitory DREADDs receptors in the PFC (CNO 2.5mg/kg) (1 INJECTION)
%==========================================================================
    
elseif strcmp(experiment,'inhibDREADD_PFC_BaselineSleep')
    % Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210504/BaselineSleep/DREADD_1196_BaselineSleep3_210504_091101/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210504/BaselineSleep/DREADD_1197_BaselineSleep3_210504_091101/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1198
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1198/20210504/BaselineSleep/DREADD_1198_BaselineSleep3_210504_091101/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1235
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1235/20210928/BaselineSleep/DREADD_PFC_1235_Baseline_210928_092852/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1236
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1236/20210928/DREADD_PFC_1236_Baseline_210928_092852/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20210928/BaselineSleep/DREADD_PFC_1237_Baseline_210928_092852/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20210928/BaselineSleep/DREADD_PFC_1238_Baseline_210928_092852/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'inhibDREADD_PFC_SalineInjection_1pm')
    % Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210506/Sleep_SalineInjection/DREADD_1196_Nacl_210506_090150/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210506/Sleep_SalineInjection/DREADD_1197_Nacl_210506_090150/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1198
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1198/20210506/Sleep_SalineInjection/DREADD_1198_Nacl_210506_090150/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
elseif strcmp(experiment,'inhibDREADD_PFC_CNOInjection_1pm')
    % Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210511/Sleep_CNOInjection/DREADD_1196_CNO_210511_085525/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210511/Sleep_CNOInjection/DREADD_1197_CNO_210511_085525/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1198
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1198/20210511/Sleep_CNOInjection/DREADD_1198_CNO_210511_085525/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1235
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1235/20210929/Sleep_CNOInjection/DREADD_PFC_1235_CNO_210929_093424/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1236
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1236/20210929/Sleep_CNOInjection/DREADD_PFC_1236_CNO_210929_093424/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20210929/Sleep_CNOInjection/DREADD_PFC_1237_CNO_210929_093424/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20210929/Sleep_CNOInjection/DREADD_PFC_1238_CNO_210929_093424/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
%==========================================================================
%             Inhibitory DREADDs receptors in the PFC-VLPO pathway
%    retro-cre in the VLPO & inhibitory dreadds in the PFC (cre-dependant)
%                   (CNO 2.5mg/kg) (1 INJECTION)
%==========================================================================
    
elseif strcmp(experiment,'inhibDREADD_retroCre_PFC_VLPO_BaselineSleep')
    
elseif strcmp(experiment,'inhibDREADD_retroCre_PFC_VLPO_SalineInjection_1pm') %%injection à 13h
    %%First batch
    %Mouse 1245
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1245/20211118/Sleep_SalineInjection/DREADD_PFC_VLPO_1245_Saline_211118_091441/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1247
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1247/20211118/Sleep_SalineInjection/DREADD_PFC_VLPO_1247_Saline_211118_091441/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1248
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1248/20211118/Sleep_SalineInjection/DREADD_PFC_VLPO_1248_Saline_211118_091441/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%Second batch
    %Mouse 1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220519/Sleep_SalineInjection/DREADD_PFC_VLPO_1300_Saline_220519_090544/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220519/Sleep_SalineInjection/DREADD_PFC_VLPO_1301_Saline_220519_090544/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220519/Sleep_SalineInjection/DREADD_PFC_VLPO_1302_Saline_220519_090544/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220519/Sleep_SalineInjection/DREADD_PFC_VLPO_1303_Saline_220519_090544/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'inhibDREADD_retroCre_PFC_VLPO_CNOInjection_1pm') %%injection à 13h
    %%First batch
    %Mouse 1245
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1245/20211208/Sleep_CNOinjection/DREADD_PFC_VLPO_1245_CNO_211208_090523/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1247
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1247/20211209/Sleep_CNOInjection/DREADD_PFC_VLPO_1247_CNO_211209_085935/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1248
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1248/20211208/Sleep_CNOInjection/DREADD_PFC_VLPO_1248_CNO_211208_090523/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%Second batch
    %Mouse 1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220525/Sleep_CNOInjection/DREADD_PFC_VLPO_1300_CNO_220525_085221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220603/Sleep_CNOInjection/DREADD_PFC_VLPO_1301_cno_220603_085639/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220525/Sleep_CNOInjection/DREADD_PFC_VLPO_1302_CNO_220525_085221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220603/Sleep_CNOInjection/DREADD_PFC_VLPO_1303_cno_220603_085639/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'mCherry_retroCre_PFC_VLPO_BaselineSleep')
    %Mouse 1423
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1423/20230320/BaselineSleep/CTRL_PFC_VLPO_1423_baselinesleep_230320_083012/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1424
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1424/20230320/BaselineSleep/CTRL_PFC_VLPO_1424_baselinesleep_230320_083012/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1425
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1425/20230320/BaselineSleep/CTRL_PFC_VLPO_1425_baselinesleep_230320_083012/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1426
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1426/20230320/BaselineSleep/CTRL_PFC_VLPO_1426_baselinesleep_230320_083012/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %2e batch
    %Mouse 1433
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1433/20230419/BaselineSleep/CTRL_PFC_VLPO_1433_BaselineSleep_230419_091255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1434
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1434/20230419/BaselineSleep/CTRL_PFC_VLPO_1434_BaselineSleep_230419_091255/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1435
%     a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS182/CTRL_PFC_VLPO_1433_1434_1435_BaselineSleep_230419_091255/1435/'; % soustraire ref +à update quand sur serveur
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
elseif strcmp(experiment,'mCherry_retroCre_PFC_VLPO_SalineInjection_10am') %%injection à 10h (CONTROLE MANIPE DEFAITE SOCIALE : souris non dreadd et non stressées)
    %1e batch mcherry
    %Mouse 1423
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1423/20230316/Sleep_SalineInjection_10h/CTRL_PFC_VLPO_1423_saline_10h_230316_100751/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%Mouse 1424
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1424/20230316/Sleep_SalineInjection_10h/CTRL_PFC_VLPO_1424_saline_10h_230316_100751/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
    %Mouse 1425
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1425/20230316/Sleep_SalineInjection_10h/CTRL_PFC_VLPO_1425_saline_10h_230316_100751/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1426
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1426/20230316/Sleep_SalineInjection_10h/CTRL_PFC_VLPO_1426_saline_10h_230316_100751/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %2e batch mcherry
    %Mouse 1433
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1433/20230420/Sleep_SalineInjection/CTRL_PFC_VLPO_1433_Sleep_SalineInjection_230420_100957/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1434
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1434/20230420/Sleep_SalineInjection/CTRL_PFC_VLPO_1434_Sleep_SalineInjection_230420_100957/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1435
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1435/20230420/Sleep_SalineInjection_10h/CTRL_PFC_VLPO_1435_Sleep_SalineInjection_230420_100957/'; %BAD SIGNALS
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %3e batch mcherry
    %Mouse 1449
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1449/20230517/Sleep_SalineInjection_10h/CTRL_1449_saline_10h_230517_100502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1450
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1450/20230517/Sleep_SalineInjection_10h/CTRL_1450_saline_10h_230517_100502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1451
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1451/20230517/Sleep_SalineInjection_10h/CTRL_1451_saline_10h_230517_100502/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %%non dreadd mice (BM's)
    %Mouse1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1414/20230615/Sleep_SalineInjection_10h/BM_1414_Sleep_saline_10h_230615_100317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1439/20230601/Sleep_SalineInjection_10h/BM_1439_saline_10h_230601_095914/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1440/20230601/Sleep_SalineInjection_10h/BM_1440_saline_10h_230601_095914/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse1416
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1416/20230615/Sleep_SalineInjection_10h/BM_1416_Sleep_saline_10h_230615_100317/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1437/20230615/Sleep_SalineInjection_10h/BM_1437_Sleep_saline_10h_230615_100317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
elseif strcmp(experiment,'mCherry_retroCre_PFC_VLPO_CNOInjection_10am')%%injection à 10h (controles manip défaite sociale : souris non dreadd et non stressée)
    %Mouse 1423
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1423/20230321/Sleep_CNOInjection_10h/CTRL_PFC_VLPO_1423_cno_10h_230321_101024/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1424
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1424/20230321/Sleep_CNOInjection_10h/CTRL_PFC_VLPO_1424_cno_10h_230321_101024/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1425
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1425/20230321/Sleep_CNOInjection_10h/CTRL_PFC_VLPO_1425_cno_10h_230321_101024/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1426
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1426/20230321/Sleep_CNOInjection_10h/CTRL_PFC_VLPO_1426_cno_10h_230321_101024/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %2e batch
    %Mouse 1433
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1433/20230426/Sleep_CNOInjection/CTRL_1433_Sleep_CNOInjection_10h_230426_100211/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1434
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1434/20230426/Sleep_CNOInjection/CTRL_1434_Sleep_CNOInjection_10h_230426_100211/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1435
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1435/20230426/Sleep_CNOInjection/CTRL_1435_Sleep_CNOInjection_10h_230426_100211/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
%==========================================================================
%          Control experiments to test the effect of CNO ALONE
%            Protocole with one injection of CNO (2.5MG/KG)
%==========================================================================
    
elseif strcmp(experiment,'noDREADD_SalineInjection_1pm') %injection à 13h
    % Mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1107/20201013/Sleep_SalineInjection/DREADD_1107_Nacl_201013_090425/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1109
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1109/20210212/Sleep_SalineInjection/1109_Nacl_210212_090249/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1137
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1137/20210212/Sleep_SalineInjection/1137_Nacl_210212_090249/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'noDREADD_CNOInjection_1pm') %injection à 13h
    % Mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1107/20201016/Sleep_CNOInjection/DREADD_1107_CNO_201016_090240/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1109
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1109/20210217/Sleep_CNOInjection/1109_CNO_210217_090123/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1137
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1137/20210217/Sleep_CNOInjection/1137_CNO_210217_090123/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1254/20220510/Sleep_CNOInjection/1254_CNO_220510_085935/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
elseif strcmp(experiment,'noDREADD_SalineInjection_10am')%%injection à 10h
    %Mouse 1387
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1387/20230207/Sleep_Saline_10h/OPTO_1387_saline_10H_230127_095942/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1388
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1388/20230207/Sleep_Saline_10h/OPTO_1388_saline_10H_230127_095942/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1389
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1389/20230207/Sleep_Saline_10h/OPTO_1389_saline_10H_230207_100543/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1390
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1390/20230207/Sleep_Saline_10h/OPTO_1390_saline_10H_230207_100543/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
elseif strcmp(experiment,'noDREADD_CNOInjection_10am')%%injection à 10h
    %Mouse 1387
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS180/OPTO_1387_1388_cno_10H_230201_102204/1387/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1388
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS180/OPTO_1387_1388_cno_10H_230201_102204/1388/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1389
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS180/OPTO_1389_1390_cno_10H_230203_101657/1389/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1390
    a=a+1;Dir.path{a}{1}='/media/mobschapeau/DataMOBS180/OPTO_1389_1390_cno_10H_230203_101657/1390/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
    
    
elseif strcmp(experiment,'noDREADD_SalineInjection_1mg_1pm') %CTRL
    % Mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1107/20201020/Sleep_SalineInjection/DREADD_1107_Nacl_201020_085532/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'noDREADD_CNOInjection_1mg_1pm')  %CTRL
    % Mouse 1107
    a=a+1;Dir.path{a}{1}='/media/nas5/Thierry_DATA/M1107/20201022/Sleep_CNOInjection/DREADD_1107_CNO1mg_201022_090908/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    
elseif strcmp(experiment,'noDREADD_SalineInjections_9am_1pm') %CTRL
    
elseif strcmp(experiment,'noDREADD_CNOInjections_9am_1pm') %CTRL
    
    
    
    
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


