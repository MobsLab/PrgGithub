function [pval,ax] = PlotErrorLineN_KJ(A,varargin)

% function pval= PlotErrorLineN_KJ(x,A,varargin)
%
% INPUT:
% - A                       can be a matrice, line corresponds to dots & columns to bars
%                           or a cell Array
%
% - newfig (optional)       = 1 to display in a new figure, 0 to add on existing 
%                           one (default 1)
% - paired (optional)       = 1 if each line are paired data from a unique mouse, 
%                           0 if from independent groups (default 0)
% - optiontest (optional)   = 'ttest' , 'ranksum' (default ranksum)
% - x_data (optional)       = (default []) value to put in the x-axis
% - errorbars (optional)    = (default 0) 1 to plot the errorbars, 0 otherwise
% - median (optional)       = (default 0) 1 to display the median, 0 for the mean
% - linecolor (optional)    = (default 'k'), to change the color of the line
% - linewidth (optional)    = (default 2), Linewidth of the line
% - linespec (optional)     = (default []), LineSpec of the line 
% - ColumnTest (optional)   = (default 'all pair of columns') pair of columns on which to do statistical tests
% - NonColumnTest (optional)= (default []) pair of columns on which NOT to do statistical tests
% - ShowSigstar (optional)  = (default 'none') 'none' for no stat
%                             'ns' for only non significant, 'sig' for only
%                             significant, 'all' for all stat
% - y_lim (optional)        = (default None), impose ylim to the graph
%
%
% OUTPUT:
% - p   = p-value from ranksum (default) or ttest
% - ax  = axe of the plot (line) 
%
%       see PlotErrorBarN_KJ PlotErrorSpreadN_KJ
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'newfig'
            newfig = varargin{i+1};
            if newfig~=0 && newfig ~=1
                error('Incorrect value for property ''newfig''.');
            end
        case 'paired'
            paired = varargin{i+1};
            if paired~=0 && paired ~=1
                error('Incorrect value for property ''paired''.');
            end
        case 'optiontest'
            optiontest = varargin{i+1};
            if ~isastring(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'x_data'
            x_data = varargin{i+1};
            if ~isvector(x_data)
                error('Incorrect value for property ''x_data''.');
            end
        case 'errorbars'
            errorbars = varargin{i+1};
            if errorbars~=0 && errorbars ~=1
                error('Incorrect value for property ''errorbars''.');
            end 
        case 'median'
            median = varargin{i+1};
            if median~=0 && median ~=1
                error('Incorrect value for property ''median''.');
            end 
        case 'linecolor'
            linecolor = varargin{i+1};
        case 'linewidth'
            linewidth = varargin{i+1};
        case 'linespec'
            linespec = varargin{i+1};    
        case 'columntest'
            column_test = varargin{i+1};
            if size(column_test,2)~=2
                error('Incorrect value for property ''ColumnTest''.');
            end
        case 'noncolumntest'
            noncolumn_test = varargin{i+1};
            if size(noncolumn_test,2)~=2
                error('Incorrect value for property ''NonColumnTest''.');
            end
        case 'showsigstar'
            ShowSigstar = varargin{i+1};
            if ~isastring(ShowSigstar, 'none' , 'ns', 'sig', 'all')
                error('Incorrect value for property ''ShowSigstar''.');
            end
        case 'y_lim'
            y_lim = varargin{i+1};
            if ~isvector(y_lim) || length(y_lim)~=2
                error('Incorrect value for property ''y_lim''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('newfig','var')
    newfig=1;
end
if ~exist('paired','var')
    paired=0;
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end
if ~exist('x_data','var')
    x_data=[];
end
if ~exist('errorbars','var')
    errorbars=0;
end
if ~exist('median','var')
    median=0;
end
if ~exist('linecolor','var')
    linecolor='k';
end
if ~exist('linewidth','var')
    linewidth=2;
end
if ~exist('linestyle','var')
    linespec=[];
end
if ~exist('ShowSigstar','var')
    ShowSigstar='none';
end

%eventually formating A to cell
if ~iscell(A)
    tempA=A; A={};
    for i=1:size(tempA,2)
        A{i}=tempA(:,i);
    end
end
% value for x, by default
if isempty(x_data)
    x = 1:length(A);
else
    x = x_data;
end

%default column that are tested statistically
if ~strcmpi(ShowSigstar,'none')
    if ~exist('column_test','var')
        column_test = nchoosek(1:length(A),2);
    end 
    if exist('noncolumn_test','var')
        [~,indx] = ismember(noncolumn_test, column_test,'rows');
        column_test(indx,:) = [];
    end
    column_test = mat2cell(column_test,ones(1,size(column_test,1)),2);
else
    column_test = cell(0);
end

if strcmpi(ShowSigstar,'sig')
    ShowNS = 0;
    ShowSig = 1;
elseif strcmpi(ShowSigstar,'ns')
    ShowNS = 1;
    ShowSig = 0;
elseif strcmpi(ShowSigstar,'all')
    ShowNS = 1;
    ShowSig = 1;
end


%% GET DATA FROM A

N=length(A); %number of column
R=[];
E=[];

for i=1:N
    [Ri,~,Ei] = MeanDifNan(A{i});
    if median
        Ri = nanmedian(A{i});
    end
    R=[R,Ri];
    E=[E,Ei];
end


%% DISPLAY

%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

%plot
if isempty(linespec)
    ax = plot(x, R, 'color', linecolor,'Linewidth',linewidth);
else
    ax = plot(x, R, linespec,'Linewidth',linewidth);
end

%plot the bars with the errors
if errorbars
    errorbar(x,R,E,'+','Color',linecolor, 'Linewidth',linewidth)
end
if exist('y_lim','var')
    ylim(y_lim)
end


%% STATISTICAL TESTS

thresh_signif=0.05;  % stat param: threshold for statistical significance

if ~isempty(column_test)
    
    % Rank sum Wilcoxon
    if strcmp(optiontest,'ranksum')
        pval=nan(N,N);
        groups = cell(0);
        stats = [];
        for c=1:length(column_test)
            i = column_test{c}(1);
            j = column_test{c}(2);
            if sum(~isnan(A{i}))>2 && sum(~isnan(A{j}))>2
                if paired
                    idx=find(~isnan(A{i}) & ~isnan(A{j}));
                    [p,h]= signrank(A{i}(idx),A{j}(idx));
                else
                    [p,h]=ranksum(A{i}(~isnan(A{i})),A{j}(~isnan(A{j})));
                end
                pval(i,j)=p; pval(j,i)=p;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[i j];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[i j];
                    stats = [stats p];
                end
           end
        end
        stats(stats>thresh_signif)=nan;
        sigstar(groups,stats)

    % T-test
    elseif strcmp(optiontest,'ttest')
        pval=nan(N,N);
        groups = cell(0);
        stats = [];
        % normality
        for i=1:N
            [hi,~,~]=swtest(A{i},0.05);
            hnorm(i)=hi;
        end
        % normal distributions with same variance
        for i=1:N
            for j=i:N
                [hi,~,~]=vartest2(A{i},A{j});
                hvar(i,j)=hi;
            end
        end
        % test
        for c=1:length(column_test)
            i = column_test{c}(1);
            j = column_test{c}(2);
            if hnorm(i)+hnorm(j)==0 && hvar(min(i,j),max(i,j))==0
                [h,p]=ttest2(A{i},A{j});
                pval(i,j)=p; pval(j,i)=p;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[i j];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[i j];
                    stats = [stats p];
                end
            end
        end
        stats(stats>thresh_signif)=nan;
        sigstar(groups,stats)
    end
end

%% TERMINATION
if ~exist('pval','var')
    pval=nan;
end



