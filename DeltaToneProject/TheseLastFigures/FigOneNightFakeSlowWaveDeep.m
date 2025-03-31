%%FigOneNightFakeSlowWaveDeep
% 13.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%     
%
%


%% load

Dir = PathForExperimentsFakeSlowWave('sup');
p=5

    
disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)

clearvars -except Dir p
    
%params
binsize_mua = 10;
binsize_met = 10;
nbBins_met  = 160;
factorLFP = 0.195;
fontsize = 18;


%raster
load('RasterLFPDeltaWaves.mat','deltadeep', 'ch_deep', 'ch_sup', 'deltadeep_tmp') 


%deltas channel
deltadeep_tmp = Range(deltadeep_tmp);

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = CleanUpEpoch(NREM - TotalNoiseEpoch,1);

%down
load('DownState.mat', 'down_PFCx')

%LFP PFCx
labels_ch = cell(0);
PFC = cell(0);
load('ChannelsToAnalyse/PFCx_locations.mat')

%507
if strcmpi(Dir.name{p},'Mouse507')
    channels = [3 4 8 20 32 36 44 56];
end

for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP

    labels_ch{ch} = ['Ch ' num2str(channels(ch))];
end

PFCdeep = PFC{channels==ch_deep};

 %delta epoch
name_var = ['delta_ch_' num2str(ch_deep)];
load('DeltaWavesChannels.mat', name_var)
eval(['deltas = ' name_var ';'])
%Restrict    
DeltaDeep = and(deltas, NREM);
st_deep = Start(DeltaDeep);
center_deep = (Start(DeltaDeep) + End(DeltaDeep))/2;
    
    
%% Quantification good and fake

%delta deep>PFCsup
nb_sample = round(length(deltadeep_tmp)/4);

raster_tsd = deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
[~, idxMat1] = sort(vmean1);

high_deep = sort(deltadeep_tmp(idxMat1(1:nb_sample)));%good
low_deep = sort(deltadeep_tmp(idxMat1(end-nb_sample+1:end)));%fake

%down or not down
[RealDelta,~,Istat, idreal] = GetIntersectionsEpochs(DeltaDeep, down_PFCx);
FakeDelta = subset(DeltaDeep, setdiff(1:length(Start(DeltaDeep)), idreal)');

nb_delta = length(Start(DeltaDeep));
nb_real = length(Start(RealDelta));
nb_fake = length(Start(FakeDelta));
nb_high = high_deep;

    
%% PFC response
for ch=1:length(channels)
    %highest inversion
    [m,~,tps] = mETAverage(high_deep, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_lfp.high{ch}(:,1) = tps; met_lfp.high{ch}(:,2) = m * factorLFP;
    %fake delta deep
    [m,~,tps] = mETAverage(low_deep, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_lfp.low{ch}(:,1) = tps; met_lfp.low{ch}(:,2) = m * factorLFP;
    
    %real delta deep
    [m,~,tps] = mETAverage(Start(RealDelta), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_lfp.real{ch}(:,1) = tps; met_lfp.real{ch}(:,2) = m * factorLFP;
    %fake delta deep
    [m,~,tps] = mETAverage(Start(FakeDelta), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_lfp.fake{ch}(:,1) = tps; met_lfp.fake{ch}(:,2) = m * factorLFP;
end
    
    
%% PLOT deltas detected on  SUP

color_all = [0.3 0.3 0.3];
color_down = 'k';
color_good = 'b';
color_fake = 'r';



%deltas sup - pfc deep
raster_tsd = deltadeep.sup;
Mat = Data(raster_tsd)'*factorLFP;
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
Mat = Mat(idxMat1,:);



%Fig1
figure, hold on

%Raster
subplot(7,4,[5 9 13 17 21]), hold on
imagesc(x_tmp/10, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas detected on deep'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1000 1000], 'ytick',[], 'fontsize',fontsize);
caxis([-360 440]),
% hb = colorbar('location','eastoutside'); hold on
xlabel({'time from delta waves', 'detected on deep layer (ms)'}), 
title('LFP amplitude (Sup Layer)')

%low inversion
subplot(5,3,[2 5]), hold on
line([-400 600],[0 0],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
for ch=1:length(channels)
    if ismember(channels(ch),[ch_deep ch_sup])
        linewidt = 2;
    else
        linewidt = 0.5;
    end
    hold on, plot(met_lfp.low{ch}(:,1), met_lfp.low{ch}(:,2), 'color',color_fake, 'linewidth',linewidt)
end
set(gca,'xlim', [-400 600], 'ylim', [-240 300],'fontsize',fontsize);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
ylabel('mean LFP amplitude (µV)'), 
title('25% lowest inversion')


%high inversion
subplot(5,3,[11 14]), hold on
line([-400 600],[0 0],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
for ch=1:length(channels)
    if ismember(channels(ch),[ch_deep ch_sup])
        linewidt = 2;
    else
        linewidt = 0.5;
    end
    hold on, h(ch) = plot(met_lfp.high{ch}(:,1), met_lfp.high{ch}(:,2), 'color',color_good, 'linewidth',linewidt);   
end
set(gca,'xlim', [-400 600], 'ylim', [-240 300],'fontsize',fontsize);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
ylabel('mean LFP amplitude (µV)'), xlabel('time from detection (ms)'), 
title('25% highest inversion')



%Fake deltas
subplot(5,3,[3 6]), hold on
line([-400 600],[0 0],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
for ch=1:length(channels)
    if ismember(channels(ch),[ch_deep ch_sup])
        linewidt = 2;
    else
        linewidt = 0.5;
    end
    hold on, plot(met_lfp.fake{ch}(:,1), met_lfp.fake{ch}(:,2), 'color',color_fake, 'linewidth',linewidt)
end
set(gca,'xlim', [-400 600], 'ylim', [-240 300], 'ytick',[], 'fontsize',fontsize);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
title(['Fake deltas (' num2str(round(100*nb_fake/nb_delta,2))  '%)'])


%Real deltas
subplot(5,3,[12 15]), hold on
line([-400 600],[0 0],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
for ch=1:length(channels)
    if ismember(channels(ch),[ch_deep ch_sup])
        linewidt = 2;
    else
        linewidt = 0.5;
    end
    hold on, h(ch) = plot(met_lfp.real{ch}(:,1), met_lfp.real{ch}(:,2), 'color',color_good, 'linewidth',linewidt);
end
set(gca,'xlim', [-400 600], 'ylim', [-240 300], 'ytick',[], 'fontsize',fontsize);
line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
xlabel('time from detection (ms)'), 
title(['Delta with down (' num2str(round(100*nb_real/nb_delta,2))  '%)'])





