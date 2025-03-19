%%PlotExampleRealFakeHomeostasisFit1
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
windowsize_density = 60e4; %60s
minDurationDelta = 75;
rescale = 0;

color_curve = [0.5 0.5 0.5];
color_S = 'b';
color_peaks = 'r';

color_fit = 'k';


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
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

new_st  = Data(Restrict(NewtsdZT, ts(Start(NREM))));
new_end = Data(Restrict(NewtsdZT, ts(End(NREM))));
NREMzt = intervalSet(new_st,new_end);


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
[~, ~, Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);

x_intervals = Hstat.x_intervals;
x_peaks = Hstat.x_peaks;
y_peaks = Hstat.y_peaks;

%S process
Sdown.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sdown.y = interp1(x_peaks, y_peaks, Sdown.x, 'pchip'); 

%fit
idx1 = Hstat.x_intervals<=Hstat.limSplit;
idx2 = Hstat.x_intervals>=Hstat.limSplit;

%
R2.singlefit = Hstat.R2_0;
R2.doublefit(1) = Hstat.R2_1;
R2.doublefit(2) = Hstat.R2_2;
R2.expfit    = Hstat.exp_R2;

pv.singlefit = Hstat.pv0;
pv.doublefit(1) = Hstat.pv1;
pv.doublefit(2) = Hstat.pv2;
pv.expfit    = Hstat.pv_b;

rmse.singlefit = Hstat.rmse0;
rmse.doublefit(1) = Hstat.rmse1;
rmse.doublefit(2) = Hstat.rmse2;
rmse.expfit    = Hstat.rmseExp;

slope.singlefit = Hstat.p0(1);
slope.doublefit(1) = Hstat.p1(1);
slope.doublefit(2) = Hstat.p2(1);
slope.expfit    = Hstat.exp_b;


%% Plot
fontsize = 11;

% X_lim = [min(Start(NREMzt))/3600e4-0.2 max(Data(NewtsdZT))/3600e4]; 

figure, hold on

%Single fit
subplot(1,3,1), hold on
plot(Hstat.x_intervals, Hstat.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sdown.x, Sdown.y*100, color_S),
scatter(Hstat.x_peaks, Hstat.y_peaks*100, 20,'r','filled')
plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_fit,'linewidth',2);

textbox_str = {['Slope = ' num2str(slope.singlefit,2)], ['p-value = ' num2str(pv.singlefit,2)], ['RMSE = ' num2str(rmse.singlefit,2)] };
annotation('textbox',[0.23 0.81 0.1 0.1],'String',textbox_str,'FontWeight','bold', 'linestyle','none', 'fontsize',fontsize);

% set(gca,'xlim', X_lim),
ylabel('Down occupancy (%epoch)'), xlabel ('Time (hours)'),
title('Single Linear fit')



%Double fit
subplot(1,3,2), hold on
plot(Hstat.x_intervals, Hstat.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sdown.x, Sdown.y*100, color_S),
scatter(Hstat.x_peaks, Hstat.y_peaks*100, 20,'r','filled')
plot(Hstat.x_intervals(idx1), Hstat.reg1(idx1)*100,'color',color_fit,'linewidth',2);
plot(Hstat.x_intervals(idx2), Hstat.reg2(idx2)*100,'color',color_fit,'linewidth',2);

textbox_str = {['Slope = ' num2str(slope.doublefit(1),2)], ['p-value = ' num2str(pv.doublefit(1),2)], ['RMSE = ' num2str(rmse.doublefit(1),2)] };
annotation('textbox',[0.43 0.82 0.1 0.1],'String',textbox_str,'FontWeight','bold', 'linestyle','none', 'fontsize',fontsize);

textbox_str = {['Slope = ' num2str(slope.doublefit(2),2)], ['p-value = ' num2str(pv.doublefit(2),2)], ['RMSE = ' num2str(rmse.doublefit(2),2)] };
annotation('textbox',[0.54 0.61 0.1 0.1],'String',textbox_str,'FontWeight','bold', 'linestyle','none', 'fontsize',fontsize);

% set(gca, 'xlim', X_lim),
ylabel('Down occupancy (%epoch)'), xlabel ('Time (hours)'),
title('Double Linear fit')



%Exponential fit
subplot(1,3,3), hold on
plot(Hstat.x_intervals, Hstat.y_density*100, 'color', color_curve, 'linewidth',2),
plot(Sdown.x, Sdown.y*100, color_S),
scatter(Hstat.x_peaks, Hstat.y_peaks*100, 20,'r','filled')
plot(Hstat.x_intervals, Hstat.reg_exp*100,'color',color_fit,'linewidth',2);

textbox_str = {['Exp coeff = ' num2str(slope.expfit,2)], ['p-value = ' num2str(pv.expfit,2)], ['RMSE = ' num2str(rmse.expfit,2)] };
annotation('textbox',[0.8 0.81 0.1 0.1],'String',textbox_str,'FontWeight','bold', 'linestyle','none', 'fontsize',fontsize);

% set(gca, 'xlim', X_lim),
ylabel('Down occupancy (%epoch)'), xlabel ('Time (hours)'),
title('Exponential fit')





