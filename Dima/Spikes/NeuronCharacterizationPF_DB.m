%% Parameters
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/';
fig_post = 'FRduringRipples';
% Before Vtsd correction == 1
old = 0;
sav = 0;
% Numbers of mice to run analysis on
Mice_to_analyze = [797 798 828 861 882 905 906 911 912 977];
% PFidx{1} = [27 32];
% PFidx{2} = 12;
% PFidx{3} = [17 18 19 27];
% PFidx{4} = [5 8 17 18];
% PFidx{5} = [56 58 61 63];

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

%% Get data

for i = 1:length(Dir.path)
    beh{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'SessionEpoch');
    rip{i} = load([Dir.path{i}{1} '/Ripples.mat'], 'ripples');
    spikes{i} = load([Dir.path{i}{1} '/SpikeData.mat'], 'S', 'BasicNeuronInfo', 'PlaceCells');
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    else
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    end
end

%% Calculate

for i=1:length(Dir.path)
    RipIS{i}=intervalSet(rip{i}.ripples(:,1)*1E4, rip{i}.ripples(:,3)*1E4);
    RipSt{i} = Start(RipIS{i});
    % Get pyramidal cells
    if ~isempty(spikes{i}.PlaceCells.idx)
        SPF{i} = spikes{i}.S(spikes{i}.PlaceCells.idx);
        SnoPF{i} = spikes{i}.S(intersect(setdiff(spikes{i}.BasicNeuronInfo.idx_SUA,spikes{i}.PlaceCells.idx),...
            find(spikes{i}.BasicNeuronInfo.neuroclass>0)));
    else
        SPF{i}=[];
        SnoPF{i} = [];
    end
    
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
    for j = 1:length(SPF{i})
        if ~isempty(SPF{i})
            temp1 = Restrict(SPF{i}{j}, SWSPre{i});
            temp2 = Restrict(SPF{i}{j}, REMPre{i});
            PREFR_SWS_PF{i}(j) = length(temp1) / (sum(End(SWSPre{i} ) - Start(SWSPre{i}))/1e4);
            PREFR_REM_PF{i}(j) = length(temp2) / (sum(End(REMPre{i} ) - Start(REMPre{i}))/1e4);
            temp1 = Restrict(SPF{i}{j}, SWSPost{i});
            temp2 = Restrict(SPF{i}{j}, REMPost{i});
            POSTFR_SWS_PF{i}(j) = length(temp1) / (sum(End(SWSPost{i} ) - Start(SWSPost{i}))/1e4);
            POSTFR_REM_PF{i}(j) = length(temp2) / (sum(End(REMPost{i} ) - Start(REMPost{i}))/1e4);
        else
            PREFR_SWS_PF{i} = [];
            PREFR_REM_PF{i} = [];
            POSTFR_SWS_PF{i} = [];
            POSTFR_REM_PF{i} = [];
        end
    end
    clear temp1 temp2
    % FR in SWS Pre and Post / Int
    for j = 1:length(SnoPF{i})
        if ~isempty(SnoPF{i})
            temp1 = Restrict(SnoPF{i}{j}, SWSPre{i});
            temp2 = Restrict(SnoPF{i}{j}, REMPre{i});
            PREFR_SWS_noPF{i}(j) = length(temp1) / (sum(End(SWSPre{i} ) - Start(SWSPre{i}))/1e4);
            PREFR_REM_noPF{i}(j) = length(temp2) / (sum(End(REMPre{i} ) - Start(REMPre{i}))/1e4);
            temp1 = Restrict(SnoPF{i}{j}, SWSPost{i});
            temp2 = Restrict(SnoPF{i}{j}, REMPost{i});
            POSTFR_SWS_noPF{i}(j) = length(temp1) / (sum(End(SWSPost{i} ) - Start(SWSPost{i}))/1e4);
            POSTFR_REM_noPF{i}(j) = length(temp2) / (sum(End(REMPost{i} ) - Start(REMPost{i}))/1e4);
        else
            PREFR_SWS_noPF{i} = [];
            PREFR_REM_noPF{i} = [];
            POSTFR_SWS_noPF{i} = [];
            POSTFR_REM_noPF{i} = [];
        end
    end
    clear temp1 temp2
    % Ripples Pyr Pre/Post
    NoRipPre = beh{i}.SessionEpoch.PreSleep-RipISPre{i};
    for j=1:length(SPF{i})
        if ~isempty(SPF{i})
            temp1 = Restrict(SPF{i}{j}, RipISPre{i});
            temp2 = Restrict(SPF{i}{j}, NoRipPre);
            PREFR_rip_PF{i}(j) = length(temp1) / (sum(End(RipISPre{i} ) - Start(RipISPre{i}))/1e4);
            PREFR_norip_PF{i}(j) = length(temp2) / (sum(End(NoRipPre) - Start(NoRipPre))/1e4);
        else
            PREFR_rip_PF{i} = [];
            PREFR_norip_PF{i} = [];
        end
    end
    clear temp1 temp2
    NoRipPost = beh{i}.SessionEpoch.PostSleep-RipISPost{i};
    for j=1:length(SPF{i})
        if ~isempty(SPF{i})
            temp1 = Restrict(SPF{i}{j}, RipISPost{i});
            temp2 = Restrict(SPF{i}{j}, NoRipPost);
            POSTFR_rip_PF{i}(j) = length(temp1) / (sum(End(RipISPost{i} ) - Start(RipISPost{i}))/1e4);
            POSTFR_norip_PF{i}(j) = length(temp2) / (sum(End(NoRipPost) - Start(NoRipPost))/1e4);
        else
            POSTFR_rip_PF{i} = [];
            POSTFR_norip_PF{i} = [];
        end
    end
    
    % Cond PF
    NoRipCond = CondEpoch{i}-RipISCond{i};
    for j=1:length(SPF{i})
        if ~isempty(SPF{i})
            temp1 = Restrict(SPF{i}{j}, RipISCond{i});
            temp2 = Restrict(SPF{i}{j}, NoRipCond);
            CONDFR_rip_PF{i}(j) = length(temp1) / (sum(End(RipISCond{i} ) - Start(RipISCond{i}))/1e4);
            CONDFR_norip_PF{i}(j) = length(temp2) / (sum(End(NoRipCond) - Start(NoRipCond))/1e4);
        else
            CONDFR_rip_PF{i} = [];
            CONDFR_norip_PF{i} = [];
        end
    end
    clear temp1 temp2
    for j=1:length(SnoPF{i})
        if ~isempty(SnoPF{i})
            temp1 = Restrict(SnoPF{i}{j}, RipISCond{i});
            temp2 = Restrict(SnoPF{i}{j}, NoRipCond);
            CONDFR_rip_noPF{i}(j) = length(temp1) / (sum(End(RipISCond{i} ) - Start(RipISCond{i}))/1e4);
            CONDFR_norip_noPF{i}(j) = length(temp2) / (sum(End(NoRipCond) - Start(NoRipCond))/1e4);
        else
            CONDFR_rip_noPF{i} = [];
            CONDFR_norip_noPF{i} = [];
        end
    end
    % Ripples Int Pre/Post
    clear temp1 temp2 NoRipPre NoRipPost
    NoRipPre = beh{i}.SessionEpoch.PreSleep-RipISPre{i};
    for j=1:length(SnoPF{i})
        if ~isempty(SnoPF{i})
            temp1 = Restrict(SnoPF{i}{j}, RipISPre{i});
            temp2 = Restrict(SnoPF{i}{j}, NoRipPre);
            PREFR_rip_noPF{i}(j) = length(temp1) / (sum(End(RipISPre{i} ) - Start(RipISPre{i}))/1e4);
            PREFR_norip_noPF{i}(j) = length(temp2) / (sum(End(NoRipPre) - Start(NoRipPre))/1e4);
        else
            PREFR_rip_noPF{i} = [];
            PREFR_norip_noPF{i} = [];
        end
    end
    clear temp1 temp2
    NoRipPost = beh{i}.SessionEpoch.PostSleep-RipISPost{i};
    for j=1:length(SnoPF{i})
        if ~isempty(SnoPF{i})
            temp1 = Restrict(SnoPF{i}{j}, RipISPost{i});
            temp2 = Restrict(SnoPF{i}{j}, NoRipPost);
            POSTFR_rip_noPF{i}(j) = length(temp1) / (sum(End(RipISPost{i} ) - Start(RipISPost{i}))/1e4);
            POSTFR_norip_noPF{i}(j) = length(temp2) / (sum(End(NoRipPost) - Start(NoRipPost))/1e4);
        else
            POSTFR_rip_noPF{i} = [];
            POSTFR_norip_noPF{i} = [];
        end
    end
    
    % Probability to fire during ripples (participation probability) / Pyr
    for j=1:length(SPF{i})
        if ~isempty(SPF{i})
            count = zeros(1,length(Start(RipISPre{i})));
            for k = 1:length(Start(RipISPre{i}))
                if ~isempty(Data(Restrict(SPF{i}{j},subset(RipISPre{i},k))))
                    count(k) = 1;
                else
                    count(k) = 0;
                end
            end
            PartProbPre_rip_PF{i}(j) = sum(count)/length(Start(RipISPre{i}));
            count = zeros(1,length(Start(RipISPost{i})));
            for k = 1:length(Start(RipISPost{i}))
                if ~isempty(Data(Restrict(SPF{i}{j},subset(RipISPost{i},k))))
                    count(k) = 1;
                else
                    count(k) = 0;
                end
            end
            PartProbPost_rip_PF{i}(j) = sum(count)/length(Start(RipISPost{i}));
            count = zeros(1,length(Start(RipISCond{i})));
            for k = 1:length(Start(RipISCond{i}))
                if ~isempty(Data(Restrict(SPF{i}{j},subset(RipISCond{i},k))))
                    count(k) = 1;
                else
                    count(k) = 0;
                end
            end
            PartProbCond_rip_PF{i}(j) = sum(count)/length(Start(RipISPost{i}));
        else
            PartProbPre_rip_PF{i} = [];
            PartProbPost_rip_PF{i} = [];
            PartProbCond_rip_PF{i} = [];
        end
    end
    % Probability to fire during ripples (participation probability) / Int
    for j=1:length(SnoPF{i})
        if ~isempty(SnoPF{i})
            count = zeros(1,length(Start(RipISPre{i})));
            for k = 1:length(Start(RipISPre{i}))
                if ~isempty(Data(Restrict(SnoPF{i}{j},subset(RipISPre{i},k))))
                    count(k) = 1;
                else
                    count(k) = 0;
                end
            end
            PartProbPre_rip_noPF{i}(j) = sum(count)/length(Start(RipISPre{i}));
            count = zeros(1,length(Start(RipISPost{i})));
            for k = 1:length(Start(RipISPost{i}))
                if ~isempty(Data(Restrict(SnoPF{i}{j},subset(RipISPost{i},k))))
                    count(k) = 1;
                else
                    count(k) = 0;
                end
            end
            PartProbPost_rip_noPF{i}(j) = sum(count)/length(Start(RipISPost{i}));
            count = zeros(1,length(Start(RipISCond{i})));
            for k = 1:length(Start(RipISCond{i}))
                if ~isempty(Data(Restrict(SnoPF{i}{j},subset(RipISCond{i},k))))
                    count(k) = 1;
                else
                    count(k) = 0;
                end
            end
            PartProbCond_rip_noPF{i}(j) = sum(count)/length(Start(RipISCond{i}));
        else
            PartProbPre_rip_noPF{i} = [];
            PartProbPost_rip_noPF{i} = [];
            PartProbCond_rip_noPF{i} = [];
        end
    end
    
    
    %     % Spike ripple probability (probability of any ripple to harbor spikes)
    %     SPF_Pool{i} = PoolNeurons(SPF{i},[1:length(SPF{i})]);
    %     count = zeros(1,length(Start(RipISPre{i})));
    %     for k = 1:length(Start(RipISPre{i}))
    %         if ~isempty(Data(Restrict(SPF{i}{j},subset(RipISPre{i},k))))
    %             count(k) = 1;
    %         else
    %             count(k) = 0;
    %         end
    %     end
    %     RippSpikeProbPre_rip_PF(i) = sum(count)/(sum(End(NoRipPost) - Start(NoRipPost))/1e4);
    %     count = zeros(1,length(Start(RipISPost{i})));
    %     for k = 1:length(Start(RipISPost{i}))
    %         if ~isempty(Data(Restrict(SPF{i}{j},subset(RipISPost{i},k))))
    %             count(k) = 1;
    %         else
    %             count(k) = 0;
    %         end
    %     end
    %     RippSpikeProbPost_rip_PF(i) = sum(count)(sum(End(RipISPost{i}) - Start(RipISPost{i}))/1e4);
    
