% QuantifEffectStimSlowDyn
% 02.10.2018 KJ
%
% Infos
%   for each night :
%       - effect of stim
%       - success ratio
%       
%
% SEE 
%   QuantifHypnogramSlowDyn QuantifSlowWaveSlowDynPlot
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'),'quantif_res')


for p=1:length(Dir.filereference)
    clearvars -except Dir p stim_res quantif_res     
    
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    %% init
    
    stim_res.filename{p} = Dir.filename{p};
    stim_res.filereference{p} = Dir.filereference{p};
    stim_res.subject{p} = Dir.subject{p};
    stim_res.date{p} = Dir.date(p);
    stim_res.age{p} = Dir.age{p};
    stim_res.gender{p} = Dir.gender{p};
    
    %params
    success_intv = [0 0.5]*1e4;
    
    %load signals and data
    [stimulations, StageEpochs] = GetStimHypnoDreem(Dir.filename{p});
    N1 = StageEpochs{1}; N2 = StageEpochs{2}; N3 = StageEpochs{3};
    channel_sw = quantif_res.channel_sw{p};
    
    %load slow waves
    sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    if exist(sw_file,'file')==2
        load(sw_file);
    else
       [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'SlowWaves'));
    end
    
    %stimulations
    [stim_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
    
    %night duration
    for st=1:length(StageEpochs)
        try
            endst(st) = max(End(StageEpochs{st})); 
        catch
            endst(st) = nan;
        end
    end
    night_duration = max(endst);
    
    
    stim_res.night_duration{p} = night_duration;
    stim_res.nb_stim{p} = length(stim_tmp);
    
    
    %% slow-waves
    center_slowwaves = (Start(SlowWaveEpochs{channel_sw}) + End(SlowWaveEpochs{channel_sw})) / 2;
    start_slowwaves = Start(SlowWaveEpochs{channel_sw});
    
    stim_res.nb_slowwaves{p} = length(start_slowwaves);
    
    %% success
    if ~isempty(stim_tmp)
        intv = [stim_tmp+success_intv(1) stim_tmp+success_intv(2)];
        [~,intervals,~] = InIntervals(start_slowwaves, intv);
        intervals(intervals==0)=[];
        intervals = unique(intervals);
        stim_res.nb_success{p} = length(intervals);
        stim_res.success_rate{p} = length(intervals) / stim_res.nb_stim{p};
    
    else
        stim_res.nb_success{p} = nan;
        stim_res.success_rate{p} = nan;
        
    end
    
end

%saving data
cd(FolderSlowDynData)
save QuantifEffectStimSlowDyn.mat stim_res success_intv

