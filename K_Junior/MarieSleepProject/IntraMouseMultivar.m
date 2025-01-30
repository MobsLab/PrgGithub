%IntraMouseMultivar

%cd /home/karim/Dropbox/MOBS_workingON/AnalyseMultivarieMarie
clear
load BigMat

MatREM(isnan(MatREM)) = 0;
%good variables - remove 25-26-36-37
goodvar = [2:24 27:35 38:75];
%number of components
n=14;
%path and mice
allpaths = [MatREM(:,76) zeros(length(MatREM(:,76)),1)];
mice_name = unique(Dir.name);
path_mice = zeros(1,length(Dir.path));
for i=1:length(Dir.path)
    path_mice(i) = find(strcmp(Dir.name(i), mice_name));
    allpaths(allpaths(:,1)==i,2) = path_mice(i);
end
allmice = allpaths(:,2);
mice = unique(allmice);
paths = unique(allpaths(:,1));


figure, hold on
for i=1:length(mice)
    yfit=[]; Ytest = []; all_betas=[];
    
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
    
    subplot(3,4,i), 
    hold on, plot(Ytest,yfit,'k.')
    hold on, plot(0:250)
    xlabel('true'), ylabel('prediction')
    xlim([0 300]), ylim([0 300])
    title(mice_name{i})
    
end







