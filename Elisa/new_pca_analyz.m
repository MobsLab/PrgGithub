
[R,P]=corrcoef(saline, saline');


[rows,cols] = find(P<.05);

%%

figure
subplot(221)
imagesc(R)
colormap redblue
plot(rows,cols,'*k')
axis square, axis xy
% yticks(1:length(name_bm)), yticklabels(name_bm), xtickangle(45);
% % xticks(1:length(Data(1, :))), xticklabels(Var);
% xticks(1:length(params(:, 1))), xticklabels(Var);
title('Correlation matrix on model parameters');

% colorbar

%%

All_corr = zeros(length(name_bm), length(params(:, 1)));
All_p = zeros(length(name_bm), length(params(:, 1)));
% Data = Data_Hab
for b=1:length(name_bm)
    for p=1:length(params(:, 1))
        lam = overall_best_lambda(b, p)
        disp(lam);
        if lam ==0
            X = log(abs(params(param, :)));
        else
            X = ((abs(params(param, :)).^lam)-1)/lam;
        end
    Y=log(abs(Behav_measur(:,bm_)));
    Y(isinf(X))=[];
    X(isinf(X))=[];
    [R,P]=corrcoef(X',Y);

%     [Data_corr,pv] = corr(X, Y, 'type','pearson');
%     All_corr(b, p) = Data_corr;
%     All_p(b, p) = pv;
    All_corr(b, p) = R(2, 1);
    All_p(b, p) = P(2, 1);
    
    
%     figure
%     PlotCorrelations_BM(X, Y')
%     axis square, axis xy
%     xlabel(strcat(Var(p), ', Hab')), ylabel(strcat(name_bm(b), ', TestPre'))
%     title('Correlations model parameters - behavioral metrics')    
    end    
end
