% ClinicQuantitySleep
% 28.03.2017 KJ
%
% duration of each sleep substages
% 
% 
%   see QuantitySleepDelta ClinicQuantitySleepPlot
%


clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('all');
    
%params
sleepstage_ind = 1:6; %N1, N2, N3, REM, WAKE, N2+N3
hours_expe = 0:1:8;
for h=1:length(hours_expe)
    hours_epoch{h} = intervalSet(hours_expe(h)*3600E4, (hours_expe(h)+1)*3600E4-1);
end
effect_period = 8000; %800ms


%% loop over nights
for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    quantity_res.filename{p} = Dir.filename{p};
    quantity_res.condition{p} = Dir.condition{p};
    quantity_res.subject{p} = Dir.subject{p};
    quantity_res.date{p} = Dir.date{p};
    quantity_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    StageEpochs{6} = or(StageEpochs{2},StageEpochs{3});
    %slow wave
    SlowWaveEpochs = FindSlowWaves(signals{Dir.channel_sw{p}(1)});
    BurstEpochs = FindBurstSlowWave(SlowWaveEpochs);
    start_slowwaves = ts(Start(SlowWaveEpochs));
    start_burst = ts(Start(BurstEpochs));
    
    %tones
    stim_tmp = Range(stimulations);
    stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
    tone_intv_post = intervalSet(stim_tmp, stim_tmp + effect_period);  % Tone and its window where an effect could be observed
    all_tones = ts(stim_tmp);
    nb_tones = length(all_tones);
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% QUANTIF
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% night duration
    quantity_res.night_duration = max(Range(signals{1}));
    
    %% tones - induced a slow wave?
    [~,interval,~] = InIntervals(Range(start_slowwaves), [Start(tone_intv_post) End(tone_intv_post)]);
    tone_success = unique(interval);
    tone_success(tone_success==0)=[];
    stim_success = ts(stim_tmp(tone_success));
    
    
    %% total
    for sstage=1:length(StageEpochs)
        quantity_res.sleepstages.total{p}(sstage) = tot_length(StageEpochs{sstage});
    end
    quantity_res.slowwaves.total{p} = length(start_slowwaves);
    quantity_res.burst.total{p} = length(start_burst);
    quantity_res.tones.total{p} = length(all_tones);
    quantity_res.success.total{p} = length(stim_success);
    
    %% hours
    quantity_res.sleepstages.hours{p} = nan(length(hours_epoch),length(sleepstage_ind));
    for h=1:length(hours_epoch)
        %sleep stages
        for sstage=1:length(StageEpochs)
            quantity_res.sleepstages.hours{p}(h,sstage) = tot_length(and(hours_epoch{h},StageEpochs{sstage}));
        end
        %deltas
        quantity_res.slowwaves.hours{p,h} = length(Restrict(start_slowwaves,hours_epoch{h}));
        quantity_res.burst.hours{p,h} = length(Restrict(start_burst,hours_epoch{h}));
        quantity_res.tones.hours{p,h} = length(Restrict(all_tones,hours_epoch{h}));
        quantity_res.success.hours{p,h} = length(Restrict(stim_success,hours_epoch{h}));
    end
    
    
end

%saving data
cd(FolderPrecomputeDreem)
save ClinicQuantitySleep.mat quantity_res sleepstage_ind hours_expe





