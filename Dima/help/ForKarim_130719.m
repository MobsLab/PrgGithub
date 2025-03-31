cd('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')
load('Ripples.mat')

% PosMatInit
InitX = tsd(Range(Xtsd),PosMatInit(:,2));
InitY = tsd(Range(Ytsd),PosMatInit(:,3));

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),5,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);

[mapBase,mapS,statsBase,pxBase,pyBase,FR,sizeFinal,PrFieldBase,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{18},UMazeMovingEpoch), Restrict(Xtsd, UMazeMovingEpoch), Restrict(Ytsd, UMazeMovingEpoch), 'smoothing', 2.5, 'size', 75, 'plotresults',0);

% Conditioning
ConditioningEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond3);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond4);

ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);

[mapCond,mapS,statsCond,pxCond,pyCond,FR,sizeFinal,PrFieldCond,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{18},ConditioningEpoch), Restrict(Xtsd, ConditioningEpoch), Restrict(Ytsd, ConditioningEpoch), 'smoothing', 2.5, 'size', 75, 'plotresults',0);
[mapCondF,mapS,statsCondF,pxCondF,pyCondF,FR,sizeFinal,PrFieldCondF,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{18},and(ConditioningEpoch,FreezeAccEpoch)), Restrict(Xtsd, and(ConditioningEpoch,FreezeAccEpoch)), Restrict(Ytsd, and(ConditioningEpoch,FreezeAccEpoch)), 'smoothing', 2.5, 'size', 75, 'plotresults',0);
[mapCondM,mapS,statsCondM,pxCondM,pyCondM,FR,sizeFinal,PrFieldCondM,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{18},ConditioningMovingEpoch), Restrict(Xtsd, ConditioningMovingEpoch), Restrict(Ytsd, ConditioningMovingEpoch), 'smoothing', 2.5, 'size', 75, 'plotresults',0);


% Ripples
[mapRipples,mapS,statsRipples,pxRipples,pyRipples,FR,sizeFinal,PrFieldRipples,C,ScField,pfH,pf]=PlaceField_DB(Restrict(ts(ripples(:,2)*1e4),ConditioningEpoch), Restrict(Xtsd, and(ConditioningEpoch,FreezeAccEpoch)), Restrict(Ytsd, and(ConditioningEpoch,FreezeAccEpoch)), 'smoothing', 2.5, 'size', 75, 'plotresults',0);

[mapRipples,mapS,statsRipples,px,py,FR,sizeFinal,PrFieldRipples,C,ScField,pfH,pf]=PlaceField_DB(Restrict(ts(ripples(:,2)*1e4),ConditioningEpoch), Restrict(Xtsd, ConditioningEpoch), Restrict(Ytsd, ConditioningEpoch), 'smoothing', 1, 'size', 75, 'plotresults',1);


%% Plot

fh =  figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);

maze = [10 82; 88 82; 88 55; 33 55; 33 35; 88 35; 88 8; 10 8; 10 82];
shockzone = [88 82; 88 55; 56 55; 56 82; 88 82];
% xmaze = maze(:,1)*93;
% ymaze = maze(:,2)*93;
% 
% BW = poly2mask(xmaze, ymaze, 93,93);
% BW = double(BW);
% BW(find(BW==0))=Inf;


subplot(1,2,1)
imagesc(mapBase.rate)
colormap jet
title('PreExplorations - Rate map');
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
hold on
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
caxis([3 16])

subplot(1,2,2)
imagesc(mapCondF.rate)
colormap jet
title('Conditioning - Rate Map during Freezing');
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
hold on
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
hold on, plot(pxRipples,pyRipples,'r.')

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/M906_Cond_Base.fig');
saveFigure(fh,'M906_Cond_Base','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');


fh1 =  figure('units', 'normalized', 'outerposition', [0 0 0.4 0.6]);
imagesc(mapRipples.rate)
colormap jet
title('Conditioning - Ripples during Freezing');
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
hold on
plot(maze(:,1),maze(:,2),'w','LineWidth',3)
hold on
plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
saveas(fh1, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/M906_Cond_Ripples.fig');
saveFigure(fh1,'M906_Cond_Ripples','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');


%% Figure with trajectories

fh =  figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);

maze = [10 82; 88 82; 88 55; 33 55; 33 35; 88 35; 88 8; 10 8; 10 82];
shockzone = [88 82; 88 55; 56 55; 56 82; 88 82];
% xmaze = maze(:,1)*93;
% ymaze = maze(:,2)*93;
% 
% BW = poly2mask(xmaze, ymaze, 93,93);
% BW = double(BW);
% BW(find(BW==0))=Inf;


subplot(1,2,1)
plot(Data(Restrict(InitY, UMazeMovingEpoch)),Data(Restrict(InitX, UMazeMovingEpoch)), '.','Color',[0.8 0.8 0.8])
hold on, plot(pxBase,pyBase,'r.', 'MarkerSize', 10)
title('PreExplorations');
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([min(Data(InitY))-0.3 max(Data(InitY))+0.3])
ylim([min(Data(InitX))-0.3 max(Data(InitX))+0.3])
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% hold on
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% caxis([3 16])

subplot(1,2,2)
plot(Data(Restrict(InitY, ConditioningEpoch)),Data(Restrict(InitX, ConditioningEpoch)),'.','Color',[0.8 0.8 0.8])
hold on, plot(pxRipples,pyRipples,'b.', 'MarkerSize', 10)
hold on, plot(pxCondF,pyCondF,'r.', 'MarkerSize', 10)
title('Conditioning');
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([min(Data(InitY))-0.3 max(Data(InitY))+0.3])
ylim([min(Data(InitX))-0.3 max(Data(InitX))+0.3])
% hold on
% plot(maze(:,1),maze(:,2),'w','LineWidth',3)
% hold on
% plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
% hold on, plot(pxRipples,pyRipples,'r.')

fh3 = figure('units', 'normalized', 'outerposition', [0 0 0.6 0.6]);
plot(Data(Restrict(InitY, ConditioningEpoch)),Data(Restrict(InitX, ConditioningEpoch)),'.','Color',[0.8 0.8 0.8])
hold on, plot(pxCondM,pyCondM,'r.', 'MarkerSize', 10)
title('Conditioning');
axis xy
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
set(gca,'XtickLabel',{},'YTickLabel',{});
xlim([min(Data(InitY))-0.3 max(Data(InitY))+0.3])
ylim([min(Data(InitX))-0.3 max(Data(InitX))+0.3])

saveas(fh3, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/M906_Cond_Mov2.fig');
saveFigure(fh3,'M906_Cond_Mov2','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');