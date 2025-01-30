% QuantifHypnogramSlowDynPlot
% 15.09.2018 KJ
%
% Infos
%   for each night :
%       - Sleep stages stat
%       - Waso - SOL - Sleep Efficiency
%       
%
% SEE 
%   QuantifHypnogramSlowDyn QuantifHypnogramSlowDynPlot2
%

clear
load(fullfile(FolderSlowDynData,'QuantifHypnogramSlowDyn.mat'))

%% init

%params
age_range = [20 30 40 50 90];
show_sig = 'sig';
showPoints = 1;

%colors
colori = [distinguishable_colors(length(age_range)-1)];
for i=1:length(age_range)-1
    colori_cluster{i} = colori(i,:);
end

%labels
for i=1:length(age_range)-2
    labels{i} = [num2str(age_range(i)) '-' num2str(age_range(i+1))]; 
end
labels{length(age_range)-1} = ['>' num2str(age_range(end-1))];


%%  pool

%age
all_ages = cell2mat(hypno_res.age);

%sol,waso, sleep efficiency
all_sol = cell2mat(hypno_res.sol)/1e4;
all_waso = cell2mat(hypno_res.waso);
all_sleepeff = cell2mat(hypno_res.sleep_efficiency);

%N3 ratio, N3 total, REM total
all_stage_total = cell2mat(hypno_res.stage.total');

all_sleep    = (all_stage_total(:,1)+all_stage_total(:,2)+all_stage_total(:,3)+all_stage_total(:,4))/ 1e4;

all_N3total   = all_stage_total(:,3)/1e4;
all_REMtotal  = all_stage_total(:,4)/1e4;
all_Nremtotal = (all_stage_total(:,1)+all_stage_total(:,2)+all_stage_total(:,3)) / 1e4;
all_n3ratio   = 100 * all_N3total ./ all_sleep;



%% data by range
for i=1:length(age_range)-1
    idx = all_ages>=age_range(i)&all_ages<age_range(i+1);
    
    sol_data{i}      = all_sol(idx);
    waso_data{i}     = all_waso(idx);
    sleepeff_data{i} = all_sleepeff(idx);
    
    totN3_data{i}   = all_N3total(idx);
    totREM_data{i}  = all_REMtotal(idx);
    ratioN3_data{i} = all_n3ratio(idx);
    
end


%% Plot
figure, hold on

%sol
subplot(2,3,1), hold on
PlotErrorBarN_KJ(sol_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Sleep onset latency'),

%waso
subplot(2,3,2), hold on
PlotErrorBarN_KJ(waso_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Wake after sleep onset'),

%sleep efficiency
subplot(2,3,3), hold on
PlotErrorBarN_KJ(sleepeff_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Sleep efficiency'),

%total N3
subplot(2,3,4), hold on
PlotErrorBarN_KJ(totN3_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Amount of n3'),

%Ratio N3
subplot(2,3,5), hold on
PlotErrorBarN_KJ(ratioN3_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('% N3'),

%total REM
subplot(2,3,6), hold on
PlotErrorBarN_KJ(totREM_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Amount of REM'),



