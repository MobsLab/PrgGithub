%%FakeSlowWaveOneNightHomeostasis1
% 21.08.2019 KJ
%
% Infos
%   script about real and fake slow waves and homeostasis
%
% see
%    FakeSlowWaveOneNight1 FakeSlowWaveOneNightHomeostasis2





Dir = PathForExperimentsFakeSlowWave;

%% load

% load
p=8;
disp(' ')
disp('****************************************************************')
cd(Dir.path{p})
disp(pwd)

clearvars -except Dir p

%raster
load('RasterLFPDeltaWaves.mat','deltadeep', 'deltasup', 'ch_deep', 'ch_sup') 

%hemisphere
if strcmpi(Dir.name{p},'Mouse508')
    hsp='_r';
elseif strcmpi(Dir.name{p},'Mouse509')
    hsp='_l';
else
    hsp='';
end

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;
%down states
down_PFCx = GetDownStates('area',['PFCx' hsp]);
st_down = Start(down_PFCx);
center_down = (Start(down_PFCx)+End(down_PFCx))/2;
%delta waves
deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
st_deltas = Start(deltas_PFCx);
center_deltas = (Start(deltas_PFCx)+End(deltas_PFCx))/2;
%local detection
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
eval(['DeltaDeep = delta_ch_' num2str(ch_deep) ';'])
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
eval(['DeltaSup = delta_ch_' num2str(ch_sup) ';'])

delta_deep = Restrict(ts(Start(DeltaDeep)), NREM);
delta_sup = Restrict(ts(Start(DeltaSup)), NREM);
deltadeep_tmp = Range(delta_deep);
deltasup_tmp = Range(delta_sup);

%night duration
load('IdFigureData2.mat', 'night_duration')

%LFP
load(['LFPData/LFP' num2str(ch_deep) '.mat'])
PFCdeep = LFP; clear LFP
load(['LFPData/LFP' num2str(ch_sup) '.mat'])
PFCsup = LFP; clear LFP


%% good and fake

%delta deep>PFCsup
nb_sample = round(length(deltadeep_tmp)/4);

raster_tsd = deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);

vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
[~, idx1] = sort(vmean1);


sort_deep{1} = sort(deltadeep_tmp(idx1(end-nb_sample+1:end)));%fake
sort_deep{2} = sort(deltadeep_tmp(idx1(2*nb_sample+1:3*nb_sample)));
sort_deep{3} = sort(deltadeep_tmp(idx1(nb_sample+1:2*nb_sample)));
sort_deep{4} = sort(deltadeep_tmp(idx1(1:nb_sample)));%good

%delta sup>PFCdeep
nb_sample = round(length(deltasup_tmp)/4);

raster_tsd = deltasup.deep;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
[~, idx2] = sort(vmean2);


sort_sup{1} = sort(deltasup_tmp(idx2(1:nb_sample)));%good
sort_sup{2} = sort(deltasup_tmp(idx2(nb_sample+1:2*nb_sample)));
sort_sup{3} = sort(deltasup_tmp(idx2(2*nb_sample+1:3*nb_sample)));
sort_sup{4} = sort(deltasup_tmp(idx2(end-nb_sample+1:end)));%fake


%% Density curves

for i=1:4
    [x_density.deep{i}, y_density.deep{i}] = DensityCurves_KJ(ts(sort_deep{i}), 'endtime',night_duration, 'smoothing', 2);
    [x_density.sup{i}, y_density.sup{i}] = DensityCurves_KJ(ts(sort_sup{i}), 'endtime',night_duration, 'smoothing', 2);
    
    y_density.deep{i} = y_density.deep{i}*4;
    y_density.sup{i} = y_density.sup{i}*4;
    
end

[x_density.down, y_density.down] = DensityCurves_KJ(ts(st_down), 'endtime',night_duration, 'smoothing', 2);

%% Plot

xd = x_density.down/3600e4;
d_down  = y_density.down;


%deep
figure, hold on


for i=1:4
    subplot(4,1,i), hold on
    d_delta = y_density.deep{i};
    
    %regression
    idx_down = d_down > max(d_down)/8;
    idx_delta = d_delta > max(d_delta)/8;

    [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
    reg_down    = polyval(p_down,xd);
    [p_delta,~] = polyfit(xd(idx_delta), d_delta(idx_delta), 1);
    reg_delta   = polyval(p_delta,xd);

    clear h
    h(1) = plot(xd, d_down, 'color', [0.6 0.6 0.6]); hold on
    plot(xd, reg_down, 'color', [0.6 0.6 0.6]), hold on
    h(2) = plot(xd, d_delta, 'color', 'k'); hold on
    plot(xd, reg_delta, 'color', 'k'),
    set(gca, 'XTickLabel',{''}), hold on
    legend(h, 'down', 'delta'),
    ylabel('per sec'),

    y_lim = get(gca,'ylim'); y_lim(1)=0;
    ylim(y_lim); set(gca,'yticklabel',0.5:0.5:1.5)
    title(['Homeostasis for Delta group ' num2str(i) ' and down'])

    
end
%suplabel
suplabel([Dir.name{p} ' - ' Dir.date{p} ' (deltas on deep)'], 't');



%Sup
figure, hold on

for i=1:4
    subplot(4,1,i), hold on
    d_delta = y_density.sup{i};
    
    %regression
    idx_down = d_down > max(d_down)/8;
    idx_delta = d_delta > max(d_delta)/8;

    [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
    reg_down    = polyval(p_down,xd);
    [p_delta,~] = polyfit(xd(idx_delta), d_delta(idx_delta), 1);
    reg_delta   = polyval(p_delta,xd);

    clear h
    h(1) = plot(xd, d_down, 'color', [0.6 0.6 0.6]); hold on
    plot(xd, reg_down, 'color', [0.6 0.6 0.6]), hold on
    h(2) = plot(xd, d_delta, 'color', 'k'); hold on
    plot(xd, reg_delta, 'color', 'k'),
    set(gca, 'XTickLabel',{''}), hold on
    legend(h, 'down', 'delta'),
    ylabel('per sec'),

    y_lim = get(gca,'ylim'); y_lim(1)=0;
    ylim(y_lim); set(gca,'yticklabel',0.5:0.5:1.5)
    title(['Homeostasis for Delta group ' num2str(i) ' and down'])
    
    
end
%suplabel
suplabel([Dir.name{p} ' - ' Dir.date{p} ' (Sup)'], 't');









