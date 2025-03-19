%% DetectHB_PAGTest_Master


Dir_DB = PathForExperimentsPAGTest_Dima('Hab');

%% Others
% Make Heart Beat data
Dir=pwd;
Options.TemplateThreshStd=3;
Options.BeatThreshStd=0.5;
load ([Dir '/ChannelsToAnalyse/EKG.mat'])
EKG = load(['LFPData/LFP',num2str(channel),'.mat']);
load('ExpeInfo.mat')
load('behavResources.mat');
% load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch');
% StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-3E2, Start(TTLInfo.StimEpoch)+5E3);
% BadEpoch = or(TotalNoiseEpoch, StimEpoch);
BadEpoch=intervalSet(0,0);
[Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(EKG.LFP,BadEpoch,Options,1);
EKG.HBTimes=ts(Times);
EKG.HBShape=Template;
EKG.DetectionOptions=Options;
EKG.HBRate=HeartRate;
EKG.GoodEpoch=GoodEpoch;
save('HeartBeatInfo.mat','EKG')
saveas(gcf,'EKGCheck.fig'),
saveFigure(gcf,'EKGCheck', Dir);