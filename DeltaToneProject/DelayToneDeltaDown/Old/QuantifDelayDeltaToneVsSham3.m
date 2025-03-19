% QuantifDelayDeltaToneVsSham3
% 15.11.2016 KJ
%
%
% distributions of the delays after the events (tones vs sham) 
%
% Info
%   Analysis are made for the different substages and conditions.
%


% load
cd([FolderProjetDelta 'Data/']) 
clear
load QuantifDelayDeltaToneVsSham.mat


%% Concatenate

%params
step = 20;
max_edge = 900;
edges = 0:step:max_edge;
smoothing=2;

for sub=substages_ind
    for d=1:length(delays)
        %% Sham
        delay_delta_sham = [];
        delay_down_sham = [];
        for p=1:length(delay_res.path)
            delay_delta_sham = [delay_delta_sham ; sham_res.delay_delta_sham{p,sub,d}];
            delay_down_sham = [delay_down_sham ; sham_res.delay_down_sham{p,sub,d}];
        end

        deltas.sham.medians_delay(d,sub) = median(delay_delta_sham(delay_delta_sham/10<max_edge))/10;
        deltas.sham.modes_delay(d,sub) = mode(delay_delta_sham(delay_delta_sham/10<max_edge))/10;
        h = histogram(delay_delta_sham/10, edges,'Normalization','probability');
        deltas.sham.histo.x{d,sub} = h.BinEdges(2:end) - step/2;
        deltas.sham.histo.y{d,sub} = SmoothDec(h.Values,smoothing); close
        
        downs.sham.medians_delay(d,sub) = median(delay_down_sham(delay_down_sham/10<max_edge))/10;
        downs.sham.modes_delay(d,sub) = mode(delay_down_sham(delay_down_sham/10<max_edge))/10;
        h = histogram(delay_down_sham/10, edges,'Normalization','probability');
        downs.sham.histo.x{d,sub} = h.BinEdges(2:end) - step/2;
        downs.sham.histo.y{d,sub} = SmoothDec(h.Values,smoothing); close
        
        %% Tone
        delay_delta_tone = [];
        delay_down_tone = [];
        for p=1:length(delay_res.path)
            if delay_res.delay{p}==delays(d)
                delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
                delay_down_tone = [delay_down_tone ; delay_res.delay_down_tone{p,sub}];
            end
        end

        deltas.tone.medians_delay(d,sub) = median(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
        deltas.tone.modes_delay(d,sub) = mode(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
        h = histogram(delay_delta_tone/10, edges,'Normalization','probability');
        deltas.tone.histo.x{d,sub} = h.BinEdges(2:end) - step/2;
        deltas.tone.histo.y{d,sub} = SmoothDec(h.Values,smoothing); close
        
        downs.tone.medians_delay(d,sub) = median(delay_down_tone(delay_down_tone/10<max_edge))/10;
        downs.tone.modes_delay(d,sub) = mode(delay_down_tone(delay_down_tone/10<max_edge))/10;
        h = histogram(delay_down_tone/10, edges,'Normalization','probability');
        downs.tone.histo.x{d,sub} = h.BinEdges(2:end) - step/2;
        downs.tone.histo.y{d,sub} = SmoothDec(h.Values,smoothing); close
    end
end

clear sub p m d
clear delay_delta_tone delay_down_tone delay_res
clear smoothing step edges h max_edge


%% Order and plot
NameSubstages = {'N1', 'N2', 'N3'}; % NREM substages
substages_plot = 1:3;
col = {[0.75 0.75 0.75], 'k', 'r', 'b', 'g'};

%Delta
figure, hold on
for sub=substages_plot
    subplot(3,1,sub), hold on,
    for d=1:length(delays)
        plot(deltas.tone.histo.x{d,sub}, deltas.tone.histo.y{d,sub}, 'color', col{d}), hold on,
        plot(deltas.sham.histo.x{d,sub}, deltas.sham.histo.y{d,sub}, 'color', col{d}, 'LineStyle', '--'), hold on,
    end
    legend('Tone 140ms', 'Sham 140ms', 'Tone 200ms', 'Sham 200ms', ...
        'Tone 320ms', 'Sham 320ms', 'Tone 490ms', 'Sham 490ms'), hold on
    for d=1:length(delays)
        line([deltas.tone.medians_delay(d,sub) deltas.tone.medians_delay(d,sub)],get(gca,'YLim'), 'color', col{d}, 'linewidth',0.5), hold on
        line([deltas.sham.medians_delay(d,sub) deltas.sham.medians_delay(d,sub)],get(gca,'YLim'), 'color', col{d}, 'linewidth',0.5, 'LineStyle', '--'), hold on
    end
    title([NameSubstages{sub}])
end
suplabel('Delta Delay','t');

%down
figure, hold on
for sub=substages_plot
    subplot(3,1,sub), hold on,
    for d=1:length(delays)
        plot(downs.tone.histo.x{d,sub}, downs.tone.histo.y{d,sub}, 'color', col{d}), hold on,
        plot(downs.sham.histo.x{d,sub}, downs.sham.histo.y{d,sub}, 'color', col{d}, 'LineStyle', '--'), hold on,
    end
    legend('Tone 140ms', 'Sham 140ms', 'Tone 200ms', 'Sham 200ms', ...
        'Tone 320ms', 'Sham 320ms', 'Tone 490ms', 'Sham 490ms'), hold on
    for d=1:length(delays)
        line([downs.tone.medians_delay(d,sub) downs.tone.medians_delay(d,sub)],get(gca,'YLim'), 'color', col{d}, 'linewidth',0.5), hold on
        line([downs.sham.medians_delay(d,sub) downs.sham.medians_delay(d,sub)],get(gca,'YLim'), 'color', col{d}, 'linewidth',0.5, 'LineStyle', '--'), hold on
    end
    title([NameSubstages{sub}])
end
suplabel('Down Delay','t');



