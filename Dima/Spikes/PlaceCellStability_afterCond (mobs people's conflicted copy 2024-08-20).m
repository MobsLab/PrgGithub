%% Parameters
nmouse = [797 798 828 861 882 905 911 912 977];
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
CorrStabAfterCondCell = nan(1,100);
for j=1:length(Dir.path)
    cd(Dir.path{j}{1});
    load('SpikeData.mat','S','PlaceCells');
    load('behavResources.mat','SessionEpoch','CleanVtsd','CleanAlignedXtsd','CleanAlignedYtsd');
    
    st = Start(SessionEpoch.Hab);
    en = End(SessionEpoch.Hab);
    Hab1Half = intervalSet(st,((en-st)/2)+st);
    Hab2Half = intervalSet(((en-st)/2)+st,en);
    
    % BaselineExplo Epoch
    UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
    UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
    UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
    UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);
    
    % After Conditioning
    AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
    AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
    AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);
    
    
    % Locomotion threshold
    LocomotionEpoch = thresholdIntervals(tsd(Range(CleanVtsd),movmedian(Data(CleanVtsd),5)),2.5,'Direction','Above');
    % Get resulting epochs
    UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
    AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
    MovingHab1Half = and(LocomotionEpoch,Hab1Half);
    MovingHab2Half = and(LocomotionEpoch,Hab2Half);
    
    % Same cell stabity
    if isfield(PlaceCells,'idx')
        for i=1:length(PlaceCells.idx)
            try
                map1 = PlaceField_DB(Restrict(S{PlaceCells.idx(i)},MovingHab1Half),...
                    Restrict(CleanAlignedXtsd, MovingHab1Half),...
                    Restrict(CleanAlignedYtsd, MovingHab1Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                map2 = PlaceField_DB(Restrict(S{PlaceCells.idx(i)},MovingHab2Half),...
                    Restrict(CleanAlignedXtsd, MovingHab2Half),...
                    Restrict(CleanAlignedYtsd, MovingHab2Half), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                close all
            catch
                map1 = [];
                map2 = [];
            end
            if ~isempty(map1) && ~isempty(map2)
                s=s+1;
                de = corrcoef(map1.rate,map2.rate);
                CorrStabSameCell(s) = de(2,1);
            else
                s+1;
                CorrStabSameCell(s) = nan;
            end
        end
    end
    
    clear map1 map2
    
    % Inter-cell correlation
     if isfield(PlaceCells,'idx')
        for i=1:length(PlaceCells.idx)
            try
                map1 = PlaceField_DB(Restrict(S{PlaceCells.idx(i)},UMazeMovingEpoch),...
                    Restrict(CleanAlignedXtsd, UMazeMovingEpoch),...
                    Restrict(CleanAlignedYtsd, UMazeMovingEpoch), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                map2 = PlaceField_DB(Restrict(S{PlaceCells.idx(i)},AfterConditioningMovingEpoch),...
                    Restrict(CleanAlignedXtsd, AfterConditioningMovingEpoch),...
                    Restrict(CleanAlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', 2.5, 'size', 50, 'plotresults',0);
                close all
            catch
                map1 = [];
                map2 = [];
            end
            if ~isempty(map1) && ~isempty(map2)
                s=s+1;
                de = corrcoef(map1.rate,map2.rate);
                CorrStabAfterCondCell(s) = de(2,1);
            else
                s+1;
                CorrStabAfterCondCell(s) = nan;
            end
        end
    end
    clear S PlaceCells SessionEpoch CleanVtsd CleanAlignedXtsd CleanAlignedYtsd st en Hab1Half Hab1Half LocomotionEpoch MovingHab1Half MovingHab2Half
end
   
CorrStabSameCell = CorrStabSameCell(~isnan(CorrStabSameCell));
CorrStabAfterCondCell = CorrStabAfterCondCell(~isnan(CorrStabAfterCondCell));


%% Calculate
% Find Number Of Cells
s=0;
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).BeforeCond)
        for j = 1:length(SelectedPlaceCells(i).BeforeCond.map) % cell1
            s=s+1;
            m{s} = SelectedPlaceCells(i).BeforeCond.map{j};
        end
    end
end
numcells = length(m);

% Same cell stabity (within session)
CorrStabSameCell = nan(1,length(numcells));
s=0;
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).Hab1Half)
        for j = 1:length(SelectedPlaceCells(i).Hab1Half.map)
            s=s+1;
            if length(SelectedPlaceCells(i).Hab1Half.px{j})>NumSpikesThresh && ...
                    length(SelectedPlaceCells(i).Hab2Half.px{j})>NumSpikesThresh
                de = corrcoef(SelectedPlaceCells(i).Hab1Half.map{j}.rate,SelectedPlaceCells(i).Hab2Half.map{j}.rate);
                CorrStabSameCell(s) = de(2,1);
            else
                CorrStabSameCell(s) = nan;
            end
        end
    end
end

% After conditioning stability
CorrStabBeforeAfter = zeros(1,length(numcells));
s=0;
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).BeforeCond)
        for j = 1:length(SelectedPlaceCells(i).BeforeCond.map)
            if ~isempty(SelectedPlaceCells(i).AfterCond.map{j})
                if length(SelectedPlaceCells(i).BeforeCond.px{j})>NumSpikesThresh && ...
                        length(SelectedPlaceCells(i).AfterCond.px{j})>NumSpikesThresh
                    s = s+1;
                    de = corrcoef(SelectedPlaceCells(i).BeforeCond.map{j}.rate,SelectedPlaceCells(i).AfterCond.map{j}.rate);
                    CorrStabBeforeAfter(s) = de(2,1);
                else
                    s=s+1;
                    CorrStabBeforeAfter(s) = nan;
                end
            else
                s=s+1;
                CorrStabBeforeAfter(s) = nan;
            end
        end
    end
