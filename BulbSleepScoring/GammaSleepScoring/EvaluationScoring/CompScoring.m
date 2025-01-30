tic
%% Step 1 - channels to use and 2 spectra
close all
clear WeirdNoiseEpoch Channel_SleepScor channels

filename=cd;
if filename(end)~='/'
    filename(end+1)='/';
end
scrsz = get(0,'ScreenSize');
load('LFPData/LFP1.mat');
r=Range(LFP);
TotalEpoch=intervalSet(0*1e4,r(end));
mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep
ThreshEpoch=TotalEpoch;
% end
%
%chH=input('please give hippocampus channel for theta');
%chB=input('please give olfactory bulb channel');

%% Step 2 - Theta and Gamma Epochs from Spectra

load('StateEpoch.mat');
try
    chH=Channel_SleepScor;
catch
    try chH=channels;
    catch
        load('LFPData/InfoLFP.mat')
        strhpc=strmatch('dHPC',InfoLFP.structure);
        chH=InfoLFP.channel(strhpc(1));
    end
end


load('ChannelsToAnalyse/Bulb_deep.mat');
chB=channel;

try WeirdNoiseEpoch;
catch WeirdNoiseEpoch=intervalSet(0,1*1e4);
end
Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch-WeirdNoiseEpoch;
save(strcat(filename,'StateEpochSB'),'Epoch','NoiseEpoch','GndNoiseEpoch','NoiseThresh', 'GndNoiseThresh','-v7.3');
% try
% load('behavResources.mat','PreEpoch')
% Epoch=And(Epoch,PreEpoch);
% Epoch=CleanUpEpoch(Epoch);
% end
% try
% load('behavResources.mat','stimEpoch')
% Epoch=Epoch-stimEpoch;
% Epoch=CleanUpEpoch(Epoch);
% end
TotalEpoch=And(TotalEpoch,Epoch);
TotalEpoch=CleanUpEpoch(TotalEpoch);
close all;
FindGammaEpoch(TotalEpoch,chB,mindur,filename);
close all;
FindThetaEpoch(TotalEpoch,ThetaI,chH,filename);
close all;

%% Step 3 - Behavioural Epochs
FindBehavEpochs(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)

%% Step 4 - Sleep scoring figure


PlotEp=TotalEpoch;
FigCompScoring
toc
%
% %m147
% Ep=intervalSet([425,2191,3085,3350,5087,9573,10376,12509,18925]*1e4,[515,2356,3183,3536,5230,9612,10475,12779,19500]*1e4)
% %m148
% Ep=intervalSet([439,552,5980,6432,8265,24119]*1e4,[451,1137,6224,6614,8905,24263]*1e4)


