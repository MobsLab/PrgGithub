%%PlotExampleRealFakeHomeostasis
% 18.09.2019 KJ
%
% Infos
%   Examples homeostasis figures
%
% see
%     FindExampleRealFakeSlow
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
ch_example = 0;

pathexample = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170127/ProjectEmbReact_M509_20170127_BaselineSleep';
ch_example = 33;


freq_delta = [0.5 4];
windowsize_density = 60e4; %60s
minDurationDelta = 75;
rescale = 2;

color_nrem = 'b';
color_rem  = [0 0.5 0];
color_wake = 'k';
color_curve = [0.7 0.7 0.7];
color_S = 'b';
color_peaks = 'r';

color_1fit = 'k';
color_2fit = [1 0.25 0];
color_expfit = [0 0.5 0];

%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%% load

%night duration and tsd zt
load('behavResources.mat', 'NewtsdZT')
load('IdFigureData2.mat', 'night_duration')

%NREM
[NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

[N1, N2, N3, REM, Wake] = GetSubstages;
NREM = or(N1,or(N2,N3));
SleepStages = {REM,NREM,Wake};
colorStages = {color_rem, color_nrem, color_wake};
NameStages = {'REM','NREM','Wake'};
Labels = {'R','NR','W'};
for s=1:length(SleepStages)
    new_st  = Data(Restrict(NewtsdZT, ts(Start(SleepStages{s}))));
    new_end = Data(Restrict(NewtsdZT, ts(End(SleepStages{s}))));    
    SleepStages{s} = intervalSet(new_st,new_end);
end
NREMzt = SleepStages{2}; 


%Deltawaves
load('DeltaWaves.mat', 'deltas_PFCx')
DeltaDiff = deltas_PFCx;

%Down
load('DownState.mat', 'down_PFCx')
GlobalDown = down_PFCx;

%delta waves of channel (single channel detection)
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_example)])
eval(['all_delta_ch = delta_ch_' num2str(ch_example) ';'])
DeltaWavesCh = dropShortIntervals(and(all_delta_ch,NREM), minDurationDelta);

