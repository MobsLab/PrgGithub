function Dir=PathForExperimentsEmbReactMontreal(experiment)

% input:
% name of the experiment.
% possible choices:
% 'Calibration'
% 'EPM'
% 'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost' 'Extinction'
% 'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest'
% 'CtxtHab' 'SleepPreCtxt' 'CtxtCond' 'SleepPostCtxt' 'CtxtTest' 'CtxtTestCtrl'
% 'BaselineSleep'
% 'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight'
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
% 'EPM'
% 'Habituation' 'SleepPreUmaze' 'PreTest' 'Cond' 'SleepPostUmaze' 'PostTest' 'Extinction'
% 'SleepPreEPM' 'SleepPostEPM'
% 'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest'
% 'CtxtHab' 'SleepPreCtxt' 'CtxtCond' 'SleepPostCtxt' 'CtxtTest' 'CtxtTestCtrl'
% 'BaselineSleep'

if strcmp(experiment,'EPM')
    %Mouse404
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160714/ProjetEmbReact_M404_20160714_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse430
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse430/20160801/ProjetctEmbReact_M430_20160801_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse445
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse445/20160824/ProjectEmbReact_M445_20160824_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_EPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

    
elseif strcmp(experiment,'Calibration')
    
%     % Mouse431
%     a=a+1;
%     cc=1;
%     StimLevels={'0','1','2','3','3','4','4','5','5'};
%     StimDur={'100','100','100','100','300','100','300','100','300'};
%     for c=1:length(StimLevels)
%         Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160730/PAGCalibration',StimLevels{c},'V-',StimDur{c},'ms/'];
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
%         Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160810/PAGCalibration/PAGCalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
%         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
%         cc=cc+1;
%     end
    
%     % Mouse437
%     a=a+1;
%     cc=1;
%     StimLevels={'0','0,5','1','2'};
%     StimDur={'100','100','100','200'};
%     for c=1:length(StimLevels)
%         Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160810/PAGCalibration/PAGCalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
%         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
%         cc=cc+1;
%     end
    
%     % Mouse438
%     a=a+1;
%     cc=1;
%     StimLevels={'1','2','3','3','4','4','5'};
%     StimDur={'100','100','100','200','100','200','100'};
%     for c=1:length(StimLevels)
%         Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160818/PAGCalibration/PACalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
%         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
%         cc=cc+1;
%     end
    
    % Mouse439
    a=a+1;
    cc=1;
    StimLevels={'0,5','1','2','2,5','2,5'};
    StimDur={'100','100','100','100','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160818/PAGCalibration/PAGCalibration-',StimLevels{c},'V-',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse469
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','3','4'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161019/Calibration/PAGCalibration',StimLevels{c},'V-200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    StimLevels={'0','1','2','25'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161019/Calibration/PAGCalibration',StimLevels{c},'V-200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse471
    a=a+1;
    cc=1;
    StimLevels={'0','05','1','15','2','25'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161025/PAGCalibration',StimLevels{c},'V-200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
%     %Mouse483
%     a=a+1;
%     cc=1;
%     StimLevels={'0','1','1,5','2'};
%     for c=1:length(StimLevels)
%         Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161114/Calibration/ProjectEmbReact_M483_20161114_Calibration_',StimLevels{c},'V-200ms/'];
%         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
%         cc=cc+1;
%     end
    
    %Mouse484
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161117/ProjectEmbReact_M484_20161117_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse485
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161117/ProjectEmbReact_M485_20161117_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse490
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161129/ProjectEmbReact_M490_20161129_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse507
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,3'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170131/ProjectEmbReact_M507_20170131_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse508
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170131/ProjectEmbReact_M508_20170131_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse509
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170131/ProjectEmbReact_M509_20170131_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
     
    %Mouse510
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170207/ProjectEmbReact_M510_20170207_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse512
    a=a+1;
    cc=1;
    StimLevels={'0','1'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170207/ProjectEmbReact_M512_20170207_Calibration_',StimLevels{c},'V_200ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'Habituation')
    
    %Mouse404
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160705/ProjetEmbReact_M404_20161705_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
   
    
elseif strcmp(experiment,'SleepPreUMaze')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPre')
    
    % Mouse117
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse117/20140221/ProjectFearAnxiety_M117_20140221_PreTest/PreTest',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse404
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160705/ProjetEmbReact_M404_20161705_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse425
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse431
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse436
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse437
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse438
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse439
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse490
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse507
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse508
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse509
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse510
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
     
    %Mouse512
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %Mouse514
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCond')
    % Mouse117
    a=a+1;
    cc=1;
    for c=[1:10,12:16]
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse117/20140221/ProjectFearAnxiety_M117_20140221_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse404
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160705/ProjetEmbReact_M404_20161705_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse425
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse431
    a=a+1;
    cc=1;
    for c=1:10
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse436
    a=a+1;
    cc=1;
    for c=1:9
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse437
    a=a+1;
    cc=1;
    for c=1:9
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse438
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse439
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse490
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse507
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse508
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse509
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse510
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse512
    a=a+1;
    cc=1;
    for c=1:6
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse514
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'SleepPostUMaze')
    
    %Mouse404
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160705/ProjetEmbReact_M404_20161705_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'TestPost')
    
    % Mouse404
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160705/ProjetEmbReact_M404_20161705_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse425
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse431
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse436
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse437
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse438
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse439
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse490
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse507
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse508
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse509
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
     
    % Mouse510
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse512
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse514
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'Extinction')
    
    %Mouse404
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160705/ProjetEmbReact_M404_20161705_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'SoundHab')
    
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160818/ProjectEmbReact_M425_20160818_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SoundHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;


