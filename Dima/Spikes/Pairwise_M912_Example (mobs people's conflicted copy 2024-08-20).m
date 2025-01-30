

%% Parameters
placecells = [56 58 61 62 63];
cells = [1:76];
cells(placecells)=[];
overlap = {{1,2},{1,3},{1,4},{1,5},{2,3},{2,4},{2,5},{3,5},{4,5}};

%% Load Data
cd('/media/mobsrick/DataMOBS101/Mouse-912/20190515/PAGexp/_Concatenated/');
load('SpikeData.mat');
load('behavResources.mat');
load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch','Sleep');

%% Epochs

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
VtsdSmoothed  = tsd(Range(Vtsd),movmedian(Data(Vtsd),5));
LocomotionEpoch = thresholdIntervals(VtsdSmoothed,3,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);

%% All chaa

%% Plot individually
for i=2:length(overlap)
    yl = [0 3];
    temp = overlap{i};
    cell1 = placecells(temp{1});
    cell2 = placecells(temp{2});
    [map1,mapS1,stats1] = PlaceField(Restrict(S{cell1},UMazeMovingEpoch), Restrict(Xtsd, UMazeMovingEpoch),...
        Restrict(Ytsd, UMazeMovingEpoch), 'smoothing', 2.5, 'size', 75, 'plotresults',0);
    [map2,mapS2,stats2] = PlaceField(Restrict(S{cell2},UMazeMovingEpoch), Restrict(Xtsd, UMazeMovingEpoch),...
        Restrict(Ytsd, UMazeMovingEpoch), 'smoothing', 2.5, 'size', 75, 'plotresults',0);
    
    [C_PreSleep,B]=CrossCorr(Range(Restrict(S{cell1},and(SessionEpoch.PreSleep, SWSEpoch))),...
        Range(Restrict(S{cell2},and(SessionEpoch.PreSleep, SWSEpoch))),10,160);
    [C_PreTest,B]=CrossCorr(Range(Restrict(S{cell1},UMazeMovingEpoch)),...
        Range(Restrict(S{cell2},UMazeMovingEpoch)),10,160);
    [C_PostSleep,B]=CrossCorr(Range(Restrict(S{cell1},and(SessionEpoch.PostSleep,SWSEpoch))),...
        Range(Restrict(S{cell2},and(SessionEpoch.PostSleep,SWSEpoch))),10,160);
    [C_PostTest,B]=CrossCorr(Range(Restrict(S{cell1},AfterConditioningMovingEpoch)),...
        Range(Restrict(S{cell2},AfterConditioningMovingEpoch)),10,160);
    
    maze = [15 10; 43 10; 43 62; 60 62; 60 10; 85 10; 85 85; 15 85; 15 10];
    shockzone = [60 40; 60 10; 85 10; 85 40; 60 40];
    fh = figure('units', 'normalized', 'outerposition', [0 0 1 0.7]);
    subplot(3,4,[1:2 5:6])
    imagesc(map1.rate)
    colormap jet
    title(['Spatial Info: ' num2str(stats1.spatialInfo)]);
    axis xy
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca, 'LineWidth', 3);
    set(gca,'XtickLabel',{},'YTickLabel',{});
    hold on
    plot(maze(:,1),maze(:,2),'w','LineWidth',3)
    hold on
    plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
    subplot(3,4,[3:4 7:8])
    imagesc(map2.rate)
    title(['Spatial Info: ' num2str(stats2.spatialInfo)]);
    colormap jet
    axis xy
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca, 'LineWidth', 3);
    set(gca,'XtickLabel',{},'YTickLabel',{});
    hold on
    plot(maze(:,1),maze(:,2),'w','LineWidth',3)
    hold on
    plot(shockzone(:,1),shockzone(:,2),'r','LineWidth',3)
    subplot(3,4,9)
    bar(B, runmean(C_PreSleep,3),'k')
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca, 'LineWidth', 3);
    xlabel('Time (ms)')
    ylim(yl)
    title('PreSleep')
    subplot(3,4,10)
    bar(B, runmean(C_PreTest,3),'k')
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca, 'LineWidth', 3);
    xlabel('Time (ms)')
    ylim(yl)
    title('PreExploration')
    subplot(3,4,11)
    bar(B, runmean(C_PostSleep,3),'k')
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca, 'LineWidth', 3);
    xlabel('Time (ms)')
    ylim(yl)
    title('PostSleep')
    subplot(3,4,12)
    bar(B, runmean(C_PostTest,3),'k')
    set(gca, 'FontSize', 14, 'FontWeight',  'bold');
    set(gca, 'LineWidth', 3);
    xlabel('Time (ms)')
    ylim(yl)
    title('PostTests')
   
    saveas(gcf,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_InProgress/Mouse912/CrossCorr/' cellnames{cell1} 'vs' cellnames{cell2} '.fig']);
    saveFigure(gcf,[cellnames{cell1} 'vs' cellnames{cell2}], '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_InProgress/Mouse912/CrossCorr/');
end

clear C B

%% Calculate

% PreSleep
for i=1:length(overlap)
    temp = overlap{i};
    cell1 = placecells(temp{1});
    cell2 = placecells(temp{2});
    [C{i},B{i}]=CrossCorr(Range(Restrict(S{cell1},and(SessionEpoch.PreSleep,SWSEpoch))),...
        Range(Restrict(S{cell2},and(SessionEpoch.PreSleep,SWSEpoch))),10,160);
end

figure
s = 0;
for i=1:length(overlap)
    s=s+1;
    subplot(3,3,s)
    bar(B{i}, runmean(C{i},3),'k')
%     bar(B{i}, C{i},'k')
    title([num2str(placecells(overlap{i}{1})) ' vs ' num2str(placecells(overlap{i}{2}))])
end
mtit(gcf,'PreSleep','yoff',0.001, 'zoff', 0.03)


% Run
for i=1:length(overlap)
    temp = overlap{i};
    cell1 = placecells(temp{1});
    cell2 = placecells(temp{2});
    [C{i},B{i}]=CrossCorr(Range(Restrict(S{cell1},UMazeMovingEpoch)),...
        Range(Restrict(S{cell2},UMazeMovingEpoch)),10,160);
end

figure
s = 0;
for i=1:length(overlap)
    s=s+1;
    subplot(3,3,s)
    bar(B{i}, runmean(C{i},3),'k')
%     bar(B{i}, C{i},'k')
    title([num2str(placecells(overlap{i}{1})) ' vs ' num2str(placecells(overlap{i}{2}))])
end
mtit(gcf,'Run','yoff',0.001, 'zoff', 0.03)


% PostSleep
for i=1:length(overlap)
    temp = overlap{i};
    cell1 = placecells(temp{1});
    cell2 = placecells(temp{2});
    [C{i},B{i}]=CrossCorr(Range(Restrict(S{cell1},and(SessionEpoch.PostSleep,SWSEpoch))),...
        Range(Restrict(S{cell2},and(SessionEpoch.PostSleep,SWSEpoch))),10,160);
end

figure
s = 0;
for i=1:length(overlap)
    s=s+1;
    subplot(3,3,s)
    bar(B{i}, runmean(C{i},3),'k')
%     bar(B{i}, C{i},'k')
    title([num2str(placecells(overlap{i}{1})) ' vs ' num2str(placecells(overlap{i}{2}))])
end
mtit(gcf,'PostSleep','yoff',0.001, 'zoff', 0.03)



% PostTest
for i=1:length(overlap)
    temp = overlap{i};
    cell1 = placecells(temp{1});
    cell2 = placecells(temp{2});
    [C{i},B{i}]=CrossCorr(Range(Restrict(S{cell1},AfterConditioningMovingEpoch)),...
        Range(Restrict(S{cell2},AfterConditioningMovingEpoch)),10,160);
end

figure
s = 0;
for i=1:length(overlap)
    s=s+1;
    subplot(3,3,s)
    bar(B{i}, runmean(C{i},3),'k')
%     bar(B{i}, C{i},'k')
    title([num2str(placecells(overlap{i}{1})) ' vs ' num2str(placecells(overlap{i}{2}))])
end
mtit(gcf,'PostTests','yoff',0.001, 'zoff', 0.03)

clear C B

%% Calculate mean

for i=1:length(placecells)
    S1{i} = S{placecells(i)};
end
S1 = tsdArray(S1);


% Q=MakeQfromS(S1,1000);
Q=MakeQfromS(S,1000);

QPRE=zscore(full(Data(Restrict(Q,SessionEpoch.PreSleep))));
QTASK=zscore(full(Data(Restrict(Q,UMazeEpoch))));
QPOST=zscore(full(Data(Restrict(Q,SessionEpoch.PostSleep))));
QPOSTTEST=zscore(full(Data(Restrict(Q,AfterConditioningMovingEpoch))));


for i=1:length(S1)
% for i=1:length(S)
    for j=i+1:length(S1)
%     for j=i+1:length(S)
        [r,p]=corrcoef(QPRE(:,i),QPRE(:,j));
        RPRE(i,j)=r(2,1);
        PPRE(i,j)=p(2,1);
        
        [r,p]=corrcoef(QTASK(:,i),QTASK(:,j));
        RTASK(i,j)=r(2,1);
        PTASK(i,j)=p(2,1);
        
        [r,p]=corrcoef(QPOST(:,i),QPOST(:,j));
        RPOST(i,j)=r(2,1);
        PPOST(i,j)=p(2,1);
        
        [r,p]=corrcoef(QPOSTTEST(:,i),QPOSTTEST(:,j));
        RPOSTTEST(i,j)=r(2,1);
        PPOSTTEST(i,j)=p(2,1);
    end
end

ca=0.1;
figure, 
subplot(2,4,1),imagesc(RPRE), caxis([-ca ca])
subplot(2,4,2),imagesc(RTASK), caxis([-ca ca])
subplot(2,4,3),imagesc(RPOST), caxis([-ca ca])
subplot(2,4,4),imagesc(RPOSTTEST), caxis([-ca ca])

subplot(2,4,5),imagesc(RPRE), caxis([ca-0.05 ca])
subplot(2,4,6),imagesc(RTASK), caxis([ca-0.05  ca])
subplot(2,4,7),imagesc(RPOST), caxis([ca-0.05  ca])
subplot(2,4,8),imagesc(RPOSTTEST), caxis([ca-0.05  ca])

C_PreSleep = nonzeros(RPRE);
C_PreTest = nonzeros(RTASK);
C_PostSleep = nonzeros(RPOST);
C_PostTest = nonzeros(RPOSTTEST);


PlotErrorBarN_DB([C_PreSleep C_PreTest C_PostSleep C_PostTest],'showpoints',0)








% %%
% % PreSleep
% for i=2:length(overlap)
%     temp = overlap{i};
%     cell1 = placecells(temp{1});
%     cell2 = placecells(temp{2});
%     [CC(1:201,i),B]=CrossCorr(Range(Restrict(S{cell1},SessionEpoch.PreSleep)),...
%         Range(Restrict(S{cell2},SessionEpoch.PreSleep)),1,200);
% end
% C_PreSleep = mean(CC);
% 
% 
% % Run
% for i=2:length(overlap)
%     temp = overlap{i};
%     cell1 = placecells(temp{1});
%     cell2 = placecells(temp{2});
%     [CC(1:201,i),B]=CrossCorr(Range(Restrict(S{cell1},UMazeMovingEpoch)),...
%         Range(Restrict(S{cell2},UMazeMovingEpoch)),1,200);
% end
% C_PreTest = mean(CC);
% 
% % PostSleep
% for i=2:length(overlap)
%     temp = overlap{i};
%     cell1 = placecells(temp{1});
%     cell2 = placecells(temp{2});
%     [CC(1:201,i),B]=CrossCorr(Range(Restrict(S{cell1},SessionEpoch.PostSleep)),...
%         Range(Restrict(S{cell2},SessionEpoch.PostSleep)),1,200);
% end
% C_PostSleep = mean(CC);
%  
%  % PostTests
% for i=2:length(overlap)
%     temp = overlap{i};
%     cell1 = placecells(temp{1});
%     cell2 = placecells(temp{2});
%     [CC(1:201,i),B]=CrossCorr(Range(Restrict(S{cell1},AfterConditioningMovingEpoch)),...
%         Range(Restrict(S{cell2},AfterConditioningMovingEpoch)),1,200);
% end
% C_PostTest = mean(CC);
% 
% PlotErrorBarN_DB([C_PreSleep' C_PreTest' C_PostSleep' C_PostTest'],'showpoints',0)
%     
