%function ExplainedVariance_AG(nmice)
% This is not relevant script. Please, refer to the ExplainedVariance_new_AG.m

%%%% ExplainedVariance_Kud1999_DB
%
%
% This script calculates explained variance (EV) and reverse EV
% the same manner it was calculated in Kudrimoti et al., 1999
%
% EV = ((R_task,post - R_task,pre*R_post,pre)/sqrt((1-R_task,pre.^2)(1-R_post,pre.^2))).^2;
%
% REV = ((R_task,pre - R_task,post*R_post,pre)/sqrt((1-R_task,post.^2)(1-R_post,pre.^2))).^2;
%
%
% Please go inside the script and check the parameters

% Three sets of data:
% - Sleep - Run - Sleep - Run (_full)
% - NREM - REM - Run - NREM - REM - Run (_stages)
% - NREM_Split - REM_Split - Run - NREM_Split - REM_Split - Run (_splitStages)
%
% Also conditioning but only for split data
%
% TODO (inspiration - Kudrimoti et al., 1999):
% - Control for FR of neurons
% - Plot mean pairwise correlations

%% Parameters
AddMyPaths_Arsenii;
% Mice which participate in the analysis

% nmice = [797 798 828 861 882 905 906 911 912 977 994 1117 1124 1161 1162 1168]; % Все мыши

% 828 912 1124 - исключены из анализа.
% 905 911 под вопросом
% 797 798 861 882 977 1117 не проходят threshold по PC

% nmice = [797 798 861 882 905 906 911 977 994 1117 1161 1162 1168]; % Мыши в анализе
nmice = [905 906 911 994 1161 1162 1168]; % Мыши в анализе

% Colors for plots
cols = {[0.2 0.2 0.2], [0.8 0.8 0.8]};

% Do you want to save the figures?
% IsSaveFig = false; %%% Does not work now

% Binsize for firing rate histogram (in tsd units!!!)
binsize = 0.1*1e4;

% Do you want to split NREM sleep epochs into several consecutive intervals (in min)?
% If not - put []. Note that number of intervals will be floor(40/splitSleep)
% It cannot be more than 40
splitSleep = 20;
if splitSleep > 20
    warning(['There is going to be only one interval: ' num2str(splitSleep) ' min']);
end

%% Allocate memory
% Get paths of each individual mouse
Dir = PathForExperimentsERC_Arsenii('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', nmice); %restrict on mice, which are used in this session (nmice)

if ~isempty(splitSleep)
    if splitSleep <= 20
        % Calculate number of intervals ~~~ !!! 40 min hardcoded !!! ~~~
        numint = floor(40/splitSleep);
        
        PreSleepSWS_Split = cell(1,length(Dir.path)); % interval set
        PostSleepSWS_Split = cell(1,length(Dir.path)); % interval set
        QPRESWS_Split = cell(1,length(Dir.path)); % firing rate histogram
        QPOSTSWS_Split = cell(1,length(Dir.path)); % firing rate histogram
        QTASK_Split = cell(1,length(Dir.path)); % firing rate histogram
        EVSWS_Split = cell(1,numint);
        REVSWS_Split = cell(1,numint);
        EVSWS_SplitCond = cell(1,numint);
        REVSWS_SplitCond = cell(1,numint);
        EVSWS_SplitCondFr = cell(1,numint);
        REVSWS_SplitCondFr = cell(1,numint);
        
        for j = 1:length(length(Dir.path))
            QPRESWS_Split{j} = cell(1,numint);
            QPOSTSWS_Split{j} = cell(1,numint);
        end
        for i=1:length(numint)
            EVSWS_Split{i} = zeros(1,length(Dir.path));
            REVSWS_Split{i} = zeros(1,length(Dir.path));
            EVSWS_SplitCond{i} = zeros(1,length(Dir.path));
            REVSWS_SplitCond{i} = zeros(1,length(Dir.path));
            EVSWS_SplitCondFr{i} = zeros(1,length(Dir.path));
            REVSWS_SplitCondFr{i} = zeros(1,length(Dir.path));
        end
    end
end

