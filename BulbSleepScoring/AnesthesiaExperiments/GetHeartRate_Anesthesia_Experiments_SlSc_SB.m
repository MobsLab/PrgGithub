clear all, close all
%% Average spectra for all three states + levels of anesthesia

ExperimentNames{1} = 'Isoflurane_WakeUp';
ExperimentNames{2} = 'Isoflurane_08';
ExperimentNames{3} = 'Isoflurane_10';
ExperimentNames{4} = 'Isoflurane_12';
ExperimentNames{5} = 'Isoflurane_15';
ExperimentNames{6} = 'Isoflurane_18';
ExperimentNames{7} = 'Ketamine';
ExperimentNames{8} = 'Sleep_Pre_Ketamine';


for exp = 1:length(ExperimentNames)
    Dir = PathForExperimentsAnesthesia(ExperimentNames{exp});
    
    for k = 1 : length(Dir.path)
        for kk = 1:length(Dir.path{k})
            
            cd(Dir.path{k}{kk})
            
            if exist('ChannelsToAnalyse/EKG.mat')>0 & exist('StateEpochSB.mat')>0
                clear Behav EKG channel StimEpoch
                Options.TemplateThreshStd=3;
                Options.BeatThreshStd=0.5;
                load('ChannelsToAnalyse/EKG.mat')
                load('behavResources.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                load('StateEpochSB.mat','TotalNoiseEpoch')
                NoiseEpoch=TotalNoiseEpoch;
                
                try,  StimEpoch;
                    NoiseEpoch=or(TotalNoiseEpoch,intervalSet(Start(StimEpoch),Start(StimEpoch)+2*1e4));
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
    end
end