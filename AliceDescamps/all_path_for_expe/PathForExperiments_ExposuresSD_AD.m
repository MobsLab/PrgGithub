function Dir=PathForExperiments_ExposuresSD_AD(experiment)

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
%                Physical Exposure (5') of Social Defeat
%==========================================================================
if strcmp(experiment,'PhysicalExposure_CD1cage_noVirus')
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/SocialDefeat_oneSensoryExpo/PhysicalExposure_CD1cage/SLEEP-Mouse-1539&1541&1536&1538-09012024_00/';
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240104/SocialDefeat_oneSensoryExpo/PhysicalExposure_CD1cage/SLEEP-Mouse-1540&1537&0&1-04012024_00/';
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/SocialDefeat_oneSensoryExpo/PhysicalExposure_CD1cage/SLEEP-Mouse-1539&1541&1536&1538-09012024_00/';
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1542&1543&1537&1538-11012024_00/';
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1542&1543&1537&1538-11012024_00/';
    
elseif strcmp(experiment,'PhysicalExposure_CD1cage_SecondRun_noVirus')
%     %Mice that had one sensory exposure for 1st SD
%     %Mouse 1539
%     a=a+1;Dir.path{a}{1}='';%transfer on nas
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1540
%     a=a+1;Dir.path{a}{1}='';%transfer on nas
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
%     %Mouse 1541
%     a=a+1;Dir.path{a}{1}='';%transfer on nas
%     load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mice that had two sensory exposures for 1st SD
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1542&1543&1535&1537-24012024_00/';
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1542&1543&1535&1537-24012024_00/';
    
elseif strcmp(experiment,'PhysicalExposure_CD1cage_mCherry_CRH_VLPO')    
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1566/20240403/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1566&1567&1572&1577-03042024_00/';
    %Mouse 1567
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1567/20240403/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1566&1567&1572&1577-03042024_00/';
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1568/20240401/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1568&1569&1572&1575-01042024_00/';
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1569/20240401/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1568&1569&1572&1575-01042024_00/';
    
    %second batch
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240517/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1578&1579&1627&1629-17052024_00/';
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240517/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1578&1579&1627&1629-17052024_00/';
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240522/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1581&1580&1627&1630-22052024_00/';
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240522/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1581&1580&1627&1630-22052024_00/';
    
    %third batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240827/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1634&1635&1647&1648-27082024_00/';
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240827/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1634&1635&1647&1648-27082024_00/';
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240828/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1636&1637&1647&1649-28082024_00/';
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240828/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1636&1637&1647&1649-28082024_00/';
    
elseif strcmp(experiment,'PhysicalExposure_CD1cage_SecondRun_mCherry_CRH_VLPO')    
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240529/SocialDefeat_SecondRun/PhysicalExposure_CD1cage/SLEEP-Mouse-1578&1579&1525&1526-29052024_00/';
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240529/SocialDefeat_SecondRun/PhysicalExposure_CD1cage/SLEEP-Mouse-1578&1579&1525&1526-29052024_00/';
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240604/SocialDefeat_SecondRun/PhysicalExposure_CD1cage/SLEEP-Mouse-1580&1581&1625&1626-04062024_00/';
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240604/SocialDefeat_SecondRun/PhysicalExposure_CD1cage/SLEEP-Mouse-1580&1581&1625&1626-04062024_00/';
    
    %third batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240905/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1634&1635&1648&1647-05092024_00/';
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240905/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1634&1635&1648&1647-05092024_00/';
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240906/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1636&1637&1649&1647-06092024_00/';
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240906/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1636&1637&1649&1647-06092024_00/';

elseif strcmp(experiment,'PhysicalExposure_CD1cage_inhibDREADD_CRH_VLPO')
    %Mouse 1488 
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1488&1489&1524&1525-07112023_00/';
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1488&1489&1524&1525-07112023_00/';
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1510&1511&1512&1-30112023_00/';
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1510&1511&1512&1-30112023_00/';
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231130/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1510&1511&1512&1-30112023_00/';
    
    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240822/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1631&1647&0&1-22082024_00/';
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240823/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1638&1639&1647&1648-23082024_00/';
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240823/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1638&1639&1647&1648-23082024_00/';

elseif strcmp(experiment,'PhysicalExposure_CD1cage_SecondRun_inhibDREADD_CRH_VLPO')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1488&1489&1535&1537-07122023_00/';
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231207/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1488&1489&1535&1537-07122023_00/';
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1510&1511&1512&0-09112023_00/';
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1510&1511&1512&0-09112023_00/';
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SocialDefeat/PhysicalExposure_CD1cage/SLEEP-Mouse-1510&1511&1512&0-09112023_00/';

    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240830/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1631&1649&0&1-30082024_00/';
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240903/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1638&1639&1648&1647-03092024_00/';
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240903/SocialDefeat2/PhysicalExposure_CD1cage/SLEEP-Mouse-1638&1639&1648&1647-03092024_00/';
    
    
%==========================================================================
%               1st Sensory Exposure (20') of Social Defeat
%==========================================================================

elseif strcmp(experiment,'FirstSensoryExposure_CD1cage_noVirus')
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240109/SocialDefeat_oneSensoryExpo/SensoryExposure_CD1cage/tetrodes_PFC_1539_sensoryexpoCD1cage_240109_091153/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240104/SocialDefeat_oneSensoryExpo/SensoryExposure_CD1cage/tetrodes_PFC_1540_sensoryexpoCD1cage_240104_091322/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240109/SocialDefeat_oneSensoryExpo/SensoryExposure_CD1cage/tetrodes_PFC_1541_sensoryexpoCD1cage_240109_091153/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1542_sensoryexpoCD1cage_240111_090708/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1543_sensoryexpoCD1cage_240111_090708/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'FirstSensoryExposure_CD1cage_SecondRun_noVirus')
    %Mice that had one sensory exposure for 1st SD
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/SocialDefeat_SecondSD/SensoryExposure_CD1cage/tetrodes_PFC_1539_SensoryExpo_CD1cage_secondSD_240118_090958/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240118/SocialDefeat_SecondSD/SensoryExposure_CD1cage/tetrodes_PFC_1540_SensoryExpo_CD1cage_secondSD_240118_090958/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/SocialDefeat_SecondSD/SensoryExposure_CD1cage/tetrodes_PFC_1541_SensoryExpo_CD1cage_secondSD_240118_090958/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mice that had two sensory exposures for 1st SD
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1542_SensoryExpo_CD1cage_240124_090500/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SocialDefeat/SensoryExposure_CD1cage/tetrodes_PFC_1543_SensoryExpo_CD1cage_240124_090500/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
elseif strcmp(experiment,'FirstSensoryExposure_CD1cage_mCherry_CRH_VLPO')    
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1566/20240403/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1566_SensoryExpoCD1cage_240403_091117/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1567
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1567/20240403/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1567_SensoryExpoCD1cage_240403_091117/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1568/20240401/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1568_SensoryExpoCD1cage_240401_091527/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1569/20240401/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1569_SensoryExpoCD1cage_240401_091527/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %second batch
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240517/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1578_SD_CNOinj_SensoryExpoCD1cage_240517_091240/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240517/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1579_SD_CNOinj_SensoryExpoCD1cage_240517_091240/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240522/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1580_SD_SalInj_SensoryExpoCD1cage_240522_090743/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240522/SocialDefeat/SensoryExposure_CD1cage/mCherry_CRH_1581_SD_SalInj_SensoryExpoCD1cage_240522_090743/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
        
    %third batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240827/SocialDefeat/SensoryExposure_CD1cage/CRH_mCherry_1634_SensoryExposure_CD1cage_240827_091203/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240827/SocialDefeat/SensoryExposure_CD1cage/CRH_mCherry_1635_SensoryExposure_CD1cage_240827_091203/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240828/SocialDefeat/SensoryExposure_CD1cage/CRH_mCherry_1636_SensoryExposure_CD1cage_240828_091245/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240828/SocialDefeat/SensoryExposure_CD1cage/CRH_mCherry_1637_SensoryExposure_CD1cage_240828_091245/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'FirstSensoryExposure_CD1cage_SecondRun_mCherry_CRH_VLPO')    
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240529/SocialDefeat_SecondRun/SensoryExposure_CD1cage/mCherry_CRH_1578_SD2_SalInj_SensoryExpoCD1cage_240529_090817/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240529/SocialDefeat_SecondRun/SensoryExposure_CD1cage/mCherry_CRH_1579_SD2_SalInj_SensoryExpoCD1cage_240529_090817/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240604/SocialDefeat_SecondRun/SensoryExposure_CD1cage/mCherry_CRH_1580_SD2_CNOInj_SensoryExpoCD1cage_240604_091857/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240604/SocialDefeat_SecondRun/SensoryExposure_CD1cage/mCherry_CRH_1581_SD2_CNOInj_SensoryExpoCD1cage_240604_091857/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
        
    %third batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240905/SocialDefeat2/SensoryExposure_CD1cage/CRH_mCherry_1634_SensoryExposure_CD1cage_240905_091128/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240905/SocialDefeat2/SensoryExposure_CD1cage/CRH_mCherry_1635_SensoryExposure_CD1cage_240905_091128/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240906/SocialDefeat2/SensoryExposure_CD1cage/CRH_mCherry_1636_SensoryExposure_CD1cage_240906_091028/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240906/SocialDefeat2/SensoryExposure_CD1cage/CRH_mCherry_1637_SensoryExposure_CD1cage_240906_091028/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'FirstSensoryExposure_CD1cage_inhibDREADD_CRH_VLPO')
    %Mouse 1488 
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1488_SensoryExposure_CD1cage_231107_091404/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1489_SensoryExposure_CD1cage_231107_091404/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1510_SensoryExposure_CD1cage_231109_091143/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1511_SensoryExposure_CD1cage_231109_091143/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1512_SensoryExposure_CD1cage_231109_091143/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240822/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1631_SensoryExposure_CD1cage_240822_090756/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240823/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1638_SensoryExposure_CD1cage_240823_091313/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240823/SocialDefeat/SensoryExposure_CD1cage/CRH_inhib_1639_SensoryExposure_CD1cage_240823_091313/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'FirstSensoryExposure_CD1cage_SecondRun_inhibDREADD_CRH_VLPO')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1488_sensoryExpoCD1cage2_231207_091417/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231207/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1489_sensoryExpoCD1cage2_231207_091417/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1510_sensoryExpoCD1cage_231130_091317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1511_sensoryExpoCD1cage_231130_091317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231130/SocialDefeat/SensoryExposure_CD1cage/DREADD_inhi_CRH_VLPO_1512_sensoryExpoCD1cage_231130_091317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240830/SocialDefeat2/SensoryExposure_CD1cage/CRH_inhib_1631_SensoryExpoCD1cage_240830_090653/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240903/SocialDefeat2/SensoryExposure_CD1cage/CRH_inhib_1638_SensoryExposure_CD1cage_240903_091029/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240903/SocialDefeat2/SensoryExposure_CD1cage/CRH_inhib_1639_SensoryExposure_CD1cage_240903_091029/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    

