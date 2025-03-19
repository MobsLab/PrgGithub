
%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/';
fig_post = 'FRduringRipples';
% Before Vtsd correction == 1
old = 0;
sav = 0;
% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 882 905 906 911 912 977 994];

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

for i=1:length(Dir.path)
    % Create interval for the ripples
    RipIS{i}=intervalSet(rip{i}.ripples(:,1)*1E4, rip{i}.ripples(:,3)*1E4);
    RipSt{i} = Start(RipIS{i});
    % Get pyramidal cells
    SPyr{i} = spikes{i}.S(intersect(spikes{i}.BasicNeuronInfo.idx_SUA, find(spikes{i}.BasicNeuronInfo.neuroclass>0)));
    SInt{i} = spikes{i}.S(intersect(spikes{i}.BasicNeuronInfo.idx_SUA, find(spikes{i}.BasicNeuronInfo.neuroclass<0)));
    
    %%% CondEpoch
    CondEpoch{i} = or(beh{i}.SessionEpoch.Cond1,beh{i}.SessionEpoch.Cond2);
    CondEpoch{i} = or(CondEpoch{i},beh{i}.SessionEpoch.Cond3);
    CondEpoch{i} = or(CondEpoch{i},beh{i}.SessionEpoch.Cond4);
    
    %%% Create epochs
    SWSPre{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PreSleep);
    REMPre{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PreSleep);
    RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
    RipISCond{i} = and(RipIS{i},CondEpoch{i});
    SWSPost{i} = and(sleepscored{i}.SWSEpoch,beh{i}.SessionEpoch.PostSleep);
    REMPost{i} = and(sleepscored{i}.REMEpoch,beh{i}.SessionEpoch.PostSleep);
    RipISPre{i} = and(RipIS{i},beh{i}.SessionEpoch.PreSleep);
    RipISPost{i} = and(RipIS{i},beh{i}.SessionEpoch.PostSleep);

    
    % FR in SWS Pre and Post / Pyr
    for j = 1:length(SPyr{i})
        temp1 = Restrict(SPyr{i}{j}, SWSPre{i});
        temp2 = Restrict(SPyr{i}{j}, REMPre{i});
        PREFR_SWS_Pyr{i}(j) = length(temp1) / (sum(End(SWSPre{i} ) - Start(SWSPre{i}))/1e4);
        PREFR_REM_Pyr{i}(j) = length(temp2) / (sum(End(REMPre{i} ) - Start(REMPre{i}))/1e4);
        temp1 = Restrict(SPyr{i}{j}, SWSPost{i});
        temp2 = Restrict(SPyr{i}{j}, REMPost{i});
        POSTFR_SWS_Pyr{i}(j) = length(temp1) / (sum(End(SWSPost{i} ) - Start(SWSPost{i}))/1e4);
        POSTFR_REM_Pyr{i}(j) = length(temp2) / (sum(End(REMPost{i} ) - Start(REMPost{i}))/1e4);
    end
    clear temp1 temp2
       % FR in SWS Pre and Post / Int
    for j = 1:length(SInt{i})
        temp1 = Restrict(SInt{i}{j}, SWSPre{i});
        temp2 = Restrict(SInt{i}{j}, REMPre{i});
        PREFR_SWS_Int{i}(j) = length(temp1) / (sum(End(SWSPre{i} ) - Start(SWSPre{i}))/1e4);
        PREFR_REM_Int{i}(j) = length(temp2) / (sum(End(REMPre{i} ) - Start(REMPre{i}))/1e4);
        temp1 = Restrict(SInt{i}{j}, SWSPost{i});
        temp2 = Restrict(SInt{i}{j}, REMPost{i});
        POSTFR_SWS_Int{i}(j) = length(temp1) / (sum(End(SWSPost{i} ) - Start(SWSPost{i}))/1e4);
        POSTFR_REM_Int{i}(j) = length(temp2) / (sum(End(REMPost{i} ) - Start(REMPost{i}))/1e4);
    end 
    
    % Ripples Pyr Pre/Post
    clear temp1 temp2
    NoRipPre = beh{i}.SessionEpoch.PreSleep-RipISPre{i};
    for j=1:length(SPyr{i})
        temp1 = Restrict(SPyr{i}{j}, RipISPre{i});
        temp2 = Restrict(SPyr{i}{j}, NoRipPre);
        PREFR_rip_Pyr{i}(j) = length(temp1) / (sum(End(RipISPre{i} ) - Start(RipISPre{i}))/1e4);
        PREFR_norip_Pyr{i}(j) = length(temp2) / (sum(End(NoRipPre) - Start(NoRipPre))/1e4);
    end
    clear temp1 temp2
    NoRipPost = beh{i}.SessionEpoch.PostSleep-RipISPost{i};
    for j=1:length(SPyr{i})
        temp1 = Restrict(SPyr{i}{j}, RipISPost{i});
        temp2 = Restrict(SPyr{i}{j}, NoRipPost);
        POSTFR_rip_Pyr{i}(j) = length(temp1) / (sum(End(RipISPost{i} ) - Start(RipISPost{i}))/1e4);
        POSTFR_norip_Pyr{i}(j) = length(temp2) / (sum(End(NoRipPost) - Start(NoRipPost))/1e4);
    end
    % Cond pyr
    NoRipCond = CondEpoch{i}-RipISCond{i};
    for j=1:length(SPyr{i})
        temp1 = Restrict(SPyr{i}{j}, RipISCond{i});
        temp2 = Restrict(SPyr{i}{j}, NoRipCond);
        CONDFR_rip_Pyr{i}(j) = length(temp1) / (sum(End(RipISCond{i} ) - Start(RipISCond{i}))/1e4);
        CONDFR_norip_Pyr{i}(j) = length(temp2) / (sum(End(NoRipCond) - Start(NoRipCond))/1e4);
    end
    clear temp1 temp2
    for j=1:length(SInt{i})
        temp1 = Restrict(SInt{i}{j}, RipISCond{i});
        temp2 = Restrict(SInt{i}{j}, NoRipCond);
        CONDFR_rip_Int{i}(j) = length(temp1) / (sum(End(RipISCond{i} ) - Start(RipISCond{i}))/1e4);
        CONDFR_norip_Int{i}(j) = length(temp2) / (sum(End(NoRipCond) - Start(NoRipCond))/1e4);
    end
    clear temp1 temp2
    % Ripples Int Pre/Post
    clear temp1 temp2 NoRipPre NoRipPost
    NoRipPre = beh{i}.SessionEpoch.PreSleep-RipISPre{i};
    for j=1:length(SInt{i})
        temp1 = Restrict(SInt{i}{j}, RipISPre{i});
        temp2 = Restrict(SInt{i}{j}, NoRipPre);
        PREFR_rip_Int{i}(j) = length(temp1) / (sum(End(RipISPre{i} ) - Start(RipISPre{i}))/1e4);
        PREFR_norip_Int{i}(j) = length(temp2) / (sum(End(NoRipPre) - Start(NoRipPre))/1e4);
    end
    clear temp1 temp2
    NoRipPost = beh{i}.SessionEpoch.PostSleep-RipISPost{i};
    for j=1:length(SInt{i})
        temp1 = Restrict(SInt{i}{j}, RipISPost{i});
        temp2 = Restrict(SInt{i}{j}, NoRipPost);
        POSTFR_rip_Int{i}(j) = length(temp1) / (sum(End(RipISPost{i} ) - Start(RipISPost{i}))/1e4);
        POSTFR_norip_Int{i}(j) = length(temp2) / (sum(End(NoRipPost) - Start(NoRipPost))/1e4);
    end
    
    % Probability to fire during ripples (participation probability) / Pyr
    for j=1:length(SPyr{i})
        count = zeros(1,length(Start(RipISPre{i})));
        for k = 1:length(Start(RipISPre{i}))
            if ~isempty(Data(Restrict(SPyr{i}{j},subset(RipISPre{i},k))))
                count(k) = 1;
            else
                count(k) = 0;
            end
        end
        PartProbPre_rip_Pyr{i}(j) = sum(count)/length(Start(RipISPre{i}));
        count = zeros(1,length(Start(RipISPost{i})));
        for k = 1:length(Start(RipISPost{i}))
            if ~isempty(Data(Restrict(SPyr{i}{j},subset(RipISPost{i},k))))
                count(k) = 1;
            else
                count(k) = 0;
            end
        end
        PartProbPost_rip_Pyr{i}(j) = sum(count)/length(Start(RipISPost{i}));
        count = zeros(1,length(Start(RipISCond{i})));
        for k = 1:length(Start(RipISCond{i}))
            if ~isempty(Data(Restrict(SPyr{i}{j},subset(RipISCond{i},k))))
                count(k) = 1;
            else
                count(k) = 0;
            end
        end
        PartProbCond_rip_Pyr{i}(j) = sum(count)/length(Start(RipISPost{i}));
    end
    % Probability to fire during ripples (participation probability) / Int
    for j=1:length(SInt{i})
        count = zeros(1,length(Start(RipISPre{i})));
        for k = 1:length(Start(RipISPre{i}))
            if ~isempty(Data(Restrict(SInt{i}{j},subset(RipISPre{i},k))))
                count(k) = 1;
            else
                count(k) = 0;
            end
        end
        PartProbPre_rip_Int{i}(j) = sum(count)/length(Start(RipISPre{i}));
        count = zeros(1,length(Start(RipISPost{i})));
        for k = 1:length(Start(RipISPost{i}))
            if ~isempty(Data(Restrict(SInt{i}{j},subset(RipISPost{i},k))))
                count(k) = 1;
            else
                count(k) = 0;
            end
        end
        PartProbPost_rip_Int{i}(j) = sum(count)/length(Start(RipISPost{i}));
            end
        end
        count = zeros(1,length(Start(RipISCond{i})));
        for k = 1:length(Start(RipISCond{i}))
            if ~isempty(Data(Restrict(SInt{i}{j},subset(RipISCond{i},k))))
                count(k) = 1;
            else
                count(k) = 0;
        PartProbCond_rip_Int{i}(j) = sum(count)/length(Start(RipISCond{i}));
    end
        
        
    
