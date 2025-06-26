
clear all

cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20250103_LSP_saline')
% cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long/')
% cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long/')

%%
smootime = 10;
load('SleepScoring_OBGamma.mat', 'Wake', 'REMEpoch', 'SWSEpoch', 'Sleep', 'Info')

load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = tsd(Range(LFP) , Data(LFP));
Fil_Delta = FilterLFP(Restrict(LFP , Sleep),[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDelta_OB  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

figure
gamma_thresh = GetGaussianThresh_BM(log10(Data(Restrict(SmoothDelta_OB , SWSEpoch))), 0, 1);
makepretty


N2 = thresholdIntervals(SmoothDelta_OB , 10^gamma_thresh , 'Direction' , 'Above');
N2 = mergeCloseIntervals(N2,5e4);
N2 = dropShortIntervals(N2,10e4);
N1 = SWSEpoch-N2;


load('DeltaWaves_Bulb.mat', 'deltas_Bulb')


load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M1,~] = PlotRipRaw(LFP, Start(and(deltas_Bulb , REMEpoch))/1e4 , 500, 1, 0, 0);
[M3,~] = PlotRipRaw(LFP, Start(and(deltas_Bulb , N1))/1e4 , 500, 1, 0, 0);
[M5,~] = PlotRipRaw(LFP, Start(and(deltas_Bulb , N2))/1e4 , 500, 1, 0, 0);

load('ChannelsToAnalyse/Bulb_sup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M2,~] = PlotRipRaw(LFP, Start(and(deltas_Bulb , REMEpoch))/1e4 , 500, 1, 0, 0);
[M4,~] = PlotRipRaw(LFP, Start(and(deltas_Bulb , N1))/1e4 , 500, 1, 0, 0);
[M6,~] = PlotRipRaw(LFP, Start(and(deltas_Bulb , N2))/1e4 , 500, 1, 0, 0);


% figures
figure
bar([length(Start(and(deltas_Bulb , REMEpoch)))./(sum(DurationEpoch(REMEpoch))./1e4)...
    length(Start(and(deltas_Bulb , N1)))./(sum(DurationEpoch(N1))./1e4)...
    length(Start(and(deltas_Bulb , N2)))./(sum(DurationEpoch(N2))./1e4)])
xticklabels({'REM','IS','NREM'}), xtickangle(45)
ylabel('Delta occurence (#/s)')
makepretty


figure
% subplot(131)
% shadedErrorBar(M1(:,1), runmean(M1(:,2),5) , runmean(M1(:,4),5) ,'-b',1);
% hold on
% shadedErrorBar(M1(:,1), runmean(M2(:,2),5)-5e2 , runmean(M2(:,4),5) ,'-r',1);
% f=get(gca,'Children'); legend([f(3),f(1)],'OB sup','OB deep');
% xlabel('time (ms)'), ylabel('amplitude (a.u.)'), title('REM'), ylim([-1.2e3 1.5e3])
% makepretty
% vline(0,'--k')

% subplot(121)
% shadedErrorBar(M1(:,1), runmean(M3(:,2),5) , runmean(M3(:,4),5) ,'-b',1);
% hold on
% shadedErrorBar(M1(:,1), runmean(M4(:,2),5)-5e2 , runmean(M4(:,4),5) ,'-r',1);
% xlabel('time (ms)'), title('IS'), ylim([-1.2e3 1.5e3])
% makepretty
% vline(0,'--k')
% 
% subplot(133)
shadedErrorBar(M1(:,1), runmean(M5(:,2),5) , runmean(M5(:,4),5) ,'-b',1);
hold on
shadedErrorBar(M1(:,1), runmean(M6(:,2),5)-5e2 , runmean(M6(:,4),5) ,'-r',1);
xlabel('Time (ms)'), ylabel('Amplitude (a.u.)'), ylim([-1.2e3 1.5e3])
makepretty
vline(0,'--k')


%% co-occurence with Deltas PFC
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20250103_LSP_saline')
load('SleepScoring_OBGamma.mat', 'SWSEpoch', 'REMEpoch')

% on PFC delta
load('DeltaWaves_PFCx.mat', 'deltas_PFCx')

load('ChannelsToAnalyse/PFCx_deltadeep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M1,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close

load('ChannelsToAnalyse/PFCx_deltasup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M2,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close



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
[M3,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close

load('ChannelsToAnalyse/Bulb_sup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M4,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close


subplot(222)
plot(M1(:,1) , runmean(M3(:,2),5))
hold on
plot(M1(:,1) , runmean(M4(:,2),5)-200)
legend('OB deep','OB sup')
vline(0,'--k'), text(0,400,'PFC delta','FontSize',15), ylim([-1e3 1.5e3])
makepretty



% on OB delta
load('DeltaWaves_Bulb.mat', 'deltas_Bulb')

load('ChannelsToAnalyse/PFCx_deltadeep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M5,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close

load('ChannelsToAnalyse/PFCx_deltasup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M6,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close


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
[M7,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close

load('ChannelsToAnalyse/Bulb_sup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
[M8,~] = PlotRipRaw(LFP, Start(and(deltas_PFCx , SWSEpoch))/1e4 , 500, 1, 1, 1);
close

subplot(224)
plot(M1(:,1) , runmean(M7(:,2),5))
hold on
plot(M1(:,1) , runmean(M8(:,2),5)-500)
legend('OB deep','OB sup')
xlabel('time (ms)')
vline(0,'--k'), text(0,400,'OB delta','FontSize',15), ylim([-1e3 1.5e3])
makepretty

% do with random times



%% cross-corr
% Get event times in seconds
ts1 = Start(and(deltas_Bulb, N2)) / 1e4;
ts2 = Start(and(deltas_PFCx, N2)) / 1e4;

% Set parameters
binSize = 0.1; % seconds
win = 10;      % seconds

% Create histogram edges
edges = -win:binSize:win;

% Initialize cross-correlogram
ccg_counts = zeros(size(edges)-[0 1]);

% Compute cross-correlogram manually
for i = 1:length(ts1)
    diffs = ts2 - ts1(i);
    diffs = diffs(abs(diffs) <= win); % keep only within the window
    ccg_counts = ccg_counts + histcounts(diffs, edges);
end

% Plot the result
binCenters = edges(1:end-1) + binSize/2;
figure;
bar(binCenters, ccg_counts, 1 , 'FaceColor' , 'k' , 'FaceAlpha' , .7);
xlabel('Time lag (s)');
ylabel('Count'); ylim([0 700])
title('Cross-correlogram: PFCx relative to Bulb events');
xlim([-4, 4]); xticks([-4:2:4])




