%Sleep Scoring Using Olfactory Bulb and Hippocampal LFP


%% Step 1 - channels to use and 2 spectra
close all
clear all
filename=cd;
if filename(end)~='/'
   filename(end+1)='/';
end
scrsz = get(0,'ScreenSize');
load('LFPData/LFP0.mat');
r=Range(LFP);
TotalEpoch=intervalSet(0*1e4,r(end));
mindur=3; %abs cut off for events;
ThetaI=[4 10]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep

WantThreshEpoch=0;
WantThreshEpoch=input('Do you want a special Epoch for threshold finding ? y=1/n=0');
if WantThreshEpoch
    beginEp=input('Start time in sec');
    endEp=input('End time in sec');
    ThreshEpoch=intervalSet(beginEp*1e4,endEp*1e4);
else
    ThreshEpoch=TotalEpoch;
end

chH=input('please give hippocampus channel for theta');
chB=input('please give olfactory bulb channel');

% HighBlbSpectrum(filename,chB);
% disp('Bulb done')
% LowHpcSpectrum(filename,chH);
% disp('Hippocampus spectrum done')

%% Step 2 - Theta and Gamma Epochs from Spectra
% load('behavRessources.mat');
Epoch=FindNoiseEpoch(filename,chH)
% Epoch=And(Epoch,PreEpoch);
% Epoch=CleanUpEpoch(Epoch);
ThreshEpoch=And(ThreshEpoch,Epoch);
ThreshEpoch=CleanUpEpoch(ThreshEpoch);
close all;
FindThetaEpoch(ThreshEpoch,ThetaI,chH,filename);
% CalcTheta(Epoch,ThetaI,chH,filename)
close all;
FindGammaEpochv2(ThreshEpoch,chB,mindur,filename);
%CalcGamma(Epoch,chB,mindur,filename)

close all;

%% Step 3 - Behavioural Epochs
load(strcat(filename,'StateEpochSB'))
% Epoch=And(Epoch,PreEpoch);
Epoch=CleanUpEpoch(Epoch);
    FindBehavEpochs(TotalEpoch,ThetaEpoch,sleepper,mindur,mw_dur,sl_dur,ms_dur,wa_dur,Epoch,filename);
    load(strcat(filename,'StateEpochSB'))
    [aft_cell,bef_cell]=transEpoch(wakeper,REMEpoch);
    disp(strcat('wake to REM transitions :',num2str(size(start(aft_cell{1,2}),1))))
    [aft_cell,bef_cell]=transEpoch(Or(NoiseEpoch,GndNoiseEpoch),Sleep);
    nsleep=And(aft_cell{1,2},bef_cell{1,2});
    disp(strcat('noise periods during sleep :',num2str(size(start(nsleep)/1e4,1))))

    %% Step 4 - Sleep scoring figure
    PlotEp=Epoch;
    SleepScoreFigure(filename,PlotEp)
close all
CheckSleepCharacteristics(filename,Epoch,13,'PFCx')
CheckSleepCharacteristics(filename,Epoch,13,'PaCx')

% Sleep Transitions maybe go into

%% Step 5 - Compare with classical sleep scoring


%% Step 6 - Clustering


%% Step 7 - Exploring the phase space



