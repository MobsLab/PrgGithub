% NumberDeltaBeginning
% 10.02.2017 KJ
%
% quantify the number of delta at the first sessions
%   density and number of delta, duration
%
% see 
%   QuantifNumberDelta NumberDeltaBeginning2
%  


%% load
clear
load([FolderProjetDelta 'Data/NumberDeltaPerRecord.mat']) 


%% params
manipes =  unique(deltanumber_res.manipe);
animals = unique(deltanumber_res.name);
session_ind=1;

% conditions
conditions = unique(deltanumber_res.condition);
colori = {'k','b',[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'};

%reformat session times
for p=1:length(deltanumber_res.name)
    deltanumber_res.session_time{p} = deltanumber_res.session_time{p}/(3600E4);
end
deltanumber_res.session_time = deltanumber_res.session_time';

%first hours baseline
first_numbers = cell2mat(deltanumber_res.session(:,1));
for p=1:length(deltanumber_res.name)
    first_duration(p) = deltanumber_res.session_time{p}(1,2) - deltanumber_res.session_time{p}(1,1);
end
first_density = first_numbers ./ first_duration';
good_paths = first_density>1300 & first_density<3500;
good_paths = first_density>0;

%all durations
durations_all = nan(length(deltanumber_res.name),5);
for p=1:length(deltanumber_res.name)
    dur = deltanumber_res.session_time{p}(:,2) - deltanumber_res.session_time{p}(:,1);
    durations_all(p,:) = dur';
    
end


%% DATA
for cond=1:length(conditions)
    path_cond = find(strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths');
    number_delta{cond} = cell2mat(deltanumber_res.session(path_cond,session_ind));
    for p=1:length(path_cond)
        start_rec{cond}(p) = deltanumber_res.session_time{path_cond(p)}(session_ind,1);
        session_duration{cond}(p) = deltanumber_res.session_time{path_cond(p)}(session_ind,2) - deltanumber_res.session_time{path_cond(p)}(session_ind,1);
    end
end
path_cond = find(strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths');
number_delta{end+1} = cell2mat(deltanumber_res.session(path_cond,session_ind));
start_rec{end+1}=[];
session_duration{end+1}=[];
for p=1:length(path_cond)
    start_rec{end}(p) = deltanumber_res.session_time{path_cond(p)}(session_ind,1);
    session_duration{end}(p) = deltanumber_res.session_time{path_cond(p)}(session_ind,2) - deltanumber_res.session_time{path_cond(p)}(session_ind,1);
end
legends = conditions;
legends{end+1} = 'DeltaToneAll';


%% Plot

figure, hold on
scattersize = 25;

%Number of delta
subplot(2,2,1),hold on
for cond=1:length(number_delta)
    scatter(start_rec{cond},number_delta{cond},scattersize,colori{cond},'filled'), hold on
end
legend(legends)
y_lim = get(gca,'YLim'); x_lim = get(gca,'XLim');
line(x_lim, [3000 3000],'LineStyle',':'), hold on
xlabel('Start time (h)'); ylabel('Number of Delta');
t = title('Number of delta');
set(t, 'FontSize', 8);

%Density of delta
subplot(2,2,3),hold on
for cond=1:length(number_delta)-1
    scatter(start_rec{cond},number_delta{cond}./session_duration{cond}',scattersize,colori{cond},'filled'), hold on
end
legend(legends)
y_lim = get(gca,'YLim'); x_lim = get(gca,'XLim');
line(x_lim, [1484 1484],'LineStyle',':'), hold on
line(x_lim, [3441 3441],'LineStyle',':'), hold on
xlabel('Start time (h)'); ylabel('delta waves per hour');
t = title('Density of delta');
set(t, 'FontSize', 8);

%Duration
subplot(2,2,2),hold on
for cond=1:length(number_delta)
    scatter(start_rec{cond},session_duration{cond}*60,scattersize,colori{cond},'filled'), hold on
end
legend(legends)
y_lim = get(gca,'YLim'); x_lim = get(gca,'XLim');
line(x_lim, [100 100],'LineStyle',':'), hold on
xlabel('Start time (h)'); ylabel('session duration (min)');
t = title('Session duration');
set(t, 'FontSize', 8);

%Duration
subplot(2,2,4),hold on
for cond=1:length(number_delta)
    scatter(session_duration{cond}*60, number_delta{cond}./session_duration{cond}',scattersize,colori{cond},'filled'), hold on
end
legend(legends)
xlabel('session duration (min)'); ylabel('delta waves per hour');
t = title('Session duration vs Density');
set(t, 'FontSize', 8);

suplabel(['Session' num2str(session_ind)],'t');





