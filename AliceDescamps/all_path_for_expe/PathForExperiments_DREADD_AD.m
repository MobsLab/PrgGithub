function Dir=PathForExperiments_DREADD_AD(experiment)

% INPUT:
% name of the experiment.
% possible choices:

% OUTPUT
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
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

%==========================================================================
%      No DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (2.5MG/KG) at 10AM
%==========================================================================
if strcmp(experiment,'mCherry_CRH_VLPO_SalineInjection_10am')
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1566/20240320/Sleep_SalineInjection/mCherry_CRH_1566_Saline_Inj_240320_100244/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1567
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1567/20240320/Sleep_SalineInjection/mCherry_CRH_1567_Saline_Inj_240320_100244/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1568/20240327/Sleep_SalineInjection/mCherry_CRH_1568_SalineInj_240327_100757/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1569/20240327/Sleep_SalineInjection/mCherry_CRH_1569_SalineInj_240327_100757/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse; 
    
    %Second Batch
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240430/Sleep_SalineInjection/mCherry_CRH_1578_SalInj_10h_240430_100221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240430/Sleep_SalineInjection/mCherry_CRH_1579_SalInj_10h_240430_100221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240507/Sleep_SalineInjection/mCherry_CRH_1580_Salinj_240507_100127/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581 %%big insomnia until 3 hours after start of recording : got tanggled a lot, to suppress ??
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240507/Sleep_SalineInjection/mCherry_CRH_1581_Salinj_240507_100127/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %3rd batch
%     %Mouse 1634    %%really bad theta
%     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240813/Sleep_SalineInjection_10h/CRH_mCherry_1634_SalInj_240813_100854/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240813/Sleep_SalineInjection_10h/CRH_mCherry_1635_SalInj_240813_100854/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240807/Sleep_SalineInjection_10h/CRH_mCherry_1636_SalInjection_240807_100002/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240807/Sleep_SalineInjection_10h/CRH_mCherry_1637_SalInjection_240807_100002/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'mCherry_CRH_VLPO_CNOInjection_10am')
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1566/20240327/Sleep_CNOInjection/mCherry_CRH_1566_CNOInj_240327_100757/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1567 %très mauvais theta, pas de REM
%     a=a+1;Dir.path{a}{1}='';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1568/20240320/Sleep_CNOInjection/mCherry_CRH_1568_CNOInj_240320_100244/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1569/20240320/Sleep_CNOInjection/mCherry_CRH_1569_CNOInj_240320_100244/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
    %Second Batch
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240507/Sleep_CNOInjection/mCherry_CRH_1578_CNOinj_240507_100127/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240507/Sleep_CNOInjection/mCherry_CRH_1579_CNOinj_240507_100127/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240430/Sleep_CNOInjection/mCherry_CRH_1580_CNOInj_10h_240430_100221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581 %%big insomnia during the day : to suppress ?? same as in saline
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240430/Sleep_CNOInjection/mCherry_CRH_1581_CNOInj_10h_240430_100221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %3rd batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240807/Sleep_CNOInjection_10h/CRH_mCherry_1634_CNOInjection_240807_100002/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240807/Sleep_CNOInjection_10h/CRH_mCherry_1635_CNOInjection_240807_100002/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636 %weird gamma and accelero scoring with a lot of changes in the begining of the session, wake is not scored properly
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240813/Sleep_CNOInjection_10h/CRH_mCherry_1636_CNOInj_240813_100854/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240813/Sleep_CNOInjection_10h/CRH_mCherry_1637_CNOInj_240813_100854/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

%==========================================================================
%      No DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (1MG/KG) at 10AM
%==========================================================================

elseif strcmp(experiment,'mCherry_CRH_VLPO_CNOInjection_1mgkg_10am')
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/CRH_mCherry_1634_1635_1636_1637_CNO_1mg_kg_240820_095755/M1634/'; %bad theta
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/CRH_mCherry_1634_1635_1636_1637_CNO_1mg_kg_240820_095755/M1635/'; %bad theta
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/CRH_mCherry_1634_1635_1636_1637_CNO_1mg_kg_240820_095755/M1636/'; %bad theta
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/CRH_mCherry_1634_1635_1636_1637_CNO_1mg_kg_240820_095755/M1637/'; %bad theta
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;


%==========================================================================
%    Excitatory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (2.5MG/KG) at 1PM
%==========================================================================
elseif strcmp(experiment,'exciDREADD_CRH_VLPO_SalineInjection_1pm') %Mathilde Data
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
    
elseif strcmp(experiment,'exciDREADD_homo_CRH_VLPO_SalineInjection_1pm') %test homo/hetero
    % Mouse 1667
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1667/20240928/Sleep_SalineInjection_13h/exci_CRH_Homo_1667_SalInj_13h_240928_090108/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1668
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1668/20240928/Sleep_SalineInjection_13h/exci_CRH_Homo_1668_SalInj_13h_240928_090108/';
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

elseif strcmp(experiment,'exciDREADD_homo_CRH_VLPO_CNOInjection_1pm') %test homo/hetero
    % Mouse 1667
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1668
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
elseif strcmp(experiment,'exciDREADD_homo_CRH_VLPO_CNOInjection_1pm') %test homo/hetero
    % Mouse 1674
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1674/20241002/Sleep_SalineInjection_13h/exci_CRH_Hetero_1674_SalInj_13h_241002_085548/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1675
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1675/20241002/Sleep_SalineInjection_13h/exci_CRH_Hetero_1675_SalInj_13h_241002_085548/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1676
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1677
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'exciDREADD_hetero_CRH_VLPO_CNOInjection_1pm') %test homo/hetero
    % Mouse 1674
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1674/20241009/Sleep_CNOInjection_13h/exci_CRH_Hetero_1674_CNOInj_241009_085721/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1675
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1675/20241009/Sleep_CNOInjection_13h/exci_CRH_Hetero_1675_CNOInj_241009_085721/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1676
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    % Mouse 1677
    a=a+1;Dir.path{a}{1}='';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

%==========================================================================
%    Inhibitory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%         Protocole with one injection of CNO (2.5MG/KG) at 10AM
%==========================================================================
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
    
    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240809/Sleep_SalineInjection_10h/CRH_inhib_1631_SalInj_240809_095932/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240802/Sleep_SalineInjection_10h/CRH_inhib_1638_SalInj_240802_100134/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240802/Sleep_SalineInjection_10h/CRH_inhib_1639_SalInj_240802_100134/';
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
    
    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240802/Sleep_CNOInjection_10h/CRH_inhib_1631_CNOInj_240802_100134/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240809/Sleep_CNOInjection_10h/CRH_inhib_1638_CNOInj_240809_095932/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240809/Sleep_CNOInjection_10h/CRH_inhib_1639_CNOInj_240809_095932/';
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
