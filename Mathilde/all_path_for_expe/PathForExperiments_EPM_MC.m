function Dir=PathForExperiments_EPM_MC(experiment)

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
if strcmp(experiment,'EPM_ctrl')
    Mouse 1449
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1449/20230414/EPM_Basal/ERC-Mouse-1449-14042023-EPM_00/';
    Mouse 1450
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1450/20230414/EPM_Basal/ERC-Mouse-1450-14042023-EPM_00/';
    Mouse 1451
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1451/20230414/EPM_Basal/ERC-Mouse-1451-14042023-EPM_00/';
    Mouse 1452
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1452/20230414/EPM_Basal/ERC-Mouse-1452-14042023-EPM_00/';
    Mouse 1453
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1453/20230414/EPM_Basal/ERC-Mouse-1453-14042023-EPM_00/';
    Eleonore's mice
    Mouse CLA231
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA231/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_00/';
    Mouse CLA232
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA232/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_02/';
    Mouse CLA234
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA234/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_05/';
    Mouse CLA235
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA235/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_06/';
    Mouse EV93
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV93/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_03/';
    Mouse EV94
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV94/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_04/';
    
elseif strcmp(experiment,'EPM_ctrl_EV')
    %Eleonore's mice
    %Mouse CLA231
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA231/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_00/';
    %Mouse CLA232
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA232/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_02/';
    %Mouse CLA234
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA234/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_05/';
    %Mouse CLA235
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/CLA235/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_06/';
    %Mouse EV93
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV93/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_03/';
    %Mouse EV94
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV94/20230602/EPM_Basal/ERC-Mouse-NaN-02062023-EPM_04/';

elseif strcmp(experiment,'EPM_behav_wiCable_saline') %%with cable plugged for ephy
    %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20211221/EPM_saline/1196_EPM_saline_211221_154345/FEAR-Mouse-1196-21122021-EPM_01/';
    %Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211226/EPM_saline/1237_EPM_saline_211226_123151/FEAR-Mouse-1237-26122021-EPM_00/';
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211226/EPM_saline/1238_EPM_saline_211226_124412/FEAR-Mouse-1238-26122021-EPM_00/';
    
    
elseif strcmp(experiment,'EPM_behav_woCable_saline') %%not plugged
    %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20220222/EPM_saline/ERC-Mouse-1196-22022022-EPM_00/';
    %Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20220222/EPM_saline/ERC-Mouse-1237-22022022-EPM_00/';
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20220222/EPM_saline/ERC-Mouse-1238-22022022-EPM_00/';
    
    
elseif strcmp(experiment,'EPM_behav_wiCable_inhibitionPFC') %%with cable plugged for ephy
    %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210514/EMP_inhibitionPFC/1196_EPM_210514_134406/FEAR-Mouse-1196-14052021-EPM_00/';
    %Mouse 1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210514/EPM_inhibitionPFC/1197_EPM_210514_135609/FEAR-Mouse-1197-14052021-EPM_00/';
    %Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211221/EPM_inhibitionPFC/1237_EPM_cno_211221_155252/FEAR-Mouse-1237-21122021-EPM_00/';
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211221/EPM_inhibitionPFC/1238_EPM_cno_211221_160210/FEAR-Mouse-1238-21122021-EPM_00/';
    
elseif strcmp(experiment,'EPM_behav_woCable_inhibitionPFC') %%not plugged
    %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20220201/EPM_CNO/ERC-Mouse-1196-01022022-EPM_00/';
    %Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20220201/EPM_CNO/ERC-Mouse-1237-01022022-EPM_00/';
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20220201/EPM_CNO/ERC-Mouse-1238-01022022-EPM_00/';
    
    
elseif strcmp(experiment,'EPM_behav_retro_cre_saline') %%not plugged
    %Mouse1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220816/EPM_saline/ERC-Mouse-1300-16082022-EPM_00/';
    %Mouse1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220816/EPM_saline/ERC-Mouse-1301-16082022-EPM_00/';
    %Mouse1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220822/EPM_saline/ERC-Mouse-1302-22082022-EPM_00/';
    %Mouse1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220822/EPM_saline/ERC-Mouse-1303-22082022-EPM_00/';
    
    
elseif strcmp(experiment,'EPM_behav_retro_cre_cno') %%not plugged
    %Mouse1300
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1300/20220822/EPM_CNO/ERC-Mouse-1300-22082022-EPM_07/';
    %Mouse1301
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1301/20220822/EPM_CNO/ERC-Mouse-1301-22082022-EPM_00/';
    %Mouse1302
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1302/20220816/EPM_cno/ERC-Mouse-1302-16082022-EPM_00/';
    %Mouse1303
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1303/20220816/EPM_CNO/ERC-Mouse-1303-16082022-EPM_00/';
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
elseif strcmp(experiment,'EPM_behav_dreadd_exci_CRH_VLPO_saline') %%not plugged
    %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20230110/EPM_saline/ERC-Mouse-1371-10012023-EPM_00/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20230110/EPM_saline/ERC-Mouse-1372-10012023-EPM_00/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20230117/EPM_saline/ERC-Mouse-1373-17012023-EPM_00/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20230117/EPM_saline/ERC-Mouse-1374-17012023-EPM_00/';
    
    
