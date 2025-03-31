% CycleDurationSubstageDeltaTonePlot
% 23.04.2017 KJ
%
% Inside sleep cycles: duration, substages, number of tones/delta
%
%
%%%%%
% INPUT :
%   stages_num:     int or list - the substages to consider in numerator (for the percentage)
% 
%   stages_den:     int or list - the substages to consider in denominator (for the percentage)
%               
%               0 : ALL SUBSTAGES
%               1 : N1
%               2 : N2
%               3 : N3
%               4 : REM
%               5 : WAKE
%               6 : NREM
%              -1 : No percentage (for stages_den only)
%
%   timescale:      string - at which time scale data are considered      
%                   'hours', 'session'
%
%   moment:         int or list - at which moment data are considered
%                   0 : ALL
%
%%%%%
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
%
%%%%%
%   EXAMPLE : 
%       CycleDurationSubstageDeltaTonePlot(3, 6, 'session', 2, 'newfig',0,'show_sig','sig');   
% 
%
% See
%   CycleDurationDeltaTone CycleDurationEventDeltaTonePlot
%   
%



function data = CycleDurationSubstageDeltaTonePlot(stages_num, stages_den, timescale, moment, varargin)


%% CHECK INPUTS
if nargin < 4 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

if ~isvector(stages_num)
    error('Incorrect value for argument ''stages_num''.');
end
if ~isvector(stages_den)
    error('Incorrect value for argument ''stages_den''.');
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

%params
NameSubstages={'N1','N2','N3','REM','Wake','NREM'};
colori = {'k','b',[0.1 0.15 0.1],[0.75 0.75 0.75],[0.4 0.4 0.4],'c','r'};


%% load
load([FolderProjetDelta 'Data/CycleDurationDeltaTone.mat']) 
animals = unique(cycle_res.name);
conditions = unique(cycle_res.condition);


%% stages
stages_num = sort(stages_num);
stages_den = sort(stages_den);

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
    

%% index and timescales
if strcmpi(timescale,'hours')
    if moment==0
        idx_plot = hours_expe;
    else
        [~,idx_plot]=intersect(hours_expe,moment);
        maintitle = [maintitle ' | Hours: ' num2str(moment)];
    end
elseif strcmpi(timescale,'session')
    if moment==0
        idx_plot = 1:5;
    else
        idx_plot = moment;
        maintitle = [maintitle ' | Sessions: ' num2str(moment)];
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

%non_paired, on all nights
if paired==0
    for cond=1:length(conditions)
        path_cond = find(strcmpi(cycle_res.condition,conditions{cond}));
        for p=1:length(path_cond)
            data_num = squeeze(cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_num));
            data_num = sum(cell2mat(data_num),1);
            if ratio
                data_den = squeeze(cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_den));
                data_den = sum(cell2mat(data_den),1);                
            else
                data_den = 1E4 * 100; %in sec
            end
            data{cond}(p) = 100 * mean(data_num ./ data_den);
        end
    end
    path_cond = find(strcmpi(cycle_res.manipe,'DeltaToneAll')); %DeltaToneAll
    for p=1:length(path_cond)        
        data_num = squeeze(cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_num));
        data_num = sum(cell2mat(data_num),1);
        if ratio
            data_den = squeeze(cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_den));
            data_den = sum(cell2mat(data_den),1);
        else
            data_den = 1E4 * 100; %in sec
        end
        data{length(conditions)+1}(p) = 100 * mean(data_num ./ data_den);
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
            selected_paths = find(strcmpi(cycle_res.condition,conditions{cond}) .* strcmpi(cycle_res.name,animals{m}));

            mouse_data = [];
            for p=1:length(selected_paths)                
                data_num = squeeze(cycle_res.(timescale).substage_duration(selected_paths(p),idx_plot,stages_num));
                data_num = sum(cell2mat(data_num),1);
                if ratio
                    data_den = squeeze(cycle_res.(timescale).substage_duration(selected_paths(p),idx_plot,stages_den));
                    data_den = sum(cell2mat(data_den),1);                    
                else
                    data_den = 100 * 1E4; %in sec
                end
                mouse_data = [mouse_data 100 * data_num ./ data_den];
            end
            data(m,cond) = mean(mouse_data);
        end

        selected_paths = find(strcmpi(cycle_res.manipe,'DeltaToneAll') .* strcmpi(cycle_res.name,animals{m})); %DeltaToneAll
        mouse_data = [];
        for p=1:length(selected_paths)
            data_num = squeeze(cycle_res.(timescale).substage_duration(selected_paths(p),idx_plot,stages_num));
            data_num = sum(cell2mat(data_num),1);
            if ratio
                data_den = squeeze(cycle_res.(timescale).substage_duration(selected_paths(p),idx_plot,stages_den));
                data_den = sum(cell2mat(data_den),1); 
            else
                data_den = 1E4 * 100; %in sec
            end
            mouse_data = [mouse_data 100 * data_num ./ data_den];
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









