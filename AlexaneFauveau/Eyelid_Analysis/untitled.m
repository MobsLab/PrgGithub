

clear all
load('behavResources.mat')
StimEpoch = TTLInfo.StimEpoch;
StimEpoch = intervalSet(Start(StimEpoch)-0.1*1e4,Stop(StimEpoch)+0.1*1e4);
SleepScoring_OBgamma_RemoveStimBeforeSmoothing_AF('stimepoch',StimEpoch);



load('SleepScoring_OBGamma.mat')
figure
plot(Range(SmoothGamma,'min'),Data(SmoothGamma))
hold on
plot(Range(Restrict(SmoothGamma,Wake),'min'),Data(Restrict(SmoothGamma,Wake)),'r')
load('SleepScoring_OBGamma_Audiodream.mat')
plot(Range(SmoothGamma,'min'),Data(SmoothGamma)+400,'b')
plot(Range(Restrict(SmoothGamma,Wake),'min'),Data(Restrict(SmoothGamma,Wake))+400,'r')







