function Dir=PathForExperimentsEmbReact_BM(experiment)


%% Path
a=0;
I_CA=[];

if strcmp(experiment,'Calibration')
    
    %     % Mouse1171
    %     a=a+1;
    %     cc=1;
    %     StimLevels={'0','1','1,5','2,5','3','3,5'};
    %     StimDur={'200','200','200','200','200','200'};
    %     for c=1:length(StimLevels)
    %         Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210204/ProjectEmbReact_M1171_20210204_Calibration_',StimLevels{c},'V_',StimDur{c},'ms/'];
    %         load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
    %         cc=cc+1;
    %     end
    
    
elseif strcmp(experiment,'BaselineSleep')
    %   % Mouse404
    %     a=a+1;
    %     Dir.path{a}{1}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160820/';
    %     load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    %     Dir.path{a}{2}='/media/DataMOBsRAID/ProjectEmbReact/Mouse404/20160823/';
    %     load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    %
elseif strcmp(experiment,'Habituation24HPre_PreDrug')
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation24HPre_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation24HPre_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
elseif strcmp(experiment,'Habituation_PreDrug')
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation_PreDrug/Hab1/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    Dir.path{a}{2}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_Habituation_PreDrug/Hab2/';
    load([Dir.path{a}{2},'ExpeInfo.mat']),Dir.ExpeInfo{a}{2}=ExpeInfo;
    
    
elseif strcmp(experiment,'HabituationBlockedShock_PreDrug')
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_HabituationBlockedShock_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'HabituationBlockedSafe_PreDrug')
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_HabituationBlockedSafe_PreDrug/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'SleepPre_PreDrug')
    
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_SleepPre/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'TestPre_PreDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_TestPre_PreDrug/TestPre',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    elseif strcmp(experiment,'SleepPost_PreDrug')
    % Mouse1171
    a=a+1;Dir.path{a}{1}='/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_SleepPost/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
elseif strcmp(experiment,'UMazeCondExplo_PostDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_UMazeCondExplo_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondBlockedShock_PostDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_UMazeCondBlockedShock_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'UMazeCondBlockedSafe_PostDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:3
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_UMazeCondBlockedSafe_PostDrug/Cond',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'TestPost_PostDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:4
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_TestPost_PostDrug/TestPost',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'ExtinctionBlockedShock_PostDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_ExtinctionBlockedShock_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
elseif strcmp(experiment,'ExtinctionBlockedSafe_PostDrug')
    % Mouse1171
    a=a+1;
    cc=1;
    for c=1:2
        Dir.path{a}{cc}=['/media/nas6/ProjetEmbReact/Mouse1171/20210304/ProjectEmbReact_M1171_20210304_ExtinctionBlockedSafe_PostDrug/Ext',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
end




