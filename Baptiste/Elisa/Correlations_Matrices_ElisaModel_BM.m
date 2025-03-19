
% Mouse_names = {'M688', 'M739', 'M777', 'M779', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M1189', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226'};
% Data2=[log10(Data(:,1:5)) Data(:,6:8) log10(Data(:,9:11))];
% figure
% imagesc(Data2)


Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1171', 'M9184', 'M9205', 'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226'};
Var={'thigmo','speed & dir pers','motion inertia','beta','p1','p2','p3','gamma','k','bp','Wm','Wnm'};

cd('/home/ratatouille/Downloads')
load('PreTest_all_optimized_model_param.mat')
load('Hab_all_optimized_model_param.mat')

Data=[M688 ; M777 ; M849 ; M1144 ; M1146 ; M1147 ; M1171 ; M9184 ; M9205 ; M1391 ; M1392 ; M1394 ; M1224 ; M1225 ; M1226];

%% on the interest of applying some transformations on variables
figure
subplot(121)
PlotCorrelations_BM(Data(:,3),Data(:,12)')
axis square, axis xy
xlabel('motion inertia'), ylabel('Wnm')
title('regular scale')

subplot(122)
PlotCorrelations_BM(log10(Data(:,3)),log10(Data(:,12))')
axis square, axis xy
xlabel('motion inertia'), ylabel('Wnm')
title('log scale')

a=suptitle('On the interest of applying some transformations on variables'); a.FontSize=20;


figure
PlotCorrelations_BM(log10(Data_Hab(5,:)),log10(Data_TestPre(5,:)))
axis square, axis xy
xlabel('motion inertia, Hab'), ylabel('motion inertia, TestPre')
title('Correlations variables Hab-TestPre')



%% correlations matrices
clear A B Data
A=load('Hab_all_optimized_model_param.mat');
Data_Hab=[A.M688 ; A.M777 ; A.M849 ; A.M1144 ; A.M1146 ; A.M1147 ; A.M1171 ; A.M9184 ; A.M9205 ; A.M1391 ; A.M1392 ; A.M1394 ; A.M1224 ; A.M1225 ; A.M1226];
B=load('PreTest_all_optimized_model_param.mat');
Data_TestPre=[B.M688 ; B.M777 ; B.M849 ; B.M1144 ; B.M1146 ; B.M1147 ; B.M1171 ; B.M9184 ; B.M9205 ; B.M1391 ; B.M1392 ; B.M1394 ; B.M1224 ; B.M1225 ; B.M1226];

for f=1:9
    clear Data Data1 Data2 Data_log Data_log1 Data_log2 Data_corr1 Data_corr2 Data_corr3 Data_corr4 p1 p2 v v2 rows1 rows2 rows3 rows4 cols1 cols2 cols3 cols4
    
    if f<5
        Data=Data_Hab;
    elseif and(f>4,f<9)
        Data=Data_TestPre;
    elseif f>8
        Data1=Data_Hab;
        Data2=Data_TestPre;
    end
    
    if or(f==1,f==5)
        % 1) log, pearson
        Data_log=log10(Data);
        [Data_corr1,p1] = corr(Data_log,'type','pearson');
        [Data_corr2,p2] = corr(Data_log','type','pearson');
    elseif or(f==2,f==6)
        % 2) log, spearman
        Data_log=log10(Data);
        [Data_corr1,p1] = corr(Data_log,'type','spearman');
        [Data_corr2,p2] = corr(Data_log','type','spearman');
    elseif or(f==3,f==7)
        % 3) zscore, pearson
        Data_log=zscore(Data);
        [Data_corr1,p1] = corr(Data_log,'type','pearson');
        [Data_corr2,p2] = corr(Data_log','type','pearson');
    elseif or(f==4,f==8)
        % 4) zscore, spearman
        Data_log=zscore(Data);
        [Data_corr1,p1] = corr(Data_log,'type','spearman');
        [Data_corr2,p2] = corr(Data_log','type','spearman');
    elseif f==9
        % 5) Hab/TestPre, log, pearson
        Data_log1=log10(Data1); Data_log2=log10(Data2);
        [Data_corr1,p1] = corr(Data_log1,Data_log2,'type','pearson');
        [Data_corr2,p2] = corr(Data_log1',Data_log2','type','pearson');
    end
    
    [Data_corr3 , ~ , ~ , v] = OrderMatrix_BM(Data_corr1);
    [Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2);
    
    [rows1,cols1] = find(p1<.05);
    [rows2,cols2] = find(p2<.05);
    [rows3,cols3] = find(p1(v,v)<.05);
    [rows4,cols4] = find(p2(v2,v2)<.05);
    
    figure
    if f<9
        subplot(141)
        imagesc(Data_log)
        colormap redblue
        axis square, axis xy
        xticks(1:12), xticklabels(Var), xtickangle(45)
        yticks(1:15), yticklabels(Mouse_names)
        colorbar
        title('Parameters values by mouse')
    else
        subplot(241)
        imagesc(Data_log1)
        colormap redblue
        axis square, axis xy
        xticks(1:12), xticklabels(Var), xtickangle(45)
        yticks(1:15), yticklabels(Mouse_names)
        colorbar
        title('Hab')
        
        subplot(245)
        imagesc(Data_log2)
        axis square, axis xy
        xticks(1:12), xticklabels(Var), xtickangle(45)
        yticks(1:15), yticklabels(Mouse_names)
        title('TestPre')
    end
    
    subplot(242)
    imagesc(Data_corr3)
    hold on
    plot(rows3,cols3,'*k')
    axis square, axis xy
    xticks(1:12), xticklabels(Var(v)), xtickangle(45)
    yticks(1:12), yticklabels(Var(v))
    caxis([-1 1])
    title('Correlation matrix on model parameters')
    
    subplot(243)
    [rlvm, frvals, frvecs1, trnsfrmd1, mn, dv] = pca(Data_corr3);
    App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4'})
    
    subplot(244)
    imagesc(App_Data1)
    axis square, axis xy
    xticks(1:12), xticklabels(Var(v)), xtickangle(45)
    yticks(1:12), yticklabels(Var(v))
    title('λ1 x PC1')    
    
    subplot(246)
    imagesc(Data_corr4)
    hold on
    plot(rows4,cols4,'*k')
    axis square, axis xy
    xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
    yticks(1:15), yticklabels(Mouse_names(v2))
    caxis([-1 1])
    title('Correlation matrix on mice')
    
    subplot(247)
    [rlvm, frvals, frvecs2, trnsfrmd2, mn, dv] = pca(Data_corr4);
    App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4'})
    
    subplot(248)
    imagesc(App_Data2)
    axis square, axis xy
    xticks(1:15), xticklabels(Mouse_names(v2)), xtickangle(45)
    yticks(1:15), yticklabels(Mouse_names(v2))
    title('λ1 x PC1')
end
a=suptitle('Global approach for model parameters using matrices correlations, Hab-TestPre sessions'); a.FontSize=20;