elseif strcmp(experiment,'EPM_behav_dreadd_exci_CRH_VLPO_cno') %%not plugged
    %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20230117/EPM_CNO/ERC-Mouse-1371-17012023-EPM_00/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20230117/EPM_CNO/ERC-Mouse-1372-17012023-EPM_00/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20230110/EPM_CNO/ERC-Mouse-1373-10012023-EPM_00/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20230110/EPM_CNO/ERC-Mouse-1374-10012023-EPM_00/';
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%Alice's mice
elseif strcmp(experiment,'EPM_10h_behav_dreadd_exci_CRH_VLPO_saline') %%not plugged
    %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20230125/EPM_SalineInjection/ERC-Mouse-1371-25012023-EPM_00/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20230125/EPM_SalineInjection/ERC-Mouse-1372-25012023-EPM_00/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20230130/EPM_SalineInjection/ERC-Mouse-1373-30012023-EPM_00/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20230130/EPM_SalineInjection/ERC-Mouse-1374-30012023-EPM_00/';
    
    
elseif strcmp(experiment,'EPM_10h_behav_dreadd_exci_CRH_VLPO_cno') %%not plugged
    %Mouse1371
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1371/20230202/EPM_CNOInjection/ERC-Mouse-1371-02022023-EPM_00/';
    %Mouse1372
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1372/20230202/EPM_CNOInjection/ERC-Mouse-1372-02022023-EPM_00/';
    %Mouse1373
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1373/20230126/EPM_CNOInjection/ERC-Mouse-1373-26012023-EPM_00/';
    %Mouse1374
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1374/20230126/EPM_CNOInjection/ERC-Mouse-1374-26012023-EPM_00/';
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
elseif strcmp(experiment,'EPM_Ephy_saline')
    %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20211221/EPM_saline/1196_EPM_saline_211221_154345/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %     %Mouse 1237
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211226/EPM_saline/1237_EPM_saline_211226_123151/';
    % %     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211226/EPM_saline/1238_EPM_saline_211226_124412/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'EPM_Ephy_inhibitionPFC')
    %Mouse 1196
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1196/20210514/EMP_inhibitionPFC/1196_EPM_210514_134406/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1197
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1197/20210514/EPM_inhibitionPFC/1197_EPM_210514_135609/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1237
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1237/20211221/EPM_inhibitionPFC/1237_EPM_cno_211221_155252/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1238
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetPFCVLPO/M1238/20211221/EPM_inhibitionPFC/1238_EPM_cno_211221_160210/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
    %==========================================================================
    %           "OUR CLASSIC" VERSION OF THE SOCIAL DEFEAT PROTOCOL
    %                   without sleep and followed by EPM
    %
    %  5' in CD1 cage (physical interaction)
    % 20' in CD1 cage w/ separator (sensory exposure)
    % 20' in C57 cage w/ separator (sensory exposure) : association sleep envnt w/ the stressor
    %  5' EPM
    %==========================================================================
elseif strcmp(experiment,'EPM_Post_SD')
    %mouse1429
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1429/20230403/EPM_Post_SocialDefeat/ERC-Mouse-1429-03042023-EPM_00/'; %% !! no Ephy
    %mouse1430
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1430/20230403/EPM_Post_SocialDefeat/ERC-Mouse-1430-03042023-EPM_00/'; %% !! no Ephy
    %mouse1431
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1431/20230403/EPM_Post_SocialDefeat/ERC-Mouse-1431-03042023-EPM_00/'; %% !! no Ephy
    %mouse1432
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1432/20230403/EPM_Post_SocialDefeat/ERC-Mouse-1432-03042023-EPM_00/'; %% !! no Ephy
    %mouse1452
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1452/20230512/EPM_Post_SocialDefeat/ERC-Mouse-1452-12052023-EPM_00/'; %% !! no Ephy
    
    %mouseEV105
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV105/20230809/EMP_PostSD/ERC-Mouse-105-09082023-EPM_00/'; %% !! no Ephy
    %     %mouseEV106
    % a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV106/20230809/EMP_PostSD/ERC-Mouse-106-09082023-EPM_00/'; %% !! no Ephy %%%% RETRACK OFFLINE
    %mouseEV107
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV107/20230809/EMP_PostSD/ERC-Mouse-107-09082023-EPM_00/'; %% !! no Ephy
    %mouseEV108
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV108/20230809/EMP_PostSD/ERC-Mouse-108-09082023-EPM_00/'; %% !! no Ephy
    %mouseEV269
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV269/20230809/EMP_PostSD/ERC-Mouse-269-09082023-EPM_00/'; %% !! no Ephy
    %mouseEV270
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV270/20230809/EMP_PostSD/ERC-Mouse-270-09082023-EPM_00/'; %% !! no Ephy
    
elseif strcmp(experiment,'EPM_Post_SD_tetrodesPFC')
    %tetrodes PFC
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/EPM/ERC-Mouse-1542-11012024-EPM_00/'; %% !! no Ephy
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/EPM/ERC-Mouse-1543-11012024-EPM_00/'; %% !! no Ephy


