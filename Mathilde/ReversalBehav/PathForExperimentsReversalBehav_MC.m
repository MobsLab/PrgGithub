function Dir=PathForExperimentsReversalBehav_MC(experiment)

% input:
% name of the experiment.
% possible choices:

% 'Hab', 'TestPre', 'TestPostPAG', 'TestPostMFB'
% 'CondPAG', 'CondWallShockPAG', 'CondWallSafePAG'
% 'CondMFB', 'CondWallShockMFB', 'CondWallSafeMFB'

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
%lHav
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



%% Groups
% Sham = [3,4,5,7,8,10]; % with your new mice
% Exp = [1,2,6,9,11,12];

Sham = [3,4,5,7,9]; % with old mice only
Exp = [1,2,6,8,10];
%% Path
a=0;
I_CA=[];

if strcmp(experiment,'FirstExplo')
    % Mouse 913
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/FirstExplo/'; %expe
    % Mouse 934
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/FirstExplo/'; %expe
    % Mouse 935
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/FirstExplo/'; %sham
    % Mouse 938
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/FirstExplo/'; %sham
    % Mouse 1138
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/FirstExplo/'; %sham
    % Mouse 1139
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/FirstExplo/'; %expe
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/FirstExplo/'; %sham
    % Mouse 1140
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/FirstExplo/'; %sham
    % Mouse 1141
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/FirstExplo/'; %expe
    % Mouse 1142
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/FirstExplo/'; %sham
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/FirstExplo/';%expe
    % Mouse 1143
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/FirstExplo/'; %expe

elseif strcmp(experiment,'Extinction')
    % Mouse 913
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/Extinction/';
    % Mouse 934
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/Extinction/';
    % Mouse 935
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/Extinction/';
    % Mouse 938
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/Extinction/';
    % Mouse 1138
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/Extinction/';
    % Mouse 1139
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/Extinction/';
%    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/Extinction/';
    % Mouse 1140
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/Extinction/';
    % Mouse 1141
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/Extinction/';
    % Mouse 1142
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/Extinction/';
%     a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/Extinction/';
    % Mouse 1143
    a=a+1;Dir.path{a}{1}='/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/Extinction/'; 
    
elseif strcmp(experiment,'TestPre')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:4
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:4
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/ReversalWake_sham/TestPre/TestPre',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/TestPre/TestPre',num2str(s),'/'];
        ss=ss+1;
    end
    
    
elseif strcmp(experiment,'TestPostPAG')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:4
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
%         ss=ss+1;
%     end    
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:4
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'TestPostMFB')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:4
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
%         ss=ss+1;
%     end    
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:4
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
%         ss=ss+1;
%     end
    
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:4
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'CondPAG')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/Cond/CondPAG/CondPAG',num2str(s),'/'];
%         ss=ss+1;
%     end   
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/Cond/CondPAG/CondPAG',num2str(s),'/']; %sham
%         ss=ss+1;
%     end
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/Cond/CondPAG/CondPAG',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'CondMFB')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/Cond/CondMFB/CondMFB',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/Cond/CondMFB/CondMFB',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/Cond/CondMFB/CondMFB',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'CondWallShockPAG')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/ConWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end  
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
%         ss=ss+1;
%     end   
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/ConWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/ConWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
%         ss=ss+1;
%     end   
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'CondWallSafePAG')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'CondWallShockMFB')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/ConWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
%         ss=ss+1;
%     end    
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/ConWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/ConWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
%         ss=ss+1;
%     end
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
        ss=ss+1;
    end
    
elseif strcmp(experiment,'CondWallSafeMFB')
    % Mouse 913
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M913/20190529/ReversalWake/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 934
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M934/20190612/ReversalWake/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 935
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M935/20190613/ReversalWake_sham/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 938
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M938/20190618/ReversalWake_sham/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1138
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1138/20201216/ReversalWake_sham/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1139
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210106/ReversalWake/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1139/20210317/ReversalWake_sham/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
%         ss=ss+1;
%     end  
    % Mouse 1140
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1140/20201217/ReversalWake_sham/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1141
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1141/20201229/ReversalWake/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    % Mouse 1142
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20201218/ReversalWake_sham/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
%     a=a+1;
%     ss=1;
%     for s=1:3
%         Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1142/20210326/ReversalWake/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
%         ss=ss+1;
%     end  
    % Mouse 1143
    a=a+1;
    ss=1;
    for s=1:3
        Dir.path{a}{ss}=['/media/nas5/ProjetReversalBehavior/M1143/20201230/ReversalWake/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
        ss=ss+1;
    end
    
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

%% get groups
for i=1:length(Dir.path)
    Dir.manipe{i}=experiment;
    if strcmp(Dir.manipe{i},'Hab') || strcmp(Dir.manipe{i},'TestPre') || strcmp(Dir.manipe{i},'TestPostPAG') || strcmp(Dir.manipe{i},'TestPostMFB') || strcmp(Dir.manipe{i},'CondPAG') || strcmp(Dir.manipe{i},'CondMFB')
        for j=1:length(Sham)
            Dir.group{1}{Sham(j)} = 'Sham';
        end
        for j=1:length(Exp)
            Dir.group{1}{Exp(j)} = 'Exp';
        end
    end
end

