%% input dir
DirDREADD = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirDREADD = RestrictPathForExperiment(DirDREADD, 'nMice', [1150]); % to get mice with EMG only

DirOpto_ChR = PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto_ChR = RestrictPathForExperiment(DirOpto_ChR, 'nMice', [675 733 1074 1076 1109]);
DirOpto_Ctrl = PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirOpto_Ctrl = RestrictPathForExperiment(DirOpto_Ctrl, 'nMice', [1075 1112 1180]); %

DirOpto = MergePathForExperiment(DirOpto_ChR, DirOpto_Ctrl);

DirEMG = MergePathForExperiment(DirDREADD, DirOpto);

%% get data for all mice with EMG
for i=1:length(DirEMG.path)
    cd(DirEMG.path{i}{1});
    % REM
    [M_start_rem, M_end_rem, M_stim_rem] = GetActivityAtStateTransition_MC('emg','rem');
    % to get the 2nd column to get the mean emg of each mouse
    startREM(:,i) = M_start_rem(:,2);
    endREM(:,i) = M_end_rem(:,2);
    % to get the 4th column to get stdError emg of each mouse
    % NREM
    [M_start_sws, M_end_sws, M_stim_sws] = GetActivityAtStateTransition_MC('emg','sws');
    startSWS(:,i) = M_start_sws(:,2); % to get the 2nd column to get the mean emg of each mouse
    endSWS(:,i) = M_end_sws(:,2);
    % WAKE
    [M_start_wake, M_end_wake, M_stim_wake] = GetActivityAtStateTransition_MC('emg','wake');
    startWake(:,i) = M_start_wake(:,2); % to get the 2nd column to get the mean emg of each mouse
    endWake(:,i) = M_end_wake(:,2);
    
    %======================================================================
    %     [M_start_transREMSWS, M_end_transREMSWS, M_stim_transREMSWS] = GetActivityAtStateTransition_MC('emg','transREMSWS');
    %     StartSWS_precededByREM(:,i) = M_start_transREMSWS(:,2);
    %
    %     [M_start_transREMWake, M_end_transREMWake, M_stim_transREMWake] = GetActivityAtStateTransition_MC('emg','transREMWake');
    %     StartWake_precededByREM(:,i) = M_start_transREMWake(:,2);
    %======================================================================
end

%% get data for opto mice
for j=1:length(DirOpto_ChR.path)
    cd(DirOpto_ChR.path{j}{1});
    % REM
    [M_start_rem, M_end_rem, M_stim_rem] = GetActivityAtStateTransition_MC('emg','rem');
    stimREM_opto(:,j) = M_stim_rem(:,2); % to get the 2nd column to get the mean emg of each mouse
end

%% get data for control mice
for k=1:length(DirOpto_Ctrl.path)
    cd(DirOpto_Ctrl.path{k}{1});
    % REM
    [M_start_rem, M_end_rem, M_stim_rem] = GetActivityAtStateTransition_MC('emg','rem');
    stimREM_ctrl(:,k) = M_stim_rem(:,2); % to get the 2nd column to get the mean emg of each mouse
end

