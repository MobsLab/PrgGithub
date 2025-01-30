function [pval,eb] = PlotErrorNox_KJ(A,varargin)

% function [pval,eb] = PlotErrorNox_KJ(A,varargin)
%
% INPUT:
% - A                       can be a matrice, line corresponds to dots & columns to bars
%                           or a cell Array
%
% - newfig (optional)       = 1 to display in a new figure, 0 to add on existing 
%                           one (default 1)
% - paired (optional)       = 1 if each line are paired data from a unique mouse, 
%                           0 if from independent groups (default 1, -> signrank test)
% - optiontest (optional)   = 'ttest' , 'ranksum' (default ranksum)
% - barcolors (optional)    = (default []), to change the colors of the bars
% - barwidth (optional)     = (default []), to change the width of the bars 
% - x_data (optional)       = (default []) value to put in the x-axis
% - showPoints (optional)   = (default 1), 0 to not display individual points 
% - ColumnTest (optional)   = (default 'all pair of columns') pair of columns on which to do statistical tests
% - NonColumnTest (optional)= (default []) pair of columns on which NOT to do statistical tests
% - ShowSigstar (optional)  = (default 'sig') 'none' for no stat
%                             'ns' for only non significant, 'sig' for only
%                             significant, 'all' for all stat
% - y_lim (optional)        = (default None), impose ylim to the graph
%
%
% OUTPUT:
% - p  = p value from ranksum (default) or ttest
% - eb = errorbar handle  
%
%
%       see PlotErrorBarN PlotErrorLineN_KJ PlotErrorSpreadN_KJ
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
            if ~isstring_FMAToolbox(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'showpoints'
            showpoints = varargin{i+1};
            if showpoints~=0 && showpoints ~=1
                error('Incorrect value for property ''showPoints''.');
            end
        case 'barcolors'
            barcolors = varargin{i+1};
        case 'barwidth'
            barwidth = varargin{i+1};
            if ~isvector(barwidth) || length(barwidth)~=1
                error('Incorrect value for property ''barwidth''.');
            end
        case 'x_data'
            x_data = varargin{i+1};
            if ~isvector(x_data)
                error('Incorrect value for property ''x_data''.');
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
    paired=1;
end
if ~exist('optiontest','var')
    optiontest='ranksum';
if ~exist('showpoints','var')
    showpoints=1;
end
if ~exist('barcolors','var')
    barcolors=[];
end
if ~exist('barwidth','var')
    barwidth=[];
end
if ~exist('x_data','var')
    x_data=[];
end
if ~exist('ShowSigstar','var')
    ShowSigstar='sig';
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
    x_data = 1:length(A);
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

jitter= 0.3;
jitScale=jitter*0.55; %To scale the patch by the width of the jitter

%% GET DATA FROM A

N=length(A); %number of column
R=[];
E=[];
S=[];

for i=1:N
    if ~isempty(A{i})
        [Ri,Si,Ei]=MeanDifNan(A{i});
        R=[R,Ri];
        S=[S,Si];
        E=[E,Ei];
    else
        R=[R,nan];
        S=[S,nan];
        E=[E,nan];
    end
end


%% DISPLAY

%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,


%% BAR PLOT
X_plot = [];

for i=1:length(R)
    % patch SD
    h(i).sdPtch=patchMaker(S(i),patchColors{2});
    
    % patch SEM
    h(i).semPtch=patchMaker(E(i),patchColors{1});
    
    % line mean
    h(i).mu=plot([x_data(i)-jitScale,x_data(i)+jitScale],[R(i),R(i)],'-r', 'linewidth',2);
    
    % if showPoints is equal to 1
    if showpoints
        %plot points, indicating value for each individual
        thisY = A(:,i);
        thisY = thisY(~isnan(thisY));
        thisX = repmat(x_data(i),1,length(thisY));

        % Generate scatter in X 
        thisX = violaPoints(thisX,thisY);
        h(i).data = plot(thisX, thisY, 'o', 'color', C, 'markerfacecolor', [0.3 0.3 0.3]);
        
        X_plot = [X_plot thisX];
    end
    
end


% line bonding points
if paired
    M = cell2mat(A);
    if size(M,1)==1
        M=cell2mat(A')';
    end
    nb_individual=size(M,1); %number of indivudual
    
    if showpoints
        for k=1:nb_individual
            idx = find(~isnan(M(k,:)));
            for i=1:length(idx)-1
                try 
                    line(0.1+[X_plot(k,idx(i)) X_plot(k,idx(i+1))]', [M(k,idx(i)) M(k,idx(i+1))]', 'color',[0.6 0.6 0.6]); 
                end
            end
        end
    end
end


%     xlim([0 N+1])
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
                    groups{length(groups)+1}=[x_data(i) x_data(j)];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[x_data(i) x_data(j)];
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
                if paired
                    [h,p]=ttest(A{i},A{j});
                else
                    [h,p]=ttest2(A{i},A{j});
                end
                pval(i,j)=p; pval(j,i)=p;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[x_data(i) x_data(j)];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[x_data(i) x_data(j)];
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

end


function ptch=patchMaker(k,thisInterval,tColor)
    %This nested function builds a patch for the SD or SEM
    l=R(k)-thisInterval;
    u=R(k)+thisInterval;
    ptch=patch([x_data(k)-jitScale, x_data(k)+jitScale, x_data(k)+jitScale, x_data(k)-jitScale],...
            [l,l,u,u], 0);
    set(ptch,'edgecolor',tColor*0.8,'facecolor',tColor)
end %function patchMaker


function X=violaPoints(X,Y)
    % Variable jitter according to how many points occupy each range of values. 
    [counts,~,bins] = histcounts(Y,10);
    inds = find(counts~=0);
    counts = counts(inds);

    Xr = X;
    for jj=1:length(inds)
        tWidth = jitter * (1-exp(-0.1 * (counts(jj)-1)));
        xpoints = linspace(-tWidth*0.8, tWidth*0.8, counts(jj));
        Xr(bins==inds(jj)) = xpoints;
    end
    X = X+Xr;
end % function violaPoints


