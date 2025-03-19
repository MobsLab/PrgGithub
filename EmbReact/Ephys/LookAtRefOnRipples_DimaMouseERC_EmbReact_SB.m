k=0;
load('Ripples.mat')
Ripples_ts = ts(ripples(:,2)*1e4);

load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018/FindSleep/ChannelsToAnalyse/dHPC_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
k=k+1;[M{k},T{k}] = PlotRipRaw(LFP,Range((Ripples_ts),'s'),1000,0,0);

load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018/FindSleep/ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
k=k+1;[M{k},T{k}] = PlotRipRaw(LFP,Range((Ripples_ts),'s'),1000,0,0);

load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018/FindSleep/ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
k=k+1;[M{k},T{k}] = PlotRipRaw(LFP,Range((Ripples_ts),'s'),1000,0,0);

load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018/FindSleep/ChannelsToAnalyse/Bulb_sup.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
k=k+1;[M{k},T{k}] = PlotRipRaw(LFP,Range((Ripples_ts),'s'),1000,0,0);

load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-714/20022018/FindSleep/ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
k=k+1;[M{k},T{k}] = PlotRipRaw(LFP,Range((Ripples_ts),'s'),1000,0,0);

channel = 22;
load(['LFPData/LFP',num2str(channel),'.mat'])
k=k+1;[M{k},T{k}] = PlotRipRaw(LFP,Range((Ripples_ts),'s'),1000,0,0);

clf
subplot(211)
for i = 1:k
    plot(M{i}(:,1),(runmean((M{i}(:,2)),20)),'linewidth',2), hold on
end
legend('HPCDeep','HPCrip','BulbDeep','BulbSup','EKG','ref')
subplot(212)
for i = 1:k
    plot(M{i}(:,1),zscore(runmean((M{i}(:,2)),20)),'linewidth',2), hold on
end
legend('HPCDeep','HPCrip','BulbDeep','BulbSup','EKG','ref')
