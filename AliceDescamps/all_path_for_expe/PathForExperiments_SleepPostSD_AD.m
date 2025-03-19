function Dir=PathForExperiments_SleepPostSD_AD(experiment)

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
%            ONE SENSORY EXPOSURE IN CD1 CAGE FOLLOWED BY EPM
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
%  5' in EPM
% sleep post social defeat and EPM
%==========================================================================
if strcmp(experiment,'SleepPostSDandEPM_OneSensoryExpo_noVirus')
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/SleepPostSDandEPM/tetrodes_PFC_1539_SleepPostSDandEPM_240109_100801/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240104/SleepPostSDandEPM/tetrodes_PFC_1540_SleepPostSDandEPM_240104_095212/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/SleepPostSDandEPM/tetrodes_PFC_1541_SleepPostSDandEPM_240109_100801/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
%==========================================================================
%      TWO SENSORY EXPOSURES IN CD1 CAGE AND HOMECAGE FOLLOWED BY EPM
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure)
%  5' in EPM
% sleep post social defeat and EPM
%==========================================================================
elseif strcmp(experiment,'SleepPostSDandEPM_TwoSensoryExpo_noVirus')
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SleepPostSDandEPM/tetrodes_PFC_1542_SleepPostSDandEPM_240111_103314/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SleepPostSDandEPM/tetrodes_PFC_1543_SleepPostSDandEPM_240111_103314/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
%==========================================================================
%  2nd sd : TWO SENSORY EXPOSURES IN CD1 CAGE AND HOMECAGE FOLLOWED BY EPM
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure)
%  5' in EPM
% sleep post social defeat and EPM
%==========================================================================
elseif strcmp(experiment,'SleepPostSDandEPM_TwoSensoryExpo_SecondRun_noVirus')
    %Mice that had one sensory exposure for 1st SD
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/SleepPostSDandEPM/tetrodes_PFC_1539_SleepPostSDandEPM_240118_104433/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240118/SleepPostSDandEPM/tetrodes_PFC_1540_SleepPostSDandEPM_240118_104433/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/SleepPostSDandEPM/tetrodes_PFC_1541_SleepPostSDandEPM_240118_104433/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mice that had two sensory exposures for 1st SD
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SleepPostSDandEPM/tetrodes_PFC_1542_SleepPostSDandEPM_SecondRun_240124_102321/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SleepPostSDandEPM/tetrodes_PFC_1543_SleepPostSDandEPM_SecondRun_240124_102321/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
    
    
    
    
    
    
    
    
    
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  sections bellow manipulate neurons with chemogenetic after SD  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%==========================================================================
%              TWO SENSORY EXPOSURES IN CD1 CAGE AND HOMECAGE
%      No DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure)
% Saline or CNO injection at 10 am
% sleep post social defeat
%==========================================================================
elseif strcmp(experiment,'SleepPostSD_mCherry_CRH_VLPO_SalineInjection_10am')    
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1566/20240403/SleepPostSD_SalineInjection/mCherry_CRH_1566_SleepPostSD_240403_100601/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %second batch
    %Mouse 1580 %%weird gamma and bad PFC so cannot score sleep properly
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240522/SleepPostSD_SalineInjection/mCherry_CRH_1580_SD_SalInj_SleepPostSD_240522_100324/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581 %careful : SD with no attacks / Do not use ?
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240522/SleepPostSD_SalineInjection/mCherry_CRH_1581_SD_SalInj_SleepPostSD_240522_100324/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %third batch
    %Mouse 1634 %%really bad theta, check if ther's something we can do : could be used for insomnia and studying sleep in general
