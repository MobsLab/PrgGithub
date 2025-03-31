% Dat2Mat_DB - Converting preprocessed files to matlab format
% 30.01.2019 DB

function Dat2Mat_DB(dirin)

%% Parameters
try
   dirin;
catch
   dirin={
%         '/media/mobsrick/DataMOBS82/Mouse-742/31052018/_Concatenated/';
%         '/media/mobsrick/DataMOBS82/Mouse-712/12042018/_Concatenated/';
        '/media/mobsrick/DataMOBS82/Mouse-711/17032018/_Concatenated/';
        '/media/mobsrick/DataMOBs71/Mouse-714/27022018_Mouse-714-UMaze-Day3/_Concatenated/'
       };
end

%%% Do you have stimulations during sleep?
sleepstimulated = 0;

%% Run
for i=1:length(dirin)
    Dir=dirin{i};
    
    cd(Dir);
    load('ExpeInfo.mat');
    flnme = ['M' num2str(ExpeInfo.nmouse) '_' num2str(ExpeInfo.date) '_' ExpeInfo.SessionType];

    %% Make data

    %Set Session
    SetCurrentSession([flnme '.xml']);
    
%     Get Stimulations if you have any
        GetStims_DB
    
%     make Spike Data
    if ExpeInfo.PreProcessingInfo.DoSpikes
        MakeData_Spikes('mua', 1);
    end
    
    %% Sleep scoring
    
    if sleepstimulated
        StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-3E2, Start(TTLInfo.StimEpoch)+3E3);
        SleepScoring_Accelero_OBgamma('PlotFigure',1, 'smoothwindow', 1.2, 'StimEpoch', StimEpoch);
    else
        SleepScoring_Accelero_OBgamma('PlotFigure',1);
    end
    
    %% Others
    % Make Heart Beat data
    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.5;
    load ([Dir '/ChannelsToAnalyse/EKG.mat'])
    EKG = load(['LFPData/LFP',num2str(channel),'.mat']);
    load('ExpeInfo.mat')
    load('behavResources.mat');
    load('SleepScoring_OBGamma.mat', 'TotalNoiseEpoch');
%     StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-10, Start(TTLInfo.StimEpoch)+25E2);
%     BadEpoch = StimEpoch;
%     BadEpoch = or(TotalNoiseEpoch, StimEpoch);
    BadEpoch = intervalSet(0,0);
    [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(EKG.LFP,BadEpoch,Options,1);
    EKG.HBTimes=ts(Times);
    EKG.HBShape=Template;
    EKG.DetectionOptions=Options;
    EKG.HBRate=HeartRate;
    EKG.GoodEpoch=GoodEpoch;
    save('HeartBeatInfo.mat','EKG')
    saveas(gcf,'EKGCheck.fig'),              
    saveFigure(gcf,'EKGCheck', Dir);
    
    %% Detect ripples events
    if exist('ChannelsToAnalyse/dHPC_rip.mat')==2
        rip_chan = load('ChannelsToAnalyse/dHPC_rip.mat');
        nonrip_chan = load('ChannelsToAnalyse/nonHPC.mat');
        [ripples,stdev] = FindRipples_DB (rip_chan.channel, nonrip_chan.channel, [2 5],'rmvnoise',1, 'clean',1);
%         [ripples,stdev] = FindRipples_DB (rip_chan.channel, 22, [2 7],'rmvnoise',1, 'clean',1);
    end

end
end