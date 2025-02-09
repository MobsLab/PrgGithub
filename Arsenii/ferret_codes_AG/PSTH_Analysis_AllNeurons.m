function [popRawPSTH, popZscoredPSTH, popAvgRate, popAvgZ, timeCenters] = PSTH_Analysis_AllNeurons(A, chcl, stim_states, conditionNames, directory)
% PSTH_Analysis_AllNeurons
%
% OUTPUTS:
%   popRawPSTH      (nNeurons x nBins x nConds)
%   popZscoredPSTH  (nNeurons x nBins x nConds)
%   popAvgRate      (nNeurons x nConds)
%   popAvgZ         (nNeurons x nConds)
%   timeCenters     (1 x nBins)
%
% Builds raw & z-scored PSTHs for all neurons in A, across all conditions 
% in stim_states. Then:
%   - Plots per-neuron PSTH (2-subplot: raw + z-score)
%   - Population PSTH (raw + z)
%   - Violin plots of average firing
%   - Heatmap of z-scored PSTH
%   - Control analyses: sub-sampling, random onsets, spike jitter
%
% USAGE:
%   PSTH_Analysis_AllNeurons(A, stim_states, conditionNames, directory)

fprintf('== Running PSTH_Analysis_AllNeurons ==\n');

if length(conditionNames) ~= length(stim_states)
    error('conditionNames and stim_states must have the same length!');
end

%% 0) Config
allCondsIdx = 1:length(conditionNames);

% PSTH window
t_pre  = -1;
t_post =  5;
binSize= 0.1; % 100 ms bins

timeEdges = t_pre : binSize : t_post;
timeCenters = (timeEdges(1:end-1) + timeEdges(2:end))/2;

% Stim highlight
stimWindow = [0,3];

% Colors for each condition
myColors = {
    [0 0 1];     % Wake
    [.7 .7 .7];     % Sleep
    [1 0 0];   % NREM
    [0 1 0];     % REM
    [1 0.5 0.5]; % NREM1
    [0.5 0 0];   % NREM2
};

analysisWindow = [0 3]; % for average [0..3)
yminZ=-0.5; ymaxZ=2.5; yminRaw=0; ymaxRaw=150;

%% 1) Initialize population arrays
nNeurons = length(A);
nConds = length(allCondsIdx);
nBins = length(timeCenters);

popRawPSTH  = nan(nNeurons, nBins, nConds);
popZscoredPSTH = nan(nNeurons, nBins, nConds);
popAvgRate = nan(nNeurons, nConds);
popAvgZ = nan(nNeurons, nConds);

