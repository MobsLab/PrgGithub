


clear all

GetSleepSessions_Drugs_BM

% take 2 hours of sleep before injection and 1 hour after
Mouse_names = {'M1207','M1224','M1225','M1226','M1227'};
Drug_Group= {'Saline','DZP','BUS'};

for drug = 1
    for mouse = 3:length(Mouse_names)
        
        cd(SleepInfo.path{drug,mouse})
        
        clear Options
        close all
        clear TTLInfo Behav EKG channel
        Options.TemplateThreshStd=3;
        Options.BeatThreshStd=0.5;
        load('ChannelsToAnalyse/EKG.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch')
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
        close all
        clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
    end
end











clear all

GetSleepSessions_Drugs_BM

% take 2 hours of sleep before injection and 1 hour after
Mouse_names = {'M1207','M1224','M1225','M1226','M1227'};
Drug_Group= {'Saline','DZP','BUS'};

for drug = 3
    for mouse = 3:length(Mouse_names)
        
        cd(SleepInfo.path{drug,mouse})
        
        %% Sleep event
        disp('getting sleep signals')
        if mouse==1; CreateSleepSignals('recompute',1,'rip',0);
        else CreateSleepSignals('recompute',1);
        end
        
        %% Substages
        disp('getting sleep stages')
        [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures;
        save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch')
        [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
        save('SleepSubstages', 'Epoch', 'NameEpoch')
        
        %% Id figure 1
        close all
        disp('making ID fig1')
        MakeIDSleepData
        PlotIDSleepData
        saveas(1,'IDFig1.png')
        close all
        
        %% Id figure 2
        disp('making ID fig2')
        MakeIDSleepData2
        PlotIDSleepData2
        saveas(1,'IDFig2.png')
        close all
        
        
        
    end
end
    
    
    
    
    
    
    
    CreateSleepSignals('recompute',1,'rip',1,'delta',0,'spindle',0);
    
    
    
    
    
    
