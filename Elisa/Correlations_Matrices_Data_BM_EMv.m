
function Correlations_Matrices_Data_BM(M , Mouse_names , Var_Names)

% normalisation of data 
Data_to_use=abs(M);
Data_to_use=sqrt(sqrt(Data_to_use));
Data_to_use = zscore_nan_BM(Data_to_use);

% generate correlation matrices
[Data_corr1,p1] = corr(Data_to_use,'type','pearson');
[Data_corr2,p2] = corr(Data_to_use','type','pearson');

% display best oredered matrix for both dimensions
[Data_corr3 , ~ , ~ , v] = OrderMatrix_BM(Data_corr1  , Var_Names , p1 , 1);
[Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2  , Mouse_names , p2 , 1);

% significativity values
[rows3,cols3] = find(p1(v,v)<.05);
[rows4,cols4] = find(p2(v2,v2)<.05);

% plot figure
% 1) data
figure
subplot(141)
imagesc(Data_to_use)
colormap redblue
axis square, axis xy
xticks(1:length(Var_Names)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names)
colorbar
title('Parameters values by mouse')

% 2) Correlation matrices for both params
subplot(242)
imagesc(Data_corr3)
hold on
plot(rows3,cols3,'*k')
axis square, axis xy
xticks(1:length(Var_Names)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Var_Names)), yticklabels({''}), ylabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
caxis([-1 1])
colorbar
title('Correlation matrix on behaviour parameters')

% 3) Eigen values distribution
subplot(243)
[~, ~, frvecs1, trnsfrmd1, ~, ~] = pca(Data_corr3);
App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

% 4) First PC
subplot(244)
imagesc(App_Data1)
axis square, axis xy
xticks(1:length(Var_Names)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
yticks(1:length(Var_Names)), yticklabels({''}), ylabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
caxis([-1 1])
title('λ1 x PC1')

subplot(246)
imagesc(Data_corr4)
hold on
plot(rows4,cols4,'*k')
axis square, axis xy
xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(90)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
caxis([-1 1])
title('Correlation matrix on behaviour parameters')

subplot(247)
[~, ~, frvecs2, trnsfrmd2, ~, ~] = pca(Data_corr4);
App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
ylabel('% variance explained')
xticklabels({'λ1','λ2','λ3','λ4'})

subplot(248)
imagesc(App_Data2)
axis square, axis xy
xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(90)
yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
caxis([-1 1])
title('λ1 x PC1')

a=suptitle('Global approach for bejavioural parameters using matrices correlations'); a.FontSize=20;

