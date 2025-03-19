clear all
clc

% Ordered_REM = REM();
[ Nb, States, Latence] = LatenceTransition();
% save('M645_Stim_27032018_Latence.mat','Nb')
% save('M645_Stim_27032018_States.mat','States')
% save('M645_Stim_27032018_Ordered_REM.mat','Ordered_REM')
save('M711_Baseline_28032018_Time_Latence.mat','Latence')
