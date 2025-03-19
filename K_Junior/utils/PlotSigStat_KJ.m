function [pval,StatAll] = PlotSigStat_KJ(A,varargin)

% function pval= PlotSigStat_KJ(A,varargin)
%
% INPUT:
% - A                       can be a matrice, line corresponds to dots & columns to bars
%                           or a cell Array
%
% - alpĥa (optional)        = alpha - threshold for statistical significance (default 0.05)
% - paired (optional)       = paired test (default 1)
% - optiontest (optional)   = 'ttest' , 'ranksum' (default ranksum)
% - Horizontal (optional)   = (default 0), to display an horizontal bar plot
% - ColumnTest (optional)   = (default 'all pair of columns') pair of columns on which to do statistical tests
% - NonColumnTest (optional)= (default []) pair of columns on which NOT to do statistical tests
% - ShowSigstar (optional)  = (default 'sig') 'none' for no stat
%                             'ns' for only non significant, 'sig' for only
%                             significant, 'all' for all stat
%
%
% OUTPUT:
% - p     = p value from ranksum (default) or ttest
% - stat  = stat  
%
% EXAMPLE
%   [pval,StatAll] = PlotSigStat_KJ(data,'paired',1, 'optiontest',sigtest, 'ShowSigstar',showsig);
% 
%
% SEE 
%   PlotErrorBarN_KJ
%
%
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
        case 'alpha'
            alpha = varargin{i+1};
            if alpha<=0
                error('Incorrect value for property ''alpha''.');
            end
        case 'paired'
            paired = varargin{i+1};
            if paired~=0 && paired ~=1
                error('Incorrect value for property ''paired''.');
            end
        case 'optiontest'
            optiontest = varargin{i+1};
            if ~isstring_FMAToolbox(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'horizontal'
            horizontal = varargin{i+1};
            if horizontal~=0 && horizontal ~=1
                error('Incorrect value for property ''Horizontal''.');
            end
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
            if ~isstring_FMAToolbox(ShowSigstar, 'none' , 'ns', 'sig', 'all')
                error('Incorrect value for property ''ShowSigstar''.');
            end
        case 'x_data'
            x_data = varargin{i+1};
            if ~isvector(x_data)
                error('Incorrect value for property ''x_data''.');
            end  
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('alpha','var')
    alpha=0.05;
end
if ~exist('paired','var')
    paired=1;
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end
if ~exist('horizontal','var')
    horizontal=0;
end
if ~exist('ShowSigstar','var')
    ShowSigstar='sig';
end
if ~exist('x_data','var')
    x_data=[];
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
%number of column
N=size(A,2); 


%default column that are tested statistically
if ~strcmpi(ShowSigstar,'none')
    if ~exist('column_test','var')
        column_test = nchoosek(1:N,2);
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


%% STATISTICAL TESTS

if ~isempty(column_test)
    
    % Rank sum Wilcoxon
    if strcmp(optiontest,'ranksum')
        pval=nan(N,N);
        StatAll = cell(0);
        groups = cell(0);
        stats = [];
        for c=1:length(column_test)
            i = column_test{c}(1);
            j = column_test{c}(2);
            if sum(~isnan(A{i}))>2 && sum(~isnan(A{j}))>2
                if paired
                    idx=find(~isnan(A{i}) & ~isnan(A{j}));
                    [p,h,tstat]= signrank(A{i}(idx),A{j}(idx));
                else
                    [p,h,tstat]=ranksum(A{i}(~isnan(A{i})),A{j}(~isnan(A{j})));
                end
                pval(i,j)=p; pval(j,i)=p;
                StatAll{i,j}=tstat; StatAll{j,i}=tstat;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[x(i) x(j)];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[x(i) x(j)];
                    stats = [stats p];
                end
           end
        end
    % T-test
    elseif strcmp(optiontest,'ttest')
        pval = nan(N,N);
        StatAll = cell(0);
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
                if paired
                    [h,p,~,tstat]=ttest(A{i},A{j});
                else
                    [h,p,~,tstat]=ttest2(A{i},A{j});
                end
                pval(i,j)=p; pval(j,i)=p;
                StatAll{i,j}=tstat; StatAll{j,i}=tstat;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[x(i) x(j)];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[x(i) x(j)];
                    stats = [stats p];
                end
            end
        end
    end
end


%below alpha only
stats(stats>alpha)=nan;

%plot stars eventually
if ~strcmpi(ShowSigstar,'none')
    if ~horizontal
        sigstar(groups,stats)
    else
        sigstarh(groups,stats)
    end
end



%% TERMINATION
if ~exist('pval','var')
    pval=nan;
end
if ~exist('StatAll','var')
    StatAll=nan;
end




end

