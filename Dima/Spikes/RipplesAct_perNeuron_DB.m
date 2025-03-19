%%% testripples

%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/';
fig_post = 'PFCells_RippleParticipation';
% Numbers of mice to run analysis on
Mice_to_analyze = 906;
PFidx = [17 18 19 27];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

%% Load data
beh = load([Dir.path{1}{1} '/behavResources.mat'], 'SessionEpoch','FreezeAccEpoch','ZoneEpoch');
rip = load([Dir.path{1}{1} '/Ripples.mat'], 'ripples');
spikes = load([Dir.path{1}{1} '/SpikeData.mat'], 'S', 'BasicNeuronInfo');
sleepscored = load([Dir.path{1}{1} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');

%%

RipIS=intervalSet(rip.ripples(:,1)*1E4, rip.ripples(:,3)*1E4);
RipSt= Start(RipIS);
rip=ts(rip.ripples(:,2)*1E4);
% Get pyramidal cells
SPF = spikes.S(PFidx);
SnoPF= spikes.S(intersect(setdiff(spikes.BasicNeuronInfo.idx_SUA,PFidx),...
    find(spikes.BasicNeuronInfo.neuroclass>0)));


%%% CondEpoch
CondEpoch = or(beh.SessionEpoch.Cond1,beh.SessionEpoch.Cond2);
CondEpoch = or(CondEpoch,beh.SessionEpoch.Cond3);
CondEpoch = or(CondEpoch,beh.SessionEpoch.Cond4);

%%% Create epochs
SWSPre = and(sleepscored.SWSEpoch,beh.SessionEpoch.PreSleep);
REMPre = and(sleepscored.REMEpoch,beh.SessionEpoch.PreSleep);
RipISPre = and(RipIS,beh.SessionEpoch.PreSleep);
RipISCond = and(RipIS,CondEpoch);
RipISPost = and(RipIS,beh.SessionEpoch.PostSleep);
SWSPost = and(sleepscored.SWSEpoch,beh.SessionEpoch.PostSleep);
REMPost = and(sleepscored.REMEpoch,beh.SessionEpoch.PostSleep);

% Weird Epoch
SafeSideEpoch = or(beh.ZoneEpoch.NoShock,beh.ZoneEpoch.CentreNoShock);
FreezeSafeSideEpoch = and(beh.FreezeAccEpoch,SafeSideEpoch);

%% Get firing rate of each situation
for i=1:length(SPF)
    FR_Pre(i) = length(Range(Restrict(SPF{i},and(beh.SessionEpoch.PreSleep,sleepscored.SWSEpoch))))/...
        sum((End(and(beh.SessionEpoch.PreSleep,sleepscored.SWSEpoch))-...
        Start(and(beh.SessionEpoch.PreSleep,sleepscored.SWSEpoch))))*1e4;
    FR_Post(i) = length(Range(Restrict(SPF{i},and(beh.SessionEpoch.PostSleep,sleepscored.SWSEpoch))))/...
        sum((End(and(beh.SessionEpoch.PostSleep,sleepscored.SWSEpoch))-...
        Start(and(beh.SessionEpoch.PostSleep,sleepscored.SWSEpoch))))*1e4;
    FR_Cond(i) = length(Range(Restrict(SPF{i},and(beh.SessionEpoch.PostSleep,sleepscored.SWSEpoch))))/...
        sum((End(and(CondEpoch,FreezeSafeSideEpoch))-Start(and(CondEpoch,FreezeSafeSideEpoch))))*1e4;
end

%% Get the Cross-corellation with ripples in each state

for i=1:length(SPF)
    [C_Pre(i,:),B]=CrossCorr(Range(Restrict(rip,and(beh.SessionEpoch.PreSleep,sleepscored.SWSEpoch))),...
        Range(SPF{i}),5,50);
    [C_Post(i,:),B]=CrossCorr(Range(Restrict(rip,and(beh.SessionEpoch.PostSleep,sleepscored.SWSEpoch))),...
        Range(SPF{i}),5,50);
    [C_Cond(i,:),B]=CrossCorr(Range(Restrict(rip,and(CondEpoch,FreezeSafeSideEpoch))),Range(SPF{i}),5,50);
end


%% Get the ripple participation in PreSleep
nocellsRip_pre = 0;
noPFcellRip_pre = 0;
noPFCell1_pre = 0;
noPFCell2_pre = 0;
noPFCell3_pre = 0;
noPFCell4_pre = 0;
Cell1_pre = 0;
Cell2_pre = 0;
Cell3_pre = 0;
Cell4_pre = 0;

Cell1_wh_pre = 0;
Cell2_wh_pre = 0;
Cell3_wh_pre = 0;
Cell4_wh_pre = 0;

% Calculate number of cells activated per ripple
for i=1:length(Start(RipISPre))
    if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISPre,i)))) &&...
            isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISPre,i)))) % No neuron firing at a given ripple
        nocellsRip_pre = nocellsRip_pre+1;
    elseif ~isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISPre,i)))) % noPF Cell
        if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISPre,i))))
            noPFcellRip_pre = noPFcellRip_pre+1;
        else
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISPre,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['noPFCell' num2str(count) '_pre= noPFCell' num2str(count) '_pre + 1;']);
            end
        end
    elseif ~isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISPre,i))))
        if isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISPre,i))))
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISPre,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['Cell' num2str(count) '_pre= Cell' num2str(count) '_pre + 1;']);
            end
        end
    end