elseif strcmp(experiment,'EPM_Post_SD_secondRound')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/EPM/ERC-Mouse-1539-18012024-EPM_00/'; %% !! no Ephy !! warning : first SD was only one ensory expo
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/EPM/ERC-Mouse-1541-18012024-EPM_00/'; %% !! no Ephy !! warning : first SD was only one ensory expo
    %mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/EPM/ERC-Mouse-1542-24012024-EPM_00/'; %% !! no Ephy
    %mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/EPM/ERC-Mouse-1543-24012024-EPM_00/'; %% !! no Ephy
    
    
    %==========================================================================
    %            SECOND VERSION OF THE SOCIAL DEFEAT PROTOCOL
    % (sleep after stress / no association between sleep envnt and the stressor)
    %                   without sleep and followed by EPM
    %
    %  5' in CD1 cage (physical interaction)
    % 20' in CD1 cage w/ separator (sensory exposure)
    % 20' in CD1 cage w/ separator (sensory exposure)
    %  5' EPM
    %==========================================================================
elseif strcmp(experiment,'EPM_Post_SDsafe')
    %mouse1453
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1453/20230512/EPM_Post_SDSafe/ERC-Mouse-1453-12052023-EPM_00/'; %% !! no Ephy
    %mouse1454
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1454/20230531/EPM_Post_SDSafe/ERC-Mouse-1454-31052023-EPM_00/'; %% !! no Ephy
    %mouse1455
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1455/20230531/EPM_Post_SDSafe/ERC-Mouse-1455-31052023-EPM_00/'; %% !! no Ephy
    %mouse1456
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1456/20230601/EPM_Post_SDSafe/ERC-Mouse-1456-01062023-EPM_00/'; %% !! no Ephy
    %mouse1457
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1457/20230601/EPM_Post_SDSafe/ERC-Mouse-1457-01062023-EPM_00/'; %% !! no Ephy
    
        %mouse1466
        a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1466/20230701/EPM_PostSD/ERC-Mouse-1466-01072023-EPM_00/'; %% !! no Ephy
        %mouse1467
        a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1467/20230701/EPM_PostSD/ERC-Mouse-1467-01072023-EPM_00/'; %% !! no Ephy
        %mouse1468
        a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1468/20230701/EPM_PostSD/ERC-Mouse-1468-01072023-EPM_00/'; %% !! no Ephy
        %mouse1469
        a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1469/20230701/EPM_PostSD/ERC-Mouse-1469-01072023-EPM_00/'; %% !! no Ephy
        %mouse1470
%         a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1470/20230701/EPM_PostSD/ERC-Mouse-1470-01072023-EPM_00/'; %% !! no Ephy
    
%         %mouse1466
%         a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1466/20230726/EPM_Post_SDSafe/ERC-Mouse-1466-26072023-EPM_00/'; %% !! no Ephy
%         %mouse1468
%         a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1468/20230726/EPM_Post_SDSafe/ERC-Mouse-1468-26072023-EPM_00/'; %% !! no Ephy
%         %mouse1469
%         a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1469/20230726/EPM_Post_SDSafe/ERC-Mouse-1469-26072023-EPM_00/'; %% !! no Ephy
%         %mouse1470
%         a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1470/20230726/EPM_Post_SDSafe/ERC-Mouse-1470-26072023-EPM_00/'; %% !! no Ephy
%     
    %mouseEV101
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV101/20230808/EPM_postSDsafe/ERC-Mouse-101-08082023-EPM_00/'; %% !! no Ephy
    %mouseEV102
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV102/20230808/EPM_postSDsafe/ERC-Mouse-102-08082023-EPM_00/'; %% !! no Ephy
    %mouseEV103
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV103/20230808/EPM_postSDsafe/ERC-Mouse-103-08082023-EPM_00/'; %% !! no Ephy
    %mouseEV104
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV104/20230808/EPM_postSDsafe/ERC-Mouse-104-08082023-EPM_00/'; %% !! no Ephy
    %mouseEV113
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV113/20230808/EPM_postSDsafe/ERC-Mouse-113-08082023-EPM_00/'; %% !! no Ephy
    %mouseEV114
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/EV114/20230808/EPM_postSDsafe/ERC-Mouse-114-08082023-EPM_00/'; %% !! no Ephy
    
    %==========================================================================
    %            Third VERSION OF THE SOCIAL DEFEAT PROTOCOL
    % (sleep after stress / no association between sleep envnt and the stressor)
    %                   with sleep and followed by EPM
    %
    %  5' in CD1 cage (physical interaction)
    % 20' in CD1 cage w/ separator (sensory exposure)
    %  5' EPM
    %  Sleep
    %==========================================================================  
    
elseif strcmp(experiment,'EPM_Post_SD_OneSensoryExposure')
    %mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/EPM/ERC-Mouse-1539-09012024-EPM_00/'; %% !! no Ephy
    %mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240104/EPM/FEAR-Mouse-1540-04012024-EPM_00/'; %% !! no Ephy
    %mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/EPM/ERC-Mouse-1541-09012024-EPM_00/'; %% !! no Ephy
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
