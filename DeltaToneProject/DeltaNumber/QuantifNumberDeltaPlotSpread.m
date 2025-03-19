% QuantifNumberDeltaPlotSpread
% 06.02.2017 KJ
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
%                       4 : Figure4 - Bar plot for a specific time window
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
%       QuantifNumberDeltaPlotSpread(1, 'show_sig','none','paired',1);       
% 
%
% See
%   QuantifNumberDelta QuantifNumberDeltaPlot
%   
%


function QuantifNumberDeltaPlotSpread(figure_numbers, varargin)


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
hours_expe = 10:1:20;
[~,idx_hour_window]=intersect(hours_expe,hour_window);

% conditions
conditions = unique(deltanumber_res.condition);
colori = {'k','b',[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'};


%first hours baseline
first_values = cell2mat(deltanumber_res.hours(:,1));
good_paths = first_values>1500 & first_values<3500;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Order and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ALL FIGURES
if ismember(0,figure_numbers)
    QuantifNumberDeltaPlotSpread(1, 'show_sig','sig','paired',1);
    QuantifNumberDeltaPlotSpread(1, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlotSpread(2, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlotSpread(2, 'show_sig','sig','paired',1);
    QuantifNumberDeltaPlotSpread(3, 'show_sig','sig','paired',0);
    QuantifNumberDeltaPlotSpread(3, 'show_sig','sig','paired',1);
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'paired',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'paired',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'paired',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title('17h-19h (9 mice)')
    end
end


%% Figure4 - Bar plot for a specific time window
if ismember(4,figure_numbers)
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'paired',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
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
        PlotErrorSpreadN_KJ(data, 'newfig',0,'paired',0,'plotcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
        ylabel('Number of Delta waves'),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title([num2str(hour_window) 'h (9 mice)'])
    end
end


end






