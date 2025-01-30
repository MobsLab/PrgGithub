% ClinicQuantitySleepPlotNew
% 30.06.2017 KJ
%
% Graphs quantifying sleep duration, for each sleep stage and many conditions 
%
%
%%%%%
% INPUT :
%   stages_num:     int or list - the substages to consider in numerator (for the percentage)
% 
%   stages_den:     int or list - the substages to consider in denominator (for the percentage)
%               
%               0 : ALL STAGES
%               1 : N1
%               2 : N2
%               3 : N3
%               4 : REM
%               5 : WAKE
%               6 : N2&N3
%       
%               7 : SOL (Sleep onset latency)   - no ratio
%               8 : WASO                        - no ratio
%               9 : Sleep Efficiency            - no ratio
%
%              -1 : No percentage (for stages_den only)
%
%   scorer:         string - the name of the scorer ('dreem', 'livio' or 'pascal')
%
%   ref_score:      string - the scoring ref for synchronization ('livio' or 'pascal')
%
%%%%%
%   (OPTIONAL)
%   hours               list int - list of hours to consider in data
%                       (default whole night)
%   newfig              bool - 1 to display in a new figure, 0 to add on existing one 
%                       (default 1)
%   show_sig:           string - which stat are displayed
%                       (default 'sig') 'none' for no stat, 'ns' for only non significant, 
%                       'sig' for only significant, 'all' for all stat 
%   optiontest:         string - which test for the stat
%                       (default ranksum) 'ttest' , 'ranksum'
%   paired:             bool - 1 for paired analysis on mice data average, 0 for analysis on all nights
%                       (default 0)
%   show_points:        bool - 1 to display points on the bar plot, 0 otherwise
%                       (default 1)
%
%%%%%
%   EXAMPLE : 
%       ClinicQuantitySleepPlotNew(1:3, 0, 'dreem','livio', 'hours', 2:4, 'show_sig','none','paired',1);       
% 
%
% See
%   QuantitySleepDeltaPlot ClinicQuantitySleepNew
%   
%

function [data, conditions] = ClinicQuantitySleepPlotNew(stages_num, stages_den, scorer, ref_score, varargin)


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
if ~isstring_FMAToolbox(scorer)
    error('Incorrect value for argument ''scorer''.');
end
if ~isstring_FMAToolbox(ref_score)
    error('Incorrect value for argument ''ref_score''.');
end

