% QuantifClinicDelayToneSlowWave
% 10.01.2017 KJ
%
% distributions of the delays after the tones
% -> Collect and save data 
%
%   see 
%       QuantifDelayFirstDeltaToneSubstage QuantifClinicDelayToneSlowWave2
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
    
    %tones - distinguish 1st and 2nd tones
    all_tones = Range(stimulations);
    second_idx = [0 ; diff(all_tones)<lim_between_stim];
    
    tones_first = ts(all_tones(second_idx==0));
    tones_second = ts(all_tones(second_idx==1));
    
    for ch=1:length(channels)
        if ismember(channels(ch),Dir.channel_sw{p})
            %find Slow Wave
            SlowWaveEpochs = FindSlowWaves(signals{channels(ch)});
            start_slowwave = Start(SlowWaveEpochs);

            %% loop over sleep stages
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
                
                
                delay_res.delay_slowwave_tone1{p,ch,sstage} = delay_slowwave_tone1;
                delay_res.delay_slowwave_tone2{p,ch,sstage} = delay_slowwave_tone2;
            end
        end
    end
    
end

%saving data
cd(FolderPrecomputeDreem)
save QuantifClinicDelayToneSlowWave.mat delay_res sleepstage_ind channels name_channels



