
%% Parameters
nmouse = [797 798 828 861 882 905 906 911 912 977];
% nmouse = [906 912]; % Had PreMazes
% nmouse = [905 911]; % Did not have PreMazes
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);

overlapFactor = 0;

sav = 0;

%% Load the data
for j=1:length(Dir.path)
    cd(Dir.path{j}{1});
    load('SpikeData.mat','S','PlaceCells');
    load('behavResources.mat','SessionEpoch','CleanVtsd','CleanAlignedXtsd','CleanAlignedYtsd');
    if j == 7 || j==10 %%%% Mouse906 Mouse977
        load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Sleep');
    else
        load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch','Sleep');
    end
    
    
    %% Epochs
    
    PreSleepSWS10{j} = SplitIntervals(and(SessionEpoch.PreSleep, SWSEpoch),...
        10*60*1e4);
    PostSleepSWS10{j} = SplitIntervals(and(SessionEpoch.PostSleep, SWSEpoch),...
        10*60*1e4);
    
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
    VtsdSmoothed  = tsd(Range(CleanVtsd),movmedian(Data(CleanVtsd),5));
    LocomotionEpoch = thresholdIntervals(VtsdSmoothed,3,'Direction','Above');
    
    % Get resulting epoch
    UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
    AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
    
    
    %% Bin the trains
    % Calculate crosscorrelations for overlapped and non-ovelapped cells
    Q=MakeQfromS(S,2000); % = 100ms
    QPRESWS{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PreSleep,SWSEpoch)))));
    for i=1:4
        QPRESWS10{j}{i} = zscore(full(Data(Restrict(Q,PreSleepSWS10{j}{i}))));
    end
    QPREREM{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PreSleep,REMEpoch)))));
    QPRE{j}=zscore(full(Data(Restrict(Q,SessionEpoch.PreSleep))));
    % QPRE{j}=full(Data(Restrict(Q,SessionEpoch.PreSleep)));
    QTASK{j}=zscore(full(Data(Restrict(Q,UMazeEpoch))));
    % QTASK{j}=full(Data(Restrict(Q,UMazeEpoch)));
    %     QPOST{j}=zscore(full(Data(Restrict(Q,SessionEpoch.PostSleep))));
    QPOSTSWS{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PostSleep,SWSEpoch)))));
    for i=1:4
        QPOSTSWS10{j}{i} = zscore(full(Data(Restrict(Q,PostSleepSWS10{j}{i}))));
    end
    QPOSTREM{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PostSleep,REMEpoch)))));
    QPOST{j}=full(Data(Restrict(Q,SessionEpoch.PostSleep)));
    QPOSTTEST{j}=zscore(full(Data(Restrict(Q,AfterConditioningMovingEpoch))));
    % QPOSTTEST{j}=full(Data(Restrict(Q,AfterConditioningMovingEpoch)));
    
    %% Calculate the correlation maps and coefficients
    CorrM{j}.Pre = corr(QPRE{j});
    CorrM{j}.Task = corr(QTASK{j});
    CorrM{j}.Task1 = CorrM{j}.Task;
    CorrM{j}.Task2 = CorrM{j}.Task;
    CorrM{j}.Post = corr(QPOST{j});
    CorrM{j}.PostTest = corr(QPOSTTEST{j});
    CorrM{j}.PostTest1 = CorrM{j}.PostTest;
    CorrM{j}.PostTest2 = CorrM{j}.PostTest;
    CorrM{j}.PreSWS = corr(QPRESWS{j});
    CorrM{j}.PreREM = corr(QPREREM{j});
    for i=1:4
        CorrM{j}.PreSWS10{i}=corr(QPRESWS10{j}{i});
    end
    CorrM{j}.PostSWS = corr(QPOSTSWS{j});
    for i=1:4
        CorrM{j}.PostSWS10{i}=corr(QPOSTSWS10{j}{i});
    end
    CorrM{j}.PostREM = corr(QPOSTREM{j});
    
    % Check if the number of neurons is the same across all states
    idx_nonexist_Pre = find(isnan(CorrM{j}.Pre(:,1)));
    idx_nonexist_Task = find(isnan(CorrM{j}.Task(:,1)));
    idx_nonexist_Post = find(isnan(CorrM{j}.Post(:,1)));
    idx_nonexist_PreSWS = find(isnan(CorrM{j}.PreSWS(:,1)));
    for i=1:4
        idx_nonexist_PreSWS10{i} = find(isnan(CorrM{j}.PreSWS10{i}(:,1)));
    end
    idx_nonexist_PreSWS10_Final = unique([idx_nonexist_PreSWS10{1}; idx_nonexist_PreSWS10{2}; idx_nonexist_PreSWS10{3}; idx_nonexist_PreSWS10{4}]);
    idx_nonexist_PreREM = find(isnan(CorrM{j}.PreREM(:,1)));
    idx_nonexist_PostSWS = find(isnan(CorrM{j}.PreSWS(:,1)));
    for i=1:4
        idx_nonexist_PostSWS10{i} = find(isnan(CorrM{j}.PostSWS10{i}(:,1)));
    end
    idx_nonexist_PostSWS10_Final = unique([idx_nonexist_PostSWS10{1}; idx_nonexist_PostSWS10{2}; idx_nonexist_PostSWS10{3}; idx_nonexist_PostSWS10{4}]);
    idx_nonexist_PostREM = find(isnan(CorrM{j}.PreREM(:,1)));
    idx_nonexist_PostTest = find(isnan(CorrM{j}.PostTest(:,1)));
    idx_toremove = unique(([idx_nonexist_Pre; idx_nonexist_Task; idx_nonexist_Post; idx_nonexist_PostTest])');
    idx_toremove1 = unique(([idx_nonexist_PreSWS; idx_nonexist_PreREM;...
        idx_nonexist_Task; idx_nonexist_PostSWS; idx_nonexist_PostREM; idx_nonexist_PostTest])');
    idx_toremove2 = unique(([idx_nonexist_PreSWS10_Final; ...
        idx_nonexist_Task; idx_nonexist_PostSWS10_Final; idx_nonexist_PostTest])');
    CorrM{j}.Pre(idx_toremove,:) = [];
    CorrM{j}.Pre(:,idx_toremove) = [];
    CorrM{j}.Task(:,idx_toremove) = [];
    CorrM{j}.Task(idx_toremove,:) = [];
    CorrM{j}.Post(:,idx_toremove) = [];
    CorrM{j}.Post(idx_toremove,:) = [];
    CorrM{j}.PostTest(:,idx_toremove) = [];
    CorrM{j}.PostTest(idx_toremove,:) = [];
    
    CorrM{j}.PreSWS(idx_toremove1,:) = [];
    CorrM{j}.PreSWS(:,idx_toremove1) = [];
    CorrM{j}.PreREM(idx_toremove1,:) = [];
    CorrM{j}.PreREM(:,idx_toremove1) = [];
    
    CorrM{j}.Task1(:,idx_toremove1) = [];
    CorrM{j}.Task1(idx_toremove1,:) = [];
    
    CorrM{j}.PostSWS(idx_toremove1,:) = [];
    CorrM{j}.PostSWS(:,idx_toremove1) = [];
    CorrM{j}.PostREM(idx_toremove1,:) = [];
    CorrM{j}.PostREM(:,idx_toremove1) = [];
    
    CorrM{j}.PostTest1(:,idx_toremove1) = [];
    CorrM{j}.PostTest1(idx_toremove1,:) = [];
    
    for i=1:4
        CorrM{j}.PreSWS10{i}(:,idx_toremove2) = [];
        CorrM{j}.PreSWS10{i}(idx_toremove2,:) = [];
    end
    CorrM{j}.Task2(:,idx_toremove2) = [];
    CorrM{j}.Task2(idx_toremove2,:) = [];
    for i=1:4
        CorrM{j}.PostSWS10{i}(idx_toremove2,:) = [];
        CorrM{j}.PostSWS10{i}(:,idx_toremove2) = [];
    end
    CorrM{j}.PostTest2(:,idx_toremove2) = [];
    CorrM{j}.PostTest2(idx_toremove2,:) = [];
    
    % Calculate EV and REV
    temp{j} = corrcoef(CorrM{j}.Post,CorrM{j}.Task); CorrCo_PostTask(j) = temp{j}(1,2); clear temp
    temp{j} = corrcoef(CorrM{j}.Task,CorrM{j}.Pre); CorrCo_TaskPre(j) = temp{j}(1,2); clear temp
    temp{j} = corrcoef(CorrM{j}.Post,CorrM{j}.Pre); CorrCo_PostPre(j) = temp{j}(1,2); clear temp
    
    temp{j} = corrcoef(CorrM{j}.PostSWS,CorrM{j}.Task1); CorrCo_PostSWSTask(j) = temp{j}(1,2); clear temp
    temp{j} = corrcoef(CorrM{j}.PostREM,CorrM{j}.Task1); CorrCo_PostREMTask(j) = temp{j}(1,2); clear temp
    
    temp{j} = corrcoef(CorrM{j}.Task1,CorrM{j}.PreSWS); CorrCo_TaskPreSWS(j) = temp{j}(1,2); clear temp
    temp{j} = corrcoef(CorrM{j}.Task1,CorrM{j}.PreREM); CorrCo_TaskPreREM(j) = temp{j}(1,2); clear temp
    
    temp{j} = corrcoef(CorrM{j}.PostSWS,CorrM{j}.PreSWS); CorrCo_PostSWSPreSWS(j) = temp{j}(1,2); clear temp
    temp{j} = corrcoef(CorrM{j}.PostREM,CorrM{j}.PreREM); CorrCo_PostREMPreREM(j) = temp{j}(1,2); clear temp
    
    for i=1:4
        temp{j} = corrcoef(CorrM{j}.PostSWS10{i},CorrM{j}.Task2); CorrCo_PostSWS10Task{j}(i) = temp{j}(1,2); clear temp
    end
    for i=1:4
        temp{j} = corrcoef(CorrM{j}.Task2,CorrM{j}.PreSWS10{i}); CorrCo_TaskPreSWS10{j}(i) = temp{j}(1,2); clear temp
    end
    for i=1:4
        temp{j} = corrcoef(CorrM{j}.PostSWS10{i},CorrM{j}.PreSWS10{i}); CorrCo_PostSWSPreSWS10{j}(i) = temp{j}(1,2); clear temp
    end
    
    EV(j) = ((CorrCo_PostTask(j)-CorrCo_TaskPre(j)*CorrCo_PostPre(j))/...
        sqrt((1-(CorrCo_TaskPre(j))^2)*(1-(CorrCo_PostPre(j))^2)))^2;
    REV(j) = ((CorrCo_TaskPre(j)-CorrCo_PostTask(j)*CorrCo_PostPre(j))/...
        sqrt((1-(CorrCo_PostTask(j))^2)*(1-(CorrCo_PostPre(j))^2)))^2;
    
    EVSWS(j) = ((CorrCo_PostSWSTask(j)-CorrCo_TaskPreSWS(j)*CorrCo_PostSWSPreSWS(j))/...
        sqrt((1-(CorrCo_TaskPreSWS(j))^2)*(1-(CorrCo_PostSWSPreSWS(j))^2)))^2;
    REVSWS(j) = ((CorrCo_TaskPreSWS(j)-CorrCo_PostSWSTask(j)*CorrCo_PostSWSPreSWS(j))/...
        sqrt((1-(CorrCo_PostSWSTask(j))^2)*(1-(CorrCo_PostSWSPreSWS(j))^2)))^2;
    
    EVREM(j) = ((CorrCo_PostREMTask(j)-CorrCo_TaskPreREM(j)*CorrCo_PostREMPreREM(j))/...
        sqrt((1-(CorrCo_TaskPreREM(j))^2)*(1-(CorrCo_PostREMPreREM(j))^2)))^2;
    REVREM(j) = ((CorrCo_TaskPreREM(j)-CorrCo_PostREMTask(j)*CorrCo_PostREMPreREM(j))/...
        sqrt((1-(CorrCo_PostREMTask(j))^2)*(1-(CorrCo_PostREMPreREM(j))^2)))^2;
    
    for i=1:4
        EVSWS10{i}(j) = ((CorrCo_PostSWS10Task{j}(i)-CorrCo_TaskPreSWS10{j}(i)*CorrCo_PostSWSPreSWS10{j}(i))/...
            sqrt((1-(CorrCo_TaskPreSWS10{j}(i))^2)*(1-(CorrCo_PostSWSPreSWS10{j}(i))^2)))^2;
        REVSWS10{i}(j) = ((CorrCo_TaskPreSWS10{j}(i)-CorrCo_PostSWS10Task{j}(i)*CorrCo_PostSWSPreSWS10{j}(i))/...
            sqrt((1-(CorrCo_PostSWS10Task{j}(i))^2)*(1-(CorrCo_PostSWSPreSWS10{j}(i))^2)))^2;
    end
    clear Q idx_nonexist_Pre idx_nonexist_Task idx_nonexist_Post idx_nonexist_PostTest SWSEpoch REMEpoch
    
end

%% Plot

Pl = {EV*100; REV*100};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',12,'XTick',1:2,'XTickLabel',...
    {'Explained variance','Reversed explained variance'})
% ylim([0.15 0.9])
ylabel('EV or REV in %')
% title('Place cell stability after conditioning')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));


