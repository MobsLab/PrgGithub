%%FakeSlowWaveOneNight3
% 14.06.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight1 FakeSlowWaveOneNight2
%

clear
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep

%params
binsize_mua = 10;
t_before = -1E4; %in 1E-4s
t_after = 1E4; %in 1E-4s


%% load

%channels
load('ChannelsToAnalyse/PFCx_deep.mat')
ch_deep = channel;
load('ChannelsToAnalyse/PFCx_sup.mat')
ch_sup = channel;

%SWS
load SleepScoring_OBGamma.mat SWSEpoch REMEpoch Wake


%down states
down_states = GetDownStates;
%delta waves
deltas_PFCx = GetDeltaWaves;
%local detection
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
eval(['delta_deep = delta_ch_' num2str(ch_deep) ';'])
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
eval(['delta_sup = delta_ch_' num2str(ch_sup) ';'])

delta_deep = Restrict(ts(Start(delta_deep)), SWSEpoch);
delta_sup = Restrict(ts(Start(delta_sup)), SWSEpoch);

%night duration
load('IdFigureData2.mat', 'night_duration')

%LFP PFCx
labels_ch = cell(0);
PFC = cell(0);

load('ChannelsToAnalyse/PFCx_locations.mat')
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
    
    labels_ch{ch} = ['Ch ' num2str(channels(ch))];
end

PFCdeep = PFC{channels==ch_deep};
PFCsup = PFC{channels==ch_sup};


%% Raster
raster.deltadeep.deep = RasterMatrixKJ(PFCdeep, delta_deep, t_before, t_after);
raster.deltadeep.sup = RasterMatrixKJ(PFCsup, delta_deep, t_before, t_after);
raster.deltasup.deep = RasterMatrixKJ(PFCdeep, delta_sup, t_before, t_after);
raster.deltasup.sup = RasterMatrixKJ(PFCsup, delta_sup, t_before, t_after);


%% PLOT
figure, hold on


%deltas deep - pfc deep
raster_tsd = raster.deltadeep.deep;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
[~,idx] = sort(mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2));
Mat = Mat(idx,:);

subplot(2,2,1), hold on
imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

yyaxis right
y_meancurves = Smooth(y_meancurves ,1);
% y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

yyaxis left
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
caxis([-1500 3000]),
hb = colorbar('location','eastoutside'); hold on
title('Deltas on deep - PFCdeep')


%deltas deep - pfc sup
raster_tsd = raster.deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
[~,idx] = sort(mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2));
Mat = Mat(idx,:);

subplot(2,2,2), hold on
imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

yyaxis right
y_meancurves = Smooth(y_meancurves ,1);
% y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

yyaxis left
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
caxis([-1500 1000]),
hb = colorbar('location','eastoutside'); hold on
title('Deltas on deep - PFCsup')


%deltas sup - pfc deep
raster_tsd = raster.deltasup.deep;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
[~,idx] = sort(mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2));
Mat = Mat(idx,:);

subplot(2,2,3), hold on
imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

yyaxis right
y_meancurves = Smooth(y_meancurves ,1);
% y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

yyaxis left
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
caxis([-1500 3000]),
hb = colorbar('location','eastoutside'); hold on
title('Deltas on sup - PFCdeep')


%deltas sup - pfc sup
raster_tsd = raster.deltasup.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
[~,idx] = sort(mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2));
Mat = Mat(idx,:);

subplot(2,2,4), hold on
imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

yyaxis right
y_meancurves = Smooth(y_meancurves ,1);
% y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

yyaxis left
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
caxis([-1500 1000]),
hb = colorbar('location','eastoutside'); hold on
title('Deltas on sup - PFCsup')







