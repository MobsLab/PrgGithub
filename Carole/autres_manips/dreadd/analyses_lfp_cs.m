%% load le pfc
clear all
Mice=[873, 874, 891];
i=3
mouse_num=Mice(i);
path=strcat('/media/mobschapeau/09E7077B1FE07CCB/DREADD/', num2str(mouse_num), '/cond/day2_sleep_ext_sleep');
cd(path)
load('ExpeInfo.mat');
load('behavResources.mat');
load('Epoch.mat')
channel_pfc=ExpeInfo.ChannelToAnalyse.PFCx_deep;

load(['LFPData/LFP',num2str(channel_pfc),'.mat']);

% %% gros mega spectro de toute la journée
% 
[Sp,t,f]=LoadSpectrumML(channel_pfc,pwd,'low');
% imagesc(t, f, log(Sp'));
% axis xy;
% hold on;
% 
% vline(TTLInfo.InjectTTL, 'r', 'inj');
% vline(TTLInfo.ExtTTL, 'r', 'debut ext');
% vline(TTLInfo.PostExtTTL, 'r', 'fin ext');
% 
% title(strcat('mouse',num2str(mouse_num),' spectro pfc'));

%% p=f(f) pour le pfc, avant et apres injection

Spectsd = tsd(t*1e4,log(Sp));

subplot(1,3,1);
% eveillee avant
plot(f,mean(Data(Restrict(Spectsd,Epoch.Non_FreezeAcc_Pre_Inj))), 'color', 'g','linewidth',2);
hold on
plot(f,mean(Data(Restrict(Spectsd,Epoch.Inj))), 'color', 'r','linewidth',2);
hold on
plot(f,mean(Data(Restrict(Spectsd,Epoch.Non_FreezeAcc_Ext))), 'color', 'k','linewidth',2);
hold on
plot(f,mean(Data(Restrict(Spectsd,Epoch.Non_FreezeAcc_Post_Ext))), 'color', 'm','linewidth',2);
hold on
legend('awake pre inj', 'awake post inj','active ext', 'awake post ext');
title(strcat('mouse',num2str(mouse_num),' spectro pfc, active'));


subplot(1,3,2);
plot(f,mean(Data(Restrict(Spectsd,Epoch.FreezeAcc_Ext))), 'color', 'r','linewidth',2);
hold on
plot(f,mean(Data(Restrict(Spectsd,Epoch.Non_FreezeAcc_Ext))), 'color', 'k','linewidth',2);
hold on
legend('freeze (ext)', 'active (ext)');
title(strcat('mouse',num2str(mouse_num),' spectro pfc, extinction'));

subplot(1,3,3);
plot(f,mean(Data(Restrict(Spectsd,Epoch.FreezeAcc_Pre_Inj))), 'color', 'blue','linewidth',2);
hold on
plot(f,mean(Data(Restrict(Spectsd,Epoch.Non_FreezeAcc_Post_Ext))), 'color', 'green','linewidth',2);
hold on
legend('sleep pre inj', 'sleep post ext');
title(strcat('mouse',num2str(mouse_num),' spectro pfc, sleep'));