elseif strcmp(experiment,'SleepPreSound')
    
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
       %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPreSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SoundCond')
    
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160818/ProjectEmbReact_M425_20160818_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
     %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SoundCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPostSound')
    
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPostSound/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;

elseif strcmp(experiment,'SoundTest')
    
    %Mouse431
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160803/ProjetctEmbReact_M431_20160803_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse436
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse437
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse438
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160819/ProjectEmbReact_M438_20160819_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse439
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160818/ProjectEmbReact_M425_20160818_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161201/ProjectEmbReact_M490_20161201_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170201/ProjectEmbReact_M507_20170201_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170203/ProjectEmbReact_M508_20170203_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170204/ProjectEmbReact_M509_20170204_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170209/ProjectEmbReact_M510_20170209_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170208/ProjectEmbReact_M512_20170208_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170316/ProjectEmbReact_M514_20170316_SoundTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'CtxtHab')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtHab/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPreCtxt')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_SleepPreCtxt/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'CtxtCond')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPostCtxt')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtCond/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'CtxtTest')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtTest/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'CtxtTestCtrl')
    
    %Mouse425
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160719/ProjectEmbReact_M425_20160719_CtxtTestCtrl/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPreEPM')
    
    %Mouse430
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse430/20160801/ProjetctEmbReact_M430_20160801_SleepPreEPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse445
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse445/20160824/ProjectEmbReact_M445_20160824_SleepPreEPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'SleepPostEPM')
    
    %Mouse430
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse430/20160801/ProjetctEmbReact_M430_20160801_SleepPostEPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %Mouse445
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse445/20160824/ProjectEmbReact_M445_20160824_SleepPostEPM/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'BaselineSleep')
    
    % Mouse404
