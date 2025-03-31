%%%% LinearizeTrack_DB


%% Which data
% Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
Mice_to_analyze = 977;

DirHab = PathForExperimentsERC_Dima('Hab');
DirHab = RestrictPathForExperiment(DirHab, 'nMice', Mice_to_analyze);

DirPre = PathForExperimentsERC_Dima('TestPre');
DirPre = RestrictPathForExperiment(DirPre, 'nMice', Mice_to_analyze);

DirCond = PathForExperimentsERC_Dima('Cond');
DirCond = RestrictPathForExperiment(DirCond, 'nMice', Mice_to_analyze );

DirPost = PathForExperimentsERC_Dima('TestPost');
DirPost = RestrictPathForExperiment(DirPost, 'nMice', Mice_to_analyze );


%% Hab
% Morph
for i = 1:length(DirHab.path)
    for k = 1:length(DirHab.path{i})
        cd(DirHab.path{i}{k});
        load behavResources.mat
        
        if ~(exist('AlignedXtsd','var'))
            
            [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd,Ytsd,...
                Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput',  '-append');
        end
        
        close all
        clear 
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
        
        mapxy=[Data(Ytsd)';Data(Xtsd)']';
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
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
end

%% TestPre
% Morph
for i = 1:length(DirPre.path)
    for k = 1:length(DirPre.path{i})
        cd(DirPre.path{i}{k});
        load behavResources.mat
            
        if ~(exist('AlignedXtsd','var'))
            
            [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd,Ytsd,...
                Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput',  '-append');
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end

% Linear
for i=1:length(DirPre.path)
    for k = 1:length(DirPre.path{i})
        cd(DirPre.path{i}{k});
        load('behavResources.mat');
        
%         if ~exist('LinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            mapxy=[Data(Ytsd)';Data(Xtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[DirPre.path{i}{1} 'lineartraj.fig']);
            saveFigure(gcf,'lineartraj', DirPre.path{i}{1});
            close(gcf);
            
            LinearDist=tsd(Range(Xtsd),t);
            
            save('behavResources.mat', 'LinearDist','-append');
%         end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
    end
end

%% Cond
% Morph
for i = 1:length(DirCond.path)
    for k = 1:length(DirCond.path{i})
        cd(DirCond.path{i}{k});
        load behavResources.mat
            
        if ~(exist('AlignedXtsd','var'))
            
            [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd,Ytsd,...
                Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput',  '-append');
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end

% Linear
for i=1:length(DirCond.path)
    for k=1:length(DirCond.path{i})
        cd(DirCond.path{i}{k});
        load('behavResources.mat');
        
%         if ~exist('LinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            mapxy=[Data(Ytsd)';Data(Xtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[DirCond.path{i}{1} 'lineartraj.fig']);
            saveFigure(gcf,'lineartraj', DirCond.path{i}{1});
            close(gcf);
            
            LinearDist=tsd(Range(Xtsd),t);
            
            save('behavResources.mat', 'LinearDist','-append');
%         end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
    end
end

%% TestPost
% Morph
for i = 1:length(DirPost.path)
    for k = 1:length(DirPost.path{i})
        cd(DirPost.path{i}{k});
        load behavResources.mat
            
        if ~(exist('AlignedXtsd','var'))
            
            [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd,Ytsd,...
                Zone{1},ref,Ratio_IMAonREAL);
            
            save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput',  '-append');
        end
        
        close all
        clearvars -except DirHab DirPre DirCond DirPost i k
    end
end

% Linear
for i=1:length(DirPost.path)
    for k=1:length(DirPost.path{i})
        cd(DirPost.path{i}{k});
        load('behavResources.mat');
        
        if ~exist('LinearDist','var')
            
            figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
            
            
            imagesc(mask+Zone{1})
            curvexy=ginput(4);
            clf
            
            mapxy=[Data(Ytsd)';Data(Xtsd)']';
            [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
            
            subplot(211)
            imagesc(mask+Zone{1})
            hold on
            plot(Data(Ytsd)'*Ratio_IMAonREAL,Data(Xtsd)'*Ratio_IMAonREAL)
            subplot(212)
            plot(t), ylim([0 1])
            
            saveas(gcf,[DirPost.path{i}{1} 'lineartraj.fig']);
            saveFigure(gcf,'lineartraj', DirPost.path{i}{1});
            close(gcf);
            
            LinearDist=tsd(Range(Xtsd),t);
            
            save('behavResources.mat', 'LinearDist','-append');
        end
        clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
    end
end