%% 2) Loop over Neurons & Build/Plot PSTHs
fprintf('plotting PSTHs\n');
for iNeuron=1:nNeurons
    clear f1
    f1 = figure('Color','w','Name',sprintf('Neuron %d PSTH', iNeuron),...
        'Units','normalized','Position',[0.1 0.3 0.7 0.4],'Visible', 'off');

    rawRates = cell(nConds,1);
    zRates = cell(nConds,1);

    axZ = subplot(1,2,1); hold on; title('Z-scored PSTH'); 
    xlabel('Time (s)'); ylabel('Z-score');
    axRaw = subplot(1,2,2); hold on; title('Raw PSTH'); 
    xlabel('Time (s)'); ylabel('Spikes/s');

    % Gray patch
    patch(axZ,[stimWindow(1) stimWindow(2) stimWindow(2) stimWindow(1)],...
        [yminZ yminZ ymaxZ ymaxZ],[0.8 0.8 0.8],'EdgeColor','none',...
        'FaceAlpha',0.5,'HandleVisibility','off');
    patch(axRaw,[stimWindow(1) stimWindow(2) stimWindow(2) stimWindow(1)],...
        [yminRaw yminRaw ymaxRaw ymaxRaw],[0.8 0.8 0.8],'EdgeColor','none',...
        'FaceAlpha',0.5,'HandleVisibility','off');

    lineHandlesZ = gobjects(nConds,1);
    lineHandlesRaw = gobjects(nConds,1);

    for cIdx=1:nConds
        c = allCondsIdx(cIdx);
        onsetTimes = Range(stim_states{c},'s');
        nOnsets = length(onsetTimes);

        % Trial-by-trial PSTH
        tmp_raw = zeros(nOnsets, nBins);
        for iOnset=1:nOnsets
            sTimes = Range(A{iNeuron},'s');
            relTimes = sTimes - onsetTimes(iOnset);
            inWindow = (relTimes>=t_pre & relTimes<=t_post);
            theseSpks = relTimes(inWindow);
            counts = histcounts(theseSpks,timeEdges);
            tmp_raw(iOnset,:) = counts / binSize; 
        end

        % Z-score
        idxBL = (timeCenters>=-1 & timeCenters<0);
        baseline = tmp_raw(:,idxBL); 
        meanBL = mean(baseline,'all'); %mean across trials and across -1-0 window
        stdBL = std(baseline,0,'all');
        tmp_z = (tmp_raw - meanBL) ./ stdBL;

        rawRates{cIdx} = tmp_raw;
        zRates{cIdx} = tmp_z;

        % Plot: Z-scored
        meanZ = mean(tmp_z,1);
        semZ = std(tmp_z,0,1)/sqrt(nOnsets);
        ciUpZ = meanZ + 1.96*semZ; ciLoZ = meanZ - 1.96*semZ;

        subplot(axZ);
        fill([timeCenters fliplr(timeCenters)], ...
             [ciUpZ fliplr(ciLoZ)], myColors{c}, ...
             'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
        lineHandlesZ(cIdx) = plot(timeCenters,meanZ,'Color',myColors{c}, ...
            'LineWidth',2,'DisplayName',conditionNames{c});

        % Plot: Raw
        meanR = mean(tmp_raw,1);
        semR = std(tmp_raw,0,1)/sqrt(nOnsets);
        ciUpR = meanR + 1.96*semR; ciLoR = meanR - 1.96*semR;

        subplot(axRaw);
        fill([timeCenters fliplr(timeCenters)], ...
             [ciUpR fliplr(ciLoR)], myColors{c}, ...
             'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
        lineHandlesRaw(cIdx) = plot(timeCenters,meanR,'Color',myColors{c}, ...
            'LineWidth',2,'DisplayName',conditionNames{c});
    end

    legend(axZ, lineHandlesZ, {conditionNames{allCondsIdx}},'Location','best');
    legend(axRaw,lineHandlesRaw,{conditionNames{allCondsIdx}},'Location','best');
    xlim(axZ,[t_pre t_post]); ylim(axZ,[min(meanZ)-0.5 max(meanZ)+1]); box(axZ,'off');
    xlim(axRaw,[t_pre t_post]); ylim(axRaw,[min(meanR)-10 max(meanR)+15]); box(axRaw,'off');

    % Store for population
    for cIdx=1:nConds
        tmp_raw = rawRates{cIdx};
        tmp_z = zRates{cIdx};
        popRawPSTH(iNeuron,:,cIdx) = mean(tmp_raw,1);
        popZscoredPSTH(iNeuron,:,cIdx) = mean(tmp_z,1);

        idxWin = (timeCenters>=analysisWindow(1) & timeCenters<analysisWindow(2));
        popAvgRate(iNeuron,cIdx) = mean(mean(tmp_raw(:,idxWin),2));
        popAvgZ(iNeuron,cIdx) = mean(mean(tmp_z(:,idxWin),2));
    end
    saveas(f1, [directory '/wave_clus/raster_figures/' 'PSTHs_#' num2str(chcl{iNeuron}(1)) '_' num2str(chcl{iNeuron}(2))], 'png')
end

%% 3) Population Figures (raw PSTH, z-scored PSTH, box/violin, heatmap)
fprintf('plotting population PSTH\n');
% (A) Population PSTH
close all
clear f2
f2 = figure('Color','w','Name','Population PSTH','Units','normalized','Position',[0.2 0.1 0.6 0.7],'Visible', 'off');
% Raw
ax1=subplot(1,3,2); hold on; title('Population-Avg Raw PSTH'); xlabel('Time (s)'); ylabel('Spikes/s');
patch(ax1,[stimWindow(1) stimWindow(2) stimWindow(2) stimWindow(1)], [yminRaw yminRaw ymaxRaw ymaxRaw], ...
    [0.8 0.8 0.8],'EdgeColor','none','FaceAlpha',0.5,'HandleVisibility','off');
lineHandlesPopRaw = gobjects(nConds,1);
for cIdx=1:nConds
    c = allCondsIdx(cIdx);
    rawAllNeurons = squeeze(popRawPSTH(:,:,cIdx));
    meanRaw_pop = mean(rawAllNeurons,1);
    semRaw_pop = std(rawAllNeurons,0,1)/sqrt(nNeurons);
    ciUp = meanRaw_pop + 1.96*semRaw_pop;
    ciLo = meanRaw_pop - 1.96*semRaw_pop;
    fill([timeCenters fliplr(timeCenters)], [ciUp fliplr(ciLo)], ...
         myColors{c}, 'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
    lineHandlesPopRaw(cIdx) = plot(timeCenters, meanRaw_pop, 'Color', myColors{c},...
        'LineWidth',2,'DisplayName',conditionNames{c});
end
legend(ax1, lineHandlesPopRaw,{conditionNames{allCondsIdx}},'Location','best');
xlim(ax1,[t_pre t_post]); ylim(ax1,[yminRaw ymaxRaw]); box(ax1,'off');

% Z
ax2=subplot(1,3,1); hold on; title('Population-Avg Z-scored PSTH'); xlabel('Time (s)'); ylabel('Z-score');
patch(ax2,[stimWindow(1) stimWindow(2) stimWindow(2) stimWindow(1)], [yminZ yminZ ymaxZ ymaxZ], ...
    [0.8 0.8 0.8],'EdgeColor','none','FaceAlpha',0.5,'HandleVisibility','off');
lineHandlesPopZ = gobjects(nConds,1);
for cIdx=1:nConds
    c = allCondsIdx(cIdx);
    zAllNeurons = squeeze(popZscoredPSTH(:,:,cIdx));
    meanZ_pop = mean(zAllNeurons,1);
    semZ_pop = std(zAllNeurons,0,1)/sqrt(nNeurons);
    ciUp = meanZ_pop + 1.96*semZ_pop;
    ciLo = meanZ_pop - 1.96*semZ_pop;
    fill([timeCenters fliplr(timeCenters)], [ciUp fliplr(ciLo)], ...
         myColors{c}, 'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
    lineHandlesPopZ(cIdx) = plot(timeCenters, meanZ_pop, 'Color', myColors{c},...
        'LineWidth',2,'DisplayName',conditionNames{c});
end
legend(ax2, lineHandlesPopZ,{conditionNames{allCondsIdx}},'Location','best');
xlim(ax2,[t_pre t_post]); ylim(ax2,[yminZ ymaxZ]); box(ax2,'off');

% Box or bar
ax3=subplot(1,3,3); hold on; title('Avg Rate during stimulus across neurons'); ylabel('Spikes/s (raw)');
myData=[]; myGroups=[];
for cIdx=1:nConds
    theseVals = popAvgRate(:,cIdx);
    myData = [myData; theseVals];
    myGroups = [myGroups; cIdx*ones(size(theseVals))];
end
boxplot(ax3, myData, myGroups, 'Labels', conditionNames(allCondsIdx));
xlim(ax3,[0.5 nConds+0.5]); box(ax3,'off');
% [p,~,stats] = anova1(myData,myGroups,'off');
% fprintf('Population-level ANOVA p=%.4g\n', p);
% posthoc=multcompare(stats,'ctype','tukey-kramer'); disp(posthoc);

saveas(f2, [directory '/wave_clus/raster_figures/' 'population_PSTHs'], 'png')

%% 3.1) Violin Plot
fprintf('plotting violin plot\n');
close all
clear f3
f3 = figure('Color','w','Name','Violin Plots: Per-Neuron Mean Rate','Visible', 'off');
hold on; title('Violin Plot of [0-3s] Firing Rate across Neurons');
ylabel('Mean Firing Rate [spikes/s]');
[nN, nC] = size(popAvgRate);
allData=[]; allGroups=[];
for c=1:nC
    vals = popAvgRate(:,c);
    allData=[allData; vals]; 
    allGroups=[allGroups; c*ones(nN,1)];
end
violinplot(allData, allGroups,'ShowMean', true); %,'ViolinColor', cell2mat(myColors), 'Labels', cell2mat(conditionNames), 
box off; hold off;

saveas(f3, [directory '/wave_clus/raster_figures/' 'violin_FR_across_neurons'], 'png')

%% 3.2) Heatmaps (Z-scored)
fprintf('plotting heat maps\n');
close all
clear f4
f4 = figure('Color','w','Name','PSTH Heatmaps','Units','normalized','Position',[0.2 0.1 0.7 0.7],'Visible', 'off');
[nNeurons, ~, nConds] = size(popZscoredPSTH);
for c=1:nConds
    subplot(2,3,c);
    dataMatrix = squeeze(popZscoredPSTH(:,:,c));  % (nNeurons x nBins)
    imagesc(timeCenters, 1:nNeurons, dataMatrix);
    set(gca,'YDir','normal'); colormap(gca,'viridis');
    caxis([-0.3 0.7]); colorbar;
    title(conditionNames{c}); xlabel('Time (s)'); ylabel('Neuron #');
end
sgtitle('Heatmaps of Z-scored PSTH across Neurons');

saveas(f4, [directory '/wave_clus/raster_figures/' 'heat_maps_PSTH'], 'png')

%% 4) CONTROL ANALYSES (Sub-sampling, random onsets, spike jitter)
nNeuron=2; % pick an example neuron