end

%% Plot
Pl = {CorrStabAfterCondCell; CorrStabSameCell};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,'XTickLabel',{'PreVsPost','WithinBaselineSession'})
ylim([0 0.9])
ylabel('Correlation Coef.')
title('Place cell stability after conditioning')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

saveas(fh,'/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/Stability_PrePostAllCells.fig');
saveFigure(fh,'Stability_PrePostAllCells','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/');


%% Find 95% Confidence interval
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

%% Examples
% Shockzone
fh1 = figure('units', 'normalized', 'outerposition', [0 0 0.63 0.67]);
subplot(221)
maze = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
shockzone = [10 10; 10 42; 38 42; 38 10;10 10];
imagesc(SelectedPlaceCells(1).BeforeCond.map{1}.rate)
colormap jet
colorbar
axis xy
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
set(gca,'XTickLabel',{},'YTickLabel',{});
title('Before conditioning')

subplot(222)
imagesc(SelectedPlaceCells(1).AfterCond.map{1}.rate)
colormap jet
colorbar
axis xy
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
set(gca,'XTickLabel',{},'YTickLabel',{});
title('After conditioning')

subplot(223)
maze = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
shockzone = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0]; 
a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
% BaselineExplo Epoch
UMazeEpoch = or(a.SessionEpoch.Hab,a.SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre4);
% After Conditioning
AfterConditioningEpoch = or(a.SessionEpoch.TestPost1,a.SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,a.SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,a.SessionEpoch.TestPost4);
LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
plot(Data(Restrict(a.AlignedXtsd, UMazeMovingEpoch)),Data(Restrict(a.AlignedYtsd, UMazeMovingEpoch)),...
    '.','Color',[0.8 0.8 0.8])
hold on
plot(SelectedPlaceCells(1).BeforeCond.px{1},SelectedPlaceCells(1).BeforeCond.py{1},'r.', 'MarkerSize', 12)
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([-0.1 1.1])
ylim([-0.1 1.1])

subplot(224)
plot(Data(Restrict(a.AlignedXtsd, AfterConditioningMovingEpoch)),Data(Restrict(a.AlignedYtsd, AfterConditioningMovingEpoch)),...
    '.','Color',[0.8 0.8 0.8])
