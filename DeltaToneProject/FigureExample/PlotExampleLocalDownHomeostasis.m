%%PlotExampleLocalDownHomeostasis
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

pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Breath-Mouse-243-244-31032015/Mouse244';
idtetrodes = []; 

pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243'pwd;
idtetrodes = []; 



disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%params
freq_delta = [0.5 4];
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

endtime = 262239648;


%% load

%night duration and tsd zt
load('behavResources.mat', 'NewtsdZT')
load('IdFigureData2.mat', 'night_duration')

%Stages
colorStages = {color_rem, color_nrem, color_wake};
NameStages = {'REM','NREM','Wake'};
Labels = {'R','NR','W'};

[NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;
SleepStages = {REM,NREM,Wake};


for s=1:length(SleepStages)
    new_st  = Start(SleepStages{s});
    new_end = End(SleepStages{s});
    idx = find(new_st<endtime);

    new_st  = Data(Restrict(NewtsdZT, ts(new_st(idx))));
    new_end = Data(Restrict(NewtsdZT, ts(new_end(idx))));
    
    SleepStages{s} = intervalSet(new_st,new_end);
end
NREMzt = SleepStages{2}; 


%% Down

%Global
load('DownState.mat', 'down_PFCx')
GlobalDown = down_PFCx;

%Local
load('LocalDownState.mat', 'localdown_PFCx')
if ~isempty(idtetrodes)
    localdown_PFCx = localdown_PFCx(idtetrodes);
end
nb_tetrodes = length(localdown_PFCx);
for tt=1:nb_tetrodes
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(localdown_PFCx{tt}, GlobalDown);
    LocalDown{tt} = subset(localdown_PFCx{tt}, setdiff(1:length(Start(localdown_PFCx{tt})), idAlocal)');
    LocalDown{tt} = dropShortIntervals(and(LocalDown{tt},NREM), 750);
end

%Union 
UnionDown = intervalSet([],[]);
UnionStrict = intervalSet([],[]);
for tt=1:nb_tetrodes
    intv = dropLongIntervals(dropShortIntervals(and(localdown_PFCx{tt},NREM), 750),2e4);
    UnionDown = or(UnionDown,intv);
    UnionStrict = or(UnionStrict,LocalDown{tt});
end

UnionDown = dropLongIntervals(UnionDown,1e4);


%% Homeostasis

%Global
[~, ~, Global.Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', endtime,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Local
for tt=1:nb_tetrodes
    [~, ~, Local.Hstat{tt}] = DensityOccupation_KJ(LocalDown{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', endtime,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
end
%Union all 
[~, ~, Union.Hstat] = DensityOccupation_KJ(UnionDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', endtime,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Union strict 
[~, ~, UnionStr.Hstat] = DensityOccupation_KJ(UnionStrict, 'homeostat',4, 'windowsize',windowsize_density,'endtime', endtime,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);



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


%union all
x_peaks = Union.Hstat.x_peaks;
y_peaks = Union.Hstat.y_peaks;
Sall.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sall.y = interp1(x_peaks, y_peaks, Sall.x, 'pchip'); 

%union strict
x_peaks = UnionStr.Hstat.x_peaks;
y_peaks = UnionStr.Hstat.y_peaks;
Sustr.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sustr.y = interp1(x_peaks, y_peaks, Sustr.x, 'pchip'); 


%% Plot 1 Occupation

%Figure 1 
gap = [0.06 0.06];

possubplot{1} = 1:2:17;
possubplot{2} = 2:2:18;
possubplot{3} = 19:2:35;
possubplot{4} = 20:2:36;

poshypno{1} = [37 39];
poshypno{2} = [38 40];

fontsize = 20;
XL = [10.5 17.5];


figure, hold on

%Global Down
subplot(20,2,possubplot{1}), hold on
Homeo = Global.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sglobal.x, Sglobal.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[], 'xlim', XL,'fontsize',fontsize),
ylabel('Down occupancy (%epoch)'),
title('Global Down')


%Local
for tt=1:nb_tetrodes
    subplot(20,2,possubplot{tt+1}), hold on
    Homeo = Local.Hstat{tt};
    plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
    plot(Slocal.x{tt}, Slocal.y{tt}*100, color_S),
    scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
    plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

    set(gca, 'xtick',[], 'xlim', XL,'fontsize',fontsize),
    ylabel('Local Down occupancy (%epoch)'),
    title(['Tetrodes ' tetrodesNames{tt}])
end

%hypnogram
for h=1:length(poshypno)
    subplot(20,2,poshypno{h}), hold on
    for s=1:length(SleepStages)
        st_stages  = Start(SleepStages{s});
        end_stages = End(SleepStages{s});
        for i=1:length(st_stages)
            line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
        end
    end
    set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', XL,'fontsize',fontsize),
    xlabel ('Time (hours)'),
end


%%  fig 2
figure, hold on

%Global Down
subplot(20,2,possubplot{1}), hold on
Homeo = Global.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sglobal.x, Sglobal.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[], 'xlim', XL,'fontsize',fontsize),
ylabel('Down occupancy (%epoch)'),
title('Global Down')


%Union Down
subplot(20,2,possubplot{3}), hold on
Homeo = Union.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sall.x, Sall.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[], 'xlim', XL,'fontsize',fontsize),
ylabel('occupancy (%epoch)'),
title('Union (A+B+C+Global)')


%Union Strict
subplot(20,2,possubplot{4}), hold on
Homeo = UnionStr.Hstat;
plot(Homeo.x_intervals, Homeo.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sustr.x, Sustr.y*100, color_S),
scatter(Homeo.x_peaks, Homeo.y_peaks*100, 20,'r','filled')
plot(Homeo.x_intervals, Homeo.reg0*100,'color',color_fit,'linewidth',2);

set(gca, 'xtick',[], 'xlim', XL,'fontsize',fontsize),
ylabel('occupancy (%epoch)'),
title('A+B+C')

%hypnogram
for h=1:length(poshypno)
    subplot(20,2,poshypno{h}), hold on
    for s=1:length(SleepStages)
        st_stages  = Start(SleepStages{s});
        end_stages = End(SleepStages{s});
        for i=1:length(st_stages)
            line([st_stages(i) end_stages(i)]/3600e4, [s-0.5 s-0.5], 'color',colorStages{s}, 'linewidth',35)
        end
    end
    set(gca,'ytick', [0.5 1.5 2.5], 'yticklabel', Labels, 'ylim', [0 3], 'xlim', XL,'fontsize',fontsize),
    xlabel ('Time (hours)'),
end





