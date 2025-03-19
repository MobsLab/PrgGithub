
function [Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(M , Mouse_names , Var_Names)

% normalisation of data
% Data_to_use=abs(M);
% Data_to_use=sqrt(sqrt(Data_to_use));
% Data_to_use = zscore_nan_BM(M);
Data_to_use=M;

% if size(Data_to_use,2)<2e2
if size(Data_to_use,50)<2
    
    
    % generate correlation matrices
    [Data_corr1,p1] = corr(Data_to_use,'type','pearson');
    [Data_corr2,p2] = corr(Data_to_use','type','pearson');
    
    % display best oredered matrix for both dimensions
    if size(Data_corr1,1)<1e2
        [Data_corr3 , ~ , ~ , v1] = OrderMatrix_BM(Data_corr1  , Var_Names , p1 , 1);
        %         [Data_corr3 , ~ , ~ , v1] = OrderMatrix_BM(Data_corr1  , {''} , p1 , 1);
    else
        Data_corr3 = Data_corr1; v1=[];
    end
    if size(Data_corr2,1)<1e3
        [Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2  , Mouse_names , p2 , 1);
    else
        Data_corr4 = Data_corr2; v2=[];
    end
    
    % significativity values
    [rows3,cols3] = find(p1(v1,v1)<.05);
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
    xticks(1:length(Var_Names))
    yticks(1:length(Var_Names))
    xticklabels({''}), xlabel('behavioural parameters')
    yticklabels({''}), ylabel('behavioural parameters')
    %     xticklabels(Var_Names(v1))
    %     yticklabels(Var_Names(v1)), %xtickangle(45)
    caxis([-1 1])
    colorbar
    title('Correlation matrix on behaviour parameters')
    
    % 3) Eigen values distribution
    subplot(243)
    [~, x, frvecs1, trnsfrmd1, ~, ~] = pca(Data_corr3);
    App_Data1 = trnsfrmd1(:,1) * frvecs1(:,1)';
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4'})
    
    eig1 = frvecs1;
    
    % 4) First PC
    subplot(244)
    imagesc(App_Data1)
    axis square, axis xy
    xticks(1:length(Var_Names)),
    yticks(1:length(Var_Names)),
    try
        xticklabels(Var_Names)
        yticklabels(Var_Names)
    catch
        xticklabels({''}), xlabel('behavioural parameters')
        yticklabels({''}), ylabel('behavioural parameters')
    end
    xtickangle(45)
    %     xticklabels(Var_Names(v1))
    %     yticklabels(Var_Names(v1)), xtickangle(45)
    %     caxis([-1 1])
    title('λ1 x PC1')
    
    subplot(246)
    imagesc(Data_corr4)
    hold on
    plot(rows4,cols4,'*k')
    axis square, axis xy
    try
        xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
        yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
    catch
        xlabel('mice #'), ylabel('mice #')
    end
    caxis([-1 1])
    title('Correlation matrix on behaviour parameters')
    
    subplot(247)
    [~, x, frvecs2, trnsfrmd2, ~, ~] = pca(Data_corr4);
    App_Data2 = trnsfrmd2(:,1) * frvecs2(:,1)';
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4','λ5','λ6','λ7'})
    
    eig2 = frvecs2;
    
    subplot(248)
    imagesc(App_Data2)
    axis square, axis xy
    try
        xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
        yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
    catch
        xlabel('mice #'), ylabel('mice #')
    end
    caxis([-1 1])
    title('λ1 x PC1')
    
    % a=suptitle('Global approach for bejavioural parameters using matrices correlations'); a.FontSize=20;
    
    Mf.Data_corr_a = Data_corr3;
    Mf.Data_corr_b = Data_corr4;
    Mf.PC_a = App_Data1;
    Mf.PC_b = App_Data2;
    
    
else
    
    
    
    % generate correlation matrices
    [Data_corr2,p2] = corr(Data_to_use','type','pearson');
    [Data_corr4 , ~ , ~ , v2] = OrderMatrix_BM(Data_corr2  , Mouse_names , p2 , 1); close
    
    % significativity values
    [rows4,cols4] = find(p2(v2,v2)<.05);
    
    % plot figure
    % 1) data
    figure
    subplot(151)
    imagesc(Data_to_use)
    colormap redblue
    axis square, axis xy
    xticks(1:length(Var_Names)), xticklabels({''}), xlabel('behavioural parameters')%xticklabels(Var_Names), xtickangle(45)
    yticks(1:length(Mouse_names)), yticklabels(Mouse_names)
    colorbar
    title('Parameters values by mouse')
    
    
    subplot(152)
    imagesc(Data_corr4)
    hold on
    
    axis square, axis xy
    if size(Data_corr4,2)<25
        plot(rows4,cols4,'*k')
        xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
        yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
    end
    caxis([-1 1])
    title('Correlation matrix on behaviour parameters')
    
    subplot(153)
    [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr4);
    ylabel('% variance explained')
    xticklabels({'λ1','λ2','λ3','λ4'})
    axis square, box off
    
    subplot(154)
    imagesc(eigen_vector(:,1)*(eigen_vector(:,1))')
    axis square, axis xy
    if size(Data_corr4<25)
        xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
        yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
    end
    %     caxis([-1 1])
    title('PC1')
    
    
    subplot(155)
    imagesc(eigen_vector(:,2)*(eigen_vector(:,2))')
    axis square, axis xy
    if size(Data_corr4<25)
        xticks(1:length(Mouse_names)), xticklabels(Mouse_names(v2)), xtickangle(45)
        yticks(1:length(Mouse_names)), yticklabels(Mouse_names(v2))
    end
    %     caxis([-1 1])
    title('PC2')
    
    
    Mf=[];
    v1=[];
    v2=[];
    % Mf.PC_b = App_Data2;
    
    
end



