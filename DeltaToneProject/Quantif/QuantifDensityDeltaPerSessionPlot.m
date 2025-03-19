% QuantifDensityDeltaPerSessionPlot
% 18.11.2016 KJ
%
% function QuantifDensityDeltaPerSessionPlot(datatype)
%
% INPUT:
% - data_type:   string, indicating which value are to be ploted
%               'delta', 'down', 'duration', 'duration ratio'
% - permouse:   string, indicating what represent the value, per mouse
%               'total', 'median'
% - measure:    string, indicating what measure to choose
%               'number', 'density',''
% - subfeature: string, feature that determines the subplots
%               'substage', 'session','none'
% 
% - sessions_plot: (optional - default [1:5], all session)
%               which sessions that are put into the plot
%               S1 - S2 - S3 - S4 - S5
% - substages_plot: (optional - default [1:5], all substages)
%               which substages that are put into the plot
%               N1 - N2 - N3 - REM - WAKE
% - delays_ind: (optional - default [1:6], all delays)
%               which delays-condition that are put into the plot
%               Rdm - 140ms - 200ms - 320ms - 490ms - Basal              
% - toPlot:     (optional - default 1)
%               1 to plot the figure, 0 otherwise
% - samescale:  (optional - default 1)
%               1 to have the same Ylim for all the axes, 0 otherwise
% - maintitle:  (optional)
%               Main title of the subplot  
%
% OUTPUT
%
% INFO
%   Plot stat from the data collected with QuantifDensityDeltaPerSession and QuantifDensityDeltaPerSession2
% example :
%   data_ouput = QuantifDensityDeltaPerSessionPlot('delta', 'total', 'density', 'session');
%   return a plot bar of the delta waves density over all similar period, for each
%   mouse, with a subplot for each session
%
% See
%   QuantifDensityDeltaPerSession QuantifDensityDeltaPerSession2
%

function data_ouput = QuantifDensityDeltaPerSessionPlot(data_type, permouse, measure, subfeature, varargin)

%% CHECK INPUTS
if nargin < 4 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'sessions_plot',
            sessions_plot = unique(varargin{i+1});
            if isempty(sessions_plot) || ~all(ismember(sessions_plot,1:5))
                error('Incorrect value for property ''sessions_plot''.');
            end
        case 'substages_plot',
            substages_plot = unique(varargin{i+1});
            if isempty(substages_plot) || ~all(ismember(substages_plot,1:5))
                error('Incorrect value for property ''substages_plot''.');
            end
        case 'delays_ind',
            delays_ind = unique(varargin{i+1});
            if isempty(delays_ind) || ~all(ismember(delays_ind,1:6))
                error('Incorrect value for property ''delays_ind''.');
            end
        case 'toplot',
            toPlot = varargin{i+1};
            if toPlot~=0 && toPlot ~=1
                error('Incorrect value for property ''toPlot''.');
            end
        case 'samescale',
            samescale = varargin{i+1};
            if samescale~=0 && samescale ~=1
                error('Incorrect value for property ''samescale''.');
            end
        case 'maintitle',
            maintitle = varargin{i+1};
            if ~isstring(maintitle)
                error('Incorrect value for property ''maintitle''.');
            end
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if ~isstring(subfeature)
    error('Incorrect value for property ''subfeature''.');
end

if ~exist('sessions_plot','var')
    sessions_plot=1:5;
else
    suffixe_session = 1;
end
if ~exist('substages_plot','var')
    substages_plot=1:5;
else
    suffixe_substage = 1;
end
if ~exist('delays_ind','var')
    delays_ind=1:6;
end
if ~exist('toPlot','var')
    toPlot=1;
end
if ~exist('samescale','var')
    samescale=0;
end

%% load
cd([FolderProjetDelta 'Data/'])
load QuantifDensityDeltaPerSession_bis.mat

