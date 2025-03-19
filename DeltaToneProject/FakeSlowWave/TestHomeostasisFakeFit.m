%%TestHomeostasisFakeFit
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensityPlot ParcoursHomeostasieLocalDeltaOccupancy
%   TestHomeostasisLocalFit


%params
binsize_mua = 5*10; %5ms
minDurationDown1 = 75;
minDurationDown2 = 50;
maxDurationDown = 800; %800ms
windowdensity = 60e4; %60s  


%% load

%night duration and tsd zt
load('behavResources.mat', 'NewtsdZT')
load('IdFigureData2.mat', 'night_duration')

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

%Deltawaves
load('DeltaWaves.mat', 'deltas_PFCx')
DeltaDiff = deltas_PFCx;


%% slopes
[~, ~, Hstat] = DensityOccupation_KJ(DeltaDiff, 'homeostat',4, 'windowsize',windowdensity,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',0);
[~, ~, Hstat_resc] = DensityOccupation_KJ(DeltaDiff, 'homeostat',4, 'windowsize',windowdensity,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',1);


%% plot
figure, hold on

%no rescale
subplot(4,2,[1 3 5]), hold on
plot(Hstat.x_intervals,Hstat.y_density,'b')
plot(Hstat.x_intervals, Hstat.reg0,'r.')

idx1 =  Hstat.x_intervals<Hstat.limSplit;
idx2 =  Hstat.x_intervals>Hstat.limSplit; 

plot(Hstat.x_intervals(idx1), Hstat.reg1(idx1),'k.')
plot(Hstat.x_intervals(idx2), Hstat.reg2(idx2),'k.')
hold on, scatter(Hstat.x_peaks, Hstat.y_peaks,'r')

textbox_str = {['1fit (r2= ' num2str(Hstat.R2_0) ' / p=' num2str(Hstat.p0(1)) ' / pvalue=' num2str(Hstat.pv0)  ') '],...
               ['2fit (r2= ' num2str(Hstat.R2_1) ' / p=' num2str(Hstat.p1(1)) ' / pvalue=' num2str(Hstat.pv1) ') '],...
               ['2fit (r2bis= ' num2str(Hstat.R2_2) ' / pbis=' num2str(Hstat.p2(1)) ' / pvalue=' num2str(Hstat.pv2) ') ']};

subplot(4,2,7), hold on
textbox_dim = get(subplot(4,2,7),'position');
delete(subplot(4,2,7))

annotation(gcf,'textbox',...
textbox_dim,...
'String',textbox_str,...
'LineWidth',1,...
'HorizontalAlignment','center',...
'FontWeight','bold',...
'FitBoxToText','off');


%rescale
subplot(4,2,[2 4 6]), hold on
plot(Hstat_resc.x_intervals,Hstat_resc.y_density,'b')
plot(Hstat_resc.x_intervals, Hstat_resc.reg0,'r.')

idx1 =  Hstat_resc.x_intervals<Hstat_resc.limSplit;
idx2 =  Hstat_resc.x_intervals>Hstat_resc.limSplit; 

plot(Hstat_resc.x_intervals(idx1), Hstat_resc.reg1(idx1),'k.')
plot(Hstat_resc.x_intervals(idx2), Hstat_resc.reg2(idx2),'k.')
hold on, scatter(Hstat_resc.x_peaks, Hstat_resc.y_peaks,'r')

textbox_str2 = {['1fit (r2= ' num2str(Hstat_resc.R2_0) ' / p=' num2str(Hstat_resc.p0(1)) ' / pvalue=' num2str(Hstat_resc.pv0)  ') '],...
               ['2fit (r2= ' num2str(Hstat_resc.R2_1) ' / p=' num2str(Hstat_resc.p1(1)) ' / pvalue=' num2str(Hstat_resc.pv1) ') '],...
               ['2fit (r2bis= ' num2str(Hstat_resc.R2_2) ' / pbis=' num2str(Hstat_resc.p2(1)) ' / pvalue=' num2str(Hstat_resc.pv2) ') ']};

subplot(4,2,8), hold on
textbox_dim = get(subplot(4,2,8),'position');
delete(subplot(4,2,8))

annotation(gcf,'textbox',...
textbox_dim,...
'String',textbox_str2,...
'LineWidth',1,...
'HorizontalAlignment','center',...
'FontWeight','bold',...
'FitBoxToText','off');