end
% Calculate which cell is activated per ripple
for i=1:length(Start(RipISPre))
    if ~isempty(Data(Restrict(SPF{1},subset(RipISPre,i))))
        Cell1_wh_pre = Cell1_wh_pre + 1;
        if ~isempty(Data(Restrict(SPF{2},subset(RipISPre,i))))
            Cell2_wh_pre = Cell2_wh_pre + 1;
            if ~isempty(Data(Restrict(SPF{3},subset(RipISPre,i))))
                Cell3_wh_pre = Cell3_wh_pre + 1;
                if ~isempty(Data(Restrict(SPF{4},subset(RipISPre,i))))
                    Cell4_wh_pre = Cell4_wh_pre + 1;
                end
            end
        end
    elseif ~isempty(Data(Restrict(SPF{2},subset(RipISPre,i))))
        Cell2_wh_pre = Cell2_wh_pre + 1;
        if ~isempty(Data(Restrict(SPF{3},subset(RipISPre,i))))
            Cell3_wh_pre = Cell3_wh_pre + 1;
            if ~isempty(Data(Restrict(SPF{4},subset(RipISPre,i))))
                Cell4_wh_pre = Cell4_wh_pre + 1;
            end
        end
    elseif ~isempty(Data(Restrict(SPF{3},subset(RipISPre,i))))
        Cell3_wh_pre = Cell3_wh_pre + 1;
        if ~isempty(Data(Restrict(SPF{4},subset(RipISPre,i))))
            Cell4_wh_pre = Cell4_wh_pre + 1;
        end
    elseif ~isempty(Data(Restrict(SPF{4},subset(RipISPre,i))))
        Cell4_wh_pre = Cell4_wh_pre + 1;
    end
end


%% Get the ripple participation in Cond
nocellsRip_cond = 0;
noPFcellRip_cond = 0;
noPFCell1_cond = 0;
noPFCell2_cond = 0;
noPFCell3_cond = 0;
noPFCell4_cond = 0;
Cell1_cond = 0;
Cell2_cond = 0;
Cell3_cond = 0;
Cell4_cond = 0;

Cell1_wh_cond = 0;
Cell2_wh_cond = 0;
Cell3_wh_cond = 0;
Cell4_wh_cond = 0;

