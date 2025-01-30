

% Numbers of mice to run analysis on
Mice_DB = [785 786 787];
Mice_SL = [784 789 792];
Mice_DB_E = 994;

% Get directories
Dir_DB = PathForExperimentsPAGTest_Dima('Hab');
Dir1_DB = RestrictPathForExperiment(Dir_DB,'Group','First');
Dir2_DB = RestrictPathForExperiment(Dir_DB,'Group','Second');
Dir1_DB = RestrictPathForExperiment(Dir1_DB,'nMice', Mice_DB);
Dir2_DB = RestrictPathForExperiment(Dir2_DB,'nMice', Mice_DB);

Dir_SL = PathForExperimentsPAGTest_Dima('Hab');
Dir1_SL = PathForExperimentsPAGTest_SL(Dir_SL,'Group','First');
Dir2_SL = PathForExperimentsPAGTest_SL(Dir_SL,'Group','Second');
Dir1_SL = PathForExperimentsPAGTest_SL(Dir1_SL,'nMice', Mice_SL);
Dir2_SL = PathForExperimentsPAGTest_SL(Dir2_SL,'nMice', Mice_SL);

%%%%%%%%%%%%%%% Do 994
Dir = MergePathForExperiment(Dir_DB,Dir_SL);
% Dir

%% Get data

for i = 1:length(Dir1_DB.path)
    a1{i} = load([Dir1_DB.path{i}{1} '/behavResources.mat']);
    h1{i} = load([Dir1_DB.path{i}{1} '/HeartBeatInfo.mat']);
end
for i = 1:length(Dir2_DB.path)
    a2{i} = load([Dir2_DB.path{i}{1} '/behavResources.mat']);
    h2{i} = load([Dir2_DB.path{i}{1} '/HeartBeatInfo.mat']);
end

%% Mazes
maze = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.6; 0.35 0.6; 0.35 0; 0 0]; 

%% Plot Traj
fh = figure('rend','painters','pos',[1 0.15 700 750]);
for i=1:length(a1)
    subplot(length(a1),2,2*i-1)
    plot(Data(a1{i}.CleanAlignedXtsd),Data(a1{i}.CleanAlignedYtsd),'LineWidth',2,'Color','k');
    box off
    set(gca,'XtickLabel',{},'YtickLabel',{});
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    if i==1
        title('First Exp','FontSize',18,'FontWeight','bold');
    end
    xlim([0 1])
    ylim([0 1])
    % set(gca, 'FontSize', 18, 'FontWeight',  'bold');
    
    subplot(length(a1),2,2*i)
    plot(Data(a2{i}.CleanAlignedXtsd),Data(a2{i}.CleanAlignedYtsd),'LineWidth',2,'Color','k');
    box off
    set(gca,'XtickLabel',{},'YtickLabel',{});
    hold on
    plot(maze(:,1),maze(:,2),'k','LineWidth',3)
    plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',3)
    if i==1
        title('Second Exp','FontSize',18,'FontWeight','bold');
    end
    xlim([0 1])
    ylim([0 1])
    % set(gca, 'FontSize', 18, 'FontWeight',  'bold');
end

saveas(fh,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/FirstSecond/Traj_DB.fig']);
    saveFigure(fh,'Traj_DB',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/FirstSecond/');

% Plot speed distribution
fh = figure('rend','painters','pos',[1 0.15 700 750]);
for i=1:length(a1)
    subplot(length(a1),2,2*i-1)
    aaa = Data(a1{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    dattemp = tsd(Range(a1{i}.CleanVtsd),aaa);
    hist(Data(dattemp),100);
    clear aaa dattemp
    set(gca, 'FontSize', 16, 'FontWeight',  'bold');
     xlim([0 35])
    if i==1
        ylim([0 800])
    elseif i==3
        ylim([0 800])
    end
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'k';
    h.EdgeColor = 'k';
    box off
    axis = gca;
    tempy = get(axis,'YTickLabel');
    tempy{1}='';
    set(gca,'YTickLabel',tempy);
    clear tempy
    if i==1
        title('First Exp','FontSize',18,'FontWeight','bold');
    end
    
    subplot(length(a1),2,2*i)
    aaa = Data(a2{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    dattemp = tsd(Range(a2{i}.CleanVtsd),aaa);
    hist(Data(dattemp),100);
    clear aaa dattemp
    set(gca, 'FontSize', 16, 'FontWeight',  'bold');
     xlim([0 35])
    if i==1
        ylim([0 800])
    elseif i==3
        ylim([0 800])
    end
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'k';
    h.EdgeColor = 'k';
    box off
    axis = gca;
    tempy = get(axis,'YTickLabel');
    tempy{1}='';
    set(gca,'YTickLabel',tempy);
    clear tempy
    if i==1
        title('Second Exp','FontSize',18,'FontWeight','bold');
    end
end

saveas(fh,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/FirstSecond/SpeedDistr_DB.fig']);
    saveFigure(fh,'SpeedDistr_DB',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/FirstSecond/');
    
% Heart rate
% Plot speed distribution
fh = figure('rend','painters','pos',[1 0.15 700 750]);
for i=1:length(h1)
    subplot(length(h1),2,2*i-1)
    hist(movmedian(Data(h1{i}.EKG.HBRate),5),10);
    set(gca, 'FontSize', 16, 'FontWeight',  'bold');
    xlim([11 14])
    if i==3
        ylim([0 2500])
    end
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'k';
    h.EdgeColor = 'k';
    box off
    axis = gca;
    tempy = get(axis,'YTickLabel');
    tempy{1}='';
    set(gca,'YTickLabel',tempy);
    clear tempy
    if i==1
        title('First Exp','FontSize',18,'FontWeight','bold');
    end

    
    subplot(length(h1),2,2*i)
    hist(movmedian(Data(h2{i}.EKG.HBRate),5),10);
    set(gca, 'FontSize', 16, 'FontWeight',  'bold');
    xlim([11 14])
    if i==3
        ylim([0 2500])
    end
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'k';
    h.EdgeColor = 'k';
    box off
    axis = gca;
    tempy = get(axis,'YTickLabel');
    tempy{1}='';
    set(gca,'YTickLabel',tempy);
    clear tempy
    if i==1
        title('Second Exp','FontSize',18,'FontWeight','bold');
    end
end

saveas(fh,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing_results/PAGTest/FirstSecond/HR_DB.fig']);
    saveFigure(fh,'HR_DB',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing_results/PAGTest/FirstSecond/');