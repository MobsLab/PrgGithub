% ClinicEpisodeDurationNew
% 30.06.2017 KJ
%
% duration of each sleep stage episode
% 
% 
%   see ClinicEpisodeDuration ClinicEpisodeDurationPlot 
%


clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');

%params
sleepstage_ind = 1:6; %N1, N2, N3, REM, WAKE, N2+N3
NameStages = {'N1', 'N2', 'N3', 'REM', 'WAKE', 'N2+N3'};

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
    %Hypnograms
    [Hypnograms, scorer, ref_score] = GetHypnogramClinic(Dir.filereference{p});
    if isempty(Hypnograms)
        Hypnograms{1} = StageEpochs;
        scorer{1} = 'dreem';
        ref_score{1} = 'dreem';
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
    
    
    %% Data
    
    %slow waves
    SlowWaveEpochs{1} = FindSlowWaves(signals_dreem_vc,'threshold',-100,'noiseThreshold',260);
    SlowWaveEpochs{2} = FindSlowWaves(signals_psg_vc,'threshold',-100,'noiseThreshold',260);
    for i=1:2
        BurstEpochs{i} = FindBurstSlowWave(SlowWaveEpochs{i});
        start_slowwaves{i} = ts(Start(SlowWaveEpochs{i}));
        start_burst{i} = ts(Start(BurstEpochs{i}));
    end
    
    %tones
    stim_tmp = Range(stimulations);
    if ~strcmpi(Dir.condition{p},'sham')
        stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
    end
    stim_tmp = ts(stim_tmp);
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% QUANTIF
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for s=1:length(scorer)
        StageEpochs = Hypnograms{s};
        
        for sstage=1:length(StageEpochs)
            durations = End(StageEpochs{sstage}) - Start(StageEpochs{sstage});
            quantity_res.duration{p,sstage} = durations / 1E4;
            
            for i=1:2
                nb_slowwave = [];
                nb_burst = [];
                nb_tone = [];
                for ep=1:length(Start(StageEpochs{sstage})) %number of episode
                    sub_intv = subset(StageEpochs{sstage},ep);
                    nb_slowwave = [nb_slowwave length(Restrict(start_slowwaves{i}, sub_intv))];
                    nb_burst = [nb_burst length(Restrict(start_burst{i}, sub_intv))];
                    nb_tone = [nb_tone length(Restrict(stim_tmp, sub_intv))];
                end
                quantity_res.nb.slowwaves{p,sstage,s,i} = nb_slowwave;
                quantity_res.nb.burst{p,sstage,s,i} = nb_burst;
                quantity_res.nb.tones{p,sstage,s,i} = nb_tone;                    
            end
        end
    end
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicEpisodeDurationNew.mat quantity_res sleepstage_ind NameStages scorer ref_score