% Calculate number of cells activated per ripple
for i=1:length(Start(RipISCond))
    if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISCond,i)))) &&...
            isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISCond,i)))) % No neuron firing at a given ripple
        nocellsRip_cond = nocellsRip_cond+1;
    elseif ~isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISCond,i)))) % noPF Cell
        if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISCond,i))))
            noPFcellRip_cond = noPFcellRip_cond+1;
        else
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISCond,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['noPFCell' num2str(count) '_cond= noPFCell' num2str(count) '_cond + 1;']);
            end
        end
    elseif ~isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISCond,i))))
        if isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISCond,i))))
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISCond,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['Cell' num2str(count) '_cond= Cell' num2str(count) '_cond + 1;']);
            end
        end
    end
end
% Calculate which cell is activated per ripple
for i=1:length(Start(RipISCond))
    if ~isempty(Data(Restrict(SPF{1},subset(RipISCond,i))))
        Cell1_wh_cond = Cell1_wh_cond + 1;
        if ~isempty(Data(Restrict(SPF{2},subset(RipISCond,i))))
            Cell2_wh_cond = Cell2_wh_cond + 1;
            if ~isempty(Data(Restrict(SPF{3},subset(RipISCond,i))))
                Cell3_wh_cond = Cell3_wh_cond + 1;
                if ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
                    Cell4_wh_cond = Cell4_wh_cond + 1;
                end
            end
        end
    elseif ~isempty(Data(Restrict(SPF{2},subset(RipISCond,i))))
        Cell2_wh_cond = Cell2_wh_cond + 1;
        if ~isempty(Data(Restrict(SPF{3},subset(RipISCond,i))))
            Cell3_wh_cond = Cell3_wh_cond + 1;
            if ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
                Cell4_wh_cond = Cell4_wh_cond + 1;
            end
        end
    elseif ~isempty(Data(Restrict(SPF{3},subset(RipISCond,i))))
        Cell3_wh_cond = Cell3_wh_cond + 1;
        if ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
            Cell4_wh_cond = Cell4_wh_cond + 1;
        end
    elseif ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
        Cell4_wh_cond = Cell4_wh_cond + 1;
    end
end

%% Get the ripple participation in PostSleep
nocellsRip_post = 0;
noPFcellRip_post = 0;
noPFCell1_post = 0;
noPFCell2_post = 0;
noPFCell3_post = 0;
noPFCell4_post = 0;
Cell1_post = 0;
Cell2_post = 0;
Cell3_post = 0;
Cell4_post = 0;

Cell1_wh_post = 0;
Cell2_wh_post = 0;
Cell3_wh_post = 0;
Cell4_wh_post = 0;

% Calculate number of cells activated per ripple
for i=1:length(Start(RipISPost))
    if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISPost,i)))) &&...
            isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISPost,i)))) % No neuron firing at a given ripple
        nocellsRip_post = nocellsRip_post+1;
    elseif ~isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISPost,i)))) % noPF Cell
        if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISPost,i))))
            noPFcellRip_post = noPFcellRip_post+1;
        else
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISPost,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['noPFCell' num2str(count) '_post= noPFCell' num2str(count) '_post + 1;']);
            end
        end
    elseif ~isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISPost,i))))
        if isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISPost,i))))
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISPost,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['Cell' num2str(count) '_post= Cell' num2str(count) '_post + 1;']);
            end
        end
    end
