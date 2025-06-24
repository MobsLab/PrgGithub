
function MakeHeartRateForSession_BM

clear TTLInfo Behav EKG channel
close all
Options.TemplateThreshStd=3;
Options.BeatThreshStd=0.05;
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
try
    load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch')
catch
    load('StateEpochSB.mat', 'TotalNoiseEpoch')
end
load('ExpeInfo.mat')
if ExpeInfo.SleepSession==0
    load('behavResources.mat')
    try,  TTLInfo;
        NoiseEpoch=or(TotalNoiseEpoch,intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4));
    catch
        NoiseEpoch=TotalNoiseEpoch;
    end
else
    NoiseEpoch=TotalNoiseEpoch;
end
[Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,NoiseEpoch,Options,1);
EKG.HBTimes=ts(Times);
EKG.HBShape=Template;
EKG.DetectionOptions=Options;
EKG.HBRate=HeartRate;
EKG.GoodEpoch=GoodEpoch;

save('HeartBeatInfo.mat','EKG')
saveas(1,'EKGCheck.fig'),
saveas(1,'EKGCheck.png')
% close all
clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times

close