end
%% Average
for i = 1:length(Dir.path)
    PREFR_SWS_PyrMean(i) = mean(PREFR_SWS_Pyr{i});
    PREFR_REM_PyrMean(i) = mean(PREFR_REM_Pyr{i});
    POSTFR_SWS_PyrMean(i) = mean(POSTFR_SWS_Pyr{i});
    POSTFR_REM_PyrMean(i) = mean(POSTFR_REM_Pyr{i});
    PREFR_SWS_IntMean(i) = mean(PREFR_SWS_Int{i});
    PREFR_REM_IntMean(i) = mean(PREFR_REM_Int{i});
    POSTFR_SWS_IntMean(i) = mean(POSTFR_SWS_Int{i});
    POSTFR_REM_IntMean(i) = mean(POSTFR_REM_Int{i});
    
    PREFR_rip_PyrMean(i) = mean(PREFR_rip_Pyr{i});
    PREFR_norip_PyrMean(i) = mean(PREFR_norip_Pyr{i});
    POSTFR_rip_PyrMean(i) = mean(POSTFR_rip_Pyr{i});
    POSTFR_norip_PyrMean(i) = mean(POSTFR_norip_Pyr{i});
    PREFR_rip_IntMean(i) = mean(PREFR_rip_Int{i});
    PREFR_norip_IntMean(i) = mean(PREFR_norip_Int{i});
    POSTFR_rip_IntMean(i) = mean(POSTFR_rip_Int{i});
    POSTFR_norip_IntMean(i) = mean(POSTFR_norip_Int{i});
    CONDFR_rip_PyrMean(i) = mean(CONDFR_rip_Pyr{i});
    CONDFR_norip_PyrMean(i) = mean(CONDFR_norip_Pyr{i});
    CONDFR_rip_IntMean(i) = mean(CONDFR_rip_Int{i});
    CONDFR_norip_IntMean(i) = mean(CONDFR_norip_Int{i});
    
    PartProbPre_rip_PyrMean(i) = mean(PartProbPre_rip_Pyr{i});
    PartProbPost_rip_PyrMean(i) = mean(PartProbPost_rip_Pyr{i});
    PartProbPre_rip_IntMean(i) = mean(PartProbPre_rip_Int{i});
    PartProbPost_rip_IntMean(i) = mean(PartProbPost_rip_Int{i});
    PartProbCond_rip_PyrMean(i) = mean(PartProbCond_rip_Pyr{i});
    PartProbCond_rip_IntMean(i) = mean(PartProbCond_rip_Int{i});
