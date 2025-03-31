% QuantifSlowWaveStartEndSlowDyn
% 04.10.2018 KJ
%
% Infos
%       
%
% SEE 
%   QuantifSlowWaveSlowDyn
%

% clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

%load channels sw
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'),'quantif_res')
all_channels_sw = quantif_res.channel_sw;
all_nightDur = cell2mat(quantif_res.night_duration); clear hypno_res

%load channels sw
load(fullfile(FolderSlowDynData,'QuantifHypnogramSlowDyn.mat'),'hypno_res')
all_sol = cell2mat(hypno_res.sol); clear hypno_res



%% loop
for p=1:length(Dir.filereference)
    clearvars -except Dir p quantif_res all_channels_sw all_sol all_nightDur

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %% init
    
    quantif_res.filename{p}     = Dir.filename{p};
    quantif_res.filereference{p} = Dir.filereference{p};
    quantif_res.subject{p}      = Dir.subject{p};
    quantif_res.date{p}         = Dir.date(p);
    quantif_res.age{p}          = Dir.age{p};
    quantif_res.gender{p}       = Dir.gender{p};
    quantif_res.channel_sw{p}   = all_channels_sw{p};
    
    %params
    channel_sw = quantif_res.channel_sw{p};
    periodDuration = 2*3600e4;    
    
    
    %load slow waves
    sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    if exist(sw_file,'file')==2
        load(sw_file);
    else
       [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'SlowWaves'));
    end
    
    start_slowwaves = ts(Start(SlowWaveEpochs{channel_sw}));
    
    
    %% Info
    quantif_res.nb_slowwaves{p} = length(start_slowwaves);
    quantif_res.night_duration{p} = all_nightDur(p);
    quantif_res.durations{p} = End(SlowWaveEpochs{channel_sw}) - Start(SlowWaveEpochs{channel_sw});
    
    
    %% Start and End
    start_period = intervalSet(all_sol(p), all_sol(p)+periodDuration);
    end_period   = intervalSet(all_nightDur(p)-periodDuration, all_nightDur(p));

    quantif_res.nb_start{p} = length(Restrict(start_slowwaves, start_period));
    quantif_res.nb_end{p} = length(Restrict(start_slowwaves, end_period));
    
    
end

%saving data
cd(FolderSlowDynData)
save QuantifSlowWaveStartEndSlowDyn.mat quantif_res periodDuration




