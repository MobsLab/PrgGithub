% QuantifSlowWaveSlowDyn
% 15.09.2018 KJ
%
% Infos
%   for each night :
%       - number of slow waves
%       - density
%       - distribution in substages
%       - slope
%       
%
% SEE 
%   QuantifHypnogramSlowDyn QuantifSlowWaveSlowDynPlot
%   QuantifSlowWaveSlowDynPlot2
%

% clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

%loop
for p=1:length(Dir.filereference)
    clearvars -except Dir p quantif_res

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %% init
    
    quantif_res.filename{p} = Dir.filename{p};
    quantif_res.filereference{p} = Dir.filereference{p};
    quantif_res.subject{p} = Dir.subject{p};
    quantif_res.date{p} = Dir.date(p);
    quantif_res.age{p} = Dir.age{p};
    quantif_res.gender{p} = Dir.gender{p};
    
    %load signals and data
    [signals, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
    N1 = StageEpochs{1}; N2 = StageEpochs{2}; N3 = StageEpochs{3};

    %quality - choose a channel
    try
        [~, NoiseEpoch, ~] = GetDreemQuality(Dir.filereference{p});
        duration_noise = [];
        for i=1:4
            duration_noise(i,1) = tot_length(NoiseEpoch{i});
        end
        [~,idx] = min(duration_noise);

        channel_sw = [1 2 5 6];
        channel_sw = channel_sw(idx);
        
    catch
        channel_sw = 1;
    end
    quantif_res.channel_sw{p} = channel_sw;
        
    channel_sw = quantif_res.channel_sw{p};

    %load slow waves
    sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    if exist(sw_file,'file')==2
        load(sw_file);
    else
       [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'SlowWaves'));
    end
    
    
    %% params
    %params density
    windowsize = 60e4; %60s
    smoothing = 1;
    %params isi
    step=100;
    edges=0:step:10000;
    
    %% night duration and intervals
    for st=1:length(StageEpochs)
        try
            endst(st) = max(End(StageEpochs{st})); 
        catch
            endst(st) = nan;
        end
    end
    night_duration = max(endst);

    %intervals
    intervals_start = 0:windowsize:night_duration;    
    x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
    
    
    %% slow-waves
    center_slowwaves = (Start(SlowWaveEpochs{channel_sw}) + End(SlowWaveEpochs{channel_sw})) / 2;
    start_slowwaves = Start(SlowWaveEpochs{channel_sw});
    
    
    %% Info
    quantif_res.nb_slowwaves{p} = length(center_slowwaves);
    quantif_res.night_duration{p} = night_duration;
    quantif_res.durations{p} = End(SlowWaveEpochs{channel_sw}) - Start(SlowWaveEpochs{channel_sw});
    
    
    %% Amplitude and size
    func_max = @(a) measureOnSignal(a,'maximum');
    func_min = @(a) measureOnSignal(a,'minimum');

    [peak_value, peak_tmp, ~] = functionOnEpochs(signals{channel_sw}, SlowWaveEpochs{channel_sw}, func_max);
    [troughs_value, troughs_tmp, ~] = functionOnEpochs(signals{channel_sw}, SlowWaveEpochs{channel_sw}, func_min);
    trough_to_peaks = peak_value-troughs_value;
    trough_peak_delays = peak_tmp - troughs_tmp;
    
    quantif_res.amplitude.trough{p} = troughs_value;
    quantif_res.amplitude.peak{p} = peak_value;
    quantif_res.slopes{p} = trough_to_peaks ./ (trough_peak_delays*1e-4);
    
    
    %% slow waves density
    slowwaves_density = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        slowwaves_density(t) = length(Restrict(ts(center_slowwaves),intv)); %per min
    end
    quantif_res.x_density{p} = x_intervals;
    quantif_res.y_density{p} = slowwaves_density;

    %slope
    [x_dens, y_dens] = AdaptDensityCurves(x_intervals, slowwaves_density, smoothing);
    idx_density = y_dens > max(y_dens)/8;
    [p_density,~] = polyfit(x_dens(idx_density), y_dens(idx_density)', 1);
    
    quantif_res.density_slope{p} = p_density(1);
    
    
    %% ISI
    [quantif_res.y_isi{p}, quantif_res.x_isi{p}] = histcounts(diff(start_slowwaves/10), edges);
    quantif_res.x_isi{p} = quantif_res.x_isi{p}(1:end-1) + diff(quantif_res.x_isi{p});
    
    quantif_res.isi_peak{p} = mode(diff(start_slowwaves/10));
    quantif_res.isi_std{p} = std(diff(start_slowwaves/10)) / sqrt(length(diff(start_slowwaves/10)));
    
    
    
end

%saving data
cd(FolderSlowDynData)
save QuantifSlowWaveSlowDyn.mat quantif_res windowsize smoothing edges




