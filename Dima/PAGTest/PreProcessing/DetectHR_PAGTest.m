%% DetectHR_PAGTest

try
   dirin;
catch
   dirin=Dir.path;
end

for i=1:length(dirin)
    cd(dirin{i});
    
    load ([dirin{i} '/ChannelsToAnalyse/EKG.mat']);
    
    
    %% Check for noise
    [Epoch,TotalNoiseEpoch,SubNoiseEpoch,Info]=FindNoiseEpoch_SleepScoring(channel);
	
    load ([dirin{1} '/LFPData/LFP' num2str(channel) '.mat']);
    A = Restrict(LFP, Epoch);
    plot(Range(A, 's'), Data(A))
    
    save('NoiseEpoch', 'Epoch', 'TotalNoiseEpoch','SubNoiseEpoch','Info');
    
    %% Make Heart Beat data
    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.5;
    load ([dirin{i} '/ChannelsToAnalyse/EKG.mat'])
    EKG = load(['LFPData/LFP',num2str(channel),'.mat']);
    load('ExpeInfo.mat')
    load('behavResources.mat');
    SafeEpoch = intervalSet (Start(TTLInfo.StimEpoch)-5E2, Start(TTLInfo.StimEpoch)+3E3);
    [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(EKG.LFP,SafeEpoch,Options,1);
    EKG.HBTimes=ts(Times);
    EKG.HBShape=Template;
    EKG.DetectionOptions=Options;
    EKG.HBRate=HeartRate;
    EKG.GoodEpoch=GoodEpoch;
    save('HeartBeatInfo.mat','EKG')
    saveas(gcf,'EKGCheck.fig'),              
    saveFigure(gcf,'EKGCheck', dirin{1});
    
    
end