% firing rate histograms
QPRE = cell(1,length(Dir.path));
QPRESWS = cell(1,length(Dir.path));
QPREREM = cell(1,length(Dir.path));
QHAB = cell(1,length(Dir.path));
QTASK = cell(1,length(Dir.path));
QCOND = cell(1,length(Dir.path));
QCONDMOV = cell(1,length(Dir.path));
QCONDFR = cell(1,length(Dir.path));
QTASK_Whole = cell(1,length(Dir.path));
QTASK_WholeMov = cell(1,length(Dir.path));
QPOST = cell(1,length(Dir.path));
QPOSTSWS = cell(1,length(Dir.path));
QPOSTREM = cell(1,length(Dir.path));
QPOSTTEST = cell(1,length(Dir.path));

% Structure with correlation matrices
CorrM = cell(1,length(Dir.path));

% Explained variance and reverse explained variance
EV_whole = zeros(1,length(Dir.path));
REV_whole = zeros(1,length(Dir.path));
EV = zeros(1,length(Dir.path));
REV = zeros(1,length(Dir.path));
EVSWS = zeros(1,length(Dir.path));
REVSWS = zeros(1,length(Dir.path));
EVREM = zeros(1,length(Dir.path));
REVREM = zeros(1,length(Dir.path));

EV_hab_SWS = zeros(1,length(Dir.path));
EV_hab_REM = zeros(1,length(Dir.path));
REV_hab_SWS = zeros(1,length(Dir.path));
REV_hab_REM = zeros(1,length(Dir.path));
EV_cond_SWS = zeros(1,length(Dir.path));
EV_cond_REM = zeros(1,length(Dir.path));
REV_cond_SWS = zeros(1,length(Dir.path));
REV_cond_REM = zeros(1,length(Dir.path));
EV_fullwake_SWS = zeros(1,length(Dir.path));
REV_fullwake_SWS = zeros(1,length(Dir.path));
EV_fullwake_REM = zeros(1,length(Dir.path));
REV_fullwake_REM = zeros(1,length(Dir.path));



%% Load the data

for j=1:length(Dir.path)
    
    cd(Dir.path{j}{1});
    spikes{j} = load('SpikeData.mat','S','PlaceCells', 'RippleGroups', 'TT', 'BasicNeuronInfo');
