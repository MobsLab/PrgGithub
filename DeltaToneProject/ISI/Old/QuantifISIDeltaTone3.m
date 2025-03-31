% QuantifISIDeltaTone3
% 16.09.2016 KJ
%
% plot ISI distribution curves for several conditions
%   - Basal (n+1, n+2)
%   - DeltaTone, efficient tones (n+1, n+2)
%   - DeltaTone, failed tones (n+1, n+2)
% smooth curves
%
% Info
%   In this version of QuantifIsiDeltaTone, we take into account delay of
%   the tones, as well as the first ISI when the tones induced a down/delta
%

cd([FolderProjetDelta 'Data/'])

%% Concatenate
clear 
load QuantifIsiDeltaTone.mat
for i=1:length(delays)    
    %Basal records
    if delays(i)==0
        basal_deltas_isi1 = [];
        basal_deltas_isi2 = [];
        basal_down_isi1 = [];
        basal_down_isi2 = [];
        for p=1:length(basal_res.path)
            basal_deltas_isi1 = [basal_deltas_isi1 ; basal_res.intv_deltas1{p}];
            basal_deltas_isi2 = [basal_deltas_isi2 ; basal_res.intv_deltas2{p}];
            basal_down_isi1 = [basal_down_isi1 ; basal_res.intv_down1{p}];
            basal_down_isi2 = [basal_down_isi2 ; basal_res.intv_down2{p}];
        end
        dltone_delay.delay{i} = delays(i);

    %DeltaTone records
    else
        dltone_gooddelta_isi1 = [];
        dltone_gooddelta_isi2 = [];
        dltone_baddelta_isi1 = [];
        dltone_baddelta_isi2 = [];
        dltone_gooddown_isi1 = [];
        dltone_gooddown_isi2 = [];
        dltone_baddown_isi1 = [];
        dltone_baddown_isi2 = [];
        for p=1:length(deltatone_res.path)
            if deltatone_res.delay{p}==delays(i)
                dltone_gooddelta_isi1 = [dltone_gooddelta_isi1 ; deltatone_res.intv1_good_deltas{p}];
                dltone_gooddelta_isi2 = [dltone_gooddelta_isi2 ; deltatone_res.intv2_good_deltas{p}];
                dltone_baddelta_isi1 = [dltone_baddelta_isi1 ; deltatone_res.intv1_bad_deltas{p}];
                dltone_baddelta_isi2 = [dltone_baddelta_isi2 ; deltatone_res.intv2_bad_deltas{p}];
                dltone_gooddown_isi1 = [dltone_gooddown_isi1 ; deltatone_res.intv1_good_down{p}];
                dltone_gooddown_isi2 = [dltone_gooddown_isi2 ; deltatone_res.intv2_good_down{p}];
                dltone_baddown_isi1 = [dltone_baddown_isi1 ; deltatone_res.intv1_bad_down{p}];
                dltone_baddown_isi2 = [dltone_baddown_isi2 ; deltatone_res.intv2_bad_down{p}];
            end
        end
        dltone_delay.dltone_gooddelta_isi1{i} = dltone_gooddelta_isi1;
        dltone_delay.dltone_gooddelta_isi2{i} = dltone_gooddelta_isi2;
        dltone_delay.dltone_baddelta_isi1{i} = dltone_baddelta_isi1;
        dltone_delay.dltone_baddelta_isi2{i} = dltone_baddelta_isi2;
        dltone_delay.dltone_gooddown_isi1{i} = dltone_gooddown_isi1;
        dltone_delay.dltone_gooddown_isi2{i} = dltone_gooddown_isi2;
        dltone_delay.dltone_baddown_isi1{i} = dltone_baddown_isi1;
        dltone_delay.dltone_baddown_isi2{i} = dltone_baddown_isi2;
        dltone_delay.delay{i} = delays(i);
    end
    
end

clear dltone_gooddelta_isi1 dltone_gooddelta_isi2 dltone_baddelta_isi1 dltone_baddelta_isi2
clear dltone_gooddown_isi1 dltone_gooddown_isi2 dltone_baddown_isi1 dltone_baddown_isi2
clear deltatone_res basal_res i p