Pl = {EVSWS*100; REVSWS*100};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',12,'XTick',1:2,'XTickLabel',...
    {'Explained variance','Reversed explained variance'})
% ylim([0.15 0.9])
ylabel('EV or REV in %')
% title('Place cell stability after conditioning')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

Pl = {EVREM*100; REVREM*100};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',12,'XTick',1:2,'XTickLabel',...
    {'Explained variance','Reversed explained variance'})
% ylim([0.15 0.9])
ylabel('EV or REV in %')
% title('Place cell stability after conditioning')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));


% Dynamics
Pl = {EVSWS10{1}*100; REVSWS10{1}*100; EVSWS10{2}*100; REVSWS10{2}*100; EVSWS10{3}*100; REVSWS10{3}*100;...
    EVSWS10{4}*100; REVSWS10{4}*100;};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:8]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',12,'XTick',1:8,'XTickLabel',...
    {'EV 0-10min','REV 0-10 min','EV 10-20min','REV 10-20 min', 'EV 20-30min','REV 20-30 min', 'EV 30-40min','REV 30-40 min'})
% ylim([0.15 0.9])
ylabel('EV or REV in %')
% title('Place cell stability after conditioning')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));



%% How many mice have EV>REV
idx = EV>REV;
EV_new = EV(idx);
REV_new = REV(idx);

Pl = {EV_new*100; REV_new*100};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.7 0.9]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,'XTickLabel',...
    {'Explained variance','Reverse explained variance'})
% ylim([0.15 0.9])
ylabel('EV or REV in %')
% title('Place cell stability after conditioning')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));


if sav
    saveas(gcf,['/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/ExplainedVariance.fig']);
    saveFigure(gcf,'ExplainedVariance',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/');
end