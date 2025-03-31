% QuantifSlowDynDelayToneSlowWaveAgePlot
% 02.10.2018 KJ
%
% distributions of the delays after the tones
% -> Plot
%
%   see 
%       QuantifSlowDynDelayToneSlowWave QuantifSlowDynDelayToneSlowWavePlot
%

%load
clear
load(fullfile(FolderSlowDynData, 'QuantifSlowDynDelayToneSlowWave.mat'))


%params
step = 20;
max_edge = 1400;
edges = 0:step:max_edge;
smoothing=2;
age_range = [20 30 40 50 90];

%labels
for i=1:length(age_range)-2
    labels{i} = [num2str(age_range(i)) '-' num2str(age_range(i+1))]; 
end
labels{length(age_range)-1} = ['>' num2str(age_range(end-1))];





%% Pool data

%age&subjects
all_ages = cell2mat(delay_res.age);

%data
for i=1:length(age_range)-1

    for k=1:4
        delay_slowwave.tone{k} = [];
        delay_slowwave.sham{k} = [];
        for sstage=sleepstage_ind
            for p=1:length(delay_res.filename)
                if all_ages(p)>=age_range(i) && all_ages(p)<age_range(i+1) %age condition
                    %tones
                    try
                        delay_slowwave.tone{k}  = [delay_slowwave.tone{k}  ; delay_res.tone.delay_slowwave{p}{sstage,k}'/10];
                    end
                    %sham
                    try
                        delay_slowwave.sham{k}  = [delay_slowwave.sham{k}  ; delay_res.sham.delay_slowwave{p}{sstage,k}'/10];
                    end
                end
            end
        end
    end

    %all 
    all_delay.tones{i} = [];
    all_delay.sham{i} = [];
    for k=1:4
        all_delay.tones{i} = [all_delay.tones{i} ; delay_slowwave.tone{k}];
        all_delay.sham{i} = [all_delay.sham{i} ; delay_slowwave.sham{k}];
    end

end

%% Distributions

for i=1:length(age_range)-1

    %all tones
    [y_counts, x_counts] = histcounts(all_delay.tones{i}, edges, 'Normalization','probability');
    tones.histo.x{i} = x_counts(1:end-1) + diff(x_counts);
    tones.histo.y{i} = SmoothDec(y_counts,smoothing);

    %all sham
    [y_counts, x_counts] = histcounts(all_delay.sham{i}, edges, 'Normalization','probability');
    sham.histo.x{i} = x_counts(1:end-1) + diff(x_counts);
    sham.histo.y{i} = SmoothDec(y_counts,smoothing);

end

%% plot
figure, hold on

for i=1:length(age_range)-1
    subplot(2,2,i), hold on
    plot(tones.histo.x{i}, tones.histo.y{i}, 'color', 'b','linewidth',2), hold on,
    plot(sham.histo.x{i}, sham.histo.y{i}, 'color', 'r', 'linewidth',2), hold on,
    legend('tones', 'sham'),
    xlabel('time from tones/sham (ms)'), ylabel('probability'),   
    title(labels{i}),
    
end