end
%% Average
for i = 1:length(Dir.path)
    PREFR_SWS_PFMean(i) = mean(PREFR_SWS_PF{i});
    PREFR_REM_PFMean(i) = mean(PREFR_REM_PF{i});
    POSTFR_SWS_PFMean(i) = mean(POSTFR_SWS_PF{i});
    POSTFR_REM_PFMean(i) = mean(POSTFR_REM_PF{i});
    PREFR_SWS_noPFMean(i) = mean(PREFR_SWS_noPF{i});
    PREFR_REM_noPFMean(i) = mean(PREFR_REM_noPF{i});
    POSTFR_SWS_noPFMean(i) = mean(POSTFR_SWS_noPF{i});
    POSTFR_REM_noPFMean(i) = mean(POSTFR_REM_noPF{i});
    
    PREFR_rip_PFMean(i) = mean(PREFR_rip_PF{i});
    PREFR_norip_PFMean(i) = mean(PREFR_norip_PF{i});
    POSTFR_rip_PFMean(i) = mean(POSTFR_rip_PF{i});
    POSTFR_norip_PFMean(i) = mean(POSTFR_norip_PF{i});
    PREFR_rip_noPFMean(i) = mean(PREFR_rip_noPF{i});
    PREFR_norip_noPFMean(i) = mean(PREFR_norip_noPF{i});
    POSTFR_rip_noPFMean(i) = mean(POSTFR_rip_noPF{i});
    POSTFR_norip_noPFMean(i) = mean(POSTFR_norip_noPF{i});
    CONDFR_rip_PFMean(i) = mean(CONDFR_rip_PF{i});
    CONDFR_norip_PFMean(i) = mean(CONDFR_norip_PF{i});
    CONDFR_rip_noPFMean(i) = mean(CONDFR_rip_noPF{i});
    CONDFR_norip_noPFMean(i) = mean(CONDFR_norip_noPF{i});
    
    PartProbPre_rip_PFMean(i) = mean(PartProbPre_rip_PF{i});
    PartProbPost_rip_PFMean(i) = mean(PartProbPost_rip_PF{i});
    PartProbPre_rip_noPFMean(i) = mean(PartProbPre_rip_noPF{i});
    PartProbPost_rip_noPFMean(i) = mean(PartProbPost_rip_noPF{i});
    PartProbCond_rip_PFMean(i) = mean(PartProbCond_rip_PF{i});
    PartProbCond_rip_noPFMean(i) = mean(PartProbCond_rip_noPF{i});
