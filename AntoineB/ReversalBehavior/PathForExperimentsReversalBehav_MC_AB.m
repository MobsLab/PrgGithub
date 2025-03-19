function Dir=PathForExperimentsReversalBehav_MC_AB(experiment)

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
include_old_mice = true;
include_new_mice = true;
if include_new_mice && include_old_mice
    Sham = [3,4,5,7,8,10]; % with new & old mice
    Exp = [1,2,6,9,11,12];
elseif ~include_new_mice && include_old_mice
    Sham = [3,4,5,7,9]; % with old mice only
    Exp = [1,2,6,8,10];
elseif include_new_mice && ~include_old_mice
    Sham = [1]; % with new mice only
    Exp = [2];
else
    errordlg('No Mice included.\n');
    return;
end

%% Path
a=0;
I_CA=[];

if strcmp(experiment,'FirstExplo')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/FirstExplo/'; %expe
        % Mouse 934
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/FirstExplo/'; %expe
        % Mouse 935
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/FirstExplo/'; %sham
        % Mouse 938
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/FirstExplo/'; %sham
        % Mouse 1138
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/FirstExplo/'; %sham
        % Mouse 1139
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/FirstExplo/'; %expe
        % Mouse 1140
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/FirstExplo/'; %sham
        % Mouse 1141
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/FirstExplo/'; %expe
        % Mouse 1142
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/FirstExplo/'; %sham
        % Mouse 1143
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/FirstExplo/'; %expe
    end
    % Additional mice
    if include_new_mice
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/FirstExplo/'; %sham
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/FirstExplo/'; %expe
    end

elseif strcmp(experiment,'Extinction')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/Extinction/';
        % Mouse 934
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/Extinction/';
        % Mouse 935
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/Extinction/';
        % Mouse 938
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/Extinction/';
        % Mouse 1138
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/Extinction/';
        % Mouse 1139
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/Extinction/';
        % Mouse 1140
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/Extinction/';
        % Mouse 1141
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/Extinction/';
        % Mouse 1142
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/Extinction/';
        % Mouse 1143
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/Extinction/';
    end
    % Additional mice
    if include_new_mice
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/Extinction/';
        a=a+1;Dir.path{a}{1}='/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/Extinction/';
    end
    
elseif strcmp(experiment,'TestPre')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;true
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/TestPre/TestPre',num2str(s),'/'];
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'TestPostPAG')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/TestPost/TestPostPAG/TestPostPAG',num2str(s),'/'];
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'TestPostMFB')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:4
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/TestPost/TestPostMFB/TestPostMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'CondPAG')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/Cond/CondPAG/CondPAG',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/Cond/CondPAG/CondPAG',num2str(s),'/']; %sham
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'CondMFB')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/Cond/CondMFB/CondMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'CondWallShockPAG')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/ConWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/ConWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/ConWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/CondWallShock/CondWallShockPAG/CondWallShockPAG',num2str(s),'/'];
            ss=ss+1;
        end 
    end
    
elseif strcmp(experiment,'CondWallSafePAG')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/CondWallSafe/CondWallSafePAG/CondWallSafePAG',num2str(s),'/'];
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'CondWallShockMFB')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/ConWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/ConWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/ConWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/CondWallShock/CondWallShockMFB/CondWallShockMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    
elseif strcmp(experiment,'CondWallSafeMFB')
    % Old mice
    if include_old_mice
        % Mouse 913
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M913/29052019/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 934
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M934/12062019/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 935
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M935/13062019/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 938
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M938/18062019/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1138
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1138/16122020/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1139
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/06012021/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1140
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1140/17122020/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1141
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1141/29122020/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1142
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/18122020/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        % Mouse 1143
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1143/30122020/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
    end
    % Additional mice
    if include_new_mice
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1139/17032021/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
        a=a+1;
        ss=1;
        for s=1:3
            Dir.path{a}{ss}=['/media/nas5/ProjetERC3/ReversalBehav/M1142/26032021/CondWallSafe/CondWallSafeMFB/CondWallSafeMFB',num2str(s),'/'];
            ss=ss+1;
        end
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
    if strcmp(Dir.manipe{i},'Hab') || strcmp(Dir.manipe{i},'TestPre') || strcmp(Dir.manipe{i},'TestPostPAG')...
            || strcmp(Dir.manipe{i},'TestPostMFB') || strcmp(Dir.manipe{i},'CondPAG') || strcmp(Dir.manipe{i},'CondMFB')
        for j=1:length(Sham)
            Dir.group{1}{Sham(j)} = 'Sham';
        end
        for j=1:length(Exp)
            Dir.group{1}{Exp(j)} = 'Exp';
        end
    end
end


