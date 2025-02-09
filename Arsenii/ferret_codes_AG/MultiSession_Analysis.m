function MultiSession_Analysis

% MULTISESSION_ANALYSIS
% Example script to merge PSTH data from multiple sessions, compute:
%   1) Global mean PSTH across ALL neurons in ALL sessions
%   2) PSTH of one selected “stable neuron” across sessions
%   3) Single-neuron analysis of gamma-binned PSTHs (within Wake)
%      using PSTH_GammaBins_SingleNeuron subfunction
%
% REQUIREMENTS:
%   - Each session's PSTH results stored in PSTH_Results_SessionX.mat
%   - popRawPSTH, popZscoredPSTH, popAvgRate, popAvgZ, timeCenters, conditionNames, ...
%   - Same bin edges, same condition order, potentially different # of neurons
%
% By: A. Goriachenkov 03/02/2025
% -----------------------------------------------------

%% 1) Define Sessions to Merge
% For instance, you might have a list of sessions or directories:
sessions = {...
    '20241205_TORCs', ... 
    '20241206_TORCs', ...
    '20241209_TORCs', ...
    '20241211_TORCs', ...
    '20241212_TORCs', ... 
    '20241213_TORCs', ...
    '20241214_TORCs', ...
    '20241221_TORCs', ...
    '20241223_TORCs'};
% '20241210_TORCs', ... skip
exp_path  = '/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/';

nSessions = length(sessions);

%% 2) Preallocate / Initialize Master Arrays
% We'll store all neurons from all sessions. 
% But we don't know total # of neurons until we load each file.
allPopRaw   = [];   % eventually (sumOfNeurons x nBins x nConds)
allPopZscore= [];

allSessionIDs = []; % to track which session each neuron came from
sessionNeuronsCount = zeros(nSessions,1);

% We'll also store "timeCenters" and "conditionNames" from the first session. 
% We'll assume they are consistent across sessions.
masterTimeCenters = [];
masterConds       = [];
nBins = [];
nConds = [];

myColors = {
    [0 0 1];     % Wake
    [.7 .7 .7];     % Sleep
    [1 0 0];   % NREM
    [0 1 0];     % REM
    [1 0.5 0.5]; % NREM1
    [0.5 0 0];   % NREM2
};

%% 3) Loop Over Sessions, Load & Concatenate
runningNeuronCount = 0;
for s = 1:nSessions
    sessName = sessions{s};
    dat = load([exp_path sessName '/wave_clus/spike_analysis_' sessName]);  % loads popRawPSTH, popZscoredPSTH, etc.
    
    if s == 1
        % Store timeCenters, conditionNames
        masterTimeCenters = dat.timeCenters;
        masterConds       = dat.conditionNames;
        nBins = size(dat.popRawPSTH,2);
        nConds = size(dat.popRawPSTH,3);
    else
        % Verify consistency in nBins, nConds
        if length(dat.timeCenters) ~= length(masterTimeCenters)
            error('Session %d: time bin mismatch!', s);
        end
        if ~isequal(dat.conditionNames, masterConds)
            error('Session %d: conditionNames mismatch!', s);
        end
    end
    
    % number of neurons in this session
    nNeursThis = size(dat.popRawPSTH,1);
    sessionNeuronsCount(s) = nNeursThis;
    
    % Concatenate
    if isempty(allPopRaw)
        allPopRaw    = dat.popRawPSTH;
        allPopZscore = dat.popZscoredPSTH;
        allSessionIDs= ones(nNeursThis,1)*s;
    else
        allPopRaw    = cat(1, allPopRaw,    dat.popRawPSTH);
        allPopZscore = cat(1, allPopZscore, dat.popZscoredPSTH);
        allSessionIDs= [allSessionIDs; ones(nNeursThis,1)*s];
    end
    
    runningNeuronCount = runningNeuronCount + nNeursThis;
    fprintf('Loaded Session %d: %s, nNeurons=%d\n', s, sessName, nNeursThis);
end

fprintf('Total Neurons across all sessions: %d\n', runningNeuronCount);

%% 4) Compute GLOBAL Mean PSTH (Raw + Z) Across All Neurons
% allPopRaw is (N_totalNeurons x nBins x nConds)
meanGlobalRaw = squeeze(mean(allPopRaw, 1));   % (nBins x nConds)
semGlobalRaw  = squeeze(std(allPopRaw, 0, 1)) / sqrt(runningNeuronCount);

