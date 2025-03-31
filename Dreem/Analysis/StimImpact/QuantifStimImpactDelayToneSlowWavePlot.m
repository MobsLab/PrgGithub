% QuantifStimImpactDelayToneSlowWavePlot
% 14.05.2017 KJ
%
% distributions of the delays after the tones
% -> Plot
%
%   see 
%       QuantifStimImpactDelayToneSlowWave QuantifClinicDelayToneSlowWave_VC2
%

%load
clear
load(fullfile(FolderStimImpactData, 'QuantifStimImpactDelayToneSlowWave.mat'))


%params
step = 20;
max_edge = 1400;
edges = 0:step:max_edge;
smoothing=2;


%% Pool data

for k=1:4
    delay_slowwave.tone{k} = [];
    delay_slowwave.sham{k} = [];
    for sstage=sleepstage_ind
        for p=1:length(delay_res.filename)
            try
                delay_slowwave.tone{k}  = [delay_slowwave.tone{k}  ; delay_res.tone.delay_slowwave{p}{sstage,k}'/10];
            end
            try
                delay_slowwave.sham{k}  = [delay_slowwave.sham{k}  ; delay_res.sham.delay_slowwave{p}{sstage,k}'/10];
            end
        end
    end
end


%% Distributions

%tones
for k=1:4

    %tones
    tones.medians_delay{k}  = median(delay_slowwave.tone{k} (delay_slowwave.tone{k}<max_edge));
    tones.modes_delay{k}  = mode(delay_slowwave.tone{k} (delay_slowwave.tone{k}<max_edge));
    
    [y_counts, x_counts] = histcounts(delay_slowwave.tone{k}, edges, 'Normalization','probability');
    tones.histo.x{k} = x_counts(1:end-1) + diff(x_counts);
    tones.histo.y{k} = SmoothDec(y_counts,smoothing);
    
    %sham
    sham.medians_delay{k}  = median(delay_slowwave.sham{k} (delay_slowwave.sham{k}<max_edge));
    sham.modes_delay{k}  = mode(delay_slowwave.sham{k} (delay_slowwave.sham{k}<max_edge));
    
    
    [y_counts, x_counts] = histcounts(delay_slowwave.sham{k}, edges, 'Normalization','probability');
    sham.histo.x{k} = x_counts(1:end-1) + diff(x_counts);
    sham.histo.y{k} = SmoothDec(y_counts,smoothing);
    
end



%% plot
figure, hold on

for k=1:4
    subplot(2,2,k), hold on
    plot(tones.histo.x{k}, tones.histo.y{k}, 'color', 'k','linewidth',2), hold on,
    plot(sham.histo.x{k}, sham.histo.y{k}, 'color', [0.7 0.7 0.7], 'linewidth',1), hold on,
    legend('tones', 'sham')

    xlabel('time from tones/sham (ms)'), ylabel('probability'),   
    title(['Tones ' num2str(k)]),
    
end

