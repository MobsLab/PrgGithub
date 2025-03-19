% ClinicQuantitySleepPlot
% 28.03.2017 KJ
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
%              -1 : No percentage (for stages_den only)
%
%
%%%%%
%   (OPTIONAL)
%   hours               list int - listg of hours to consider in data
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
%
%%%%%
%   EXAMPLE : 
%       ClinicQuantitySleepPlot(1:3, 0, 'hours', 2:4, 'show_sig','none','paired',1);       
% 
%
% See
%   QuantitySleepDeltaPlot ClinicQuantitySleep
%   
%

function data = ClinicQuantitySleepPlot(stages_num, stages_den, varargin)


%% CHECK INPUTS
if nargin < 2 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

if ~isvector(stages_num)
    error('Incorrect value for argument ''stages_num''.');
end
if ~isvector(stages_den)
    error('Incorrect value for argument ''stages_den''.');
end

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

%params
NameSubstages={'N1','N2','N3','REM','Wake','N2&N3'};
colori = {'k','b',[0.1 0.15 0.1],'r'};


%% load
load([FolderPrecomputeDreem 'ClinicQuantitySleep.mat']) 
conditions = unique(quantity_res.condition);
subjects = unique(cell2mat(quantity_res.subject));

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
if isempty(hours)
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

%non_paired, on all nights
if paired==0
    for cond=1:length(conditions)
        path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
        for p=1:length(path_cond)
            data_num = sum(sum(quantity_res.sleepstages.hours{path_cond(p)}(idx_plot,stages_num)));
            if ratio
                data_den = sum(sum(quantity_res.sleepstages.hours{path_cond(p)}(idx_plot,stages_den)));
            else
                data_den = 1E4; %in sec
            end
            data{cond}(p) = 100 * data_num / data_den;
        end
    end
    labels = conditions;

    PlotErrorBarN_KJ(data, 'newfig',0,'paired',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
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
                data_num = sum(sum(quantity_res.sleepstages.hours{selected_paths(p)}(idx_plot,stages_num)));
                if ratio
                    data_den = sum(sum(quantity_res.sleepstages.hours{selected_paths(p)}(idx_plot,stages_den)));
                else
                    data_den = 1E4; %in sec
                end
                subject_data = [subject_data 100*data_num/data_den];
            end
            data(s,cond) = mean(subject_data);
        end
    end
    labels = conditions;

    PlotErrorBarN_KJ(data, 'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
    ylabel(y_label),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
    title([maintitle ' (' num2str(length(subjects)) ' subjects)'])
end




end