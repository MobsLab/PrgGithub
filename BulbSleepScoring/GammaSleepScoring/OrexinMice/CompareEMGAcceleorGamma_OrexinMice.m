%% Used for draft 11th april
clear all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%% Sessions
% % EMG
% m=1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h';
% % filename{m,2}=7;
% m=m+1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h';
% % filename{m,2}=7;
% m=m+1;
% filename{m,1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse573/20171221-BasalSleepDay';
% % filename{m,2}=9;

m=1;
filename{m,1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170126/ProjectEmbReact_M507_20170126_BaselineSleep';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161129/ProjectEmbReact_M490_20161129_BaselineSleep';
% filename{m,2}=9;
figure
clear emg gam
EpochSizes=[1:0.5:30];
for mm=1:3
    mm
    subplot(1,3,mm)
    cd(filename{mm})
load('behavResources.mat')
MovAccSmotsd = tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),3));
    load('StateEpochSB.mat')
    times=Range(smooth_ghi);
    timestamps = ts(times(1:1000:end));
    plot(log(Data(Restrict(smooth_ghi,timestamps))),log(Data(Restrict(MovAccSmotsd,timestamps))),'.','MarkerSize',2)
    hold on
    line([1 1]*log(gamma_thresh),ylim,'linewidth',3,'color','r')
end


%clear all, close all
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

%% Sessions
% EMG
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
% filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
% filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
% filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';


figure
clear emg gam
EpochSizes=[1:0.5:30];
for mm=1:3
    mm
    subplot(1,3,mm)
    cd(filename{mm})
    load('StateEpochEMGSB.mat')
    load('StateEpochSB.mat')
    times=Range(smooth_ghi);
    timestamps = ts(times(1:1000:end));
    plot(log(Data(Restrict(smooth_ghi,timestamps))),log(Data(Restrict(EMGData,timestamps))),'.','MarkerSize',2)
    hold on
    line([1 1]*log(gamma_thresh),ylim,'linewidth',3,'color','r')
end
