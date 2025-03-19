function Dir=PathForExperiments_MFB_Maze_BM(experiment)

% input:
% name of the experiment.
% possible choices:

% 'Habituation24HPre_PreDrug_TempProt' 'Habituation_PreDrug_TempProt' 'HabituationBlockedSafe_PreDrug_TempProt' 'HabituationBlockedShock_PreDrug_TempProt'
% 'SleepPre_PreDrug_TempProt' 'TestPre_PreDrug_TempProt' 'UMazeCond_PreDrug_TempProt' 'UMazeCondBlockedShock_PreDrug_TempProt' 'UMazeCondBlockedSafe_PreDrug_TempProt' 'SleepPost_PreDrug_TempProt'
% 'TestPost_PreDrug_TempProt' 'Extinction_PostDrug_TempProt' 'ExtinctionBlockedShock_PostDrug_TempProt' 'ExtinctionBlockedSafe__PostDrug_TempProt'

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
% PathForExperimentsEmbReact.m
% PathForExperimentsDeltaSleep.m
% PathForExperimentsKB.m
% PathForExperimentsML.m

%% strains inputs


%% Path
a=0;
I_CA=[];

if strcmp(experiment,'SleepPre_PreDrug')
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20220112/ProjectEmbReact_M1230_20220112_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1239
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1239/20220112/ProjectEmbReact_M1239_20220112_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11240
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1240/20220107/ProjectEmbReact_M1240_20220107_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11249
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1249/20220107/ProjectEmbReact_M1249_20220107_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11239
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1239/20220118/ProjectEmbReact_M1239_20220118_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1240
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1240/20220111/ProjectEmbReact_M1240_20220111_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1249
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1249/20220111/ProjectEmbReact_M1249_20220111_SleepPre_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
    
elseif strcmp(experiment,'Habituation')
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20220112/ProjectEmbReact_M1230_20220112_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1239
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1239/20220112/ProjectEmbReact_M1239_20220112_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11240
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1240/20220107/ProjectEmbReact_M1240_20220107_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11249
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1249/20220107/ProjectEmbReact_M1249_20220107_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11239
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1239/20220118/ProjectEmbReact_M1239_20220118_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1240
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1240/20220111/ProjectEmbReact_M1240_20220111_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1249
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1249/20220111/ProjectEmbReact_M1249_20220111_Habituation/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPre_PreDrug')
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20220112/ProjectEmbReact_M1230_20220112_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1239
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1239/20220112/ProjectEmbReact_M1239_20220112_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11240
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1240/20220107/ProjectEmbReact_M1240_20220107_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11249
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1249/20220107/ProjectEmbReact_M1249_20220107_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11230
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11239
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1239/20220118/ProjectEmbReact_M1239_20220118_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1240
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1240/20220111/ProjectEmbReact_M1240_20220111_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1249
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1249/20220111/ProjectEmbReact_M1249_20220111_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'UMazeCondExplo_PostDrug')
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20220112/ProjectEmbReact_M1230_20220112_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1239
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1239/20220112/ProjectEmbReact_M1239_20220112_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11240
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1240/20220107/ProjectEmbReact_M1240_20220107_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11249
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1249/20220107/ProjectEmbReact_M1249_20220107_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11230
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11239
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1239/20220118/ProjectEmbReact_M1239_20220118_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1240
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1240/20220111/ProjectEmbReact_M1240_20220111_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1249
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1249/20220111/ProjectEmbReact_M1249_20220111_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'SleepPost_PostDrug')
    
    % Mouse 1230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20220112/ProjectEmbReact_M1230_20220112_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1239
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1239/20220112/ProjectEmbReact_M1239_20220112_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11240
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1240/20220107/ProjectEmbReact_M1240_20220107_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11249
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1249/20220107/ProjectEmbReact_M1249_20220107_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11230
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 11239
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1239/20220118/ProjectEmbReact_M1239_20220118_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1240
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1240/20220111/ProjectEmbReact_M1240_20220111_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    % Mouse 1249
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1249/20220111/ProjectEmbReact_M1249_20220111_SleepPost_PostDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPost_PostDrug')
    
    % Mouse 1230
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20220112/ProjectEmbReact_M1230_20220112_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1239
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1239/20220112/ProjectEmbReact_M1239_20220112_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11240
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1240/20220107/ProjectEmbReact_M1240_20220107_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1249
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1249/20220107/ProjectEmbReact_M1249_20220107_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11230
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 11239
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1239/20220118/ProjectEmbReact_M1239_20220118_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1240
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1240/20220111/ProjectEmbReact_M1240_20220111_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1249
    a=a+1;
    cc=1;
    for c=1:8
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1249/20220111/ProjectEmbReact_M1249_20220111_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    
end