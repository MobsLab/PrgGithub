% DistribDelayToneShamDeltaMousePlot
% 11.07.2019 KJ
%
% quantification of the delay between a tone/sham and the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are plotted for each mouse
%
%   see DistribDelayToneShamDelta QuantifDelayTonevsDelta QuantifDelayShamDelta QuantifDelayShamRandomDeltaTone
%


clear
load(fullfile(FolderDeltaDataKJ,'DeltaToneRefractoryPeriodAnalysisData.mat'))

%params
perc = 0:5:100;
colori = {[0.5 0.3 1]; [1 0.5 1]; [0.8 0 0.7]; [0.1 0.7 0]; [0.5 0.2 0.1]; 'r'};


%% RANDOM TONE

%percentile
all_delay = cell2mat(tones.delay(:));
all_delay = all_delay(all_delay<7000);
percentiles_delta = prctile(all_delay,perc);
labels = cell(0);
xdata_random = (percentiles_delta(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = tones.delay{m};
    restrictions = (tones.substage{m}==2 | tones.substage{m}==3) & (tones.tonein{m}==0);
    for i=1:length(percentiles_delta)-1
        restrict_tones.induce(m,i) = sum(tones.induce{m}(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1)));
        restrict_tones.number(m,i) = sum(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end
% Data for PlotLineError 
percentage_tones.random = (restrict_tones.induce ./ restrict_tones.number)*100;

%% RANDOM SHAM

%percentile
all_delay = cell2mat(sham.delay(:));
all_delay = all_delay(all_delay<7000);
percentiles_delta = prctile(all_delay,perc);
labels = cell(0);
xdata_sham = (percentiles_delta(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = sham.delay{m};
    restrictions = (sham.substage{m}==2 | sham.substage{m}==3) & (sham.tonein{m}==0);
    for i=1:length(percentiles_delta)-1
        restrict_sham.induce(m,i) = sum(sham.induce{m}(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1)));
        restrict_sham.number(m,i) = sum(restrictions & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end
% Data for PlotLineError 
percentage_sham.random = (restrict_sham.induce ./ restrict_sham.number)*100;



%% PLOT
for m=1:length(animals)
    %Line
    figure, hold on
    [~,h(1)]=PlotErrorLineN_KJ(percentage_tones.random(m,:),'x_data',xdata_random,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
    [~,h(2)]=PlotErrorLineN_KJ(percentage_sham.random(m,:),'x_data',xdata_sham,'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');
    legend(h,'Random tone', 'Random Sham')
    title(animals{m},'fontsize',16)
    set(gca,'XTick',0:100:700,'Xlim',[-20 720],'YTick',0:20:80,'YLim',[0 60],'FontName','Times','fontsize',20), hold on,
    ylabel('% of tones evoking a delta waves'), xlabel('delay between delta waves occurence and auditory stimuli')
end