% i) Sub-Sampling
fprintf('plotting control: subsampling\n');
close all
clear f5
f5 = figure('Name','Sub-sampled PSTH','Color','w','Units','normalized','Position',[0.1 0.3 0.7 0.4],'Visible', 'off'); 
sgtitle(['Control: Sub-sampled PSTH for channel#' num2str(nNeuron)], 'FontWeight', 'bold', 'FontSize', 15)
ax4 = subplot(1,2,2);hold on;
title(ax4, ['Z-scored PSTH']);
xlabel(ax4, 'Time (s)'); ylabel(ax4, 'Z-score'); legend(ax4, 'Location','best'); box off;
ax5 = subplot(1,2,1);hold on;
xlabel(ax5, 'Time (s)'); ylabel(ax5, 'Spikes/s'); legend(ax5, 'Location','best'); box off;
title(ax5, ['Raw PSTH']);
spikeTimes=Range(A{nNeuron},'s');
trialCounts=zeros(1,nConds);
for c=1:nConds
    trialCounts(c)=length(Range(stim_states{c},'s'));
end
Nmin=min(trialCounts);

for c=1:nConds
    onAll = Range(stim_states{c},'s');
    idx = randperm(trialCounts(c), Nmin);
    subsetOnsets = onAll(idx);
    [mP, sP, ~, mPz, sPz, ~] = ComputePSTH(spikeTimes, subsetOnsets, timeEdges);
    ciUp = mP + 1.96*sP; ciLo = mP - 1.96*sP;
    ciUp_z = mPz + 1.96*sPz; ciLo_z = mPz - 1.96*sPz;
    

    fill(ax4, [timeCenters fliplr(timeCenters)], [ciUp fliplr(ciLo)], ...
         myColors{c}, 'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
    plot(ax4, timeCenters,mP,'Color',myColors{c},'LineWidth',2,'DisplayName',conditionNames{c});

    fill(ax5, [timeCenters fliplr(timeCenters)], [ciUp_z fliplr(ciLo_z)], ...
         myColors{c}, 'FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
    plot(ax5, timeCenters,mPz,'Color',myColors{c},'LineWidth',2,'DisplayName',conditionNames{c});
end

saveas(f5, [directory '/wave_clus/raster_figures/' 'control_subsampling_PSTH'], 'png')


% ii) Random Onsets
fprintf('plotting control: random onsets\n');
close all
clear f6
f6 = figure('Name','Shuffle Control','Color','w','Units','normalized','Position',[0.1 0.3 0.7 0.4],'Visible', 'off');
sgtitle('Shuffle Control: True PSTH vs Random Onset PSTH', 'FontWeight', 'bold', 'FontSize', 15);

ax(1) = subplot(1,2,1); hold on; title('True PSTH');
ax(2) = subplot(1,2,2); hold on; title('Random-Onset PSTH');
c=1; % e.g. Wake

trueOnsets=Range(stim_states{c},'s');
[mean_true,sem_true]=ComputePSTH(spikeTimes,trueOnsets,timeEdges);
tc=timeCenters;
subplot(1,2,1);
fill([tc fliplr(tc)], [mean_true+1.96*sem_true fliplr(mean_true-1.96*sem_true)], ...
     'b','FaceAlpha',0.2,'EdgeColor','none');
plot(tc,mean_true,'b','LineWidth',2); xlabel('Time(s)'); ylabel('Spikes/s');

nOnsets=length(trueOnsets);
% load([directory '/SleepScoring_OBGamma.mat'], 'Epoch')
% temp=End(Epoch)/1e4;
temp=trueOnsets(end);
randOnsets=sort(rand(nOnsets,1)*temp(end));
[mean_rand,sem_rand]=ComputePSTH(spikeTimes,randOnsets,timeEdges);
subplot(1,2,2);
fill([tc fliplr(tc)], [mean_rand+1.96*sem_rand fliplr(mean_rand-1.96*sem_rand)], ...
     'r','FaceAlpha',0.2,'EdgeColor','none');
plot(tc,mean_rand,'r','LineWidth',2); xlabel('Time(s)'); ylabel('Spikes/s');
linkaxes(ax, 'y')
saveas(f6, [directory '/wave_clus/raster_figures/' 'control_random_onsets_PSTH'], 'png')

% iii) Spike Jitter
fprintf('plotting control: spike jitter\n');