end
%%
for j=1:length(Dir.path)
    % If there are less than 2 PCs - don't do
    if isfield(spikes{j}.PlaceCells,'idx')
        if length(spikes{j}.PlaceCells.idx)>2
            
            load('behavResources.mat','SessionEpoch', 'CleanVtsd', 'FreezeAccEpoch');
            load('Ripples.mat','ripples');
            if strcmp(Dir.name{j}, 'Mouse906') || strcmp(Dir.name{j}, 'Mouse977') || strcmp(Dir.name{j}, 'Mouse861')% Mice with bad OB-based sleep scoring
                load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch'); % Sleep is not used
            else
                load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch');  % Sleep is not used
            end
            
            %% Create interval sets (epochs)
            
            % Split epochs if necessary
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    PreSleepSWS_Split{j} = SplitIntervals(and(SessionEpoch.PreSleep, SWSEpoch),...
                        splitSleep*60*1e4);
                    PostSleepSWS_Split{j} = SplitIntervals(and(SessionEpoch.PostSleep, SWSEpoch),...
                        splitSleep*60*1e4);
                    
                    % Allocate memory for split intervals
                    idx_nonexist_PreSWS_Split = cell(1,numint);
                    idx_nonexist_PostSWS_Split = cell(1,numint);
                    
                end
            end
            
            % Get epochs
            [~, UMazeEpoch, CondEpoch, TaskEpoch, AfterConditioningEpoch] = ReturnMnemozyneEpochs(SessionEpoch);
            
            % Locomotion threshold
            VtsdSmoothed  = tsd(Range(CleanVtsd),movmedian(Data(CleanVtsd),5));
            LocomotionEpoch = thresholdIntervals(VtsdSmoothed,4,'Direction','Above');
            
            % Get resulting epochs
            UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
            AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
            CondMovingEpoch = and(LocomotionEpoch,CondEpoch);
            CondFreezeEpoch = and(LocomotionEpoch,FreezeAccEpoch);
            TaskMovingEpoch = and(LocomotionEpoch,TaskEpoch);
            
            %% Create firing rate histograms
       
            % Filter only pyramidal neurons    
            
            id_ripples{j} = PyramLayerSorting(spikes{j}.RippleGroups, spikes{j}.TT);

            % Convert to logical indices
            ids_ripples{j} = zeros(1, length(spikes{j}.S));
            ids_ripples{j}(id_ripples{j})= 1;
            ids_sua{j} = zeros(1, length(spikes{j}.S));
            ids_sua{j}(spikes{j}.BasicNeuronInfo.idx_SUA) = 1;
            
            % Firing rate threshold, Hz
            
            FR_threshold_lower{j} = (spikes{j}.BasicNeuronInfo.firingrate >= .3);
            FR_threshold_upper{j} = (spikes{j}.BasicNeuronInfo.firingrate <= 5);
            Thresholdead{j} = FR_threshold_upper{j}&FR_threshold_lower{j}&ids_ripples{j}&ids_sua{j}; % получили индексы нужных нейронов.
            Thresholdead{j} = FR_threshold_lower{j}&ids_ripples{j}&ids_sua{j}; % получили индексы нужных нейронов
            
            pyr_cells = spikes{j}.S(Thresholdead{j});
            num_pyr_cells(j) = length(pyr_cells);

            fprintf(['\n There are ' num2str(num_pyr_cells(j)) ' neurons in the analysis from the mouse ' num2str(Dir.name{j}) '\n']);

            % Restrict spike train to place cells only
            %             S_PC = S(PlaceCells.idx);
            
            % Bin the trains
            Q = MakeQfromS(pyr_cells, binsize); %Нужно Thresholdead{j} переформатировать в ts?
            
            % Create epochs for different periods of the day
            
            % PreSleep full
            QPRE{j}=zscore(full(Data(Restrict(Q,SessionEpoch.PreSleep))));
            
            % PreSleep NREM
            QPRESWS{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PreSleep,SWSEpoch))))); % full NREM sleep
            %             QPRESWS{j}=zscore(full(Data(Restrict(Q,PreSleepRipplesEpoch)))); % only during nREM ripples
            
            % PreSleep NREM binned if necessary
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    for i=1:numint
                        QPRESWS_Split{j}{i} = zscore(full(Data(Restrict(Q,PreSleepSWS_Split{j}{i}))));
                    end
                end
            end
            
            % PreSleep REM
            QPREREM{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PreSleep,REMEpoch)))));
            
            % Exploration + PreTests (Locomotion only)
            QTASK{j}=zscore(full(Data(Restrict(Q,UMazeMovingEpoch))));
            
            % Conditioning 
            QHAB{j}=zscore(full(Data(Restrict(Q,SessionEpoch.Hab))));
            
            % Conditioning 
            QCOND{j}=zscore(full(Data(Restrict(Q,CondEpoch))));
            % Conitioning (Locomotion Only)
            QCONDMOV{j}=zscore(full(Data(Restrict(Q,CondMovingEpoch))));
            
            % Conitioning (Freezing Only)
            QCONDFR{j}=zscore(full(Data(Restrict(Q,CondFreezeEpoch)))); % restricted to freezing
            
            % Whole task (everything)
            QTASK_Whole{j}=zscore(full(Data(Restrict(Q,TaskEpoch))));
            
            % Whole task (Locomotion only)
            QTASK_WholeMov{j}=zscore(full(Data(Restrict(Q,TaskMovingEpoch))));
            
            % PostSleep full
            QPOST{j}=full(Data(Restrict(Q,SessionEpoch.PostSleep)));
            
            % PostSleep NREM
            QPOSTSWS{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PostSleep,SWSEpoch))))); % full NREM sleep
            %             QPOSTSWS{j}=zscore(full(Data(Restrict(Q,PostSleepRipplesEpoch)))); % only during nREM ripples
            
            % PostSleep NREM binned if necessary
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    for i=1:numint
                        QPOSTSWS_Split{j}{i} = zscore(full(Data(Restrict(Q,PostSleepSWS_Split{j}{i}))));
                    end
                end
            end
            
            % PostSleep REM
            QPOSTREM{j}=zscore(full(Data(Restrict(Q,and(SessionEpoch.PostSleep,REMEpoch)))));
            
            % PostTests (Locomotion only)
            QPOSTTEST{j}=zscore(full(Data(Restrict(Q,AfterConditioningMovingEpoch))));
            
            % Get rid the variable unneccessry in future
