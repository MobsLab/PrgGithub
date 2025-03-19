% QuantifSlowWaveStartEndSlowDynPlot
% 04.10.2018 KJJ
%
% Infos
%       
%
% SEE 
%   QuantifHypnogramSlowDyn QuantifSlowWaveSlowDyn
%

clear
load(fullfile(FolderSlowDynData,'QuantifSlowWaveStartEndSlowDyn.mat'))

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
all_ages = cell2mat(quantif_res.age);
all_subject = quantif_res.subject;

%start/end
all_start = cell2mat(quantif_res.nb_start);
all_end = cell2mat(quantif_res.nb_end);

%% average per subject

%unique
subject_info = table2cell(unique(table(all_subject', all_ages')));
subject_name = subject_info(:,1);
subject_age  = cell2mat(subject_info(:,2))';

%by subject
sub_start = [];
sub_end   = [];

% data per subject
for s=1:length(subject_name)
    idx = strcmpi(all_subject, subject_name{s});
    
    sub_start(s) = mean(all_start(idx)); 
    sub_end(s)   = mean(all_end(idx)); 
    
end

%% fit

%Slow waves at the start
pfit.start = polyfit(subject_age, sub_start,1);
yfit.start = pfit.start(1)*subject_age + pfit.start(2);

[rc.start, pv.start] = corrcoef(subject_age,sub_start);

%Slow waves at the end
pfit.end = polyfit(subject_age, sub_end,1);
yfit.end = pfit.end(1)*subject_age + pfit.end(2);

[rc.end, pv.end] = corrcoef(subject_age,sub_end);


%% Plot
sz = 25;
fontsize = 20;
sc_color = [0.3 0.3 0.3];

figure, hold on

%Trough of slow waves
subplot(2,2,1), hold on
scatter(subject_age, sub_start, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.start,'k')
title('First 2 hours after sleep onset'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('number of slow waves'),

text_info = {['r = ' num2str(rc.start(1,2))],['p = ' num2str(pv.start(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.start>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end

%Slow waves peak amplitude
subplot(2,2,2), hold on
scatter(subject_age, sub_end, sz, sc_color, 'filled'), hold on
plot(subject_age, yfit.end,'k')
title('Last 2 hours'),
set(gca, 'xtick', 20:10:70, 'fontsize',fontsize),
xlabel('age'), ylabel('number of slow waves'),

text_info = {['r = ' num2str(rc.end(1,2))],['p = ' num2str(pv.end(1,2))]};    
x_lim = xlim; y_lim = ylim;
if pv.end>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end