%     a=a+1;
%     Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160820/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse404/20160823/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
%     % Mouse425
%     a=a+1;
%     Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160822/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse425/20160823/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     
%     % Mouse430
%     a=a+1;
%     Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse430/20160818/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse430/20160819/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     
%     % Mouse431
%     a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse431/20160802/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     
%     % Mouse436
%     a=a+1;
%     Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160809/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse436/20160810/Sleep/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     
%     % Mouse437
%     a=a+1;
%     Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160809/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse437/20160810/Sleep/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     
%     % Mouse438
%     a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160816/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160817/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     Dir.path{a}{3}='/media/sophie/My Passport1/ProjectEmbReac/Mouse438/20160818/Sleep/';
%     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
%     
    % Mouse439
    a=a+1;
    Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160816/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160817/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/sophie/My Passport/ProjectEmbReac/Mouse439/20160818/Sleep/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse444
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse444/20160819/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse444/20160820/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/sophie/My Passport/ProjectEmbReac/Mouse444/20160822/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
%     % Mouse445
%     a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse445/20160820/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse445/20160822/';
%     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
%     Dir.path{a}{3}='/media/sophie/My Passport1/ProjectEmbReac/Mouse445/20160823/';
%     load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
%     
    % Mouse469
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161102/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161019/Sleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161018/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161019/Sleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161018/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161024/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161021/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse483
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161114/Sleep/ProjectEmbReact_M483_20161114_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse484
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161117/ProjectEmbReact_M484_20161117_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    Dir.path{a}{3}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161115/ProjectEmbReact_M484_20161115_BaselineSleep/';
    load([Dir.path{a}{3},'ExpeInfo.mat']),Dir.ExpeInfo{a}{3}=ExpeInfo;
            
    %Mouse485
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161117/ProjectEmbReact_M485_20161117_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161115/ProjectEmbReact_M485_20161115_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse490
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse490/20161129/ProjectEmbReact_M490_20161129_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    %Mouse507
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170126/ProjectEmbReact_M507_20170126_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse507/20170127/ProjectEmbReact_M507_20170127_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse508
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse509
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
        
    %Mouse510
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170203/ProjectEmbReact_M510_20170203_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport/ProjectEmbReac/Mouse510/20170204/ProjectEmbReact_M510_20170204_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse512
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170202/ProjectEmbReact_M512_20170202_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/sophie/My Passport1/ProjectEmbReac/Mouse512/20170204/ProjectEmbReact_M512_20170204_BaselineSleep/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    %Mouse514
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse514/20170315/ProjectEmbReact_M514_20170315_BaselineSleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'HabituationNight')
    
    % Mouse469
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161024/ProjetctEmbReact_M469_20161024_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161028/ProjetctEmbReact_M471_20161028_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
%     % Mouse485
%     a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_Habituation/';
%     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
%     
elseif strcmp(experiment,'SleepPreNight')
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161028/ProjetctEmbReact_M471_20161028_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse485
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPreNight')
    
    % Mouse469
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161024/ProjetctEmbReact_M469_20161024_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse471
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161028/ProjetctEmbReact_M471_20161028_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse483
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse484
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse485
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_TestPre/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondNight')
    
    % Mouse469
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161024/ProjetctEmbReact_M469_20161024_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse471
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161028/ProjetctEmbReact_M471_20161028_Cond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse483
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse484
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse485
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_UMazeCond/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'SleepPostNight')
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse485
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'TestPostNight')
    
    % Mouse469
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161024/ProjetctEmbReact_M469_20161024_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse470
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse471
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161028/ProjetctEmbReact_M471_20161028_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse483
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse484
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse485
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_TestPost/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'ExtinctionNight')
    
    % Mouse469
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse469/20161024/ProjetctEmbReact_M469_20161024_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse470
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse470/20161026/ProjetctEmbReact_M470_20161026_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse471
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport/ProjectEmbReac/Mouse471/20161028/ProjetctEmbReact_M471_20161028_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse483
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse483/20161115/ProjectEmbReact_M483_20161115_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse484
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse484/20161122/ProjectEmbReact_M484_20161122_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse485
    a=a+1;Dir.path{a}{1}='/media/sophie/My Passport1/ProjectEmbReac/Mouse485/20161125/ProjectEmbReact_M485_20161125_Extinction/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
else
    error('Invalid name of experiment')
end

end