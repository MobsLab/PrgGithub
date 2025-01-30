% QuantifStimImpactDelayToneSlowWave
% 14.05.2018 KJ
%
% distributions of the delays after the tones - STIM IMPACT
% -> Collect and save data 
%
%   see 
%       QuantifClinicDelayToneSlowWave_VC QuantifStimImpactDelayToneSlowWavePlot
%
%

clear

%Dir
Dir = ListOfDreemRecordsStimImpact('all');
    
%params
sleepstage_ind = 1:5; %N1, N2, N3, REM, WAKE


for p=1:length(Dir.filename)
    
    %init
    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    delay_res.filename{p} = Dir.filename{p};
    delay_res.filereference{p} = Dir.filereference{p};
    delay_res.condition{p} = Dir.condition{p};
    delay_res.subject{p} = Dir.subject{p};
    delay_res.date{p} = Dir.date{p};
    delay_res.age{p} = Dir.age{p};
    
    
    %% load signals
    [~, ~, stimulations, StageEpochs, ~] = GetRecordDreem(Dir.filename{p});
    
    %slow waves
    sw_file = fullfile(FolderStimImpactPreprocess, 'SlowWaves', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
    load(sw_file);
    start_slowwave = Start(SlowWaveEpochs);
    
    
    %stimulations
    [stim_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations);
    
    
    %% Delay
    
    %loop over sleep stages
    for sstage = sleepstage_ind
        
        %tones
        for k=1:size(stim_train,2)
            tones_tmp = stim_train(:,k);
            tones_tmp = tones_tmp(~isnan(tones_tmp));
            tones_tmp = Range(Restrict(ts(tones_tmp), StageEpochs{sstage}));
            
            delay_slowwave_tone{sstage,k} = [];
            for i=1:length(tones_tmp)
                idx_first_sw = find(start_slowwave > tones_tmp(i), 1);
                if ~isempty(idx_first_sw)
                    delay_slowwave_tone{sstage,k} = [delay_slowwave_tone{sstage,k} start_slowwave(idx_first_sw)-tones_tmp(i)];
                end
            end
        end
           
        for k=1:size(sham_train,2)
            %sham
            sham_tmp = sham_train(:,k);
            sham_tmp = sham_tmp(~isnan(sham_tmp));
            sham_tmp = Range(Restrict(ts(sham_tmp), StageEpochs{sstage}));
            
            delay_slowwave_sham{sstage,k} = [];
            for i=1:length(sham_tmp)
                idx_first_sw = find(start_slowwave > sham_tmp(i), 1);
                if ~isempty(idx_first_sw)
                    delay_slowwave_sham{sstage,k} = [delay_slowwave_sham{sstage,k} start_slowwave(idx_first_sw)-sham_tmp(i)];
                end
            end
            
        end
    end
    
    delay_res.tone.delay_slowwave{p} = delay_slowwave_tone;
    delay_res.sham.delay_slowwave{p} = delay_slowwave_sham;
    
end

%saving data
cd(FolderStimImpactData)
save QuantifStimImpactDelayToneSlowWave.mat delay_res sleepstage_ind