meanGlobalZ   = squeeze(mean(allPopZscore, 1));
semGlobalZ    = squeeze(std(allPopZscore, 0, 1)) / sqrt(runningNeuronCount);

% You can also do a median if desired, or check distributions, etc.

%% 5) Plot GLOBAL PSTH
f1 = figure('Name',['Global PSTH (' num2str(numel(sessions)) ' Sessions)'],'Color','w','Position',[300 100 1000 600], 'Visible', 'off');
sgtitle(['sessions = ' num2str(numel(sessions)) '; units = ' num2str(runningNeuronCount)], 'FontWeight', 'bold', 'FontSize', 15)
nCondsLocal = length(masterConds);

% We'll do subplots or a single plot with multiple lines. 
% Example: single subplot, each condition a line
% Z-scored PSTH
subplot(1,2,1); hold on;
title('Global Z-scored PSTH');
xlabel('Time (s)'); ylabel('Z-score');
for c = 1:nCondsLocal
    mZ  = meanGlobalZ(:, c);
    sZ  = semGlobalZ(:,  c);
    tC  = masterTimeCenters;
    ciU = mZ + 1.96*sZ;
    ciL = mZ - 1.96*sZ;
    
    fill([tC, fliplr(tC)], [ciU', fliplr(ciL')], ...
         myColors{c},'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
    plot(tC, mZ, 'LineWidth',2, 'DisplayName', masterConds{c}, 'Color', myColors{c});
end
legend('Location','best'); box off;

subplot(1,2,2); hold on;
title('Global Raw PSTH');
xlabel('Time (s)'); ylabel('Firing Rate (spikes/s)');
for c = 1:nCondsLocal
    mR  = meanGlobalRaw(:, c);
    sR  = semGlobalRaw(:,  c);
    tC  = masterTimeCenters;
    ciU = mR + 1.96*sR;
    ciL = mR - 1.96*sR;
    
    fill([tC, fliplr(tC)], [ciU', fliplr(ciL')], ...
         myColors{c},'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
    pH = plot(tC, mR, 'LineWidth',2, 'DisplayName', masterConds{c}, 'Color', myColors{c});
    % pick color if you want
end
legend('Location','best'); box off;

saveas(f1, [exp_path 'average_PSTH_TORCS'], 'png')


%% UNDER CONSTRUCTION YET: 6) Select ONE “Stable” Neuron Across Sessions
% % For example, you might have a known stable neuron ID in each session,
% % or a stable "channel-cluster" label. Let's assume you store that info
% % in some structure or a simple mapping. Example:
% 
% % stableNeuronMap(sessionID) = localNeuronIndex
% % that means in session #1, the stable neuron's index is 2
% % in session #2, maybe index is 5, etc.
% % We'll just define a dummy example here:
% 
% stableNeuronMap = [2, 4, 1];  % length = nSessions
% % i.e. session1 => neuron #2, session2 => neuron #4, session3 => neuron #1
% 
% % We'll build a figure that shows that single neuron's PSTH across sessions.
% figure('Name','Stable Neuron PSTHs','Color','w','Position',[200 200 800 600]);
% 
% for s = 1:nSessions
%     % load that session data again or re-use the data you already loaded
%     % but we need to keep references for each session's data:
%     % We'll do it in a simpler approach: we re-load from file or we could have
%     % stored them in an array inside the loop above.
% 
%     thisFile = sessionList{s};
%     dat = load(thisFile);
% 
%     localIdx = stableNeuronMap(s);
%     % Extract PSTHs for that local neuron
%     rawPSTH   = squeeze(dat.popRawPSTH(localIdx, : , :));     % (nBins x nConds)
%     zPSTH     = squeeze(dat.popZscoredPSTH(localIdx, : , :));
% 
%     % We'll do subplots: each row is a session, left plot=raw, right=z
%     subplot(nSessions, 2, (s-1)*2 + 1); hold on;
%     title(sprintf('Session %d - Raw PSTH (Neuron %d)', s, localIdx));
%     xlabel('Time (s)'); ylabel('FR (sp/s)');
%     for c = 1:nCondsLocal
%         plot(dat.timeCenters, rawPSTH(:,c), 'LineWidth',2, 'DisplayName', dat.conditionNames{c});
%     end
%     legend('Location','best'); box off;
% 
%     subplot(nSessions, 2, (s-1)*2 + 2); hold on;
%     title(sprintf('Session %d - Z-scored PSTH (Neuron %d)', s, localIdx));
%     xlabel('Time (s)'); ylabel('Z-score');
%     for c = 1:nCondsLocal
%         plot(dat.timeCenters, zPSTH(:,c), 'LineWidth',2, 'DisplayName', dat.conditionNames{c});
%     end
%     legend('Location','best'); box off;
% end
% 
% sgtitle('Stable Neuron PSTHs Across Multiple Sessions');

