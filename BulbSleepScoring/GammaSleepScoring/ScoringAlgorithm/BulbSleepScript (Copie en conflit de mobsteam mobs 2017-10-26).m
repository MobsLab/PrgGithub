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

WantThreshEpoch=0;
%WantThreshEpoch=input('Do you want a special Epoch for threshold finding ? y=1/n=0 ');
if WantThreshEpoch
    beginEp=input('Start time in sec');
    endEp=input('End time in sec');
    ThreshEpoch=intervalSet(beginEp*1e4,endEp*1e4);
else
    ThreshEpoch=TotalEpoch;
end

try
    load('ChannelsToAnalyse/dHPC_deep.mat')
    chH=channel;
catch
    try
        load('ChannelsToAnalyse/dHPC_rip.mat')
        chH=channel;
    catch
        chH=input('please give hippocampus channel for theta ');
    end
end

try
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
catch
    chB=input('please give olfactory bulb channel ');
end

%  
%  HighSpectrum(filename,chB,'B');
%  disp('Bulb Spectrum done')
%  LowSpectrumSB(filename,chH,'H');
%  disp('Hpc spectrum done')
% % 

%% Step 2 - Theta and Gamma Epochs from Spectra
% load('behavRessources.mat');
try
    load StateEpochSB
    Epoch;
catch
    Epoch=FindNoiseEpoch(filename,chH);
end

%Epoch=FindNoiseEpoch(filename,chH);

try
    load('behavResources.mat','PreEpoch')
    Epoch=and(Epoch,PreEpoch);
    Epoch=CleanUpEpoch(Epoch);
end
try
    load('behavResources.mat','stimEpoch')
    Epoch=Epoch-stimEpoch;
    Epoch=CleanUpEpoch(Epoch);
end
    
TotalEpoch=and(TotalEpoch,Epoch);
TotalEpoch=CleanUpEpoch(TotalEpoch);
ThreshEpoch=and(ThreshEpoch,Epoch);
ThreshEpoch=CleanUpEpoch(ThreshEpoch);
close all;
FindGammaEpoch(ThreshEpoch,chB,mindur,filename);
close all;
FindThetaEpoch(ThreshEpoch,ThetaI,chH,filename);
% CalcTheta(Epoch,ThetaI,chH,filename)
%CalcGamma(Epoch,chB,mindur,filename)

close all;

%% Step 3 - Behavioural Epochs
FindBehavEpochs(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)
 
%% Step 4 - Sleep scoring figure
%WantPlotEpoch=input('Do you want a special Epoch for plotting ? y=1/n=0 ');
WantPlotEpoch=0;
if WantPlotEpoch
    beginEp=input('Start time in sec ');
    endEp=input('End time in sec ');
    PlotEp=intervalSet(beginEp*1e4,endEp*1e4);
    PlotEp=And(PlotEp,TotalEpoch);
    PlotEp=CleanUpEpoch(PlotEp);
else
    PlotEp=TotalEpoch;
end

SleepScoreFigure(filename,PlotEp)
toc
 
% %m147
% Ep=intervalSet([425,2191,3085,3350,5087,9573,10376,12509,18925]*1e4,[515,2356,3183,3536,5230,9612,10475,12779,19500]*1e4)
% %m148
% Ep=intervalSet([439,552,5980,6432,8265,24119]*1e4,[451,1137,6224,6614,8905,24263]*1e4)