end
% Calculate which cell is activated per ripple
for i=1:length(Start(RipISPost))
    if ~isempty(Data(Restrict(SPF{1},subset(RipISPost,i))))
        Cell1_wh_post = Cell1_wh_post + 1;
        if ~isempty(Data(Restrict(SPF{2},subset(RipISPost,i))))
            Cell2_wh_post = Cell2_wh_post + 1;
            if ~isempty(Data(Restrict(SPF{3},subset(RipISPost,i))))
                Cell3_wh_post = Cell3_wh_post + 1;
                if ~isempty(Data(Restrict(SPF{4},subset(RipISPost,i))))
                    Cell4_wh_post = Cell4_wh_post + 1;
                end
            end
        end
    elseif ~isempty(Data(Restrict(SPF{2},subset(RipISPost,i))))
        Cell2_wh_post = Cell2_wh_post + 1;
        if ~isempty(Data(Restrict(SPF{3},subset(RipISPost,i))))
            Cell3_wh_post = Cell3_wh_post + 1;
            if ~isempty(Data(Restrict(SPF{4},subset(RipISPost,i))))
                Cell4_wh_post = Cell4_wh_post + 1;
            end
        end
    elseif ~isempty(Data(Restrict(SPF{3},subset(RipISPost,i))))
        Cell3_wh_post = Cell3_wh_post + 1;
        if ~isempty(Data(Restrict(SPF{4},subset(RipISPost,i))))
            Cell4_wh_post = Cell4_wh_post + 1;
        end
    elseif ~isempty(Data(Restrict(SPF{4},subset(RipISPost,i))))
        Cell4_wh_post = Cell4_wh_post + 1;
    end
end

%% Percentages
nocellsRip_pre = nocellsRip_pre/length(Start(RipISPre))*100;
noPFcellRip_pre = noPFcellRip_pre/length(Start(RipISPre))*100;
noPFCell1_pre = noPFCell1_pre/length(Start(RipISPre))*100;
noPFCell2_pre = noPFCell2_pre/length(Start(RipISPre))*100;
noPFCell3_pre = noPFCell3_pre/length(Start(RipISPre))*100;
noPFCell4_pre = noPFCell4_pre/length(Start(RipISPre))*100;
Cell1_pre = Cell1_pre/length(Start(RipISPre))*100;
Cell2_pre = Cell2_pre/length(Start(RipISPre))*100;
Cell3_pre = Cell3_pre/length(Start(RipISPre))*100;
Cell4_pre = Cell4_pre/length(Start(RipISPre))*100;

Cell1_wh_pre = Cell1_wh_pre/length(Start(RipISPre))*100;
Cell2_wh_pre = Cell2_wh_pre/length(Start(RipISPre))*100;
Cell3_wh_pre = Cell3_wh_pre/length(Start(RipISPre))*100;
Cell4_wh_pre = Cell4_wh_pre/length(Start(RipISPre))*100;

nocellsRip_cond = nocellsRip_cond/length(Start(RipISCond))*100;
noPFcellRip_cond = noPFcellRip_cond/length(Start(RipISCond))*100;
noPFCell1_cond = noPFCell1_cond/length(Start(RipISCond))*100;
noPFCell2_cond = noPFCell2_cond/length(Start(RipISCond))*100;
noPFCell3_cond = noPFCell3_cond/length(Start(RipISCond))*100;
noPFCell4_cond = noPFCell4_cond/length(Start(RipISCond))*100;
Cell1_cond = Cell1_cond/length(Start(RipISCond))*100;
Cell2_cond = Cell2_cond/length(Start(RipISCond))*100;
Cell3_cond = Cell3_cond/length(Start(RipISCond))*100;
Cell4_cond = Cell4_cond/length(Start(RipISCond))*100;

Cell1_wh_cond = Cell1_wh_cond/length(Start(RipISCond))*100;
Cell2_wh_cond = Cell2_wh_cond/length(Start(RipISCond))*100;
Cell3_wh_cond = Cell3_wh_cond/length(Start(RipISCond))*100;
Cell4_wh_cond = Cell4_wh_cond/length(Start(RipISCond))*100;


nocellsRip_post = nocellsRip_post/length(Start(RipISPost))*100;
noPFcellRip_post = noPFcellRip_post/length(Start(RipISPost))*100;
noPFCell1_post = noPFCell1_post/length(Start(RipISPost))*100;
noPFCell2_post = noPFCell2_post/length(Start(RipISPost))*100;
noPFCell3_post = noPFCell3_post/length(Start(RipISPost))*100;
noPFCell4_post = noPFCell4_post/length(Start(RipISPost))*100;
Cell1_post = Cell1_post/length(Start(RipISPost))*100;
Cell2_post = Cell2_post/length(Start(RipISPost))*100;
Cell3_post = Cell3_post/length(Start(RipISPost))*100;
Cell4_post = Cell4_post/length(Start(RipISPost))*100;