end

%% Pool all neurons
PREFR_SWS_PFAll = 0;
PREFR_REM_PFAll = 0;
POSTFR_SWS_PFAll = 0;
POSTFR_REM_PFAll = 0;
PREFR_SWS_noPFAll = 0;
PREFR_REM_noPFAll = 0;
POSTFR_SWS_noPFAll = 0;
POSTFR_REM_noPFAll = 0;

PREFR_rip_PFAll = 0;
PREFR_norip_PFAll = 0;
POSTFR_rip_PFAll = 0;
POSTFR_norip_PFAll = 0;
PREFR_rip_noPFAll = 0;
PREFR_norip_noPFAll = 0;
POSTFR_rip_noPFAll = 0;
POSTFR_norip_noPFAll = 0;
CONDFR_rip_PFAll = 0;
CONDFR_norip_PFAll = 0;
CONDFR_rip_noPFAll = 0;
CONDFR_norip_noPFAll = 0;

PartProbPre_rip_PFAll = 0;
PartProbPost_rip_PFAll = 0;
PartProbPre_rip_noPFAll = 0;
PartProbPost_rip_noPFAll = 0;
PartProbCond_rip_PFAll = 0;
PartProbCond_rip_noPFAll = 0;
for i = 1:length(Dir.path)
    PREFR_SWS_PFAll(end+1:end+length(PREFR_SWS_PF{i})) = PREFR_SWS_PF{i};
    PREFR_REM_PFAll(end+1:end+length(PREFR_REM_PF{i})) = PREFR_REM_PF{i};
    POSTFR_SWS_PFAll(end+1:end+length(POSTFR_SWS_PF{i})) = POSTFR_SWS_PF{i};
    POSTFR_REM_PFAll(end+1:end+length(POSTFR_REM_PF{i})) = POSTFR_REM_PF{i};
    PREFR_SWS_noPFAll(end+1:end+length(PREFR_SWS_noPF{i})) = PREFR_SWS_noPF{i};
    PREFR_REM_noPFAll(end+1:end+length(PREFR_REM_noPF{i})) = PREFR_REM_noPF{i};
    POSTFR_SWS_noPFAll(end+1:end+length(POSTFR_SWS_noPF{i})) = POSTFR_SWS_noPF{i};
    POSTFR_REM_noPFAll(end+1:end+length(POSTFR_REM_noPF{i})) = POSTFR_REM_noPF{i};
    
    PREFR_rip_PFAll(end+1:end+length(PREFR_rip_PF{i})) = PREFR_rip_PF{i};
    PREFR_norip_PFAll(end+1:end+length(PREFR_norip_PF{i})) = PREFR_norip_PF{i};
    POSTFR_rip_PFAll(end+1:end+length(POSTFR_rip_PF{i})) = POSTFR_rip_PF{i};
    POSTFR_norip_PFAll(end+1:end+length(POSTFR_norip_PF{i})) = POSTFR_norip_PF{i};
    PREFR_rip_noPFAll(end+1:end+length(PREFR_rip_noPF{i})) = PREFR_rip_noPF{i};
    PREFR_norip_noPFAll(end+1:end+length(PREFR_norip_noPF{i})) = PREFR_norip_noPF{i};
    POSTFR_rip_noPFAll(end+1:end+length(POSTFR_rip_noPF{i})) = POSTFR_rip_noPF{i};
    POSTFR_norip_noPFAll(end+1:end+length(POSTFR_norip_noPF{i})) = POSTFR_norip_noPF{i};
    CONDFR_rip_PFAll(end+1:end+length(CONDFR_rip_PF{i})) = CONDFR_rip_PF{i};
    CONDFR_norip_PFAll(end+1:end+length(CONDFR_norip_PF{i})) = CONDFR_norip_PF{i};
    CONDFR_rip_noPFAll(end+1:end+length(CONDFR_rip_noPF{i})) = CONDFR_rip_noPF{i};
    CONDFR_norip_noPFAll(end+1:end+length(CONDFR_norip_noPF{i})) = CONDFR_norip_noPF{i};
    
    PartProbPre_rip_PFAll(end+1:end+length(PartProbPre_rip_PF{i})) = PartProbPre_rip_PF{i};
    PartProbPost_rip_PFAll(end+1:end+length(PartProbPost_rip_PF{i})) = PartProbPost_rip_PF{i};
    PartProbPre_rip_noPFAll(end+1:end+length(PartProbPre_rip_noPF{i})) = PartProbPre_rip_noPF{i};
    PartProbPost_rip_noPFAll(end+1:end+length(PartProbPost_rip_noPF{i})) = PartProbPost_rip_noPF{i};
    PartProbCond_rip_PFAll(end+1:end+length(PartProbCond_rip_PF{i})) = PartProbCond_rip_PF{i};
    PartProbCond_rip_noPFAll(end+1:end+length(PartProbCond_rip_noPF{i})) = PartProbCond_rip_noPF{i};
