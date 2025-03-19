% EMG on freezing
clear all,
m=0;
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SoundTest/';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC/';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SoundTest/';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SoundTest/';

smootime=3;
for mm=1:m
    cd(Filename{mm})
    clear smooth_ghi EMGData FreezeEpoch
    load('ChannelsToAnalyse/EMG.mat'); chE=channel;
    load('ChannelsToAnalyse/Bulb_deep.mat'); chB=channel;
    
    % load smooth_ghi
    try
        load('StateEpochSB.mat')
        smooth_ghi
    catch
        load(['LFPData/LFP',num2str(chB),'.mat'])
        FilGamma=FilterLFP(LFP,[50 70],1024);
        HilGamma=hilbert(Data(FilGamma));
        H=abs(HilGamma);
        tot_ghi=tsd(Range(LFP),H);
        smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
        try,save('StateEpochSB.mat','smooth_ghi','-append'),
        catch,save('StateEpochSB.mat','smooth_ghi') ,end
    end
    
    % load EMGData
    try
        load('StateEpochSBEMG.mat')
        EMGData
    catch
        load(['LFPData/LFP',num2str(chE),'.mat'])
        FilLFP=FilterLFP(LFP,[50 300],1024);
        EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
        EMGData=Restrict(EMGData,intervalSet(0,750*1e4));
        try,save('StateEpochSBEMG.mat','EMGData','-append'),
        catch,save('StateEpochSBEMG.mat','EMGData') ,end
    end
    
    
    % load Movtsd and FreezeEpoch
    load('behavResources.mat')
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,5*1e4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
    Times=round(Start(FreezeEpoch)/1000)/10;
    
    [M,T]=PlotRipRaw(EMGData,Times,5000);close;
    EMGTriggeredFr(mm,:)=M(:,2)';
    
    [M,T]=PlotRipRaw(smooth_ghi,Times,5000);close;
    GammaTriggeredFr(mm,:)=M(:,2)';
end


% EMG on sleep
clear all
m=0;
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M258/20151112/';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjectEmbReact/Mouse439/20160820/ProjectEmbReact_M439_20160820_SleepPost/';
m=m+1;Filename{m}='/media/DataMOBSSlSc/SleepScoringMice/M259/20151112/';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjectEmbReact/Mouse437/20160812/ProjectEmbReact_M437_20160812_SleepPre/';
m=m+1;Filename{m}='/media/DataMOBsRAID/ProjectEmbReact/Mouse436/20160811/ProjectEmbReact_M436_20160811_SleepPre/';

smootime=3;
for mm=1:m
    cd(Filename{mm})
    clear smooth_ghi EMGData FreezeEpoch
    load('ChannelsToAnalyse/EMG.mat'); chE=channel;
    load('ChannelsToAnalyse/Bulb_deep.mat'); chB=channel;
    
    % load smooth_ghi
    try
        load('StateEpochSB.mat')
        smooth_ghi;
    catch
        load(['LFPData/LFP',num2str(chB),'.mat'])
        FilGamma=FilterLFP(LFP,[50 70],1024);
        HilGamma=hilbert(Data(FilGamma));
        H=abs(HilGamma);
        tot_ghi=tsd(Range(LFP),H);
        smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
        try,save('StateEpochSB.mat','smooth_ghi','-append'),
        catch,save('StateEpochSB.mat','smooth_ghi') ,end
    end
    
    % load EMGData
    try
        load('StateEpochSBEMG.mat')
        EMGData;
    catch
        load(['LFPData/LFP',num2str(chE),'.mat'])
        FilLFP=FilterLFP(LFP,[50 300],1024);
        EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
        try,save('StateEpochSBEMG.mat','EMGData','-append'),
        catch,save('StateEpochSBEMG.mat','EMGData') ,end
    end
    
    % load Movtsd and FreezeEpoch
    load('StateEpochSB.mat','wakeper','SWSEpoch')
    wakeper=dropShortIntervals(wakeper,5*1e4);
    SWSEpoch=dropShortIntervals(SWSEpoch,5*1e4);
    [aft_cell,bef_cell]=transEpoch(wakeper,SWSEpoch);
    
    Times=round(Start(bef_cell{2,1})/1000)/10;
    Times=Times(1:min([length(Times),100])); Times(2:end-1);
    [M,T]=PlotRipRaw(EMGData,Times,5000);close;
    EMGTriggeredSl(mm,:)=M(:,2)';
    
    [M,T]=PlotRipRaw(smooth_ghi,Times,5000);close;
    GammaTriggeredSl(mm,:)=M(:,2)';
end
plot(zscore(EMGTriggeredSl'),'k')
cd /media/DataMOBSSlSc/SleepScoringMice/FreezingEMG
save('TriggeredEMGGammaSleep.mat','EMGTriggeredSl','GammaTriggeredSl')


%%%
clear all
load('TriggeredEMGGammaFreeze.mat')
load('TriggeredEMGGammaSleep.mat')
m=size(GammaTriggeredSl,1);
SlWk=[];
for mm=1:m
    SlWk(mm,:)=(GammaTriggeredSl(mm,:)-mean(GammaTriggeredSl(mm,:)));%./mean(GammaTriggeredSl(mm,:));
end


FrNoFr=[];
for mm=1:m
    FrNoFr(mm,:)=(GammaTriggeredFr(mm,:)-mean(GammaTriggeredFr(mm,:)));%./mean(GammaTriggeredFr(mm,:));
end

figure
g=shadedErrorBar(time,mean(SlWk),[stdError(SlWk);stdError(SlWk)],'b')
hold on
g=shadedErrorBar(time,mean(FrNoFr),[stdError(FrNoFr);stdError(FrNoFr)])
% ylim([-120 120])
line([0 0],ylim,'color','k','linestyle','--','linewidth',3)


SlWk=[];
for mm=1:m
    SlWk(mm,:)=(EMGTriggeredSl(mm,:)-mean(EMGTriggeredSl(mm,:)));%./mean(EMGTriggeredSl(mm,:));
end


FrNoFr=[];
for mm=1:m
    FrNoFr(mm,:)=(EMGTriggeredFr(mm,:)-mean(EMGTriggeredFr(mm,:)));%./mean(EMGTriggeredFr(mm,:));
end

figure
g=shadedErrorBar(time,mean(SlWk),[stdError(SlWk);stdError(SlWk)],'b')
hold on
g=shadedErrorBar(time,mean(FrNoFr),[stdError(FrNoFr);stdError(FrNoFr)])
% ylim([-0.8e5 0.8e5])
line([0 0],ylim,'color','k','linestyle','--','linewidth',3)
line(xlim,[0 0],'color','k','linestyle','--','linewidth',1)

