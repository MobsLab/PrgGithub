% FigureDelayToneDelta
% 17.12.2016 KJ
%
% distributions of the delays after the tones 
% - c
% 
%   see QuantifDelayFirstDeltaToneSubstage3
%

%load
clear
eval(['load ' FolderProjetDelta 'Data/QuantifDelayFirstDeltaToneSubstage.mat'])


%% Concatenate
%params
step = 20;
max_edge = 500;
edges = 0:step:max_edge;
smoothing=2;

animals = unique(delay_res.name);

delay_delta_tone = [];
for sub=substages_ind
    for p=1:length(delay_res.path)
            delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
    end
end

deltas.medians_delay = median(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
deltas.modes_delay = mode(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
h = histogram(delay_delta_tone/10, edges,'Normalization','probability');
deltas.histo.x = h.BinEdges(2:end) - step/2;
deltas.histo.y = SmoothDec(h.Values,smoothing); close



%% plot
%Delta
figure, hold on
plot(deltas.histo.x, deltas.histo.y, 'color', 'k','linewidth',2), hold on,
line([300 300],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
xlabel('time (ms)'),
set(gca,'XTick',0:100:500,'Ytick',[0 0.02 0.05 0.08],'FontName','Times','fontsize',16), hold on,