%params
NameSubstages = {'N1','N2', 'N3','REM','Wake'}; % Sleep substages
NameSessions = {'S1','S2','S3','S4','S5'};
NameConditions = {'Basal','140ms','200ms','320ms','490ms','Random'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data to work with
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ratio=0;
density=0;
if strcmpi(data_type,'delta')
    dataname = 'deltas';
    big_title = 'Delta waves';
    ylab = 'delta';
elseif strcmpi(data_type,'down')
    dataname = 'downs';
    big_title = 'Down states';
    ylab = 'down';
elseif strcmpi(data_type,'duration')
    dataname = 'perioduration';
    big_title = 'Duration';
    ylab = 'sec';
elseif strcmpi(data_type,'duration ratio')
    dataname = 'perioduration';
    big_title = 'Duration ratio';
    ylab = '%';
    ratio=1;
end

if strcmpi(permouse,'total')
    dataname = [dataname '.total'];
elseif strcmpi(permouse,'median')
    dataname = [dataname '.median'];
    big_title = [big_title ' (medians)'];
end

if strcmpi(measure,'number')
    dataname = [dataname '.nb'];
    big_title = [big_title ' - '];
    ylab = ['number of ' ylab];
elseif strcmpi(measure,'density')
    dataname = [dataname '.density'];
    big_title = [big_title ' - Density'];
    ylab = [ylab ' per sec'];
    density=1;
end


eval(['data=' dataname ';']) %data is the vector containing data from the collect

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_ouput.data_to_plot = cell(0);
data_ouput.titles = cell(0);
data_ouput.ylab = ylab;

% Each subplot correspond to a substage
if strcmpi(subfeature,'substage') 
    for sub=substages_plot
        data_to_plot = [];
        for d=delays_ind
            if ratio
                total_duration = squeeze(sum(sum(data(d,sessions_plot,:,:),2),3));
                ratios = squeeze(sum(data(d,sessions_plot,sub,:),2)) ./ total_duration;
                data_to_plot = [data_to_plot round(ratios*100,2)];
            elseif density
                data_to_plot = [data_to_plot squeeze(mean(data(d,sessions_plot,sub,:),2))];
            else
                data_to_plot = [data_to_plot squeeze(sum(data(d,sessions_plot,sub,:),2))];
            end
        end
        data_ouput.data_to_plot{end+1} = data_to_plot;    
        data_ouput.titles{end+1} = NameSubstages{sub};
    end
    
    if suffixe_session %suptitle suffixe
        suffixe = '';
        for suf=sessions_plot
            suffixe = [suffixe NameSessions{suf} '-'];
        end
        big_title = [big_title ' ('  suffixe(1:end-1) ')'];
    end
    data_ouput.labels = NameConditions(delays_ind);
    
% Each subplot correspond to a session
elseif strcmpi(subfeature,'session')
    for s=sessions_plot
        data_to_plot = [];
        for d=delays_ind
            if ratio
                total_duration = sum(squeeze(data(d,s,:,:)));
                ratios = squeeze(sum(data(d,s,substages_plot,:),3)) ./ total_duration';
                data_to_plot = [data_to_plot round(ratios*100,2)];
            elseif density
                data_to_plot = [data_to_plot squeeze(mean(data(d,s,substages_plot,:),3))];
            else
                data_to_plot = [data_to_plot squeeze(sum(data(d,s,substages_plot,:),3))];
            end 
        end
        data_ouput.data_to_plot{end+1} = data_to_plot;    
        data_ouput.titles{end+1} = NameSessions{s};
    end
    
    if suffixe_substage %suptitle suffixe
        suffixe = '';
        for sub=substages_plot
            suffixe = [suffixe NameSubstages{sub} '-'];
        end
        big_title = [big_title ' ('  suffixe(1:end-1) ')'];
    end
    data_ouput.labels = NameConditions(delays_ind);
    
% Each subplot correspond to a delay
elseif strcmpi(subfeature,'delay')
    for d=delays_ind
        data_to_plot = [];
        
        
    end

% No subplot
else
    data_to_plot = [];
    for d=delays_ind
        data_to_plot = [];
        for d=delays_ind
            if ratio
                total_duration = squeeze(sum(sum(data(d,:,:,:),2),3));
                ratios = squeeze(sum(sum(data(d,sessions_plot,substages_plot,:),2),3)) ./ total_duration;
                data_to_plot = [data_to_plot round(ratios*100,2)'];
            elseif density
                data_to_plot = [data_to_plot squeeze(mean(mean(data(d,sessions_plot,substages_plot,:),2),3))];
            else
                data_to_plot = [data_to_plot squeeze(sum(sum(data(d,sessions_plot,substages_plot,:),2),3))];
            end
        end
        data_ouput.data_to_plot{1} = data_to_plot;    
        data_ouput.titles{1} = '';

    end
    data_ouput.data_to_plot{1} = data_to_plot;    
    data_ouput.titles{1} = '';
    
    
    if suffixe_session %suptitle suffixe
        suffixe = '';
        for suf=sessions_plot
            suffixe = [suffixe NameSessions{suf} '-'];
        end
        big_title = [big_title ' ('  suffixe(1:end-1) ')'];
    end
    if suffixe_substage %suptitle suffixe
        suffixe = '';
        for sub=substages_plot
            suffixe = [suffixe NameSubstages{sub} '-'];
        end
        big_title = [big_title ' ('  suffixe(1:end-1) ')'];
    end
    data_ouput.labels = NameConditions(delays_ind);

end


%Update suptitle
if exist('maintitle','var')
    data_ouput.big_title = maintitle;
else
    data_ouput.big_title = big_title;
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if toPlot
    nb_subplot = length(data_ouput.data_to_plot);
    
    if nb_subplot>1
        figure, hold on,
        for i=1:nb_subplot
            h(i) = subplot(2,ceil(nb_subplot/2),i); hold on,
            PlotErrorBarN_KJ(data_ouput.data_to_plot{i}, 'newfig',0);
            title(data_ouput.titles{i}), ylabel(data_ouput.ylab), hold on,
            set(gca, 'XTickLabel',data_ouput.labels, 'XTick',1:numel(data_ouput.labels), 'XTickLabelRotation', 30), hold on,
        end
        if samescale
            ylim = max(cell2mat(get(h,'Ylim')));
            set(h,'Ylim',ylim)
        end
        suplabel(data_ouput.big_title,'t');
        
    else
        figure, hold on,
        PlotErrorBarN_KJ(data_ouput.data_to_plot{1}, 'newfig',0);
        title(data_ouput.big_title), ylabel(data_ouput.ylab), hold on,
        set(gca, 'XTickLabel',data_ouput.labels, 'XTick',1:numel(data_ouput.labels), 'XTickLabelRotation', 30), hold on,
    end
end
  
end