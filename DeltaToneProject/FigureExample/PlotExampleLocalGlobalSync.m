%%PlotExampleLocalGlobalSync
% 18.09.2019 KJ
%
% Infos
%   Examples homeostasis figures
%
% see
%     FindExampleRealFakeSlow PlotExampleRealFakeHomeostasis
%
%


clear

%params
pathexample = '/media/nas4/ProjetDeltaToneFeedback/Mouse490/20161124';
windowsize_density = 60e4; %60s
rescale = 0;

color_nrem = 'b';
color_rem  = [0 0.5 0];
color_wake = 'k';
color_curve = [0.5 0.5 0.5];
color_S = 'b';
color_peaks = 'r';
color_fit = 'k';
tetrodesNames = {'A','B','C'};
id_tetrodes = [1 4];


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



%% Down

%Global
load('DownState.mat', 'down_PFCx')
GlobalDown = down_PFCx;

%Local
load('LocalDownState.mat', 'all_local_PFCx')
all_local_PFCx = all_local_PFCx(id_tetrodes);

nb_tetrodes = length(all_local_PFCx);
for tt=1:nb_tetrodes
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(all_local_PFCx{tt}, GlobalDown);
    LocalDown{tt} = subset(all_local_PFCx{tt}, setdiff(1:length(Start(all_local_PFCx{tt})), idAlocal)');
    LocalDown{tt} = dropShortIntervals(and(LocalDown{tt},NREM), 750);
end


%% Homeostasis

%Global
[~, ~, Global.Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Local
for tt=1:nb_tetrodes
    [~, ~, Local.Hstat{tt}] = DensityOccupation_KJ(LocalDown{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
end


%% interpolate peaks
x_intervals = Global.Hstat.x_intervals;

%global
x_peaks = Global.Hstat.x_peaks;
y_peaks = Global.Hstat.y_peaks;
Sglobal.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sglobal.y = interp1(x_peaks, y_peaks, Sglobal.x, 'pchip'); 

%local
for tt=1:nb_tetrodes
    Hstat = Local.Hstat{tt};
    x_peaks = Hstat.x_peaks;
    y_peaks = Hstat.y_peaks;
    Slocal.x{tt} = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
    Slocal.y{tt} = interp1(x_peaks, y_peaks, Slocal.x{tt}, 'pchip');
end

% %swa
% x_peaks = Swa.Hstat.x_peaks;
% y_peaks = Swa.Hstat.y_peaks;
% Sswa.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
% Sswa.y = interp1(x_peaks, y_peaks, Sswa.x, 'pchip'); 
% 



%% Plot

%Figure 1 

gap = [0.06 0.06];
X_lim = [min(Start(NREMzt))/3600e4-0.2 max(Data(NewtsdZT))/3600e4];

possubplot{1} = 1:2:17;
possubplot{2} = 2:2:18;
possubplot{3} = 19:2:35;
possubplot{4} = 20:2:36;

poshypno = [37 39];



figure, hold on

%Global Down
subplot(20,2,possubplot{1}), hold on
Homeo = Global.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sglobal.x, Sglobal.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Global Down occupancy (%epoch)'),
title('Global Down')

%Local
tt=2;
subplot(20,2,possubplot{3}), hold on
Homeo = Local.Hstat{2};
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Slocal.x{tt}, Slocal.y{tt}*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[], 'xlim', X_lim),
ylabel('Local Down occupancy (%epoch)'),
title('Strictly Local down')


%hypnogram
subplot(20,2,poshypno), hold on
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




