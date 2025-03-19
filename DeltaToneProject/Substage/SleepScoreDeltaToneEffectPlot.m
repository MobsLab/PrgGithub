% SleepScoreDeltaToneEffectPlot
% 04.10.2017 KJ
%
% - Plot the difference between sleep score
%
%
% See 
%   QuantitySleepDelta SleepScoreDeltaToneEffect FigureSleepArchitectureChangeED3C
%
%



clear

%% INPUT

newfig=1;
show_sig = 'sig';
optiontest='ranksum';
paired=0;

% index and timescales
scoring_types = {'true','add','remove'};
idx_plot = 1:5;

%params
NameSubstages={'N1','N2','N3','REM','Wake','NREM'};
colori = {'k','k','k',[0.75 0.75 0.75],[0.75 0.75 0.75],[0.75 0.75 0.75],[70 180 10]/255,[70 180 10]/255,[70 180 10]/255};


%% load
load([FolderProjetDelta 'Data/SleepScoreDeltaToneEffect.mat']) 
animals = unique(scoring_res.name);
conditions = unique(scoring_res.condition);
conditions = conditions(1:2);

labels = {'Basal','Basal+','Basal-', 'Random','Random+','Random-', 'Delta-triggered','Delta-triggered+','Delta-triggered-'};

%% stages
stages_num = 2;
stages_den = 6;

if stages_num==0 %whole record
    stages_num = 1:5;
elseif isequal(stages_num,1:4)% Whole Sleep
    maintitle = 'Sleep';
else
    maintitle = strjoin(NameSubstages(stages_num), ' + '); 
end

ratio=1; y_label = '%';
if stages_den==-1 %no ratio
    ratio=0;
    y_label = 'Duration (s)';
elseif stages_den==0 %whole record
    stages_den = 1:5;
    maintitle = ['Percentage of ' maintitle];
elseif isequal(stages_den,1:4)% Whole Sleep
    maintitle = ['Percentage of ' maintitle ' / Sleep'];
else
    maintitle = ['Percentage (' maintitle ') / (' strjoin(NameSubstages(stages_den), ' + ') ')'];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

column_test = [1 2; 2 3; 1 3];
column_test = [column_test; column_test + 3; column_test + 6];

%non_paired, on all nights
if paired==0
    for st=1:length(scoring_types)
        for cond=1:length(conditions)
            path_cond = find(strcmpi(scoring_res.condition,conditions{cond}));
            for p=1:length(path_cond)
                data_num = sum(sum(scoring_res.substages.(scoring_types{st}){path_cond(p)}(idx_plot,stages_num)));
                if ratio
                    data_den = sum(sum(scoring_res.substages.(scoring_types{st}){path_cond(p)}(idx_plot,stages_den)));
                else
                    data_den = 1E4; %in sec
                end
                data{cond,st}(p) = 100 * data_num / data_den;
            end
        end
        path_cond = find(strcmpi(scoring_res.manipe,'DeltaToneAll') & cell2mat(scoring_res.delay)>0); %DeltaToneAll
        for p=1:length(path_cond)
            data_num = sum(sum(scoring_res.substages.(scoring_types{st}){path_cond(p)}(idx_plot,stages_num)));
            if ratio
                data_den = sum(sum(scoring_res.substages.(scoring_types{st}){path_cond(p)}(idx_plot,stages_den)));
            else
                data_den = 1E4; %in sec
            end
            data{length(conditions)+1,st}(p) = 100 * data_num / data_den;
        end
    end

    %format data
    dataplot = [data(1,1:3) data(2,1:3) data(3,1:3)];
    %plot
    PlotErrorBarN_KJ(dataplot, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest,'columntest',column_test);
    ylabel(y_label), xlim([0.5 9.5]),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30,'FontName','Times','fontsize',20), hold on,
    title(maintitle)


%paired, on mice
else
    data = nan(length(animals), length(conditions), length(scoring_types));
    for st=1:length(scoring_types)
        for m=1:length(animals)
            for cond=1:length(conditions)
                selected_paths = find(strcmpi(scoring_res.condition,conditions{cond}) .* strcmpi(scoring_res.name,animals{m}));

                mouse_data = [];
                for p=1:length(selected_paths)
                    data_num = sum(sum(scoring_res.substages.(scoring_types{st}){selected_paths(p)}(idx_plot,stages_num)));
                    if ratio
                        data_den = sum(sum(scoring_res.substages.(scoring_types{st}){selected_paths(p)}(idx_plot,stages_den)));
                    else
                        data_den = 1E4; %in sec
                    end
                    mouse_data = [mouse_data 100*data_num/data_den];
                end
                data(m,cond,st) = mean(mouse_data);
            end

            selected_paths = find(strcmpi(scoring_res.manipe,'DeltaToneAll') & cell2mat(scoring_res.delay)>0 & strcmpi(scoring_res.name,animals{m})); %DeltaToneAll
            mouse_data = [];
            for p=1:length(selected_paths)
                data_num = sum(sum(scoring_res.substages.(scoring_types{st}){selected_paths(p)}(idx_plot,stages_num)));
                if ratio
                    data_den = sum(sum(scoring_res.substages.(scoring_types{st}){selected_paths(p)}(idx_plot,stages_den)));
                else
                    data_den = 1E4; %in sec
                end
                mouse_data = [mouse_data 100*data_num/data_den];
            end
            data(m,length(conditions)+1,st) = mean(mouse_data);
        end
    end

    
    %format data
    dataplot = [squeeze(data(:,1,1:3)) squeeze(data(:,2,1:3)) squeeze(data(:,3,1:3))];
    %plot
    PlotErrorBarN_KJ(dataplot, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
    ylabel(y_label), xlim([0.5 9.5]),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30,'FontName','Times','fontsize',20), hold on,
    title([maintitle ' (' num2str(length(animals)) ' mice)'])
end














    
