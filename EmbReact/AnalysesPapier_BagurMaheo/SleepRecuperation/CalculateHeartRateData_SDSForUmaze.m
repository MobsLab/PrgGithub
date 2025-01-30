clear all
%% input dir
%%1
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1414,1439,1440,1416,1437]);

%%2
DirSocialDefeat_totSleepPost_BM_cno1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_CNOInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_BM = MergePathForExperiment(DirSocialDefeat_totSleepPost_BM_cno1,DirSocialDefeat_BM_saline1);
close all

for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    
    % Heart beat detection
    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.05;
    
    if exist('ChannelsToAnalyse/EKG.mat')>0 
            disp(Dir_ctrl.path{i}{1});

        clear TTLInfo Behav EKG channel
        load('ChannelsToAnalyse/EKG.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch')
        load('ExpeInfo.mat')
        if not(exist('HeartBeatInfo.mat'))>0
            
            [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,TotalNoiseEpoch,Options,1);
            EKG.HBTimes=ts(Times);
            EKG.HBShape=Template;
            EKG.DetectionOptions=Options;
            EKG.HBRate=HeartRate;
            EKG.GoodEpoch=GoodEpoch;
            
            save('HeartBeatInfo.mat','EKG')
            saveas(1,'EKGCheck.fig'),
            saveas(1,'EKGCheck.png')
            close all
            clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
        end
    end
end

for i=1:length(DirSocialDefeat_BM.path)
    cd(DirSocialDefeat_BM.path{i}{1});
    
    % Heart beat detection
    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.05;
    
    if exist('ChannelsToAnalyse/EKG.mat')>0 
            disp(DirSocialDefeat_BM.path{i}{1});

        
        clear TTLInfo Behav EKG channel
        load('ChannelsToAnalyse/EKG.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch')
        load('ExpeInfo.mat')
        if not(exist('HeartBeatInfo.mat'))>0
            
            [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,TotalNoiseEpoch,Options,1);
            EKG.HBTimes=ts(Times);
            EKG.HBShape=Template;
            EKG.DetectionOptions=Options;
            EKG.HBRate=HeartRate;
            EKG.GoodEpoch=GoodEpoch;
            
            save('HeartBeatInfo.mat','EKG')
            saveas(1,'EKGCheck.fig'),
            saveas(1,'EKGCheck.png')
            close all
            clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
        end
    end
end