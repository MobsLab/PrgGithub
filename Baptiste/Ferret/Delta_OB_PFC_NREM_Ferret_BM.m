




load('SleepScoring_OBGamma.mat', 'SWSEpoch', 'REMEpoch')

% on PFC delta
load('DeltaWaves_PFC.mat', 'deltas_PFCx')

load('ChannelsToAnalyse/PFCx_deltadeep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M1,T1] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);

load('ChannelsToAnalyse/PFCx_deltasup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M2,T2] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);



figure
subplot(221)
plot(M1(:,1) , runmean(M1(:,2),5))
hold on
plot(M1(:,1) , runmean(M2(:,2),5)-500)
legend('PFC deep','PFC sup')
ylabel('amplitude (a.u.)')
vline(0,'--k'), text(0,1500,'PFC delta','FontSize',15)
makepretty



load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M3,T1] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);

load('ChannelsToAnalyse/Bulb_sup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M4,T2] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);


subplot(222)
plot(M1(:,1) , runmean(M3(:,2),5))
hold on
plot(M1(:,1) , runmean(M4(:,2),5)-200)
legend('OB deep','OB sup')
vline(0,'--k'), text(0,400,'PFC delta','FontSize',15), ylim([-1e3 1.5e3])
makepretty



% on OB delta
load('DeltaWaves_OB.mat', 'deltas_PFCx')

load('ChannelsToAnalyse/PFCx_deltadeep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M5,T1] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);

load('ChannelsToAnalyse/PFCx_deltasup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M6,T2] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);


subplot(223)
plot(M1(:,1) , runmean(M5(:,2),5))
hold on
plot(M1(:,1) , runmean(M6(:,2),5)-200)
legend('PFC deep','PFC sup')
xlabel('time (ms)'), ylabel('amplitude (a.u.)'), ylim([-1e3 1.5e3])
vline(0,'--k'), text(0,1500,'OB delta','FontSize',15)
makepretty


load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M7,T1] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);

load('ChannelsToAnalyse/Bulb_sup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M8,T2] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);


subplot(224)
plot(M1(:,1) , runmean(M7(:,2),5))
hold on
plot(M1(:,1) , runmean(M8(:,2),5)-500)
legend('OB deep','OB sup')
xlabel('time (ms)')
vline(0,'--k'), text(0,400,'OB delta','FontSize',15), ylim([-1e3 1.5e3])
makepretty




