end
PREFR_SWS_PFAll(1) = [];
PREFR_REM_PFAll(1) = [];
POSTFR_SWS_PFAll(1) = [];
POSTFR_REM_PFAll(1) = [];
PREFR_SWS_noPFAll(1) = [];
PREFR_REM_noPFAll(1) = [];
POSTFR_SWS_noPFAll(1) = [];
POSTFR_REM_noPFAll(1) = [];

PREFR_rip_PFAll(1) = [];
PREFR_norip_PFAll(1) = [];
POSTFR_rip_PFAll(1) = [];
POSTFR_norip_PFAll(1) = [];
PREFR_rip_noPFAll(1) = [];
PREFR_norip_noPFAll(1) = [];
POSTFR_rip_noPFAll(1) = [];
POSTFR_norip_noPFAll(1) = [];
CONDFR_rip_PFAll(1) = [];
CONDFR_norip_PFAll(1) = [];
CONDFR_rip_noPFAll(1) = [];
CONDFR_norip_noPFAll(1) = [];

PartProbPre_rip_PFAll(1) = [];
PartProbPost_rip_PFAll(1) = [];
PartProbPre_rip_noPFAll(1) = [];
PartProbPost_rip_noPFAll(1) = [];
PartProbCond_rip_PFAll(1) = [];
PartProbCond_rip_noPFAll(1) = [];

