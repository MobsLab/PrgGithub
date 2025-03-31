% QuantifDelayTonevsDelta2
% 15.02.2017 KJ
%
% collect data for the quantification of the delay between a tone a the next delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayFirstDeltaToneSubstage QuantifDelayTonevsDelta

%load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifDelayTonevsDelta.mat'))


%% Concatenate
%params
hstep = 10;
max_edge = 600;
edges = 0:hstep:max_edge;
smoothing=2;
thresh_delay = 300;
proba_max = 0.04;


delay_delta_tone = [];
for sub=substages_ind
    for p=1:length(delay_res.path)
        delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
    end
end

deltas.medians_delay = median(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
deltas.modes_delay = mode(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
h = histogram(delay_delta_tone/10, edges,'Normalization','probability');
deltas.histo.x = h.BinEdges(2:end) - hstep/2;
deltas.histo.y = SmoothDec(h.Values,smoothing); close



%% plot
%Delta delay distribution
figure, hold on
bar(deltas.histo.x, deltas.histo.y,1), hold on,
xlabel('time (ms)'), ylabel('density')
set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge-100],'Ytick',0:0.02:proba_max,'YLim',[0 proba_max],'FontName','Times','fontsize',16), hold on,
line([thresh_delay thresh_delay],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
%title('Distribution of the delays between tones and the next delta wave')
y_rec1 = [0 0 proba_max proba_max];
x_rec1 = [0 thresh_delay thresh_delay 0];
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.2);
y_rec2 = [0 0 proba_max proba_max];
x_rec2 = [thresh_delay max_edge max_edge thresh_delay];
hold on, patch(x_rec2, y_rec2, 'r', 'EdgeColor', 'None', 'FaceAlpha', 0.2);




