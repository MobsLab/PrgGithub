%%%% LinearizeTrack_DB


%% Which data
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
Mice_to_analyze = 994;

DirHab = PathForExperimentsERC_Dima('Hab');
DirHab = RestrictPathForExperiment(DirHab, 'nMice', Mice_to_analyze);

DirPre = PathForExperimentsERC_Dima('TestPre');
DirPre = RestrictPathForExperiment(DirPre, 'nMice', Mice_to_analyze);

DirCond = PathForExperimentsERC_Dima('Cond');
DirCond = RestrictPathForExperiment(DirCond, 'nMice', Mice_to_analyze );

DirPost = PathForExperimentsERC_Dima('TestPost');
DirPost = RestrictPathForExperiment(DirPost, 'nMice', Mice_to_analyze );

DirAfter = PathForExperimentsERC_Dima('ExploAfter');
DirAfter = RestrictPathForExperiment(DirAfter, 'nMice', Mice_to_analyze );

%% Hab
% Morph
for i = 1:length(DirHab.path)
    for k = 1:length(DirHab.path{i})
        cd(DirHab.path{i}{k});
        load behavResources.mat
        
        if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost DirAfter i k
    end
end

% Linear
for i=1:length(DirHab.path)
    cd(DirHab.path{i}{1});
    load('behavResources.mat');
    
    if ~exist('LinearDist','var')
        
        figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
        
        
        imagesc(mask+Zone{1})
        curvexy=ginput(4);
        clf
        
        mapxy=[Data(Ytsd)'; Data(Xtsd)']';
        [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
        
        subplot(211)
        imagesc(mask+Zone{1})
        hold on
        plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
        subplot(212)
        plot(t), ylim([0 1])
        
        saveas(gcf,[DirHab.path{i}{1} 'lineartraj.fig']);
        saveFigure(gcf,'lineartraj', DirHab.path{i}{1});
        close(gcf);
        
        LinearDist=tsd(Range(Xtsd),t);
        
        save('behavResources.mat', 'LinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
end



% CleanLinear
for i=1:length(DirHab.path)
    cd(DirHab.path{i}{1});
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
        
        saveas(gcf,[DirHab.path{i}{1} 'Cleanlineartraj.fig']);
        saveFigure(gcf,'Cleanlineartraj', DirHab.path{i}{1});
        close(gcf);
        
        CleanLinearDist=tsd(Range(CleanXtsd),t);
        
        save('behavResources.mat', 'CleanLinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
end

%% TestPre
% Morph
for i = 1:length(DirPre.path)
    for k = 1:length(DirPre.path{i})
        cd(DirPre.path{i}{k});
        load behavResources.mat
        
        if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost DirAfter i k
    end
end

% Linear
for i=1:length(DirPre.path)
    for k = 1:length(DirPre.path{i})
        cd(DirPre.path{i}{k});
        load('behavResources.mat');
        
        if ~exist('LinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            mapxy=[Data(Ytsd)'; Data(Xtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[DirPre.path{i}{k} 'lineartraj.fig']);
            saveFigure(gcf,'lineartraj', DirPre.path{i}{k});
            close(gcf);
            
            LinearDist=tsd(Range(Xtsd),t);
            
            save('behavResources.mat', 'LinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
    end
end



% CleanLinear
for i=1:length(DirPre.path)
    for k = 1:length(DirPre.path{i})
        cd(DirPre.path{i}{k});
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
            
            saveas(gcf,[DirPre.path{i}{k} 'Cleanlineartraj.fig']);
            saveFigure(gcf,'Cleanlineartraj', DirPre.path{i}{k});
            close(gcf);
            
            CleanLinearDist=tsd(Range(CleanXtsd),t);
            
            save('behavResources.mat', 'CleanLinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
    end
end

%% Cond
% Morph
for i = 1:length(DirCond.path)
    for k = 1:length(DirCond.path{i})
        cd(DirCond.path{i}{k});
        load behavResources.mat
        
        if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost DirAfter i k
    end
end

% Linear
for i=1:length(DirCond.path)
    for k = 1:length(DirCond.path{i})
        cd(DirCond.path{i}{k});
        load('behavResources.mat');
        
        if ~exist('LinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            mapxy=[Data(Ytsd)'; Data(Xtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[DirCond.path{i}{k} 'lineartraj.fig']);
            saveFigure(gcf,'lineartraj', DirCond.path{i}{k});
            close(gcf);
            
            LinearDist=tsd(Range(Xtsd),t);
            
            save('behavResources.mat', 'LinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
    end
end


% CleanLinear
for i=1:length(DirCond.path)
    for k=1:length(DirCond.path{i})
        cd(DirCond.path{i}{k});
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
            
            saveas(gcf,[DirCond.path{i}{k} 'Cleanlineartraj.fig']);
            saveFigure(gcf,'Cleanlineartraj', DirCond.path{i}{k});
            close(gcf);
            
            CleanLinearDist=tsd(Range(CleanXtsd),t);
            
            save('behavResources.mat', 'CleanLinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
    end
end

%% TestPost
% Morph
for i = 1:length(DirPost.path)
    for k = 1:length(DirPost.path{i})
        cd(DirPost.path{i}{k});
        load behavResources.mat
        
        if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost DirAfter i k
    end
end

% Linear
for i=1:length(DirPost.path)
    for k = 1:length(DirPost.path{i})
        cd(DirPost.path{i}{k});
        load('behavResources.mat');
        
        if ~exist('LinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            mapxy=[Data(Ytsd)'; Data(Xtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[DirPost.path{i}{k} 'lineartraj.fig']);
            saveFigure(gcf,'lineartraj', DirPost.path{i}{k});
            close(gcf);
            
            LinearDist=tsd(Range(Xtsd),t);
            
            save('behavResources.mat', 'LinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
    end
end


% CleanLinear
for i=1:length(DirPost.path)
    for k=1:length(DirPost.path{i})
        cd(DirPost.path{i}{k});
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
            
            saveas(gcf,[DirPost.path{k}{1} 'Cleanlineartraj.fig']);
            saveFigure(gcf,'Cleanlineartraj', DirPost.path{i}{k});
            close(gcf);
            
            CleanLinearDist=tsd(Range(CleanXtsd),t);
            
            save('behavResources.mat', 'CleanLinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
    end
end


%% ExploAfter
% Morph
for i = 1:length(DirAfter.path)
    for k = 1:length(DirAfter.path{i})
        cd(DirAfter.path{i}{k});
        load behavResources.mat
        
        if ~exist('CleanAlignedXtsd','var')
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
                (CleanXtsd,CleanYtsd,Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
                'CleanXYOutput',  '-append');
            
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost DirAfter i k
    end
end

% Linear
for i=1:length(DirAfter.path)
    cd(DirAfter.path{i}{1});
    load('behavResources.mat');
    
    if ~exist('LinearDist','var')
        
        figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
        
        
        imagesc(mask+Zone{1})
        curvexy=ginput(4);
        clf
        
        mapxy=[Data(Ytsd)'; Data(Xtsd)']';
        [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
        
        subplot(211)
        imagesc(mask+Zone{1})
        hold on
        plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
        subplot(212)
        plot(t), ylim([0 1])
        
        saveas(gcf,[DirAfter.path{i}{1} 'lineartraj.fig']);
        saveFigure(gcf,'lineartraj', DirAfter.path{i}{1});
        close(gcf);
        
        LinearDist=tsd(Range(Xtsd),t);
        
        save('behavResources.mat', 'LinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
end

% CleanLinear
for i=1:length(DirAfter.path)
    cd(DirAfter.path{i}{1});
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
        
        saveas(gcf,[DirAfter.path{i}{1} 'Cleanlineartraj.fig']);
        saveFigure(gcf,'Cleanlineartraj', DirAfter.path{i}{1});
        close(gcf);
        
        CleanLinearDist=tsd(Range(CleanXtsd),t);
        
        save('behavResources.mat', 'CleanLinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost DirAfter i
end