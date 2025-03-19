% FigureDelayRefractoryPeriod
% 17.12.2016 KJ
%
% 
%   see RandomPethAnalysis3
%

clear
load([FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat']) 

%params
perc = 0:5:100;
colori = {[0.5 0.3 1]; [1 0.5 1]; [0.8 0 0.7]; [0.1 0.7 0]; [0.5 0.2 0.1]};
NameSubstages = {'N1';'N2';'N3';'REM';'Wake'};

%% percentile
all_delay = cell2mat(diff.delay(:));
percentiles_delta = prctile(all_delay,perc);
delta.percentiles = percentiles_delta;

labels = cell(0);
for i=1:length(perc)
    labels{end+1} = num2str(round(delta.percentiles(i)/10));
end

%% Loop over animals
for m=1:length(animals)
    %delta
    delay = diff.delay{m};
    for i=1:length(percentiles_delta)-1
        delta.induce(m,i) = sum(diff.induce{m}(delay>percentiles_delta(i) & delay<percentiles_delta(i+1)));
        delta.number(m,i) = sum(delay>percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end

% Data for PlotErrorBar 
percentage_delta = (delta.induce ./ delta.number)*100;


%% Restricted to N2+N3
for m=1:length(animals)
    %delta
    delay = diff.delay{m};
    restrict_substage = diff.substage{m}==2 | diff.substage{m}==3;
    for i=1:length(percentiles_delta)-1
        restrict.induce(m,i) = sum(diff.induce{m}(restrict_substage & delay>percentiles_delta(i) & delay<percentiles_delta(i+1)));
        restrict.number(m,i) = sum(restrict_substage & delay>percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
end

% Data for PlotLineError 
percentage_delta_sws = (restrict.induce ./ restrict.number)*100;


%% For each substage

%delta
all_substage = cell2mat(diff.substage(:));
all_delay = cell2mat(diff.delay(:));
for i=1:length(percentiles_delta)-1    
    delta_prctile = all_substage(all_delay>percentiles_delta(i) & all_delay<percentiles_delta(i+1));
    for sub=substage_ind
        delta.substage(sub,i) = 100*sum(delta_prctile==sub)/length(delta_prctile);
    end
end
delta.percentage_n2n3 = sum(delta.substage([2 3],:),1) * 100 ./ sum(delta.substage,1);


%% plot
figure, hold on

x = 1:length(perc)-1;

subplot(2,1,1), hold on
% yyaxis right
% plot(x, delta.percentage_n2n3, 'b', 'Linewidth',2);
% legend('% of N2+N3'), hold on, ylim([30 100]),
% yyaxis left
PlotErrorBarN_KJ(percentage_delta, 'newfig',0);
%PlotErrorLineN_KJ(percentage_delta_sws, 'newfig',0,'linecolor','r');
xlabel('Delays between delta and sound (0-20 are the smallest delays)'),
ylabel('% of success tones'), ylim([0 70]),
set(gca, 'XTickLabel', labels,'XTick',(1:numel(labels)+1) - 0.5,'YTick',0:20:100,'FontName','Times','fontsize',16), hold on,


subplot(2,1,2), hold on
b=bar(x, delta.substage', 'stacked'); hold on
set(b,{'FaceColor'},colori);
xlabel('Delays between delta and sound (0-20 are the smallest delays)'),
ylabel('Substage percentage'),
set(gca, 'XTickLabel', labels,'XTick',(1:numel(labels)+1) - 0.5,'XLim', [0 21],'YLim', [0 100],'YTick',0:20:100,'FontName','Times','fontsize',16), hold on,
legend(NameSubstages); 