arg_scorer = scorer;
arg_refscore = ref_score;

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'hours',
            hours = varargin{i+1};
            if ~isvector(hours)
                error('Incorrect value for property ''hours''.');
            end
        case 'newfig',
            newfig = varargin{i+1};
            if newfig~=0 && newfig ~=1
                error('Incorrect value for property ''newfig''.');
            end
        case 'show_sig',
            show_sig = varargin{i+1};
            if ~isstring_FMAToolbox(show_sig, 'none' , 'ns', 'sig', 'all')
                error('Incorrect value for property ''show_sig''.');
            end
        case 'optiontest',
            optiontest = varargin{i+1};
            if ~isstring_FMAToolbox(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'paired',
            paired = varargin{i+1};
            if paired~=1 && paired~=0
                error('Incorrect value for property ''paired''.');
            end
        case 'show_points',
            show_points = varargin{i+1};
            if show_points~=1 && show_points~=0
                error('Incorrect value for property ''show_points''.');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('hours','var')
    hours=[];
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
if ~exist('show_points','var')
    show_points=1;
end

%params
NameSubstages={'N1','N2','N3','REM','Wake','N2&N3'};
colori = {'k','b','r'};


%% load
load([FolderPrecomputeDreem 'ClinicQuantitySleepNew.mat']) 
conditions = unique(quantity_res.condition(~cellfun(@isempty, quantity_res.condition)));
subjects = unique(cell2mat(quantity_res.subject));
for p=1:length(quantity_res.subject)
   if isempty(quantity_res.subject{p})
       quantity_res.subject{p}=-1;
   end
end


%% scorer
ind_scorer = find(strcmpi(arg_scorer,scorer) & strcmpi(arg_refscore,ref_score));

%% stages
stages_num = sort(stages_num);
stages_den = sort(stages_den);

ratio=1; y_label = '%'; sleep_stat=0;

if stages_num==0 %whole record
    stages_num = 1:5;
elseif isequal(stages_num,1:4)% Whole Sleep
    maintitle = 'Sleep';
elseif stages_num<7
    maintitle = strjoin(NameSubstages(stages_num), ' + '); 
    
elseif ismember(stages_num,[7 8 9])  %SOL,WASO, Sleep efficiency
    ratio=0;
    sleep_stat=1;
    if stages_num==7
        maintitle = 'SOL';
        y_label = 'Latency (s)';
        stat_field = 'sol';
    elseif stages_num==8
        maintitle = 'WASO';
        y_label = 'nb';
        stat_field = 'waso';
    elseif stages_num==9
        maintitle = 'Sleep efficiency';
        y_label = '%';
        stat_field = 'sleep_efficiency';
    end
    
end

if stages_den==-1  %no ratio
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
if isempty(hours) || sleep_stat
    idx_plot = 1:length(hours_expe);
else
    [~,idx_plot]=intersect(hours_expe,hours);
    maintitle = [maintitle ' | Hours: ' num2str(hours)];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

%% Sleep stat
if sleep_stat
    
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
            data{cond} = [];
            for p=1:length(path_cond)
                if ~isempty(quantity_res.sleepstages.(stat_field){path_cond(p),ind_scorer})
                    data{cond} = [data{cond} quantity_res.sleepstages.(stat_field){path_cond(p),ind_scorer}];
                end
            end
        end
        labels = conditions;
        
        PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest,'showPoints',show_points);
        ylabel(y_label),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title(maintitle)
        
    %paired, on subject
    else
        data = nan(length(subjects), length(conditions));
        for s=1:length(subjects)
            for cond=1:length(conditions)
                selected_paths = find(strcmpi(quantity_res.condition,conditions{cond}) .* (cell2mat(quantity_res.subject)==subjects(s)));

                subject_data = [];
                for p=1:length(selected_paths)
                    if ~isempty(quantity_res.sleepstages.(stat_field){selected_paths(p),ind_scorer})
                        subject_data = [subject_data quantity_res.sleepstages.(stat_field){selected_paths(p),ind_scorer}];
                    end
                end
                data(s,cond) = mean(subject_data);
            end
        end
        labels = conditions;

        PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest,'showPoints',show_points);
        ylabel(y_label),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title([maintitle ' (' num2str(length(subjects)) ' subjects)'])
        
    end
    
    
%% Sleep stage
else
    %non_paired, on all nights
    if paired==0
        for cond=1:length(conditions)
            path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
            for p=1:length(path_cond)
                if ~isempty(quantity_res.sleepstages.hours{path_cond(p),ind_scorer})
                    data_num = sum(sum(quantity_res.sleepstages.hours{path_cond(p),ind_scorer}(idx_plot,stages_num)));
                    if ratio
                        data_den = sum(sum(quantity_res.sleepstages.hours{path_cond(p),ind_scorer}(idx_plot,stages_den)));
                    else
                        data_den = 1E4; %in sec
                    end
                    data{cond}(p) = 100 * data_num / data_den;
                end
            end
        end
        labels = conditions;

        PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest,'showPoints',show_points);
        ylabel(y_label),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title(maintitle)


    %paired, on subject
    else
        data = nan(length(subjects), length(conditions));
        for s=1:length(subjects)
            for cond=1:length(conditions)
                selected_paths = find(strcmpi(quantity_res.condition,conditions{cond}) .* (cell2mat(quantity_res.subject)==subjects(s)));

                subject_data = [];
                for p=1:length(selected_paths)
                    if ~isempty(quantity_res.sleepstages.hours{selected_paths(p),ind_scorer})
                        data_num = sum(sum(quantity_res.sleepstages.hours{selected_paths(p),ind_scorer}(idx_plot,stages_num)));
                        if ratio
                            data_den = sum(sum(quantity_res.sleepstages.hours{selected_paths(p),ind_scorer}(idx_plot,stages_den)));
                        else
                            data_den = 1E4; %in sec
                        end
                        subject_data = [subject_data 100*data_num/data_den];
                    end
                end
                data(s,cond) = mean(subject_data);
            end
        end
        labels = conditions;

        PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest,'showPoints',show_points);
        ylabel(y_label),
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
        title([maintitle ' (' num2str(length(subjects)) ' subjects)'])
    end

end


end