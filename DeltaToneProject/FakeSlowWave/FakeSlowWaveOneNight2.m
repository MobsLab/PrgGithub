%%FakeSlowWaveOneNight2
% 21.06.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    






clear
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep

%params
binsize_mua = 10;
t_before = -1E4; %in 1E-4s
t_after = 1E4; %in 1E-4s
binsize_met = 10;
nbBins_met  = 80;


%% load

%channels
load('ChannelsToAnalyse/PFCx_deep.mat')
ch_deep = channel;
load('ChannelsToAnalyse/PFCx_sup.mat')
ch_sup = channel;

%SWS
load SleepScoring_OBGamma.mat SWSEpoch REMEpoch Wake

%MUA
MUA = GetMuaNeurons_KJ('PFCx_r', 'binsize',binsize_mua); 

%down states
down_states = GetDownStates;
%delta waves
deltas_PFCx = GetDeltaWaves;
%local detection
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
eval(['DeltaDeep = delta_ch_' num2str(ch_deep) ';'])
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
eval(['DeltaSup = delta_ch_' num2str(ch_sup) ';'])

delta_deep = Restrict(ts(Start(DeltaDeep)), SWSEpoch);
delta_sup = Restrict(ts(Start(DeltaSup)), SWSEpoch);
deltadeep_tmp = Range(delta_deep);
deltasup_tmp = Range(delta_sup);

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
raster.deltadeep.sup = RasterMatrixKJ(PFCsup, delta_deep, t_before, t_after);
raster.deltasup.deep = RasterMatrixKJ(PFCdeep, delta_sup, t_before, t_after);


%% Quantification good and fake


%delta deep>PFCsup
raster_tsd = raster.deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
[~, idx1] = sort(vmean1);
idx_fake = find(vmean1>300);
idx_good = find(vmean1<-300);
good_deep = deltadeep_tmp(idx_good);
fake_deep = deltadeep_tmp(idx_fake);


%delta sup>PFCdeep
raster_tsd = raster.deltasup.deep;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
[~, idx2] = sort(vmean2);
idx_fake = find(vmean2<-100);
idx_good = find(vmean2>1000);
good_sup = deltasup_tmp(idx_good);
fake_sup = deltasup_tmp(idx_fake);

%Quantification

intvDur_sup = 100*10; %100ms
intvDur_deep = 50*10; %50ms

%diff and sup
larger_delta_epochs = [Start(DeltaSup)-intvDur_sup, End(DeltaSup)];
[status, ~, ~] = InIntervals(down_tmp,larger_delta_epochs);
down_delta = sum(status);
down_only = length(down_tmp) - down_delta;
delta_only = length(Start(DeltaSup)) - down_delta;

%down and sup
larger_delta_epochs = [Start(DeltaSup)-intvDur_sup, End(DeltaSup)];
[status, ~, ~] = InIntervals(deltas_tmp,larger_delta_epochs);
diff_sup = sum(status);
diff_only = length(deltas_tmp) - diff_sup;
sup_only = length(Start(DeltaSup)) - diff_sup;








