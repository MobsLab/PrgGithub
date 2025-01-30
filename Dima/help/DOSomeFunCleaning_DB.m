%%%% LinearizeTrack_DB


%% Which data
Mice_to_analyze = [797 798 828 861 882 905 906 911 912];

DirHab = PathForExperimentsERC_Dima('Hab');
DirHab = RestrictPathForExperiment(DirHab, 'nMice', Mice_to_analyze);

DirPre = PathForExperimentsERC_Dima('TestPre');
DirPre = RestrictPathForExperiment(DirPre, 'nMice', Mice_to_analyze);

DirCond = PathForExperimentsERC_Dima('Cond');
DirCond = RestrictPathForExperiment(DirCond, 'nMice', Mice_to_analyze );

DirPost = PathForExperimentsERC_Dima('TestPost');
DirPost = RestrictPathForExperiment(DirPost, 'nMice', Mice_to_analyze );

%% Hab
% Clean
for i = 1:length(DirHab.path)
    for k = 1:length(DirHab.path{i})
        cd(DirHab.path{i}{k});
        
        [CleanPosMatInit, CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] =...
            CleanTrajectories_DB(DirHab.path{i}{k});
            
        save('behavResources.mat', 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
            'CleanVtsd', 'CleanMaskBounary', '-append');
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end

%% TestPre
% Morph
for i = 1:length(DirPre.path)
    for k = 1:length(DirPre.path{i})
        cd(DirPre.path{i}{k});
            
        [CleanPosMatInit, CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] =...
            CleanTrajectories_DB(DirPre.path{i}{k});
        
        save('behavResources.mat', 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
            'CleanVtsd', 'CleanMaskBounary', '-append');
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end

%% Cond
% Morph
for i = 1:length(DirCond.path)
    for k = 1:length(DirCond.path{i})
        cd(DirCond.path{i}{k});
        load('behavResources.mat');
        if ~exist('CleanXtsd','var')
            clearvars -except DirHab DirPre DirCond DirPost i k
            
            [CleanPosMatInit, CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] =...
                CleanTrajectories_DB(DirCond.path{i}{k});
            
            save('behavResources.mat', 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
                'CleanVtsd', 'CleanMaskBounary', '-append');
        end
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end

%% TestPost
% Morph
for i = 1:length(DirPost.path)
    for k = 1:length(DirPost.path{i})
        cd(DirPost.path{i}{k});
            
        [CleanPosMatInit, CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] =...
            CleanTrajectories_DB(DirPost.path{i}{k});
        
        save('behavResources.mat', 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
            'CleanVtsd', 'CleanMaskBounary', '-append');
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end