%% histograms

%params for histogram
step = 20;
max_edge = 4000;
edges = 0:step:max_edge;
smoothing=2;

%basal data
h = histogram(basal_deltas_isi1/10,edges,'Normalization','probability');
x_b1_delta = h.BinEdges(2:end) - step/2;
y_b1_delta = h.Values; close
h = histogram(basal_deltas_isi2/10,edges,'Normalization','probability');
x_b2_delta = h.BinEdges(2:end) - step/2;
y_b2_delta = h.Values; close
h = histogram(basal_down_isi1/10,edges,'Normalization','probability');
x_b1_down = h.BinEdges(2:end) - step/2;
y_b1_down = h.Values; close
h = histogram(basal_down_isi2/10,edges,'Normalization','probability');
x_b2_down = h.BinEdges(2:end) - step/2;
y_b2_down = h.Values; close

ys_b1_delta = SmoothDec(y_b1_delta,smoothing);
ys_b2_delta = SmoothDec(y_b2_delta,smoothing);
ys_b1_down = SmoothDec(y_b1_down,smoothing);
ys_b2_down = SmoothDec(y_b2_down,smoothing);

leg_b1_delta = ['Basal n+1 (n=' num2str(length(basal_deltas_isi1)) ')'];
leg_b2_delta = ['Basal n+2 (n=' num2str(length(basal_deltas_isi2)) ')'];
leg_b1_down = ['Basal n+1 (n=' num2str(length(basal_down_isi1)) ')'];
leg_b2_down = ['Basal n+2 (n=' num2str(length(basal_down_isi2)) ')'];

m_b1_delta = median(basal_deltas_isi1(basal_deltas_isi1/10<max_edge)/10);
m_b2_delta = median(basal_deltas_isi2(basal_deltas_isi2/10<max_edge)/10);
m_b1_down = median(basal_down_isi1(basal_down_isi1/10<max_edge)/10);
m_b2_down = median(basal_down_isi2(basal_down_isi2/10<max_edge)/10);


%deltatone data
pos_delays = delays(delays>0);
nb_graphs = length(pos_delays);
hist_dltone = cell(0);

