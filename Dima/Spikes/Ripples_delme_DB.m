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
beh = load([Dir.path{1}{1} '/behavResources.mat'], 'SessionEpoch');
rip = load([Dir.path{1}{1} '/Ripples.mat'], 'ripples');
spikes = load([Dir.path{1}{1} '/SpikeData.mat'], 'S', 'BasicNeuronInfo');
sleepscored = load([Dir.path{1}{1} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');

%%

RipIS=intervalSet(rip.ripples(:,1)*1E4, rip.ripples(:,3)*1E4);
RipSt= Start(RipIS);
% Get pyramidal cells
SPF = spikes.S(PFidx);
SnoPF= spikes.S(intersect(setdiff(spikes.BasicNeuronInfo.idx_SUA,PFidx),...
    find(spikes.BasicNeuronInfo.neuroclass>0)));


%%% CondEpoch
CondEpoch = or(beh.SessionEpoch.Cond1,beh.SessionEpoch.Cond2);
CondEpoch = or(CondEpoch,beh.SessionEpoch.Cond3);
CondEpoch = or(CondEpoch,beh.SessionEpoch.Cond4);

%%% Create epochs
    SWSPre{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PreSleep);
    REMPre{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PreSleep);
    RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
    RipISCond{i} = and(RipIS{i},CondEpoch{i});
    RipISPost{i} = and(RipIS{i},beh{i}.SessionEpoch.PostSleep); 
    SWSPost{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PostSleep);
    REMPost{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PostSleep);
    


RipISCond = and(RipIS,CondEpoch);

numRip  = length(Start(RipISCond))

%% Allocate
nocellsRip = 0;
noPFcellRip = 0;
noPFCell1 = 0;
noPFCell2 = 0;
noPFCell3 = 0;
noPFCell4 = 0;
Cell1 = 0;
Cell2 = 0;
Cell3 = 0;
Cell4 = 0;

Cell1_wh = 0;
Cell2_wh = 0;
Cell3_wh = 0;
Cell4_wh = 0;

%% Calculate number of cells activated per ripple
for i=1:numRip
    if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISCond,i)))) &&...
            isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISCond,i)))) % No neuron firing at a given ripple
        nocellsRip = nocellsRip+1;
    elseif ~isempty(Data(Restrict(PoolNeurons(SnoPF,1:length(SnoPF)),subset(RipISCond,i)))) % noPF Cell
        if isempty(Data(Restrict(PoolNeurons(SPF,1:length(SPF)),subset(RipISCond,i))))
            noPFcellRip = noPFcellRip+1;
        else
            count = 0;
            for j=1:length(SPF)
                if ~isempty(Data(Restrict(SPF{j},subset(RipISCond,i))))
                    count = count + 1;
                end
            end
            if count>0
                eval(['noPFCell' num2str(count) '= noPFCell' num2str(count) ' + 1;']);
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
                eval(['Cell' num2str(count) '= Cell' num2str(count) ' + 1;']);
            end
        end
    end
end


%% Calculate which cell is activated per ripple
for i=1:numRip
    if ~isempty(Data(Restrict(SPF{1},subset(RipISCond,i))))
        Cell1_wh = Cell1_wh + 1;
        if ~isempty(Data(Restrict(SPF{2},subset(RipISCond,i))))
            Cell2_wh = Cell2_wh + 1;
            if ~isempty(Data(Restrict(SPF{3},subset(RipISCond,i))))
                Cell3_wh = Cell3_wh + 1;
                if ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
                    Cell4_wh = Cell4_wh + 1;
                end
            end
        end
    elseif ~isempty(Data(Restrict(SPF{2},subset(RipISCond,i))))
        Cell2_wh = Cell2_wh + 1;
        if ~isempty(Data(Restrict(SPF{3},subset(RipISCond,i))))
            Cell3_wh = Cell3_wh + 1;
            if ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
                Cell4_wh = Cell4_wh + 1;
            end
        end
    elseif ~isempty(Data(Restrict(SPF{3},subset(RipISCond,i))))
        Cell3_wh = Cell3_wh + 1;
        if ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
            Cell4_wh = Cell4_wh + 1;
        end
    elseif ~isempty(Data(Restrict(SPF{4},subset(RipISCond,i))))
        Cell4_wh = Cell4_wh + 1;
    end
end


%% Calculate how much cell was activated
for i=1:length(SPF)
    spikes_PF(i) = length(Data(Restrict(SPF{i},RipISCond)));
end

for i=1:length(SnoPF)
    spikes_noPF(i) = length(Data(Restrict(SnoPF{i},RipISCond)));
end


%% Percentage

nocellsRip = nocellsRip/numRip*100;
noPFcellRip = noPFcellRip/numRip*100;
noPFCell1 = noPFCell1/numRip*100;
noPFCell2 = noPFCell2/numRip*100;
noPFCell3 = noPFCell3/numRip*100;
noPFCell4 = noPFCell4/numRip*100;
Cell1 = Cell1/numRip*100;
Cell2 = Cell2/numRip*100;
Cell3 = Cell3/numRip*100;
Cell4 = Cell4/numRip*100;

Cell1_wh = Cell1_wh/numRip*100;
Cell2_wh = Cell2_wh/numRip*100;
Cell3_wh = Cell3_wh/numRip*100;
Cell4_wh = Cell4_wh/numRip*100;

%% PieChart
fh = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.8]);
pieid  = pie([nocellsRip noPFcellRip noPFCell1 noPFCell2 noPFCell3 noPFCell4 Cell1 Cell2 Cell3 Cell4]);
legend ({'No cell detected', 'Only non-PF', 'nonPF+1 PF','nonPF+2PFs','nonPF+3PFs',...
    'nonPF+4PFs','1PF','2PFs','3PFs','4PFs'}, 'Position', [0.1 0.7 0.17 0.01]);

%% PieChart 2
fh = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.8]);
barid  = bar([nocellsRip noPFcellRip Cell1_wh Cell2_wh Cell3_wh Cell4_wh]);