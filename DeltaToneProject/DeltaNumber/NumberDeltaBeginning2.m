% NumberDeltaBeginning2
% 10.02.2017 KJ
%
% quantify the number of delta at the first sessions
%   density and number of delta, duration
%
% see 
%   QuantifNumberDelta NumberDeltaBeginning QuantifNumberDeltaPlot
%  



%% load
clear
load([FolderProjetDelta 'Data/NumberDeltaPerRecord.mat']) 


%% params
show_sig = 'sig'; % none or sig or all or ns
colori = {'k','b',[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'}; %condition colors
optiontest='ttest'; % ranksum or ttest

manipes =  unique(deltanumber_res.manipe);
animals = unique(deltanumber_res.name);
session_ind=1;

% conditions
conditions = unique(deltanumber_res.condition);

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
%good_paths = first_density>0;


%% DATA
%basal-rdm-t140-t200-t320-t490
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

for cond=1:length(number_delta)
    density_delta{cond} = number_delta{cond}./session_duration{cond}';
end


%% plot
figure, hold on
PlotErrorBarN_KJ(density_delta, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
ylabel('Number of Delta waves'),
set(gca, 'XTickLabel',legends, 'XTick',1:numel(legends)), hold on,
title('Session1')














