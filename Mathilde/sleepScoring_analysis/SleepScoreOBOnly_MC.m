
clear all

load('ChannelsToAnalyse/Bulb_deep.mat')
chB=channel;

save('ChannelsToAnalyse/dHPC_deep.mat','channel');

SleepScoring_Accelero_OBgamma


filename=cd;
if filename(end)~='/'
    filename(end+1)='/';
end
scrsz = get(0,'ScreenSize');



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

load('ChannelsToAnalyse/Bulb_deep.mat')
chB=channel;

if exist('B_Low_Spectrum.mat')==0
    LowSpectrum_MC(filename,chB,'B');
    disp('Bulb Spectrum done')
else
    LowSpectrum_MC([cd filesep],chB,'B')
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

close all

name_to_use=strcat(filename,'StateEpochSBAllOB')
OBfrequency='1015';

%% Step 3 - Behavioural Epochs
FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)

%% Step 4 - Sleep scoring figure
PlotEp=TotalEpoch;

SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use)
close all

%%%%%% SleepScoring 15-25
save('StateEpochSBAllOB_Bis.mat','chB')
Find1525Epoch(ThreshEpoch,ThetaI,chB,filename);
close all

name_to_use=strcat(filename,'StateEpochSBAllOB_Bis')
OBfrequency='1525';

FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
PlotEp=TotalEpoch;
SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use)

close all

%%%%%% SleepScoring 20-30

save('StateEpochSBAllOB_Ter.mat','chB')
Find2030Epoch(ThreshEpoch,ThetaI,chB,filename);
close all
name_to_use=strcat(filename,'StateEpochSBAllOB_Ter')
OBfrequency='2030';

FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
PlotEp=TotalEpoch;
SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use)

close all