%% UNDER CONSTRUCTION:
% stableNeuronMap = ones(1, nSessions);
% 
% figure('Name','Gamma-Binned PSTHs (all sessions)','Color','w');
% % We'll store a correlation (bin index vs PSTH amplitude in [0..2 s]) as an example metric
% corrVals = nan(1, nSessions);
% 
% for s = 1:nSessions
%     sessName    = sessions{s};
%     resultFile  = fullfile(exp_path, sessName, 'wave_clus', ['spike_analysis_' sessName '.mat']);
%     dat         = load(resultFile); 
%     localIdx    = stableNeuronMap(s);
%     
%     % We also need 'SmoothGamma','Wake' from the same session
%     sleepFile   = fullfile(exp_path, sessName, 'SleepScoring_OBGamma.mat');
%     if ~exist(sleepFile, 'file')
%         warning('No SleepScoring file found for session %s. Skipping gamma-binned PSTH.', sessName);
%         continue;
%     end
%     load(sleepFile, 'SmoothGamma','Wake');  
%     
%     % Now call our subfunction
%     % PSTH_GammaBins_SingleNeuron(A, iNeuron, SmoothGamma, Wake, Starttime);
%     % But we need the actual spike times: 
%     %   localIdx => dat.metadata(localIdx,:) gives us channel/cluster, or we can do:
%     %   We must re-build A? 
%     %   For a quick approach, we can re-build A from the original script or store it in dat if you included it. 
%     %   For demonstration, let's assume you saved A in dat. 
%     %   If not, you'd have to reconstruct from spikes or do partial approach.
% 
%     % We'll do a fallback: if you didn't store A in the .mat, you can load spikes from wave_clus again, 
%     % or skip. We'll assume "dat.A" is not stored. So we demonstrate how to re-build quickly:
% 
%     spikeFile = fullfile(exp_path, sessName, 'wave_clus', 'wave_clus.mat'); 
%     if ~exist(spikeFile,'file')
%         warning('No wave_clus raw spikes found. Skipping gamma-binned PSTH for session %s.', sessName);
%         continue;
%     end
%     spkData = load(spikeFile, 'spikes','metadata');
%     
%     iCh      = dat.chcl{localIdx}(1); % channel
%     iCluster = dat.chcl{localIdx}(2); % cluster
%     row = find(spkData.metadata(:,1)==iCh & spkData.metadata(:,2)==iCluster);
%     singleNeuronTs = ts(spkData.spikes(:, row)*1e1);  % building a single ts object
%     
%     % We'll define Starttime from the same .mat or from "dat.Starttime" if saved. 
%     % If not, we might load LFP111.mat to get Starttime. For demonstration, we skip details:
%     if ~isfield(dat, 'Starttime')
%         warning('No Starttime in dat. Provide a stimulus onset or skip. Example only.');
%         continue;
%     end
%     Starttime = dat.Starttime; % If you saved it
% 
%     % Now we call PSTH_GammaBins_SingleNeuron
%     subplot(nSessions,1,s); % each session in a different row
%     [amplitudePerBin, binCenters] = PSTH_GammaBins_SingleNeuron(singleNeuronTs, SmoothGamma, Wake, Starttime);
% 
%     % (Optional) new dataset analysis: correlation of bin index with PSTH amplitude
%     % amplitudePerBin is 1x10 if we compute the PSTH amplitude in [0..2s].
%     if ~isempty(amplitudePerBin)
%         r = corr((1:length(amplitudePerBin))', amplitudePerBin(:), 'Rows','complete');
%         corrVals(s) = r;
%         title(sprintf('%s: r=%.2f', sessName, r));
%     else
%         title(sprintf('%s: no data for gamma bins', sessName));
%     end
% end
% 
% sgtitle('Gamma-Binned PSTH of stable neuron across sessions');
% 
% % Show correlation results
% fprintf('Gamma bin index vs PSTH amplitude correlation, per session: \n');
% disp(corrVals);

%% UNDER CONSTRUCTION: ADDITIONAL ANALYSIS: PSTH Amplitude vs State
% 
% % We have allPopRaw: (totalNeurons x nBins x nConds)
% % We have masterTimeCenters: (1 x nBins)
% % We have masterConds: cell array of length nConds
% %
% % 1) amplitude in [0..0.5]
% % 2) ongoing response in [0.5..3], minus baseline [-1..0]
% 
% % --- Indices for baseline, early response, ongoing response
% idxBaseline = (masterTimeCenters >= -1 & masterTimeCenters < 0);
% idxEarly    = (masterTimeCenters >= 0 & masterTimeCenters < 0.5);
% idxOngoing  = (masterTimeCenters >= 0.5 & masterTimeCenters < 3);
% 
% nTotalNeurons = size(allPopRaw,1);
% nBins = size(allPopRaw,2);
% nConds= size(allPopRaw,3);
% 
% % (A) Early response amplitude [0..0.5]
% %   We'll create a matrix: earlyAmp = (totalNeurons x nConds)
% %   Each entry is mean firing in [0..0.5].
% 
% earlyAmp = squeeze(mean(allPopRaw(:, idxEarly, :), 2));  % => (totalNeurons x nConds)
% % If idxEarly has multiple bins, mean across the 2nd dimension of allPopRaw.
% 
% % (B) Ongoing response [0.5..3] minus baseline [-1..0]
% %   baseline = average in [-1..0], ongoing = average in [0.5..3]
% baseFR     = squeeze(mean(allPopRaw(:, idxBaseline, :), 2));  % (totalNeurons x nConds)
% ongoingFR  = squeeze(mean(allPopRaw(:, idxOngoing,  :), 2));  % (totalNeurons x nConds)
% ongoingMinusBase = ongoingFR - baseFR;  % (totalNeurons x nConds)
% 
% % Now we make two figures:
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % FIGURE 1: PSTH amplitude in [0..0.5] across states
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figAmp = figure('Name','Early PSTH amplitude [0..0.5] vs. State','Color','w');
% hold on;
% title('Amplitude in [0..0.5] across states');
% ylabel('Firing Rate (spikes/s)');
% 
% % We can box-plot, or violin-plot, etc. 
% % For a boxplot, we need a vector plus a group label. 
% % We'll flatten (neurons x conds) into a single vector + group ID.
% 
% allData   = earlyAmp(:);  % flatten
% allGroups = [];           % numeric group 1..nConds
% for c = 1:nConds
%     nNeuronsCond = size(earlyAmp,1);
%     allGroups = [allGroups; c*ones(nNeuronsCond,1)]; %#ok<AGROW>
% end
% 
% boxplot(allData, allGroups, 'Labels', masterConds);
% xlabel('State/Condition');
% box off;
% ylim([0, max(allData)*1.2]);  % or an appropriate range
% grid on;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % FIGURE 2: Ongoing response [0.5..3] minus baseline [-1..0] across states
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figOngoing = figure('Name','Ongoing [0.5..3] minus baseline vs. State','Color','w');
% hold on;
% title('Ongoing [0.5..3] minus baseline [-1..0] across states');
% ylabel('Delta FR (spikes/s)');
% 
% allData2   = ongoingMinusBase(:);
% allGroups2 = [];
% for c = 1:nConds
%     nNeuronsCond = size(ongoingMinusBase,1);
%     allGroups2 = [allGroups2; c*ones(nNeuronsCond,1)]; %#ok<AGROW>
% end
% 
% boxplot(allData2, allGroups2, 'Labels', masterConds);
% xlabel('State/Condition');
% box off;
% % We might see negative values if the ongoing < baseline
% grid on;
% 
% % If you'd like to do stats, e.g. ANOVA across states:
% [p1,~,stats1] = anova1(earlyAmp,[],'off');  % early window
% fprintf('ANOVA p=%.4g for early response [0..0.5]\n', p1);
% 
% [p2,~,stats2] = anova1(ongoingMinusBase,[],'off'); % ongoing vs baseline
% fprintf('ANOVA p=%.4g for ongoing-baseline [0.5..3]\n', p2);


end