%% calculate median
startREM_med = median(startREM,2);
endREM_med = median(endREM,2);
startSWS_med = median(startSWS,2);
endSWS_med = median(endSWS,2);
startWake_med = median(startWake,2);
endWake_med = median(endWake,2);
stimREM_opto_med = median(stimREM_opto,2);
stimREM_ctrl_med = median(stimREM_ctrl,2);
% StartSWS_precededByREM_med = median(StartSWS_precededByREM,2);
% StartWake_precededByREM_med = nanmedian(StartWake_precededByREM,2);
% calculate std
startREM_std = std(startREM');
endREM_std = std(endREM');
startSWS_std = std(startSWS');
endSWS_std = std(endSWS');
startWake_std = std(startWake');
endWake_std = std(endWake');
stimREM_opto_std = std(stimREM_opto');
stimREM_ctrl_std = std(stimREM_ctrl');
% StartSWS_precededByREM_std = std(StartSWS_precededByREM');
% StartWake_precededByREM_std = nanstd(StartWake_precededByREM');

%% figure
% all transitions
figure, subplot(231), shadedErrorBar(M_start_rem(:,1), runmean(startREM_med,1), startREM_std, 'g'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
% xlim([-60 60])
title('start REM')
subplot(234), shadedErrorBar(M_start_rem(:,1), runmean(endREM_med,1), endREM_std, 'g'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('end REM')
subplot(232), shadedErrorBar(M_start_rem(:,1), runmean(startSWS_med,1), startSWS_std, 'r'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start NREM')
subplot(235), shadedErrorBar(M_start_rem(:,1), runmean(endSWS_med,1), endSWS_std, 'r'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('end NREM')
subplot(233), shadedErrorBar(M_start_rem(:,1), runmean(startWake_med,1), startWake_std, 'b'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start wake')
subplot(236), shadedErrorBar(M_start_rem(:,1), runmean(endWake_med,1), endWake_std, 'b'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('end wake')

%% all transitions and opto stimulations
figure, subplot(431), shadedErrorBar(M_start_rem(:,1), runmean(startREM_med,1), startREM_std, 'g'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start REM (n = 9)')

subplot(432), shadedErrorBar(M_start_rem(:,1), runmean(startSWS_med,1), startSWS_std, 'r'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start NREM')

subplot(433), shadedErrorBar(M_start_rem(:,1), runmean(startWake_med,1), startWake_std, 'b'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start wake')

subplot(435), shadedErrorBar(M_start_rem(:,1), runmean(StartSWS_precededByREM_med,1), StartSWS_precededByREM_std, 'r'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start NREM preceded by REM')

subplot(436), shadedErrorBar(M_start_rem(:,1), runmean(StartWake_precededByREM_med,1), StartWake_precededByREM_std, 'b'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('start Wake preceded by REM')

subplot(437), shadedErrorBar(M_start_rem(:,1), runmean(endREM_med,1), endREM_std, 'g'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('end REM')

subplot(438), shadedErrorBar(M_start_rem(:,1), runmean(endSWS_med,1), endSWS_std, 'r'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('end NREM')

subplot(439), shadedErrorBar(M_start_rem(:,1), runmean(endWake_med,1), endWake_std, 'b'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('end wake')

subplot(4,3,10), shadedErrorBar(M_start_rem(:,1), runmean(stimREM_ctrl_med,1), stimREM_ctrl_std, 'k'), hold on;
ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('stim (control n = 2)')

subplot(4,3,11), shadedErrorBar(M_start_rem(:,1), runmean(stimREM_opto_med,1), stimREM_opto_std, 'k'), hold on;
% ylim([0 3.5e5])
line([0 0], ylim,'color','k','linestyle',':')
plot([-60 60], [0.5e5 0.5e5],'color',[0.3 0.3 0.3],'linewidth',0.5)
xlabel('Time (s)')
makepretty
xlim([-60 60])
title('stim opto (n = 5)')


%%
%%%%%%

st_REM = mean(startREM(601:end,:));
st_SWS = mean(startSWS(601:end,:));
st_Wake = mean(startWake(601:end,:));

st_opto = mean(stimREM_opto(601:end,:));
st_ctrl = mean(stimREM_ctrl(601:end,:));

data = {st_SWS, st_REM, st_Wake,st_ctrl,st_opto};
figure, MakeBoxPlot_DB(data,{[1 0 0],[0 1 0],[0 .2 .8],[0.3 0.3 0.3],[0.3 0.3 0.3]},[1 2 3 4 5], {'NREM','REM','Wake','ctrl','opto'},1)
ylabel('Mean value EMG^2')


%%
data = {st_SWS, st_REM, st_Wake};
figure, MakeBoxPlot_DB(data,{[1 0 0],[0 1 0],[0 .2 .8]},[1 2 3], {'NREM','REM','Wake'},1)
ylabel('Mean value EMG^2')


% Rank sum test
p = ranksum(st_SWS, st_REM);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',12);
end

p = ranksum(st_SWS, st_Wake);
if p<0.05
    sigstar_DB({[1 3]},p,0,'LineWigth',16,'StarSize',12);
end

p = ranksum(st_REM, st_Wake);
if p<0.05
    sigstar_DB({[2 3]},p,0,'LineWigth',16,'StarSize',12);
end