end

%% Pool all neurons
PREFR_SWS_PyrAll = 0;
PREFR_REM_PyrAll = 0;
POSTFR_SWS_PyrAll = 0;
POSTFR_REM_PyrAll = 0;
PREFR_SWS_IntAll = 0;
PREFR_REM_IntAll = 0;
POSTFR_SWS_IntAll = 0;
POSTFR_REM_IntAll = 0;

PREFR_rip_PyrAll = 0;
PREFR_norip_PyrAll = 0;
POSTFR_rip_PyrAll = 0;
POSTFR_norip_PyrAll = 0;
PREFR_rip_IntAll = 0;
PREFR_norip_IntAll = 0;
POSTFR_rip_IntAll = 0;
POSTFR_norip_IntAll = 0;
CONDFR_rip_PyrAll = 0;
CONDFR_norip_PyrAll = 0;
CONDFR_rip_IntAll = 0;
CONDFR_norip_IntAll = 0;

PartProbPre_rip_PyrAll = 0;
PartProbPost_rip_PyrAll = 0;
PartProbPre_rip_IntAll = 0;
PartProbPost_rip_IntAll = 0;
PartProbCond_rip_PyrAll = 0;
PartProbCond_rip_IntAll = 0;
for i = 1:length(Dir.path)
    PREFR_SWS_PyrAll(end+1:end+length(PREFR_SWS_Pyr{i})) = PREFR_SWS_Pyr{i};
    PREFR_REM_PyrAll(end+1:end+length(PREFR_REM_Pyr{i})) = PREFR_REM_Pyr{i};
    POSTFR_SWS_PyrAll(end+1:end+length(POSTFR_SWS_Pyr{i})) = POSTFR_SWS_Pyr{i};
    POSTFR_REM_PyrAll(end+1:end+length(POSTFR_REM_Pyr{i})) = POSTFR_REM_Pyr{i};
    PREFR_SWS_IntAll(end+1:end+length(PREFR_SWS_Int{i})) = PREFR_SWS_Int{i};
    PREFR_REM_IntAll(end+1:end+length(PREFR_REM_Int{i})) = PREFR_REM_Int{i};
    POSTFR_SWS_IntAll(end+1:end+length(POSTFR_SWS_Int{i})) = POSTFR_SWS_Int{i};
    POSTFR_REM_IntAll(end+1:end+length(POSTFR_REM_Int{i})) = POSTFR_REM_Int{i};
    
    PREFR_rip_PyrAll(end+1:end+length(PREFR_rip_Pyr{i})) = PREFR_rip_Pyr{i};
    PREFR_norip_PyrAll(end+1:end+length(PREFR_norip_Pyr{i})) = PREFR_norip_Pyr{i};
    POSTFR_rip_PyrAll(end+1:end+length(POSTFR_rip_Pyr{i})) = POSTFR_rip_Pyr{i};
    POSTFR_norip_PyrAll(end+1:end+length(POSTFR_norip_Pyr{i})) = POSTFR_norip_Pyr{i};
    PREFR_rip_IntAll(end+1:end+length(PREFR_rip_Int{i})) = PREFR_rip_Int{i};
    PREFR_norip_IntAll(end+1:end+length(PREFR_norip_Int{i})) = PREFR_norip_Int{i};
    POSTFR_rip_IntAll(end+1:end+length(POSTFR_rip_Int{i})) = POSTFR_rip_Int{i};
    POSTFR_norip_IntAll(end+1:end+length(POSTFR_norip_Int{i})) = POSTFR_norip_Int{i};
    CONDFR_rip_PyrAll(end+1:end+length(CONDFR_rip_Pyr{i})) = CONDFR_rip_Pyr{i};
    CONDFR_norip_PyrAll(end+1:end+length(CONDFR_norip_Pyr{i})) = CONDFR_norip_Pyr{i};
    CONDFR_rip_IntAll(end+1:end+length(CONDFR_rip_Int{i})) = CONDFR_rip_Int{i};
    CONDFR_norip_IntAll(end+1:end+length(CONDFR_norip_Int{i})) = CONDFR_norip_Int{i};
    
    PartProbPre_rip_PyrAll(end+1:end+length(PartProbPre_rip_Pyr{i})) = PartProbPre_rip_Pyr{i};
    PartProbPost_rip_PyrAll(end+1:end+length(PartProbPost_rip_Pyr{i})) = PartProbPost_rip_Pyr{i};
    PartProbPre_rip_IntAll(end+1:end+length(PartProbPre_rip_Int{i})) = PartProbPre_rip_Int{i};
    PartProbPost_rip_IntAll(end+1:end+length(PartProbPost_rip_Int{i})) = PartProbPost_rip_Int{i};
    PartProbCond_rip_PyrAll(end+1:end+length(PartProbCond_rip_Pyr{i})) = PartProbCond_rip_Pyr{i};
    PartProbCond_rip_IntAll(end+1:end+length(PartProbCond_rip_Int{i})) = PartProbCond_rip_Int{i};
