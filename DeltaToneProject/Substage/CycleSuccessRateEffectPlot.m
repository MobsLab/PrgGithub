% CycleSuccessRateEffectPlot
% 23.04.2017 KJ
%
% Success rate vs :
%   - Substage duration
%   - deltas number
% Graphs for each substage and many conditions 
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
%   conditions:     int or list - the condition to consider 
%
%               0 : ALL CONDITIONS
%               1 : BASAL
%               2 : RANDOM
%               3 : TONE 0ms
%               4 : TONE 140ms
%               5 : TONE 320ms
%               6 : TONE 490ms
%               7 : TONE all delay
%
%   timescale:      string - at which time scale data are considered      
%                   'hours', 'session'
%
%   moment:         int or list - at which moment data are considered
%                   0 : ALL
%
%%%%%
%   (OPTIONAL)
%   newfig              bool - 1 to display in a new figure, 0 to add on existing one 
%                       (default 1)
%   showtitle           bool - 1 to display the title, 0 otherwise
%                       (default 1)   
%   stat_type:          string - type of correlation
%                       (default 'none') 'none','Spearman','Pearson'
%   xdata:              string - data displayed on x-axis
%                       (default 'percentage') 'percentage','number','tones'
%
%%%%%
%   EXAMPLE : 
%       CycleSuccessRateEffectPlot(3, 6, 0, 'session', 0, 'xdata', 'percentage', 'newfig',0,'stat_type','Spearman');   
% 
%
% See
%   SuccessRateEffectPlot CycleDurationDeltaTone
%   
%   


function data_y = CycleSuccessRateEffectPlot(stages_num, stages_den, conditions, timescale, moment, varargin)


%% CHECK INPUTS
if nargin < 5 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

if ~isvector(stages_num)
    error('Incorrect value for argument ''stages_num''.');
end
if ~isvector(stages_den)
    error('Incorrect value for argument ''stages_den''.');
end
if ~isvector(conditions)
    error('Incorrect value for argument ''conditions''.');
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
        case 'showtitle',
            showtitle = varargin{i+1};
            if showtitle~=0 && showtitle ~=1
                error('Incorrect value for property ''showtitle''.');
            end
        case 'stat_type',
            stat_type = varargin{i+1};
            if ~isstring(stat_type, 'none','Spearman','Pearson')
                error('Incorrect value for property ''stat_type''.');
            end
        case 'xdata',
            xdata = varargin{i+1};
            if ~isstring(xdata, 'percentage','number','tones')
                error('Incorrect value for property ''xdata''.');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('newfig','var')
    newfig=1;
end
if ~exist('showtitle','var')
    showtitle=1;
end
if ~exist('stat_type','var')
    stat_type = 'none';
end
if ~exist('xdata','var')
    xdata = 'percentage';
end

%params
NameSubstages={'N1','N2','N3','REM','Wake','NREM'};
colori = {'k','b',[0.1 0.15 0.1],[0.75 0.75 0.75],[0.4 0.4 0.4],'m','r'};
scattersize = 25;


%% load
load([FolderProjetDelta 'Data/CycleDurationDeltaTone.mat']) 
animals = unique(cycle_res.name);
conditions_name = unique(cycle_res.condition);


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

maintitle = [maintitle ' (sleep cycle)'];
    
%condition
if conditions==0
    conditions = 1:7;
end

conditions_name{end+1}='DeltaToneAll';
conditions_name = conditions_name(conditions);
colori = colori(conditions);


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

if strcmpi(xdata,'percentage')
    x_label = '% success';
elseif strcmpi(xdata,'number')
    x_label = 'number of success tones';
elseif strcmpi(xdata,'tones')
    x_label = 'number of tones';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

