% RandomPethAnalysis2
% 07.12.2016 KJ
%
% Quantification
% 
% 
%   see RandomPethAnalysis RandomPethAnalysis_bis
%

clear
load([FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat']) 
perc = 0:5:100;

%% For each animal

for m=1:2
    %delta
    delay = diff.delay{m};
    percentiles_delta = prctile(delay,perc);
    for i=1:length(percentiles_delta)-1
        delta.induce(m,i) = sum(diff.induce{m}(delay>percentiles_delta(i) & delay<percentiles_delta(i+1)));
        delta.number(m,i) = sum(delay>percentiles_delta(i) & delay<percentiles_delta(i+1));
    end
    delta.percentiles(m,:) = percentiles_delta';
    
    %down
    delay = mua.delay{m};
    percentiles_down = prctile(delay, perc);
    for i=1:length(percentiles_down)-1        
        down.induce(m,i) = sum(mua.induce{m}(delay>percentiles_down(i) & delay<percentiles_down(i+1)));
        down.number(m,i) = sum(delay>percentiles_down(i) & delay<percentiles_down(i+1));
    end
    down.percentiles(m,:) = percentiles_down';
    
end

%all mice 
ratio_delta = delta.induce ./ delta.number;
ratio_down = down.induce ./ down.number;

labels = cell(0);
for i=1:length(perc)
    labels{end+1} = num2str(perc(i));
end

%% plot
figure, hold on
subplot(1,2,1)
PlotErrorBarN_KJ(ratio_delta, 'newfig',0);
xlabel('Percentile of delay between delta and sound (0-20 are the smallest delays)'),
ylabel('% of success tones'),
set(gca, 'XTickLabel', labels,'XTick',(1:numel(labels)+1) - 0.5), hold on,
title('Delta waves')

subplot(1,2,2)
PlotErrorBarN_KJ(ratio_down, 'newfig',0);
xlabel('Percentile of delay between down and sound (0-20 are the smallest delays)'),
ylabel('% of success tones'),
set(gca, 'XTickLabel', labels,'XTick',(1:numel(labels)) - 0.5), hold on,
title('Down states')











