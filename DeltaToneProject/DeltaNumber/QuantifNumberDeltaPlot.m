% QuantifNumberDeltaPlot
% 18.02.2017 KJ
%
% Graphs quantifying number/density of delta waves for many conditions and
% hours/sessions
%
%
%%%%%
% INPUT :
%
%   density:        bool - 0 to plot the numbers of delta waves, 1 to plot the density
%
%   timescale:      string - at which time scale data are considered      
%                   'hour', 'session'
%
%   moment:         int or list - at which moment data are considered
%                   0 : ALL
%
%
%%%%%
%   (OPTIONAL)
%   newfig              bool - 1 to display in a new figure, 0 to add on existing one 
%                       (default 1)
%   show_sig:           string - which stat are displayed
%                       (default 'sig') 'none' for no stat, 'ns' for only non significant, 
%                       'sig' for only significant, 'all' for all stat 
%   optiontest:         string - which test for the stat
%                       (default ranksum) 'ttest' , 'ranksum'
%   paired:             bool - 1 for paired analysis on mice data average, 0 for analysis on all nights
%                       (default 0)
%   SpikesDataSet:      bool - 1 to use the dataset that contains spikes, 0 otherwise
%                       (default 0)
%
%%%%%
%   EXAMPLE : 
%       QuantifNumberDeltaPlot(1, 'session', 2, 'show_sig','sig','paired',1);       
% 
%
% See
%   QuantitySleepDelta QuantifNumberDeltaPlot QuantitySleepDeltaPlot QuantifNumberDeltaPlot2
%   
%


function data = QuantifNumberDeltaPlot(density, timescale, moment, varargin)


%% CHECK INPUTS
if nargin < 3 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

if density~=1 && density~=0
    error('Incorrect value for property ''density''.');
end
if ~isstring(timescale, 'hours', 'session')
    error('Incorrect value for argument ''timescale''.');
end
if ~isvector(moment)
    error('Incorrect value for argument ''moment''.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'newfig',
            newfig = varargin{i+1};
            if newfig~=0 && newfig ~=1
                error('Incorrect value for property ''newfig''.');
            end
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
        case 'spikesdataset',
            spikesdataset = varargin{i+1};
            if spikesdataset~=1 && spikesdataset~=0
                error('Incorrect value for property ''spikesdataset''.');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('newfig','var')
    newfig=1;
end
if ~exist('show_sig','var')
    show_sig = 'sig';
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end
if ~exist('paired','var')
    paired=0;
end
if ~exist('spikesdataset','var')
    spikesdataset=0;
end

%params
colori = {'k','b',[0.1 0.15 0.1],[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'};

if density
    maintitle = 'Delta waves density';
    y_label = 'deltas per hour';
else
    maintitle = 'Number Delta waves';
    y_label = 'number of delta waves';
end


%% load
if spikesdataset
    load([FolderProjetDelta 'Data/QuantitySleepDeltaDown.mat'])
else
    load([FolderProjetDelta 'Data/QuantitySleepDelta.mat']) 
end
animals = unique(quantity_res.name);
conditions = unique(quantity_res.condition);
    

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

% %% record selection
% %first hours baseline
% first_values = cell2mat(quantity_res.deltas.session(:,1)); 
% second_values = cell2mat(quantity_res.deltas.session(:,2));
% good_paths = first_values>1500 & first_values<3500 & second_values>2500 & second_values<5000;
% 
% %good_paths = first_values>3500 & first_values<10000;
% good_paths = first_values>0;


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
    path_cond = find(strcmpi(quantity_res.manipe,'DeltaToneAll')); %DeltaToneAll
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

    labels = conditions;
    labels{end+1} = 'DeltaToneAll';

    PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
    ylabel(y_label),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
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

        selected_paths = find(strcmpi(quantity_res.manipe,'DeltaToneAll') .* strcmpi(quantity_res.name,animals{m})); %DeltaToneAll
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

    labels = conditions;
    labels{end+1} = 'DeltaToneAll';

    PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
    ylabel(y_label),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
    title([maintitle ' (' num2str(length(animals)) ' mice)'])
end
    

end