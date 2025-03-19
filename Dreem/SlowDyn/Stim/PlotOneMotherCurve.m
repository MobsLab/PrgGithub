% PlotOneMotherCurve
% 03.10.2018 KJ
%
%       
%
% SEE 
%   ParcoursMotherCurvesSlowDyn ParcoursMotherCurvesSlowDynPlot
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

%rec
p=100; %138914
rec = 233154;
p = find(cell2mat(Dir.filereference)==rec);

%params
channel_frontal = [1 2 5 6];
binsize_met = 10;
nbBins_met  = 300;

%load signals and data
[signals, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
signals = signals(channel_frontal);
labels_eeg = labels_eeg(channel_frontal);

%stimulations
[stim_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
nb_stim= length(stim_tmp);


%% Mean Curves sync on Tones/Sham
if ~isempty(stim_tmp)
    for ch=1:length(signals)
        [m,s,tps] = mETAverage(stim_tmp, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
        met_tones{ch}(:,1) = tps; met_tones{ch}(:,2) = m; met_tones{ch}(:,3) = m;

        [m,s,tps] = mETAverage(sham_tmp, Range(signals{ch}), Data(signals{ch}), binsize_met, nbBins_met);
        met_sham{ch}(:,1) = tps; met_sham{ch}(:,2) = m; met_sham{ch}(:,2) = m;
    end
end


%% Plot
figure, hold on

for ch=1:4
    subplot(2,2,ch), hold on
    h(1) = plot(met_tones{ch}(:,1), met_tones{ch}(:,2), 'color', 'b'); hold on
    h(2) =  plot(met_sham{ch}(:,1), met_sham{ch}(:,2), 'color', 'r'); hold on
    
    set(gca, 'ylim', [-80 80], 'fontsize', 16),
    line([0 0], ylim,'color','k','linewidth',1), hold on
    legend(h, 'stim', 'sham'),
    xlabel('time from stim/sham (ms)'), ylabel('µV'),
    title(['channel ' num2str(ch)])
end

% channel
figure, hold on
ch=4;
h(1) = plot(met_tones{ch}(:,1), met_tones{ch}(:,2), 'color', 'b','linewidth',2); hold on
h(2) =  plot(met_sham{ch}(:,1), met_sham{ch}(:,2), 'color', 'r','linewidth',2); hold on
set(gca, 'ylim', [-80 80], 'fontsize', 26),
line([0 0], ylim,'color','k','linewidth',1), hold on
legend(h, 'stim', 'sham'),
xlabel('time from stim/sham (ms)'), ylabel('µV'),
title('1 night - F8-02')








