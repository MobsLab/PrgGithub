%% input dir
DirDREADD = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirOpto_ChR = PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto_Ctrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');

DirOpto = MergePathForExperiment(DirOpto_ChR,DirOpto_Ctrl);
DirGam = MergePathForExperiment(DirDREADD, DirOpto_Ctrl);

%% get data for all mice with EMG
for i=1:length(DirOpto_Ctrl.path)
    cd(DirOpto_Ctrl.path{i}{1});
    % REM
    [Spectro_start_rem, Spectro_end_rem, Spectro_stimOpto_rem, temps] = GetGammaPowerAtTransitions_MC('rem');
    Sp_startREM{i} = Spectro_start_rem;
    Sp_endREM{i} = Spectro_end_rem;
    % NREM
    [Spectro_start_sws, Spectro_end_sws, Spectro_stim_sws, temps] = GetGammaPowerAtTransitions_MC('sws');
    Sp_startSWS{i} = Spectro_start_sws;
    Sp_endSWS{i} = Spectro_end_sws;
    % WAKE
    [Spectro_start_wake, Spectro_end_wake, Spectro_stim_wake, temps] = GetGammaPowerAtTransitions_MC('wake');
    Sp_startWake{i} = Spectro_start_wake;
    Sp_endWake{i} = Spectro_end_wake;
    
    %======================================================================
    [Spectro_start_transREMSWS, Spectro_end, Spectro_stim, temps] = GetGammaPowerAtTransitions_MC('transREMSWS');
    Sp_StartSWS_precededByREM{i} = Spectro_start_transREMSWS;
    
    [Spectro_start_transREMWake, Spectro_end, Spectro_stim, temps] = GetGammaPowerAtTransitions_MC('transREMWake');
    Sp_StartWake_precededByREM{i} = Spectro_start_transREMWake;
    %======================================================================
end

%% get data for opto mice
for j=1:length(DirOpto_ChR.path)
    cd(DirOpto_ChR.path{j}{1});
    % REM
    [Spectro_start_rem, Spectro_end_rem, Spectro_stimOpto_rem, temps] = GetGammaPowerAtTransitions_MC('rem');
    Sp_stimREM_opto{j} = Spectro_stimOpto_rem;
    
end

%% get data for control mice
for k=1:length(DirOpto_Ctrl.path)
    cd(DirOpto_Ctrl.path{k}{1});
    % REM
    [Spectro_start_rem, Spectro_end_rem, Spectro_stimCtrl_rem, temps] = GetGammaPowerAtTransitions_MC('rem');
    Sp_stimREM_ctrl{k} = Spectro_stimCtrl_rem;
end

%% calculate mean

dataSp_startREM = cat(3,Sp_startREM{:});
dataSp_endREM = cat(3,Sp_endREM{:});
dataSp_startSWS = cat(3,Sp_startSWS{:});
dataSp_endSWS = cat(3,Sp_endSWS{:});
dataSp_startWake = cat(3,Sp_startWake{:});
dataSp_endWake = cat(3,Sp_endWake{:});
dataSp_StartSWS_precededByREM = cat(3,Sp_StartSWS_precededByREM{:});
dataSp_StartWake_precededByREM = cat(3,Sp_StartWake_precededByREM{:});

dataSp_stimREM_opto = cat(3,Sp_stimREM_opto{:});
dataSp_stimREM_ctrl = cat(3,Sp_stimREM_ctrl{:});

avdataSp_startREM = nanmean(dataSp_startREM,3);
avdataSp_endREM = nanmean(dataSp_endREM,3);
avdataSp_startSWS = nanmean(dataSp_startSWS,3);
avdataSp_endSWS = nanmean(dataSp_endSWS,3);
avdataSp_startWake = nanmean(dataSp_startWake,3);
avdataSp_endWake = nanmean(dataSp_endWake,3);
avdataSp_StartSWS_precededByREM = nanmean(dataSp_StartSWS_precededByREM,3);
avdataSp_StartWake_precededByREM = nanmean(dataSp_StartWake_precededByREM,3);

avdataSp_stimREM_opto = nanmean(dataSp_stimREM_opto,3);
avdataSp_stimREM_ctrl = nanmean(dataSp_stimREM_ctrl,3);

%% figure
% freq=[20:100];

freq=[1:30];

% all transitions
figure, hold on
subplot(431), imagesc(temps, freq, avdataSp_startREM), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('start REM (n = 10)')
ylim([5 30])
subplot(437), imagesc(temps, freq, avdataSp_endREM), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('end REM')
ylim([5 30])
subplot(432),  imagesc(temps, freq, avdataSp_startSWS), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('start NREM')
ylim([5 30])
subplot(438),  imagesc(temps, freq, avdataSp_endSWS), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('end NREM')
ylim([5 30])
subplot(435),  imagesc(temps, freq, avdataSp_StartSWS_precededByREM), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('start NREM preceded by REM')
ylim([5 30])
subplot(436),  imagesc(temps, freq, avdataSp_StartWake_precededByREM), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('start Wake preceded by REM (n = 8)')
ylim([5 30])
subplot(433), imagesc(temps, freq, avdataSp_startWake), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('start wake')
ylim([5 30])
subplot(439), imagesc(temps, freq, avdataSp_endWake), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('end wake')
ylim([5 30])
subplot(4,3,10), imagesc(temps, freq, avdataSp_stimREM_ctrl), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('opto stim in REM (control n = 5)')
ylim([5 30])
subplot(4,3,11), imagesc(temps, freq, avdataSp_stimREM_opto), axis xy, colormap(jet), %caxis([0 3])
colorbar
line([0 0], ylim,'color','w','linestyle','-')
xlim([-60 60])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('opto stim in REM (n = 8)')
ylim([5 30])