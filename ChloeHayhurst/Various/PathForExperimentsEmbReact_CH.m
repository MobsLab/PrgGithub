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
    
    
elseif strcmp(experiment,'Habituation24HPre_PreDrug')
    
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
    
    
elseif strcmp(experiment,'Habituation_PreDrug')
    
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

    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug')
    
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
    
    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug')
    
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
    
    
elseif strcmp(experiment,'HabituationBlockedSafe_PreDrug')
    
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
    
    
elseif strcmp(experiment,'SleepPre_PreDrug')
    
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
    
    
elseif strcmp(experiment,'TestPre_PreDrug')
    
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
    
    
elseif strcmp(experiment,'UMazeCondExplo_PreDrug')
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PreDrug')
    
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PreDrug')
    
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
    
    
elseif strcmp(experiment,'SleepPost_PreDrug')
    
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
  
    
elseif strcmp(experiment,'UMazeCondExplo_PostDrug')
    
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PostDrug')
    
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
    
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PreDrug')
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
    
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PreDrug')
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

    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PostDrug')
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
    
    
elseif strcmp(experiment,'SleepPost_PostDrug')
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
    
     
elseif strcmp(experiment,'TestPost_PostDrug')
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
    
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PostDrug')
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
    
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PostDrug')
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
   
    
elseif strcmp(experiment,'TestPost_PreDrug')
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
    
    
else
    error('Invalid name of experiment')
end

end
    