J=0.5; % ±500 ms
close all
clear f7
f7 = figure('Name','Spike Jitter','Color','w','Visible', 'off'); hold on;
[mean_orig,sem_orig] = ComputePSTH(spikeTimes,trueOnsets,timeEdges);
jitterVec = (2*J)*rand(size(spikeTimes)) - J;
jitSpikes = spikeTimes + jitterVec;
[mean_jit,sem_jit] = ComputePSTH(jitSpikes,trueOnsets,timeEdges);
fill([tc fliplr(tc)], [mean_orig+1.96*sem_orig fliplr(mean_orig-1.96*sem_orig)], ...
     'b','FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
plot(tc,mean_orig,'b','LineWidth',2,'DisplayName','Original');
fill([tc fliplr(tc)], [mean_jit+1.96*sem_jit fliplr(mean_jit-1.96*sem_jit)], ...
     'r','FaceAlpha',0.2,'EdgeColor','none','HandleVisibility','off');
plot(tc,mean_jit,'r','LineWidth',2,'DisplayName','Jittered');
xlabel('Time(s)'); ylabel('Spikes/s'); legend('Location','best'); box off;
title(sprintf('Spike Jitter (Neuron %d, Cond=%s)',nNeuron,conditionNames{c}));
saveas(f7, [directory '/wave_clus/raster_figures/' 'control_spike_jitter'], 'png')

end