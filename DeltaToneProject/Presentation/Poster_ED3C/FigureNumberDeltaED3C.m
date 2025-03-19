% FigureNumberDeltaED3C
% 19.04.2017 KJ
%
% plot the number of delta waves for each conditions
%
%
% see 
%   QuantitySleepDeltaPlot
%  


clear

%% INPUT
density=1;
timescale = 'session';
moment=0;

newfig=1;
show_sig = 'sig';
optiontest='ranksum';
paired=0;


%params
colori = {'k',[0.75 0.75 0.75],[70 180 10]/255};
maintitle = 'Delta waves density';
y_label = 'deltas per hour';
labels = {'Basal', 'Random', 'Delta-triggered'};


%% load
load([FolderProjetDelta 'Data/QuantitySleepDelta.mat']) 

animals = unique(quantity_res.name);
conditions = unique(quantity_res.condition);
conditions = conditions(1:2);


%% index and timescales
if strcmpi(timescale,'hours')
    if moment==0
        idx_plot = hours_expe;
    else
        [~,idx_plot]=intersect(hours_expe,moment);
        maintitle = [maintitle ' | Hours:' num2str(moment)];
    end
elseif strcmpi(timescale,'session')
    if moment==0
        idx_plot = 1:5;
    else
        idx_plot = moment;
        maintitle = [maintitle ' | Sessions:' num2str(moment)];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

all_deltas = cell2mat(quantity_res.deltas.(timescale));

%non_paired, on all nights
if paired==0
    for cond=1:length(conditions)
        path_cond = find(strcmpi(quantity_res.condition,conditions{cond})); 
        for p=1:length(path_cond)
            data{cond}(p) =  sum(all_deltas(path_cond(p),idx_plot));
            if density && strcmpi(timescale,'hours')
                duration = length(idx_plot);
                data{cond}(p) = data{cond}(p) / duration;
            elseif density && strcmpi(timescale,'session')
                duration = quantity_res.session_time{path_cond(p)}(idx_plot,:) / 3600E4;
                duration = sum(duration(:,2) - duration(:,1));
                data{cond}(p) = data{cond}(p) / duration;
            end
        end
    end
    path_cond = find(strcmpi(quantity_res.manipe,'DeltaToneAll')  & cell2mat(quantity_res.delay)>0); %DeltaToneAll
    for p=1:length(path_cond)
        data{length(conditions)+1}(p) =  sum(all_deltas(path_cond(p),idx_plot));
        if density && strcmpi(timescale,'hours')
            duration = length(idx_plot);
            data{length(conditions)+1}(p) = data{length(conditions)+1}(p) / duration;
        elseif density && strcmpi(timescale,'session')
            duration = quantity_res.session_time{path_cond(p)}(idx_plot,:) / 3600E4;
            duration = sum(duration(:,2) - duration(:,1));
            data{length(conditions)+1}(p) = data{length(conditions)+1}(p) / duration;
        end
    end

%     labels = conditions;
%     labels{end+1} = 'DeltaToneAll';

    PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
    ylabel(y_label), xlim([0.5 3.5]),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30,'YTick',[0 1000 2000],'FontName','Times','fontsize',20), hold on,
    title(maintitle)
    

    
%paired, on mice
else
    data = nan(length(animals), length(conditions));
    for m=1:length(animals)
        for cond=1:length(conditions)
            selected_paths = find(strcmpi(quantity_res.condition,conditions{cond}) .* strcmpi(quantity_res.name,animals{m}));
            mouse_data = [];
            for p=1:length(selected_paths)
                mouse_data(p) =  sum(all_deltas(selected_paths(p),idx_plot));
                if density && strcmpi(timescale,'hours')
                    duration = length(idx_plot);
                    mouse_data(p) = mouse_data(p) / duration;
                elseif density && strcmpi(timescale,'session')
                    duration = quantity_res.session_time{selected_paths(p)}(idx_plot,:) / 3600E4;
                    duration = sum(duration(:,2) - duration(:,1));
                    mouse_data(p) = mouse_data(p) / duration;
                end
            end
            data(m,cond) = mean(mouse_data);
        end

        selected_paths = find(strcmpi(quantity_res.manipe,'DeltaToneAll') & cell2mat(quantity_res.delay)>0 & strcmpi(quantity_res.name,animals{m})); %DeltaToneAll
        mouse_data = [];
        for p=1:length(selected_paths)
            mouse_data(p) =  sum(all_deltas(selected_paths(p),idx_plot));
            if density && strcmpi(timescale,'hours')
                duration = length(idx_plot);
                mouse_data(p) = mouse_data(p) / duration;
            elseif density && strcmpi(timescale,'session')
                duration = quantity_res.session_time{selected_paths(p)}(idx_plot,:) / 3600E4;
                duration = sum(duration(:,2) - duration(:,1));
                mouse_data(p) = mouse_data(p) / duration;
            end
        end
        data(m,length(conditions)+1) = mean(mouse_data);
    end

%     labels = conditions;
%     labels{end+1} = 'DeltaToneAll';

    PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
    ylabel(y_label), xlim([0.5 3.5]),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30,'YTick',[0 1000 2000],'FontName','Times','fontsize',20), hold on,
    title([maintitle ' (' num2str(length(animals)) ' mice)'])
end







