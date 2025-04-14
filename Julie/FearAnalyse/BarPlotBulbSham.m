function BarPlotBulbSham(Table,TableName,Gpcolor,test,n,p,j, info,varargin)

% INPUTS
% - Table:
% - TableName : for the title and for the filename2save for stats
% - n,p : for subplot (n nb lines , p nb columns)
% - test: can be 'kruskal' or 'ranksum'
% - savestats : 0 or 1.  if 1, it save statistics as TableName_stats.mat
% - Leg can be {'pre','post', '+6j', '+3wk'} or {'noCS','CS-','CS+1','CS+2','CS+3'} Leg is a cell array containing the name of the steps
% - 'errorbar'can 'SD' or 'sem' added 04.02.2016 (before only SD)
% - indivdots : 0 or 1


% Julie janv 2015

% Define the defaults values for varargin
savestats=1;
errorbarflag='SD';
indivdots=1;
% legend adapted to the Table size
Leg={};
for k=1:size(Table{1,1},2) % Leg={'1','2', '3', '4','5'};
    Leg=[Leg; num2str(k)];
end


for i = 1:2:length(varargin),
  switch(lower(varargin{i})),
    case 'savestats'
        savestats=varargin{i+1};
    case 'legendtype',
        Leg= varargin{i+1};
        if strcmp(Leg, 'explo')
            Leg={'p_r_e','p_o_s_t', '+_6_j', '+_3_w_k'};
        elseif strcmp(Leg, 'freezing')
            Leg={'n_o_C_S','C_S_-','C_S_+_1','C_S_+_2','C_S_+_3'};
        else
            disp('precise legend')
        end
     case 'errorbar',
         errorbarflag= varargin{i+1};
     case 'indivdots',
         indivdots= varargin{i+1};
  end
end
 
subplot(n,p,j);
% build the abscissae vectors
X1=[0.8:1:(size(Table{1,1},2)-0.2)];
X2=[1.2:1:(size(Table{1,2},2)+0.2)];
multiX1=[];
multiX2=[];
for i=1:size(Table{1,1}, 1)
    multiX1=[multiX1; X1];
end
for i=1:size(Table{1,2}, 1)
    multiX2=[multiX2; X2];