% Get random noPF with 

%% Save
clear beh Cols count Dir dir_out fh fig_post h5 i idx_Pyr j k Mice_to_analyze NoRipPost NoRipPre old p PFidx Pl...
    rip RipIS RipISPre RipISPost REMPost REMPre RipSt sav sleepscored SnoPF SPF spikes stats SWSPre SWSPost temp1 temp2

save('/home/mobsrick/Dropbox/MOBS_workingON/Dima/Data_temp/NeuronPF.mat');

%% Figure Pyr Sleep

Pl = {PREFR_SWS_PFAll; POSTFR_SWS_PFAll; PREFR_REM_PFAll; POSTFR_REM_PFAll};

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
    'XTickLabel',{'Pre-NREM','Post-NREM','Pre-REM','Post-REM'})
% ylim([0.15 0.9])
ylabel('Mean firing rate (Hz)')
title('Firing rate of cells with PF in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_SWS_PFAll,POSTFR_SWS_PFAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-NREM')
ylabel('Post-NREM')
subplot(122)
scatter(PREFR_REM_PFAll,POSTFR_REM_PFAll)
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
scatter(PREFR_SWS_PFAll,PREFR_REM_PFAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-NREM')
ylabel('Pre-REM')
subplot(122)
scatter(POSTFR_SWS_PFAll,POSTFR_REM_PFAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Post-NREM')
ylabel('Post-REM')

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/1_PyrFR_Mean.fig');
saveFigure(fh, '1_PyrFR_Mean', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)

%% Figure Int Sleep

Pl = {PREFR_SWS_noPFAll; POSTFR_SWS_noPFAll; PREFR_REM_noPFAll; POSTFR_REM_noPFAll};

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
    'XTickLabel',{'Pre-NREM','Post-NREM','Pre-REM','Post-REM'})
% ylim([0.15 0.9])
ylabel('Mean firing rate (Hz)')
title('Firing rate of cells without PF in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_SWS_PFAll,datasample(PREFR_SWS_noPFAll,length(PREFR_SWS_PFAll)))
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-NREM-PF')
ylabel('Pre-NREM-noPF')
subplot(122)
scatter(PREFR_REM_PFAll,datasample(PREFR_REM_noPFAll,length(PREFR_REM_PFAll)))
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre-REM-PF')
ylabel('Pre-REM-noPF')


fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(POSTFR_SWS_PFAll,datasample(POSTFR_SWS_noPFAll,length(POSTFR_SWS_PFAll)))
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Post-NREM-PF')
ylabel('Post-NREM-noPF')
subplot(122)
scatter(POSTFR_REM_PFAll,datasample(POSTFR_REM_noPFAll,length(POSTFR_REM_PFAll)))
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Post-NREM-PF')
ylabel('Post-NREM-noPF')


saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/2_IntFR_Mean.fig');
saveFigure(fh, '2_IntFR_Mean', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)


%% Figure Pyr ripples FR

Pl = {PREFR_rip_PFAll; PREFR_norip_PFAll; POSTFR_rip_PFAll; POSTFR_norip_PFAll};

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
title('Firing rate cells with PF during ripples in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PREFR_rip_PFAll,POSTFR_rip_PFAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre')
ylabel('Post')
subplot(122)
scatter(PREFR_rip_noPFAll,POSTFR_rip_noPFAll)
hold on
if xlim>=ylim
    plot([0:max(xlim)],[0:max(xlim)],'Color','k')
else
    plot([0:max(ylim)],[0:max(ylim)],'Color','k')
end
xlabel('Pre')
ylabel('Post')


saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/3_PyrFRRipples_Mean.fig');
saveFigure(fh, '3_PyrFRRipples_Mean', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)


%% Figure Int ripples FR

Pl = {PREFR_rip_noPFAll; PREFR_norip_noPFAll; POSTFR_rip_noPFAll; POSTFR_norip_noPFAll};

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
title('Firing rate cells without PF during ripples in sleep')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/4_IntFRRipples_Mean.fig');
saveFigure(fh, '4_IntFRRipples_Mean', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)


%% Figure Int ripples FR

Pl = {PartProbPre_rip_PFAll; PartProbPost_rip_PFAll; PartProbPre_rip_noPFAll; PartProbPost_rip_noPFAll};

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
    'XTickLabel',{'PF in Pre','noPF in Post','PF in Pre','noPF in Post'})
% ylim([0.15 0.9])
ylabel('Participation probabilty')
title('Patricipation probability in ripples')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.7]);
subplot(121)
scatter(PartProbPre_rip_PFAll,PartProbPost_rip_PFAll)
hold on
if max(xlim) >=1 || max(ylim)>=1
    if xlim>=ylim
        plot([0:max(xlim)],[0:max(xlim)],'Color','k')
    else
        plot([0:max(ylim)],[0:max(ylim)],'Color','k')
    end