end
PREFR_SWS_PyrAll(1) = [];
PREFR_REM_PyrAll(1) = [];
POSTFR_SWS_PyrAll(1) = [];
POSTFR_REM_PyrAll(1) = [];
PREFR_SWS_IntAll(1) = [];
PREFR_REM_IntAll(1) = [];
POSTFR_SWS_IntAll(1) = [];
POSTFR_REM_IntAll(1) = [];

PREFR_rip_PyrAll(1) = [];
PREFR_norip_PyrAll(1) = [];
POSTFR_rip_PyrAll(1) = [];
POSTFR_norip_PyrAll(1) = [];
PREFR_rip_IntAll(1) = [];
PREFR_norip_IntAll(1) = [];
POSTFR_rip_IntAll(1) = [];
POSTFR_norip_IntAll(1) = [];
CONDFR_rip_PyrAll(1) = [];
CONDFR_norip_PyrAll(1) = [];
CONDFR_rip_IntAll(1) = [];
CONDFR_norip_IntAll(1) = [];

PartProbPre_rip_PyrAll(1) = [];
PartProbPost_rip_PyrAll(1) = [];
PartProbPre_rip_IntAll(1) = [];
PartProbPost_rip_IntAll(1) = [];
PartProbCond_rip_PyrAll(1) = [];
PartProbCond_rip_IntAll(1) = [];