%             clear Q SWSEpoch REMEpoch SessionEpoch ripples CleanVtsd ripplesEpoch PreSleepRipplesEpoch TaskEpoch
%             clear PostSleepRipplesEpoch UMazeEpoch CondEpoch AfterConditioningEpoch VtsdSmoothed LocomotionEpoch
%             clear UMazeMovingEpoch AfterConditioningMovingEpoch CondMovingEpoch CondFreezeEpoch FreezeAccEpoch TaskMovingEpoch
            
            %% Calculate the correlation maps and coefficients for split epochs
            
            % PreSleep NREM binned if necessary
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    for i=1:numint
                        CorrM{j}.PreSWS_Split{i}=corr(QPRESWS_Split{j}{i});
                    end
                end
            end
            
            % PostSleep NREM binned if necessary
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    for i=1:numint
                        CorrM{j}.PostSWS_Split{i}=corr(QPOSTSWS_Split{j}{i});
                    end
                end
            end
            
            %% Find non-firing neurons in each epoch
            
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    
                    % PreSleep
                    for i=1:numint
                        idx_nonexist_PreSWS_Split{i} = find(isnan(CorrM{j}.PreSWS_Split{i}(:,1)));
                    end
                    idx_nonexist_PreSWS_Split_Final = idx_nonexist_PreSWS_Split{1};
                    for i = 2:numint
                        idx_nonexist_PreSWS_Split_Final = [idx_nonexist_PreSWS_Split_Final; idx_nonexist_PreSWS_Split{i}];
                    end
                    
                    idx_nonexist_PreSWS_Split_Final = unique(idx_nonexist_PreSWS_Split_Final);
                    
                    % PostSleep
                    for i=1:numint
                        idx_nonexist_PostSWS_Split{i} = find(isnan(CorrM{j}.PostSWS_Split{i}(:,1)));
                    end
                    idx_nonexist_PostSWS_Split_Final = idx_nonexist_PostSWS_Split{1};
                    for i = 2:numint
                        idx_nonexist_PostSWS_Split_Final = [idx_nonexist_PostSWS_Split_Final; idx_nonexist_PostSWS_Split{i}];
                    end
                    
                    idx_nonexist_PostSWS_Split_Final = unique(idx_nonexist_PostSWS_Split_Final);
                    
                    % Merge
                    idx_toremove_splitStages = unique(([idx_nonexist_PreSWS_Split_Final; idx_nonexist_PostSWS_Split_Final])');
                    
                    
                end
            end
            
            % Get rid the variable unneccessry in future
            clear idx_nonexist_PreSWS_Split idx_nonexist_PreSWS_Split_Final
            clear idx_nonexist_PostSWS_Split idx_nonexist_PostSWS_Split_Final
            
            %% Remove neurons that do not fire in split sleep epochs
            
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    QTASK_Split{j} = QTASK{j};
                    QTASK_Split{j}(:,idx_toremove_splitStages) = [];
                    QCONDMOV{j}(:,idx_toremove_splitStages) = [];
                    QCONDFR{j}(:,idx_toremove_splitStages) = [];
                    for i=1:numint
                        QPRESWS_Split{j}{i}(:,idx_toremove_splitStages) = [];
                        QPOSTSWS_Split{j}{i}(:,idx_toremove_splitStages) = [];
                    end
                end
            end
            
            %% Calculate EV and REV
            %SWS
            [EV_hab_SWS(j),REV_hab_SWS(j), CorrM_hab_SWS(j)] = ExplainedVariance(QPRESWS{j},QHAB{j},QPOSTSWS{j});
            [EV_cond_SWS(j),REV_cond_SWS(j), CorrM_cond_SWS(j)] = ExplainedVariance(QPRESWS{j},QCOND{j},QPOSTSWS{j});
            [EV_fullwake_SWS(j),REV_fullwake_SWS(j), CorrM_fullwake_SWS(j)] = ExplainedVariance(QPRESWS{j},QTASK_Whole{j},QPOSTSWS{j});
            %REM
            [EV_hab_REM(j),REV_hab_REM(j), CorrM_hab_REM(j)] = ExplainedVariance(QPREREM{j},QHAB{j},QPOSTREM{j});
            [EV_cond_REM(j),REV_cond_REM(j), CorrM_cond_REM(j)] = ExplainedVariance(QPREREM{j},QCOND{j},QPOSTREM{j});
            [EV_fullwake_REM(j),REV_fullwake_REM(j), CorrM_fullwake_REM(j)] = ExplainedVariance(QPREREM{j},QTASK_Whole{j},QPOSTREM{j});

            
            %%%%%%%% full wake mov %%%%%%%%
            [EV_whole(j),REV_whole(j), CorrM_Whole(j)] = ExplainedVariance(QPRE{j},QTASK_WholeMov{j},QPOST{j});
            
            %%%%%%%% Intance _full %%%%%%%%
            [EV(j),REV(j)] = ExplainedVariance(QPRE{j},QTASK{j},QPOST{j});
            
            %%%%%%%% Intance _stages %%%%%%%%
            [EVSWS(j),REVSWS(j), CorrM_SWS(j)] = ExplainedVariance(QPRESWS{j},QTASK{j},QPOSTSWS{j});
            [EVREM(j),REVREM(j)] = ExplainedVariance(QPREREM{j},QTASK{j},QPOSTREM{j});
            
            %%%%%%%% Intance _splitStages %%%%%%%%
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    for i=1:numint
                        [EVSWS_Split{i}(j),REVSWS_Split{i}(j)] = ExplainedVariance(QPRESWS_Split{j}{i},...
                            QTASK_Split{j},QPOSTSWS_Split{j}{i});
                    end
                end
            end
            
            %%%%%%%% Intance _splitStages task is locomotion during conditioning %%%%%%%%
            if ~isempty(splitSleep)
                if splitSleep <= 20
                    for i=1:numint
                        [EVSWS_SplitCond{i}(j),REVSWS_SplitCond{i}(j)] = ExplainedVariance(QPRESWS_Split{j}{i},...
                            QCONDMOV{j},QPOSTSWS_Split{j}{i});
                    end
                end
            end
            
            %%%%%%%% Intance _splitStages task is freezing during conditioning %%%%%%%%
            if ~isempty(splitSleep)
                if  splitSleep <= 20
                    for i=1:numint
                        [EVSWS_SplitCondFr{i}(j),REVSWS_SplitCondFr{i}(j)] = ExplainedVariance(QPRESWS_Split{j}{i},...
                            QCONDFR{j},QPOSTSWS_Split{j}{i});
                    end
                end
            end
            
        end
    end
end

%% Remove mice without data

QPRE = QPRE(~cellfun('isempty',QPRE));
QPRESWS = QPRESWS(~cellfun('isempty',QPRESWS));
QPREREM = QPREREM(~cellfun('isempty',QPREREM));
QTASK = QTASK(~cellfun('isempty',QTASK));
QTASK_Whole = QTASK_Whole(~cellfun('isempty',QTASK_Whole));
QTASK_WholeMov = QTASK_WholeMov(~cellfun('isempty',QTASK_WholeMov));
QPOST = QPOST(~cellfun('isempty',QPOST));
QPOSTSWS = QPOSTSWS(~cellfun('isempty',QPOSTSWS));
QPOSTREM = QPOSTREM(~cellfun('isempty',QPOSTREM));
QPOSTTEST = QPOSTTEST(~cellfun('isempty',QPOSTTEST));

if ~isempty(splitSleep)
    if splitSleep <= 20
        QPRESWS_Split = QPRESWS_Split(~cellfun('isempty',QPRESWS_Split));
        QPOSTSWS_Split = QPOSTSWS_Split(~cellfun('isempty',QPOSTSWS_Split));
    end
end

CorrM = CorrM(~cellfun('isempty',CorrM));

EV_whole = nonzeros(EV_whole);
REV_whole = nonzeros(REV_whole);
EV = nonzeros(EV);
REV = nonzeros(REV);
EVSWS = nonzeros(EVSWS);
REVSWS = nonzeros(REVSWS);
EVREM = nonzeros(EVREM);
REVREM = nonzeros(REVREM);

if ~isempty(splitSleep)
    if splitSleep <= 20
        for i=1:numint
            EVSWS_Split{i} = nonzeros(EVSWS_Split{i});
            REVSWS_Split{i} = nonzeros(REVSWS_Split{i});
            EVSWS_SplitCond{i} = nonzeros(EVSWS_SplitCond{i});
            REVSWS_SplitCond{i} = nonzeros(REVSWS_SplitCond{i});
            EVSWS_SplitCondFr{i} = nonzeros(EVSWS_SplitCondFr{i});
            REVSWS_SplitCondFr{i} = nonzeros(REVSWS_SplitCondFr{i});
        end
    end
end

%% Some message for the public
fprintf(['\n ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n',...
    '         ' num2str(length(EV)) ' mice are in the analysis           \n' ,...
    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \n']);

%% Plot figures

foldertosave = ChooseFolderForFigures_AG('ReactReplay');

cols_ssd = cols;
while length(cols_ssd) < 6
    cols_ssd{length(cols_ssd)+1} = cols{1};
    cols_ssd{length(cols_ssd)+1} = cols{2};
end

% Plot spikes for each mouse
Spikes_vis_AG

% Plot correlation matrices
CorrM_plot

%% Figure 1

% EV_whole_clean & REV_whole_clean = EV_whole & REV_whole but with excluded
% mice with positive slope and extremly (REV > EV)

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.3 0.5]);
f1_data = {EV_whole*100, REV_whole*100};

ssp_1 = MakeBoxPlot_DB(f1_data, cols_ssd, [1 2], [], 1, 'ConnectDots', 1);
set(gca, 'Xtick', [1:2], 'XtickLabel', {'EV', 'REV'});
ylabel('% explained');
title('Pre-Post sleep EV full task', 'FontSize', 14);

makepretty

%% Figure 2

% general explained variance, regardless of sleep state

f2 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.5]);
subplot(1,3,1)
f2_data_subplot1 = {EV_cond_REM*100, REV_cond_REM*100};
ssp_2_1 = MakeBoxPlot_DB(f2_data_subplot1, cols_ssd, [1 2], [], 1, 'ConnectDots', 1);
set(gca, 'Xtick', [1:2], 'XtickLabel', {'EV', 'REV'});
ylabel('% explained');
title('Conditioning. REM', 'FontSize', 14);

