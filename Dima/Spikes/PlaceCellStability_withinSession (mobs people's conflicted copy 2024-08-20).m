%% Parameters
nmouse = [797 798 828 861 882 905 906 911 912 977];
% nmouse = [906 912]; % Had PreMazes
% nmouse = [905 911]; % Did not have PreMazes
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);

overlapFactor = 0;

sav = 0;

%% Load Data
s=0;
r=0;
CorrStabSameCell = nan(1,100);
CorrStabOtherCell = nan(1,1000);
CorrStabAfterCondCell = nan(1,100);
CorrStabSameCell_idx = cell(1,100);
CorrStabOtherCell_idx = cell(1,1000);
CorrStabAfterCondCell_idx = cell(1,100);
for j=1:length(Dir.path)
    cd(Dir.path{j}{1});
    b{j} = load('SpikeData.mat','S','PlaceCells');
    a{j} = load('behavResources.mat','SessionEpoch','Vtsd','CleanAlignedXtsd','CleanAlignedYtsd');
    
    st = Start(a{j}.SessionEpoch.Hab);
    en = End(a{j}.SessionEpoch.Hab);
    Hab1Half = intervalSet(st,((en-st)/2)+st);
    Hab2Half = intervalSet(((en-st)/2)+st,en);
    
    % BaselineExplo Epoch
    UMazeEpoch = or(a{j}.SessionEpoch.Hab,a{j}.SessionEpoch.TestPre1);
    UMazeEpoch = or(UMazeEpoch,a{j}.SessionEpoch.TestPre2);
    UMazeEpoch = or(UMazeEpoch,a{j}.SessionEpoch.TestPre3);
    UMazeEpoch = or(UMazeEpoch,a{j}.SessionEpoch.TestPre4);
    
    % After Conditioning
    AfterConditioningEpoch = or(a{j}.SessionEpoch.TestPost1,a{j}.SessionEpoch.TestPost2);
    AfterConditioningEpoch = or(AfterConditioningEpoch,a{j}.SessionEpoch.TestPost3);
    AfterConditioningEpoch = or(AfterConditioningEpoch,a{j}.SessionEpoch.TestPost4);
    
    
    % Locomotion threshold
    LocomotionEpoch = thresholdIntervals(tsd(Range(a{j}.Vtsd),movmedian(Data(a{j}.Vtsd),5)),2.5,'Direction','Above');
    % Get resulting epochs
    UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
    AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
    MovingHab1Half = and(LocomotionEpoch,Hab1Half);
    MovingHab2Half = and(LocomotionEpoch,Hab2Half);
    
    % Same cell stabity
    if isfield(b{j}.PlaceCells,'idx')
        for i=1:length(b{j}.PlaceCells.idx)
            try
                map1 = PlaceField_DB(Restrict(b{j}.S{b{j}.PlaceCells.idx(i)},MovingHab1Half),...
                    Restrict(a{j}.CleanAlignedXtsd, MovingHab1Half),...
                    Restrict(a{j}.CleanAlignedYtsd, MovingHab1Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                map2 = PlaceField_DB(Restrict(b{j}.S{b{j}.PlaceCells.idx(i)},MovingHab2Half),...
                    Restrict(a{j}.CleanAlignedXtsd, MovingHab2Half),...
                    Restrict(a{j}.CleanAlignedYtsd, MovingHab2Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                close all
            catch
                map1 = [];
                map2 = [];
            end
            if ~isempty(map1) && ~isempty(map2)
                s=s+1;
                de = corrcoef(map1.rate,map2.rate);
                CorrStabSameCell(s) = de(2,1);
                CorrStabSameCell_idx{s} = [j b{j}.PlaceCells.idx(i)];
            else
                s+1;
                CorrStabSameCell(s) = nan;
            end
        end
    end
    
    clear map1 map2
    
    % Inter-cell correlation
    if isfield(b{j}.PlaceCells,'idx')
        for i=1:length(b{j}.PlaceCells.idx)
            for k = 1:length(b{j}.PlaceCells.idx)
                if i~=k
                    try
                        map1 = PlaceField_DB(Restrict(b{j}.S{b{j}.PlaceCells.idx(i)},MovingHab1Half),...
                            Restrict(a{j}.CleanAlignedXtsd, MovingHab1Half),...
                            Restrict(a{j}.CleanAlignedYtsd, MovingHab1Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                        map2 = PlaceField_DB(Restrict(b{j}.S{b{j}.PlaceCells.idx(k)},MovingHab1Half),...
                            Restrict(a{j}.CleanAlignedXtsd, MovingHab1Half),...
                            Restrict(a{j}.CleanAlignedYtsd, MovingHab1Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                        close all
                    catch
                        map1 = [];
                        map2 = [];
                    end
                    if ~isempty(map1) && ~isempty(map2)
                        de = corrcoef(map1.rate,map2.rate);
                        r=r+1;
                        CorrStabOtherCell(r) = de(2,1);
                        CorrStabOtherCell_idx{r} = [j i; j k];
                    else
                        r=r+1;
                        CorrStabOtherCell(r) = nan;
                    end
                else
                    r=r+1;
                    CorrStabOtherCell(r) = nan;
                end
            end
        end
    end
    
    clear map1 map2
    
    % Inter-cell correlation
     if isfield(b{j}.PlaceCells,'idx')
        for i=1:length(b{j}.PlaceCells.idx)
            try
                map1 = PlaceField_DB(Restrict(b{j}.S{b{j}.PlaceCells.idx(i)},UMazeMovingEpoch),...
                    Restrict(a{j}.CleanAlignedXtsd, UMazeMovingEpoch),...
                    Restrict(a{j}.CleanAlignedYtsd, UMazeMovingEpoch), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                map2 = PlaceField_DB(Restrict(b{j}.S{b{j}.PlaceCells.idx(i)},AfterConditioningMovingEpoch),...
                    Restrict(a{j}.CleanAlignedXtsd, AfterConditioningMovingEpoch),...
                    Restrict(a{j}.CleanAlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                close all
            catch
                map1 = [];
                map2 = [];
            end
            if ~isempty(map1) && ~isempty(map2)
                s=s+1;
                de = corrcoef(map1.rate,map2.rate);
                CorrStabAfterCondCell(s) = de(2,1);
                CorrStabAfterCondCell_idx{s} = [j b{j}.PlaceCells.idx(i)];
            else
                s+1;
                CorrStabAfterCondCell(s) = nan;
            end
        end
    end
    
    clear st en Hab1Half Hab1Half LocomotionEpoch MovingHab1Half MovingHab2Half
end



CorrStabSameCell45 = CorrStabSameCell(~isnan(CorrStabSameCell));
CorrStabSameCell_idx45 = CorrStabSameCell_idx(~isnan(CorrStabSameCell));
[CorrStabSameCell_Final,idx1] = unique(CorrStabSameCell45);
CorrStabSameCell_idx_Final = CorrStabSameCell_idx45(idx1);

CorrStabOtherCell45 = CorrStabOtherCell(~isnan(CorrStabOtherCell));
CorrStabOtherCell_idx45 = CorrStabOtherCell_idx(~isnan(CorrStabOtherCell));
[CorrStabOtherCell_Final,idx1] = unique(CorrStabOtherCell45);
CorrStabOtherCell_idx_Final = CorrStabOtherCell_idx45(idx1);

CorrStabAfterCondCell45 = CorrStabAfterCondCell(~isnan(CorrStabAfterCondCell));
CorrStabAfterCondCell_idx45 = CorrStabAfterCondCell_idx(~isnan(CorrStabAfterCondCell));
[CorrStabAfterCondCell_Final,idx1] = unique(CorrStabAfterCondCell45);
CorrStabAfterCondCell_idx_Final = CorrStabAfterCondCell_idx45(idx1);



%% Plot
Pl = {CorrStabSameCell_Final; CorrStabOtherCell_Final; CorrStabAfterCondCell_Final};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:3]);
% [p,h5,stats] = signrank(Pl{1},Pl{2});
% if p < 0.05
%     sigstar_DB({{1,2}},p,0, 'StarSize',16);
% end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',20,'XTick',1:3,'XTickLabel',...
    {'Intra-cell','Inter-cell','AfterCond'});
ylabel('Correlation Coef.')
% title('Place cell intra-session stability')
% ylim([0 0.9])
ax = gca;
labels = string(ax.YAxis.TickLabels); % extract
labels(2:2:end) = nan; % remove every other one
ax.YAxis.TickLabels = labels; % set

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

saveas(fh,'/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/IntraSessionStab_AllCells.fig');
saveFigure(fh,'IntraSessionStab_AllCells','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/');


% %% Find 95% Confidence interval
% s=0;
% for i=1:length(SelectedPlaceCells)
%     if ~isempty(SelectedPlaceCells(i).Hab1Half)
%         for j = 1:length(SelectedPlaceCells(i).Hab1Half.map) % cell1
%             s=s+1;
%             m{s} = SelectedPlaceCells(i).Hab1Half.map{j};
%         end
%     end
% end
% 
% CorrStabAll = zeros(length(m),length(m));
% for i = 1:length(m)
%     for j=i+1:length(m)
%         de = corrcoef(m{i}.rate,m{j}.rate);
%         CorrStabAll(i,j) = de(2,1);
%     end
% end
% A = nonzeros(CorrStabAll);
% N = length(A);
% M = mean(A);
% ySEM = std(A)/sqrt(N);
% CI95=tinv([0 0.95],N-1);
% yCI95 = bsxfun(@times,ySEM,CI95(:));
% Y = prctile(A,95);
% figure
% hist(A,20,'k')
% hold on
% line([yCI95(2) yCI95(2)], ylim,'color','r','Linewidth',3)
% set(gca,'LineWidth',3,'FontSize',14)
% title('Corr. coefficient')
% 
% %% Examples
% 
% %Good2
% fh2 = figure('units', 'normalized', 'outerposition', [0 0 0.63 0.67]);
% subplot(221)
% maze = [17 10; 17 85; 86 85; 86 10; 62 10; 62 66; 41 66; 41 10; 17 10];
% shockzone = [17 10; 17 43; 41 43; 41 10; 17 10];
% imagesc(SelectedPlaceCells(8).Hab1Half.map{1}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('First half of PreExploration')
% 
% subplot(222)
% maze = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
% shockzone = [10 10; 10 42; 38 42; 38 10;10 10];
% imagesc(SelectedPlaceCells(8).Hab2Half.map{1}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('Second half of PreExploration')
% 
% subplot(223)
% maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
% shockzone = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0];
% a = load('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/behavResources.mat',...
%     'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
% st = Start(a.SessionEpoch.Hab);
% en = End(a.SessionEpoch.Hab);
% Hab1Half = intervalSet(st,((en-st)/2)+st);
% Hab2Half = intervalSet(((en-st)/2)+st,en);
% LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
% MovingHab1Half = and(LocomotionEpoch,Hab1Half);
% MovingHab2Half = and(LocomotionEpoch,Hab2Half);
% plot(Data(Restrict(a.AlignedXtsd, MovingHab1Half)),Data(Restrict(a.AlignedYtsd, MovingHab1Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(8).Hab1Half.px{1},SelectedPlaceCells(8).Hab1Half.py{1},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% 
% subplot(224)
% plot(Data(Restrict(a.AlignedXtsd, MovingHab2Half)),Data(Restrict(a.AlignedYtsd, MovingHab2Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(8).Hab2Half.px{1},SelectedPlaceCells(8).Hab2Half.py{1},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3);
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% clear a
% mtit(fh2,[SelectedPlaceCells(8).name ' - ' SelectedPlaceCells(8).Hab2Half.idtet{1}],'yoff',0.01,'zoff',0.03,...
%     'FontSize',16)
% 
% saveas(fh2,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples' ...
%     '/IntraHabStab_' SelectedPlaceCells(8).name '-' SelectedPlaceCells(8).Hab2Half.idtet{1} '.fig']);
% saveFigure(fh2,['IntraHabStab_' SelectedPlaceCells(8).name '-' SelectedPlaceCells(8).Hab2Half.idtet{1}],...
%     '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');
% 
% %Bad1
% fh3 = figure('units', 'normalized', 'outerposition', [0 0 0.63 0.67]);
% subplot(221)
% maze = [10 12; 10 79; 76 79; 76 12; 52 12; 52 58; 35 58; 35 12; 10 12];
% shockzone = [10 12; 10 45; 35 45; 35 12; 10 12];
% imagesc(SelectedPlaceCells(10).Hab1Half.map{3}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('First half of PreExploration')
% 
% subplot(222)
% maze = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
% shockzone = [10 10; 10 42; 38 42; 38 10;10 10];
% imagesc(SelectedPlaceCells(10).Hab2Half.map{3}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('Second half of PreExploration')
% 
% subplot(223)
% maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
% shockzone = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0];
% a = load('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/behavResources.mat',...
%     'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
% st = Start(a.SessionEpoch.Hab);
% en = End(a.SessionEpoch.Hab);
% Hab1Half = intervalSet(st,((en-st)/2)+st);
% Hab2Half = intervalSet(((en-st)/2)+st,en);
% LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
% MovingHab1Half = and(LocomotionEpoch,Hab1Half);
% MovingHab2Half = and(LocomotionEpoch,Hab2Half);
% plot(Data(Restrict(a.AlignedXtsd, MovingHab1Half)),Data(Restrict(a.AlignedYtsd, MovingHab1Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(10).Hab1Half.px{3},SelectedPlaceCells(10).Hab1Half.py{3},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% 
% subplot(224)
% plot(Data(Restrict(a.AlignedXtsd, MovingHab2Half)),Data(Restrict(a.AlignedYtsd, MovingHab2Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(10).Hab2Half.px{3},SelectedPlaceCells(10).Hab2Half.py{3},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% clear a
% mtit(fh3,[SelectedPlaceCells(10).name ' - ' SelectedPlaceCells(10).Hab2Half.idtet{3}],'yoff',0.01,'zoff',0.03,...
%     'FontSize',16)
% 
% saveas(fh3,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples' ...
%     '/IntraHabStab_' SelectedPlaceCells(10).name '-' SelectedPlaceCells(10).Hab2Half.idtet{3} '.fig']);
% saveFigure(fh3,['IntraHabStab_' SelectedPlaceCells(10).name '-' SelectedPlaceCells(10).Hab2Half.idtet{3}],...
%     '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');
% 
% %Bad2
% fh4 = figure('units', 'normalized', 'outerposition', [0 0 0.63 0.67]);
% subplot(221)
% maze = [17 10; 17 85; 86 85; 86 10; 62 10; 62 66; 41 66; 41 10; 17 10];
% shockzone = [17 10; 17 43; 41 43; 41 10; 17 10];
% imagesc(SelectedPlaceCells(8).Hab1Half.map{4}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('First half of PreExploration')
% 
% subplot(222)
% maze = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
% shockzone = [10 10; 10 42; 38 42; 38 10;10 10];
% imagesc(SelectedPlaceCells(8).Hab2Half.map{4}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('Second half of PreExploration')
% 
% subplot(223)
% maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
% shockzone = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0];
% a = load('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/behavResources.mat',...
%     'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
% st = Start(a.SessionEpoch.Hab);
% en = End(a.SessionEpoch.Hab);
% Hab1Half = intervalSet(st,((en-st)/2)+st);
% Hab2Half = intervalSet(((en-st)/2)+st,en);
% LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
% MovingHab1Half = and(LocomotionEpoch,Hab1Half);
% MovingHab2Half = and(LocomotionEpoch,Hab2Half);
% plot(Data(Restrict(a.AlignedXtsd, MovingHab1Half)),Data(Restrict(a.AlignedYtsd, MovingHab1Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(8).Hab1Half.px{4},SelectedPlaceCells(8).Hab1Half.py{4},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% 
% subplot(224)
% plot(Data(Restrict(a.AlignedXtsd, MovingHab2Half)),Data(Restrict(a.AlignedYtsd, MovingHab2Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(8).Hab2Half.px{4},SelectedPlaceCells(8).Hab2Half.py{4},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% clear a
% mtit(fh4,[SelectedPlaceCells(8).name ' - ' SelectedPlaceCells(8).Hab2Half.idtet{4}],'yoff',0.01,'zoff',0.03,...
%     'FontSize',16)
% 
% saveas(fh4,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples' ...
%     '/IntraHabStab_' SelectedPlaceCells(8).name '-' SelectedPlaceCells(8).Hab2Half.idtet{4} '.fig']);
% saveFigure(fh4,['IntraHabStab_' SelectedPlaceCells(8).name '-' SelectedPlaceCells(8).Hab2Half.idtet{4}],...
%     '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');
% 
% %Bad3
% fh4 = figure('units', 'normalized', 'outerposition', [0 0 0.63 0.67]);
% subplot(221)
% maze = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
% shockzone = [10 12; 10 45; 35 45; 35 12; 10 12];
% imagesc(SelectedPlaceCells(10).Hab1Half.map{4}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('First half of PreExploration')
% 
% subplot(222)
% maze = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
% shockzone = [10 10; 10 42; 38 42; 38 10;10 10];
% imagesc(SelectedPlaceCells(10).Hab2Half.map{4}.rate)
% colormap jet
% colorbar
% axis xy
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% set(gca,'XTickLabel',{},'YTickLabel',{});
% title('Second half of PreExploration')
% 
% subplot(223)
% maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
% shockzone = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0];
% a = load('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/behavResources.mat',...
%     'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
% st = Start(a.SessionEpoch.Hab);
% en = End(a.SessionEpoch.Hab);
% Hab1Half = intervalSet(st,((en-st)/2)+st);
% Hab2Half = intervalSet(((en-st)/2)+st,en);
% LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
% MovingHab1Half = and(LocomotionEpoch,Hab1Half);
% MovingHab2Half = and(LocomotionEpoch,Hab2Half);
% plot(Data(Restrict(a.AlignedXtsd, MovingHab1Half)),Data(Restrict(a.AlignedYtsd, MovingHab1Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(10).Hab1Half.px{4},SelectedPlaceCells(10).Hab1Half.py{4},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% 
% subplot(224)
% plot(Data(Restrict(a.AlignedXtsd, MovingHab2Half)),Data(Restrict(a.AlignedYtsd, MovingHab2Half)),...
%     '.','Color',[0.8 0.8 0.8])
% hold on
% plot(SelectedPlaceCells(10).Hab2Half.px{4},SelectedPlaceCells(10).Hab2Half.py{4},'r.', 'MarkerSize', 12)
% plot(maze(:,1),maze(:,2),'k','LineWidth',3)
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% axis xy
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% set(gca, 'LineWidth', 3);
% set(gca,'XtickLabel',{},'YTickLabel',{});
% xlim([-0.1 1.1])
% ylim([-0.1 1.1])
% clear a
% mtit(fh4,[SelectedPlaceCells(10).name ' - ' SelectedPlaceCells(10).Hab2Half.idtet{4}],'yoff',0.01,'zoff',0.03,...
%     'FontSize',16)
% 
% saveas(fh4,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples' ...
%     '/IntraHabStab_' SelectedPlaceCells(10).name '-' SelectedPlaceCells(10).Hab2Half.idtet{4} '.fig']);
% saveFigure(fh4,['IntraHabStab_' SelectedPlaceCells(10).name '-' SelectedPlaceCells(10).Hab2Half.idtet{4}],...
%     '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');



%% Find examples

for i=1:length(CorrStabAfterCondCell_Final)
    st = Start(a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.Hab);
    en = End(a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.Hab);
    Hab1Half = intervalSet(st,((en-st)/2)+st);
    Hab2Half = intervalSet(((en-st)/2)+st,en);
    
    % BaselineExplo Epoch
    UMazeEpoch = or(a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.Hab,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPre1);
    UMazeEpoch = or(UMazeEpoch,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPre2);
    UMazeEpoch = or(UMazeEpoch,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPre3);
    UMazeEpoch = or(UMazeEpoch,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPre4);
    
    % After Conditioning
    AfterConditioningEpoch = or(a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPost1,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPost2);
    AfterConditioningEpoch = or(AfterConditioningEpoch,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPost3);
    AfterConditioningEpoch = or(AfterConditioningEpoch,a{CorrStabAfterCondCell_idx_Final{i}(1)}.SessionEpoch.TestPost4);
    
    % Locomotion threshold
    LocomotionEpoch = thresholdIntervals(tsd(Range(a{CorrStabAfterCondCell_idx_Final{i}(1)}.Vtsd),movmedian(Data(a{CorrStabAfterCondCell_idx_Final{i}(1)}.Vtsd),5)),2.5,'Direction','Above');
    % Get resulting epochs
    UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
    AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
    MovingHab1Half = and(LocomotionEpoch,Hab1Half);
    MovingHab2Half = and(LocomotionEpoch,Hab2Half);
    
    
    try
    map1 = PlaceField_DB(Restrict(b{CorrStabAfterCondCell_idx_Final{i}(1)}.S{CorrStabAfterCondCell_idx_Final{i}(2)},MovingHab1Half),...
        Restrict(a{CorrStabAfterCondCell_idx_Final{i}(1)}.CleanAlignedXtsd, MovingHab1Half),...
        Restrict(a{CorrStabAfterCondCell_idx_Final{i}(1)}.CleanAlignedYtsd, MovingHab1Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
    close gcf
    catch
        map1=[];
    end
    try
    map2 = PlaceField_DB(Restrict(b{CorrStabAfterCondCell_idx_Final{i}(1)}.S{CorrStabAfterCondCell_idx_Final{i}(2)},MovingHab2Half),...
        Restrict(a{CorrStabAfterCondCell_idx_Final{i}(1)}.CleanAlignedXtsd, MovingHab2Half),...
        Restrict(a{CorrStabAfterCondCell_idx_Final{i}(1)}.CleanAlignedYtsd, MovingHab2Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
    close gcf
    catch
        map2=[];
    end
    try
    map3 = PlaceField_DB(Restrict(b{CorrStabAfterCondCell_idx_Final{i}(1)}.S{CorrStabAfterCondCell_idx_Final{i}(2)},AfterConditioningMovingEpoch),...
        Restrict(a{CorrStabAfterCondCell_idx_Final{i}(1)}.CleanAlignedXtsd, AfterConditioningMovingEpoch),...
        Restrict(a{CorrStabAfterCondCell_idx_Final{i}(1)}.CleanAlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
    close gcf
    catch
        map3=[];
    end
    
    
    fh1 = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.67]);
%     maze = [24 15; 24 77; 85 77; 85 15; 63 15;  63 58; 46 58; 46 15; 24 15];
%     shockzone = [24 15; 24 43; 46 43; 46 15; 24 15];
    subplot(131)
    if ~isempty(map1)
    imagesc(map1.rate)
    colormap jet
    axis xy
    hold on
%     plot(maze(:,1),maze(:,2),'w','LineWidth',3)
%     plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
    set(gca,'XTickLabel',{},'YTickLabel',{});
    title('1half')
    end
    subplot(132)
    if ~isempty(map2)
    imagesc(map2.rate)
    colormap jet
    axis xy
    hold on
%     plot(maze(:,1),maze(:,2),'w','LineWidth',3)
%     plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
    set(gca,'XTickLabel',{},'YTickLabel',{});
    title('2half')
    end
     subplot(133)
     if ~isempty(map3)
    imagesc(map3.rate)
    colormap jet
    axis xy
    hold on
%     plot(maze(:,1),maze(:,2),'w','LineWidth',3)
%     plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
    set(gca,'XTickLabel',{},'YTickLabel',{});
    title('After Cond')
     end
    
    clear map1 map2 map3
end
   

    