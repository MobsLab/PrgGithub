function Dir=PathForExperimentsEmbReact(experiment)

% input:
% name of the experiment.
% possible choices:
% '


% 'EPM'
% 'Calibration' , 'Calibration_Eyeshock' , 'Calibration_VHC'

% apprentissage PAG - webcam
% 'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost'
% 'Extinction'  --> PAG during the day

% 'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest'

% 'CtxtHab' 'SleepPreCtxt' 'CtxtCond' 'SleepPostCtxt' 'CtxtTest' 'CtxtTestCtrl'

% 'BaselineSleep'

% 'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight'
% 'SleepPostNight' 'TestPostNight' 'ExtinctionNight' --> PAG during the
% night

% 'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShock' 'WallCondSafe_EyeShockTempProt'
% 'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt'

% apprentissage eyeshock - webcam/infrared
% 'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock'
% 'SleepPre_EyeShock' 'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' 'SleepPost_EyeShock'
% 'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'

% 'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
% 'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
% 'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
% 'SleepPost_PostDrug' 'TestPost_PostDrug'
% 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'Extinction_PostDrug'

% 'Habituation24HPre_PreDrug_TempProt' 'Habituation_PreDrug_TempProt' 'HabituationBlockedSafe_PreDrug_TempProt' 'HabituationBlockedShock_PreDrug_TempProt'
% 'SleepPre_PreDrug_TempProt' 'TestPre_PreDrug_TempProt' 'UMazeCond_PreDrug_TempProt' 'UMazeCondBlockedShock_PreDrug_TempProt' 'UMazeCondBlockedSafe_PreDrug_TempProt' 'SleepPost_PreDrug_TempProt'
% 'TestPost_PreDrug_TempProt' 'Extinction_PostDrug_TempProt' 'ExtinctionBlockedShock_PostDrug_TempProt' 'ExtinctionBlockedSafe__PostDrug_TempProt'

% 'MidazolamDoseResponse_UMaze' 'MidazolamDoseResponse_Plethysmo'
% 'MidazolamDoseResponse_EPM'
% output
% Dir = structure containing paths / names / strains / name of the
% experiment (manipe) / correction for amplification (default=1000)
%
%
% example:
% Dir=PathForExperimentsML('EPM');
%
% 	merge two Dir:
% Dir=MergePathForExperiment(Dir1,Dir2);
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

%% strains inputs


%% Path
a=0;
I_CA=[];

