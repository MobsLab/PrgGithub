%%% RippleParticipation_DB



%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/';
fig_post = 'PFCells_RippleParticipation';
% Numbers of mice to run analysis on
Mice_to_analyze = [711 797 906 911 912];
PFidx{1} = [27 32];
PFidx{2} = 12;
PFidx{3} = [17 18 19 27];
PFidx{4} = [5 8 17 18];
PFidx{5} = [56 58 61 63];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

%% Get data

for i = 1:length(Dir.path)
    beh{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'SessionEpoch');
    rip{i} = load([Dir.path{i}{1} '/Ripples.mat'], 'ripples');
    spikes{i} = load([Dir.path{i}{1} '/SpikeData.mat'], 'S', 'BasicNeuronInfo');
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    else
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    end
end

%% Calculate
k=0;
u=0;
for i=1:length(Dir.path)
    RipIS{i}=intervalSet(rip{i}.ripples(:,1)*1E4, rip{i}.ripples(:,3)*1E4);
    RipSt{i} = Start(RipIS{i});
    % Get pyramidal cells
    SPF{i} = spikes{i}.S(PFidx{i});
    SnoPF{i} = spikes{i}.S(intersect(setdiff(spikes{i}.BasicNeuronInfo.idx_SUA,PFidx{i}),...
        find(spikes{i}.BasicNeuronInfo.neuroclass<0)));

    %%% CondEpoch
    CondEpoch{i} = or(beh{i}.SessionEpoch.Cond1,beh{i}.SessionEpoch.Cond2);
    CondEpoch{i} = or(CondEpoch{i},beh{i}.SessionEpoch.Cond3);
    CondEpoch{i} = or(CondEpoch{i},beh{i}.SessionEpoch.Cond4);
    
    %%% Create epochs
    SWSPre{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PreSleep);
    REMPre{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PreSleep);
    RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
    RipISCond{i} = and(RipIS{i},CondEpoch{i});
    RipISPost{i} = and(RipIS{i},beh{i}.SessionEpoch.PostSleep); 
    SWSPost{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PostSleep);
    REMPost{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PostSleep);
    
    
    % Probaility of each neuron to fire during ripples
    for j = 1:length(SPF{i})
        k=k+1;
        ProbPF_SWSPre(k) = length(Data(Restrict(SPF{i}{j},and(SWSPre{i},RipISPre{i}))))/...
            length(Data(Restrict(SPF{i}{j},SWSPre{i})));
        ProbPF_SWSPost(k) = length(Data(Restrict(SPF{i}{j},and(SWSPost{i},RipISPost{i}))))/...
            length(Data(Restrict(SPF{i}{j},SWSPost{i})));
        ProbPF_SWSCond(k) = length(Data(Restrict(SPF{i}{j},and(CondEpoch{i},RipISCond{i}))))/...
            length(Data(Restrict(SPF{i}{j},CondEpoch{i})));
       
    end
    
    
    for j = 1:length(SnoPF{i})
        u=u+1;
        ProbnoPF_SWSPre(u) = length(Data(Restrict(SnoPF{i}{j},and(SWSPre{i},RipISPre{i}))))/...
            length(Data(Restrict(SnoPF{i}{j},SWSPre{i})));
        ProbnoPF_SWSPost(u) = length(Data(Restrict(SnoPF{i}{j},and(SWSPost{i},RipISPost{i}))))/...
            length(Data(Restrict(SnoPF{i}{j},SWSPost{i})));
        ProbnoPF_SWSCond(u) = length(Data(Restrict(SnoPF{i}{j},and(CondEpoch{i},RipISCond{i}))))/...
            length(Data(Restrict(SnoPF{i}{j},CondEpoch{i})));
    end
    
end


%% Plot


Pl = {ProbPF_SWSCond; ProbnoPF_SWSCond};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:2]);
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'Cond-PF','Cond-noPF'})
% ylim([0.15 0.9])
ylabel('RippleParticipation')
% title('Firing rate of cells with PF in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));