%% data
for cond=1:length(conditions_name)
    if ~strcmpi('DeltaToneAll',conditions_name{cond})
        path_cond = find(strcmpi(cycle_res.condition,conditions_name{cond}));
        for p=1:length(path_cond)            
            data_num = cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_num);
            data_num = reshape(data_num,[size(data_num,2),size(data_num,3)]);
            dn = [];
            for i=size(data_num,2)
                if isempty(dn)
                    dn = [data_num{:,i}];
                else
                    dn = dn + [data_num{:,i}];
                end
            end
            data_num = dn;
            
            if ratio
                data_den = cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_den);
                data_den = reshape(data_den,[size(data_den,2),size(data_den,3)]);
                dd = [];
                for i=size(data_den,2)
                    if isempty(dd)
                        dd = [data_den{:,i}];
                    else
                        dd = dd + [data_den{:,i}];
                    end
                end
                data_den = dd;
            else
                data_den = 1E4 * 100; %in sec
            end
            
            d_y = data_num ./ data_den;
            d_y(d_y==Inf)=[];
            data_y{cond}(p) = 100 * nanmean(d_y);

            nb_tone = mean(cell2mat(cycle_res.(timescale).nb_tones(path_cond(p),idx_plot)));
            nb_success = mean(cell2mat(cycle_res.(timescale).nb_success(path_cond(p),idx_plot)));
            if strcmpi(xdata,'percentage')
                data_x{cond}(p) = 100 * (nb_success / nb_tone);
            elseif strcmpi(xdata,'number')
                data_x{cond}(p) = nb_success;
            elseif strcmpi(xdata,'tones')
                data_x{cond}(p) = nb_tone;
            end
        end
    end
end

%DeltaToneAll condition
if ismember('DeltaToneAll',conditions_name)
    idx = find(strcmpi('DeltaToneAll',conditions_name));
    path_cond = find(strcmpi(cycle_res.manipe,'DeltaToneAll')); %DeltaToneAll
    for p=1:length(path_cond)
        data_num = cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_num);
        data_num = reshape(data_num,[size(data_num,2),size(data_num,3)]);
        dn = [];
        for i=size(data_num,2)
            if isempty(dn)
                dn = [data_num{:,i}];
            else
                dn = dn + [data_num{:,i}];
            end
        end
        data_num = dn;
        
        if ratio
            data_den = cycle_res.(timescale).substage_duration(path_cond(p),idx_plot,stages_den);
            data_den = reshape(data_den,[size(data_den,2),size(data_den,3)]);
            dd = [];
            for i=size(data_den,2)
                if isempty(dd)
                    dd = [data_den{:,i}];
                else
                    dd = dd + [data_den{:,i}];
                end
            end
            data_den = dd;
            
        else
            data_den = 1E4 * 100; %in sec
        end        
        d_y = data_num ./ data_den;
        d_y(d_y==Inf)=[];
        data_y{idx}(p) = 100 * nanmean(d_y);
        
        nb_tone = mean(cell2mat(cycle_res.(timescale).nb_tones(path_cond(p),idx_plot)));
        nb_success = mean(cell2mat(cycle_res.(timescale).nb_success(path_cond(p),idx_plot)));
        if strcmpi(xdata,'percentage')
            data_x{idx}(p) = 100 * (nb_success / nb_tone);
        elseif strcmpi(xdata,'number')
            data_x{idx}(p) = nb_success;
        elseif strcmpi(xdata,'tones')
            data_x{idx}(p) = nb_tone;
        end
    end
end
%labels
labels = conditions_name;


%% stat
if ~strcmpi(stat_type,'none')
    x_points = [];
    y_points = [];
    for cond=1:length(data_y)
        x_points = [x_points data_x{cond}];
        y_points = [y_points data_y{cond}];
    end
    [r1,p1]=corr(x_points',y_points','type',stat_type);
    curve_fit= polyfit(x_points,y_points,1);
end


%% plot
for cond=1:length(data_x)
    scatter(data_x{cond},data_y{cond},scattersize,colori{cond},'filled'), hold on
end
legend(labels), hold on
if p1<0.05
    line([min(x_points),max(x_points)],curve_fit(2)+[min(x_points),max(x_points)]*curve_fit(1),'Color','k','Linewidth',1), hold on
end
xlabel(x_label),ylabel(y_label),
if showtitle
    title(maintitle), hold on
end
text(0.05,0.95,['r = ' num2str(round(r1,2))],'Units','normalized');
text(0.05,0.9,['p = ' num2str(round(p1,4))],'Units','normalized');




end










