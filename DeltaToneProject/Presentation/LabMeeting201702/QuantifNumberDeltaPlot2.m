% QuantifNumberDeltaPlot2
% 01.02.2017 KJ
%
% !!! USE RATHER THE NEW VERSION QuantifNumberDeltaPlot
% 
%
%
% Graphs for the quantification of the number of delta waves, in different conditions 
%
% Info
%   In this version of NumberDeltaPerRecord:
%       - numbers of deltas are collected for basal/random/deltatone
%       - there are numbers of deltas per hour
%       - there are numbers of deltas per session
%       - there are numbers of deltas at midday (12h-14h) and at the evening (17h-19h)
%       - data are ploted for all nights or for each mouse (paired)
%
% INPUT :
%   figure_numbers:     int or list - the figures to plot
%
%                       0 : ALL FIGURES
%                       1 : Figure1 - Total number of delta on the record
%                       2 : Figure2 - Midday number of delta
%                       3 : Figure3 - Evening number of delta
%                       4 : Figure4 - Number of delta per hour
%                       5 : Figure5 - Number of delta per session
%                       6 : Figure6 - Bar plot for a specific time window
% 
%
%   show_sig:           string - which stat are displayed
%                       (default 'none') 'none' for no stat, 'ns' for only non significant, 
%                       'sig' for only significant, 'all' for all stat 
%   optiontest:         string - which test for the stat
%                       (default ranksum) 'ttest' , 'ranksum'
%   paired:             bool - 1 for paired analysis on mice data average, 0 for analysis on all nights
%                       (default 0)
%   hour_window:        array - list of hours
%                       (default [])
%
%   EXAMPLE : 
%       QuantifNumberDeltaPlot2(1, 'show_sig','none','paired',1);       
% 
%
% See
%   QuantifNumberDeltaPlot QuantifNumberDelta QuantifNumberDeltaPlotSpread
%   
%


function QuantifNumberDeltaPlot2(figure_numbers, varargin)


