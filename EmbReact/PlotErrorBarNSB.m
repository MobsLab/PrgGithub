function pval=PlotErrorBarNSB(A,newfig,paired,optiontest,ColumnTest,SubSet)

% function pval= PlotErrorBarN(A,newfig,paired,optiontest,ColumnTest)
% inputs:
% - A can be a matrice, line corresponds to dots & columns to bars
%    or a cell Array 
% - newfig (optional) = 1 to display in a new figure, 0 to add on existing 
%                        one (default 1)
% - paired (optional) = 1 if each line are paired data from a unique mouse, 
%                        0 if from independent groups (default 1, -> signrank test)
% - optiontest (optional) = 'ttest' , 'ranksum' (default ranksum) 
% - ColumnTest (optional) = (default 1), change if column to which all
% groups must be compared are not the first one
% Subset of values to make stand out

% outputs:
% - p = p value from ranksum (default) or ttest
%% CHECK INPUTS
if ~exist('newfig','var')
    newfig=1;
end
if ~exist('paired','var')
    paired=1;
end
if ~exist('optiontest','var')
    optiontest='ranksum';
end
if ~exist('ColumnTest','var')
    ColumnTest=1;
end
if ~exist('SubSet','var')
    SubSet=[];
end

if ~iscell(A)
    tempA=A; A={};
    for i=1:size(tempA,2)
        A{i}=tempA(:,i);
    end
end

%% GET DATA FROM A

N=length(A);
R=[];
E=[];

for i=1:N
    [Ri,Si,Ei]=MeanDifNan(A{i});
    R=[R,Ri];
    E=[E,Ei];
end


%% DISPLAY

if newfig
    figure('color',[1 1 1]),
end
figure(gcf), hold on, 
bar(R,0.5,'FaceColor',[0.3 0.3 0.3],'EdgeColor','k')
errorbar(R,E,'+','Color','k')
xlim([0 N+1])

if paired
    for i=1:N-1
        temp=A{i};
        tempi=A{i+1};
        try line([i*ones(length(temp),1) (i+1)*ones(length(tempi),1)]',[temp tempi]','color',[0.6 0.6 0.6]); end
            if not(isempty(SubSet))
        try line([i*ones(length(SubSet),1) (i+1)*ones(length(SubSet),1)]',[temp(SubSet) tempi(SubSet)]','color','b'); end
            end
    end
end

for i=1:N
    temp=A{i}(~isnan(A{i}));
    plot(i*ones(length(temp),1),temp,'ko','markerfacecolor','w','markersize',5)
    if not(isempty(SubSet))
        temp=A{i};
        temp=temp(SubSet);
        temp=temp(~isnan(temp));
        plot(i*ones(length(temp),1),temp,'ko','markerfacecolor','b','markersize',5)
    end
end


%% STATISTICAL TESTS

fac=1;
thSig=0.05;

if strcmp(optiontest,'ranksum')
    pval=nan(1,length([1:ColumnTest-1,ColumnTest+1:N]));
    for i=[1:ColumnTest-1,ColumnTest+1:N]
        if sum(~isnan(A{ColumnTest}))>2 && sum(~isnan(A{i}))>2
            
            if paired
                a3=find(~isnan(A{ColumnTest}) & ~isnan(A{i}));
                [p,h]= signrank(A{ColumnTest}(a3),A{i}(a3));
            else
                [p,h]=ranksum(A{ColumnTest}(~isnan(A{ColumnTest})),A{i}(~isnan(A{i})));
            end
            pval(i)=p;
            if h==1 && p<thSig && p>0.01
                text(i,max(A{i})+max(E)*(1+1/fac),'*','Color','k')
            elseif h==1 && p<0.01 && p>0.001
                text(i,max(A{i})+max(E)*(1+1/fac),'**','Color','k')
            elseif h==1 && p<0.001
                text(i,max(A{i})+max(E)*(1+1/fac),'***','Color','k')
            end
        end
    end
    
    
elseif strcmp(optiontest,'ttest')
    % normality
    for i=1:N
        [hi,pi,di]=swtest(A{i},0.05);
        hnorm(i)=hi;
    end
    % normal distributions with same variance
    for i=1:N
        for j=i:N
            [hi,pi,di]=vartest2(A{i},A{j});
            hvar(i,j)=hi;
        end
    end
    pval=nan(1,length([1:ColumnTest-1,ColumnTest+1:N]));
    for i=[1:ColumnTest-1,ColumnTest+1:N]
        
        if hnorm(i)+hnorm(ColumnTest)==0 && hvar(min(i,ColumnTest),max(i,ColumnTest))==0
            % parametric tests ANOVA?
            [h,p]=ttest2(A{ColumnTest},A{i});
            if p<thSig && p>0.01
                text(i,max(A{i})+max(E)*(1+1/fac),'*','Color','k')
            elseif p<0.01 & p>0.001
                text(i,max(A{i})+max(E)*(1+1/fac),'**','Color','k')
            elseif p<0.001
                text(i,max(A{i})+max(E)*(1+1/fac),'***','Color','k')
            end
            pval(i)=p;
        else
            text(i,max(A{i})+max(E)*(1+1/fac),'NaN')
        end
        
    end
    
end

%% TERMINATION
if ~exist('p','var')
    p=nan;
end



