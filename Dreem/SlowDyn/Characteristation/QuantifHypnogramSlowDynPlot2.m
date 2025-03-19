% QuantifHypnogramSlowDynPlot2
% 02.10.2018 KJ
%
% Infos
%   for each night :
%       - Sleep stages stat
%       - Waso - SOL - Sleep Efficiency
%   Scatter Plot    
%
% SEE 
%   QuantifHypnogramSlowDyn QuantifHypnogramSlowDynPlot
%

clear
load(fullfile(FolderSlowDynData,'QuantifHypnogramSlowDyn.mat'))


%%  pool

%age
all_ages = cell2mat(hypno_res.age)';
all_subject = hypno_res.subject;

%sol,waso, sleep efficiency
all_sol = cell2mat(hypno_res.sol)/1e4;
all_waso = cell2mat(hypno_res.waso)/1e4;
all_sleepeff = 100*cell2mat(hypno_res.sleep_efficiency);

c = cell2mat(hypno_res.sleep_efficiency);

%N3 ratio, N3 total, REM total
all_stage_total = cell2mat(hypno_res.stage.total');

all_sleep    = (all_stage_total(:,1)+all_stage_total(:,2)+all_stage_total(:,3)+all_stage_total(:,4))/ 3600e4;

all_N1total   = all_stage_total(:,1)/3600e4;
all_N2total   = all_stage_total(:,2)/3600e4;
all_N3total   = all_stage_total(:,3)/3600e4;
all_REMtotal  = all_stage_total(:,4)/3600e4;
all_Nremtotal = (all_stage_total(:,1)+all_stage_total(:,2)+all_stage_total(:,3)) / 3600e4;

all_n1ratio   = 100 * all_N1total ./ all_sleep;
all_n2ratio   = 100 * all_N2total ./ all_sleep;
all_n3ratio   = 100 * all_N3total ./ all_sleep;
all_REMratio   = 100 * all_REMtotal ./ all_sleep;


%% average per subject

%unique
subject_info = table2cell(unique(table(all_subject', all_ages)));
subject_name = subject_info(:,1);
subject_age  = cell2mat(subject_info(:,2))';

%by subject
sub_sol         = [];
sub_waso        = [];
sub_sleepeff    = [];  
sub_sleep       = [];

sub_N1total     = [];
sub_N2total     = [];
sub_N3total     = [];
sub_REMtotal   = [];
sub_Nremtotal   = [];

sub_n1ratio     = [];
sub_n2ratio     = [];
sub_n3ratio     = [];
sub_REMratio   = [];

% data per subject
for s=1:length(subject_name)
    idx = strcmpi(all_subject, subject_name{s});
    
    sub_sol(s)      = mean(all_sol(idx)); 
    sub_waso(s)     = mean(all_waso(idx)); 
    sub_sleepeff(s) = mean(all_sleepeff(idx));   
    sub_sleep(s)    = mean(all_sleep(idx)); 
    
    sub_N1total(s)      = mean(all_N1total(idx)); 
    sub_N2total(s)      = mean(all_N2total(idx)); 
    sub_N3total(s)      = mean(all_N3total(idx)); 
    sub_REMtotal(s)     = mean(all_REMtotal(idx));
    sub_Nremtotal(s)    = mean(all_Nremtotal(idx)); 
    
    sub_n1ratio(s)      = mean(all_n1ratio(idx)); 
    sub_n2ratio(s)      = mean(all_n2ratio(idx)); 
    sub_n3ratio(s)      = mean(all_n3ratio(idx)); 
    sub_REMratio(s)     = mean(all_REMratio(idx));
    
end



%% fit

%Sleep duration
pfit.sleep_tot = polyfit(subject_age, sub_sleep,1);
yfit.sleep_tot = pfit.sleep_tot(1)*subject_age + pfit.sleep_tot(2);

[rc.sleep_tot, pv.sleep_tot] = corrcoef(subject_age,sub_sleep);

%Sleep efficiency
pfit.sleep_eff = polyfit(subject_age, sub_sleepeff,1);
yfit.sleep_eff = pfit.sleep_eff(1)*subject_age + pfit.sleep_eff(2);

[rc.sleep_eff, pv.sleep_eff] = corrcoef(subject_age,sub_sleepeff);

%WASO
pfit.waso = polyfit(subject_age, sub_waso,1);
yfit.waso = pfit.waso(1)*subject_age + pfit.waso(2);

[rc.waso, pv.waso] = corrcoef(subject_age,sub_waso);

%SOL
pfit.sol = polyfit(subject_age, sub_sol,1);
yfit.sol = pfit.sol(1)*subject_age + pfit.sol(2);

[rc.sol, pv.sol] = corrcoef(subject_age,sub_sol);




%N1 ratio
pfit.n1_ratio = polyfit(subject_age, sub_n1ratio,1);
yfit.n1_ratio = pfit.n1_ratio(1)*subject_age + pfit.n1_ratio(2);

[rc.n1_ratio, pv.n1_ratio] = corrcoef(subject_age,sub_n1ratio);

%N2 ratio
pfit.n2_ratio = polyfit(subject_age, sub_n2ratio,1);
yfit.n2_ratio = pfit.n2_ratio(1)*subject_age + pfit.n2_ratio(2);

[rc.n2_ratio, pv.n2_ratio] = corrcoef(subject_age,sub_n2ratio);

%N3 ratio
pfit.n3_ratio = polyfit(subject_age, sub_n3ratio,1);
yfit.n3_ratio = pfit.n3_ratio(1)*subject_age + pfit.n3_ratio(2);

[rc.n3_ratio, pv.n3_ratio] = corrcoef(subject_age,sub_n3ratio);

%REM ratio
pfit.rem_ratio = polyfit(subject_age, sub_REMratio,1);
yfit.rem_ratio = pfit.rem_ratio(1)*subject_age + pfit.rem_ratio(2);

[rc.rem_ratio, pv.rem_ratio] = corrcoef(subject_age,sub_REMratio);



%% Plot 
sz = 25;
fontsize = 20;
sc_color = [0.3 0.3 0.3];

figure, hold on

%Sleep duration (TST)
subplot(2,2,1), hold on
scatter(subject_age, sub_sleep, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.sleep_tot,'k')
title('Total Sleep Time'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('duration (h)'),

text_info = {['r = ' num2str(round(rc.sleep_tot(1,2),2))],['p = ' num2str(pv.sleep_tot(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.sleep_tot>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Sleep efficiency
subplot(2,2,2), hold on
scatter(subject_age, sub_sleepeff, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.sleep_eff,'k')
title('Sleep efficiency'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('%'),

text_info = {['r = ' num2str(round(rc.sleep_eff(1,2),2))],['p = ' num2str(pv.sleep_eff(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.sleep_eff>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

rc.sleep_eff(1,2)=-0.17
pv.sleep_eff(1,2) = 0.036

%WASO
subplot(2,2,3), hold on
scatter(subject_age, sub_waso, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.waso,'k')
title('Wake after Sleep Onset'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('duration (s)'),

text_info = {['r = ' num2str(round(rc.waso(1,2),2))],['p = ' num2str(pv.waso(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.waso>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%SOL
subplot(2,2,4), hold on
scatter(subject_age, sub_sol, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.sol,'k')
title('Sleep Onset Latency'),
set(gca, 'xtick', 20:10:70, 'ytick',0:1000:3000, 'fontsize',fontsize),
xlabel('age'), ylabel('duration (s)'),

text_info = {['r = ' num2str(round(rc.sol(1,2),2))],['p = ' num2str(pv.sol(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.sol>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end


%% Plot 2
figure, hold on

%N1 ratio
subplot(2,2,1), hold on
scatter(subject_age, sub_n1ratio, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.n1_ratio,'k')
title('N1 %'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('%'),

text_info = {['r = ' num2str(round(rc.n1_ratio(1,2),2))],['p = ' num2str(pv.n1_ratio(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.n1_ratio>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%N2 ratio
subplot(2,2,2), hold on
scatter(subject_age, sub_n2ratio, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.n2_ratio,'k')
title('N2 %'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('%'),

text_info = {['r = ' num2str(round(rc.n2_ratio(1,2),2))],['p = ' num2str(pv.n2_ratio(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.n2_ratio>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%N3 ratio
subplot(2,2,3), hold on
scatter(subject_age, sub_n3ratio, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.n3_ratio,'k')
title('N3 %'),
set(gca, 'xtick', 20:10:70, 'ylim', [0 60], 'fontsize',fontsize),
xlabel('age'), ylabel('%'),

text_info = {['r = ' num2str(round(rc.n3_ratio(1,2),2))],['p = ' num2str(pv.n3_ratio(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.n3_ratio>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%REM ratio
subplot(2,2,4), hold on
scatter(subject_age, sub_REMratio, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.rem_ratio,'k')
title('REM %'),
set(gca, 'xtick', 20:10:70, 'ylim', [0 60], 'fontsize',fontsize),
xlabel('age'), ylabel('%'),

text_info = {['r = ' num2str(round(rc.rem_ratio(1,2),2))],['p = ' num2str(pv.rem_ratio(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.rem_ratio>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end








