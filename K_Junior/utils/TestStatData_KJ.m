function [stats, groups] = TestStatData_KJ(A,varargin)

% function [stats, group] = TestStatData_KJ(A,varargin)
%
% INPUT:
% - A                       can be a matrice, line corresponds to dots & columns to bars
%                           or a cell Array
%
% - paired (optional)       = 1 if each line are paired data from a unique mouse, 
%                           0 if from independent groups (default 1, -> signrank test)
% - optiontest (optional)   = 'ttest' , 'ranksum' (default ranksum)
% - ColumnTest (optional)   = (default 'all pair of columns') pair of columns on which to do statistical tests
% - NonColumnTest (optional)= (default []) pair of columns on which NOT to do statistical tests
% - ShowSigstar (optional)  = (default 'sig') 'none' for no stat
%                             'ns' for only non significant, 'sig' for only
%                             significant, 'all' for all stat
% 
% OUTPUT:
% - stats       = p-value from test
% - groups      = groups (column) tested in stat
%
%       see PlotErrorBarN_KJ
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
        case 'shownonsig'
            shownonsig = varargin{i+1};
            if shownonsig~=0 && shownonsig ~=1
                error('Incorrect value for property ''shownonsig''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('paired','var')
    paired=1;
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end
if ~exist('ShowNS','var')
    shownonsig=0;
end

%eventually formating A to cell
if ~iscell(A)
    tempA=A; A={};
    for i=1:size(tempA,2)
        A{i}=tempA(:,i);
    end
end

%default column that are tested statistically
if ~exist('column_test','var')
    column_test = nchoosek(1:length(A),2);
end 
if exist('noncolumn_test','var')
    [~,indx] = ismember(noncolumn_test, column_test,'rows');
    column_test(indx,:) = [];
end
column_test = mat2cell(column_test,ones(1,size(column_test,1)),2);

%params
thresh_signif=0.05;  % stat param: threshold for statistical significance
N=length(A); %number of column


%% Rank sum Wilcoxon
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
            if h==1
                groups{length(groups)+1}=[i j];
                stats = [stats p];
            elseif h==0 && shownonsig==1
                groups{length(groups)+1}=[i j];
                stats = [stats p];
            end
       end
    end
    stats(stats>thresh_signif)=nan;
end
    
%% T-test
if strcmp(optiontest,'ttest')
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
            [hi,~,~] = vartest2(A{i},A{j});
            hvar(i,j) = hi;
        end
    end
    % test
    for c=1:length(column_test)
        i = column_test{c}(1);
        j = column_test{c}(2);
        if hnorm(i)+hnorm(j)==0 && hvar(min(i,j),max(i,j))==0
            [h,p] = ttest2(A{i},A{j});
            pval(i,j)=p; pval(j,i)=p;
            if h==1
                groups{length(groups)+1}=[i j];
                stats = [stats p];
            elseif h==0 && shownonsig==1
                groups{length(groups)+1}=[i j];
                stats = [stats p];
            end
        end
    end
    stats(stats>thresh_signif)=nan;
end


end









