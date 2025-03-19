% ClinicStatAfterStim
% 17.08.2017 KJ
%
% After stimulation Stat : amplitude / AUC / Slop / Amplitude
% 
% 
%   see ClinicStatSlowWaves
%



clear

%Dir
Dir = ListOfClinicalTrialDreemAnalyse('study');

%params
common_data = GetClinicCommonData();

after_stim_period = 7E4;
lim_between_stim = common_data.lim_between_stim;
phases_group = [-pi/4 pi/4; pi/4 3*pi/4; 3*pi/4 -3*pi/4; -3*pi/4 -pi/4];


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
    [signals, stimulations, ~, name_channel, ~] = GetRecordClinic(Dir.filename{p});

    % VIRTUAL CHANNEL SIGNAL
    [index_dreem, index_psg, ~, ~] = GetVirtualChannels(Dir.filereference{p});
    [signals_dreem_vc, ~, badEpochsDreem, ~] = ComputeDataVirtualChannel(signals, index_dreem, index_psg, name_channel);
    [phase_vc, ~] = ComputeHilbertData(signals_dreem_vc,'bandpass',[0.5 4]);
    rg = Range(signals_dreem_vc);
    All_night = intervalSet(rg(1),rg(end));
    goodEpochs = All_night - badEpochsDreem;

   
    
    %% TONES
    %only real auditory stimulations 
    stimulations = Restrict(stimulations, goodEpochs);
    stim_tmp = Range(stimulations);
    if strcmpi(Dir.condition{p},'sham')
        stim_tmp = stim_tmp(Data(stimulations)==0); %sham
    else
        stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
    end
    
    %distinguish 1st and 2nd tones   
    second_idx = [0 ; diff(stim_tmp)<lim_between_stim];
    isolated_idx = [diff(second_idx)==0;0].* (second_idx==0);
    first_tones = (second_idx==0) .* (isolated_idx==0);
    first_tmp = stim_tmp(first_tones==1);
    nb_first = length(first_tmp);
    
    quantity_res.tones.total{p} = length(stim_tmp);
    quantity_res.tones.rank_tones{p} = 0*isolated_idx + first_tones + 2*second_idx;
    
    %tone phases
    phase_value = Data(phase_vc);
    phase_tmp = Range(phase_vc);
    phase_tone = zeros(length(first_tmp), 1);
    for i=1:length(first_tmp)
        [~,min_idx] = min(abs(phase_tmp-first_tmp(i)));
        phase_tone(i) = phase_value(min_idx);
    end
    
    %group of phases
    phasegroup_tone = zeros(nb_first,1);
    for i=1:size(phases_group,1)
        if phases_group(i,1)<phases_group(i,2)
            idx_curve = phase_tone>phases_group(i,1) & phase_tone<phases_group(i,2);
        else
            idx_curve = phase_tone>phases_group(i,1) | phase_tone<phases_group(i,2);
        end
        phasegroup_tone(idx_curve) = i;
    end
    
    quantity_res.first.phase{p} = phase_tone;
    quantity_res.first.phasegroup{p} = phasegroup_tone;
    
    
    %% AUC and amplitude
    auc1 = nan(nb_first,1);
    amplitude1 = nan(nb_first,1);
    auc2 = nan(nb_first,1);
    amplitude2 = nan(nb_first,1);
    
    
    for i=1:nb_first
        eeg_tsd = Restrict(signals_dreem_vc, intervalSet(first_tmp(i), first_tmp(i) + after_stim_period));
        rg = Range(eeg_tsd);
        zerocrossing = Range(threshold(eeg_tsd, 0, 'Crossing', 'Rising'));
        
        if length(zerocrossing)>2
            switch(phasegroup_tone(i)),
                case 1, %-45/45°
                    intv1 = intervalSet(rg(1), zerocrossing(1));
                    intv2 = intervalSet(zerocrossing(1), zerocrossing(2));
                case 2, %45/135°
                    intv1 = intervalSet(rg(1), zerocrossing(1));
                    intv2 = intervalSet(zerocrossing(1), zerocrossing(2));
                case 3, %135/-135°
                    intv1 = intervalSet(zerocrossing(1), zerocrossing(2));
                    intv2 = intervalSet(zerocrossing(2), zerocrossing(3));
                case 4, %-135/135°
                    intv1 = intervalSet(rg(1), zerocrossing(1));
                    intv2 = intervalSet(zerocrossing(1), zerocrossing(2));
            end

            eeg_signal1 = Data(Restrict(eeg_tsd, intv1));
            eeg_signal2 = Data(Restrict(eeg_tsd, intv2));

            [trough_value1, ~] = min(eeg_signal1);
            [trough_value2, ~] = min(eeg_signal2);

            auc1(i) = sum(abs(eeg_signal1));
            amplitude1(i) = trough_value1;
            auc2(i) = sum(abs(eeg_signal2));
            amplitude2(i) = trough_value2;  
        end
    end
    
    quantity_res.auc1{p} = auc1;
    quantity_res.amplitude1{p} = amplitude1;
    quantity_res.auc2{p} = auc2;
    quantity_res.amplitude2{p} = amplitude2;
    
end


%saving data
cd(FolderPrecomputeDreem)
save ClinicStatAfterStim.mat quantity_res phases_group after_stim_period