%% PFC response
%Good deep
for ch=1:length(channels)
    
    %Good deep
    [m,~,tps] = mETAverage(good_deep, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_good.deep{ch}(:,1) = tps; lfp_good.deep{ch}(:,2) = m;
    %Fake deep
    [m,~,tps] = mETAverage(fake_deep, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_fake.deep{ch}(:,1) = tps; lfp_fake.deep{ch}(:,2) = m;
    
    %Good sup
    [m,~,tps] = mETAverage(good_sup, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_good.sup{ch}(:,1) = tps; lfp_good.sup{ch}(:,2) = m;
    %Fake sup
    [m,~,tps] = mETAverage(fake_sup, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_fake.sup{ch}(:,1) = tps; lfp_fake.sup{ch}(:,2) = m;
    
end


%% MUA response
%Good deep
[m,~,tps] = mETAverage(good_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_good.deep(:,1) = tps; met_good.deep(:,2) = m;
%Fake deep
[m,~,tps] = mETAverage(fake_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_fake.deep(:,1) = tps; met_fake.deep(:,2) = m;
%all deep
[m,~,tps] = mETAverage(deltadeep_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_all.deep(:,1) = tps; met_all.deep(:,2) = m;

%Good sup
[m,~,tps] = mETAverage(good_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_good.sup(:,1) = tps; met_good.sup(:,2) = m;
%Fake sup
[m,~,tps] = mETAverage(fake_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_fake.sup(:,1) = tps; met_fake.sup(:,2) = m;
%all sup
[m,~,tps] = mETAverage(deltasup_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_all.sup(:,1) = tps; met_all.sup(:,2) = m;


%% homeostasis





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PLOT deltas on  DEEP
figure, hold on

%deltas deep - pfc sup
raster_tsd = raster.deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
Mat = Mat(idx1,:);

subplot(2,3,[1 4]), hold on
imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas detected on deep'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

yyaxis right
y_meancurves = Smooth(y_meancurves ,1);
% y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

yyaxis left
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
caxis([-1500 1000]),
hb = colorbar('location','eastoutside'); hold on
title('LFP sup layer')


%Deltas on deep - fake
subplot(2,3,2), hold on
for ch=1:length(channels)
    hold on, plot(lfp_fake.deep{ch}(:,1), lfp_fake.deep{ch}(:,2))
end
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
title('mean LFP on detection')
%Deltas on deep - good
subplot(2,3,5), hold on
for ch=1:length(channels)
    hold on, plot(lfp_good.deep{ch}(:,1), lfp_good.deep{ch}(:,2))
end
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

%MUA deep
subplot(2,3,[3 6]), hold on
hold on, h(1)=plot(met_fake.deep(:,1), met_fake.deep(:,2), 'r');
hold on, h(2)=plot(met_good.deep(:,1), met_good.deep(:,2), 'b');
hold on, h(3)=plot(met_all.deep(:,1), met_all.deep(:,2), 'color',[0.6 0.6 0.6]);
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
legend(h,'fake', 'good', 'all'),
title('mean MUA on detection')



%% PLOT deltas on SUP
figure, hold on

%deltas sup - pfc deep
raster_tsd = raster.deltasup.deep;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
y_meancurves = mean(Mat);
%sort
Mat = Mat(idx2,:);

subplot(2,3,[1 4]), hold on
imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
axis xy, ylabel('# deltas detected on sup'), hold on
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

yyaxis right
y_meancurves = Smooth(y_meancurves ,1);
% y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

yyaxis left
set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
caxis([-1500 3000]),
hb = colorbar('location','eastoutside'); hold on
title('LFP deep layer')


%Deltas on deep - good
subplot(2,3,2), hold on
for ch=1:length(channels)
    hold on, plot(lfp_good.sup{ch}(:,1), lfp_good.sup{ch}(:,2))
end
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
title('mean LFP on detection')
%Deltas on deep - fake
subplot(2,3,5), hold on
for ch=1:length(channels)
    hold on, plot(lfp_fake.sup{ch}(:,1), lfp_fake.sup{ch}(:,2))
end
line([0 0], ylim,'Linewidth',2,'color','k'), hold on

%MUA sup
subplot(2,3,[3 6]), hold on
hold on, h(1)=plot(met_fake.sup(:,1), met_fake.sup(:,2), 'r');
hold on, h(2)=plot(met_good.sup(:,1), met_good.sup(:,2), 'b');
hold on, h(3)=plot(met_all.sup(:,1), met_all.sup(:,2), 'color',[0.6 0.6 0.6]);
line([0 0], ylim,'Linewidth',2,'color','k'), hold on
legend(h,'fake', 'good', 'all'),
title('mean MUA on detection')









