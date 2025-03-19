%%% BehaviorERCExample

%% Parameters
nmouse = 912;

DirPre = PathForExperimentsERC_Dima('TestPre');
DirPre = RestrictPathForExperiment(DirPre, 'nMice', nmouse );

DirCond = PathForExperimentsERC_Dima('Cond');
DirCond = RestrictPathForExperiment(DirCond, 'nMice', nmouse );

DirPost = PathForExperimentsERC_Dima('TestPost');
DirPost = RestrictPathForExperiment(DirPost, 'nMice', nmouse );

y_range_bar = [0 80];

%% Load data
for i=1:length(DirPre.path{1})
    Pre{i} = load([DirPre.path{1}{i} 'behavResources.mat'],'AlignedXtsd','AlignedYtsd','PosMat','Occup');
end
for i=1:length(DirCond.path{1})
    Cond{i} = load([DirCond.path{1}{i} 'behavResources.mat'],'AlignedXtsd','AlignedYtsd','PosMat','Occup');
end    
for i=1:length(DirPost.path{1})
    Post{i} = load([DirPost.path{1}{i} 'behavResources.mat'],'AlignedXtsd','AlignedYtsd','PosMat','Occup');
end        
    
%% Plot

maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZone = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0]; 

fh = figure('units', 'normalized', 'outerposition', [0 0 1 0.8]);

set(gcf,'DefaultLineLineWidth',2)
set(gca,'FontWeight','bold', 'FontSize',16);

subplot(2,3,1)
hold on
for i=1:length(DirPre.path{1})
    plot(Data(Pre{i}.AlignedXtsd),Data(Pre{i}.AlignedYtsd));
end
axis xy
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',2)
% plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',2)
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Pre Test Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
set(gca,'XTickLabel',{},'YTickLabel',{});
xlim([-0.1 1.1])
ylim([-0.1 1.1])

hold off

subplot(2,3,2)
hold on

for i=1:length(DirCond.path{1})
    plot(Data(Cond{i}.AlignedXtsd),Data(Cond{i}.AlignedYtsd));
    
    %Find shock locations
    id = find(Cond{i}.PosMat(:,4)==1);
    DX = Data(Cond{i}.AlignedXtsd);
    ShockX = DX(id);
    DY = Data(Cond{i}.AlignedYtsd);
    ShockY = DY(id);
    
    scatter(ShockX,ShockY,110,'r','filled','p');
end
axis xy
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',2)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',2)
%legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('PAG conditioning Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
set(gca,'XTickLabel',{},'YTickLabel',{});
xlim([-0.1 1.1])
ylim([-0.1 1.1])
hold off
clear id DX DY ShockX ShockY

subplot(2,3,3)
hold on
for i=1:4
    plot(Data(Post{i}.AlignedXtsd),Data(Post{i}.AlignedYtsd));
end
axis xy
hold on
plot(maze(:,1),maze(:,2),'k','LineWidth',2)
plot(shockZone(:,1),shockZone(:,2),'r','LineWidth',2)
% lgd=legend('Trial 1','Trial 2','Trial 3','Trial 4');
% aux=lgd.Location;
% lgd.Location='southoutside';
% aux=lgd.Orientation;
% lgd.Orientation = 'horizontal';

title('Post PAG Trajectories');
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
set(gca,'XTickLabel',{},'YTickLabel',{});
xlim([-0.1 1.1])
ylim([-0.1 1.1])

hold off

OccupLabels_2={'Shock';'Safe'};

subplot(2,3,4)

for i=1:length(DirPre.path{1})
    OccPreShock(i) = Pre{i}.Occup(1);
    OccPreSafe(i) = Pre{i}.Occup(2);
end

bar([1 2],100*[mean(OccPreShock) mean(OccPreSafe)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2);
hold on
er = errorbar([1,2],100*[mean(OccPreShock) mean(OccPreSafe)],100*[std(OccPreShock) std(OccPreSafe)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Pre Tests');
ylim(y_range_bar);
plot(ones(length(OccPreShock)),100*OccPreShock,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(length(OccPreSafe)),100*OccPreSafe,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);
text(0.1,23.2,'Random Occupancy', 'FontWeight','bold','FontSize',10);

subplot(2,3,5)

for i=1:length(DirCond.path{1})
    OccCondShock(i) = Cond{i}.Occup(1);
    OccCondSafe(i) = Cond{i}.Occup(2);
end


bar([1 2],100*[mean(OccCondShock) mean(OccCondSafe)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2);
hold on
er = errorbar([1,2],100*[mean(OccCondShock) mean(OccCondSafe)],100*[std(OccCondShock) std(OccCondSafe)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy PAG conditioning');
ylim(y_range_bar);
plot(ones(length(OccCondShock)),100*OccCondShock,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(length(OccCondSafe)),100*OccCondSafe,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);

subplot(2,3,6)

for i=1:length(DirPost.path{1})
    OccPostShock(i) = Post{i}.Occup(1);
    OccPostSafe(i) = Post{i}.Occup(2);
end

bar([1 2],100*[mean(OccPostShock) mean(OccPostSafe)],'k')
set(gca,'xticklabel',OccupLabels_2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2);
hold on
er = errorbar([1,2],100*[mean(OccPostShock) mean(OccPostSafe)],100*[std(OccPostShock) std(OccPostSafe)]);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
set(er,'LineWidth',2);
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
title('Zone Occupancy Post PAG');
ylim(y_range_bar);
plot(ones(length(OccPostShock)),100*OccPostShock,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
plot(2*ones(length(OccPostSafe)),100*OccPostSafe,'linestyle','none','marker','o','MarkerEdgeColor', [0.5 0.5 0.5]','MarkerFaceColor','w','MarkerSize',5);
line(xlim,[21.5 21.5],'Color','k','LineStyle','--','LineWidth',2);

