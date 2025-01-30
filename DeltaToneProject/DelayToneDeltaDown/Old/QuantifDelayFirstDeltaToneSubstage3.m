% QuantifDelayFirstDeltaToneSubstage3
% 15.11.2016 KJ
%
% distributions of the delays after the tones 
%
% Info
%   Analysis are made for the different substages and conditions.
%

cd([FolderProjetDelta 'Data/'])

%% Concatenate
clear 
load QuantifDelayFirstDeltaToneSubstage.mat
%params
step = 20;
max_edge = 600;
edges = 0:step:max_edge;
smoothing=2;

animals = unique(delay_res.name);

for sub=substages_ind
    for d=1:length(delays)
        delay_delta_tone = [];
        delay_down_tone = [];
        for p=1:length(delay_res.path)
            if delay_res.delay{p}==delays(d)
                delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
                delay_down_tone = [delay_down_tone ; delay_res.delay_down_tone{p,sub}];
            end
        end

        deltas.medians_delay(d,sub) = median(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
        deltas.modes_delay(d,sub) = mode(delay_delta_tone(delay_delta_tone/10<max_edge))/10;
        h = histogram(delay_delta_tone/10, edges,'Normalization','probability');
        deltas.histo.x{d,sub} = h.BinEdges(2:end) - step/2;
        deltas.histo.y{d,sub} = SmoothDec(h.Values,smoothing); close
        
        downs.medians_delay(d,sub) = median(delay_down_tone(delay_down_tone/10<max_edge))/10;
        downs.modes_delay(d,sub) = mode(delay_down_tone(delay_down_tone/10<max_edge))/10;
        h = histogram(delay_down_tone/10, edges,'Normalization','probability');
        downs.histo.x{d,sub} = h.BinEdges(2:end) - step/2;
        downs.histo.y{d,sub} = SmoothDec(h.Values,smoothing); close
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
        plot(deltas.histo.x{d,sub}, deltas.histo.y{d,sub}, 'color', col{d}), hold on,
    end
    legend('random', '140ms', '200ms', '320ms', '490ms'), hold on
    for d=1:length(delays)
        line([deltas.medians_delay(d,sub) deltas.medians_delay(d,sub)],get(gca,'YLim'), 'color', col{d}, 'linewidth',0.5), hold on
    end
    title([NameSubstages{sub}])
end
suplabel('Delta Delay','t');


%Down
figure, hold on
for sub=substages_plot
    subplot(3,1,sub), hold on,
    for d=1:length(delays)
        plot(downs.histo.x{d,sub}, downs.histo.y{d,sub}, 'color', col{d}), hold on,
    end
    legend('random', '140ms', '200ms', '320ms', '490ms'), hold on
    for d=1:length(delays)
        line([downs.medians_delay(d,sub) downs.medians_delay(d,sub)],get(gca,'YLim'), 'color', col{d}, 'linewidth',0.5), hold on
    end
    title([NameSubstages{sub}])
end
suplabel('Down Delay','t');




