%%FakeSlowWaveOneNightHomeostasis2
% 28.06.2019 KJ
%
% Infos
%   script about real and fake slow waves and homeostasis
%
% see
%    FakeSlowWaveOneNight1





clearvars -except fake_res


%% load

% load
p=8;
if ~exist('fake_res','var')
    load(fullfile(FolderDeltaDataKJ,'ParcoursGenerateRasterFakeSlowWave.mat'))
end
cd(fake_res.path{p})

%hemisphere
if strcmpi(fake_res.name{p},'Mouse508')
    hsp='_r';
elseif strcmpi(fake_res.name{p},'Mouse509')
    hsp='_l';
else
    hsp='';
end


%SWS
load SleepScoring_OBGamma.mat SWSEpoch REMEpoch Wake
%down states
down_states = GetDownStates('area',['PFCx' hsp]);
down_tmp = Start(down_states);
%delta waves
deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
deltas_tmp = Start(deltas_PFCx);

%local detection
ch_deep = fake_res.ch_deep{p} ;
ch_sup = fake_res.ch_sup{p} ;
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
eval(['DeltaDeep = delta_ch_' num2str(ch_deep) ';'])
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
eval(['DeltaSup = delta_ch_' num2str(ch_sup) ';'])
delta_deep = fake_res.delta_deep{p};
delta_sup = fake_res.delta_sup{p};
deltadeep_tmp = Range(delta_deep);
deltasup_tmp = Range(delta_sup);

%night duration
load('IdFigureData2.mat', 'night_duration')

%LFP
load(['LFPData/LFP' num2str(ch_deep) '.mat'])
PFCdeep = LFP; clear LFP
load(['LFPData/LFP' num2str(ch_sup) '.mat'])
PFCsup = LFP; clear LFP


%Raster
raster = fake_res.raster{p};


%% good and fake


%delta deep>PFCsup
raster_tsd = raster.deltadeep.sup;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);

vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
[~, idx1] = sort(vmean1,'descend');
nb_sample = round(length(vmean1)/4);
deep_tmp{1} = sort(deltadeep_tmp(idx1(1:nb_sample)));
deep_tmp{2} = sort(deltadeep_tmp(idx1(nb_sample+1:2*nb_sample)));
deep_tmp{3} = sort(deltadeep_tmp(idx1(2*nb_sample+1:3*nb_sample)));
deep_tmp{4} = sort(deltadeep_tmp(idx1(3*nb_sample:end)));


%delta sup>PFCdeep
raster_tsd = raster.deltasup.deep;
Mat = Data(raster_tsd)';
x_tmp = Range(raster_tsd);
vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
[~, idx2] = sort(vmean2);
nb_sample = round(length(vmean2)/4);
sup_tmp{1} = sort(deltasup_tmp(idx2(1:nb_sample)));
sup_tmp{2} = sort(deltasup_tmp(idx2(nb_sample+1:2*nb_sample)));
sup_tmp{3} = sort(deltasup_tmp(idx2(2*nb_sample+1:3*nb_sample)));
sup_tmp{4} = sort(deltasup_tmp(idx2(3*nb_sample:end)));


%% Density curves

for i=1:4
    [x_density.deep{i}, y_density.deep{i}] = DensityCurves_KJ(ts(deep_tmp{i}), 'endtime',night_duration, 'smoothing', 2);
    [x_density.sup{i}, y_density.sup{i}] = DensityCurves_KJ(ts(sup_tmp{i}), 'endtime',night_duration, 'smoothing', 2);
end

[x_density.down, y_density.down] = DensityCurves_KJ(ts(down_tmp), 'endtime',night_duration, 'smoothing', 2);

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
suplabel([fake_res.name{p} ' - ' fake_res.date{p} ' (deltas on deep)'], 't');



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
suplabel([fake_res.name{p} ' - ' fake_res.date{p} ' (Sup)'], 't');