%==========================================================================
%               2nd Sensory Exposure (20') of Social Defeat
%==========================================================================

elseif strcmp(experiment,'SecondSensoryExposure_C57cage_noVirus')
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240111/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1542_sensoryexpoC57cage_240111_093432/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240111/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1543_sensoryexpoC57cage_240111_093432/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SecondSensoryExposure_C57cage_SecondRun_noVirus')
    %Mice that had one sensory exposure for 1st SD
    %Mouse 1539
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1539/20240118/SocialDefeat_SecondSD/SensoryExposure_C57cage/tetrodes_PFC_1539_SensoryExpo_C57cage_secondSD_240118_093536/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1540
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1540/20240118/SocialDefeat_SecondSD/SensoryExposure_C57cage/tetrodes_PFC_1540_SensoryExpo_C57cage_secondSD_240118_093536/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1541
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1541/20240118/SocialDefeat_SecondSD/SensoryExposure_C57cage/tetrodes_PFC_1541_SensoryExpo_C57cage_secondSD_240118_093536/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %Mice that had two sensory exposures for 1st SD
    %Mouse 1542
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1542/20240124/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1542_SensoryExpo_C57cage_240124_093223/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1543
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1543/20240124/SocialDefeat/SensoryExposure_C57cage/tetrodes_PFC_1543_SensoryExpo_C57cage_240124_093223/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;    
    
elseif strcmp(experiment,'SecondSensoryExposure_C57cage_mCherry_CRH_VLPO')    
    %Mouse 1566
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1566/20240403/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1566_SensoryExpoC57cage_240403_093919/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1567
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1567/20240403/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1567_SensoryExpoC57cage_240403_093919/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1568
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1568/20240401/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1568_SensoryExpoC57cage_240401_094527/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1569
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1569/20240401/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1569_SensoryExpoC57cage_240401_094527/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
    %second batch
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240517/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1578_SD_CNOinj_SensoryExpoC57cage_240517_093949/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240517/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1579_SD_CNOinj_SensoryExpoC57cage_240517_093949/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240522/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1580_SD_SalInj_SensoryExpoC57cage_240522_093528/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240522/SocialDefeat/SensoryExposure_C57cage/mCherry_CRH_1581_SD_SalInj_SensoryExpoC57cage_240522_093528/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
                
    %third batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240827/SocialDefeat/SensoryExposure_C57cage/CRH_mCherry_1634_SensoryExposure_C57cage_240827_093712/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240827/SocialDefeat/SensoryExposure_C57cage/CRH_mCherry_1635_SensoryExposure_C57cage_240827_093712/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240828/SocialDefeat/SensoryExposure_C57cage/CRH_mCherry_1636_SensoryExposure_C57cage_240828_093921/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240828/SocialDefeat/SensoryExposure_C57cage/CRH_mCherry_1637_SensoryExposure_C57cage_240828_093921/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SecondSensoryExposure_C57cage_SecondRun_mCherry_CRH_VLPO')    
    %Mouse 1578
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1578/20240529/SocialDefeat_SecondRun/SensoryExposure_C57cage/mCherry_CRH_1578_SD2_SalInj_SensoryExpoC57cage_240529_093443/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1579
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1579/20240529/SocialDefeat_SecondRun/SensoryExposure_C57cage/mCherry_CRH_1579_SD2_SalInj_SensoryExpoC57cage_240529_093443/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1580
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1580/20240604/SocialDefeat_SecondRun/SensoryExposure_C57cage/mCherry_CRH_1580_SD2_CNOInj_SensoryExpoC57cage_240604_094756/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1581
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1581/20240604/SocialDefeat_SecondRun/SensoryExposure_C57cage/mCherry_CRH_1581_SD2_CNOInj_SensoryExpoC57cage_240604_094756/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
            
    %third batch
    %Mouse 1634
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1634/20240905/SocialDefeat2/SensoryExposure_C57cage/CRH_mCherry_1634_SensoryExposure_C57cage_240905_093825/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1635
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1635/20240905/SocialDefeat2/SensoryExposure_C57cage/CRH_mCherry_1635_SensoryExposure_C57cage_240905_093825/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1636
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1636/20240906/SocialDefeat2/SensoryExposure_C57cage/CRH_mCherry_1636_SensoryExposure_C57cage_240906_093601/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1637
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1637/20240906/SocialDefeat2/SensoryExposure_C57cage/CRH_mCherry_1637_SensoryExposure_C57cage_240906_093601/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

elseif strcmp(experiment,'SecondSensoryExposure_C57cage_inhibDREADD_CRH_VLPO')
    %Mouse 1488 
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231107/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1488_SensoryExposure_C57cage_231107_094124/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231107/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1489_SensoryExposure_C57cage_231107_094124/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231109/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1510_SensoryExposure_C57cage_231109_093848/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231109/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1511_SensoryExposure_C57cage_231109_093848/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231109/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1512_SensoryExposure_C57cage_231109_093848/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240822/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1631_SensoryExposure_C57cage_240822_093222/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240823/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1638_SensoryExposure_C57cage_240823_093931/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240823/SocialDefeat/SensoryExposure_C57cage/CRH_inhib_1639_SensoryExposure_C57cage_240823_093931/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    
elseif strcmp(experiment,'SecondSensoryExposure_C57cage_SecondRun_inhibDREADD_CRH_VLPO')
    %Mouse 1488
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1488/20231207/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1488_sensoryExpoC57cage2_231207_094019/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1489
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1489/20231207/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1489_sensoryExpoC57cage2_231207_094019/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1510
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1510/20231130/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1510_sensoryExpoC57cage_231130_093950/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1511
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1511/20231130/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1511_sensoryExpoC57cage_231130_093950/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1512
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1512/20231130/SocialDefeat/SensoryExposure_C57cage/DREADD_inhi_CRH_VLPO_1512_sensoryExpoC57cage_231130_093950/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;

    %Second batch
    %Mouse 1631
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1631/20240830/SocialDefeat2/SensoryExposure_C57cage/CRH_inhib_1631_SensoryExpoC57cage_240830_093150/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1638
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1638/20240903/SocialDefeat2/SensoryExposure_C57cage/CRH_inhib_1638_SensoryExposure_C57cage_240903_093616/';
    load([Dir.path{a}{1},'ExpeInfo.mat']); Dir.ExpeInfo{a}=ExpeInfo,Dir.nMice{a}=ExpeInfo.nmouse;
    %Mouse 1639
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetPFCVLPO/M1639/20240903/SocialDefeat2/SensoryExposure_C57cage/CRH_inhib_1639_SensoryExposure_C57cage_240903_093616/';
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
