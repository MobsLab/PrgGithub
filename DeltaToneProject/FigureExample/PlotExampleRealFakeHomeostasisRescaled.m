%%PlotExampleRealFakeHomeostasisRescaled
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
freq_delta = [0.5 4];
windowsize_density = 60e4; %60s
minDurationDelta = 75;
rescale = 2;

color_nrem = 'b';
color_rem  = [0 0.5 0];
color_wake = 'k';
color_curve = [0.5 0.5 0.5];
color_S = 'b';
color_peaks = 'r';

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

%down
x_peaks = Realdt.Hstat.x_peaks;
y_peaks = Realdt.Hstat.y_peaks;
Sreal.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sreal.y = interp1(x_peaks, y_peaks, Sreal.x, 'pchip');

%down
x_peaks = Fakedt.Hstat.x_peaks;
y_peaks = Fakedt.Hstat.y_peaks;
Sfake.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sfake.y = interp1(x_peaks, y_peaks, Sfake.x, 'pchip');



%% SWA

%load spectrum
load(['Spectra/Specg_ch' num2str(ch_example) '.mat'])
if exist('Spectro','var')
    fd = Spectro{3};
    td = Spectro{2}; %td in sec - time bins = 0.2s
    Spd = Spectro{1};
else
    fd = f;
    td = t;
    Spd = Sp;
end
clear Spectro f t Sp

%swa curve
smoothing = round((windowsize_density/1e4) / median(diff(td))); %same windows as down density
idswa = fd>0.5&fd<=4;
SWA.x = Data(Restrict(NewtsdZT, ts(td'*1e4))) /3600e4;
SWA.raw_y = runmean(mean(Spd(:,idswa),2),smoothing); %

clear Spd td fd


%NREM mean
tSwa = tsd(SWA.x*3600e4,SWA.raw_y);
meanSWA = mean(Data(Restrict(tSwa,NREMzt)));
SWA.y = 100 * SWA.raw_y / meanSWA; %SWA in percentage of mean 

%peaks
SWA_smooth = Smooth(SWA.y,40); %
idx_maxima = LocalMaxima(SWA_smooth);
tmp_peaks  = tsd(SWA.x(idx_maxima)*3600e4, idx_maxima);
tmp_peaks  = Restrict(tmp_peaks, NREMzt); %only extrema in Epoch
idx_maxima = Data(tmp_peaks);
idx1 = SWA.y(idx_maxima) > max(SWA.y(idx_maxima))/3;
idx_peaks = idx_maxima(idx1);

SWA.x_peaks  = SWA.x(idx_peaks);
SWA.y_peaks  = SWA.y(idx_peaks);
Sswa.x = x_intervals(x_intervals>=SWA.x_peaks(1) & x_intervals<=SWA.x_peaks(end));
Sswa.y = interp1(SWA.x_peaks, SWA.y_peaks, Sswa.x, 'pchip'); 



%% Plot
X_lim = [min(Start(NREMzt))/3600e4-0.2 max(Data(NewtsdZT))/3600e4]; 


%% Figure 1 

gap = [0.01 0.1];

figure, hold on

%SWA
subtightplot(4,2,1:2:5,gap), hold on
plot(SWA.x, SWA.y, 'color', color_curve, 'linewidth',2),
plot(Sswa.x, Sswa.y, color_S),
scatter(SWA.x_peaks, SWA.y_peaks, 20,'r','filled')

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Slow Wave Activity (%NREM mean)'),

%hypnogram
subtightplot(4,2,7,gap), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        x_rec = [st_stages(i) end_stages(i) end_stages(i) st_stages(i)]/3600e4;
        y_rec = [s-1 s-1 s s];
        pa=patch(x_rec,y_rec,colorStages{s});
        set(pa,'EdgeColor',colorStages{s});
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', NameStages, 'ylim', [0 3], 'xlim', X_lim),
xlabel ('Time (hours)'),

%down
subtightplot(4,2,2:2:6,gap), hold on
Homeo = Down.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sdown.x, Sdown.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Down occupancy (%epoch)'),

%hypnogram
subtightplot(4,2,8,gap), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        x_rec = [st_stages(i) end_stages(i) end_stages(i) st_stages(i)]/3600e4;
        y_rec = [s-1 s-1 s s];
        pa=patch(x_rec,y_rec,colorStages{s});
        set(pa,'EdgeColor',colorStages{s});
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', NameStages, 'ylim', [0 3], 'xlim', X_lim),
xlabel ('Time (hours)'),



%% figure 2

figure, hold on

%down
subplot(10,2,1:2:15), hold on
Homeo = Down.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sdown.x, Sdown.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Down occupancy (%epoch)'),
title('Down states')

%hypnogram
subplot(10,2,[17 19]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        x_rec = [st_stages(i) end_stages(i) end_stages(i) st_stages(i)]/3600e4;
        y_rec = [s-1 s-1 s s];
        pa=patch(x_rec,y_rec,colorStages{s});
        set(pa,'EdgeColor',colorStages{s});
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim),


%Delta diff
subplot(10,2,2:2:16), hold on
Homeo = Diff.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sdiff.x, Sdiff.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Delta diff occupancy (%epoch)'),
title('Delta waves (diff)')

%hypnogram
subplot(10,2,[18 20]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        x_rec = [st_stages(i) end_stages(i) end_stages(i) st_stages(i)]/3600e4;
        y_rec = [s-1 s-1 s s];
        pa=patch(x_rec,y_rec,colorStages{s});
        set(pa,'EdgeColor',colorStages{s});
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim),
xlabel ('Time (hours)'),


%% figure 3

figure, hold on

%good delta
subplot(10,2,1:2:15), hold on
Homeo = Realdt.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sreal.x, Sreal.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
title('Slow waves with down')

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('SW with down occupancy (%epoch)'),
title('Slow waves with down')

%hypnogram
subplot(10,2,[17 19]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        x_rec = [st_stages(i) end_stages(i) end_stages(i) st_stages(i)]/3600e4;
        y_rec = [s-1 s-1 s s];
        pa=patch(x_rec,y_rec,colorStages{s});
        set(pa,'EdgeColor',colorStages{s});
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim),


%Fake
subplot(10,2,2:2:16), hold on
Homeo = Fakedt.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sfake.x, Sfake.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Fake SW  occupancy (%epoch)'),
title('Fake Slow waves')

%hypnogram
subplot(10,2,[18 20]), hold on
for s=1:length(SleepStages)
    st_stages  = Start(SleepStages{s});
    end_stages = End(SleepStages{s});
    for i=1:length(st_stages)
        x_rec = [st_stages(i) end_stages(i) end_stages(i) st_stages(i)]/3600e4;
        y_rec = [s-1 s-1 s s];
        pa=patch(x_rec,y_rec,colorStages{s});
        set(pa,'EdgeColor',colorStages{s});
    end
end
set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', X_lim),
xlabel ('Time (hours)'),



