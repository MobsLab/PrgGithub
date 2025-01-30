
%% Parameters
nmouse = [912];
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);

overlapFactor = 0;

sav = 0;

%% Load Data
cd(Dir.path{1}{1});
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

%% Calculate

% Get the stats for each cell
for i=1:length(S)
    try
        [map{i},mapS,stats{i},px,py,FR(i),sizeFinal,PrField{i},C,ScField,pfH,pf] = PlaceField(Restrict(S{i},UMazeMovingEpoch),...
            Restrict(Xtsd, UMazeMovingEpoch), Restrict(Ytsd, UMazeMovingEpoch), 'smoothing', 2.5, 'size', 75,...
            'plotresults',0);
    catch
        map{i} = [];
        stats{i}=[];
        PrField{i}=[];
    end
end

% Find place cells
placecells = [];
for i=1:length(S)
    if FR(i)>0.4
        if stats{i}.spatialInfo>0.9
            placecells = [placecells i];
        end
    elseif FR(i)>0.2
        if stats{i}.spatialInfo>1.1
          placecells = [placecells i];  
        end
    end
end

% FindOverlappingPlaceCells
o = 1;
n = 1;
for i=1:length(placecells)
    for j = i+1:length(placecells)
        cell1 = placecells(i);
        cell2 = placecells(j);
        OverlappedFields = stats{cell1}.field & stats{cell2}.field;
        numOverlap(i,j) = nnz(OverlappedFields);
        if numOverlap(i,j) > overlapFactor
            overlappairs{o} = [cell1, cell2];
            o=o+1;
        else
            distantpairs{n} = [cell1, cell2];
            n=n+1;
        end   
    end
end

% Calculate crosscorrelations for overlapped and non-ovelapped cells
Q=MakeQfromS(S,1000);
QPRE=zscore(full(Data(Restrict(Q,SessionEpoch.PreSleep))));
% QPRE=full(Data(Restrict(Q,SessionEpoch.PreSleep)));
QTASK=zscore(full(Data(Restrict(Q,UMazeEpoch))));
% QTASK=full(Data(Restrict(Q,UMazeEpoch)));
QPOST=zscore(full(Data(Restrict(Q,SessionEpoch.PostSleep))));
% QPOST=full(Data(Restrict(Q,SessionEpoch.PostSleep)));
QPOSTTEST=zscore(full(Data(Restrict(Q,AfterConditioningMovingEpoch))));
% QPOSTTEST=full(Data(Restrict(Q,AfterConditioningMovingEpoch)));

% Overlapped
for i=1:length(overlappairs)
    pair = overlappairs{i};
    [r,p]=corrcoef(QPRE(:,pair(1)),QPRE(:,pair(2)));
    RPRE_O(i)=r(2,1);
    PPRE_O(i)=p(2,1);
    
    [r,p]=corrcoef(QTASK(:,pair(1)),QTASK(:,pair(2)));
    RTASK_O(i)=r(2,1);
    PTASK_O(i)=p(2,1);
    
    [r,p]=corrcoef(QPOST(:,pair(1)),QPOST(:,pair(2)));
    RPOST_O(i)=r(2,1);
    PPOST_O(i)=p(2,1);
    
    [r,p]=corrcoef(QPOSTTEST(:,pair(1)),QPOSTTEST(:,pair(2)));
    RPOSTTEST_O(i)=r(2,1);
    PPOSTTEST_O(i)=p(2,1);
end

% Non-Overlapped
for i=1:length(distantpairs)
    pair = distantpairs{i};
    [r,p]=corrcoef(QPRE(:,pair(1)),QPRE(:,pair(2)));
    RPRE_D(i)=r(2,1);
    PPRE_D(i)=p(2,1);
    
    [r,p]=corrcoef(QTASK(:,pair(1)),QTASK(:,pair(2)));
    RTASK_D(i)=r(2,1);
    PTASK_D(i)=p(2,1);
    
    [r,p]=corrcoef(QPOST(:,pair(1)),QPOST(:,pair(2)));
    RPOST_D(i)=r(2,1);
    PPOST_D(i)=p(2,1);
    
    [r,p]=corrcoef(QPOSTTEST(:,pair(1)),QPOSTTEST(:,pair(2)));
    RPOSTTEST_D(i)=r(2,1);
    PPOSTTEST_D(i)=p(2,1);
end

%% Do the right thing

