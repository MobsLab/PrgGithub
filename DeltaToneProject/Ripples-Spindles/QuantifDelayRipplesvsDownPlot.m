% QuantifDelayRipplesvsDownPlot
% 21.09.2017 KJ
%
% plot data for the quantification of the delay between a ri a the next delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are plotted
%
%   see QuantifDelayShamDelta QuantifDelayTonevsDelta2

%load
clear
eval(['load ' FolderProjetDelta 'Data/QuantifDelayRipplesvsDeltaDown.mat'])


%% Concatenate
%params
hstep = 10;
max_edge = 600;
edges = 0:hstep:max_edge;
smoothing=2;
thresh_delay_delta = 190;
thresh_delay_down = 120;
proba_max = 0.04;


delay_delta_ripples = [];
delay_down_ripples = [];
for sub=substages_ind
    for p=1:length(delay_res.path)
        delay_delta_ripples = [delay_delta_ripples ; delay_res.delay_delta_ripples{p,sub}];
        delay_down_ripples = [delay_down_ripples ; delay_res.delay_down_ripples{p,sub}];
    end
end

%delta
deltas.medians_delay = median(delay_delta_ripples(delay_delta_ripples/10<max_edge))/10;
deltas.modes_delay = mode(delay_delta_ripples(delay_delta_ripples/10<max_edge))/10;
h = histogram(delay_delta_ripples/10, edges,'Normalization','probability');
deltas.histo.x = h.BinEdges(2:end) - hstep/2;
deltas.histo.y = SmoothDec(h.Values,smoothing); close

%down
downs.medians_delay = median(delay_down_ripples(delay_down_ripples/10<max_edge))/10;
downs.modes_delay = mode(delay_down_ripples(delay_down_ripples/10<max_edge))/10;
h = histogram(delay_down_ripples/10, edges,'Normalization','probability');
downs.histo.x = h.BinEdges(2:end) - hstep/2;
downs.histo.y = SmoothDec(h.Values,smoothing); close


%% DATA to plot
binsize = 0.01;

deltas.plot.x = [];
deltas.plot.y = [];
for k=1:length(deltas.histo.x)
    xk = deltas.histo.x(k)-hstep/2:binsize:deltas.histo.x(k)+hstep/2;
    deltas.plot.x = [deltas.plot.x xk];
    deltas.plot.y = [deltas.plot.y deltas.histo.y(k)*ones(1,length(xk))];
end

downs.plot.x = [];
downs.plot.y = [];
for k=1:length(downs.histo.x)
    xk = downs.histo.x(k)-hstep/2:binsize:downs.histo.x(k)+hstep/2;
    downs.plot.x = [downs.plot.x xk];
    downs.plot.y = [downs.plot.y downs.histo.y(k)*ones(1,length(xk))];
end


%% plot

figure, hold on

%delay distribution
subplot(2,1,1), hold on
plot(deltas.plot.x, deltas.plot.y,'r','LineWidth',2), hold on,

xlabel('time (ms)'), ylabel('density')
set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge-100],'Ytick',0:0.02:proba_max,'YLim',[0 proba_max],'FontName','Times','fontsize',20), hold on,
line([thresh_delay_delta thresh_delay_delta],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
title('Distribution of the delays between ripples and the next delta wave')

y_rec1 = [0 0 proba_max proba_max];
x_rec1 = [0 thresh_delay_delta thresh_delay_delta 0];
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.2);
y_rec2 = [0 0 proba_max proba_max];
x_rec2 = [thresh_delay_delta max_edge max_edge thresh_delay_delta];
hold on, patch(x_rec2, y_rec2, 'r', 'EdgeColor', 'None', 'FaceAlpha', 0.2);

%down distribution
subplot(2,1,2), hold on
plot(downs.plot.x, downs.plot.y,'color',[0.75 0.75 0.75],'LineWidth',2), hold on,

xlabel('time (ms)'), ylabel('density')
set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge-100],'Ytick',0:0.02:proba_max,'YLim',[0 proba_max],'FontName','Times','fontsize',20), hold on,
line([thresh_delay_down thresh_delay_down],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
title('Distribution of the delays between ripples and the next down state')

y_rec1 = [0 0 proba_max proba_max];
x_rec1 = [0 thresh_delay_down thresh_delay_down 0];
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.2);
y_rec2 = [0 0 proba_max proba_max];
x_rec2 = [thresh_delay_down max_edge max_edge thresh_delay_down];
hold on, patch(x_rec2, y_rec2, 'r', 'EdgeColor', 'None', 'FaceAlpha', 0.2);

