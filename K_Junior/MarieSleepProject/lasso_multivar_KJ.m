% Lasso wth Marie matrix

load BigMat
nights = unique(MatREM(:,76));

Y = MatREM(:,1);
X = MatREM(:,2:end-1);
names = info(2:end-1);

%normalize data
Xz = X;
ind_zscore = [6 7 13 16 17];
for i=ind_zscore
    Xz(:,i) = zscore(X(:,i));
end


%lasso glm
[B, FitInfo] = lassoglm(X,Y,'normal','CV',5,'Alpha',0.5, 'PredictorNames',names);
lassoPlot(B,FitInfo,'plottype','CV');

%sort feature by importance
beta = B(:,FitInfo.IndexMinDeviance);
[feat_sort,ind_beta] = sort(abs(beta),'descend');

bar(feat_sort);

feat_names = transpose(FitInfo.PredictorNames(ind_beta));
fv = [nanmean(X(:,ind_beta))' nanstd(X(:,ind_beta))'];
for i=1:size(feat_names,1)
    feat_names{i,2} = fv(i,1);
    feat_names{i,3} = fv(i,2);
    feat_names{i,4} = feat_sort(i);
    feat_names{i,5} = ind_beta(i)+1;
end