pairs_toCompare = {[1 2]};

p = DoWilcoxonOnArray(f2_data_subplot1, pairs_toCompare);
for ip = 1:length(p)
    if p(ip) <= 0.05
        sigstar_DB(pairs_toCompare(ip),p(ip),0,'LineWigth',16,'StarSize',24);
    end
end
t2 = text(.4, .9, ['p = ' num2str(round(p, 3))], 'sc');

makepretty
% general explained variance in nonREM sleep

subplot(1,3,2)
f2_data_subplot2 = {EV_hab_REM*100, REV_hab_REM*100};
ssp_2_2 = MakeBoxPlot_DB(f2_data_subplot2, cols_ssd, [1 2], [], 1, 'ConnectDots', 1);
set(gca, 'Xtick', [1:2], 'XtickLabel', {'EV', 'REV'});
ylabel('% explained');
title('Habituation. REM', 'FontSize', 14);

p = DoWilcoxonOnArray(f2_data_subplot2, pairs_toCompare);
for ip = 1:length(p)
    if p(ip) <= 0.05
        sigstar_DB(pairs_toCompare(ip),p(ip),0,'LineWigth',16,'StarSize',24);
    end
end
t2 = text(.4, .9, ['p = ' num2str(round(p, 3))], 'sc');

makepretty