%% Save
clear beh Cols count Dir dir_out fh fig_post h5 i idx_Pyr j k Mice_to_analyze NoRipPost NoRipPre old p PFidx Pl...
    rip RipIS RipISPre RipISPost REMPost REMPre RipSt sav sleepscored SPyr SInt spikes stats SWSPre SWSPost temp1 temp2

save('/home/mobsrick/Dropbox/MOBS_workingON/Dima/Data_temp/NeuronPyrInt.mat');

%% Figure Pyr Sleep

Pl = {PREFR_SWS_PyrAll; POSTFR_SWS_PyrAll; PREFR_REM_PyrAll; POSTFR_REM_PyrAll};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'Pyr in Pre-NREM','Pyr in Post-NREM','Pyr in Pre-REM','Pyr in Post-REM'})
ylim([0 2])
ylabel('Mean firing rate (Hz)')
title('Firing rate of Pyr in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Pyr_FR_Sleep.fig');
    saveFigure(gcf,'Pyr_FR_Sleep',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_SWS_PyrAll,POSTFR_SWS_PyrAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-NREM')
ylabel('Post-NREM')
subplot(122)
scatter(PREFR_REM_PyrAll,POSTFR_REM_PyrAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-REM')
ylabel('Post-REM')


fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_SWS_PyrAll,PREFR_REM_PyrAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-NREM')
ylabel('Pre-REM')
subplot(122)
scatter(POSTFR_SWS_PyrAll,POSTFR_REM_PyrAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Post-NREM')
ylabel('Post-REM')


saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/Pyr_Int/1_PyrFR_Mean.fig');
saveFigure(fh, '1_PyrFR_Mean', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/Pyr_Int/');
close(fh)

%% Figure Int Sleep

Pl = {PREFR_SWS_IntAll; POSTFR_SWS_IntAll; PREFR_REM_IntAll; POSTFR_REM_IntAll};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',18);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',18);
end
[p,h5,stats] = signrank(Pl{1},Pl{3});
if p < 0.05
    sigstar_DB({{1,3}},p,0, 'StarSize',18);
end
[p,h5,stats] = signrank(Pl{2},Pl{4});
if p < 0.05
    sigstar_DB({{2,4}},p,0, 'StarSize',18);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'Int in Pre-NREM','Int in Post-NREM','Int in Pre-REM','Int in Post-REM'})
% ylim([0.15 0.9])
ylabel('Mean firing rate (Hz)')
title('Firing rate of Int in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Int_FR_Sleep.fig');
    saveFigure(gcf,'Int_FR_Sleep',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_SWS_IntAll,POSTFR_SWS_IntAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre-NREM')
ylabel('Post-NREM')
subplot(122)
scatter(PREFR_REM_IntAll,POSTFR_REM_IntAll, 50, ...
    'filled', 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0]);
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3);
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre-REM')
ylabel('Post-REM')

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Int_scatter_Pre_Post.fig');
    saveFigure(gcf,'Int_scatter_Pre_Post',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end


fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_SWS_IntAll,PREFR_REM_IntAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre-NREM')
ylabel('Pre-REM')
subplot(122)
scatter(POSTFR_SWS_IntAll,POSTFR_REM_IntAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Post-NREM')
ylabel('Post-REM')

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Int_scatter_NREM_REM.fig');
    saveFigure(gcf,'Int_scatter_NREM_REM',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

%% Figure Pyr ripples FR

Pl = {PREFR_rip_PyrAll; PREFR_norip_PyrAll; POSTFR_rip_PyrAll; POSTFR_norip_PyrAll};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'ripples in Pre','no ripples in Pre','ripples in Post','no ripples in Post'})
% ylim([0.15 0.9])
ylabel('Mean firing rate (Hz)')
title('Firing rate Pyr during ripples in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Rip_FR_Pyr.fig');
    saveFigure(gcf,'Rip_FR_Pyr',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.3 0.5]);
