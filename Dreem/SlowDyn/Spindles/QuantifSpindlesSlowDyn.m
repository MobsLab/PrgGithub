% QuantifSpindlesSlowDyn
% 21.11.2018 KJ
%
% Infos
%   for each night :
%       - number of spindles
%       - density and homeostasis
%       - distribution in substages
%       
%
% SEE 
%   QuantifHypnogramSlowDyn QuantifSlowWaveSlowDyn
%   QuantifSpindlesSlowDynPlot
%


clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))
%get quality channels
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'),'quantif_res')
quality_channels = quantif_res.channel_sw;
clear quantif_res


%loop
for p=1:length(Dir.filereference)
    clearvars -except Dir p quantif_res quality_channels

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
    channel_sw = quality_channels{p};
    quantif_res.channel_sw{p} = channel_sw;

    %load spindles
    spi_file = fullfile(FolderSlowDynPreprocess, 'Spindles', ['Spindles_' num2str(Dir.filereference{p}) '.mat']);
    if exist(spi_file,'file')==2
        load(spi_file);
    else
       [SpindlesEpoch, ~] = MakeSpindlesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'Spindles'));
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
    
    
    
    %% spindles
    center_spindles = (Start(SpindlesEpoch{channel_sw}) + End(SpindlesEpoch{channel_sw})) / 2;
    start_spindles = Start(SpindlesEpoch{channel_sw});
    
    
    %% Info
    quantif_res.nb_spindles{p} = length(center_spindles);
    quantif_res.night_duration{p} = night_duration;
    quantif_res.durations{p} = End(SpindlesEpoch{channel_sw}) - Start(SpindlesEpoch{channel_sw});
    
    
    
    %% spindles density
    spindles_density = zeros(length(intervals_start),1);
    for t=1:length(intervals_start)
        intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
        spindles_density(t) = length(Restrict(ts(center_spindles),intv)); %per min
    end
    quantif_res.x_density{p} = x_intervals;
    quantif_res.y_density{p} = spindles_density;

    %slope
    if ~isempty(start_spindles)
        [x_dens, y_dens] = AdaptDensityCurves(x_intervals, spindles_density, smoothing);
        idx_density = y_dens > max(y_dens)/8;
        [p_density,~] = polyfit(x_dens(idx_density), y_dens(idx_density)', 1);

        quantif_res.density_slope{p} = p_density(1);
    else
        quantif_res.density_slope{p} = nan;
    end
    
    %% ISI
    
    [quantif_res.y_isi{p}, quantif_res.x_isi{p}] = histcounts(diff(start_spindles/10), edges);
    quantif_res.x_isi{p} = quantif_res.x_isi{p}(1:end-1) + diff(quantif_res.x_isi{p});
    
    quantif_res.isi_peak{p} = mode(diff(start_spindles/10));
    quantif_res.isi_std{p} = std(diff(start_spindles/10)) / sqrt(length(diff(start_spindles/10)));
    
    
    
end

%saving data
cd(FolderSlowDynData)
save QuantifSpindlesSlowDyn.mat quantif_res windowsize smoothing edges




