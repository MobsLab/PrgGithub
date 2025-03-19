% QuantifClinicISI_bis
% 18.01.2017 KJ
%
% collect data for the quantification of Inter Slow-wave Intervals for different sleep stages
%   - Sleep stages = N1, N2, N3, REM, WAKE
%
% Here, the data are reformated
%
%   see QuantifClinicISI QuantifClinicISIPlot
%


clear
eval(['load ' FolderPrecomputeDreem 'QuantifClinicISI.mat'])

%params
conditions = {'Basal','Random','UpPhase'};


%% concatenate

%basal
cond = strcmpi(conditions,'Basal');
for sstage=sleepstage_ind
    for i=1:3
        basal_isi = [];
        for p=1:length(basal_res.filename)
            basal_isi = [basal_isi basal_res.isi_slowwave_stage{p,sstage}{i}];
        end
        basal_isi = basal_isi / 1E4; %in ms
        
        isi_clinic.data{cond,sstage,i,1} = basal_isi; %in ms
        isi_clinic.median(cond,sstage,i,1) = nanmedian(basal_isi); %in ms
        isi_clinic.mode(cond,sstage,i,1) = mode(basal_isi); %in ms
    end
end


%random
cond = strcmpi(conditions,'Random');
for sstage=sleepstage_ind
    for i=1:3
        random_isi_success = [];
        random_isi_failed = [];
        
        for p=1:length(tone_res.filename)
            if strcmpi(tone_res.condition{p},'Random')
                data_isi = tone_res.isi_slowwave_stage{p,i};
                selected_tones = (tone_res.sleepstage_tone{p}==sstage)'; %in the very stage
                selected_tones = tone_res.slowwave_triggered{p} .* (tone_res.sleepstage_tone{p}==sstage)'; %tones really triggered, in the very stage
                
                success_tones = selected_tones .* tone_res.induce_slow_wave{p};
                data_isi_success = data_isi(success_tones==1);
                failed_tones = selected_tones .* (tone_res.induce_slow_wave{p}==0);
                data_isi_failed = data_isi(failed_tones==1);
                
                random_isi_failed = [random_isi_failed data_isi_failed];
                random_isi_success = [random_isi_success data_isi_success];
            end
        end
        random_isi_failed = random_isi_failed / 1E4; %in s
        random_isi_success = random_isi_success / 1E4; %in s
        
        isi_clinic.data{cond,sstage,i,1} = random_isi_failed;
        isi_clinic.data{cond,sstage,i,2} = random_isi_success;
        isi_clinic.median(cond,sstage,i,1) = nanmedian(random_isi_failed);
        isi_clinic.median(cond,sstage,i,2) = nanmedian(random_isi_success);
        isi_clinic.mode(cond,sstage,i,1) = mode(random_isi_failed);
        isi_clinic.mode(cond,sstage,i,2) = mode(random_isi_success);
    end
end


%Up phase
cond = strcmpi(conditions,'UpPhase');
for sstage=sleepstage_ind
    for i=1:3
        phase_isi_success = [];
        phase_isi_failed = [];
        
        for p=1:length(tone_res.filename)
            if strcmpi(tone_res.condition{p},'UpPhase')
                data_isi = tone_res.isi_slowwave_stage{p,i};
                selected_tones = (tone_res.sleepstage_tone{p}==sstage)'; %in the very stage
                selected_tones = tone_res.slowwave_triggered{p} .* (tone_res.sleepstage_tone{p}==sstage)'; %tones really triggered, in the very stage
                
                success_tones = selected_tones .* (tone_res.induce_slow_wave{p}==1);
                data_isi_success = data_isi(success_tones==1);
                failed_tones = selected_tones .* (tone_res.induce_slow_wave{p}==0);
                data_isi_failed = data_isi(failed_tones==1);
                
                phase_isi_failed = [phase_isi_failed data_isi_failed];
                phase_isi_success = [phase_isi_success data_isi_success];
            end
        end
        phase_isi_failed = phase_isi_failed / 1E4; %in s
        phase_isi_success = phase_isi_success / 1E4; %in s
        
        isi_clinic.data{cond,sstage,i,1} = phase_isi_failed;
        isi_clinic.data{cond,sstage,i,2} = phase_isi_success;
        isi_clinic.median(cond,sstage,i,1) = nanmedian(phase_isi_failed);
        isi_clinic.median(cond,sstage,i,2) = nanmedian(phase_isi_success);
        isi_clinic.mode(cond,sstage,i,1) = mode(phase_isi_failed);
        isi_clinic.mode(cond,sstage,i,2) = mode(phase_isi_success);
    end
end


%saving data
cd(FolderPrecomputeDreem)
save QuantifClinicISI_bis.mat isi_clinic conditions sleepstage_ind lim_between_stim effect_period pre_period




