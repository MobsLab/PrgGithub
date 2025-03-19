


function Dir=PathForExperimentsEmbReact_Failures(experiment)

% input:
% name of the experiment.
% possible choices:
% '


% 'EPM'

% apprentissage PAG - webcam
% 'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost'
% 'Extinction'  --> PAG during the day

% 'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest'

% 'CtxtHab' 'SleepPreCtxt' 'CtxtCond' 'SleepPostCtxt' 'CtxtTest' 'CtxtTestCtrl'

% 'BaselineSleep'

% 'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight'
% 'SleepPostNight' 'TestPostNight' 'ExtinctionNight' --> PAG during the
% night

% 'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt'
% 'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt'

% apprentissage eyeshock - webcam/infrared
% 'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock'
% 'SleepPre_EyeShock' 'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' 'SleepPost_EyeShock'
% 'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'

% 'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
% 'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
% 'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
% 'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'

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

if strcmp(experiment,'Calibration')
    
    %     Mouse1135
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2','2,5','3','3,5'};
    StimDur={'200','200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201105/ProjectEmbReact_M1135_20201105_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    %     Mouse1134
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5','3,5','4,5'};
    StimDur={'200','200','200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201106/ProjectEmbReact_M1134_20201106_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse1131
    a=a+1;
    cc=1;
    StimLevels={'0','1','1,5','2,5'};
    StimDur={'200','200','200','200'};
    for c=1:length(StimLevels)
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201202/ProjectEmbReact_M1131_20201202_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
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
    
    
elseif strcmp(experiment,'BaselineSleep')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201109/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1135/20201110/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201119/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1134/20201122/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1130
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1130/20201105/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1130/20201106/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201105/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1131/20201106/';
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
    
    
elseif strcmp(experiment,'Habituation24HPre_PreDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    
elseif strcmp(experiment,'Habituation_PreDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'HabituationBlockedSafe_PreDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'SleepPre_PreDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1144
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1146
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1147
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPre_PreDrug')
    
    
    % Mouse 1135
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1134
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_TestPre_PreDrug//TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1131
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'UMazeCondExplo_PreDrug')
    
    % Mouse1135
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1134
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1131
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_UMazeCondExplo_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PreDrug')
    
    
    % Mouse 1135
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1134
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1131
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_UMazeCondBlockedShock_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PreDrug')
    
    
    % Mouse 1135
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1134
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1131
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_UMazeCondBlockedSafe_PreDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'SleepPost_PreDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_SleepPost_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'UMazeCondExplo_PostDrug')
    
    
    % Mouse1135
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1134
    a=a+1;
    cc=1;
    for c=1
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1131
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1144
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PostDrug')
    
    % Mouse 1135
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1134
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1131
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PostDrug')
    
    % Mouse 1135
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1134
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1131
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'SleepPost_PostDrug')
    
    % Mouse 1135
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1134
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1131
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    
elseif strcmp(experiment,'TestPost_PostDrug')
    
    % Mouse 1135
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1134
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse 1131
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1144
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1146
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1147
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PostDrug')
    
    
    % Mouse1135
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1134
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse1131
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1144
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PostDrug')
    
    % Mouse1135
    a=a+1;
    cc=1;
    for c=2:3
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1135/20201113/ProjectEmbReact_M1135_20201113_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1134
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas4/ProjetEmbReact/Mouse1134/20201125/ProjectEmbReact_M1134_20201125_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    % Mouse1131
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1131/20201203/ProjectEmbReact_M1131_20201203_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1144
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1144/20210114/ProjectEmbReact_M1144_20210114_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1146
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1146/20210114/ProjectEmbReact_M1146_20210114_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse1147
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1147/20210114/ProjectEmbReact_M1147_20210114_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
    
else
    error('Invalid name of experiment')
end

end










