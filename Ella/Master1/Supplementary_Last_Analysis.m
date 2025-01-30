
%% Compare the P&T and Spectrogram methods on the Plethysmo and OB data

% Extract data from Fear experiment
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
cd(Dir.path{1}) 
 
% Get breathing raw
% load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse493/FEAR-Mouse-493-Ext-24-Plethysmo-20161227/ChannelsToAnalyse/Respi.mat')
load('ChannelsToAnalyse/Respi.mat')
load(['LFPData/LFP' num2str(channel)])
Respi = LFP;
Respi = FilterLFP((Respi),[0.1 20],1024);

% Get OB raw
clear channel LFP
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel)])
OB = LFP;
OB = FilterLFP((OB),[0.1 20],1024);

% Check the signals
figure
plot(Range(Respi,'s'),Data(Respi))
hold on
plot(Range(OB,'s'),Data(OB))
xlim([500 505])

%% Get analysis of breathing

%% Sophie's version

load('BreathingInfo_ZeroCross.mat')

% In case needed (Sophie's initial code)
% load('BreathingInfo.mat')
% plot(Range(Breathtsd,'s'),Data(Breathtsd),'*')

figure
% set(0,'DefaultFigureWindowStyle','docked')
plot(Range(Respi,'s'),Data(Respi))
hold on
% check peak trough detetion
plot(Range(Troughtsd,'s'),Data(Troughtsd),'*')
plot(Range(Peaktsd,'s'),Data(Peaktsd),'*')

yyaxis right
plot(Range(Frequecytsd,'s'),Data(Frequecytsd))
xlim([500 505])
plot(Range(Frequecytsd,'s'),runmean_BM(Data(Frequecytsd), 30))

%% Baptiste's version

% Files to find the functions
% edit Process_Sleep_BM.m
% edit MeanValuesPhysiologicalParameters_BM.m

% P&T method applied on OB and Respi
MakeInstFreqForSession_BM
PT.OB = load('InstFreqAndPhase_B.mat', 'LocalFreq');
PT.Respi = load('InstFreqAndPhase_Respi.mat', 'LocalFreq');

% Spectro method applied on OB and Respi
Spectrum.OB = load('B_Low_Spectrum.mat');
Spectro.OB = ConvertSpectrum_in_Frequencies_BM(Spectrum.OB.Spectro{3} , Spectrum.OB.Spectro{2}*1e4 , Spectrum.OB.Spectro{1});
Spectrum.Respi = load('Respi_Low_Spectrum.mat');
Spectro.Respi = ConvertSpectrum_in_Frequencies_BM(Spectrum.Respi.Spectro{3} , Spectrum.Respi.Spectro{2}*1e4 , Spectrum.Respi.Spectro{1});


%% Compare the two measures (PT and Spectro) on OB data
% Extract frequencies 
RunMean.OB.PT = runmean_BM(Data(PT.OB.LocalFreq.PT),ceil(0.03*length(PT.OB.LocalFreq.PT)));
RunMean.OB.Spectro = runmean_BM(Data(Spectro.OB),ceil(0.03*length(Spectro.OB)));
Restrict_StoPT.OB = Restrict(Spectro.OB, PT.OB.LocalFreq.PT);
RunMean.OB.RestSpectro = runmean_BM(Data(Restrict_StoPT.OB),ceil(0.03*length(Restrict_StoPT.OB)));

% Look at the raw signals
figure
plot(Range(PT.OB.LocalFreq.PT),Data(PT.OB.LocalFreq.PT)); hold on;
plot(Range(Spectro.OB),Data(Spectro.OB)); hold on;
plot(Range(PT.OB.LocalFreq.PT),Data(Restrict_StoPT.OB)); hold on;
% Runmeaned signals
figure
plot(Range(PT.OB.LocalFreq.PT),RunMean.OB.PT); hold on;
plot(Range(Spectro.OB),RunMean.OB.Spectro); hold on;
plot(Range(PT.OB.LocalFreq.PT),RunMean.OB.RestSpectro); hold on;

%% Compare the two measures (PT and Spectro) on plethysmography data
% Extract frequencies 
RunMean.Respi.PT = runmean_BM(Data(PT.Respi.LocalFreq.PT),ceil(0.03*length(PT.Respi.LocalFreq.PT)));
RunMean.Respi.Spectro = runmean_BM(Data(Spectro.Respi),ceil(0.03*length(Spectro.Respi)));
Restrict_StoPT.Respi = Restrict(Spectro.Respi, PT.Respi.LocalFreq.PT);
RunMean.Respi.RestSpectro = runmean_BM(Data(Restrict_StoPT.Respi),ceil(0.03*length(Restrict_StoPT.Respi)));

% Look at the raw signals
figure
plot(Range(PT.Respi.LocalFreq.PT),Data(PT.Respi.LocalFreq.PT)); hold on;
plot(Range(Spectro.Respi),Data(Spectro.Respi)); hold on;
plot(Range(PT.Respi.LocalFreq.PT),Data(Restrict_StoPT.Respi)); hold on;

% Runmeaned signals
figure
plot(Range(PT.Respi.LocalFreq.PT),RunMean.Respi.PT); hold on;
% plot(Range(Spectro.Respi),RunMean.Respi.Spectro); hold on;
plot(Range(PT.Respi.LocalFreq.PT),RunMean.Respi.RestSpectro); hold on;
makepretty
ylabel('Frequency plethysmography')
title('PT (blue) and Spectro (orange) method applied to pleathysmography aquired breathing')


%% Compare the OB and Respi signals measured by 1 method (Spectro)

figure
plot(Range(Spectro.OB),Data(Spectro.OB)); hold on;
plot(Range(Spectro.Respi),Data(Spectro.Respi)); hold on;

% Need
% Plethysmo and OB data of mouse that went through the U-Maze 
% The data associated to breathing to be able to fit the GLMs
% So this way of comparing seems difficult, whereas it seems to be the best
% way to do so

% Solution
% Compare the two measures (PT and Spectro) on OB data from mice that went
% through the U-Maze and then compare the correlation of these measures to
% the goodness of the fit












