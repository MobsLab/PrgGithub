% QuantifSlowWaveSlowDynPlot2
% 02.10.2018 KJ
%
% Infos
%   for each night :
%       - number of slow waves
%       - density
%       - distribution in substages
%       - slope
%   Scatter Plot 
%       
%
% SEE 
%   QuantifSlowWaveSlowDyn QuantifSlowWaveSlowDynPlot QuantifHypnogramSlowDynPlot2
%

clear
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'))

%%  pool

%age&subjects
all_ages = cell2mat(quantif_res.age);
all_subject = quantif_res.subject;

%night variable
all_densityslope = cell2mat(quantif_res.density_slope);
all_nbslowwaves  = cell2mat(quantif_res.nb_slowwaves);
all_nightdur     = cell2mat(quantif_res.night_duration)/1e4;
all_swdensity    = all_nbslowwaves ./ (all_nightdur/60); %per min   
all_isistd       = cell2mat(quantif_res.isi_std);

%isi
all_isipeak = [];
for p=1:length(quantif_res.filename)    
    y_isi = quantif_res.y_isi{p}(quantif_res.x_isi{p}<2000);
    %peak
    [~,idx] = max(Smooth(y_isi,1));
    all_isipeak(p) = quantif_res.x_isi{p}(idx);
    %std
    [~,idx] = max(Smooth(y_isi,1));
    
end

%others
all_slopes = [];
all_durations = [];
all_peak = [];
all_trough = [];
for p=1:length(quantif_res.filename)
    all_slopes(p) = nanmedian(quantif_res.slopes{p});
    all_durations(p) = nanmedian(quantif_res.durations{p})/10;
    all_peak(p) = nanmedian(quantif_res.amplitude.peak{p});
    all_trough(p) = nanmedian(quantif_res.amplitude.trough{p});
end


%% average per subject

%unique
subject_info = table2cell(unique(table(all_subject', all_ages')));
subject_name = subject_info(:,1);
subject_age  = cell2mat(subject_info(:,2))';

%by subject
sub_densityslope    = [];
sub_nbslowwaves     = [];
sub_swdensity       = [];  
sub_isipeak         = [];
sub_isistd          = [];
sub_slopes      = [];
sub_durations   = [];
sub_peak        = [];
sub_trough      = [];

% data per subject
for s=1:length(subject_name)
    idx = strcmpi(all_subject, subject_name{s});
    
    sub_densityslope(s) = mean(all_densityslope(idx)); 
    sub_nbslowwaves(s)  = mean(all_nbslowwaves(idx)); 
    sub_swdensity(s)    = mean(all_swdensity(idx));   
    sub_isipeak(s)      = mean(all_isipeak(idx)); 
    sub_isistd(s)       = mean(all_isistd(idx));  
    
    sub_slopes(s)       = mean(all_slopes(idx)); 
    sub_durations(s)    = mean(all_durations(idx)); 
    sub_peak(s)         = mean(all_peak(idx)); 
    sub_trough(s)       = mean(all_trough(idx)); 
    
end



%% fit

   
%Trough of slow waves
pfit.trough = polyfit(subject_age, sub_trough,1);
yfit.trough = pfit.trough(1)*subject_age + pfit.trough(2);

[rc.trough, pv.trough] = corrcoef(subject_age,sub_trough);

%Slow waves peak amplitude
pfit.peak = polyfit(subject_age, sub_peak,1);
yfit.peak = pfit.peak(1)*subject_age + pfit.peak(2);

[rc.peak, pv.peak] = corrcoef(subject_age,sub_peak);

%Slow waves Width
pfit.durations = polyfit(subject_age, sub_durations,1);
yfit.durations = pfit.durations(1)*subject_age + pfit.durations(2);

[rc.durations, pv.durations] = corrcoef(subject_age,sub_durations);

%Slow waves slopes
pfit.slopes = polyfit(subject_age, sub_slopes,1);
yfit.slopes = pfit.slopes(1)*subject_age + pfit.slopes(2);

[rc.slopes, pv.slopes] = corrcoef(subject_age,sub_slopes);



%number of slow waves
pfit.nbslowwaves = polyfit(subject_age, sub_nbslowwaves,1);
yfit.nbslowwaves = pfit.nbslowwaves(1)*subject_age + pfit.nbslowwaves(2);

[rc.nbslowwaves, pv.nbslowwaves] = corrcoef(subject_age,sub_nbslowwaves);

%density of slow waves
pfit.swdensity = polyfit(subject_age, sub_swdensity,1);
yfit.swdensity = pfit.swdensity(1)*subject_age + pfit.swdensity(2);

[rc.swdensity, pv.swdensity] = corrcoef(subject_age,sub_swdensity);

%Density slope
pfit.densityslope = polyfit(subject_age, sub_densityslope,1);
yfit.densityslope = pfit.densityslope(1)*subject_age + pfit.densityslope(2);

