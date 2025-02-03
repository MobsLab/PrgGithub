clear all
close all
GetAllSalineSessions_BM;
Mouse = 668;
%
AllMiceStr = fieldnames(CondSess);
AllMice = cell2mat(cellfun(@(x) eval(x(2:end)),AllMiceStr,'UniformOutput',false));

mm = find(AllMice==Mouse);
%% Shock example
%% Shock example
ff=5
cd(CondSess.(AllMiceStr{mm}){ff})


load('B_Low_Spectrum.mat')
load('HeartBeatInfo.mat')
load('behavResources_SB.mat')
load('InstFreqAndPhase_B.mat')

SfZone = or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{4});
SkZone = or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{3});
Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));


figure(6)
clf
% accelero
subplot(511)
plot(Range(Behav.MovAcctsd,'s'),runmean(Data(Behav.MovAcctsd),10))
hold on
xlim([200 300])

% position
subplot(512)
plot(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist))
ylim([0 1])
xlim([200 300])
% breathing
subplot(513)
imagesc(Spectro{2},Spectro{3},smooth2a(log(Spectro{1})',2,2)), axis xy
hold on
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
caxis([10.5 14])
line(xlim,[4 4])
colormap parula
ylim([1 15])
xlim([200 300])
subplot(514)
dat = Data(LocalFreq.WV);
dat(dat>11) = NaN;
dat = naninterp(dat);
hold on
plot(Range(LocalFreq.WV,'s'),movmean(dat,50))
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
xlim([200 300])
ylim([0 12])

% cardiac
subplot(515)
plot(Range(EKG.HBRate,'s'),movmean(Data(EKG.HBRate),2))
hold on
ylim([8 15])
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
xlim([200 300])

figure
imagesc(Spectro{2},Spectro{3},smooth2a(log(Spectro{1})',2,2)), axis xy
hold on
caxis([10.5 14])
colormap parula
ylim([1 15])
set(gca,'XTick',[],'YTick',[])
xlim([200 300])

figure
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPOB = LFP;
LFPRespi = FilterLFP(LFP,[0.5 20],1024)
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPHR = LFP;

plotEp = intervalSet(200*1e4,300*1e4);
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPOB,plotEp))))
hold on
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPRespi,plotEp)))+5)
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPHR,plotEp)))+10)

%% SAFE EXAMPLE
ff=8
cd(CondSess.(AllMiceStr{mm}){ff})


load('B_Low_Spectrum.mat')
load('HeartBeatInfo.mat')
load('behavResources_SB.mat')
load('InstFreqAndPhase_B.mat')

SfZone = or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{4});
SkZone = or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{3});
Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));

figure(5)
clf
% accelero
subplot(511)
plot(Range(Behav.MovAcctsd,'s'),(Data(Behav.MovAcctsd)))
hold on
xlim([195 295])

% position
subplot(512)
plot(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist))
ylim([0 1])
xlim([195 295])
% breathing
subplot(513)
imagesc(Spectro{2},Spectro{3},smooth2a(log(Spectro{1})',2,2)), axis xy
hold on
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
caxis([10.5 14])
line(xlim,[4 4])
colormap parula
ylim([1 15])
xlim([195 295])
% breathing
subplot(514)
dat = Data(LocalFreq.WV);
dat(dat>11) = NaN;
dat = naninterp(dat);
plot(Range(LocalFreq.WV,'s'),movmean(dat,50))
hold on
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
xlim([195 295])
ylim([0 12])

% cardiac
subplot(515)
plot(Range(EKG.HBRate,'s'),movmean(Data(EKG.HBRate),2))
hold on
ylim([8 15])
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
xlim([195 295])

figure
imagesc(Spectro{2},Spectro{3},smooth2a(log(Spectro{1})',2,2)), axis xy
hold on
caxis([10.5 14])
colormap parula
ylim([1 15])
set(gca,'XTick',[],'YTick',[])
xlim([195 295])

figure
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPOB = LFP;
LFPRespi = FilterLFP(LFP,[0.5 20],1024)
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPHR = LFP;

plotEp = intervalSet(195*1e4,295*1e4);
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPOB,plotEp))))
hold on
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPRespi,plotEp)))+5)
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPHR,plotEp)))+10)




%% Other possible mouse
clear all
close all
GetAllSalineSessions_BM;
Mouse = 667;
%
AllMiceStr = fieldnames(CondSess);
AllMice = cell2mat(cellfun(@(x) eval(x(2:end)),AllMiceStr,'UniformOutput',false));

mm = find(AllMice==Mouse);
%% Shock example
%% Shock example
ff=6
cd(CondSess.(AllMiceStr{mm}){ff})


load('B_Low_Spectrum.mat')
load('HeartBeatInfo.mat')
load('behavResources_SB.mat')
load('InstFreqAndPhase_B.mat')

SfZone = or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{4});
SkZone = or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{3});
Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));


figure(6)
clf
% accelero
subplot(511)
plot(Range(Behav.MovAcctsd,'s'),runmean(Data(Behav.MovAcctsd),10))
hold on
xlim([200 470])

% position
subplot(512)
plot(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist))
ylim([0 1])
xlim([200 470])
% breathing
subplot(513)
imagesc(Spectro{2},Spectro{3},smooth2a(log(Spectro{1})',2,2)), axis xy
hold on
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
caxis([10.5 14])
line(xlim,[4 4])
colormap parula
ylim([1 15])
xlim([200 470])
subplot(514)
dat = Data(LocalFreq.WV);
dat(dat>11) = NaN;
dat = naninterp(dat);
hold on
plot(Range(LocalFreq.WV,'s'),movmean(dat,50))
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
xlim([200 470])
ylim([0 12])

% cardiac
subplot(515)
plot(Range(EKG.HBRate,'s'),movmean(Data(EKG.HBRate),2))
hold on
ylim([8 15])
if not(isempty(Start(TTLInfo.StimEpoch,'s')))
    plot(Start(TTLInfo.StimEpoch,'s'),10,'r*')
end
xlim([200 470])

figure
imagesc(Spectro{2},Spectro{3},smooth2a(log(Spectro{1})',2,2)), axis xy
hold on
caxis([10.5 14])
colormap parula
ylim([1 15])
set(gca,'XTick',[],'YTick',[])
xlim([200 470])

figure
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPOB = LFP;
LFPRespi = FilterLFP(LFP,[0.5 20],1024)
load('ChannelsToAnalyse/EKG.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
LFPHR = LFP;

plotEp = intervalSet(200*1e4,470*1e4);
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPOB,plotEp))))
hold on
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPRespi,plotEp)))+5)
plot(Range(Restrict(LFPOB,plotEp),'s'),zscore(Data(Restrict(LFPHR,plotEp)))+10)



