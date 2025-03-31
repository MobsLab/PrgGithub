% FigureSuccessRateDelay2
% 15.05.2017 KJ
%
% Success rate in function of the delay between delta waves and tones (in DeltaToneConditions)
% 
%   see SuccessRateDelaySWS QuantifSuccessDeltaShamToneSubstage
%


%load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifSuccessDeltaShamToneSubstage_bis2.mat'))


%params
yes=2;
no=1;
sws_ind = [2 3];
animals_ind = 1:length(animals);
labels_deltatone = {'0ms','140ms','320ms','490ms'};
color_deltatone = [70 180 10]/255;

%% DELTA TONE

idx_delay = [1 2 3 4];
xdata_deltatone = [0 140 320 490];

%delta
percentage_sucess.deltatone = [];
for d=idx_delay
    success = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,yes),2));
    fail = squeeze(sum(deltas.tone.density(d,sws_ind,animals_ind,yes,no),2));
    if isempty(percentage_sucess.deltatone)
        percentage_sucess.deltatone = success ./ (success + fail);
    else
        percentage_sucess.deltatone = [percentage_sucess.deltatone success ./ (success + fail)];
    end
    
end
percentage_sucess.deltatone = 100 * percentage_sucess.deltatone;


%% RANDOM TONE
load(fullfile(FolderDeltaDataKJ,'QuantifRefractoryPeriod_bis.mat'))

perc = 0:5:100;
colori = {[0.5 0.3 1]; [1 0.5 1]; [0.8 0 0.7]; [0.1 0.7 0]; [0.5 0.2 0.1]};
NameSubstages = {'N1';'N2';'N3';'REM';'Wake'};

%% percentile
all_delay = cell2mat(result.delay(:));
all_delay = all_delay(all_delay<7000);
percentiles_delta = prctile(all_delay,perc);
labels = cell(0);
xdata_random = (percentiles_delta(1:end-1)) / 10;

% For each animal - N2+N3
for m=1:length(animals)
    %delta
    delay = result.delay{m};
    restrict_substage = result.substage{m}==2 | result.substage{m}==3;
    for i=1:length(percentiles_delta)-1
        restrict.induce(m,i) = sum(result.induce{m}(restrict_substage & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1)));
        restrict.number(m,i) = sum(restrict_substage & delay>=percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end
% Data for PlotLineError 
percentage_sucess.random = (restrict.induce ./ restrict.number)*100;


%% exclude mouse328
% percentage_sucess.deltatone(8,1)=10;
% percentage_sucess.deltatone(6,2)=30;

% percentage_sucess.random([6 8 9],:)=[];


%% PLOT

%Line
labels_tone={'~0ms','~140ms','~320ms','~490ms'};
figure, hold on
[~,h(1)]=PlotErrorLineN_KJ(percentage_sucess.random,'x_data',xdata_random,'newfig',0,'linecolor',[0.75 0.75 0.75],'ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(percentage_sucess.deltatone,'x_data',xdata_deltatone,'newfig',0,'linecolor',color_deltatone,'ShowSigstar','none','linespec','-om','linewidth',3,'errorbars',1,'linespec','.');
legend(h,'Random tone','Delta Triggered tone')
title('Success rate for Delta triggered and Random Condition','fontsize',16)
set(gca,'XTick',0:100:700,'Xlim',[-20 720],'YTick',0:20:80,'YLim',[0 60],'FontName','Times','fontsize',20), hold on,
ylabel('% of tones evoking a delta waves'), xlabel('delay between delta waves occurence and auditory stimuli')



% figure, hold on
% subplot(1,2,1), hold on
% [~,eb]=PlotErrorBarN_KJ(percentage_sucess.delta.deltatone,'newfig',0);
% set(eb,'Linewidth',2); %bold error bar
% title('Delta triggered Tone','fontsize',16)
% set(gca, 'XTickLabel',labels_deltatone, 'XTick',1:numel(labels_deltatone),'YTick',0:20:80,'YLim',[0 80],'FontName','Times','fontsize',16), hold on,
% ylabel('% of tones evoking a delta waves'),
% 
% subplot(1,2,2), hold on
% [~,eb]=PlotErrorBarN_KJ(percentage_sucess.delta.random,'newfig',0);
% set(eb,'Linewidth',2); %bold error bar
% title('Random Tone','fontsize',16)
% set(gca, 'XTickLabel',labels_rdm, 'XTick',1:numel(labels_rdm),'YTick',0:20:80,'YLim',[0 80],'FontName','Times','fontsize',16), hold on,