% Overlapped
for i=1:length(overlappairs)
    pair = overlappairs{i};
    [C_PreSleep,B]=CrossCorr(Range(Restrict(S{pair(1)},and(SessionEpoch.PreSleep, SWSEpoch))),...
        Range(Restrict(S{pair(2)},and(SessionEpoch.PreSleep, SWSEpoch))),1,200);
    C_PreSleep_O(i) = mean(C_PreSleep);
%     C_PreSleep_O(i) = mean(abs(zscore(runmean(C_PreSleep,3))));
    
    
    [C_Task,B]=CrossCorr(Range(Restrict(S{pair(1)},UMazeEpoch)),...
        Range(Restrict(S{pair(2)},UMazeEpoch)),1,200);
    C_Task_O(i) = mean(C_Task);
%     C_Task_O(i) = mean(abs(zscore(runmean(C_Task,3))));
    
    [C_PostSleep,B]=CrossCorr(Range(Restrict(S{pair(1)},and(SessionEpoch.PostSleep, SWSEpoch))),...
        Range(Restrict(S{pair(2)},and(SessionEpoch.PostSleep, SWSEpoch))),1,200);
    C_PostSleep_O(i) = mean(C_PostSleep);
%     C_PostSleep_O(i) = mean(abs(zscore(runmean(C_PostSleep,3))));
    
    [C_PostTest,B]=CrossCorr(Range(Restrict(S{pair(1)},AfterConditioningMovingEpoch)),...
        Range(Restrict(S{pair(2)},AfterConditioningMovingEpoch)),1,200);
    C_PostTest_O(i) = mean(C_PostTest);
%     C_PostTest_O(i) = mean(abs(zscore(runmean(C_PostTest,3))));
   
end

% Non-Overlapped
for i=1:length(distantpairs)
    pair = distantpairs{i};
    [C_PreSleep,B]=CrossCorr(Range(Restrict(S{pair(1)},and(SessionEpoch.PreSleep, SWSEpoch))),...
        Range(Restrict(S{pair(2)},and(SessionEpoch.PreSleep, SWSEpoch))),1,200);
        C_PreSleep_D(i) = mean(C_PreSleep);
%     C_PreSleep_D(i) = mean(abs(zscore(runmean(C_PreSleep,3))));
    
    
    [C_Task,B]=CrossCorr(Range(Restrict(S{pair(1)},UMazeEpoch)),...
        Range(Restrict(S{pair(2)},UMazeEpoch)),1,200);
    C_Task_D(i) = mean(C_Task);
%     C_Task_D(i) = mean(abs(zscore(runmean(C_Task,3))));
    
    [C_PostSleep,B]=CrossCorr(Range(Restrict(S{pair(1)},and(SessionEpoch.PostSleep, SWSEpoch))),...
        Range(Restrict(S{pair(2)},and(SessionEpoch.PostSleep, SWSEpoch))),1,200);
    C_PostSleep_D(i) = mean(C_PostSleep);
%     C_PostSleep_D(i) = mean(abs(zscore(runmean(C_PostSleep,3))));
    
    [C_PostTest,B]=CrossCorr(Range(Restrict(S{pair(1)},AfterConditioningMovingEpoch)),...
        Range(Restrict(S{pair(2)},AfterConditioningMovingEpoch)),1,200);
    C_PostTest_D(i) = mean(C_PostTest);
%     C_PostTest_D(i) = mean(abs(zscore(runmean(C_PostTest,3))));
end

%%

% Average
RPRE_O_Mean = mean(RPRE_O);
RPRE_O_std = std(RPRE_O);
RPRE_D_Mean = mean(RPRE_D);
RPRE_D_std = std(RPRE_D);
RPRE_OD_Mean = [RPRE_O_Mean RPRE_D_Mean];
RPRE_OD_std = [RPRE_O_std RPRE_D_std];

RTASK_O_Mean = mean(RTASK_O);
RTASK_O_std = std(RTASK_O);
RTASK_D_Mean = mean(RTASK_D);
RTASK_D_std = std(RTASK_D);
RTASK_OD_Mean = [RTASK_O_Mean RTASK_D_Mean];
RTASK_OD_std = [RTASK_O_std RTASK_D_std];

RPOST_O_Mean = mean(RPOST_O);
RPOST_O_std = std(RPOST_O);
RPOST_D_Mean = mean(RPOST_D);
RPOST_D_std = std(RPOST_D);
RPOST_OD_Mean = [RPOST_O_Mean RPOST_D_Mean];
RPOST_OD_std = [RPOST_O_std RPOST_D_std];