end
% plot
h1=bar(X1,nanmean(Table{1,1})','FaceColor',Gpcolor{1}, 'BarWidth', 0.4);hold on; % important to flip the matrices to have them correctlmy plotted
h2=bar(X2,nanmean(Table{1,2})','FaceColor',Gpcolor{2}, 'BarWidth', 0.4);
if strcmp (errorbarflag,'SD')
    e1=errorbar(X1,nanmean(Table{1,1})',nanstd(Table{1,1})','k','LineStyle', 'none');
    e2=errorbar(X2,nanmean(Table{1,2})',nanstd(Table{1,2})','k','LineStyle', 'none');
elseif strcmp (errorbarflag,'sem')
    e1=errorbar(X1,nanmean(Table{1,1})',nanstd(Table{1,1})'./sqrt(sum(~isnan(Table{1,1})))','k','LineStyle', 'none');
    e2=errorbar(X2,nanmean(Table{1,2})',nanstd(Table{1,2})'./sqrt(sum(~isnan(Table{1,2})))','k','LineStyle', 'none');
end
if indivdots==1
    h4=scatter(multiX1(:),Table{1,1}(:),'Marker','o','MarkerEdgeColor','k', 'MarkerFaceColor',[0.5 0.5 0.5],'LineWidth', 1,'SizeData',8); % 'SizeData',15
    h5=scatter(multiX2(:),Table{1,2}(:),'Marker','o','MarkerEdgeColor','k', 'MarkerFaceColor',[0.5 0.5 0.5], 'LineWidth', 1,'SizeData',8);
end
set(gca, 'XTick',[]);
Ylimit=get(gca,'YLim');
set(gca, 'YLim', [0 Ylimit(2)])
ylabel(TableName)

text(-0.12, 1.2, errorbarflag, 'units', 'normalized')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ANOVA 
values_for_ANOVA=[Table{1,1};Table{1,2}];
s1=ones(size(values_for_ANOVA,1),1);
sesF=[];
for i=1:size(values_for_ANOVA, 2)
    sesF=[sesF; i*s1];
end
gpF=[ones(size(Table{1,1})); zeros(size(Table{1,2}))];

[p_an,table_an,stats_an] = anovan(values_for_ANOVA(:),{sesF gpF(:)},'model' ,'interaction', 'display', 'off');

Pan_ses=p_an(1);
Pan_gp=p_an(2);
Pan_int=p_an(3);
% group effect for all sessions kruskal
[Pkw_g,table_kw_g]= kruskalwallis(values_for_ANOVA(:), gpF(:),'off');% 'displayopt'='off' popup inactivated
title (['anova P_s_e_s=' sprintf('%.2f',(Pan_ses)) '   P_g_p=' sprintf('%.2f',(Pan_gp)) '   P_i_n_t=' sprintf('%.2f',(Pan_int))  '  /  krusk P_g_p=' sprintf('%.2f',(Pkw_g))]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% KRUSKAL
if strcmp(test, 'kruskal')
    
    % not used in fact
%     k1=sum(~isnan(Table{1,1})); % k1 contain 0 if there is a full column of NaN
%     k2=sum(~isnan(Table{1,1}));
%     if sum(k1==0)==0&&sum(k2==0)==0
%         % session effect for all
%         [Pkw_ses,table_kw_ses] = kruskalwallis(values_for_ANOVA,'off');%If X is a matrix, KRUSKALWALLIS treats each column as coming from a separate group
%         % session effect for bulb
%         [Pkw_ses,table_kw_ses] = kruskalwallis(Table{1,1},'off');
%         % session effect for sham
%         [~,table_kw_ses] = kruskalwallis(Table{1,2},'off');%If X is a matrix, KRUSKALWALLIS treats each column as coming from a separate group
%     end
%     values=values_for_ANOVA;
    
    % group effect for each session
    for i=1:size(values_for_ANOVA,2)
        values=values_for_ANOVA(:,i);
        [Pkw_g,table_kw_g]= kruskalwallis(values(:), gpF(:),'off');
        p_kw(i)=Pkw_g;
        stats_kw{i}=table_kw_g;
        max=ylim;
        if Pkw_g<0.01    
            text(i,0.9*max(2),'**','Color','r', 'FontSize', 20)
        elseif Pkw_g<0.05
            text(i,0.9*max(2),'*','Color','r', 'FontSize', 20)
        end
    end

    if size(values_for_ANOVA,2)==4
        xlabel([test '    P_' Leg{1} '=' sprintf('%.2f',(p_kw(1))) '   P_' Leg{2} '=' sprintf('%.2f',(p_kw(2)))  '   P_' Leg{3} '=' sprintf('%.2f',(p_kw(3)))  '   P_' Leg{4} '=' sprintf('%.2f',(p_kw(4)))  ]);
    elseif size(values_for_ANOVA,2)==5
        xlabel([test '    P_' Leg{1} '=' sprintf('%.2f',(p_kw(1)))  '   P_' Leg{2} '=' sprintf('%.2f',(p_kw(2))) '   P_' Leg{3} '=' sprintf('%.2f',(p_kw(3)))  '   P_' Leg{4} '=' sprintf('%.2f',(p_kw(4)))  '   P_' Leg{5} '=' sprintf('%.2f',(p_kw(5)))  ]);
    end
    
    if savestats
        file2save=['Stats_' TableName '.mat'];
        save (file2save, 'p_an','table_an','stats_an', 'test','p_kw','stats_kw', 'info')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MANN-WHITNEY
elseif strcmp(test, 'ranksum')
    for i=1:size(values_for_ANOVA,2)
        x=values_for_ANOVA(logical(gpF(:,1)),i);
        y=values_for_ANOVA(logical(1-gpF(:,1)),i);
        if sum(~isnan(x))==0 ||sum(~isnan(y))==0
            Pmw=NaN; 
        else
            [Pmw,h_mw,table_mw] = ranksum(x(~isnan(x)), y(~isnan(y)));
        end
        p_mw(i)=Pmw;
        stats_mw(i)=table_mw;
        max=ylim;
        if Pmw<0.01
            text(i,0.9*max(2),'**','Color','r', 'FontSize', 20)
        elseif Pmw<0.05
            text(i,0.9*max(2),'*','Color','r', 'FontSize', 20)

        end  
    end
    % SALE ! pas tres generalisable
%     if size(values_for_ANOVA,2)==4
%         xlabel(['ranksum    P_p_r_e=' sprintf('%.2f',(p_mw(1))) '   P_p_o_s_t=' sprintf('%.2f',(p_mw(2)))  '   P_6_j=' sprintf('%.2f',(p_mw(3)))  '   P_3_w_k=' sprintf('%.2f',(p_mw(4)))  ]);
%     elseif size(values_for_ANOVA,2)==5
%         xlabel(['ranksum    P_n_o_S=' sprintf('%.2f',(p_mw(1)))  '   P_p_r_e=' sprintf('%.2f',(p_mw(2))) '   P_p_o_s_t=' sprintf('%.2f',(p_mw(3)))  '   P_6_j=' sprintf('%.2f',(p_mw(4)))  '   P_3_w_k=' sprintf('%.2f',(p_mw(5)))  ]);
%     end
    if size(values_for_ANOVA,2)==4
        xlabel([test '    P_' Leg{1} '=' sprintf('%.2f',(p_mw(1))) '   P_' Leg{2} '=' sprintf('%.2f',(p_mw(2)))  '   P_' Leg{3} '=' sprintf('%.2f',(p_mw(3)))  '   P_' Leg{4} '=' sprintf('%.2f',(p_mw(4)))  ]);
    elseif size(values_for_ANOVA,2)==5
        xlabel([test '    P_' Leg{1} '=' sprintf('%.2f',(p_mw(1)))  '   P_' Leg{2} '=' sprintf('%.2f',(p_mw(2))) '   P_' Leg{3} '=' sprintf('%.2f',(p_mw(3)))  '   P_' Leg{4} '=' sprintf('%.2f',(p_mw(4)))  '   P_' Leg{5} '=' sprintf('%.2f',(p_mw(5)))  ]);
    end
    if savestats
        file2save=['Stats_' TableName '.mat'];
        save (file2save, 'p_an','table_an','stats_an', 'test','p_mw','stats_mw', 'info')
    end
end




