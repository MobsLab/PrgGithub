% ClinicTransitionSleepStagePlot
% 30.03.2017 KJ
%
% Graphs quantifying sleep stage transitions
%
%
%%%%%
% INPUT :
%   stage_before:   int - the first sleep stage, before the transition
% 
%   stage_after:    int - the second sleep stage, after the transition
%               
%               1 : N1
%               2 : N2
%               3 : N3
%               4 : REM
%               5 : WAKE
%
%
%%%%%
%   (OPTIONAL)
%   ratio               int - 1: ratio over transition from stage1, 2:ratio over transition to stage2, 0: no ratio
%                       (default 0)
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
%       ClinicTransitionSleepStagePlot(3, 5, 'ratio',1,'show_sig','none','paired',0);       
% 
%
% See
%   ClinicTransitionSleepStage ClinicQuantitySleepPlot 
%   
%

function data = ClinicTransitionSleepStagePlot(stage_before, stage_after, varargin)


%% CHECK INPUTS
if nargin < 2 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

if ~isint(stage_before)
    error('Incorrect value for argument ''stage_before''.');
end
if ~isint(stage_after)
    error('Incorrect value for argument ''stage_after''.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'ratio',
            ratio = varargin{i+1};
            if ratio~=0 && ratio ~=1 && ratio ~=2
                error('Incorrect value for property ''ratio''.');
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

if ~exist('ratio','var')
    ratio=0;
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
load([FolderPrecomputeDreem 'ClinicTransitionSleepStage.mat']) 
conditions = unique(transition_res.condition);
subjects = unique(cell2mat(transition_res.subject));


%% title and labels
maintitle = ['Transitions from ' NameStages{stage_before} ' to ' NameStages{stage_after}]; 

if ratio==1
    y_label = '%';
    maintitle = [maintitle ' (% of ' NameStages{stage_before} ' episode)'];
elseif ratio==2
    y_label = '%';
    maintitle = [maintitle ' (% of ' NameStages{stage_after} ' episode)'];
else
    y_label = 'number of transitions';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

%data
for cond=1:length(conditions)
    path_cond = find(strcmpi(transition_res.condition,conditions{cond}));
    for p=1:length(path_cond)
        data_num = transition_res.nb_transitions{path_cond(p)}(stage_before,stage_after);
        if ratio==1
            data_den = transition_res.nb_episode{path_cond(p)}(stage_before);
        elseif ratio==2
            data_den = transition_res.nb_episode{path_cond(p)}(stage_after);
        else
            data_den = 100;
        end
        data{cond}(p) = 100 * data_num / data_den;
    end
end
labels = conditions;

%plot
PlotErrorBarN_KJ(data, 'newfig',0,'paired',paired,'barcolors',colori,'ShowSigstar',show_sig,'optiontest',optiontest);
ylabel(y_label),
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels)), hold on,
title(maintitle)
   
    



end







