% QuantifStimImpactDelayToneSlowWavePlot2
% 23.05.2017 KJ
%
% distributions of the delays after the tones
% -> plot 
%
%   see 
%       QuantifStimImpactDelayToneSlowWave QuantifStimImpactDelayToneSlowWavePlot
%

%load
clear
load(fullfile(FolderStimImpactData, 'QuantifStimImpactDelayToneSlowWave.mat'))


%% Concatenate
%params
step = 30;
max_edge = 1600;
edges = 0:step:max_edge;
smoothing=2;


%% Pool data

delay_slowwave.tone = [];
delay_slowwave.sham = [];
for k=1:4

    for sstage=sleepstage_ind
        for p=1:length(delay_res.filename)
            try
                delay_slowwave.tone  = [delay_slowwave.tone  ; delay_res.tone.delay_slowwave{p}{sstage,k}'/10];
            end
            try
                delay_slowwave.sham  = [delay_slowwave.sham  ; delay_res.sham.delay_slowwave{p}{sstage,k}'/10];
            end
        end
    end
end


%% Distributions

%tones
tones.medians_delay  = median(delay_slowwave.tone (delay_slowwave.tone<max_edge));
tones.modes_delay  = mode(delay_slowwave.tone (delay_slowwave.tone<max_edge));

[y_counts, x_counts] = histcounts(delay_slowwave.tone, edges, 'Normalization','probability');
tones.histo.x = x_counts(1:end-1) + diff(x_counts);
tones.histo.y = SmoothDec(y_counts,smoothing);

%sham
sham.medians_delay  = median(delay_slowwave.sham (delay_slowwave.sham<max_edge));
sham.modes_delay  = mode(delay_slowwave.sham (delay_slowwave.sham<max_edge));


[y_counts, x_counts] = histcounts(delay_slowwave.sham, edges, 'Normalization','probability');
sham.histo.x = x_counts(1:end-1) + diff(x_counts);
sham.histo.y = SmoothDec(y_counts,smoothing);


%% plot
figure, hold on

plot(tones.histo.x, tones.histo.y, 'color', 'k','linewidth',2), hold on,
plot(sham.histo.x, sham.histo.y, 'color', [0.7 0.7 0.7], 'linewidth',1), hold on,
legend('tones', 'sham')

xlabel('time from tones/sham (ms)'), ylabel('probability'),
title('delay between tones/sham and following slow waves'),
    

