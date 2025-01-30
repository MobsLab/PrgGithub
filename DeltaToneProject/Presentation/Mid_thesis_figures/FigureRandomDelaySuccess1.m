% FigureRandomDelaySuccess1
% 14.12.2016 KJ
%
% Plot the rate success for random tone relative to the delay between the
% tone and the preceeding delta/down
% 
% 
%   see Figure3PowerDensity FigureRandomDelaySuccess2
%

clear
load([FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat']) 

%params
colori = {[0.5 0.3 1]; [1 0.5 1]; [0.8 0 0.7]; [0.1 0.7 0]; [0.5 0.2 0.1]};
NameSubstages = {'N1';'N2';'N3';'REM';'Wake'};
ranges_delay = [0 80:90:980]*10;   


%% For each animal
for m=1:length(animals)
    %delta
    delay = diff.delay{m};
    for i=1:length(ranges_delay)-1
        delta.induce(m,i) = sum(diff.induce{m}(delay>=ranges_delay(i) & delay<ranges_delay(i+1)));
        delta.number(m,i) = sum(delay>=ranges_delay(i) & delay<ranges_delay(i+1));
    end
    
    %down
    delay = mua.delay{m};
    for i=1:length(ranges_delay)-1        
        down.induce(m,i) = sum(mua.induce{m}(delay>=ranges_delay(i) & delay<ranges_delay(i+1)));
        down.number(m,i) = sum(delay>=ranges_delay(i) & delay<ranges_delay(i+1));
    end
end

%% Data for PlotErrorBar 
ratio_delta = delta.induce ./ delta.number;
ratio_down = down.induce ./ down.number;

labels = cell(0);
for i=1:length(ranges_delay)
    labels{end+1} = num2str(round(ranges_delay(i)/10));
end


%% For each substage

%delta
all_substage = cell2mat(diff.substage(:));
all_delay = cell2mat(diff.delay(:));
for i=1:length(ranges_delay)-1    
    delta_prctile = all_substage(all_delay>ranges_delay(i) & all_delay<ranges_delay(i+1));
    for sub=substage_ind
        delta.substage(sub,i) = sum(delta_prctile==sub)/length(delta_prctile);
    end
end
delta.ratio_n2n3 = sum(delta.substage([2 3],:),1) ./ sum(delta.substage,1);

%down
all_substage = cell2mat(mua.substage(:));
all_delay = cell2mat(mua.delay(:));
for i=1:length(ranges_delay)-1    
    down_prctile = all_substage(all_delay>ranges_delay(i) & all_delay<ranges_delay(i+1));
    for sub=substage_ind
        down.substage(sub,i) = sum(down_prctile==sub)/length(down_prctile);
    end
end
down.ratio_n2n3 = sum(down.substage([2 3],:),1) ./ sum(down.substage,1);


%% plot
figure, hold on
x = 1:length(ranges_delay)-1;
PlotErrorLineN_KJ(delta.ratio_n2n3, 'newfig',0,'linecolor','b'); hold on
PlotErrorLineN_KJ(ratio_delta, 'newfig',0,'linecolor','k'); hold on
xlabel('Delays between delta and sound (0-20 are the smallest delays)'),
ylabel('Percentgae'),
legend('% of N2+N3', '% of success tones'), hold on
set(gca, 'XTickLabel', labels,'XTick',(1:numel(labels)+1) - 0.5, 'XTickLabelRotation', 30), hold on,
title('Delays between tone and following delta wave - Random Tone Condition')





