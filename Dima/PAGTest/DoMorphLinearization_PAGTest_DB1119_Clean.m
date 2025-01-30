%%%% LinearizeTrack_DB


%% Which data
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];

Dir_DB = PathForExperimentsPAGTest_Dima('Hab');

Dir_SL = PathForExperimentsPAGTest_SL('Hab');

%% Hab DB
% Morph
for i = 1:length(Dir_DB.path)
    for k = 1:length(Dir_DB.path{i})
        cd(Dir_DB.path{i}{k});
        load behavResources.mat
        
%         if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_PAGTest_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
%         end
        
        close all
        clearvars -except Dir_DB Dir_SL i k
    end
end

% CleanLinear
for i=1:length(Dir_DB.path)
    cd(Dir_DB.path{i}{1});
    load('behavResources.mat');
    
%     if ~exist('CleanLinearDist','var')
        
        figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
        
        
        imagesc(mask+Zone{1})
        curvexy=ginput(4);
        clf
        
        xxx = Data(CleanXtsd)';
        yyy = Data(CleanYtsd)';
        mapxy=[Data(CleanXtsd)'; Data(CleanYtsd)']';
        [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
        
        t(isnan(xxx))=NaN;
        
        subplot(211)
        imagesc(mask+Zone{1})
        hold on
        plot(Data(CleanXtsd)'*Ratio_IMAonREAL,Data(CleanYtsd)'*Ratio_IMAonREAL)
        subplot(212)
        plot(t), ylim([0 1])
        
        saveas(gcf,[Dir_DB.path{i}{1} 'Cleanlineartraj.fig']);
        saveFigure(gcf,'Cleanlineartraj', Dir_DB.path{i}{1});
        close(gcf);
        
        CleanLinearDist=tsd(Range(CleanXtsd),t);
        
        save('behavResources.mat', 'CleanLinearDist','-append');
%     end
    clearvars -except Mice_to_analyze Dir_DB Dir_SL DirCond i
end

%% Hab SL
% Morph
for i = 1:length(Dir_SL.path)
    for k = 1:length(Dir_SL.path{i})
        cd(Dir_SL.path{i}{k});
        load behavResources.mat
        
%         if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_PAGTest_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
%         end
        
        close all
        clearvars -except Dir_SL Dir_DB i k
    end
end

% CleanLinear
for i=1:length(Dir_SL.path)
    for k = 1:length(Dir_SL.path{i})
        cd(Dir_SL.path{i}{k});
        load('behavResources.mat');
        
        if ~exist('CleanLinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            xxx = Data(CleanYtsd)';
            yyy = Data(CleanXtsd)';
            mapxy=[Data(CleanYtsd)'; Data(CleanXtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            t(isnan(xxx))=NaN;
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(CleanYtsd)'*Ratio_IMAonREAL,Data(CleanXtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[Dir_SL.path{i}{k} 'Cleanlineartraj.fig']);
            saveFigure(gcf,'Cleanlineartraj', Dir_SL.path{i}{k});
            close(gcf);
            
            CleanLinearDist=tsd(Range(CleanXtsd),t);
            
            save('behavResources.mat', 'CleanLinearDist','-append');
        end
        clearvars -except Mice_to_analyze Dir_SL Dir_DB i k
    end
end
