%% Get noisy epochs
FindNoiseEpoch_BM([cd filesep],channel,0);
              
%% Get heart beats
clear all
Options.TemplateThreshStd=3;
Options.BeatThreshStd=0.05;
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
load('StateEpochSB.mat','TotalNoiseEpoch')
[Times,Template,HeartRate,GoodEpoch] = DetectHeartBeats_EmbReact_SB(LFP,NoiseEpoch,Options,1);

EKG.HBTimes=ts(Times);l
EKG.HBShape=Template;
EKG.DetectionOptions=Options;
EKG.HBRate=HeartRate;
EKG.GoodEpoch=GoodEpoch;

save('HeartBeatInfo.mat','EKG')
saveas(1,'EKGCheck.fig'),
saveas(1,'EKGCheck.png')

%% Get gamma power
clear all
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);
SmoothGamma = tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
save('SleepScoring_OBGamma','Sleep','SmoothGamma','-append')

%% Sleep scoring
SleepScoringOBGamma

%% Get low frequency spectra - example with bulb
load('ChannelsToAnalyse/Bulb_deep.mat')
LowSpectrumSB([cd filesep],channel,'B')

%% Get high frequency spectra - example with bulb
load('ChannelsToAnalyse/Bulb_deep.mat')
HighSpectrum([cd filesep],channel,'B');

%% Get breathing from OB
clear all
load('B_Low_Spectrum.mat')
Spectrum_Frequency = ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
save('RespiFreq','Spectrum_Frequency')

%% Get ripples
CreateRipplesSleep('stim',0,'restrict',1,'sleep',1)
