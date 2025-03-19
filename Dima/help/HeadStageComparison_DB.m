%%%% HeadStageComparison_DB
%%%%% No headstage - EIB - Two probes headstage %%%%%%%%%%


%% Load Data
% M703
DirNoH = PathForExperimentsERC_Dima('HabBehav');
DirNoH = RestrictPathForExperiment(DirNoH,'nMice',[703 708]);
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        a1{i}{j} = load([DirNoH.path{i}{j} '/behavResources.mat'],'AlignedXtsd','AlignedYtsd','Vtsd','PosMat');
    end
end
% M861
DirSmallH = PathForExperimentsERC_Dima('Hab');
DirSmallH = RestrictPathForExperiment(DirSmallH,'nMice',[797 798 828 861 905]);
for i=1:length(DirSmallH.path)
    a2{i} = load([DirSmallH.path{i}{1} '/behavResources.mat'],'CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');
end
% M994
a3{1} = load('/media/mobsrick/DataMOBS101/Mouse-994/20191011/HabSequence/02-Maze1/ERC-Mouse-994-11102019-Hab_05/behavResources.mat',...
    'CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');
a3{2} = load('/media/mobsrick/DataMOBS101/Mouse-994/20191011/HabSequence/03-Maze2/ERC-Mouse-994-11102019-Hab_06/behavResources.mat',...
    'CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');
a3{3} = load('/media/mobsrick/DataMOBS104/Dima/Mouse-994/20191105/Hab/1/ERC-Mouse-994-05112019-Hab_00/behavResources.mat',...
    'CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');
a3{4} = load('/media/mobsrick/DataMOBS104/Dima/Mouse-994/20191105/Hab/2/ERC-Mouse-994-05112019-Hab_01/behavResources.mat',...
    'CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');
a3{5} = load('/media/mobsrick/DataMOBS104/Dima/Mouse-994/20191106/Hab/ERC-Mouse-994-06112019-Hab_00/behavResources.mat',...
    'CleanAlignedXtsd','CleanAlignedYtsd','CleanVtsd');


%% Plot

fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
% M703
subplot(2,3,1)
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        plot(Data(a1{i}{j}.AlignedXtsd),Data(a1{i}{j}.AlignedYtsd),'LineWidth',2,'Color','k');
        set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
        box off
        hold on
    end
end
hold off
ylim([-0.1 1.1])
xlim([-0.1 1.1])
title('No headstage','FontSize',16,'FontWeight','bold');


subplot(2,3,4)
outV = [];
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        aaa = Data(a1{i}{j}.Vtsd);
        aaa = aaa./diff((a1{i}{j}.PosMat(:,1))); %%% !!!!!!!!! Conversion to cm/s
        aaa(aaa>35) = NaN;
        outV = [outV;aaa];
    end
end
hist(outV,100);
clear aaa outV
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
xlim([0 35])
ylim([0 8000])
h = findobj(gca,'Type','patch');
h.FaceColor = 'k';
h.EdgeColor = 'k';
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy
ylabel('Counts','FontSize',14,'FontWeight','bold');
xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');
% M861
subplot(2,3,2)
for i=1:length(DirSmallH.path)
    plot(Data(a2{i}.CleanAlignedXtsd),Data(a2{i}.CleanAlignedYtsd),'LineWidth',2,'Color','k');
    set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
    box off
    hold on
end
hold off
ylim([-0.1 1.1])
xlim([-0.1 1.1])
title('Small headstage (1.3g)','FontSize',16,'FontWeight','bold');