% general explained variance in REM sleep
subplot(1,3,3)
f2_data_subplot3 = {EV_fullwake_REM*100, REV_fullwake_REM*100};
ssp_2_2 = MakeBoxPlot_DB(f2_data_subplot3, cols_ssd, [1 2], [], 1, 'ConnectDots', 1);
set(gca, 'Xtick', [1:2], 'XtickLabel', {'EV', 'REV'});
ylabel('% explained');
title('Full Wake. REM', 'FontSize', 14);

p = DoWilcoxonOnArray(f2_data_subplot3, pairs_toCompare);
for ip = 1:length(p)
    if p(ip) <= 0.05
        sigstar_DB(pairs_toCompare(ip),p(ip),0,'LineWigth',16,'StarSize',24);
    end
end
t2 = text(.4, .9, ['p = ' num2str(round(p, 3))], 'sc');

makepretty

%% Figure 3
% Plot the figure with dynamics
if ~isempty(splitSleep)
    if splitSleep <= 20
        
        % Prepare the data
        % NREM Sleep
        fi = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.5]);
        dat_SWS =  EVSWS_Split{1};    
        
        for i=1:numint
            if i == 1
                dat_SWS = [dat_SWS REVSWS_Split{i}];
                %                 dat_SWS = [dat_SWS zeros(size(dat_SWS,1),1)];
            elseif i == numint
                dat_SWS = [dat_SWS EVSWS_Split{i}];
                dat_SWS = [dat_SWS REVSWS_Split{i}];
            else
                dat_SWS = [dat_SWS EVSWS_Split{i}];
                dat_SWS = [dat_SWS REVSWS_Split{i}];
                %                 dat_SWS = [dat_SWS zeros(size(dat_SWS,1),1)];
            end
        end
                
        dat_SWS = {dat_SWS(:,1), dat_SWS(:,2), dat_SWS(:,3), dat_SWS(:,4)};
        
        % Plot
        
        ssp_i = MakeBoxPlot_DB(dat_SWS, cols_ssd(1:4), [1, 2, 4, 5], [], 1, 'newfig', 1, 'ConnectDots', 1);
        h_occ.FaceColor = 'flat';
        h_occ.CData(2,:) = [1 1 1];
        for i=2:3:size(dat_SWS,2)
            h_occ.CData(i,:) = [1 1 1];
        end
        labels = ['0-' num2str(splitSleep) ' min'];
        for i=2:numint
            labels = {labels,[num2str((i-1)*splitSleep) '-' num2str(i*splitSleep) ' min']};
        end
        ylabel('% explained');
        set(gca,'Xtick',[1:3:size(dat_SWS,2)],'XtickLabel',labels);
        title('EV (black) and REV (white) split in intervals (naive exploration)', 'FontSize', 14);

        
