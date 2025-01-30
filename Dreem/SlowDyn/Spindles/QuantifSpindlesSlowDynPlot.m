% QuantifSpindlesSlowDynPlot
% 20.11.2018 KJ
%
% Infos
%   for each night :
%       - number of spindles
%       - density and homeostasis
%       - distribution in substages
%   Scatter Plot 
%       
%
% SEE 
%   QuantifSpindlesSlowDyn QuantifSlowWaveSlowDynPlot2
%

clear
load(fullfile(FolderSlowDynData,'QuantifSpindlesSlowDyn.mat'))

%%  pool

%age&subjects
all_ages = cell2mat(quantif_res.age);
all_subject = quantif_res.subject;

%night variable
all_densityslope = cell2mat(quantif_res.density_slope);
all_nbspindles  = cell2mat(quantif_res.nb_spindles);
all_nightdur     = cell2mat(quantif_res.night_duration)/1e4;
all_swdensity    = all_nbspindles ./ (all_nightdur/60); %per min   
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


%% average per subject

%unique
subject_info = table2cell(unique(table(all_subject', all_ages')));
subject_name = subject_info(:,1);
subject_age  = cell2mat(subject_info(:,2))';

%by subject
sub_densityslope    = [];
sub_nbspindles     = [];
sub_swdensity       = [];  
sub_isipeak         = [];
sub_isistd          = [];

% data per subject
for s=1:length(subject_name)
    idx = strcmpi(all_subject, subject_name{s});
    
    sub_densityslope(s) = mean(all_densityslope(idx)); 
    sub_nbspindles(s)  = mean(all_nbspindles(idx)); 
    sub_swdensity(s)    = mean(all_swdensity(idx));   
    sub_isipeak(s)      = mean(all_isipeak(idx)); 
    sub_isistd(s)       = mean(all_isistd(idx));  
    
end



%% fit


%number of spindles
pfit.nbspindles = polyfit(subject_age, sub_nbspindles,1);
yfit.nbspindles = pfit.nbspindles(1)*subject_age + pfit.nbspindles(2);

[rc.nbspindles, pv.nbspindles] = corrcoef(subject_age,sub_nbspindles);

%density of spindles
pfit.swdensity = polyfit(subject_age, sub_swdensity,1);
yfit.swdensity = pfit.swdensity(1)*subject_age + pfit.swdensity(2);

[rc.swdensity, pv.swdensity] = corrcoef(subject_age,sub_swdensity);

%Density slope
subject_age2 = subject_age;
subject_age2(isnan(sub_densityslope))=[];
sub_densityslope(isnan(sub_densityslope))=[];

pfit.densityslope = polyfit(subject_age2, sub_densityslope,1);
yfit.densityslope = pfit.densityslope(1)*subject_age2 + pfit.densityslope(2);

[rc.densityslope, pv.densityslope] = corrcoef(subject_age2,sub_densityslope);

%ISI peak
pfit.isipeak = polyfit(subject_age, sub_isipeak,1);
yfit.isipeak = pfit.isipeak(1)*subject_age + pfit.isipeak(2);

[rc.isipeak, pv.isipeak] = corrcoef(subject_age,sub_isipeak);

%ISI std
pfit.isistd = polyfit(subject_age, sub_isistd,1);
yfit.isistd = pfit.isistd(1)*subject_age + pfit.isistd(2);

[rc.isistd, pv.isistd] = corrcoef(subject_age,sub_isistd);


%% Plot 2
sz = 25;
sc_color = [0.3 0.3 0.3];
fontsize = 20;

figure, hold on

%number of spindles
subplot(2,2,1), hold on
scatter(subject_age, sub_nbspindles, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.nbspindles,'k')
title('Number of spindles'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('number of spindles'),

text_info = {['r = ' num2str(rc.nbspindles(1,2))],['p = ' num2str(pv.nbspindles(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.nbspindles>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%density of spindles
subplot(2,2,2), hold on
scatter(subject_age, sub_swdensity, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.swdensity,'k')
title('Density of spindles'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('spindles per min'),

text_info = {['r = ' num2str(rc.swdensity(1,2))],['p = ' num2str(pv.swdensity(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.swdensity>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Density slope
subplot(2,2,3), hold on
scatter(subject_age2, sub_densityslope, sz, sc_color, 'filled'), hold on
plot(subject_age2, yfit.densityslope,'k')
title('Slope of spindles density'),
set(gca, 'xtick', 20:10:70, 'ylim', [-2 2], 'fontsize',fontsize),
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

% %ISI peak
% subplot(2,2,4), hold on
% scatter(subject_age, sub_isipeak, sz, sc_color, 'filled'), hold on
% plot(subject_age, yfit.isipeak,'k')
% title('Peak of ISI'),
% set(gca, 'xtick', 20:10:70, 'ylim',[700 1800], 'ytick',0:250:2000, 'fontsize',fontsize),
% xlabel('age'), ylabel('peak of the ISI (s)'),
% 
% text_info = {['r = ' num2str(rc.isipeak(1,2))],['p = ' num2str(pv.isipeak(1,2))]};
% x_lim = xlim; y_lim = ylim;
% if pv.isipeak>0.05
%     text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
% else
%     text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
% end