%     a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/CRH_mCherry_1634_1635_SleepPostSD_SalInj_240827_100446/M1634/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240827/SleepPostSD_SalineInj/CRH_mCherry_1635_SleepPostSD_SalInj_240827_100446/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SleepPostSD_SecondRun_mCherry_CRH_VLPO_SalineInjection_10am')    
    %second batch
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240529/SleepPostSD_SecondRun_SalineInjection/mCherry_CRH_1578_SD2_SalInj_SleepPostSD_240529_100154/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579 %%weird gamma and bad PFC so cannot score sleep properly
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240529/SleepPostSD_SecondRun_SalineInjection/mCherry_CRH_1579_SD2_SalInj_SleepPostSD_240529_100154/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
   
    %third batch
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240906/SleepPostSD2_SalInj/CRH_mCherry_1636_SleepPostSD2_SalInj_240906_100218/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240906/SleepPostSD2_SalInj/CRH_mCherry_1637_SleepPostSD2_SalInj_240906_100218/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    
elseif strcmp(experiment,'SleepPostSD_mCherry_CRH_VLPO_CNOInjection_10am')
%     %Mouse 1567 
%     a=a+1;Dir.path{a}{1}=''; %bad HPC/no theta, do not use
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1568/20240401/SleepPostSD_CNOInjection/mCherry_CRH_1568_SleepPostSD_240401_101204/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1569/20240401/SleepPostSD_CNOInjection/mCherry_CRH_1569_SleepPostSD_240401_101204/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %second batch
    %Mouse 1578 %%weird gamma and bad PFC so cannot score sleep properly
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240517/SleepPostSD_CNOInjection/mCherry_CRH_1578_SD_CNOinj_SleepPostSD_240517_100710/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579 %%weird gamma and bad PFC so cannot score sleep properly
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240517/SleepPostSD_CNOInjection/mCherry_CRH_1579_SD_CNOinj_SleepPostSD_240517_100710/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %third batch
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240828/SleepPostSD_CNOInj/CRH_mCherry_1636_SleepPostSD_CNOInj_240828_100516/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240828/SleepPostSD_CNOInj/CRH_mCherry_1637_SleepPostSD_CNOInj_240828_100516/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SleepPostSD_SecondRun_mCherry_CRH_VLPO_CNOInjection_10am')    
    %second batch
    %Mouse 1580 %%weird gamma and bad PFC so cannot score sleep properly
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240604/SleepPostSD_SecondRun_CNOInjection/mCherry_CRH_1580_SD2_CNOInj_SleepPostSD_240604_101410/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240604/SleepPostSD_SecondRun_CNOInjection/mCherry_CRH_1581_SD2_CNOInj_SleepPostSD_240604_101410/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %third batch
%     %Mouse 1634 %%not transfered yet, really bad theta, do not use
%     a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/CRH_mCherry_1634_1635_SleepPostSD2_CNOInj_240905_100314/M1634/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240905/SleepPostSD2_CNOInj/CRH_mCherry_1635_SleepPostSD2_CNOInj_240905_100314/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
%==========================================================================
%              TWO SENSORY EXPOSURES IN CD1 CAGE AND HOMECAGE
%    Inhibitory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure)
% Saline or CNO injection at 10 am
% sleep post social defeat
%==========================================================================
elseif strcmp(experiment,'SleepPostSD_SecondRun_inhibDREADD_CRH_VLPO_SalineInjection_10am')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1488_sleepPostSD_saline_231207_100409/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1510_sleepPostSD_saline_231130_100457/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1511_sleepPostSD_saline_231130_100457/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231130/SleepPostSD_SalineInjection/DREADD_inhi_CRH_VLPO_1512_sleepPostSD_saline_231130_100457/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;


elseif strcmp(experiment,'SleepPostSD_inhibDREADD_CRH_VLPO_CNOInjection_10am')
    %Mouse 1488 
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SleepPostSD_CNOInjection/CRH_inhib_1488_SleepPstSD_cno_231107_100503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SleepPostSD_CNOInjection/CRH_inhib_1489_SleepPstSD_cno_231107_100503/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SleepPostSD_CNOInjection/CRH_inhib_1510_SleepPostSD_cno_231109_100320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SleepPostSD_CNOInjection/CRH_inhib_1511_SleepPostSD_cno_231109_100320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SleepPostSD_CNOInjection/CRH_inhib_1512_SleepPostSD_cno_231109_100320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240822/SleepPostSD_CNOInj/CRH_inhib_1631_SleepPostSD_240822_095713/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240823/SleepPostSD_CNOInj/CRH_inhib_1638_SleepPostSD_CNOInj_240823_100512/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1639 %bad theta
%     a=a+1;Dir.path{a}{1}=''; 
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
        

elseif strcmp(experiment,'SleepPostSD_SecondRun_inhibDREADD_CRH_VLPO_CNOInjection_10am')
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240830/SleepPostSD2_CNOInj/CRH_inhib_1631_SleepPostSD2_CNOInj_240830_095734/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240903/SleepPostSD2_CNOInjection/CRH_inhib_1638_SleepPostSD2_CNOInj_240903_100215/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240903/SleepPostSD2_CNOInjection/CRH_inhib_1639_SleepPostSD2_CNOInj_240903_100215/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    
    %%Wisden protocole
elseif strcmp(experiment,'SleepPostSD_ThirdRun_Wisden_mCherry_CRH_VLPO_SalineInjection_10am')    
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/mCherry_CRH_1578_SleepPostSD_SD3_WisdenProtocole_240614_100039/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/mCherry_CRH_1579_SleepPostSD_SD3_WisdenProtocole_240606_100718/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/mCherry_CRH_1580_SD3_Wisden_240618_100431/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/mobshamilton/DataMOBS202/mCherry_CRH_1581_SD3_WisdenProtocole_240620_100236/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

%==========================================================================
%              TWO SENSORY EXPOSURES IN CD1 CAGE AND HOMECAGE
%    Excitatory DREADDs receptors in VLPO CRH-neurons (CRH-cre mouse line)
%
%  5' in CD1 cage (physical interaction)
% 20' in CD1 cage w/ separator (sensory exposure)
% 20' in C57 cage w/ separator (sensory exposure)
% Saline or CNO injection at 10 am
% sleep post social defeat
%==========================================================================

elseif strcmp(experiment,'SleepPostSD_exciDREADD_CRH_VLPO_SalineInjection_10am')
    %Mouse 1674
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1674/20241013/SleepPostSD_SalineInjection/exci_CRH_Hetero_1674_SD_SleepPostSD_SalInj_241013_100547/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1675
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1675/20241013/SleepPostSD_SalineInjection/exci_CRH_Hetero_1675_SD_SleepPostSD_SalInj_241013_100547/'; 
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1676
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1676/20241012/SleepPostSD_SalineInjection/exci_CRH_Hetero_1676_SD_SleepPostSD_SalInj_241012_100034/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1677
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1677/20241012/SleepPostSD_SalineInjection/exci_CRH_Hetero_1677_SD_SleepPostSD_SalInj_241012_100034/'; 
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