hold on
plot(SelectedPlaceCells(1).AfterCond.px{1},SelectedPlaceCells(1).AfterCond.py{1},'r.', 'MarkerSize', 12)
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([-0.1 1.1])
ylim([-0.1 1.1])
clear a
mtit(fh1,[SelectedPlaceCells(1).name ' - ' SelectedPlaceCells(1).Hab2Half.idtet{1}],'yoff',0.01,'zoff',0.03,...
    'FontSize',16)

saveas(fh1,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples' ...
    '/AfterCondStab_' SelectedPlaceCells(1).name '-' SelectedPlaceCells(1).Hab2Half.idtet{1} '.fig']);
saveFigure(fh1,['AfterCondStab_' SelectedPlaceCells(1).name '-' SelectedPlaceCells(1).Hab2Half.idtet{1}],...
    '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');


%% Example 2
fh1 = figure('units', 'normalized', 'outerposition', [0 0 0.63 0.67]);
subplot(221)
maze = [24 15; 24 77; 85 77; 85 15; 63 15;  63 58; 46 58; 46 15; 24 15];
shockzone = [24 15; 24 43; 46 43; 46 15; 24 15];
imagesc(SelectedPlaceCells(2).BeforeCond.map{1}.rate)
colormap jet
axis xy
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
set(gca,'XTickLabel',{},'YTickLabel',{});
title('Before conditioning')

subplot(222)
imagesc(SelectedPlaceCells(1).AfterCond.map{1}.rate)
colormap jet
axis xy
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
set(gca,'XTickLabel',{},'YTickLabel',{});
title('After conditioning')

subplot(223)
mazeSpikes = [0 0; 0 1; 1 1; 1 0; 0.63 0; 0.63 0.75; 0.34 0.75; 0.34 0; 0 0];
shockZoneSpikes = [0 0; 0 0.4; 0.34 0.4; 0.34 0; 0 0]; 
a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/behavResources.mat',...
    'CleanAlignedXtsd','CleanAlignedYtsd','SessionEpoch','CleanVtsd');
% BaselineExplo Epoch
UMazeEpoch = or(a.SessionEpoch.Hab,a.SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre4);
LocomotionEpoch = thresholdIntervals(tsd(Range(a.CleanVtsd),movmedian(Data(a.CleanVtsd),5)),3,...
    'Direction','Above');
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
plot(Data(Restrict(a.CleanAlignedXtsd, UMazeMovingEpoch)),Data(Restrict(a.CleanAlignedYtsd, UMazeMovingEpoch)),...
    '.','Color',[0.8 0.8 0.8])
hold on
plot(SelectedPlaceCells(2).BeforeCond.px{1},SelectedPlaceCells(2).BeforeCond.py{1},'r.', 'MarkerSize', 12)
plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([0 1])
ylim([0 1])

subplot(224)
plot(Data(Restrict(a.AlignedXtsd, AfterConditioningMovingEpoch)),Data(Restrict(a.AlignedYtsd, AfterConditioningMovingEpoch)),...
    '.','Color',[0.8 0.8 0.8])
hold on
plot(SelectedPlaceCells(1).AfterCond.px{1},SelectedPlaceCells(1).AfterCond.py{1},'r.', 'MarkerSize', 12)
plot(maze(:,1),maze(:,2),'k','LineWidth',3)
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([-0.1 1.1])
ylim([-0.1 1.1])
clear a
mtit(fh1,[SelectedPlaceCells(1).name ' - ' SelectedPlaceCells(1).Hab2Half.idtet{1}],'yoff',0.01,'zoff',0.03,...
    'FontSize',16)

saveas(fh1,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples' ...
    '/AfterCondStab_' SelectedPlaceCells(1).name '-' SelectedPlaceCells(1).Hab2Half.idtet{1} '.fig']);
saveFigure(fh1,['AfterCondStab_' SelectedPlaceCells(1).name '-' SelectedPlaceCells(1).Hab2Half.idtet{1}],...
    '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');