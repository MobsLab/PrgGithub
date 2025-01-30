%Sleep Scoring Using Olfactory Bulb and Hippocampal LFP

tic
%% Step 1 - channels to use and 2 spectra
close all
clear all
filename=cd;
if filename(end)~='/'
    filename(end+1)='/';
end
scrsz = get(0,'ScreenSize');
res=pwd;

load([res,'/LFPData/InfoLFP']);
load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))]);

r=Range(LFP);
TotalEpoch=intervalSet(0*1e4,r(end));
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

load('StateEpochSB','Epoch','ThetaRatioTSD','chH','NoiseEpoch','GndNoiseEpoch')


try
   load('ChannelsToAnalyse/EMG.mat') 
   chE=channel;
catch
chE=input('please give EMG channel ');
end

TotalEpoch=and(TotalEpoch,Epoch);
TotalEpoch=CleanUpEpoch(TotalEpoch);
save(strcat(filename,'StateEpochEMGSB'),'Epoch','TotalEpoch','chE','chH','NoiseEpoch','GndNoiseEpoch','-v7.3');
 
close all;
FindEMGEpoch(TotalEpoch,chE,mindur,filename);
close all;
FindThetaEpochEMG(TotalEpoch,ThetaI,chH,filename);

close all;

%% Step 3 - Behavioural Epochs
FindBehavEpochsEMG(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)
 
%% Step 4 - Sleep scoring figure

SleepScoreFigureEMG(filename,TotalEpoch)
toc