RPOSTTEST_O_Mean = mean(RPOSTTEST_O);
RPOSTTEST_O_std = std(RPOSTTEST_O);
RPOSTTEST_D_Mean = mean(RPOSTTEST_D);
RPOSTTEST_D_std = std(RPOSTTEST_D);
RPOSTTEST_OD_Mean = [RPOSTTEST_O_Mean RPOSTTEST_D_Mean];
RPOSTTEST_OD_std = [RPOSTTEST_O_std RPOSTTEST_D_std];

%% Do the right thing
CPRE_O_Mean = mean(C_PreSleep_O);
CPRE_O_std = std(C_PreSleep_O);
CPRE_D_Mean = mean(C_PreSleep_D);
CPRE_D_std = std(C_PreSleep_D);
CPRE_OD_Mean = [CPRE_O_Mean CPRE_O_Mean];
CPRE_OD_std = [CPRE_O_std CPRE_D_std];

CTASK_O_Mean = mean(C_Task_O);
CTASK_O_std = std(C_Task_O);
CTASK_D_Mean = mean(C_Task_D);
CTASK_D_std = std(C_Task_D);
CTASK_OD_Mean = [CTASK_O_Mean CTASK_D_Mean];
CTASK_OD_std = [CTASK_O_std CTASK_D_std];

CPOST_O_Mean = mean(C_PostSleep_O);
CPOST_O_std = std(C_PostSleep_O);
CPOST_D_Mean = mean(C_PostSleep_D);
CPOST_D_std = std(C_PostSleep_D);
CPOST_OD_Mean = [CPOST_O_Mean CPOST_D_Mean];
CPOST_OD_std = [CPOST_O_std CPOST_D_std];

CPOSTTEST_O_Mean = mean(C_PostTest_O);
CPOSTTEST_O_std = std(C_PostTest_O);
CPOSTTEST_D_Mean = mean(C_PostTest_D);
CPOSTTEST_D_std = std(C_PostTest_D);
CPOSTTEST_OD_Mean = [CPOSTTEST_O_Mean CPOSTTEST_D_Mean];
CPOSTTEST_OD_std = [CPOSTTEST_O_std CPOSTTEST_D_std];

%% Plot

fh = figure('units', 'normalized', 'outerposition', [0 0 0.7 0.7]);
b = barwitherr([RPRE_OD_std;RTASK_OD_std;RPOST_OD_std;RPOSTTEST_OD_std], [RPRE_OD_Mean;RTASK_OD_Mean;RPOST_OD_Mean;RPOSTTEST_OD_Mean]);
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
b(1).BarWidth = 0.8;
b(1).FaceColor = 'w';
b(2).FaceColor = 'k';
b(1).LineWidth = 3;
b(2).LineWidth = 3;
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
set(gca,'Xtick',[1:4],'XtickLabel',{'PreSleep', 'PreExplorations', 'PostSleep', 'PostTests'})
ylabel('Cross-Corellation')
hold off
box off
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
% title 
lg = legend('Overlapping PCs', 'Non-overlapping PCs');
lg.FontSize = 14;

% if sav
%     saveas(gcf,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_InProgress/Mouse912/' ...
%         'CrossCorr/MeanCross.fig']);
%     saveFigure(gcf,'MeanCross',...
%         '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_InProgress/Mouse912/CrossCorr/');
% end

%% Plot the right thing

fh = figure('units', 'normalized', 'outerposition', [0 0 0.7 0.7]);
b = barwitherr([CPRE_OD_std;CTASK_OD_std;CPOST_OD_std;CPOSTTEST_OD_std], [CPRE_OD_Mean;CTASK_OD_Mean;CPOST_OD_Mean;CPOSTTEST_OD_Mean]);
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
b(1).BarWidth = 0.8;
b(1).FaceColor = 'w';
b(2).FaceColor = 'k';
b(1).LineWidth = 3;
b(2).LineWidth = 3;
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
set(gca,'Xtick',[1:4],'XtickLabel',{'PreSleep', 'PreExplorations', 'PostSleep', 'PostTests'})
ylabel('Cross-Corellation')
hold off
box off
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
% title 
lg = legend('Overlapping PCs', 'Non-overlapping PCs');
lg.FontSize = 14;

% if sav
%     saveas(gcf,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_InProgress/Mouse912/' ...
%         'CrossCorr/MeanCross.fig']);
%     saveFigure(gcf,'MeanCross',...
%         '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_InProgress/Mouse912/CrossCorr/');
% end