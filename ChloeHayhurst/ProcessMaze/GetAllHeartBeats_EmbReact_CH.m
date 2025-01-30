clear Options
close all
 load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')

for sess = 1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    
    clear TTLInfo Behav EKG channel
    Options.TemplateThreshStd=3;
    %Options.BeatThreshStd=0.5;
    Options.BeatThreshStd=0.05;
    load('ChannelsToAnalyse/EKG.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    load('StateEpochSB.mat','TotalNoiseEpoch')
    load('ExpeInfo.mat')
    if not(exist('HeartBeatInfo.mat'))>0
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