[rc.densityslope, pv.densityslope] = corrcoef(subject_age,sub_densityslope);

%ISI peak
pfit.isipeak = polyfit(subject_age, sub_isipeak,1);
yfit.isipeak = pfit.isipeak(1)*subject_age + pfit.isipeak(2);

[rc.isipeak, pv.isipeak] = corrcoef(subject_age,sub_isipeak);

%ISI std
pfit.isistd = polyfit(subject_age, sub_isistd,1);
yfit.isistd = pfit.isistd(1)*subject_age + pfit.isistd(2);

[rc.isistd, pv.isistd] = corrcoef(subject_age,sub_isistd);


%% Plot
sz = 25;
fontsize = 20;
sc_color = [0.3 0.3 0.3];

figure, hold on

%Trough of slow waves
subplot(2,2,1), hold on
scatter(subject_age, sub_trough, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.trough,'k')
title('Negative amplitude of slow waves'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('amplitude (µv)'),

text_info = {['r = ' num2str(rc.trough(1,2))],['p = ' num2str(pv.trough(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.trough>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Slow waves peak amplitude
subplot(2,2,2), hold on
scatter(subject_age, sub_peak, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.peak,'k')
title('Positive amplitude of slow waves'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('amplitude (µv)'),

text_info = {['r = ' num2str(rc.peak(1,2))],['p = ' num2str(pv.peak(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.peak>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Slow waves Width
subplot(2,2,3), hold on
scatter(subject_age, sub_durations, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.durations,'k')
title('Width of slow waves'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('duration (ms)'),

text_info = {['r = ' num2str(rc.durations(1,2))],['p = ' num2str(pv.durations(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.durations>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Slow waves slopes
subplot(2,2,4), hold on
scatter(subject_age, sub_slopes, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.slopes,'k')
title('Slopes of slow waves'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('µV/s'),

text_info = {['r = ' num2str(rc.slopes(1,2))],['p = ' num2str(pv.slopes(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.slopes>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end



%% Plot 2
sz = 25;
figure, hold on

%number of slow waves
subplot(2,2,1), hold on
scatter(subject_age, sub_nbslowwaves, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.nbslowwaves,'k')
title('Number of slow waves'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('number of slow-waves'),

text_info = {['r = ' num2str(rc.nbslowwaves(1,2))],['p = ' num2str(pv.nbslowwaves(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.nbslowwaves>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%density of slow waves
subplot(2,2,2), hold on
scatter(subject_age, sub_swdensity, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.swdensity,'k')
title('Density of slow waves'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('slow-wave per min'),

text_info = {['r = ' num2str(rc.swdensity(1,2))],['p = ' num2str(pv.swdensity(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.swdensity>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Density slope
subplot(2,2,3), hold on
scatter(subject_age, sub_densityslope, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.densityslope,'k')
title('Slope of SW density'),
set(gca, 'xtick', 20:10:70, 'ylim',[-6 3], 'fontsize',fontsize),
xlabel('age'), ylabel('density slope (min^-^1.h^-^1)'),

text_info = {['r = ' num2str(rc.densityslope(1,2))],['p = ' num2str(pv.densityslope(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.densityslope>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%ISI std
subplot(2,2,4), hold on
scatter(subject_age, sub_isistd, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.isistd,'k')
title('SEM of ISI'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('sem of the ISI (s)'),

text_info = {['r = ' num2str(rc.isistd(1,2))],['p = ' num2str(pv.isistd(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.isistd>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%ISI peak
subplot(2,2,2), hold on
scatter(subject_age, sub_isipeak, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.isipeak,'k')
title('Peak of ISI'),
set(gca, 'xtick', 20:10:70, 'ylim',[700 1800], 'ytick',0:250:2000, 'fontsize',fontsize),
xlabel('age'), ylabel('peak of the ISI (s)'),

text_info = {['r = ' num2str(rc.isipeak(1,2))],['p = ' num2str(pv.isipeak(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.isipeak>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end


%% Plot 3
sz = 25;
figure, hold on


%ISI std
subplot(2,2,1), hold on
scatter(subject_age, sub_isistd, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.isistd,'k')
title('SEM of ISI'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('sem of the ISI (s)'),

text_info = {['r = ' num2str(rc.isistd(1,2))],['p = ' num2str(pv.isistd(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.isistd>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%ISI peak
subplot(2,2,2), hold on
scatter(subject_age, sub_isipeak, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.isipeak,'k')
title('Peak of ISI'),
set(gca, 'xtick', 20:10:70, 'ylim',[700 1800], 'ytick',0:250:2000, 'fontsize',fontsize),
xlabel('age'), ylabel('peak of the ISI (s)'),

text_info = {['r = ' num2str(rc.isipeak(1,2))],['p = ' num2str(pv.isipeak(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.isipeak>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end