for i=1:nb_graphs
    hist_dltone.delay{i} = pos_delays(i);
    p = find(cell2mat(dltone_delay.delay)==pos_delays(i));
    
    %delta success
    h = histogram(dltone_delay.dltone_gooddelta_isi1{p}/10,edges,'Normalization','probability');
    hist_dltone.x_success1_delta{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_success1_delta{i} = SmoothDec(h.Values,smoothing); close
    h = histogram(dltone_delay.dltone_gooddelta_isi2{p}/10,edges,'Normalization','probability');
    hist_dltone.x_success2_delta{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_success2_delta{i} = SmoothDec(h.Values,smoothing); close
    %delta failed
    h = histogram(dltone_delay.dltone_baddelta_isi1{p}/10,edges,'Normalization','probability');
    hist_dltone.x_failed1_delta{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_failed1_delta{i} = SmoothDec(h.Values,smoothing); close
    h = histogram(dltone_delay.dltone_baddelta_isi2{p}/10,edges,'Normalization','probability');
    hist_dltone.x_failed2_delta{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_failed2_delta{i} = SmoothDec(h.Values,smoothing); close
    
    %down success
    h = histogram(dltone_delay.dltone_gooddown_isi1{p}/10,edges,'Normalization','probability');
    hist_dltone.x_success1_down{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_success1_down{i} = SmoothDec(h.Values,smoothing); close
    h = histogram(dltone_delay.dltone_gooddown_isi2{p}/10,edges,'Normalization','probability');
    hist_dltone.x_success2_down{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_success2_down{i} = SmoothDec(h.Values,smoothing); close
    %down failed
    h = histogram(dltone_delay.dltone_baddown_isi1{p}/10,edges,'Normalization','probability');
    hist_dltone.x_failed1_down{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_failed1_down{i} = SmoothDec(h.Values,smoothing); close
    h = histogram(dltone_delay.dltone_baddown_isi2{p}/10,edges,'Normalization','probability');
    hist_dltone.x_failed2_down{i} = h.BinEdges(2:end) - step/2;
    hist_dltone.y_failed2_down{i} = SmoothDec(h.Values,smoothing); close
    
    % legend - delta
    hist_dltone.leg_success1_delta{i} = ['Success tones n+1 (n=' num2str(length(dltone_delay.dltone_gooddelta_isi1{p})) ')'];
    hist_dltone.leg_success2_delta{i} = ['Success tones n+2 (n=' num2str(length(dltone_delay.dltone_gooddelta_isi2{p})) ')'];
    hist_dltone.leg_failed1_delta{i} = ['Failed tones n+1 (n=' num2str(length(dltone_delay.dltone_baddelta_isi1{p})) ')'];
    hist_dltone.leg_failed2_delta{i} = ['Failed tones n+2 (n=' num2str(length(dltone_delay.dltone_baddelta_isi2{p})) ')'];
    %legent - down 
    hist_dltone.leg_success1_down{i} = ['Success tones n+1 (n=' num2str(length(dltone_delay.dltone_gooddown_isi1{p})) ')'];
    hist_dltone.leg_success2_down{i} = ['Success tones n+2 (n=' num2str(length(dltone_delay.dltone_gooddown_isi2{p})) ')'];
    hist_dltone.leg_failed1_down{i} = ['Failed tones n+1 (n=' num2str(length(dltone_delay.dltone_baddown_isi1{p})) ')'];
    hist_dltone.leg_failed2_down{i} = ['Failed tones n+2 (n=' num2str(length(dltone_delay.dltone_baddown_isi2{p})) ')'];
    
    % median - delta
    hist_dltone.m1_gooddelta{i} = median(dltone_delay.dltone_gooddelta_isi1{p}(dltone_delay.dltone_gooddelta_isi1{p}/10<max_edge)/10);
    hist_dltone.m2_gooddelta{i} = median(dltone_delay.dltone_gooddelta_isi2{p}(dltone_delay.dltone_gooddelta_isi2{p}/10<max_edge)/10);
    hist_dltone.m1_baddelta{i} = median(dltone_delay.dltone_baddelta_isi1{p}(dltone_delay.dltone_baddelta_isi1{p}/10<max_edge)/10);    
    hist_dltone.m2_baddelta{i} = median(dltone_delay.dltone_baddelta_isi2{p}(dltone_delay.dltone_baddelta_isi2{p}/10<max_edge)/10);
    % median - down
    hist_dltone.m1_gooddown{i} = median(dltone_delay.dltone_gooddown_isi1{p}(dltone_delay.dltone_gooddown_isi1{p}/10<max_edge)/10);
    hist_dltone.m2_gooddown{i} = median(dltone_delay.dltone_gooddown_isi2{p}(dltone_delay.dltone_gooddown_isi2{p}/10<max_edge)/10);
    hist_dltone.m1_baddown{i} = median(dltone_delay.dltone_baddown_isi1{p}(dltone_delay.dltone_baddown_isi1{p}/10<max_edge)/10);    
    hist_dltone.m2_baddown{i} = median(dltone_delay.dltone_baddown_isi2{p}(dltone_delay.dltone_baddown_isi2{p}/10<max_edge)/10);

end


%% plot

%delta
figure, hold on
for i=1:nb_graphs
    subplot(2,2,i), 
    plot(x_b1_delta, y_b1_delta, 'color', 'k'), hold on, 
    plot(x_b2_delta, y_b2_delta,':', 'color', 'k', 'linewidth',2), hold on, 
    plot(hist_dltone.x_success1_delta{i}, hist_dltone.y_success1_delta{i}, 'color', 'b'), hold on, 
    plot(hist_dltone.x_success2_delta{i}, hist_dltone.y_success2_delta{i},'--', 'color', 'b'), hold on, 
    plot(hist_dltone.x_failed1_delta{i}, hist_dltone.y_failed1_delta{i}, 'color', '[0.75 0.75 0.75]'), hold on, 
    plot(hist_dltone.x_failed2_delta{i}, hist_dltone.y_failed2_delta{i},'-.', 'color', '[0.75 0.75 0.75]'), hold on, 

    legend(leg_b1_delta, leg_b2_delta, hist_dltone.leg_success1_delta{i}, hist_dltone.leg_success2_delta{i}, hist_dltone.leg_failed1_delta{i}, hist_dltone.leg_failed2_delta{i}), 
    set(gca,'ylim',[0 0.04]), hold on
    
    line([m_b1_delta m_b1_delta],get(gca,'YLim'), 'color', 'k', 'linewidth',0.5), hold on
    line([m_b2_delta m_b2_delta],get(gca,'YLim'), 'LineStyle', ':', 'color', 'k', 'linewidth',2), hold on
    line([hist_dltone.m1_gooddelta{i} hist_dltone.m1_gooddelta{i}],get(gca,'YLim'), 'color', 'b', 'linewidth',0.5), hold on
    line([hist_dltone.m2_gooddelta{i} hist_dltone.m2_gooddelta{i}],get(gca,'YLim'), 'LineStyle', '--', 'color', 'b', 'linewidth',0.5), hold on
    line([hist_dltone.m1_baddelta{i} hist_dltone.m1_baddelta{i}],get(gca,'YLim'), 'Color', [0.75 0.75 0.75], 'linewidth',0.5), hold on
    line([hist_dltone.m2_baddelta{i} hist_dltone.m2_baddelta{i}],get(gca,'YLim'), 'LineStyle', '-.', 'Color', [0.75 0.75 0.75], 'linewidth',0.5), hold on

    title(['delta ISI - ' num2str(hist_dltone.delay{i}) 'ms']),hold on,

end

%down
figure, hold on
for i=1:nb_graphs
    subplot(2,2,i), 
    plot(x_b1_down, y_b1_down, 'color', 'k'), hold on, 
    plot(x_b2_down, y_b2_down,':', 'color', 'k', 'linewidth',2), hold on, 
    plot(hist_dltone.x_success1_down{i}, hist_dltone.y_success1_down{i}, 'color', 'b'), hold on, 
    plot(hist_dltone.x_success2_down{i}, hist_dltone.y_success2_down{i},'--', 'color', 'b'), hold on, 
    plot(hist_dltone.x_failed1_down{i}, hist_dltone.y_failed1_down{i}, 'color', '[0.75 0.75 0.75]'), hold on, 
    plot(hist_dltone.x_failed2_down{i}, hist_dltone.y_failed2_down{i},'-.', 'color', '[0.75 0.75 0.75]'), hold on, 

    legend(leg_b1_down, leg_b2_down, hist_dltone.leg_success1_down{i}, hist_dltone.leg_success2_down{i}, hist_dltone.leg_failed1_down{i}, hist_dltone.leg_failed2_down{i}), 
    set(gca,'ylim',[0 0.04]), hold on
    
    line([m_b1_down m_b1_down],get(gca,'YLim'), 'color', 'k', 'linewidth',0.5), hold on
    line([m_b2_down m_b2_down],get(gca,'YLim'), 'LineStyle', ':', 'color', 'k', 'linewidth',2), hold on
    line([hist_dltone.m1_gooddown{i} hist_dltone.m1_gooddown{i}],get(gca,'YLim'), 'color', 'b', 'linewidth',0.5), hold on
    line([hist_dltone.m2_gooddown{i} hist_dltone.m2_gooddown{i}],get(gca,'YLim'), 'LineStyle', '--', 'color', 'b', 'linewidth',0.5), hold on
    line([hist_dltone.m1_baddown{i} hist_dltone.m1_baddown{i}],get(gca,'YLim'), 'Color', [0.75 0.75 0.75], 'linewidth',0.5), hold on
    line([hist_dltone.m2_baddown{i} hist_dltone.m2_baddown{i}],get(gca,'YLim'), 'LineStyle', '-.', 'Color', [0.75 0.75 0.75], 'linewidth',0.5), hold on

    title(['down ISI - ' num2str(hist_dltone.delay{i}) 'ms']),hold on,

end












