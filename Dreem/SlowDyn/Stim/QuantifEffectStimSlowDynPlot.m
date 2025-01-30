% QuantifEffectStimSlowDynPlot
% 02.10.2018 KJ
%
% Infos
%   for each night :
%       - effect of stim
%       - success ratio
%
% SEE 
%   QuantifEffectStimSlowDyn
%

clear
load(fullfile(FolderSlowDynData,'QuantifEffectStimSlowDyn.mat'))

%% init

%params
step = 10;
age_range = [20:step:50 90];
show_sig = 'sig';
showPoints = 1;

%colors
colori = [distinguishable_colors(length(age_range)-1)];
for i=1:length(age_range)-1
    colori_age{i} = colori(i,:);
end

%labels
for i=1:length(age_range)-2
    labels{i} = [num2str(age_range(i)) '-' num2str(age_range(i+1))]; 
end
labels{length(age_range)-1} = ['>' num2str(age_range(end-1))];



%%  pool

%age
all_ages = cell2mat(stim_res.age);
all_subject = stim_res.subject;

%data
all_nbstim  = cell2mat(stim_res.nb_stim);
all_success = cell2mat(stim_res.nb_success);
all_rate    = 100*cell2mat(stim_res.success_rate);


%% average per subject

%unique
subject_info = table2cell(unique(table(all_subject', all_ages')));
subject_name = subject_info(:,1);
subject_age  = cell2mat(subject_info(:,2))';

%by subject
sub_nbstim    = [];
sub_success     = [];
sub_rate       = [];  

% data per subject
for s=1:length(subject_name)
    idx = strcmpi(all_subject, subject_name{s});
    
    sub_nbstim(s) = nanmean(all_nbstim(idx)); 
    sub_success(s)  = nanmean(all_success(idx)); 
    sub_rate(s)    = nanmean(all_rate(idx));   
end



%% fit

%clean for fit
sub_nbstim(isnan(sub_success))  = [];
sub_rate(isnan(sub_success))    = [];
subject_age(isnan(sub_success))    = [];
sub_success(isnan(sub_success)) = [];


%Number of stim
pfit.nb_stim = polyfit(subject_age, sub_nbstim,1);
yfit.nb_stim = pfit.nb_stim(1)*subject_age + pfit.nb_stim(2);

[rc.nb_stim, pv.nb_stim] = corrcoef(subject_age,sub_nbstim);

%Number of stim success
pfit.nb_success = polyfit(subject_age, sub_success,1);
yfit.nb_success = pfit.nb_success(1)*subject_age + pfit.nb_success(2);

[rc.nb_success, pv.nb_success] = corrcoef(subject_age,sub_success);

%Rate success
pfit.success_rate = polyfit(subject_age, sub_rate,1);
yfit.success_rate = pfit.success_rate(1)*subject_age + pfit.success_rate(2);

[rc.success_rate, pv.success_rate] = corrcoef(subject_age,sub_rate);


%% Plot
figure, hold on
sz=25;

%Number of stim
subplot(2,2,1), hold on
scatter(subject_age, sub_nbstim, sz, 'filled'), hold on
plot(subject_age, yfit.nb_stim,'r-.')
xlabel('age'), title('Number of stim'),
set(gca, 'ylim',[0 600],'ytick', 0:200:800, 'fontsize', 24),

text_info = {['r = ' num2str(round(rc.nb_stim(1,2),2))],['p = ' num2str(pv.nb_stim(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.nb_stim>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end


%Rate success
subplot(2,2,2), hold on
scatter(subject_age, sub_rate, sz, 'filled'), hold on
plot(subject_age, yfit.success_rate,'r-.')
xlabel('age'), title('Success %'),
set(gca, 'ylim',[0 60],'ytick', 0:20:100, 'fontsize', 24),

text_info = {['r = ' num2str(round(rc.success_rate(1,2),2))],['p = ' num2str(pv.success_rate(1,2))]};
x_lim = xlim; y_lim = ylim;
if pv.success_rate>0.05
    text(x_lim(2), y_lim(1), text_info, 'fontsize',16),
else
    text(x_lim(2), y_lim(1), text_info, 'fontsize',18,'fontweight','bold'),
end