% subplot(121)
scatter(PREFR_rip_PyrAll,POSTFR_rip_PyrAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre')
ylabel('Post')


if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Rip_FR_Pyr_PrePost_Scatter.fig');
    saveFigure(gcf,'Rip_FR_Pyr_PrePost_Scatter',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

%% Figure Int ripples FR

Pl = {PREFR_rip_IntAll; PREFR_norip_IntAll; POSTFR_rip_IntAll; POSTFR_norip_IntAll};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'ripples in Pre','no ripples in Pre','ripples in Post','no ripples in Post'})
% ylim([0.15 0.9])
ylabel('Mean firing rate (Hz)')
title('Firing rate Int during ripples in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Rip_FR_Int.fig');
    saveFigure(gcf,'Rip_FR_Int',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.3 0.5]);
% subplot(121)
scatter(PREFR_rip_IntAll,POSTFR_rip_IntAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre')
ylabel('Post')

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Rip_FR_Int_PrePost_Scatter.fig');
    saveFigure(gcf,'Rip_Int_Pyr_PrePost_Scatter',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end
%% Figure Int ripples FR

Pl = {PartProbPre_rip_PyrAll; PartProbPost_rip_PyrAll; PartProbPre_rip_IntAll; PartProbPost_rip_IntAll};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1:4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',14);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',14);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'Pyr in Pre','Pyr in Post','Int in Pre','Int in Post'})
% ylim([0.15 0.9])
ylabel('Participation probabilty')
title('Patricipation probability in ripples')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Ripprob_FR.fig');
    saveFigure(gcf,'Ripprob_FR',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PartProbPre_rip_PyrAll,PartProbPost_rip_PyrAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if max(xlim)>=1 || max(ylim) >=1
if max(xlim)>=max(ylim)
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
else
    plot([0:1],[0:1],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre-Pyr')
ylabel('Post-Pyr')
subplot(122)
scatter(PartProbPre_rip_IntAll,PartProbPost_rip_IntAll, 50, ...
    'filled','MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 0])
hold on
if max(xlim)>=max(ylim)
    plot([0:max(xlim)],[0:max(xlim)],'Color','k', 'LineWidth',3)
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k', 'LineWidth',3)
end
set(gca,'LineWidth',3,'FontSize',16,'FontWeight','bold');
xlabel('Pre-Int')
ylabel('Post-Int')

if sav
    saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/Ripprob_FR_scatter.fig');
    saveFigure(gcf,'Ripprob_FR_scatter',...
        '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics/Pyr_Int/');
end
