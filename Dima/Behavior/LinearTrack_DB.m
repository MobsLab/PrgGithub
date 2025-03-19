%%%% LinearizeTrack_DB


%% Which data
Mice_to_analyze = [711 712 714 742 797 798 828 861 882 905 906 911 912];

DirHab = PathForExperimentsERC_Dima('Hab');
DirHab = RestrictPathForExperiment(DirHab, 'nMice', Mice_to_analyze);

DirPre = PathForExperimentsERC_Dima('TestPrePooled');
DirPre = RestrictPathForExperiment(DirPre, 'nMice', Mice_to_analyze);

DirCond = PathForExperimentsERC_Dima('CondPooled');
DirCond = RestrictPathForExperiment(DirCond, 'nMice', Mice_to_analyze );

DirPost = PathForExperimentsERC_Dima('TestPostPooled');
DirPost = RestrictPathForExperiment(DirPost, 'nMice', Mice_to_analyze );


%% Hab
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
        saveFigure(gcf,'lineartraj', DirPre.path{i}{1});
        close(gcf);
        
        LinearDist=tsd(Range(Xtsd),t);
        
        save('behavResources.mat', 'LinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
end

%% TestPre
for i=1:length(DirPre.path)
    cd(DirPre.path{i}{1});
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
        
        saveas(gcf,[DirPre.path{i}{1} 'lineartraj.fig']);
        saveFigure(gcf,'lineartraj', DirPre.path{i}{1});
        close(gcf);
        
        LinearDist=tsd(Range(Xtsd),t);
        
        save('behavResources.mat', 'LinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
end

%% Cond
for i=1:length(DirCond.path)
    cd(DirCond.path{i}{1});
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
        
        saveas(gcf,[DirCond.path{i}{1} 'lineartraj.fig']);
        saveFigure(gcf,'lineartraj', DirCond.path{i}{1});
        close(gcf);
        
        LinearDist=tsd(Range(Xtsd),t);
        
        save('behavResources.mat', 'LinearDist','-append');
    end
    clearvars -except Mice_to_analyze DirHab DirPre DirCond DirPost i
end

%% TestPost
for i=1:length(DirPost.path)
    cd(DirPost.path{i}{1});
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