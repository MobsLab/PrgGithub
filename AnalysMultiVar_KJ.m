%AnalysMultiVar_KJ

%cd /home/karim/Dropbox/MOBS_workingON/AnalyseMultivarieMarie
clear
load BigMat

MatREM(isnan(MatREM)) = 0;
%good variables - remove 25-26-36-37
goodvar = [2:24 27:35 38:75];
%number of components
n=20;
%path and mice
allpaths = [MatREM(:,76) zeros(length(MatREM(:,76)),1)];
mice = unique(Dir.name);
path_mice = zeros(1,length(Dir.path));
for i=1:length(Dir.path)
    path_mice(i) = find(strcmp(Dir.name(i), mice));
    allpaths(allpaths(:,1)==i,2) = path_mice(i);
end
allmice = allpaths(:,2);
mice = unique(allmice);
paths = unique(allpaths(:,1));

figure, hold on
%% All
%Load
X = MatREM(:,goodvar);
Xc = zscore(X);
y = MatREM(:,1);
[r,p]=corrcoef(Xc);
[V,L]=pcacov(r);
Z = Xc * V(:,1:n);
%propvar = cumsum(L/sum(L));

%Datasets and CV
cv = crossvalind('HoldOut', size(Z,1), 0.7);
Xtrain = Z(~cv,:);
Ytrain = y(~cv,:);
Xtest = Z(cv,:);
Ytest = y(cv,:);

%lasso glm
[B, FitInfo] = lassoglm(Xtrain,Ytrain,'normal','CV',3,'Alpha',0.5);
beta = [FitInfo.Intercept(FitInfo.IndexMinDeviance); B(:,FitInfo.IndexMinDeviance)];
yfit = glmval(beta,Xtest, 'identity');
subplot(4,2,1), hold on, plot(Ytest,yfit,'k.')
subplot(4,2,2), hold on, plot(beta(2:end),'ko-','markerfacecolor','k')


%% One night

yfit=[]; Ytest = []; all_betas=[];
for i=1:length(paths)
    X = MatREM(allpaths(:,1)==paths(i), goodvar);
    y = MatREM(allpaths(:,1)==paths(i), 1);
    Xc = zscore(X);
    goodcol = find(~all(isnan(corrcoef(Xc)),2));
    [r,p] = corrcoef(Xc(:,goodcol));
    [V,L]=pcacov(r);
    Z = Xc(:,goodcol) * V(:,1:n);

    %Datasets and CV
    cv = crossvalind('HoldOut', size(Z,1), 0.7);
    Xtrain = Z(~cv,:);
    Ytrain = y(~cv,:);
    Xtest = Z(cv,:);
    Ytest = [Ytest;y(cv,:)];

    %lasso glm
    [B, FitInfo] = lassoglm(Xtrain,Ytrain,'normal','CV',3,'Alpha',0.5);
    beta = [FitInfo.Intercept(FitInfo.IndexMinDeviance); B(:,FitInfo.IndexMinDeviance)];
    yfit = [yfit;glmval(beta,Xtest, 'identity')];
    all_betas = [all_betas beta];

end
subplot(4,2,3), hold on, plot(Ytest,yfit,'k.')
subplot(4,2,4), hold on, plot(all_betas,'ko-')


%% One mice, two nights
%Load
yfit=[]; Ytest = []; all_betas=[];

for i=1:length(mice)
    allmousepaths = allpaths(allpaths(:,2)==mice(i), :);
    mousepath = unique(allmousepaths(:,1));
    X = MatREM(allpaths(:,2)==mice(i), goodvar);
    y = MatREM(allpaths(:,2)==mice(i), 1);
    Xc = zscore(X);
    goodcol = find(~all(isnan(corrcoef(Xc)),2));
    [r,p] = corrcoef(Xc(:,goodcol));
    [V,L] = pcacov(r);
    Z = Xc(:,goodcol) * V(:,1:n);

    if length(mousepath) > 1
        for j=1:length(mousepath)
            %Datasets and CV
            Xtrain = Z(allmousepaths(:,1)==mousepath(j),:);
            Ytrain = y(allmousepaths(:,1)==mousepath(j),:);
            Xtest = Z(~(allmousepaths(:,1)==mousepath(j)),:);
            Ytest = [Ytest;y(~(allmousepaths(:,1)==mousepath(j)),:)];

            %lasso glm
            [B, FitInfo] = lassoglm(Xtrain,Ytrain,'normal','CV',3,'Alpha',0.5);
            beta = [FitInfo.Intercept(FitInfo.IndexMinDeviance); B(:,FitInfo.IndexMinDeviance)];
            yfit = [yfit; glmval(beta,Xtest, 'identity')];
            all_betas = [all_betas beta];

        end
    end
end
subplot(4,2,5), hold on, plot(Ytest,yfit,'k.')
subplot(4,2,6), hold on, plot(all_betas,'ko-')


%% Two different nights
yfit=[]; Ytest = []; all_betas=[];

X = MatREM(:,goodvar);
Xc = zscore(X);
y = MatREM(:,1);
[r,p]=corrcoef(Xc);
[V,L]=pcacov(r);
Z = Xc * V(:,1:n);
for i=1:length(paths)
    %Datasets and CV
    Xtrain = Z(allpaths(:,1)==paths(i),:);
    Ytrain = y(allpaths(:,1)==paths(i),:);
    Xtest = Z(~(allpaths(:,1)==paths(i)),:);
    Ytest = [Ytest;y(~(allpaths(:,1)==paths(i)),:)];

    %lasso glm
    [B, FitInfo] = lassoglm(Xtrain,Ytrain,'normal','CV',3,'Alpha',0.5);
    beta = [FitInfo.Intercept(FitInfo.IndexMinDeviance); B(:,FitInfo.IndexMinDeviance)];
    yfit = [yfit;glmval(beta,Xtest, 'identity')];
    all_betas = [all_betas beta];

end
subplot(4,2,7), hold on, plot(Ytest,yfit,'k.')
subplot(4,2,8), hold on, plot(all_betas,'ko-')