Cell1_wh_post = Cell1_wh_post/length(Start(RipISPost))*100;
Cell2_wh_post = Cell2_wh_post/length(Start(RipISPost))*100;
Cell3_wh_post = Cell3_wh_post/length(Start(RipISPost))*100;
Cell4_wh_post = Cell4_wh_post/length(Start(RipISPost))*100;


%% PieChart
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
subplot(131)
pieid  = pie([nocellsRip_pre noPFcellRip_pre noPFCell1_pre noPFCell2_pre...
    noPFCell3_pre noPFCell4_pre Cell1_pre Cell2_pre Cell3_pre Cell4_pre]);
legend ({'No cell detected', 'Only non-PF', 'nonPF+1 PF','nonPF+2PFs','nonPF+3PFs',...
    'nonPF+4PFs','1PF','2PFs','3PFs','4PFs'}, 'Position', [0.1 0.9 0.17 0.01]);
subplot(132)
pieid  = pie([nocellsRip_cond noPFcellRip_cond noPFCell1_cond noPFCell2_cond...
    noPFCell3_cond noPFCell4_cond Cell1_cond Cell2_cond Cell3_cond Cell4_cond]);
subplot(133)
pieid  = pie([nocellsRip_post noPFcellRip_post noPFCell1_post noPFCell2_post...
    noPFCell3_post noPFCell4_post Cell1_post Cell2_post Cell3_post Cell4_post]);

%% Barplot
fh = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.8]);
barid  = bar([nocellsRip_pre noPFcellRip_pre Cell1_wh_pre Cell2_wh_pre Cell3_wh_pre Cell4_wh_pre;...
    nocellsRip_cond noPFcellRip_cond Cell1_wh_cond Cell2_wh_cond Cell3_wh_cond Cell4_wh_cond;...
    nocellsRip_post noPFcellRip_post Cell1_wh_post Cell2_wh_post Cell3_wh_post Cell4_wh_post]');


%% Cross corellation figure
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

subplot(3,3,1)
plot(B/1E3,mean(C_Pre),'k','LineWidth',3,'LineWidth',3)
xlabel('Time (ms)')
title('PreSleep','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
ylim([0 6])
subplot(3,3,[4 7])
imagesc(B,1:length(SPF),C_Pre)
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 10])
xlabel('Time (ms)')

subplot(3,3,2)
plot(B/1E3,mean(C_Cond),'k','LineWidth',3)
title('Conditioning','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
xlabel('Time (ms)')
ylim([0 6])
subplot(3,3,[5 8])
imagesc(B,1:length(SPF),C_Cond)
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 10])
xlabel('Time (ms)')

subplot(3,3,3)
plot(B/1E3,mean(C_Post),'k','LineWidth',3)
title('PostSleep','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
xlabel('Time (ms)')
ylim([0 6])
subplot(3,3,[6 9])
imagesc(B,1:length(SPF),C_Post)
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 10])
xlabel('Time (ms)')

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/spikesDuringRipplesProblem/1.fig');
saveFigure(fh, '1', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/spikesDuringRipplesProblem/');


fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

subplot(3,3,1)
plot(B/1E3,mean(C_Pre),'k','LineWidth',3)
xlabel('Time (ms)')
title('PreSleep','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
ylim([0 6])
subplot(3,3,[4 7])
imagesc(B,1:length(SPF),zscore(C_Pre')')
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 4])
xlabel('Time (ms)')

subplot(3,3,2)
plot(B/1E3,mean(C_Cond),'k','LineWidth',3)
xlabel('Time (ms)')
title('Conditioning','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
ylim([0 6])
subplot(3,3,[5 8])
imagesc(B,1:length(SPF),zscore(C_Cond')')
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 4])
xlabel('Time (ms)')

subplot(3,3,3)
plot(B/1E3,mean(C_Post),'k','LineWidth',3)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
xlabel('Time (ms)')
title('PostSleep','FontSize',16)
ylim([0 6])
subplot(3,3,[6 9])
imagesc(B,1:length(SPF),zscore(C_Post')')
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 4])
xlabel('Time (ms)')

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/spikesDuringRipplesProblem/2.fig');
saveFigure(fh, '2', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/spikesDuringRipplesProblem/');


%%

fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

subplot(3,3,1)
plot(B/1E3,mean(C_Pre([1 3 4],:)),'k','LineWidth',3,'LineWidth',3)
hold on
plot(B/1E3,C_Pre(2,:),'r','LineWidth',3,'LineWidth',3)
xlabel('Time (ms)')
xlim([-0.125 0.125]);
title('PreSleep','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
ylim([0 6])
subplot(3,3,[4 7])
imagesc(B,1:length(SPF),C_Pre)
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 10])
xlabel('Time (ms)')

