% ClinicQuantitySleepNew
% 27.06.2017 KJ
%
% duration of each sleep substages
% 
% 
%   see QuantitySleepDelta ClinicQuantitySleepPlot ClinicQuantitySleep ClinicQuantitySleepPlotNew
%


clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');
    
%params
common_data = GetClinicCommonData();

sleepstage_ind = 1:6; %N1, N2, N3, REM, WAKE, N2+N3
hours_expe = 0:1:8;
for h=1:length(hours_expe)
    hours_epoch{h} = intervalSet(hours_expe(h)*3600E4, (hours_expe(h)+1)*3600E4-1);
end
effect_period = common_data.effect_period; %800ms
stage_epoch_duration = common_data.stage_epoch_duration;


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
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
        
    %tones
    stim_tmp = Range(stimulations);
    if ~strcmpi(Dir.condition{p},'sham')
        stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
    end
    tone_intv_post = intervalSet(stim_tmp, stim_tmp + effect_period);  % Tone and its window where an effect could be observed
    all_tones = ts(stim_tmp);
    nb_tones = length(all_tones);
    
    %Hypnograms
    [Hypnograms, scorer, ref_score] = GetHypnogramClinic(Dir.filereference{p});
    if isempty(Hypnograms)
        Hypnograms{4} = StageEpochs;
        scorer{4} = 'pascal';
        ref_score{4} = 'pascal';
    else
        hyp_pascal = Hypnograms{4};
        sleep_pascal = or(or(hyp_pascal{1},hyp_pascal{2}),or(hyp_pascal{1},hyp_pascal{2}));
        if tot_length(sleep_pascal)<1000E4; %less than 1000sec of sleep
            Hypnograms{4}=StageEpochs;
        end
    end
    
    %% VIRTUAL CHANNEL SIGNAL
    % Dreem 
    dreem_ch1 = find(strcmpi(name_channel,'FP1-M1'));
    dreem_ch2 = find(strcmpi(name_channel,'FP2-M2'));
    sig_f1 = Data(signals{dreem_ch1}) .* (index_dreem==0);
    sig_f2 = Data(signals{dreem_ch2}) .* (index_dreem==1);

    signals_dreem_vc = sig_f1 + sig_f2;
    signals_dreem_vc = tsd(Range(signals{dreem_ch1}), signals_dreem_vc);

    % Actiwave
    psg_ch1 = find(strcmpi(name_channel,'REF F3'));
    psg_ch2 = find(strcmpi(name_channel,'REF F4'));
    sig_f3 = Data(signals{psg_ch1}) .* (index_psg==0);
    sig_f4 = Data(signals{psg_ch2}) .* (index_psg==1);

    signals_psg_vc = sig_f3 + sig_f4;
    signals_psg_vc = tsd(Range(signals{psg_ch1}), signals_psg_vc);
    
    %slow wave
    signals_vc{1} = signals_dreem_vc;
    signals_vc{2} = signals_psg_vc;
    
    for i=1:2
        SlowWaveEpochs{i} = FindSlowWaves(signals_vc{i});
        BurstEpochs{i} = FindBurstSlowWave(SlowWaveEpochs{i});
        start_slowwaves{i} = ts(Start(SlowWaveEpochs{i}));
        start_burst{i} = ts(Start(BurstEpochs{i}));
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% QUANTIF
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% night duration
    quantity_res.night_duration = max(Range(signals{1}));
    
    %% tones - induced a slow wave?
    for i=1:2
        [~,interval,~] = InIntervals(Range(start_slowwaves{i}), [Start(tone_intv_post) End(tone_intv_post)]);
        tone_success = unique(interval);
        tone_success(tone_success==0)=[];
        stim_success{i} = ts(stim_tmp(tone_success));
    end
    
    %% total
    for s=1:length(scorer)
        StageEpochs = Hypnograms{s};
        if ~isempty(StageEpochs)
            for sstage=1:length(StageEpochs)
                quantity_res.sleepstages.total{p,s}(sstage) = tot_length(StageEpochs{sstage});
            end
            [sleep_efficiency, sol, waso] = GetDataSleepClinic(StageEpochs, stage_epoch_duration);
            quantity_res.sleepstages.waso{p,s} = waso;
            quantity_res.sleepstages.sol{p,s} = sol;
            quantity_res.sleepstages.sleep_efficiency{p,s} = sleep_efficiency;
        end
    end
    for i=1:2
        quantity_res.slowwaves.total{p,i} = length(start_slowwaves{i});
        quantity_res.burst.total{p,i} = length(start_burst{i});
        quantity_res.tones.total{p,i} = length(all_tones);
        quantity_res.success.total{p,i} = length(stim_success{i});
    end
    
    
    %% hours
    quantity_res.sleepstages.hours{p} = nan(length(hours_epoch),length(sleepstage_ind));
    for h=1:length(hours_epoch)
        %sleep stages
        for s=1:length(scorer)
            StageEpochs = Hypnograms{s}; 
            if ~isempty(StageEpochs)
                for sstage=1:length(StageEpochs)
                    quantity_res.sleepstages.hours{p,s}(h,sstage) = tot_length(and(hours_epoch{h},StageEpochs{sstage}));
                end
            end
        end
        %deltas
        for i=1:2
            quantity_res.slowwaves.hours{p,h,i} = length(Restrict(start_slowwaves{i},hours_epoch{h}));
            quantity_res.burst.hours{p,h,i} = length(Restrict(start_burst{i},hours_epoch{h}));
            quantity_res.tones.hours{p,h,i} = length(Restrict(all_tones,hours_epoch{h}));
            quantity_res.success.hours{p,h,i} = length(Restrict(stim_success{i},hours_epoch{h}));
        end
    end
    
    
end

%saving data
cd(FolderPrecomputeDreem)
save ClinicQuantitySleepNew.mat quantity_res sleepstage_ind hours_expe scorer ref_score





