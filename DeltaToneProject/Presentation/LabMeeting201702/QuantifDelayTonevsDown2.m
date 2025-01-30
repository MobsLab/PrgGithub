% QuantifDelayTonevsDown2
% 15.02.2017 KJ
%
% collect data for the quantification of the delay between a tone a the next delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayFirstDeltaToneSubstage QuantifDelayTonevsDown

%load
clear
eval(['load ' FolderProjetDelta 'Data/QuantifDelayTonevsDown.mat'])

substage_plot = substages_ind;

%% Concatenate
%params
step = 20;
max_edge = 500;
edges = 0:step:max_edge;
smoothing=2;

animals = unique(delay_res.name);

delay_down_tone = [];
for sub=substage_plot
    for p=1:length(delay_res.path)
            delay_down_tone = [delay_down_tone ; delay_res.delay_down_tone{p,sub}];
    end
end

downs.medians_delay = median(delay_down_tone(delay_down_tone/10<max_edge))/10;
downs.modes_delay = mode(delay_down_tone(delay_down_tone/10<max_edge))/10;
h = histogram(delay_down_tone/10, edges,'Normalization','probability');
downs.histo.x = h.BinEdges(2:end) - step/2;
downs.histo.y = SmoothDec(h.Values,smoothing); close



%% plot
%Down delay distribution
figure, hold on
bar(downs.histo.x, downs.histo.y, 1), hold on,
xlabel('time (ms)'),
set(gca,'XTick',0:100:500,'Ytick',[0 0.05 0.1],'YLim',[0 0.1],'FontName','Times','fontsize',16), hold on,
line([200 200],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
title('Distribution of the delays between tones and the next down state')