else
    plot([0:1],[0:1],'Color','k')
end
xlabel('Pre')
ylabel('Post')
subplot(122)
scatter(PartProbPre_rip_noPFAll,PartProbPost_rip_noPFAll)
hold on
if max(xlim) >=1 || max(ylim)>=1
    if xlim>=ylim
        plot([0:max(xlim)],[0:max(xlim)],'Color','k')
    else
        plot([0:max(ylim)],[0:max(ylim)],'Color','k')
    end
else
    plot([0:1],[0:1],'Color','k')
end
xlabel('Pre')
ylabel('Post')


saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/5_ProbRipples_Mean.fig');
saveFigure(fh, '5_ProbRipples_Mean', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)

%% Plot FR NREM/REM
fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.9]);

subplot(151)
[A,sid] = sort(PREFR_SWS_PFAll);
Pl = [A' PREFR_REM_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'NREM','REM'})
title('PF in Pre')
clear A sid Pl
subplot(152)
[A,sid] = sort(POSTFR_SWS_PFAll);
Pl = [A' POSTFR_REM_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'NREM','REM'})
title('PF in Post')
clear A sid Pl

subplot(154)
[A,sid] = sort(PREFR_SWS_noPFAll);
Pl = [A' PREFR_REM_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'NREM','REM'})
title('noPF in Pre')
clear A sid Pl
subplot(155)
[A,sid] = sort(POSTFR_SWS_noPFAll);
Pl = [A' POSTFR_REM_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'NREM','REM'})
title('noPF in Post')
clear A sid Pl

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/1_FRSleep_All.fig');
saveFigure(fh, '1_FRSleep_All', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)

%% Plot FR Pre/Post
fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.9]);

subplot(151)
[A,sid] = sort(PREFR_SWS_PFAll);
Pl = [A' POSTFR_SWS_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'Pre','Post'})
title('PF in NREM')
clear A sid Pl
subplot(152)
[A,sid] = sort(PREFR_REM_PFAll);
Pl = [A' POSTFR_REM_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'Pre','Post'})
title('PF in REM')
clear A sid Pl

subplot(154)
[A,sid] = sort(PREFR_SWS_noPFAll);
Pl = [A' POSTFR_SWS_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'Pre','Post'})
title('noPF in NREM')
clear A sid Pl
subplot(155)
[A,sid] = sort(PREFR_REM_noPFAll);
Pl = [A' POSTFR_REM_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,...
    'XTickLabel',{'Pre','Post'})
title('noPF in REM')
clear A sid Pl

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/2_FRSleep_All.fig');
saveFigure(fh, '2_FRSleep_All', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)

%% Plot FR during ripples Pre/Post
fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.8 0.9]);

subplot(151)
[A,sid] = sort(PREFR_rip_PFAll);
Pl = [A' CONDFR_rip_PFAll(sid)' POSTFR_rip_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:3,...
    'XTickLabel',{'Pre','Cond','Post'})
title('PF during ripples')
clear A sid Pl
subplot(152)
[A,sid] = sort(PREFR_norip_PFAll);
Pl = [A' CONDFR_norip_PFAll(sid)' POSTFR_norip_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:3,...
    'XTickLabel',{'Pre','Cond','Post'})
title('PF outside ripples')
clear A sid Pl

subplot(154)
[A,sid] = sort(PREFR_rip_noPFAll);
Pl = [A' CONDFR_rip_noPFAll(sid)' POSTFR_rip_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:3,...
    'XTickLabel',{'Pre','Cond','Post'})
title('noPF during ripples')
clear A sid Pl
subplot(155)
[A,sid] = sort(PREFR_norip_noPFAll);
Pl = [A' CONDFR_norip_noPFAll(sid)' POSTFR_norip_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:3,...
    'XTickLabel',{'Pre','Cond','Post'})
title('noPF outside ripples')
clear A sid Pl

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/3_FRRipples_All.fig');
saveFigure(fh, '3_FRRipples_All', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)

%% Plot discharge probability ripples Pre/Post
fh = figure('units', 'normalized', 'outerposition', [0.1 0.2 0.6 0.9]);

subplot(121)
[A,sid] = sort(PartProbPre_rip_PFAll);
Pl = [A' PartProbCond_rip_PFAll(sid)' PartProbPost_rip_PFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:3,...
    'XTickLabel',{'Pre','Cond','Post'})
title('PF ripples probability')
colorbar
clear A sid Pl
subplot(122)
[A,sid] = sort(PartProbPre_rip_noPFAll);
Pl = [A' PartProbCond_rip_noPFAll(sid)' PartProbPost_rip_noPFAll(sid)'];
imagesc(Pl)
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:3,...
    'XTickLabel',{'Pre','Cond','Post'})
title('noPF ripples probability')
colorbar
clear A sid Pl

saveas(fh, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/4_ProbRipples_All.fig');
saveFigure(fh, '4_ProbRipples_All', '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Spikes/BasicCharacteristics_0819/PF/');
close(fh)