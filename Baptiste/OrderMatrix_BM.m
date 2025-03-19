

function [Most_Arranged_Matrix , DIFF , m , v] = OrderMatrix_BM(Mat , Var_Names , p , Plot_SumUpFig)

if ~exist('Plot_SumUpFig','var')
    Plot_SumUpFig=0;
end
if ~exist('Var_Names','var')
    Var_Names={''};
end

[n1,n2] = size(Mat);
if sum(round(Mat(:,1),6)==round(Mat(1,:),6)')==n1
    sym_matrix=1; % square matrix
else
    sym_matrix=0;
end

for i=1:n1
    
    [~,v]=sortrows(Mat,i);
    Mat_sort = Mat(v,v);
    
    for rows=1:n1
        [s_des,ind_desc] = sort(Mat_sort(rows,:),'descend'); % optimal organisation, check for ascend or descend
        [s_asc,ind_asc] = sort(Mat_sort(rows,:),'ascend');
        
        diff_desc(rows,:) = abs(Mat_sort(rows,:)-s_des); % quadratic difference compared to optimal organisation for each row
        diff_asc(rows,:) = abs(Mat_sort(rows,:)-s_asc);
        
        coeff_desc(rows,:) = abs(ind_desc-flip([1:n1]));
        coeff_asc(rows,:) = abs(ind_asc-[1:n1]);
        
        if sum(diff_desc(rows,:)) == min(sum(diff_desc(rows,:)) , sum(diff_asc(rows,:))) % descent case
            Perf_Mat_diff(rows,:) = diff_desc(rows,:);
            Perf_Mat_ind(rows,:) = coeff_desc(rows,:);
        else
            Perf_Mat_diff(rows,:) = diff_asc(rows,:);
            Perf_Mat_ind(rows,:) = coeff_asc(rows,:);
        end
    end
    DIFF(i) = sum(sum(Perf_Mat_diff.*Perf_Mat_ind));
    
    if sym_matrix==0 % if not symetric matrix, check that cols organization is good too
        clear s_des s_asc ind_desc ind_asc diff_desc diff_asc coeff_desc coeff_asc Perf_Mat_diff Perf_Mat_ind
        for cols=1:n2
            [s_des,ind_desc] = sort(Mat_sort(:,cols),'descend'); % optimal organisation, check for ascend or descend
            [s_asc,ind_asc] = sort(Mat_sort(:,cols),'ascend');
            
            diff_desc(:,cols) = abs(Mat_sort(:,cols)-s_des); % quadratic difference compared to optimal organisation for each row
            diff_asc(:,cols) = abs(Mat_sort(:,cols)-s_asc);
            
            coeff_desc(:,cols) = abs(ind_desc-flip([1:n2])');
            coeff_asc(:,cols) = abs(ind_asc-[1:n2]');
            
            if sum(diff_desc(:,cols)) == min(sum(diff_desc(:,cols)) , sum(diff_asc(:,cols))) % descent case
                Perf_Mat_diff(:,cols) = diff_desc(:,cols);
                Perf_Mat_ind(:,cols) = coeff_desc(:,cols);
            else
                Perf_Mat_diff(:,cols) = diff_asc(:,cols);
                Perf_Mat_ind(:,cols) = coeff_asc(:,cols);
            end
        end
        DIFF_cols(i) = sum(sum(Perf_Mat_diff.*Perf_Mat_ind));
        DIFF(i) = DIFF(i) + DIFF_cols(i);
    end
end

[~,m]=min(DIFF);
[~,v]=sortrows(Mat,m);
Most_Arranged_Matrix = Mat(v,v);
try, [rows_p,cols_p] = find(p(v,v)<.05); end


if Plot_SumUpFig
    figure
    subplot(511)
    plot(DIFF)
    hold on
    plot(m,DIFF(m),'or')
    xticks(1:length(Var_Names)), xticklabels(Var_Names), xtickangle(45)
    ylabel('difference (a.u.)')
    title('Entropy note depending on params arrangement')
    
    subplot(5,1,2:5)
    imagesc(Most_Arranged_Matrix)
    hold on
    try, plot(rows_p,cols_p,'*k'), end
    axis square, axis xy
%     caxis([-1 1])
    try, xticks(1:length(Var_Names)), xticklabels(Var_Names(v)), xtickangle(45), end
    try, yticks(1:length(Var_Names)), yticklabels(Var_Names(v)), end
    colormap redblue
    title('The most arranged matrix')
end

% figure
% for i=1:15
%     subplot(3,5,i)
%     [~,v2]=sortrows(Mat,i);
%     Mat2 = Mat(v2,v2);
%     imagesc(Mat2)
%     axis square, axis xy
% end
% colormap redblue