%global delta and other delta 1 - for down > 75ms
[RealDelta, ~, ~,idGlobDelta,~] = GetIntersectionsEpochs(DeltaWavesCh, GlobalDown);
FakeDelta = subset(DeltaWavesCh, setdiff(1:length(Start(DeltaWavesCh)),idGlobDelta)');



%% Homeostasis

%Down
[~, ~, Down.Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Diff
[~, ~, Diff.Hstat] = DensityOccupation_KJ(DeltaDiff, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Good delta
[~, ~, Realdt.Hstat] = DensityOccupation_KJ(RealDelta, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Fake
[~, ~, Fakedt.Hstat] = DensityOccupation_KJ(FakeDelta, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%SWA
[~, ~, Swa.Hstat] = GetSWAchannel(ch_example, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',2);


%% slope & p-value

%down
down.slope.singlefit    = Down.Hstat.p0(1);
down.slope.doublefit(1) = Down.Hstat.p1(1);
down.slope.doublefit(2) = Down.Hstat.p2(1);
down.slope.expfit       = Down.Hstat.exp_b;

down.pv.singlefit    = Down.Hstat.pv0(1);
down.pv.doublefit(1) = Down.Hstat.pv1(1);
down.pv.doublefit(2) = Down.Hstat.pv2(1);
down.pv.expfit       = Down.Hstat.pv_b;

%Diff
diffdt.slope.singlefit    = Diff.Hstat.p0(1);
diffdt.slope.doublefit(1) = Diff.Hstat.p1(1);
diffdt.slope.doublefit(2) = Diff.Hstat.p2(1);
diffdt.slope.expfit       = Diff.Hstat.exp_b;

diffdt.pv.singlefit    = Diff.Hstat.pv0(1);
diffdt.pv.doublefit(1) = Diff.Hstat.pv1(1);
diffdt.pv.doublefit(2) = Diff.Hstat.pv2(1);
diffdt.pv.expfit       = Diff.Hstat.pv_b;

%Good delta
realdt.slope.singlefit    = Realdt.Hstat.p0(1);
realdt.slope.doublefit(1) = Realdt.Hstat.p1(1);
realdt.slope.doublefit(2) = Realdt.Hstat.p2(1);
realdt.slope.expfit       = Realdt.Hstat.exp_b;

realdt.pv.singlefit    = Realdt.Hstat.pv0(1);
realdt.pv.doublefit(1) = Realdt.Hstat.pv1(1);
realdt.pv.doublefit(2) = Realdt.Hstat.pv2(1);
realdt.pv.expfit       = Realdt.Hstat.pv_b;


%Fake delta
fakedt.slope.singlefit    = Fakedt.Hstat.p0(1);
fakedt.slope.doublefit(1) = Fakedt.Hstat.p1(1);
fakedt.slope.doublefit(2) = Fakedt.Hstat.p2(1);
fakedt.slope.expfit       = Fakedt.Hstat.exp_b;

fakedt.pv.singlefit    = Fakedt.Hstat.pv0(1);
fakedt.pv.doublefit(1) = Fakedt.Hstat.pv1(1);
fakedt.pv.doublefit(2) = Fakedt.Hstat.pv2(1);
fakedt.pv.expfit       = Fakedt.Hstat.pv_b;


%SWA
swa.slope.singlefit    = Swa.Hstat.p0(1);
swa.slope.doublefit(1) = Swa.Hstat.p1(1);
swa.slope.doublefit(2) = Swa.Hstat.p2(1);
swa.slope.expfit       = Swa.Hstat.exp_b;

swa.pv.singlefit    = Swa.Hstat.pv0(1);
swa.pv.doublefit(1) = Swa.Hstat.pv1(1);
swa.pv.doublefit(2) = Swa.Hstat.pv2(1);
swa.pv.expfit       = Swa.Hstat.pv_b;


%% interpolate peaks
x_intervals = Down.Hstat.x_intervals;

%down
x_peaks = Down.Hstat.x_peaks;
y_peaks = Down.Hstat.y_peaks;
Sdown.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sdown.y = interp1(x_peaks, y_peaks, Sdown.x, 'pchip'); 

%down
x_peaks = Diff.Hstat.x_peaks;
y_peaks = Diff.Hstat.y_peaks;
Sdiff.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sdiff.y = interp1(x_peaks, y_peaks, Sdiff.x, 'pchip');

%real delta
x_peaks = Realdt.Hstat.x_peaks;
y_peaks = Realdt.Hstat.y_peaks;
Sreal.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sreal.y = interp1(x_peaks, y_peaks, Sreal.x, 'pchip');

%fake
x_peaks = Fakedt.Hstat.x_peaks;
y_peaks = Fakedt.Hstat.y_peaks;
Sfake.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sfake.y = interp1(x_peaks, y_peaks, Sfake.x, 'pchip');

%SWA
x_peaks = Swa.Hstat.x_peaks;
y_peaks = Swa.Hstat.y_peaks;
Sswa.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sswa.y = interp1(x_peaks, y_peaks, Sswa.x);




%% Plot


%% Figure 1 

gap = [0.01 0.1];
X_lim = [min(Start(NREMzt))/3600e4-0.2 max(Data(NewtsdZT))/3600e4]; 
fontsize = 18;

figure, hold on

%%%%%%%%%%
%SWA
%%%%%%%%%%
subplot(10,2,1:2:15), hold on
Homeo = Swa.Hstat;
idx1 = Homeo.x_intervals<=Homeo.limSplit;
idx2 = Homeo.x_intervals>=Homeo.limSplit;

plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',1),
plot(Sswa.x, Sswa.y*100, color_S, 'linewidth',2),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 40,'r','filled')
YL = ylim;

%fit
h(1) = plot(Homeo.x_intervals, Homeo.reg0*100-YL(2)/8,'color',color_1fit,'linewidth',2.5);
h(2) = plot(Homeo.x_intervals(idx1), Homeo.reg1(idx1)*100,'color',color_2fit,'linewidth',2.5);
plot(Homeo.x_intervals(idx2), Homeo.reg2(idx2)*100,'color',color_2fit,'linewidth',2.5);
h(3) = plot(Homeo.x_intervals, Homeo.reg_exp*100+YL(2)/8,'color',color_expfit,'linewidth',2.5);

set(gca, 'xtick',[], 'xlim', X_lim,'ylim',[0 350], 'fontsize',fontsize),ylabel('Slow Wave Activity (%NREM mean)'), title('Slow Wave Activity'),
lgd{1} = ['1 linear fit (slope=' num2str(swa.slope.singlefit,3) ')'];
lgd{2} = ['double fit (slope=' num2str(swa.slope.doublefit(1),3) ')'];
lgd{3} = ['exp fit (slope=' num2str(swa.slope.expfit,3) ')'];
legend(h, lgd)

%hypnogram
subplot(10,2,[17 19]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', NameStages, 'ylim', [0 3], 'xlim', X_lim, 'fontsize',fontsize),
xlabel ('Time (hours)'),


%%%%%%%%%%
%down
%%%%%%%%%%
subplot(10,2,2:2:16), hold on
Homeo = Down.Hstat;
idx1 = Homeo.x_intervals<=Homeo.limSplit;
idx2 = Homeo.x_intervals>=Homeo.limSplit;

plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',1),
plot(Sdown.x, Sdown.y*100, color_S, 'linewidth',2),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 40,'r','filled')
YL = ylim;

%fit
h(1) = plot(Homeo.x_intervals, Homeo.reg0*100-YL(2)/8,'color',color_1fit,'linewidth',2.5);
h(2) = plot(Homeo.x_intervals(idx1), Homeo.reg1(idx1)*100,'color',color_2fit,'linewidth',2.5);
plot(Homeo.x_intervals(idx2), Homeo.reg2(idx2)*100,'color',color_2fit,'linewidth',2.5);
h(3) = plot(Homeo.x_intervals, Homeo.reg_exp*100+YL(2)/8,'color',color_expfit,'linewidth',2.5);

set(gca, 'xtick',[], 'xlim', X_lim,'ylim',[0 350], 'fontsize',fontsize),ylabel('Down occupancy (%epoch)'), title('Down states')
lgd{1} = ['1 linear fit (slope=' num2str(down.slope.singlefit,3) ')'];
lgd{2} = ['double fit (slope=' num2str(down.slope.doublefit(1),3) ')'];
lgd{3} = ['exp fit (slope=' num2str(down.slope.expfit,3) ')'];
legend(h, lgd)


%hypnogram
subplot(10,2,[18 20]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', NameStages, 'ylim', [0 3], 'xlim', X_lim, 'fontsize',fontsize),
xlabel ('Time (hours)'),



%% figure 2

figure, hold on

%%%%%%%%%%
%Delta Diff
%%%%%%%%%%
subplot(10,2,2:2:16), hold on
Homeo = Diff.Hstat;
idx1 = Homeo.x_intervals<=Homeo.limSplit;
idx2 = Homeo.x_intervals>=Homeo.limSplit;

plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',1),
plot(Sdiff.x, Sdiff.y*100, color_S, 'linewidth',2),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 40,'r','filled')
YL = ylim;

%fit
h(1) = plot(Homeo.x_intervals, Homeo.reg0*100-YL(2)/8,'color',color_1fit,'linewidth',2.5);
h(2) = plot(Homeo.x_intervals(idx1), Homeo.reg1(idx1)*100,'color',color_2fit,'linewidth',2.5);
plot(Homeo.x_intervals(idx2), Homeo.reg2(idx2)*100,'color',color_2fit,'linewidth',2.5);
h(3) = plot(Homeo.x_intervals, Homeo.reg_exp*100+YL(2)/8,'color',color_expfit,'linewidth',2.5);

set(gca, 'xtick',[], 'xlim', X_lim,'ylim',[0 350], 'fontsize',fontsize), ylabel('Delta diff occupancy (%epoch)'), title('Delta waves (diff)'),
lgd{1} = ['1 linear fit (slope=' num2str(diffdt.slope.singlefit,3) ')'];
lgd{2} = ['double fit (slope=' num2str(diffdt.slope.doublefit(1),3) ')'];
lgd{3} = ['exp fit (slope=' num2str(diffdt.slope.expfit,3) ')'];
legend(h, lgd)

%hypnogram
subplot(10,2,[18 20]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim, 'fontsize',fontsize),
xlabel ('Time (hours)'),


%% figure 3

figure, hold on

%%%%%%%%%%
%Real Delta 
%%%%%%%%%%
subplot(10,2,1:2:15), hold on
Homeo = Realdt.Hstat;
idx1 = Homeo.x_intervals<=Homeo.limSplit;
idx2 = Homeo.x_intervals>=Homeo.limSplit;

plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',1),
plot(Sreal.x, Sreal.y*100, color_S, 'linewidth',2),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 40,'r','filled')
YL = ylim;

%fit
h(1) = plot(Homeo.x_intervals, Homeo.reg0*100-YL(2)/8,'color',color_1fit,'linewidth',2.5);
h(2) = plot(Homeo.x_intervals(idx1), Homeo.reg1(idx1)*100,'color',color_2fit,'linewidth',2.5);
plot(Homeo.x_intervals(idx2), Homeo.reg2(idx2)*100,'color',color_2fit,'linewidth',2.5);
h(3) = plot(Homeo.x_intervals, Homeo.reg_exp*100+YL(2)/8,'color',color_expfit,'linewidth',2.5);

set(gca, 'xtick',[], 'xlim', X_lim,'ylim',[0 350], 'fontsize',fontsize), ylabel('SW with down occupancy (%epoch)'), title('Slow waves with down'),
lgd{1} = ['1 linear fit (slope=' num2str(realdt.slope.singlefit,3) ')'];
lgd{2} = ['double fit (slope=' num2str(realdt.slope.doublefit(1),3) ')'];
lgd{3} = ['exp fit (slope=' num2str(realdt.slope.expfit,3) ')'];
legend(h, lgd)


%hypnogram
subplot(10,2,[17 19]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim, 'fontsize',fontsize),
xlabel ('Time (hours)'),


%%%%%%%%%%
%Fake Delta 
%%%%%%%%%%
subplot(10,2,2:2:16), hold on
Homeo = Fakedt.Hstat;
idx1 = Homeo.x_intervals<=Homeo.limSplit;
idx2 = Homeo.x_intervals>=Homeo.limSplit;

plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',1),
plot(Sfake.x, Sfake.y*100, color_S, 'linewidth',2),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 40,'r','filled')
YL = ylim;

%fit
h(1) = plot(Homeo.x_intervals, Homeo.reg0*100-YL(2)/8,'color',color_1fit,'linewidth',2.5);
h(2) = plot(Homeo.x_intervals(idx1), Homeo.reg1(idx1)*100,'color',color_2fit,'linewidth',2.5);
plot(Homeo.x_intervals(idx2), Homeo.reg2(idx2)*100,'color',color_2fit,'linewidth',2.5);
h(3) = plot(Homeo.x_intervals, Homeo.reg_exp*100+YL(2)/8,'color',color_expfit,'linewidth',2.5);

set(gca, 'xtick',[], 'xlim', X_lim,'ylim',[0 350], 'fontsize',fontsize), ylabel('Fake SW  occupancy (%epoch)'), title('Fake Slow waves'),
lgd{1} = ['1 linear fit (slope=' num2str(fakedt.slope.singlefit,3) ')'];
lgd{2} = ['double fit (slope=' num2str(fakedt.slope.doublefit(1),3) ')'];
lgd{3} = ['exp fit (slope=' num2str(fakedt.slope.expfit,3) ')'];
legend(h, lgd)

%hypnogram
subplot(10,2,[18 20]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim, 'fontsize',fontsize),
xlabel ('Time (hours)'),



