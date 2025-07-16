function Dir=PathForExperimentsEmbReact_CH(experiment)


% Input : name of the experiment :
%'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
% 'TestPre_PreDrug' 'UMazeCondExplo_PreDrug'  'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
%'SleepPost_PreDrug' ' TestPost_PreDrug' 'ExtinctionBlockedShock_PreDrug' 'ExtinctionBlockedSafe_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};


%% Path
a=0;
I_CA=[];

if strcmp(experiment,'Calibration')
    
     % Mouse 1594
    a=a+1;
    cc=1;
    StimLevels={'0','1','3','4'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240422/ProjectEmbReact_M1594_20240422_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    StimLevels={'0','1','3','4','5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240529/ProjectEmbReact_M1610_20240529_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    StimLevels={'0','2','3','4','5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240603/ProjectEmbReact_M1611_20240603_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240620/ProjectEmbReact_M1612_20240620_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240624/ProjectEmbReact_M1614_20240624_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240805/ProjectEmbReact_M1641_20240805_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240925/ProjectEmbReact_M1686_20240925_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','4','5','6','7'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240924/ProjectEmbReact_M1685_20240924_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241001/ProjectEmbReact_M1687_20241001_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1688
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241010/ProjectEmbReact_M1688_20241010_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5','6'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250127/ProjectEmbReact_M1691_20250127_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1713
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
          % Mouse 1714
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','4','6'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250206/ProjectEmbReact_M1714_20250206_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        
          % Mouse 1715
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250224/ProjectEmbReact_M1715_20250224_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
       % Mouse 1740
    a=a+1;
    cc=1;
    StimLevels={'0','2','3','4','5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250506/ProjectEmbReact_M1740_20250506_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
          
          % Mouse 1747
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250512/ProjectEmbReact_M1747_20250512_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              
          % Mouse 1775
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','2','2.5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250624/ProjectEmbReact_M1775_20250624_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
                  
          % Mouse 1776
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250626/ProjectEmbReact_M1776_20250626_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              % Mouse 1777
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250702/ProjectEmbReact_M1777_20250702_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'Calibration_VHC')
    
    % Mouse 1775
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250624/ProjectEmbReact_M1775_20250624_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1776
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','1.5','1.55','1.6','1.75'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250626/ProjectEmbReact_M1776_20250626_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
       
            % Mouse 1777
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','2','3','3.5'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250701/ProjectEmbReact_M1777_20250701_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'Habituation24HPre_PreDrug')
    
    % Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
       % Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
       % Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
           % Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
            % Mouse 1740
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
         % Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
          % Mouse 1775
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
           % Mouse 1776
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
            % Mouse 1777
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
elseif strcmp(experiment,'Habituation_PreDrug')
    
    %  Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    % Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;

     %  Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;

         %  Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
            %  Mouse 1740
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
           %  Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
             %  Mouse 1775
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
              %  Mouse 1776
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
               %  Mouse 1777
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug')
    
  %      Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
     
    %      Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %      Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
      %      Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
     %      Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
         %      Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
        %      Mouse 1740
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
          %      Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
         %      Mouse 1775
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
        %      Mouse 1776
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
        %      Mouse 1777
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
  
    
elseif strcmp(experiment,'HabituationBlockedSafe_PreDrug')
    
   %   Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
     
    %   Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %   Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
     %   Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
     %   Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
         %   Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
       %   Mouse 1740
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
          %   Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
          %   Mouse 1775
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
           %   Mouse 1776
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
           %   Mouse 1777
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
  
    
elseif strcmp(experiment,'SleepPre_PreDrug')
    
    %         Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %         Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
       % Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
       % Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
           % Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
     % Mouse 1740
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
             % Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
            % Mouse 1775
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
                % Mouse 1776
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
                % Mouse 1777
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
   
    
    
elseif strcmp(experiment,'TestPre_PreDrug')
    
    %             Mouse 1594
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1610
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1611
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1612
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1614
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1641
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
     % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
            % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
            % Mouse 1740
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
             % Mouse 1775
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
      
             % Mouse 1776
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
   
              % Mouse 1777
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
   
    
elseif strcmp(experiment,'UMazeCondExplo_PreDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
          % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
        
          % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
          % Mouse 1740
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
             % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              % Mouse 1775
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
               % Mouse 1776
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
               % Mouse 1777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
 
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PreDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
     % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
            % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              % Mouse 1740
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
               % Mouse 1775
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
                   % Mouse 1776
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
  
                     % Mouse 1777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
  
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PreDrug')
   
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
          % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
                  % Mouse 1740
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
               % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
                % Mouse 1775
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
                  % Mouse 1776
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
                  % Mouse 1777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
   
    
elseif strcmp(experiment,'SleepPost_PreDrug')
    
    % Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
  
      % Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
  
     % Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
  
         % Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
           % Mouse 1740
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
     
         % Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
         % Mouse 1775
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
          % Mouse 1776
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
          % Mouse 1777
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'UMazeCondExplo_PostDrug')
    
      % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
       % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
         % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
        
         % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
         
         % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end

    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PostDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
        
        % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end

      % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PreDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
     % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
         % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
             % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
     
           % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_ExtinctionBlockedShock_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
               % Mouse 1740
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
            % Mouse 1775
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
            % Mouse 1776
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
 
               % Mouse 1777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
 
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PreDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end

        % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
            % Mouse 1740
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
         % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_ExtinctionBlockedSafe_PreDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1775
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
          % Mouse 1776
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
  
           % Mouse 1777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
  
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PostDrug')
   
    % Mouse 1594
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
      
    % Mouse 1713
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
       % Mouse 1714
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
           % Mouse 1715
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
  
           % Mouse 1747
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    

    
elseif strcmp(experiment,'SleepPost_PostDrug')
    
    % Mouse 1594
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1610
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1611
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1612
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1614
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1641
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1686
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1685
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1691
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1713
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
       % Mouse 1714
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
           % Mouse 1715
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
          % Mouse 1747
    a=a+1;Dir.path{a}{1}='/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
   
    

elseif strcmp(experiment,'TestPost_PostDrug')
    
     %             Mouse 1594
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1610
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1611
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1612
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    %             Mouse 1614
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1641
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1686
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    %             Mouse 1685
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1687
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1688
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1691
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      %             Mouse 1713
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
         %             Mouse 1714
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
             %             Mouse 1715
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
              %             Mouse 1747
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end



    
elseif strcmp(experiment,'ExtinctionBlockedShock_PostDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    
    % Mouse 1610
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1611
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1612
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1614
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
     % Mouse 1641
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1686
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1685
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1687
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1688
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1691
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
      % Mouse 1713
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
       % Mouse 1714
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
           % Mouse 1715
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
          % Mouse 1747
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_ExtinctionBlockedShock_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;

    
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PostDrug')
    
    % Mouse 1594
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1610
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    cc=cc+1;
    
    % Mouse 1611
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    % Mouse 1612
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    
    % Mouse 1614
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
     % Mouse 1641
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    
    % Mouse 1686
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    
    % Mouse 1685
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    % Mouse 1687
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    % Mouse 1688
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    % Mouse 1691
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
    % Mouse 1713
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
   
    % Mouse 1714
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
   
        % Mouse 1715
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    
        % Mouse 1747
    a=a+1;
    cc=1;
    Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_ExtinctionBlockedSafe_PostDrug','/'];
    load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
  
  
    
elseif strcmp(experiment,'TestPost_PreDrug')
    
    % Mouse 1594
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240423/ProjectEmbReact_M1594_20240423_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240530/ProjectEmbReact_M1610_20240530_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240604/ProjectEmbReact_M1611_20240604_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240621/ProjectEmbReact_M1612_20240621_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240704/ProjectEmbReact_M1614_20240704_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240808/ProjectEmbReact_M1641_20240808_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1686
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1685
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1687
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1688
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1691
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1691/20250128/ProjectEmbReact_M1691_20250128_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
     % Mouse 1713
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1713/20250204/ProjectEmbReact_M1713_20250204_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1714
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1714/20250212/ProjectEmbReact_M1714_20250212_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
     
    % Mouse 1715
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1715/20250228/ProjectEmbReact_M1715_20250228_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1740
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1740/20250509/ProjectEmbReact_M1740_20250509_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
      % Mouse 1747
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1747/20250513/ProjectEmbReact_M1747_20250513_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
       % Mouse 1775
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1775/20250625/ProjectEmbReact_M1775_20250625_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
         % Mouse 1776
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1776/20250627/ProjectEmbReact_M1776_20250627_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
           % Mouse 1777
    
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas8-2/ProjetEmbReact/Mouse1777/20250704/ProjectEmbReact_M1777_20250704_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
else
    error('Invalid name of experiment')
end

end
    