subplot(2,3,5)
outV = [];
for i=1:length(DirSmallH.path)
    aaa = Data(a2{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    outV = [outV;aaa];
end
hist(outV,100);
clear aaa outV
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
xlim([0 35])
ylim([0 8000])
h = findobj(gca,'Type','patch');
h.FaceColor = 'k';
h.EdgeColor = 'k';
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy
ylabel('Counts','FontSize',14,'FontWeight','bold');
xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');
% M994
subplot(2,3,3)
for i=1:length(a3)
    plot(Data(a3{i}.CleanAlignedXtsd),Data(a3{i}.CleanAlignedYtsd),'LineWidth',2,'Color','k');
    set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
    box off
    hold on
end
hold off
ylim([-0.1 1.1])
xlim([-0.1 1.1])
title('Big headstage (3.3g)','FontSize',16,'FontWeight','bold');

subplot(2,3,6)
outV = [];
for i=1:length(a3)
    aaa = Data(a3{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    outV = [outV;aaa];
end
hist(outV,100);
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
xlim([0 35])
ylim([0 8000])
h = findobj(gca,'Type','patch');
h.FaceColor = 'k';
h.EdgeColor = 'k';
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy
ylabel('Counts','FontSize',14,'FontWeight','bold');
xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');

% SaveF
saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/DifferentHSWeights_DB.fig');
 saveFigure(fh,'DifferentHSWeights_DB','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/');
 
 %% Individual plots
 
 % No headstage
 a = 1;
 fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        subplot(2,5,a)
        plot(Data(a1{i}{j}.AlignedXtsd),Data(a1{i}{j}.AlignedYtsd),'LineWidth',2,'Color','k');
        set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
        box off
        ylim([-0.1 1.1])
        xlim([-0.1 1.1])
        title(['No headstage ' num2str(i) '_' num2str(j)],'FontSize',16,'FontWeight','bold');
        
        subplot(2,5,a+5)
        aaa = Data(a1{i}{j}.Vtsd);
        aaa = aaa./diff((a1{i}{j}.PosMat(:,1))); %%% !!!!!!!!! Conversion to cm/s
        aaa(aaa>35) = NaN;
        hist(aaa,100);
        clear aaa 
        set(gca, 'FontSize', 16, 'FontWeight',  'bold');
        xlim([0 35])
        ylim([0 1600])
        h = findobj(gca,'Type','patch');
        h.FaceColor = 'k';
        h.EdgeColor = 'k';
        box off
        axis = gca;
        tempy = get(axis,'YTickLabel');
        tempy{1}='';
        set(gca,'YTickLabel',tempy);
        clear tempy
        ylabel('Counts','FontSize',14,'FontWeight','bold');
        xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');
        
        a=a+1;
    end
    a+1;
end
saveas(fh, ['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/forced_quickies/',...
    'No_headstage.fig']);
saveFigure(fh,'No_headstage',...
    '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/forced_quickies/');

% Speed of no headstage
fh = figure('units', 'normalized', 'outerposition', [0 0 0.4 0.5]);
outV = [];
a=1;
toplot1 = cell(1,5);
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        aaa = Data(a1{i}{j}.Vtsd);
        aaa = aaa./diff((a1{i}{j}.PosMat(:,1))); %%% !!!!!!!!! Conversion to cm/s
        aaa(aaa>35) = NaN;
        outV{i}{j} = aaa;
        h1{i}{j} = hist(outV{i}{j},100);
        plot(h1{i}{j},'LineWidth',3,'Color','k');
        set(gca, 'FontSize', 16, 'FontWeight',  'bold');
        box off
        xlim([0 35])
        ylim([0 2200])
        hold on
        
        temp{a} = outV{i}{j}(~isnan(outV{i}{j}));
        toplot1{a} = h1{i}{j}/sum(h1{i}{j});
        a=a+1;
    end
    a=a+1;
end
legend('M703_1','M703_2','M703_3','M708_1','M708_2')


%%%%
figure
for i = 1:length(toplot1)
    plot(toplot1{i},'LineWidth',3,'Color','k');
    hold on
end




%%%%%%%%


% Small headstage
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i=1:length(DirSmallH.path)
    
    subplot(2,5,i)
    plot(Data(a2{i}.CleanAlignedXtsd),Data(a2{i}.CleanAlignedYtsd),'LineWidth',2,'Color','k');
    set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
    box off
    ylim([-0.1 1.1])
    xlim([-0.1 1.1])
    title([num2str(i)],'FontSize',16,'FontWeight','bold');
    
    subplot(2,5,i+5)
    aaa = Data(a2{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    hist(aaa,100);
    clear aaa
    set(gca, 'FontSize', 16, 'FontWeight',  'bold');
    xlim([0 35])
    ylim([0 1600])
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'k';
    h.EdgeColor = 'k';
    box off
    axis = gca;
    tempy = get(axis,'YTickLabel');
    tempy{1}='';
    set(gca,'YTickLabel',tempy);
    clear tempy
    ylabel('Counts','FontSize',14,'FontWeight','bold');
    xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');
    
    
end
saveas(fh, ['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/forced_quickies/',...
    'Small_headstage_1.3g.fig']);
saveFigure(fh,'Small_headstage_1.3g',...
    '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/forced_quickies/');
close all

% Speed of small headstage
fh = figure('units', 'normalized', 'outerposition', [0 0 0.4 0.5]);
outV = [];
toplot = cell(1,5);
for i =1:length(DirSmallH.path)
    hold on
        aaa = Data(a2{i}.CleanVtsd);
        aaa(aaa>35) = NaN;
        outV{i} = aaa;
        h2{i} = hist(outV{i},100);
        plot(h2{i},'LineWidth',3,'Color','r');
        set(gca, 'FontSize', 16, 'FontWeight',  'bold');
        box off
        xlim([0 35])
        ylim([0 2500])
        hold on
        
        temp{i} = outV{i}(~isnan(outV{i}));
        toplot2{i} = h2{i}/sum(h2{i});
end
legend('M703_1','M703_2','M703_3','M708_1','M708_2')




% Big headstage

fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i=1:length(a3)
    subplot(2,5,i)
    plot(Data(a3{i}.CleanAlignedXtsd),Data(a3{i}.CleanAlignedYtsd),'LineWidth',2,'Color','k');
    set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
    box off
    ylim([-0.1 1.1])
    xlim([-0.1 1.1])
    title(['Big headstage (3.3g) ' num2str(i)],'FontSize',16,'FontWeight','bold');
    
    subplot(2,5,i+5)
    aaa = Data(a3{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    hist(aaa,100);
    clear aaa
    set(gca, 'FontSize', 16, 'FontWeight',  'bold');
    xlim([0 35])
    ylim([0 1600])
    h = findobj(gca,'Type','patch');
    h.FaceColor = 'k';
    h.EdgeColor = 'k';
    box off
    axis = gca;
    tempy = get(axis,'YTickLabel');
    tempy{1}='';
    set(gca,'YTickLabel',tempy);
    clear tempy
    ylabel('Counts','FontSize',14,'FontWeight','bold');
    xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');
    
end

fh = figure('units', 'normalized', 'outerposition', [0 0 0.4 0.5]);
outV = [];
toplot = cell(1,5);
for i =1:length(a3)
    hold on
        aaa = Data(a3{i}.CleanVtsd);
        aaa(aaa>35) = NaN;
        outV{i} = aaa;
        h3{i} = hist(outV{i},100);
        plot(h3{i},'LineWidth',3,'Color','r');
        set(gca, 'FontSize', 16, 'FontWeight',  'bold');
        box off
        hold on
        
        temp{i} = outV{i}(~isnan(outV{i}));
        toplot3{i} = h3{i}/sum(h3{i});
end
legend('M703_1','M703_2','M703_3','M708_1','M708_2')


saveas(fh, ['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/forced_quickies/',...
    'Big_headstage_3.3g.fig']);
saveFigure(fh,'Big_headstage_3.3g',...
    '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/forced_quickies/');
close all



%%
figure, subplot(1,2,1), hold on
for i = 1:length(toplot1)
    if i < 4
        a1 = plot(toplot1{i},'LineWidth',2.5,'Color','k');
    else
        a2 = plot(toplot1{i},'LineWidth',2.5,'Color',[0.7 0.7 0.7]);
    end
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    xlabel('bins')
    ylabel('Normalized speed')
    hold on
end

for i = 1:length(toplot2)
    a3 = plot(toplot2{i},'LineWidth',2.5,'Color',[0.9290, 0.6940, 0.1250]);
    hold on
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    xlabel('bins')
    ylabel('Normalized speed')
end

for i = 1:length(toplot3)
    a4 = plot(toplot3{i},'LineWidth',2.5,'Color','r');
    hold on
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    xlabel('bins')
    ylabel('Normalized speed')
end

subplot(1,2,2), hold on
for i = 1:length(toplot1)
    if i < 4
        a5 = plot(toplot1{i},'LineWidth',2.5,'Color','k');
    else
        a6 = plot(toplot1{i},'LineWidth',2.5,'Color',[0.7 0.7 0.7]);
    end
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca,'xscale','log')
    set(gca,'xtick',[1 5 10 25 50 75 100])
    set(gca,'xticklabel',[1 5 10 25 50 75 100])
    xlabel('bins')
    ylabel('Normalized speed')
    hold on
end

for i = 1:length(toplot2)
    a7 = plot(toplot2{i},'LineWidth',2.5,'Color',[0.9290, 0.6940, 0.1250]);
    set(gca,'xscale','log')
    set(gca,'xtick',[1 5 10 25 50 75 100])
    set(gca,'xticklabel',[1 5 10 25 50 75 100])
    xlabel('bins')
    ylabel('Normalized speed')
    hold on
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
end

for i = 1:length(toplot3)
    a8 = plot(toplot3{i},'LineWidth',2.5,'Color','r');
    set(gca,'xscale','log')
    set(gca,'xtick',[1 5 10 25 50 75 100])
    set(gca,'xticklabel',[1 5 10 25 50 75 100])
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    xlabel('bins')
    ylabel('Normalized speed')
    hold on
end

legend([a5,a6,a7,a8],'No headstage (Mouse1)', 'No headstage (Mouse2)','Headstage <2g',...
    'Headstage 3.3g','Location','NorthEast')


%%%%%%%%


%% Another plot - all on one plot

fh = figure('units', 'normalized', 'outerposition', [0 0 0.4 1]);
% M703
subplot(2,1,1)
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        plot(Data(a1{i}{j}.AlignedXtsd),Data(a1{i}{j}.AlignedYtsd),'LineWidth',2,'Color','k');
        set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
        box off
        hold on
    end
end
hold off
ylim([-0.1 1.1])
xlim([-0.1 1.1])
title('No headstage','FontSize',16,'FontWeight','bold');
hold on
for i=1:length(DirSmallH.path)
    plot(Data(a2{i}.CleanAlignedXtsd),Data(a2{i}.CleanAlignedYtsd),'LineWidth',2,'Color','r');
    set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
    box off
    hold on
end
hold off
ylim([-0.1 1.1])
xlim([-0.1 1.1])
title('Small headstage (1.3g)','FontSize',16,'FontWeight','bold');
hold on
for i=1:length(a3)
    plot(Data(a3{i}.CleanAlignedXtsd),Data(a3{i}.CleanAlignedYtsd),'LineWidth',2,'Color','g');
    set(gca,'XTickLabel',{},'YTickLabel',{},'LineWidth',3);
    box offfh = figure('units', 'normalized', 'outerposition', [0 0 0.4 0.5]);
outV = [];
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        aaa = Data(a1{i}{j}.Vtsd);
        aaa = aaa./diff((a1{i}{j}.PosMat(:,1))); %%% !!!!!!!!! Conversion to cm/s
        aaa(aaa>35) = NaN;
        outV = [outV;aaa];
    end
end
h = hist(outV,100);
plot(h,'Color','k','LineWidth',3);
clear aaa outV h
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy
hold on

    hold on
end
hold off
ylim([-0.1 1.1])
xlim([-0.1 1.1])
title('Big headstage (3.3g)','FontSize',16,'FontWeight','bold');


%%% Speed
fh = figure('units', 'normalized', 'outerposition', [0 0 0.4 0.5]);
outV = [];
for i =1:length(DirNoH.path)
    for j = 1:length(DirNoH.path{i})
        aaa = Data(a1{i}{j}.Vtsd);
        aaa = aaa./diff((a1{i}{j}.PosMat(:,1))); %%% !!!!!!!!! Conversion to cm/s
        aaa(aaa>35) = NaN;
        outV = [outV;aaa];
    end
end
h = hist(outV,100);
plot(h,'Color','k','LineWidth',3);
clear aaa outV h
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy
hold on

outV = [];
for i=1:length(DirSmallH.path)
    aaa = Data(a2{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    outV = [outV;aaa];
end
h = hist(outV,100);
plot(h,'Color','r','LineWidth',3);
clear aaa outV h
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy

outV = [];
for i=1:length(a3)
    aaa = Data(a3{i}.CleanVtsd);
    aaa(aaa>35) = NaN;
    outV = [outV;aaa];
end
h = hist(outV,100);
plot(h,'Color','g','LineWidth',3);
set(gca, 'FontSize', 16, 'FontWeight',  'bold');
xlim([0 35])
ylim([0 8000])
% h = findobj(gca,'Type','patch');
% h(1).FaceColor = 'g';
% h(1).EdgeColor = 'g';
% h(2).FaceColor = 'r';
% h(2).EdgeColor = 'r';
% h(3).FaceColor = 'k';
% h(3).EdgeColor = 'k';
box off
axis = gca;
tempy = get(axis,'YTickLabel');
tempy{1}='';
set(gca,'YTickLabel',tempy);
clear tempy
ylabel('Counts','FontSize',14,'FontWeight','bold');
xlabel('Speed (cm/s)','FontSize',14,'FontWeight','bold');

legend('No headstage','Small headstage (1.3g)', 'Big headstage (3.3g)')

% SaveF
saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/SpeedDistr.fig');
 saveFigure(fh,'DifferentHSWeights_DB2','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/');
 