subplot(3,3,2)
plot(B/1E3,mean(C_Cond([1 3 4],:)),'k','LineWidth',3,'LineWidth',3)
hold on
plot(B/1E3,C_Cond(2,:),'r','LineWidth',3,'LineWidth',3)
title('Conditioning','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
xlabel('Time (ms)')
xlim([-0.125 0.125]);
ylim([0 6])
subplot(3,3,[5 8])
imagesc(B,1:length(SPF),C_Cond)
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 10])
xlabel('Time (ms)')

subplot(3,3,3)
plot(B/1E3,mean(C_Post([1 3 4],:)),'k','LineWidth',3,'LineWidth',3)
hold on
plot(B/1E3,C_Post(2,:),'r','LineWidth',3,'LineWidth',3)
title('PostSleep','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
xlabel('Time (ms)')
ylim([0 6])
xlim([-0.125 0.125]);
subplot(3,3,[6 9])
imagesc(B,1:length(SPF),C_Post)
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 10])
xlabel('Time (ms)')


fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

subplot(3,3,1)
plot(B/1E3,zscore(mean(C_Pre([1 3 4],:))),'k','LineWidth',3,'LineWidth',3)
hold on
plot(B/1E3,zscore(C_Pre(2,:)),'r','LineWidth',3,'LineWidth',3)
xlabel('Time (ms)')
title('PreSleep','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
ylim([-2 4])
xlim([-0.125 0.125]);
subplot(3,3,[4 7])
imagesc(B,1:length(SPF),zscore(C_Pre')')
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 4])
xlabel('Time (ms)')

subplot(3,3,2)
plot(B/1E3,zscore(mean(C_Cond([1 3 4],:))),'k','LineWidth',3,'LineWidth',3)
hold on
plot(B/1E3,zscore(C_Cond(2,:)),'r','LineWidth',3,'LineWidth',3)
xlabel('Time (ms)')
title('Conditioning','FontSize',16)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
ylim([-2 4])
xlim([-0.125 0.125]);
subplot(3,3,[5 8])
imagesc(B,1:length(SPF),zscore(C_Cond')')
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 4])
xlabel('Time (ms)')

subplot(3,3,3)
plot(B/1E3,zscore(mean(C_Cond([1 3 4],:))),'k','LineWidth',3,'LineWidth',3)
hold on
plot(B/1E3,zscore(C_Cond(2,:)),'r','LineWidth',3,'LineWidth',3)
set(gca,'FontWeight','bold','FontSize',14,'LineWidth',3)
xlabel('Time (ms)')
title('PostSleep','FontSize',16)
ylim([-2 4])
xlim([-0.125 0.125]);
subplot(3,3,[6 9])
imagesc(B,1:length(SPF),zscore(C_Post')')
set(gca,'FontWeight','bold','FontSize',14, 'YTick',[1:4],'YTickLabel', {'1','2','3','4'})
clim([0 4])
xlabel('Time (ms)')

