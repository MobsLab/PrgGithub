clear Options
close all
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    
    for d=1:length(Dir.path)
        d
        for dd=1:length(Dir.path{d})
            clear channel
            cd(Dir.path{d}{dd})
            if (Dir.ExpeInfo{d}{dd}.nmouse==MouseToDo)
                channel = 18;
                save('ChannelsToAnalyse/EKG.mat','channel')

                if exist('ChannelsToAnalyse/EKG.mat')>0 & exist('StateEpochSB.mat')>0 & exist('HeartBeatInfo.mat')==0
                    
                    clear TTLInfo Behav EKG channel
                    disp(Dir.path{d}{dd})
                    Options.TemplateThreshStd=3;
                    Options.BeatThreshStd=0.5;
                    load('ChannelsToAnalyse/EKG.mat')
                    load(['LFPData/LFP',num2str(channel),'.mat'])
                    load('StateEpochSB.mat','TotalNoiseEpoch')
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
        end
        end
    end