%         pairs_toCompare = {[1 2], [3 4]};
%         p = DoWilcoxonOnArray(dat_SWS, pairs_toCompare);
%         for ip = 1:length(p)
%             if p(ip) <= 0.05
%                 sigstar_DB(pairs_toCompare(ip),p(ip),0,'LineWigth',16,'StarSize',24);
%             end
%         end

        makepretty
    end
end

%% Figure 4
% Plot the figure with dynamics (Conditioning locomotion)
if ~isempty(splitSleep)
    if splitSleep <= 20
        
        fi = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.5]);
        
        % Prepare the data
        % NREM Sleep
        dat_SWS =  EVSWS_SplitCond{1};
        for i=1:numint
            if i == 1
                dat_SWS = [dat_SWS REVSWS_SplitCond{i}];
                %                 dat_SWS = [dat_SWS zeros(size(dat_SWS,1),1)];
            elseif i == numint
                dat_SWS = [dat_SWS EVSWS_SplitCond{i}];
                dat_SWS = [dat_SWS REVSWS_SplitCond{i}];
            else
                dat_SWS = [dat_SWS EVSWS_SplitCond{i}];
                dat_SWS = [dat_SWS REVSWS_SplitCond{i}];
                %                 dat_SWS = [dat_SWS zeros(size(dat_SWS,1),1)];
            end
        end
        
        % Plot
        dat_SWS = {dat_SWS(:,1), dat_SWS(:,2), dat_SWS(:,3), dat_SWS(:,4)};
        
        ssp_i = MakeBoxPlot_DB(dat_SWS, cols_ssd(1:4), [1, 2, 4, 5], [], 1, 'newfig', 1, 'ConnectDots', 1);
        h_occ.FaceColor = 'flat';
        h_occ.CData(2,:) = [1 1 1];
        for i=2:3:size(dat_SWS,2)
            h_occ.CData(i,:) = [1 1 1];
        end
        labels = ['0-' num2str(splitSleep) ' min'];
        for i=2:numint
            labels = {labels,[num2str((i-1)*splitSleep) '-' num2str(i*splitSleep) ' min']};
        end
        ylabel('% explained');
        set(gca,'Xtick',[1:3:size(dat_SWS,2)],'XtickLabel',labels);
        title('EV (black) and REV (white) split in intervals (run during conditioning)', 'FontSize', 14);
        
        pairs_toCompare = {[1 2], [3 4]};
        p = DoWilcoxonOnArray(dat_SWS, pairs_toCompare);
        for ip = 1:length(p)
            if p(ip) <= 0.05
                sigstar_DB(pairs_toCompare(ip),p(ip),0,'LineWigth',16,'StarSize',24);
            end
        end

        makepretty
    end
end