if strcmp(experiment,'EPM')
    %Mouse404
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160714/ProjetEmbReact_M404_20160714_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse430
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse430/20160801/ProjetctEmbReact_M430_20160801_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse431
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse444
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse444/20160823/ProjectEmbReact_M444_20160823_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse445
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160824/ProjectEmbReact_M445_20160824_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'Calibration')
    
    %     % Mouse431
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'0','1','2','3','3','4','4','5','5'};
    %     StimDur={'100','100','100','100','300','100','300','100','300'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160730/PAGCalibration',StimLevels{c},'V-',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    %     % Mouse436
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'00','05','10','15','15','20','20','25','25','30'};
    %     StimDur={'100','100','100','100','200','100','200','100','200','100'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160810/PAGCalibration/PAGCalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    %     % Mouse437
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'0','0,5','1','2'};
    %     StimDur={'100','100','100','200'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160810/PAGCalibration/PAGCalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    %     % Mouse438
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'1','2','3','3','4','4','5'};
    %     StimDur={'100','100','100','200','100','200','100'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160818/PAGCalibration/PACalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse439
    a=a+1;
    cc=1;
    StimLevels={'0,5','1','2','2,5','2,5'};
    StimDur={'100','100','100','100','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160818/PAGCalibration/PAGCalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse469
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161019/Calibration/PAGCalibration',StimLevels{c},'V-200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','25'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161019/Calibration/PAGCalibration',StimLevels{c},'V-200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse471
    a=a+1;
    cc=1;
    StimLevels={'0','05','1','15','2','25'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161025/PAGCalibration',StimLevels{c},'V-200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    %     %Mouse483
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161114/Calibration/ProjectEmbReact_M483_20161114_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse484
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161117/ProjectEmbReact_M484_20161117_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse485
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161117/ProjectEmbReact_M485_20161117_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse490
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161129/ProjectEmbReact_M490_20161129_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse507
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,3'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170131/ProjectEmbReact_M507_20170131_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse508
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170131/ProjectEmbReact_M508_20170131_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse509
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170131/ProjectEmbReact_M509_20170131_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse510
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170207/ProjectEmbReact_M510_20170207_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse512
    a=a+1;
    cc=1;
    StimLevels={'0','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170207/ProjectEmbReact_M512_20170207_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'Calibration_Eyeshock')
    
    % Mouse560
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5','3'};
    StimDur={'2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170705/ProjectEmbReact_M560_20170705_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse564
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5','3','3,5','4,5'};
    StimDur={'2000','2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170705/ProjectEmbReact_M564_20170705_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse565
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5'};
    StimDur={'2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170704/ProjectEmbReact_M565_20170704_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse561
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5','3','3,5','4'};
    StimDur={'2000','2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/25072017/ProjectEmbReact_M561_25072017_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse566
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5','3','3,5'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170727/ProjectEmbReact_M566_20170727_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse567
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5'};
    StimDur={'2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170809/ProjectEmbReact_M567_20170809_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse568
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5'};
    StimDur={'2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170727/ProjectEmbReact_M568_20170727_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse569
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170809/ProjectEmbReact_M569_20170809_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse666
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse666/20171226/ProjectEmbReact_M666_20171226_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 667
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse667/20172612/ProjectEmbReact_M667_20172612_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 668
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse668/20171226/ProjectEmbReact_M668_20171226_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 669
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse669/20171226/ProjectEmbReact_M669_20171226_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 688
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180207/ProjectEmbReact_M688_20180207_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 689
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180207/ProjectEmbReact_M689_20180207_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','1,5','2','2,5'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/22052018/ProjectEmbReact_M739_22052018_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','1,5','2','2,5'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/22052018/ProjectEmbReact_M740_22052018_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','1,5','2','2,5'};
    StimDur={'2000','2000','2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180606/ProjectEmbReact_M750_20180606_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180813/ProjectEmbReact_M775_20180813_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180822/ProjectEmbReact_M777_20180822_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180730/ProjectEmbReact_M778_20180730_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180730/ProjectEmbReact_M779_20180730_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181023/ProjectEmbReact_M794_20181023_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181023/ProjectEmbReact_M795_20181023_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'0','1','1,5','2','2,5'};
    %     StimDur={'200','200','200','200','200'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/23102018/ProjectEmbReact_M796_23102018_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'2000','2000','2000','2000'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190112/ProjectEmbReact_M829_20190112_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190112/ProjectEmbReact_M849_20190112_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/12012019/ProjectEmbReact_M851_12012019_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190215/ProjectEmbReact_M856_20190215_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','3','4','5','6','7','8','9'};
    StimDur={'200','200','200','200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190213/ProjectEmbReact_M857_20190213_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190301/ProjectEmbReact_M858_20190301_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190301/ProjectEmbReact_M859_20190301_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse875
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190506/ProjectEmbReact_M875_20190506_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4','4,5'};
    StimDur={'200','200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190506/ProjectEmbReact_M876_20190506_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4','4,5'};
    StimDur={'200','200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190506/ProjectEmbReact_M877_20190506_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190527/ProjectEmbReact_M893_20190527_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1001
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191118/ProjectEmbReact_M1001_20191118_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1002
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191125/ProjectEmbReact_M1002_20191125_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1005
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191108/ProjectEmbReact_M1005_20191108_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1006
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191108/ProjectEmbReact_M1006_20191108_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1095
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200727/ProjectEmbReact_M1095_20200727_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1096
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200708/ProjectEmbReact_M1096_20200708_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    %Mouse1130
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201104/ProjectEmbReact_M1130_20201104_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse1144
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20201207/ProjectEmbReact_M1144_20201207_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20201207/ProjectEmbReact_M1146_20201207_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20201208/ProjectEmbReact_M1147_20201208_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1170
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210204/ProjectEmbReact_M1170_20210204_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210204/ProjectEmbReact_M1171_20210204_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1172
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210217/ProjectEmbReact_M1172_20210217_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1174
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210222/ProjectEmbReact_M1174_20210222_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1184
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4,5','5,5','6','7'};
    StimDur={'200','200','200','200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210322/ProjectEmbReact_M1184_20210322_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1189
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210322/ProjectEmbReact_M1189_20210322_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1200
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210412/ProjectEmbReact_M11200_20210412_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1204
    a=a+1;
    cc=1;
    StimLevels={'0','1'};
    StimDur={'200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210503/ProjectEmbReact_M1204_20210503_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1205
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210503/ProjectEmbReact_M1205_20210503_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1206
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210503/ProjectEmbReact_M11206_20210503_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1207
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','6','7'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210517/ProjectEmbReact_M11207_20210517_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1224
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210719/ProjectEmbReact_M1224_20210719_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1225
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210722/ProjectEmbReact_M1225_20210722_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1226
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210802/ProjectEmbReact_M1226_20210802_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1227
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4','4,5'};
    StimDur={'200','200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210810/ProjectEmbReact_M1227_20210810_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1203
    a=a+1;
    cc=1;
    StimLevels={'5'};
    StimDur={'200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210927/ProjectEmbReact_M1203_20210927_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1199
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5','6','7'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211011/ProjectEmbReact_M1199_20211011_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    StimLevels={'1','2','3','4'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211011/ProjectEmbReact_M1199_20211011_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211213/ProjectEmbReact_M1251_20211213_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1252
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211213/ProjectEmbReact_M1252_20211213_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    StimLevels={'1','1,5','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211215/ProjectEmbReact_M1253_20211215_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211215/ProjectEmbReact_M1254_20211215_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220309/ProjectEmbReact_M1267_20220309_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220324/ProjectEmbReact_M1268_20220324_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220329/ProjectEmbReact_M1266_20220329_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220404/ProjectEmbReact_M1269_20220404_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    StimLevels={'0','1'};
    StimDur={'200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220425/ProjectEmbReact_M1304_20220425_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    StimLevels={'3'};
    StimDur={'200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220511/ProjectEmbReact_M41305_20220511_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220807/ProjectEmbReact_M1351_20220807_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220807/ProjectEmbReact_M41349_20220807_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220807/ProjectEmbReact_M41352_20220807_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220807/ProjectEmbReact_M41350_20220807_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221019/ProjectEmbReact_M1376_20221019_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4','4,5'};
    StimDur={'200','200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221019/ProjectEmbReact_M1377_20221019_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221031/ProjectEmbReact_M1385_20221031_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221031/ProjectEmbReact_M1386_20221031_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221110/ProjectEmbReact_M1391_20221110_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221110/ProjectEmbReact_M1392_20221110_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221113/ProjectEmbReact_M1393_20221113_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221113/ProjectEmbReact_M1394_20221113_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230213/ProjectEmbReact_M1411_20230213_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230214/ProjectEmbReact_M1412_20230214_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','4'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230216/ProjectEmbReact_M1413_20230216_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230219/ProjectEmbReact_M1414_20230219_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230220/ProjectEmbReact_M1415_20230220_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1416
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','2,5','3','3,5','4'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230222/ProjectEmbReact_M1416_20230222_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1417
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3,5','4,5','5,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230223/ProjectEmbReact_M1417_20230223_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230227/ProjectEmbReact_M1418_20230227_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','4','5'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230320/ProjectEmbReact_M1437_20230320_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','3','4'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230321/ProjectEmbReact_M1438_20230321_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %      Mouse 1439
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230322/ProjectEmbReact_M1439_20230322_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1440
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230323/ProjectEmbReact_M1440_20230323_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230324/ProjectEmbReact_M1445_20230324_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','3','3,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230328/ProjectEmbReact_M1446_20230328_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230329/ProjectEmbReact_M1447_20230329_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230330/ProjectEmbReact_M1448_20230330_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','3','4'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230717/ProjectEmbReact_M1476_20230717_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230724/ProjectEmbReact_M1480_20230724_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230725/ProjectEmbReact_M1481_20230725_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230726/ProjectEmbReact_M1482_20230726_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    StimLevels={'1','2','3','5','7','8','9'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230912/ProjectEmbReact_M1483_20230912_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231010/ProjectEmbReact_M1501_20231010_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231011/ProjectEmbReact_M1500_20231011_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1502
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231011/ProjectEmbReact_M1502_20231011_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    StimDur={'200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231030/ProjectEmbReact_M1529_20231030_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1530
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231031/ProjectEmbReact_M1530_20231031_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1531
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231122/ProjectEmbReact_M1531_20231122_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231120/ProjectEmbReact_M1532_20231120_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'0','1','2','3'};
    %     StimDur={'200','200','200','200'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231219/ProjectEmbReact_M1533_20231219_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1561
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240205/ProjectEmbReact_M1561_20240205_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240213/ProjectEmbReact_M1562_20240213_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240213/ProjectEmbReact_M1563_20240213_CalibrationEyelid_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'Calibration_VHC')
    
    % Mouse 1411
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','2','5','7','10'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230212/ProjectEmbReact_M1411_20230212_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','2','3','4'};
    StimDur={'200','200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230213/ProjectEmbReact_M1412_20230213_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','2','3'};
    StimDur={'0.5','0.5','0.5','0.5','0.5',};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230216/ProjectEmbReact_M1413_20230216_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','2','3','4','5','6'};
    StimDur={'0.5','0.5','0.5','0.5','0.5','0.5','0.5','0.5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230219/ProjectEmbReact_M1414_20230219_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4','5'};
    StimDur={'0.5','0.5','0.5','0.5','0.5','0.5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230220/ProjectEmbReact_M1415_20230220_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1416
    a=a+1;
    cc=1;
    StimLevels={'0','1','2'};
    StimDur={'0.5','0.5','0.5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230222/ProjectEmbReact_M1416_20230222_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1417
    a=a+1;
    cc=1;
    StimLevels={'4'};
    StimDur={'0.5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230223/ProjectEmbReact_M1417_2023023_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3'};
    StimDur={'0.5','0.5','0.5','0.5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230227/ProjectEmbReact_M1418_20230227_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','2'};
    StimDur={'1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230320/ProjectEmbReact_M1437_20230320_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','1,5','2'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230321/ProjectEmbReact_M1438_20230321_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1439
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','1,5','2','3','4'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230322/ProjectEmbReact_M1439_20230322_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    StimLevels={'0','0,5','1','2','3','4','5','6','7'};
    StimDur={'1','1','1','1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230323/ProjectEmbReact_M1440_20230323_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','2'};
    StimDur={'1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230324/ProjectEmbReact_M1445_20230324_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','1,5','2','3','4'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230328/ProjectEmbReact_M1446_20230328_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','2','3','4','5'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230329/ProjectEmbReact_M1447_20230329_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    StimLevels={'20','0','1','2','3'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230330/ProjectEmbReact_M1448_20230330_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','1,5','2'};
    StimDur={'1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230718/ProjectEmbReact_M1476_20230718_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','2'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230724/ProjectEmbReact_M1480_20230724_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','2','3'};
    StimDur={'1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230725/ProjectEmbReact_M1481_20230725_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','2','3'};
    StimDur={'1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230726/ProjectEmbReact_M1482_20230726_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    StimLevels={'20','19','0','1','2'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230912/ProjectEmbReact_M1483_20230912_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    StimLevels={'0.99','0.999','1.99','1.999','2.99','2.999','3.99','3.599','3.999','4.99','19.999','20.99','20.999'};
    StimDur={'1','1','1','1','1','1','1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231012/ProjectEmbReact_M1501_20231012_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1500
    a=a+1;
    cc=1;
    StimLevels={'0.99','0.999','1.99','2.99','2.999','3.99','4.99','5.99','6.99','19.999','20.99','20.999'};
    StimDur={'1','1','1','1','1','1','1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231011/ProjectEmbReact_M1500_20231011_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    StimLevels={'0.99','0.999','1.99','1.999','2.99','2.999','3.99','3.599','3.999','4.99','19.999','20.99'};
    StimDur={'1','1','1','1','1','1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231011/ProjectEmbReact_M1502_20231009_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    StimLevels={'0.99','1.99','2.99','3.99','3.999','4.999','20.99'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231101/ProjectEmbReact_M1529_20231101_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    StimLevels={'0.99','1.99','2.99','3.99','4.99'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231031/ProjectEmbReact_M1530_20231031_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1531
    a=a+1;
    cc=1;
    StimLevels={'0.99','0.999','1.99','1.999','2.99','2.999','3.99','3.999','4.99','19.999','20.99','20.999'};
    StimDur={'1','1','1','1','1','1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231122/ProjectEmbReact_M1531_20231122_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    StimLevels={'0.99','0.999','1.99','1.999','2.99','2.999','19.999','20.99','20.999'};
    StimDur={'1','1','1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231121/ProjectEmbReact_M1532_20231121_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1594
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','19','20'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1594/20240422/ProjectEmbReact_M1594_20240422_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1610
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','19','20'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1610/20240529/ProjectEmbReact_M1610_20240529_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1611
    a=a+1;
    cc=1;
    StimLevels={'0','1','19','20'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1611/20240603/ProjectEmbReact_M1611_20240603_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1612
    a=a+1;
    cc=1;
    StimLevels={'0','1','1.1','1.25','2','19','20'};
    StimDur={'1','1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1612/20240620/ProjectEmbReact_M1612_20240620_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1614
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','20'};
    StimDur={'1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1614/20240624/ProjectEmbReact_M1614_20240624_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1641
    a=a+1;
    cc=1;
    StimLevels={'0','1','1.5','2.5','19','20'};
    StimDur={'1','1','1','1','1','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1641/20240805/ProjectEmbReact_M1641_20240805_CalibrationVHC_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'Habituation')
    
    %     %Mouse404
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPreUMaze')
    %
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPre/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPre/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPre/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPre/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPre/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPre')
    %
    %     % Mouse117
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse117/20140221/ProjectFearAnxiety_M117_20140221_PreTest/PreTest',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse404
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse425
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse431
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse436
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse437
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse438
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse439
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse490
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse507
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse508
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse509
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse510
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse512
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse514
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'UMazeCond')
    %     % Mouse117
    a=a+1;
    cc=1;
    for c=[1:10,12:16]
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse117/20140221/ProjectFearAnxiety_M117_20140221_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse404
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse425
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse431
    a=a+1;
    cc=1;
    for c=1:10
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse436
    a=a+1;
    cc=1;
    for c=1:9
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse437
    a=a+1;
    cc=1;
    for c=1:9
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse438
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse439
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse490
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse507
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse508
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse509
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse510
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse512
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse514
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'SleepPostUMaze')
    
    %     %Mouse404
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_SleepPost/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPost/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPost/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPost/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPost/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPost/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPost')
    
    %     % Mouse404
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse425
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse431
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse436
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse437
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %     % Mouse438
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse439
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse490
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse507
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse508
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse509
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse510
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse512
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse514
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'Extinction')
    %
    %     %Mouse404
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160705/ProjetEmbReact_M404_20161705_Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_Extinction/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'Habituation_EyeShockTempProt')
    %Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPre_EyeShockTempProt')
    
    % Mouse560
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse564
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse565
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'WallHabSafe_EyeShockTempProt')
    %Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_WallHab/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_WallHab/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_WallHab/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'WallHabShock_EyeShockTempProt')
    %Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_WallHab/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_WallHab/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_WallHab/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'WallCondShock_EyeShock')
    %Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_WallCond/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_WallCond/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_WallCond/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'WallCondSafe_EyeShockTempProt')
    %Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_WallCond/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_WallCond/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_WallCond/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPost_EyeShockTempProt')
    
    % Mouse564
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse565
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'WallExtShock_EyeShockTempProt')
    
    % Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_WallRetest/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_WallRetest/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_WallRetest/Shock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'WallExtSafe_EyeShockTempProt')
    
    % Mouse560
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse560/20170706/ProjectEmbReact_M560_20170706_WallRetest/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse564
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse564/20170706/ProjectEmbReact_M564_20170706_WallRetest/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse565
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse565/20170706/ProjectEmbReact_M565_20170706_WallRetest/Safe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'Habituation24HPre_EyeShock')
    
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
elseif strcmp(experiment,'Habituation_EyeShock')
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
elseif strcmp(experiment,'HabituationBlockedSafe_EyeShock')
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'HabituationBlockedShock_EyeShock')
    
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPre_EyeShock')
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPre_EyeShock')
    
    % Mouse561
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse566
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse567
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse568
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse569
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCond_EyeShock')
    % Mouse561
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse566
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse567
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse568
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse569
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondBlockedShock_EyeShock')
    % Mouse561
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse566
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse567
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse568
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse569
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_EyeShock')
    % Mouse561
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse566
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse567
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse568
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse569
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'SleepPost_EyeShock')
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPost_EyeShock')
    % Mouse561
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse566
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse567
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse568
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse569
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'Extinction_EyeShock')
    
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'ExtinctionBlockedShock_EyeShock')
    
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_EyeShock')
    
    % Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/26072017/ProjectEmbReact_M561_26072017_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170802/ProjectEmbReact_M566_20170802_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170816/ProjectEmbReact_M567_20170816_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170728/ProjectEmbReact_M568_20170728_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundHab')
    
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SoundHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse439
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160818/ProjectEmbReact_M425_20160818_SoundHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPreSound')
    
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPreSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPreSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPreSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPreSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundCond')
    
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SoundCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160818/ProjectEmbReact_M425_20160818_SoundCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPostSound')
    
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPostSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPostSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPostSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPostSound/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundTest')
    
    %     %Mouse431
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SoundTest/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse436
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundTest/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse437
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundTest/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse438
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundTest/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160818/ProjectEmbReact_M425_20160818_SoundTest/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'CtxtHab')
    
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtHab/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % elseif strcmp(experiment,'SleepPreCtxt')
    %
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPreCtxt/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % elseif strcmp(experiment,'CtxtCond')
    %
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % elseif strcmp(experiment,'SleepPostCtxt')
    %
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtCond/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % elseif strcmp(experiment,'CtxtTest')
    %
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtTest/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % elseif strcmp(experiment,'CtxtTestCtrl')
    %
    %     %Mouse425
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtTestCtrl/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % elseif strcmp(experiment,'SleepPreEPM')
    %
    %     %Mouse430
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse430/20160801/ProjetctEmbReact_M430_20160801_SleepPreEPM/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse445
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160824/ProjectEmbReact_M445_20160824_SleepPreEPM/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    %
    % elseif strcmp(experiment,'SleepPostEPM')
    %
    %     %Mouse430
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse430/20160801/ProjetctEmbReact_M430_20160801_SleepPostEPM/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %Mouse445
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160824/ProjectEmbReact_M445_20160824_SleepPostEPM/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
elseif strcmp(experiment,'BaselineSleep')
    %
    %     % Mouse404
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160820/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160823/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %     % Mouse425
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160822/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse425/20160823/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %     % Mouse430
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse430/20160818/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse430/20160819/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %     %     % Mouse431
    %     %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse431/20160802/';
    %     %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     %
    %     % Mouse436
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160809/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    %     % Mouse437
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160810/Sleep/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160809/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %     % Mouse438
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160818/Sleep/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160817/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %     Dir.path{a}{3}='/media/DataMOBsRAID/ProjectEmbReact/Mouse438/20160816/';
    %     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    %
    % Mouse439
    a=a+1;
    Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160818/Sleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160816/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse439/20160817/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse444
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse444/20160819/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse444/20160820/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse444/20160822/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    %
    %     % Mouse445
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160823/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160822/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %     Dir.path{a}{3}='/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160820/';
    %     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse469
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161019/Sleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161102/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161019/Sleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161021/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161024/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %     Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161102/';
    %     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse483
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161114/Sleep/ProjectEmbReact_M483_20161114_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse484
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161117/ProjectEmbReact_M484_20161117_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %     Dir.path{a}{3}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161115/ProjectEmbReact_M484_20161115_BaselineSleep/';
    %     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse485
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161117/ProjectEmbReact_M485_20161117_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161115/ProjectEmbReact_M485_20161115_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161129/ProjectEmbReact_M490_20161129_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161124/ProjectEmbReact_M490_20161124_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170126/ProjectEmbReact_M507_20170126_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170127/ProjectEmbReact_M507_20170127_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170203/ProjectEmbReact_M510_20170203_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170204/ProjectEmbReact_M510_20170204_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170315/ProjectEmbReact_M514_20170315_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse561
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/10082017/ProjectEmbReact_M561_20170810_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse561/11082017/ProjectEmbReact_M561_20170811_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse566
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170927/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse567
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170808/ProjectEmbReact_M567_20170808_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse567/20170809/ProjectEmbReact_M567_20170809_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse568
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170810/ProjectEmbReact_M568_20170810_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse568/20170811/ProjectEmbReact_M568_20170811_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse569
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170808/ProjectEmbReact_M569_20170808_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170809/ProjectEmbReact_M569_20170809_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180207/ProjectEmbReact_M688_20180207_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180207/ProjectEmbReact_M689_20180207_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/18052018/ProjectEmbReact_M739_18052018_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/18052018/ProjectEmbReact_M740_18052018_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180702/ProjectEmbReact_M750_20180702_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180725/ProjectEmbReact_M775_20180725_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse775/20180726/ProjectEmbReact_M775_20180726_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse775/20180727/ProjectEmbReact_M775_20180727_BaselineSleep/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180817/ProjectEmbReact_M777_20180817_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180725/ProjectEmbReact_M778_20180725_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse778/20180726/ProjectEmbReact_M778_20180726_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse778/20180727/ProjectEmbReact_M778_20180727_BaselineSleep/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse779
    Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180726/ProjectEmbReact_M779_20180726_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse779/20180727/ProjectEmbReact_M779_20180727_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    %Mouse 795
    Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181026/ProjectEmbReact_M795_20181026_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190107/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse829/20190109/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse829/20190110/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse829/20190111/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    
    %Mouse849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190107/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse849/20190109/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse849/20190110/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse849/20190111/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    
    %Mouse851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/20190107/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse851/20190109/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas4/ProjetEmbReact/Mouse851/20190110/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    Dir.path{a}{4}='/media/nas4/ProjetEmbReact/Mouse851/20190111/';
    load([Dir.path{a}{4},'ExpeInfo.mat']),Dir.ExpeInfo{a}{4}=ExpeInfo;
    
    % Mouse 856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190212/ProjectEmbReact_M856_20190212_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse856/20190213/ProjectEmbReact_M856_20190213_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190212/ProjectEmbReact_M857_20190212_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse857/20190213/ProjectEmbReact_M857_20190213_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190227/ProjectEmbReact_M858_20190227_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse858/20190228/ProjectEmbReact_M858_20190228_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190227/ProjectEmbReact_M859_20190227_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse859/20190228/ProjectEmbReact_M859_20190228_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190411/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190411/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190417/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190411/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191029/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1001/20191030/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191029/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1002/20191030/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1003
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1003/20191023/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191125/ProjectEmbReact_M1005_20191125_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191126/ProjectEmbReact_M1006_20191126_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200630/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1095/20200701/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200707/ProjectEmbReact_M1096_20200707_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1096/20200708/ProjectEmbReact_M1096_20200708_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201105/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1130/20201106/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20201210/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1144/20201216/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/nas6/ProjetEmbReact/Mouse1144/20201217/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20201216/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1146/20201217/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210109/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210111/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210208/ProjectEmbReact_M1170_20210208_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1170/20210209/ProjectEmbReact_M1170_20210209_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210208/ProjectEmbReact_M1171_20210208_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1170/20210209/ProjectEmbReact_M1170_20210209_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1172
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210218/ProjectEmbReact_M1172_20210218_BaselineSleep/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1172/20210219/ProjectEmbReact_M1172_20210219_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210222/ProjectEmbReact_M1174_20210222_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1174/20210219/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210316/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210317/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210316/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1189/20210317/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210407/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1200/20210408/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210427/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1204/20210429/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210428/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210429/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210428/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1206/20210429/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210512/ProjectEmbReact_M1207_20210512_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1207/20210519/ProjectEmbReact_M1207_20210519_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210720/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1224/20210721/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210720/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1225/20210721/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210726/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1226/20210727/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210726/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1227/20210727/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1203
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210707/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1251
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211209/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211210/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1252
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211210/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211215/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1253
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211214/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211227/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1254
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211227/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211228/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1266
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220302/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220303/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1267
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220302/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220303/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1268
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220304/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220308/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1269
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220304/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220308/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1304
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220415/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220418/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1305
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220415/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220418/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1351
    a=a+1; Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1351/20220805/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220822/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1349
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220803/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220804/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1352
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220805/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220824/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1350
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220803/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220804/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1376
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221017/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1377
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221018/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221017/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1385
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221027/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221107/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1386
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221027/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221107/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1391
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221128/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221129/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1392
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221128/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221129/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1393
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221128/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221129/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1394
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221128/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221129/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1411
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230208/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230209/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1412
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230208/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230209/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1413
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230214/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1414
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230213/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230214/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1415
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230217/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230307/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1416
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230217/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230321/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1417
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230220/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1418
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230220/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230221/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %         Mouse 1437
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/202303?/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1438
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1439
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1440
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230317/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230320/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1445
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230322/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230323/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1446
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230322/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230323/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1447
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230327/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230328/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1448
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230327/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230328/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1476
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230706/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230707/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1477
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1477/20230703/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1477/20230704/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1478
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1478/20230703/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1478/20230704/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1479
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1479/20230703/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1479/20230704/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1480
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230718/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230719/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1481
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230718/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230719/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1482
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230718/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230719/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1483
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230718/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230719/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1501
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231005/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1500
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231005/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     Mouse 1502
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231005/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231006/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %          Mouse 1529
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231027/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231103/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %         %          Mouse 1531
    %         a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231027/';
    %         load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %         a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231103/';
    %         load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %     Mouse 1532
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231116/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231117/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %                 %     Mouse 1533
    %         a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231116/';
    %         load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %         a=a+1; Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231117/';
    %         load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    
elseif strcmp(experiment,'HabituationNight')
    
    % Mouse469
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161024/ProjetctEmbReact_M469_20161024_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161028/ProjetctEmbReact_M471_20161028_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse485
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_Habituation/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    
elseif strcmp(experiment,'SleepPreNight')
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % This mouse doesn't have sleep post and doesn't sleep anyway
    %     % Mouse471
    %     a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161028/ProjetctEmbReact_M471_20161028_SleepPre/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse485
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPreNight')
    
    % Mouse469
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161024/ProjetctEmbReact_M469_20161024_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse471
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161028/ProjetctEmbReact_M471_20161028_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse483
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse484
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse485
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondNight')
    
    % Mouse469
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161024/ProjetctEmbReact_M469_20161024_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse471
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161028/ProjetctEmbReact_M471_20161028_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse483
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse484
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse485
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'SleepPostNight')
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse485
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPostNight')
    
    % Mouse469
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161024/ProjetctEmbReact_M469_20161024_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse471
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161028/ProjetctEmbReact_M471_20161028_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse483
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse484
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse485
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'ExtinctionNight')
    
    % Mouse469
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse469/20161024/ProjetctEmbReact_M469_20161024_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse470/20161026/ProjetctEmbReact_M470_20161026_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161028/ProjetctEmbReact_M471_20161028_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse483/20161115/ProjectEmbReact_M483_20161115_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse484/20161122/ProjectEmbReact_M484_20161122_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse485
    a=a+1;Dir.path{a}{1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse485/20161125/ProjectEmbReact_M485_20161125_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'Habituation24HPre_PreDrug')
    
    % Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     % Mouse 796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_Habituation24HPre_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % mouse 893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1162
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1172
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 9184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 9205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1206
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_Habituation24HPre_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     % Mouse 9203
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_Habituation24HPre_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1223
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11252
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 21251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 21253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1267 % no INTAN recordings, IMANE not me for once
    % (you could have written my name even bigger ! :) )
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_Habituation24HPre_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1304
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1351
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41351
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1376
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1377
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1385
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1386
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1391
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1392
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1393
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1394
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1411
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1412
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1413
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1438
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %      Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %      Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1476
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 51500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 41530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 41531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %         %   Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_Habituation24HPre_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_Habituation24HPre_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %   Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
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
    
    
elseif strcmp(experiment,'Habituation_PreDrug')
    
    % Mouse 688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     % Mouse 796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1162
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1172
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 9184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1189
    %    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 9205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     % Mouse 1227
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210811/ProjectEmbReact_M1227_20210811_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1227/20210811/ProjectEmbReact_M1227_20210811_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     % Mouse 9203
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11252
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 11254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1251
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 21251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 21253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1267
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1304
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 31305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %     % Mouse 1351
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 41351
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1376
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1377
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1385
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1386
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1391
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1392
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1393
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1394
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1411
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1412
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1413
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    % Mouse 1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1438
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    % Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    %  Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1476
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 51500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    %  Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %          Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %          Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %          Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 41530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 41531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %         %  Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_Habituation_PreDrug/Hab1/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_Habituation_PreDrug/Hab2/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
    %  Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %  Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
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
    
    
    %  Mouse 1686
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
    
    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug')
    % Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_HabituationBlockedShock_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1162
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1172
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse 1203
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_HabituationBlockedShock_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1223
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11252
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1267
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1304
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1351
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41351
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1376
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1377
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1385
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1386
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1391
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1392
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1393
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1394
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1411
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1412
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1413
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1438
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1476
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %      Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 41530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 41531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %      Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         %      Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_HabituationBlockedShock_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo
    
    %      Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
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
    
    
elseif strcmp(experiment,'HabituationBlockedSafe_PreDrug')
    
    % Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_HabituationBlockedSafe_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1162
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1172
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1223
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11252
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1267
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1304
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1351
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41351
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1376
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1377
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1385
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1386
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1391
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1392
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1393
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1394
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1411
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1412
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1413
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1438
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1476
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 51500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %    Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 41530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 41531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         %   Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_HabituationBlockedSafe_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %   Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
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
    
    
elseif strcmp(experiment,'SleepPre_PreDrug')
    
    % Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse 796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_SleepPre_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1162
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1172
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1223
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11252
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1267
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1304
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1351
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41351
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1376
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1377
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1385
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1386
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1391
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1392
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1393
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1394
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1411
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1412
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1413
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1438
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1476
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %    Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 51500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %         Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %         Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    %         Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % %
    %         Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 41530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 41531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         %         Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_SleepPre_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
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
    
    %         Mouse 1687
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPre_PreDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_TestPre_PreDrug/TestPre',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1001
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1002
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1005
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1006
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1095
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1096
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1130
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1161
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1162
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1170
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1172
    a=a+1;
    cc=1;
    for c=[1 2 4]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1174
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1189
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11147
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11200
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse 9203
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_TestPre_PreDrug/TestPre',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41351
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1417
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % %         Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_TestPre_PreDrug/TestPre',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    %             Mouse 1561
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %             Mouse 1563
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1562
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    %             Mouse 1686
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1686/20240926/ProjectEmbReact_M1686_20240926_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1685
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1685/20240925/ProjectEmbReact_M1685_20240925_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1687
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1687/20241003/ProjectEmbReact_M1687_20241003_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1688
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'UMazeCondExplo_PreDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1001
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1002
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1005
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1006
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1095
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1096
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse1130
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse1161
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1224
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1227
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11203
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse 9203
    %     a=a+1;
    %     cc=1;
    %     for c=1:7
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %         % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PreDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1001
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1002
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1005
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1006
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1095
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1096
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1130
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1161
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_UMazeCondBlockedShock_PreDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_UMazeCondBlockedShock_PreDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_UMazeCondBlockedShock_PreDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %         % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
        
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PreDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1001
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1002
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1005
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1006
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1095
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1096
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1130
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1161
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_UMazeCondBlockedSafe_PreDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_UMazeCondBlockedSafe_PreDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_UMazeCondBlockedSafe_PreDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    %         % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'SleepPost_PreDrug')
    % Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    %     % Mouse796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_SleepPost_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1170
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1172
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1174
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11189
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1200
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 9205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1204
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11207
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1206
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11252
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1254
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 21253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31253
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31251
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1267
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1304
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41266
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41269
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41268
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 31305
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1351
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1352
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1349
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1350
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41351
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1376
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1377
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1385
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1386
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1391
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1392
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1393
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1394
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1411
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1412
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1413
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1414
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1415
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1416
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1417
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1418
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1437
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1438
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1476
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 51500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 41531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_SleepPost_PreDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo
    
    % Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
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
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo
    
    
    % Mouse 1688
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1688/20241011/ProjectEmbReact_M1688_20241011_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo
    
    
elseif strcmp(experiment,'UMazeCondExplo_PostDrug')
    
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1001
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1002
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1005
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1006
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1095
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1096
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1130
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1144
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1161
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1162
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1170
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1172
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1174
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1189
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11184
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11200
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=[1 3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=[1:3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11204
    a=a+1;
    cc=1;
    for c=[1:3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=[1:3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=[1:3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=[1:3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=[1:3]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9203
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=2:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1417
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PostDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1001
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1002
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1005
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1006
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1095
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1096
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1130
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1161
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1162
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1170
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1172
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1174
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1189
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11184
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11200
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11204
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_UMazeCondBlockedShock_PostDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_UMazeCondBlockedShock_PostDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_UMazeCondBlockedShock_PostDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1417
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %         % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PostDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1001
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1002
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1005
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1006
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1095
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1096
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1130
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1161
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1162
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1170
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1172
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1174
    a=a+1;
    cc=1;
    for c=2:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1189
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11184
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11200
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11204
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_UMazeCondBlockedSafe_PostDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_UMazeCondBlockedSafe_PostDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_UMazeCondBlockedSafe_PostDrug/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat'],'ExpeInfo'),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat'],'ExpeInfo'),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1417
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %         % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1563
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'SleepPost_PostDrug')
    % Mouse688
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse689
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse739
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse740
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse750
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse775
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse777
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse778
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse779
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse794
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse795
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse796
    %     a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_SleepPost_PostDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse829
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse849
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse851
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse856
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse857
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse858
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse859
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse875
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse876
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse877
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse893
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1001
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1002
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1005
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1006
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1095
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1096
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1161
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1162
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1184
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1205
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1224
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1227
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11226
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11225
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse 9203
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_SleepPost_PostDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1223
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11529
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11530
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11531
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11532
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %         % Mouse 1533
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_SleepPost_PostDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1561
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1562
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
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
    
    
elseif strcmp(experiment,'TestPost_PostDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_TestPost_PostDrug/TestPost',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1001
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1002
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1005
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1006
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1095
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1096
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1130
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1161
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1162
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1170
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1172
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1174
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1189
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11147
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11200
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=2:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_TestPost_PostDrug/TestPost',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse 9203
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_TestPost_PostDrug/TestPost',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41351
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    %
    % Mouse 1417
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % %         Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:4
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_TestPost_PostDrug/TestPost',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    %             Mouse 1561
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1563
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %             Mouse 1562
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PostDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    %
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1001
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1002
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1005
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1006
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1095
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1096
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1130
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1144
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1161
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1162
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1170
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1172
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1174
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1189
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11147
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11200
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11204
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=[1 2 4]
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse 9203
    %     a=a+1;
    %     cc=1;
    %     for c=1:3
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    %   Mouse 1417
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231117/ProjectEmbReact_M1501_20231117_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    % Mouse 1561
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %         % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:3
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
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
    
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PostDrug')
    % Mouse688
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse689
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse689/20180213/ProjectEmbReact_M689_20180213_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse739
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse740
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse750
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse750/20180705/ProjectEmbReact_M750_20180705_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse775
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse777
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse777/20180828/ProjectEmbReact_M777_20180828_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse778
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse778/20180807/ProjectEmbReact_M778_20180807_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse779
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse779/20180807/ProjectEmbReact_M779_20180807_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse794
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse794/20181116/ProjectEmbReact_M794_20181116_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse795
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse795/20181030/ProjectEmbReact_M795_20181030_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse796
    %     a=a+1;
    %     cc=1;
    %     for c=1:2
    %         Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse796/26112018/ProjectEmbReact_M796_26112018_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse829
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse829/20190115/ProjectEmbReact_M829_20190115_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse849
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse849/20190116/ProjectEmbReact_M849_20190116_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse851
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse851/24012019/ProjectEmbReact_M851_24012019_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse856
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse856/20190308/ProjectEmbReact_M856_20190308_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse857
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse857/20190214/ProjectEmbReact_M857_20190214_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse858
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse858/20190305/ProjectEmbReact_M858_20190305_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse859
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse859/20190320/ProjectEmbReact_M859_20190320_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse875
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse875/20190604/ProjectEmbReact_M875_20190604_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse876
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse876/20190528/ProjectEmbReact_M876_20190528_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse877
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse877/20190531/ProjectEmbReact_M877_20190531_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse893
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse893/20190530/ProjectEmbReact_M893_20190530_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1001
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1001/20191122/ProjectEmbReact_M1001_20191122_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1002
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1002/20191127/ProjectEmbReact_M1002_20191127_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1005
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1005/20191113/ProjectEmbReact_M1005_20191113_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1006
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1006/20191112/ProjectEmbReact_M1006_20191112_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1095
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1095/20200729/ProjectEmbReact_M1095_20200729_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1096
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1096/20200710/ProjectEmbReact_M1096_20200710_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1130
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1130/20201201/ProjectEmbReact_M1130_20201201_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1144
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210311/ProjectEmbReact_M1144_20210311_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210311/ProjectEmbReact_M1146_20210311_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210304/ProjectEmbReact_M1147_20210304_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1161
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1161/20210126/ProjectEmbReact_M1161_20210126_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1162
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1162/20210202/ProjectEmbReact_M1162_20210202_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1170
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1170/20210205/ProjectEmbReact_M1170_20210205_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1172
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1172/20210224/ProjectEmbReact_M1172_20210224_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1174
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1174/20210224/ProjectEmbReact_M1174_20210224_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210324/ProjectEmbReact_M1184_20210324_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1184
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210701/ProjectEmbReact_M1184_20210701_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1189
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210324/ProjectEmbReact_M1189_20210324_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse11184
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1184/20210330/ProjectEmbReact_M1184_20210330_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11147
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210413/ProjectEmbReact_M11147_20210413_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210413/ProjectEmbReact_M11200_20210413_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11189
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1189/20210420/ProjectEmbReact_M11189_20210420_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1200
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1200/20210420/ProjectEmbReact_M1200_20210420_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1204
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210505/ProjectEmbReact_M1204_20210505_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 9205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210505/ProjectEmbReact_M1205_20210505_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1205
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210706/ProjectEmbReact_M1205_20210706_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11204
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1204/20210511/ProjectEmbReact_M11204_20210511_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11205
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1205/20210511/ProjectEmbReact_M11205_20210511_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11206
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210518/ProjectEmbReact_M11206_20210518_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11207
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1207/20210518/ProjectEmbReact_M11207_20210518_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1206
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1206/20210601/ProjectEmbReact_M1206_20210601_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1224
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1224/20210812/ProjectEmbReact_M1224_20210812_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210824/ProjectEmbReact_M1225_20210824_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210803/ProjectEmbReact_M1226_20210803_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1227
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1227/20210903/ProjectEmbReact_M1227_20210903_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11226
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1226/20210826/ProjectEmbReact_M11226_20210826_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11225
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1225/20210831/ProjectEmbReact_M11225_20210831_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1203
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20210928/ProjectEmbReact_M1203_20210928_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11203
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     % Mouse 9203
    %     a=a+1;
    %     cc=1;
    %     for c=1:3
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    % Mouse 1199
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1223
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11252
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1252/20211214/ProjectEmbReact_M1252_20211214_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1254
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1254/20220104/ProjectEmbReact_M1254_20220104_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21251
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 21253
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31253
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31251
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1267
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1267/20220310/ProjectEmbReact_M1267_20220310_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220325/ProjectEmbReact_M1268_20220325_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220405/ProjectEmbReact_M1269_20220405_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220330/ProjectEmbReact_M1266_20220330_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220422/ProjectEmbReact_M1268_20220422_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1304
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1304/20220426/ProjectEmbReact_M1304_20220426_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220422/ProjectEmbReact_M1266_20220422_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220429/ProjectEmbReact_M1269_20220429_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41266
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1266/20220510/ProjectEmbReact_M1266_20220510_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41269
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1269/20220510/ProjectEmbReact_M1269_20220510_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41268
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1268/20220512/ProjectEmbReact_M1268_20220512_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220512/ProjectEmbReact_M41305_20220512_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220520/ProjectEmbReact_M1305_20220520_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 31305
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1305/20220622/ProjectEmbReact_M31305_20220622_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1351/20220808/ProjectEmbReact_M1351_20220808_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41349
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220818/ProjectEmbReact_M41349_20220818_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220818/ProjectEmbReact_M41352_20220818_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1352
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1349
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1349/20220825/ProjectEmbReact_M1349_20220825_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1350
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1350/20220830/ProjectEmbReact_M1350_20220830_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41351
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1351/20220830/ProjectEmbReact_M41351_20220830_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1376/20221020/ProjectEmbReact_M1376_20221020_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1377
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1377/20221020/ProjectEmbReact_M1377_20221020_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1385/20221101/ProjectEmbReact_M1385_20221101_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1386/20221101/ProjectEmbReact_M1386_20221101_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1391/20221111/ProjectEmbReact_M1391_20221111_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1392
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1392/20221111/ProjectEmbReact_M1392_20221111_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1393/20221114/ProjectEmbReact_M1393_20221114_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1394/20221114/ProjectEmbReact_M1394_20221114_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1411
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1411/20230214/ProjectEmbReact_M1411_20230214_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1412
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1412/20230215/ProjectEmbReact_M1412_20230215_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1413
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1413/20230217/ProjectEmbReact_M1413_20230217_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1414
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1414/20230220/ProjectEmbReact_M1414_20230220_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1415
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1415/20230221/ProjectEmbReact_M1415_20230221_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1416
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1416/20230223/ProjectEmbReact_M1416_20230223_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1417
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1417/20230224/ProjectEmbReact_M1417_20230224_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1418
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1418/20230228/ProjectEmbReact_M1418_20230228_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1437
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1437/20230321/ProjectEmbReact_M1437_20230321_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1438
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1438/20230322/ProjectEmbReact_M1438_20230322_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1439
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1440
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1445
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1446
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1447
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1448
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1476
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1476/20230719/ProjectEmbReact_M1476_20230719_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1480
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1481
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1482
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1483
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 51500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1502
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1529
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231019/ProjectEmbReact_M11501_20231019_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231023/ProjectEmbReact_M11500_20231023_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11529
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1529/20231108/ProjectEmbReact_M11529_20231108_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231101/ProjectEmbReact_M1530_20231101_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1532
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231122/ProjectEmbReact_M1532_20231122_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231109/ProjectEmbReact_M41530_20231109_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 41531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231123/ProjectEmbReact_M41531_20231123_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1500
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1500/20231115/ProjectEmbReact_M1500_20231115_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11530
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1530/20231201/ProjectEmbReact_M11530_20231201_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11531
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1531/20231130/ProjectEmbReact_M11531_20231130_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11532
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1532/20231129/ProjectEmbReact_M11532_20231129_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1501
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1562
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1562/20240214/ProjectEmbReact_M1562_20240214_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
    %        % Mouse 1533
    %     a=a+1;
    %     cc=1;
    %     for c=1:3
    %         Dir.path{a}{cc}=['/media/nas7/ProjetEmbReact/Mouse1533/20231220/ProjectEmbReact_M1533_20231220_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
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
    
    
    
elseif strcmp(experiment,'Extinction_PostDrug')
    
    %      Mouse 1439
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1439/20230323/ProjectEmbReact_M1439_20230323_ExtinctionPostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1440
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1440/20230324/ProjectEmbReact_M1440_20230324_ExtinctionPostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1445
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1445/20230327/ProjectEmbReact_M1445_20230327_ExtinctionPostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1446
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1446/20230329/ProjectEmbReact_M1446_20230329_ExtinctionPostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1447
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1447/20230330/ProjectEmbReact_M1447_20230330_ExtinctionPostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1448
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1448/20230331/ProjectEmbReact_M1448_20230331_ExtinctionPostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1480
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1480/20230725/ProjectEmbReact_M1480_20230725_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1481
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1481/20230726/ProjectEmbReact_M1481_20230726_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1482
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1482/20230728/ProjectEmbReact_M1482_20230728_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1483
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1483/20230913/ProjectEmbReact_M1483_20230913_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1501
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1501/20231013/ProjectEmbReact_M1501_20231013_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 51500
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1500/20231012/ProjectEmbReact_M1500_20231012_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %      Mouse 1502
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1502/20231015/ProjectEmbReact_M1502_20231015_Extinction_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    %           %      Mouse 1529
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1529/20231031/ProjectEmbReact_M1529_20231031_Extinction_PostDrug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'Habituation24HPre_PreDrug_TempProt')
    
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_Habituation24HPre/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_Habituation24HPre/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
elseif strcmp(experiment,'Habituation_PreDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_Habituation/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_Habituation/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
elseif strcmp(experiment,'HabituationBlockedSafe_PreDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_HabituationBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_HabituationBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPre_PreDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPre_PreDrug_TempProt')
    % Mouse666
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse667
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse668
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse669
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCond_PreDrug_TempProt')
    % Mouse666
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse667
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse668
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse669
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_UMazeCondExplo/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PreDrug_TempProt')
    % Mouse666
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse667
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse668
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse669
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_UMazeCondBlockedShock/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PreDrug_TempProt')
    % Mouse666
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse667
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse668
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse669
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_UMazeCondBlockedSafe/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'SleepPost_PreDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPost_PreDrug_TempProt')
    % Mouse666
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse667
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse668
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse669
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'Extinction_PostDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PostDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_ExtinctionBlockedShock/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PostDrug_TempProt')
    % Mouse666
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse666/20171228/ProjectEmbReact_M666_20171228_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse667
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse667/20172912/ProjectEmbReact_M667_20172912_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse668
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse668/20171229/ProjectEmbReact_M668_20171229_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse669
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse669/20171228/ProjectEmbReact_M669_20171228_ExtinctionBlockedSafe/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'MidazolamDoseResponse_EPM')
    MouseNum = [801:824,830,831,833,836:848];
    for m = 1:length(MouseNum)
        a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetEmbReact/Midazolam/Mouse' num2str(MouseNum(m)) '/EPM/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    end
    
elseif strcmp(experiment,'MidazolamDoseResponse_UMaze')
    MouseNum = [801:824,830,831,833,836:848];
    for m = 1:length(MouseNum)
        a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetEmbReact/Midazolam/Mouse' num2str(MouseNum(m)) '/UMazeExplo/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    end
    
elseif strcmp(experiment,'MidazolamDoseResponse_Plethysmo')
    MouseNum = [830,831,836:848];
    for m = 1:length(MouseNum)
        a=a+1;Dir.path{a}{1}=['/media/nas4/ProjetEmbReact/Midazolam/Mouse' num2str(MouseNum(m)) '/Plethysmo/'];
        load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    end
    
elseif strcmp(experiment,'TestPost_PreDrug')
    % Mouse11203
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_TestPost_PreDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
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
    
    
elseif strcmp(experiment,'Recover_From_Drug')
    % Mouse 11203
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20211001/ProjectEmbReact_M11203_20211001_Recover_From_Drug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %     % Mouse 9203
    %     a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1203/20211005/ProjectEmbReact_M9203_20211005_Recover_From_Drug/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1199
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1199/20211012/ProjectEmbReact_M1199_20211012_Recover_From_Drug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20211015/ProjectEmbReact_M1230_20211015_Recover_From_Drug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1223
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1223/20211028/ProjectEmbReact_M1223_20211028_Recover_From_Drug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'UMazeCondExplo_Last')
    %     % Mouse 1561
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondExplo_Last/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    %         % Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondExplo_Last/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_Last')
    %     % Mouse 1561
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondBlockedShock_Last/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondBlockedShock_Last/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_Last')
    %     % Mouse 1561
    %     a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1561/20240206/ProjectEmbReact_M1561_20240206_UMazeCondBlockedSafe_Last/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %
    % Mouse 1563
    a=a+1;Dir.path{a}{1}='/media/nas7/ProjetEmbReact/Mouse1563/20240214/ProjectEmbReact_M1563_20240214_UMazeCondBlockedSafe_Last/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
else
    error('Invalid name of experiment')
end

end