% AnalysesISIDeltaToneSubstagePlot
% 18.02.2017 KJ
%
% Graphs quantifying the ISI between deltas, for each substage and many conditions 
%
%
%%%%%
% INPUT :
%   substage:       int - choose a substage in the list below
%               1 : N1
%               2 : N2
%               3 : N3
%               4 : REM
%               5 : WAKE
%               6 : NREM
%
%   condition:      int - choose a condition in the list below
%               1 : Basal (already ploted)
%               2 : RdmTone
%               3 : Tone   0ms
%               4 : Tone 140ms
%               5 : Tone 320ms
%               6 : Tone 490ms
%
%
%%%%%
%   (OPTIONAL)
%   isi_idx             int or list - choose which ISI to plot (1,2,3,2-3,3-1,3-2)
%                       (default all)
%   orderby             string - how to order bar plots
%                       (default 'tones') 'tones' to order by tones, 'isi' to order by isi rank
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
%       AnalysesISIDeltaToneSubstagePlot(6, 6, 'show_sig','none','paired',1);       
% 
%
% See
%   QuantitySleepDeltaPlot AnalysesISIDeltaToneSubstage FigureISITrig490
%   
%



function data = AnalysesISIDeltaToneSubstagePlot(substage, condition, varargin)


%% CHECK INPUTS
if nargin < 2 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

if ~isvector(substage)
    error('Incorrect value for argument ''substage''.');
end
if ~isvector(condition)
    error('Incorrect value for argument ''condition''.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'orderby',
            orderby = varargin{i+1};
            if ~isstring_FMAToolbox(orderby, 'tones' , 'isi')
                error('Incorrect value for argument ''orderby''.');
            end
        case 'isi_idx',
            isi_idx = varargin{i+1};
            if ~isvector(isi_idx)
                error('Incorrect value for argument ''isi_idx''.');
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
        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

if ~exist('orderby','var')
    orderby='tones';
end
if ~exist('isi_idx','var')
    isi_idx=1:6;
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
NameSubstages = {'N1','N2', 'N3','REM','Wake','NREM'}; % Sleep substages
NameISI = {'n+1','n+2','n+3','(n+2)-(n+1)','(n+3)-(n+1)','(n+3)-(n+2)'}; %ISI

cond_fig = condition;
cond_basal = 1;
substage_plot = substage;
nb_isi = isi_idx;

%% load
load(fullfile(FolderDeltaDataKJ,'AnalysesISIDeltaToneSubstage.mat'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ORDER BY TONES type
if strcmpi(orderby,'tones')
    
    %paired data
    if paired
        data=[];
        for i=nb_isi
            data=[data squeeze(cell2mat(mouse.isi.median(cond_fig,substage_plot,:,i,yes,yes)))]; %success
        end
        for i=nb_isi
            data=[data squeeze(cell2mat(mouse.isi.median(cond_fig,substage_plot,:,i,yes,no)))]; %failed
        end
        for i=nb_isi
            data=[data squeeze(cell2mat(mouse.isi.median(cond_basal,substage_plot,:,i,1,1)))]; %basal
        end

        for i=nb_isi
            mean_success_x(i) = nanmean(data(:,i));
            mean_failed_x(i) = nanmean(data(:,i+3));
        end
    % not paired
    else
        data=cell(0);
        for i=nb_isi
            data{end+1} = squeeze(cell2mat(nights.isi.median(cond_fig,substage_plot,:,i,yes,yes))); %success
        end
        for i=nb_isi
            data{end+1} = squeeze(cell2mat(nights.isi.median(cond_fig,substage_plot,:,i,yes,no))); %failed
        end
        for i=nb_isi
            data{end+1} = squeeze(cell2mat(nights.isi.median(cond_basal,substage_plot,:,i,1,1))); %basal
        end

        for i=nb_isi
            mean_success_x(i) = nanmean(data{i});
            mean_failed_x(i) = nanmean(data{i+3});
        end
    end
    
    labels=cell(0);
    bar_color = cell(0);
    for i=nb_isi
        labels{end+1} = ['Success Tones ' NameISI{i}];
        bar_color{end+1} = 'b';
    end
    for i=nb_isi
        labels{end+1} = ['Failed Tones ' NameISI{i}];
        bar_color{end+1} = 'r';
    end
    for i=nb_isi
        labels{end+1} = ['Basal ' NameISI{i}];
        bar_color{end+1} = [0.2 0.2 0.2];
    end
    
    nct = nchoosek([1 1+length(nb_isi) 1+2*length(nb_isi)],2);
    columtest = [];
    for i=1:length(nb_isi);
        columtest = [columtest ; nct+i-1];
    end
    
%% ORDER BY ISI RANK
elseif strcmpi(orderby,'isi')
    %paired data
    if paired
        data=[];
        for i=nb_isi
            data=[data squeeze(cell2mat(mouse.isi.median(cond_fig,substage_plot,:,i,yes,yes)))]; %success
            mean_success_x(i) = nanmean(data(:,end));
            data=[data squeeze(cell2mat(mouse.isi.median(cond_fig,substage_plot,:,i,yes,no)))]; %failed
            mean_failed_x(i) = nanmean(data(:,end));
            data=[data squeeze(cell2mat(mouse.isi.median(cond_basal,substage_plot,:,i,1,1)))]; %basal
        end
        
        % not paired
    else
        data=cell(0);
        for i=nb_isi
            data{end+1} = squeeze(cell2mat(nights.isi.median(cond_fig,substage_plot,:,i,yes,yes))); %success
            mean_success_x(i) = nanmean(data{end});
            data{end+1} = squeeze(cell2mat(nights.isi.median(cond_fig,substage_plot,:,i,yes,no))); %failed
            mean_failed_x(i) = nanmean(data{end});
            data{end+1} = squeeze(cell2mat(nights.isi.median(cond_basal,substage_plot,:,i,1,1))); %basal            
        end
    end
    
    labels=cell(0);
    bar_color = cell(0);
    for i=nb_isi
        labels{end+1} = ['Success Tones ' NameISI{i}];
        labels{end+1} = ['Failed Tones ' NameISI{i}];
        labels{end+1} = ['Basal ' NameISI{i}];
        bar_color{end+1} = 'b'; bar_color{end+1} = 'r'; bar_color{end+1} = [0.2 0.2 0.2];
    end
    columtest  = [nchoosek(1:length(nb_isi),2) ; nchoosek(1:length(nb_isi),2) + length(nb_isi); nchoosek(1:length(nb_isi),2) + 2*length(nb_isi)];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,


%bar plot
[~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'horizontal',1,'barcolors',bar_color,'ColumnTest',columtest,'ShowSigstar',show_sig, 'optiontest',optiontest,'paired',paired);
title([NameSubstages{substage_plot} ' - ' conditions{cond_fig}],'fontsize',20), xlabel('ms'), hold on,
set(eb,'Linewidth',2); %bold error bar
set(gca, 'YTickLabel',labels, 'YTick',1:numel(labels),'FontName','Times','fontsize',15), hold on,
set(gca, 'XTick',0:1000:3000,'XLim',[0 3500]);

%lines
if strcmpi(orderby,'tones')
    for i=nb_isi
        line([mean_success_x(i) mean_success_x(i)], [i i+6.3], 'color', 'b', 'LineStyle', '--'), hold on
    end
    for i=nb_isi
        line([mean_failed_x(i) mean_failed_x(i)], [i+3 i+6.3], 'color', 'r', 'LineStyle', '--'), hold on
    end
end




end




