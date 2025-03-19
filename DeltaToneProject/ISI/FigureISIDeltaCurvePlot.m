% FigureISIDeltaCurvePlot
% 17.04.2017 KJ
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
%       FigureISIDeltaCurvePlot(6, 6, 'show_sig','none','paired',0);       
% 
%
% See
%   QuantitySleepDeltaPlot AnalysesISIDeltaToneSubstagePlot FigureISITrig490
%   
%



function data = FigureISIDeltaCurvePlot(substage, condition, varargin)


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
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'isi_idx'
            isi_idx = varargin{i+1};
            if ~isvector(isi_idx)
                error('Incorrect value for argument ''isi_idx''.');
            end
        case 'newfig'
            newfig = varargin{i+1};
            if newfig~=0 && newfig ~=1
                error('Incorrect value for property ''newfig''.');
            end
        case 'show_sig'
            show_sig = varargin{i+1};
            if ~isstring_FMAToolbox(show_sig, 'none' , 'ns', 'sig', 'all')
                error('Incorrect value for property ''show_sig''.');
            end
        case 'optiontest'
            optiontest = varargin{i+1};
            if ~isstring_FMAToolbox(optiontest, 'ttest' , 'ranksum')
                error('Incorrect value for property ''optiontest''.');
            end
        case 'paired'
            paired = varargin{i+1};
            if paired~=1 && paired~=0
                error('Incorrect value for property ''paired''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
        
    end
end

% substage=6;
% condition=6;

if ~exist('isi_idx','var')
    isi_idx=1:3;
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
NameISI = {'d(n,n+1)','d(n,n+2)','d(n,n+3)','d(n+1,n+2)','d(n+1,n+3)','d(n+2,n+3)'}; %ISI
lineColors = {'b','r',[0.2 0.2 0.2]};
labels = {'Success','Failed','Basal'};

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

end


%sig and column
nct = nchoosek([1 1+length(nb_isi) 1+2*length(nb_isi)],2);
column_test = [];
for i=1:length(nb_isi);
    column_test = [column_test ; nct+i-1];
end

if strcmpi(show_sig,'sig')
    ShowNS = 0;
    ShowSig = 1;
elseif strcmpi(show_sig,'ns')
    ShowNS = 1;
    ShowSig = 0;
elseif strcmpi(show_sig,'all')
    ShowNS = 1;
    ShowSig = 1;
end

if ~strcmpi(show_sig,'none')
    column_test = mat2cell(column_test,ones(1,size(column_test,1)),2);
else 
    column_test = cell(0);
end
   

%% Stat data
N=length(data); %number of column
R=[];
E=[];

for i=1:N
    [Ri,~,Ei]=MeanDifNan(data{i});
    R=[R,Ri];
    E=[E,Ei];
end


%% lines

for i=1:length(labels)
    idx_line = (1:length(nb_isi)) + (i-1)*length(nb_isi);
    x_line{i} =  R(idx_line);
    bar_line{i} = E(idx_line);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%insert graph in an existing figure or create a new one
if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on,

%lines
for i=1:length(labels)
    hpl(i)=plot(x_line{i}, 1:length(nb_isi),'color',lineColors{i},'Linewidth',2); hold on
end
%error bar
for i=1:length(labels)
    eb=herrorbar(x_line{i},1:length(nb_isi),bar_line{i},'.k'); hold on
    set(eb,'Linewidth',2); %bold error bar
end

title([NameSubstages{substage_plot} ' - ' conditions{cond_fig}],'fontsize',20), xlabel('ms'), hold on,
set(gca, 'YTickLabel',NameISI(nb_isi), 'YTick',1:length(nb_isi),'YLim',[0.5 length(nb_isi)+0.5],'FontName','Times','fontsize',20), hold on,
set(gca, 'XTick',0:1000:3000,'XLim',[0 3500]);
    

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
            if sum(~isnan(data{i}))>2 && sum(~isnan(data{j}))>2
                if paired
                    idx=find(~isnan(data{i}) & ~isnan(data{j}));
                    [p,h]= signrank(data{i}(idx),data{j}(idx));
                else
                    [p,h]=ranksum(data{i}(~isnan(data{i})),data{j}(~isnan(data{j})));
                end
                pval(i,j)=p; pval(j,i)=p;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[R(i) R(j)];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[R(i) R(j)];
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
            [hi,~,~]=swtest(data{i},0.05);
            hnorm(i)=hi;
        end
        % normal distributions with same variance
        for i=1:N
            for j=i:N
                [hi,~,~]=vartest2(data{i},data{j});
                hvar(i,j)=hi;
            end
        end
        % test
        for c=1:length(column_test)
            i = column_test{c}(1);
            j = column_test{c}(2);
            if hnorm(i)+hnorm(j)==0 && hvar(min(i,j),max(i,j))==0
                [h,p]=ttest2(data{i},data{j});
                pval(i,j)=p; pval(j,i)=p;
                if h==1 && ShowSig==1
                    groups{length(groups)+1}=[R(i) R(j)];
                    stats = [stats p];
                elseif h==0 && ShowNS==1
                    groups{length(groups)+1}=[R(i) R(j)];
                    stats = [stats p];
                end
            end
        end
        stats(stats>thresh_signif)=nan;
        sigstar(groups,stats)

    end
end

legend(hpl,labels)


end








