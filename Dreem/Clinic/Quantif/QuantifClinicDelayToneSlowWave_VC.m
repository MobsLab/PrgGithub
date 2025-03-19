% QuantifClinicDelayToneSlowWave_VC
% 26.06.2017 KJ
%
% distributions of the delays after the tones - VIRTUAL CHANNEL DATA
% -> Collect and save data 
%
%   see 
%       QuantifClinicDelayToneSlowWave QuantifClinicDelayToneSlowWave_VC2
%

clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('all');
    
%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE
lim_between_stim = 1.6E4;  %1.6sec maximum between two stim of the same train
channels = [1 2 7 10];
name_channels = {'FP1-M1','FP2-M2','REF F3','REF F4'};

for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    delay_res.filename{p} = Dir.filename{p};
    delay_res.condition{p} = Dir.condition{p};
    delay_res.subject{p} = Dir.subject{p};
    delay_res.date{p} = Dir.date{p};
    delay_res.night{p} = Dir.night{p};
    
    
    %% load signals
    [signals, stimulations, StageEpochs, name_channel, domain] = GetRecordClinic(Dir.filename{p});
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    
    %tones - distinguish 1st and 2nd tones
    all_tones = Range(stimulations);
    second_idx = [0 ; diff(all_tones)<lim_between_stim];
    
    tones_first = ts(all_tones(second_idx==0));
    tones_second = ts(all_tones(second_idx==1));
    
    
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
    
    
    %% DREEM VIRTUAL CHANNEL
    SlowWaveEpochs = FindSlowWaves(signals_dreem_vc);
    start_slowwave = Start(SlowWaveEpochs);
    
    %loop over sleep stages
    for sstage = sleepstage_ind
        %tones
        tones_first_tmp = Range(Restrict(tones_first, StageEpochs{sstage}));
        tones_second_tmp = Range(Restrict(tones_second, StageEpochs{sstage}));

        %delay first tone
        delay_slowwave_tone1 = [];
        for i=1:length(tones_first_tmp)
            idx_first_sw = find(start_slowwave > tones_first_tmp(i), 1);
            if ~isempty(idx_first_sw)
                delay_slowwave_tone1 = [delay_slowwave_tone1 start_slowwave(idx_first_sw)-tones_first_tmp(i)];
            end
        end
        %delay second tone
        delay_slowwave_tone2 = [];
        for i=1:length(tones_second_tmp)
            idx_first_sw = find(start_slowwave > tones_second_tmp(i), 1);
            if ~isempty(idx_first_sw)
                delay_slowwave_tone2 = [delay_slowwave_tone2 start_slowwave(idx_first_sw)-tones_second_tmp(i)];
            end
        end

        delay_res.dreem.delay_slowwave_tone1{p,sstage} = delay_slowwave_tone1;
        delay_res.dreem.delay_slowwave_tone2{p,sstage} = delay_slowwave_tone2;
    end
    
    
    %% ACTIWAVE VIRTUAL CHANNEL
    SlowWaveEpochs = FindSlowWaves(signals_psg_vc);
    start_slowwave = Start(SlowWaveEpochs);
    
    %loop over sleep stages
    for sstage = sleepstage_ind
        %tones
        tones_first_tmp = Range(Restrict(tones_first, StageEpochs{sstage}));
        tones_second_tmp = Range(Restrict(tones_second, StageEpochs{sstage}));

        %delay first tone
        delay_slowwave_tone1 = [];
        for i=1:length(tones_first_tmp)
            idx_first_sw = find(start_slowwave > tones_first_tmp(i), 1);
            if ~isempty(idx_first_sw)
                delay_slowwave_tone1 = [delay_slowwave_tone1 start_slowwave(idx_first_sw)-tones_first_tmp(i)];
            end
        end
        %delay second tone
        delay_slowwave_tone2 = [];
        for i=1:length(tones_second_tmp)
            idx_first_sw = find(start_slowwave > tones_second_tmp(i), 1);
            if ~isempty(idx_first_sw)
                delay_slowwave_tone2 = [delay_slowwave_tone2 start_slowwave(idx_first_sw)-tones_second_tmp(i)];
            end
        end


        delay_res.psg.delay_slowwave_tone1{p,sstage} = delay_slowwave_tone1;
        delay_res.psg.delay_slowwave_tone2{p,sstage} = delay_slowwave_tone2;
    end
    
end

%saving data
cd(FolderPrecomputeDreem)
save QuantifClinicDelayToneSlowWave_VC.mat delay_res sleepstage_ind channels name_channels



