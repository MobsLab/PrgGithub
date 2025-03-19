clear all , close all
FolderLocation_778 = '/media/nas4/ProjetMTZL/Mouse778/24102018/';
FolderLocation_751 = '/media/nas4/ProjetMTZL/Mouse751/22102018/M751_SleepPlethysmo_181022_090703/';

% 778 is referece
load([FolderLocation_778 'SleepScoring_OBGamma.mat'],'REMEpoch' )
load([FolderLocation_778 'ChannelsToAnalyse/Respi.mat'])
load([FolderLocation_778 'LFPData/LFP',num2str(channel),'.mat'])
Respi=FilterLFP(LFP,[0.01 40],1024);
load([FolderLocation_778 'HeartBeatInfo.mat'])
BreathInfo = load([FolderLocation_778 'BreathingInfo_ZeroCross.mat'])


% 751 breathing to check
load([FolderLocation_751 'ChannelsToAnalyse/Respi.mat'])
load([FolderLocation_751 'LFPData/LFP',num2str(channel),'.mat'])
Respi_Other=FilterLFP(LFP,[0.01 40],1024);
load([FolderLocation_751 'SleepScoring_OBGamma.mat'],'TotalNoiseEpoch')
REMEpoch = REMEpoch - TotalNoiseEpoch;

BreathInfo_Other = load([FolderLocation_751 'BreathingInfo_ZeroCross.mat'])


figure
[M,T] = PlotRipRaw(Respi,Range(Restrict(EKG.HBTimes,subset(REMEpoch,12)),'s'),1000,0,0);
plot(M(:,1),M(:,2))
hold on
[M,T] = PlotRipRaw(Respi_Other,Range(Restrict(EKG.HBTimes,subset(REMEpoch,12)),'s'),1000,0,0);
plot(M(:,1),M(:,2))

figure
for k = 1:length(Start(REMEpoch))
    try
    subplot(1,2,1)
    [H,HS,Ph,ModTheta]=RayleighFreq(Restrict(Respi,subset(REMEpoch,k)),Restrict(EKG.HBTimes,subset(REMEpoch,k)),0.05,30,1024);
    title('Real data')
    CX = caxis;
    
    subplot(1,2,2)
    
    [H,HS,Ph,ModTheta]=RayleighFreq(Restrict(Respi_Other,subset(REMEpoch,k)),Restrict(EKG.HBTimes,subset(REMEpoch,k)),0.05,30,1024);
    title('Swopped data')
    caxis(CX)
    pause
    clf
    end
end

breath=BreathInfo_Other.Troughtsd;
HeartRate = EKG.HBTimes;

[C3p,B]=CrossCorr(Range(Restrict(breath,REMEpoch)),Range(Restrict(breath,REMEpoch)),5,600);
[C2p,B]=CrossCorr(Range(Restrict(breath,SWSEpoch)),Range(Restrict(breath,SWSEpoch)),5,600);
[C1p,B]=CrossCorr(Range(Restrict(breath,Wake)),Range(Restrict(breath,Wake)),5,600);

[C3h,B]=CrossCorr(Range(Restrict(HeartRate,REMEpoch)),Range(Restrict(HeartRate,REMEpoch)),5,600);
[C2h,B]=CrossCorr(Range(Restrict(HeartRate,SWSEpoch)),Range(Restrict(HeartRate,SWSEpoch)),5,600);
[C1h,B]=CrossCorr(Range(Restrict(HeartRate,Wake)),Range(Restrict(HeartRate,Wake)),5,600);

[C3,B]=CrossCorr(Range(Restrict(breath,REMEpoch)),Range(Restrict(HeartRate,REMEpoch)),5,600);
[C2,B]=CrossCorr(Range(Restrict(breath,SWSEpoch)),Range(Restrict(HeartRate,SWSEpoch)),5,600);
[C1,B]=CrossCorr(Range(Restrict(breath,Wake)),Range(Restrict(HeartRate,Wake)),5,600);

ru=4;

figure,
subplot(311), hold on
plot(B/1E3,runmean(C1,ru),'k'), line([0 0],ylim,'color','k','linestyle','--')
plot(B/1E3,runmean(C2,ru),'b'), line([0 0],ylim,'color','k','linestyle','--')
plot(B/1E3,runmean(C3,ru),'r'), line([0 0],ylim,'color','k','linestyle','--')
subplot(312), hold on
plot(B/1E3,runmean(C1h,ru),'k'), line([0 0],ylim,'color','k','linestyle','--')
plot(B/1E3,runmean(C2h,ru),'b'), line([0 0],ylim,'color','k','linestyle','--')
plot(B/1E3,runmean(C3h,ru),'r'), line([0 0],ylim,'color','k','linestyle','--')
subplot(313), hold on
plot(B/1E3,runmean(C1p,ru),'k'), line([0 0],ylim,'color','k','linestyle','--')
plot(B/1E3,runmean(C2p,ru),'b'), line([0 0],ylim,'color','k','linestyle','--')
plot(B/1E3,runmean(C3p,ru),'r'), line([0 0],ylim,'color','k','linestyle','--')


