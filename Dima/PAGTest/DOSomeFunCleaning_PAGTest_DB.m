%%%% LinearizeTrack_DB


%% Which data
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];

Dir_DB = PathForExperimentsPAGTest_Dima('Hab');

Dir_SL = PathForExperimentsPAGTest_SL('Hab');

%% DB Hab
% Clean
for i = 1:length(Dir_DB.path)
    for k = 1:length(Dir_DB.path{i})
        cd(Dir_DB.path{i}{k});
        
        [CleanPosMatInit, CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] =...
            CleanTrajectories_DB(Dir_DB.path{i}{k});
            
        save('behavResources.mat', 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
            'CleanVtsd', 'CleanMaskBounary', '-append');
        
        close all
        clearvars -except Dir_SL Dir_DB i k
    end
end

%% SL Hab
% Morph
for i = 1:length(Dir_SL.path)
    for k = 1:length(Dir_SL.path{i})
        cd(Dir_SL.path{i}{k});
            
        [CleanPosMatInit, CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] =...
            CleanTrajectories_DB(Dir_SL.path{i}{k});
        
        save('behavResources.mat', 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
            'CleanVtsd', 'CleanMaskBounary', '-append');
        
        close all
        clearvars -except Dir_SL Dir_DB t i k
    end
end
