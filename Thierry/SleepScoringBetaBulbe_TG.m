tic
%% Step 1 - channels to use and 2 spectra
close all
filename=cd;
if filename(end)~='/'
    filename(end+1)='/';
end
scrsz = get(0,'ScreenSize');
load('ChannelsToAnalyse/Bulb_deep.mat')
chB=channel
load(['LFPData/LFP',num2str(chB),'.mat']);
LFP;

r=Range(LFP);
TotalEpoch=intervalSet(0*1e4,r(end));
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

if exist('B_Low_Spectrum.mat')==0
    LowSpectrumSB(filename,chB,'B');
    disp('Bulb Spectrum done')
end
ThreshEpoch=TotalEpoch;



load SleepScoring_OBGamma Epoch
Epoch;

TotalEpoch=and(TotalEpoch,Epoch);
TotalEpoch=CleanUpEpoch(TotalEpoch);
ThreshEpoch=and(ThreshEpoch,Epoch);
ThreshEpoch=CleanUpEpoch(ThreshEpoch);
close all;
save('StateEpochSBAllOB.mat','chB')

Find1015Epoch(ThreshEpoch,ThetaI,chB,filename);

close all;

%% Step 3 - Behavioural Epochs
FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)

%% Step 4 - Sleep scoring figure
PlotEp=TotalEpoch;

SleepScoreFigureAllOB(filename,PlotEp)
toc