%% CHECK INPUTS
if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'show_sig',
            show_sig = varargin{i+1};
            if ~isstring(show_sig, 'none' , 'ns', 'sig', 'all')
                error('Incorrect value for property ''show_sig''.');
            end
        case 'optiontest',
            optiontest = varargin{i+1};
            if ~isstring(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'paired',
            paired = varargin{i+1};
            if paired~=1 && paired~=0
                error('Incorrect value for property ''paired''.');
            end
        case 'hour_window',
            hour_window = varargin{i+1};
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('show_sig','var')
    show_sig = 'none';
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end
if ~exist('paired','var')
    paired=0;
end
if ~exist('hour_window','var')
    hour_window=[];
end


%% load
load([FolderProjetDelta 'Data/NumberDeltaPerRecord.mat']) 


%% params
manipes =  unique(deltanumber_res.manipe);
animals = unique(deltanumber_res.name);
sessions_ind=1:5;

%hours
hours_expe = 9:1:20;
idx_plot = find(hours_expe<19 & hours_expe>9);
hours_expe_plot = hours_expe(idx_plot);
[~,idx_hour_window]=intersect(hours_expe,hour_window);

% conditions
conditions = unique(deltanumber_res.condition);
colori = {'k','b',[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'};


%first hours baseline
first_values = cell2mat(deltanumber_res.hours(:,1)); 
second_values = cell2mat(deltanumber_res.hours(:,2));
good_paths = first_values>1500 & first_values<3500 & second_values>2500 & second_values<5000;

%good_paths = first_values>3500 & first_values<10000;
good_paths = first_values>0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ALL FIGURES
if ismember(0,figure_numbers)
    QuantifNumberDeltaPlot2(1, 'show_sig','sig','paired',1);
    QuantifNumberDeltaPlot2(1, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlot2(2, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlot2(2, 'show_sig','sig','paired',1);
    QuantifNumberDeltaPlot2(3, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlot2(3, 'show_sig','sig','paired',1);
    QuantifNumberDeltaPlot2(4, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlot2(4, 'show_sig','sig','paired',1);
    QuantifNumberDeltaPlot2(5, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlot2(5, 'show_sig','sig','paired',1);
end

%% Figure1 - TOTAL number of delta on the record
if ismember(1,figure_numbers)
    clear data
    %non_paired, on all nights
    if paired==0 
        for cond=1:length(conditions)
            path_cond = strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths';
            data{cond} = cell2mat(deltanumber_res.total(path_cond==1));
        end
        path_cond = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths';
        data{end+1} = cell2mat(deltanumber_res.total(path_cond==1));
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('TOTAL NUMBER per record')
    
    %paired, on mice
    else
        data = nan(length(animals), length(conditions));
        for m=1:length(animals)
            for cond=1:length(conditions)
                selected_paths = strcmpi(deltanumber_res.condition,conditions{cond}) .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
                data(m,cond) = mean(cell2mat(deltanumber_res.total(selected_paths==1)));
            end
            selected_path = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
            data(m,length(conditions)+1) = mean(cell2mat(deltanumber_res.total(selected_path==1)));
        end
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('TOTAL NUMBER per record (9 mice)')
    end
end


%% Figure2 - MIDDAY number of delta
if ismember(2,figure_numbers)
    clear data
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths';
            data{cond} = cell2mat(deltanumber_res.midday(path_cond==1));
        end
        path_cond = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths';
        data{end+1} = cell2mat(deltanumber_res.midday(path_cond==1));
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('12h-14h')
        
    %paired, on mice
    else
        data = nan(length(animals), length(conditions));
        for m=1:length(animals)
            for cond=1:length(conditions)
                selected_paths = strcmpi(deltanumber_res.condition,conditions{cond}) .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
                data(m,cond) = mean(cell2mat(deltanumber_res.midday(selected_paths==1)));
            end
            selected_path = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
            data(m,length(conditions)+1) = mean(cell2mat(deltanumber_res.midday(selected_path==1)));
        end
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('12h-14h (9 mice)')
    end
end


%% Figure3 - EVENING number of delta
if ismember(3,figure_numbers)
    clear data
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths';
            data{cond} = cell2mat(deltanumber_res.evening(path_cond==1));
        end
        path_cond = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths';
        data{end+1} = cell2mat(deltanumber_res.evening(path_cond==1));
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('17h-19h')

    %paired, on mice
    else
        data = nan(length(animals), length(conditions));
        for m=1:length(animals)
            for cond=1:length(conditions)
                selected_paths = strcmpi(deltanumber_res.condition,conditions{cond}) .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
                data(m,cond) = mean(cell2mat(deltanumber_res.evening(selected_paths==1)));
            end
            selected_path = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
            data(m,length(conditions)+1) = mean(cell2mat(deltanumber_res.evening(selected_path==1)));
        end
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('17h-19h (9 mice)')
    end
end


%% Figure4 - Number of delta per HOUR
if ismember(4,figure_numbers)
    clear data
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths';
            data{cond} = cell2mat(deltanumber_res.hours(path_cond==1,idx_plot));
        end
        path_cond = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths';
        data{end+1} = cell2mat(deltanumber_res.hours(path_cond==1,idx_plot));
        legends = conditions;
        legends{end+1} = 'DeltaToneAll';



        figure, hold on
        for cond=1:length(data)
            [~,li(cond)] = PlotErrorLineN_KJ(data{cond}, 'x_data',hours_expe_plot, 'newfig',0,'linecolor',colori{cond},'ShowSigstar','none'); hold on
        end
        li_leg = legend(li,legends);
        set(li_leg,'FontSize',20);
        set(gca, 'XTick',10:19,'XLim',[9 19],'FontName','Times','fontsize',14);
        xlabel('time of the day (h)','fontsize',18), ylabel('Number of Delta waves'),
        title('Delta waves per hour')

    %paired, on mice
    else
        for cond=1:length(conditions)
            data{cond} = nan(length(animals), length(hours_expe_plot));
            for m=1:length(animals)
                selected_paths = strcmpi(deltanumber_res.condition,conditions{cond}) .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
                for i=1:length(idx_plot)
                    data{cond}(m,i) = mean(cell2mat(deltanumber_res.hours(selected_paths==1,idx_plot(i))));
                end
            end
        end
        data{end+1} = nan(length(animals), length(hours_expe_plot));
        for m=1:length(animals)
            selected_path = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
            for i=1:length(idx_plot)
                data{end}(m,i) = mean(cell2mat(deltanumber_res.hours(selected_path==1,idx_plot(i))));
            end
        end

        legends = conditions;
        legends{end+1} = 'DeltaToneAll';
        %plot
        figure, hold on
        for cond=1:length(data)
            [~,li(cond)] = PlotErrorLineN_KJ(data{cond}, 'x_data',hours_expe_plot,'newfig',0,'linecolor',colori{cond},'ShowSigstar','none'); hold on
        end
        li_leg = legend(li,legends);
        set(li_leg,'FontSize',20);
        set(gca, 'XTick',10:19,'XLim',[9 19],'FontName','Times','fontsize',14);
        xlabel('time of the day (h)','fontsize',18), ylabel('Number of Delta waves'),
        title('Delta waves per hour (9 mice)')
    end
end



%% Figure5 - Number of delta per SESSION
if ismember(5,figure_numbers)
    clear data
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths';
            data{cond} = cell2mat(deltanumber_res.session(path_cond==1,sessions_ind));
        end
        path_cond = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths';
        data{end+1} = cell2mat(deltanumber_res.session(path_cond==1,sessions_ind));
        legends = conditions;
        legends{end+1} = 'DeltaToneAll';


        figure, hold on
        for cond=1:length(data)
            [~,li(cond)] = PlotErrorLineN_KJ(data{cond}, 'x_data',sessions_ind, 'newfig',0,'linecolor',colori{cond},'ShowSigstar','none'); hold on
        end
        li_leg = legend(li,legends);
        set(li_leg,'FontSize',20);
        set(gca, 'XTick',1:5,'FontName','Times','fontsize',14);
        xlabel('Session','fontsize',18), ylabel('Number of Delta waves'),
        title('Delta waves per session')

    %paired, on mice
    else
        for cond=1:length(conditions)
            data{cond} = nan(length(animals), length(sessions_ind));
            for m=1:length(animals)
                selected_paths = strcmpi(deltanumber_res.condition,conditions{cond}) .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
                for s=1:length(sessions_ind)
                    data{cond}(m,s) = mean(cell2mat(deltanumber_res.session(selected_paths==1,sessions_ind(s))));
                end
            end
        end
        data{end+1} = nan(length(animals), length(sessions_ind));
        for m=1:length(animals)
            selected_path = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
            for s=1:length(sessions_ind)
                data{end}(m,s) = mean(cell2mat(deltanumber_res.session(selected_path==1,sessions_ind(s))));
            end
        end

        legends = conditions;
        legends{end+1} = 'DeltaToneAll';


        figure, hold on
        for cond=1:length(data)
            [~,li(cond)] = PlotErrorLineN_KJ(data{cond}, 'x_data',sessions_ind,'newfig',0,'linecolor',colori{cond},'ShowSigstar','none'); hold on
        end
        li_leg = legend(li,legends);
        set(li_leg,'FontSize',20);
        set(gca, 'XTick',1:5,'FontName','Times','fontsize',14);
        xlabel('Session','fontsize',18), ylabel('Number of Delta waves'),
        title('Delta waves per session (9 mice)')
    end
end             


%% Figure6 - Bar plot for a specific time window
if ismember(6,figure_numbers)
    clear data
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = find(strcmpi(deltanumber_res.condition,conditions{cond}) .* good_paths');
            for p=1:length(path_cond)
                data{cond}(p) = sum(cell2mat(deltanumber_res.hours(path_cond(p),idx_hour_window)));
            end
        end
        path_cond = find(strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* good_paths');
        for p=1:length(path_cond)
            data{length(conditions)+1}(p) = sum(cell2mat(deltanumber_res.hours(path_cond(p),idx_hour_window)));
        end
        
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title([num2str(hour_window) 'h'])
        
    %paired, on mice
    else
        data = nan(length(animals), length(conditions));
        for m=1:length(animals)
            for cond=1:length(conditions)
                selected_paths = strcmpi(deltanumber_res.condition,conditions{cond}) .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
                data(m,cond) = mean(sum(cell2mat(deltanumber_res.hours(selected_paths==1,idx_hour_window)),2));
            end
            selected_path = strcmpi(deltanumber_res.manipe,'DeltaToneAll') .* strcmpi(deltanumber_res.name,animals{m}) .* good_paths';
            data(m,length(conditions)+1) = mean(sum(cell2mat(deltanumber_res.hours(selected_path==1,idx_hour_window)),2));
        end
        labels = conditions;
        labels{end+1} = 'DeltaToneAll';

        figure, hold on
        PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title([num2str(hour_window) 'h (9 mice)'])
    end
end


end



