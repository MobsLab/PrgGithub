function PSTH_GammaBins_SingleNeuron(A, iNeuron, SmoothGamma, Wake, Starttime, directory)
% PSTH_GammaBins_SingleNeuron
%
% 1) Restrict gamma to Wake: Gamma_Wake
% 2) Bin the gamma power into 10 equal bins (lowest->highest)
% 3) For each bin, restrict stimulus onset times to that bin
% 4) Compute PSTH for each bin
% 5) Plot 10 PSTHs on the same figure, color-coded from blue (low gamma) to red (high gamma)
%
% INPUTS:
%   A         = cell array of ts objects for your spikes
%   iNeuron   = index of the neuron in A (e.g. 2)
%   SmoothGamma = tsd with gamma power (time vs power)
%   Wake      = intervalSet (the Wake epochs)
%   Starttime = stimulus onsets (ts object), or numeric times
%
% By: <Your Name>, <Date>
% ----------------------------------------------------------

%
% Gamma_Wake = Restrict(SmoothGamma, Wake);
% [Y,X]=hist(log(Data(Gamma_Wake)),1000);
% plot(X,Y)
% 
% 
% Data(Gamma_Wake)

%% 1) Restrict gamma to Wake
Gamma_Wake = Restrict(SmoothGamma, Wake);

% Extract time/power arrays
tGamma = Range(Gamma_Wake);
pGamma = Data(Gamma_Wake);

%% 2) Bin gamma power into 10 bins
nBins = 4;
% Edges from min->max of pGamma
pMin = min(pGamma);
pMax = max(pGamma);
edges = linspace(pMin, pMax, nBins+1);

% We'll create intervalSets for each bin. The logic:
%   For bin i, we keep times tGamma where pGamma is in [edges(i), edges(i+1))

binEpochs = cell(nBins,1);

for i = 1:nBins
    lowEdge  = edges(i);
    highEdge = edges(i+1);
    
    % We find time points where pGamma is in [lowEdge, highEdge)
    idx = (pGamma >= lowEdge & pGamma < highEdge);
    if i == nBins
        % For the top bin, include pGamma == highEdge
        idx = (pGamma >= lowEdge & pGamma <= highEdge);
    end
    
    theseTimes = tGamma(idx);
    % Now we must convert theseTimes into an intervalSet. 
    % Typically, you'd stitch consecutive times together if you want continuous intervals.
    % But gamma might be sampled at discrete steps. We'll define small intervals around each time step. 
    % Alternatively, we can define an interval per sample, or merge close samples. 
    % For simplicity, let's define each time step as a ~1-sample interval. 
    % If you have sampling dt, we can do dt=median(diff(tGamma)).

    dt = median(diff(tGamma));  % approximate sampling interval
    if isempty(dt) || isnan(dt)
        dt = 0.01; % fallback (10ms)
    end

    starts = theseTimes - dt/2;
    ends   = theseTimes + dt/2;
    
    % Construct intervalSet
    binEpochs{i} = intervalSet(starts, ends);
end

%% 3) For each bin, restrict the stimulus onset times to that bin
% We'll store in cell array
stim_onsetBins = cell(nBins,1);

stim_onset = ts(Starttime); % If your Starttime is numeric, wrap it in ts(...) or adjust code

for i = 1:nBins
    stim_onsetBins{i} = Restrict(stim_onset, binEpochs{i});
end

%% 4) Compute PSTH for each bin for a single neuron
% We'll define PSTH parameters
t_pre  = -1; % 1s before onset
t_post =  5; % 5s after
binSize= 0.1;
timeEdges = t_pre:binSize:t_post;
timeCenters = (timeEdges(1:end-1)+timeEdges(2:end))/2;

neuronSpikeTimes = Range(A{iNeuron}, 's');

psthCell = cell(nBins,1);

% We'll define a colormap for 10 bins
cmap = parula(nBins);  % or your choice: jet(10), hot(10), etc.

f = figure('Name','Gamma-Binned PSTHs','Color','w','Visible', 'off'); hold on;
title(sprintf(['Neuron %d: PSTHs in ' num2str(nBins) ' Gamma Power Bins (Wake)'], iNeuron));
xlabel('Time from Stimulus (s)');
ylabel('Firing Rate (spikes/s)');
box off;

for i = 1:nBins
    theseOnsets = Range(stim_onsetBins{i}, 's');
    nOnsets = length(theseOnsets);
    
    if nOnsets < 1
        % No trials in this bin, skip
        continue;
    end
    
    % Build a trial-by-trial PSTH
    trialsMatrix = zeros(nOnsets, length(timeEdges)-1);
    for iOnset = 1:nOnsets
        relTimes = neuronSpikeTimes - theseOnsets(iOnset);
        inWindow = (relTimes >= t_pre & relTimes <= t_post);
        spk = relTimes(inWindow);
        counts = histcounts(spk, timeEdges);
        trialsMatrix(iOnset,:) = counts / binSize;
    end
    
    % Mean PSTH
    meanPSTH = mean(trialsMatrix,1);
    semPSTH  = std(trialsMatrix,0,1)/sqrt(nOnsets);
    
    % Plot with a color that reflects bin i
    thisColor = cmap(i,:);
    ciUp = meanPSTH + semPSTH;
    ciLo = meanPSTH - semPSTH;
    
    % Shaded error region
    fill([timeCenters fliplr(timeCenters)], [ciUp fliplr(ciLo)], ...
         thisColor, 'FaceAlpha',0.2, 'EdgeColor','none', 'HandleVisibility','off');
    
    % PSTH line
    plot(timeCenters, meanPSTH, 'Color', thisColor, 'LineWidth',2, ...
        'DisplayName', sprintf('Gamma bin %d (%d trials)', i, nOnsets));
end

% Add legend
legend('Location','best');

saveas(f, [directory '/wave_clus/raster_figures/' 'PSTH_gamma_Wake_channel_' num2str(iNeuron)], 'png')

end