%% Figure 5
% % Plot the figure with dynamics (Conditioning freezing)
% if ~isempty(splitSleep)
%     if splitSleep <= 20
%         
%         fi = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.5]);
%         
%         % Prepare the data
%         % NREM Sleep
%         dat_SWS =  EVSWS_SplitCondFr{1};
%         for i=1:numint
%             if i == 1
%                 dat_SWS = [dat_SWS REVSWS_SplitCondFr{i}];
%                 %                 dat_SWS = [dat_SWS zeros(size(dat_SWS,1),1)];
%             elseif i == numint
%                 dat_SWS = [dat_SWS EVSWS_SplitCondFr{i}];
%                 dat_SWS = [dat_SWS REVSWS_SplitCondFr{i}];
%             else
%                 dat_SWS = [dat_SWS EVSWS_SplitCondFr{i}];
%                 dat_SWS = [dat_SWS REVSWS_SplitCondFr{i}];
%                 %                 dat_SWS = [dat_SWS zeros(size(dat_SWS,1),1)];
%             end
%         end
%         
%         % Plot
%         dat_SWS = {dat_SWS(:,1), dat_SWS(:,2), dat_SWS(:,3), dat_SWS(:,4)};
%         
%         ssp_i = MakeBoxPlot_DB(dat_SWS, cols_ssd(1:4), [1, 2, 4, 5], [], 1, 'newfig', 1);
%         h_occ.FaceColor = 'flat';
%         h_occ.CData(2,:) = [1 1 1];
%         for i=2:3:size(dat_SWS,2)
%             h_occ.CData(i,:) = [1 1 1];
%         end
%         labels = ['0-' num2str(splitSleep) ' min'];
%         for i=2:numint
%             labels = {labels,[num2str((i-1)*splitSleep) '-' num2str(i*splitSleep) ' min']};
%         end
%         ylabel('% explained');
%         set(gca,'Xtick',[1:3:size(dat_SWS,2)],'XtickLabel',labels);
%         title('EV (black) and REV (white) split in intervals (freeze during conditioning)', 'FontSize', 14);
%         makepretty
%     end
% end

%% Plot bar with amount of neurons per mouse
f6 = figure('units', 'normalized', 'outerposition', [0 0 0.7 0.9]);
bar_nn = bar(num_pyr_cells, 0.6, 'FaceColor',[0 .5 .5],'EdgeColor',[0 .6 .6],'LineWidth',1.5);
Xtips = bar_nn.XEndPoints;
Ytips = bar_nn.YEndPoints;
labels_bar_nn = string(bar_nn.YData);
text(Xtips,Ytips,labels_bar_nn,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
set(gca,'Xtick',[1:length(num_pyr_cells)],'XtickLabel', [Dir.name]);
ylabel('Number of neurons in the analysis')

%% How many mice have EV>REV
idx = EVSWS>REVSWS;
disp(['Number of mice with EV>REV is ' num2str(length(find(idx))) '/' num2str(length(idx))])
%
% % Plot only "working" mice (horrible, I know)
% EV_new = EV(idx);
% REV_new = REV(idx);
%
% Pl = {EV_new*100; REV_new*100};
%
% Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2]};
%
% addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));
%
% fh = figure('units', 'normalized', 'outerposition', [0 0 0.7 0.9]);
% MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2]);
% [p,h5,stats] = signrank(Pl{1},Pl{2});
% if p < 0.05
%     sigstar_DB({{1,2}},p,0, 'StarSize',14);
% end
% set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:2,'XTickLabel',...
%     {'Explained variance','Reverse explained variance'})
% % ylim([0.15 0.9])
% ylabel('EV or REV in %')
% % title('Place cell stability after conditioning')
%
% rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));
%
%
% if sav
%     saveas(gcf,[dropbox '/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/ExplainedVariance.fig']);
%     saveFigure(gcf,'ExplainedVariance',...
%         [dropbox '/MOBS_workingON/Dima/Ongoing results/PlaceField_Final/']);
%end

%% Save results
%% Save ratios

folders ={'E:\ERC_data'};
save([folders{1} '\EV_res.mat'],'nmice', 'EV_cond_SWS','REV_cond_SWS', 'EV_hab_SWS', 'REV_hab_SWS', 'EV_fullwake_SWS', 'REV_fullwake_SWS','EV_cond_REM','REV_cond_REM', 'EV_hab_REM', 'REV_hab_REM', 'EV_fullwake_REM', 'REV_fullwake_REM' );