%IntraNightMultiVar
%cd /home/karim/Dropbox/MOBS_workingON/AnalyseMultivarieMarie
clear
load BigMat
load BigMat2

%good variables - remove 25-26-36-37
goodvar = [2:24 27:35 38:75];
%path and mice
allpaths = newMatREM(:,76:77);
mice = unique(newMatREM(:,77));
micepath = unique(allpaths, 'rows');
paths = unique(allpaths(:,1));

figure, hold on
b=0;
for i=1:length(mice)
    
    paths = micepath(micepath(:,2)==mice(i));
    for j=1:length(paths)
        
        %Datasets and CV
        X = newMatREM(allpaths(:,1)==paths(j),goodvar);
        Xc = nanzscore(X);
        goodcol = find(~all(isnan(corrcoef(Xc)),2));
        Xc = Xc(:,goodcol);
        y = newMatREM(allpaths(:,1)==paths(j),1);
        %Datasets and CV
        yfit = []; Ytest = [];
        for k=1:5
            cv = crossvalind('HoldOut', size(Xc,1), 0.7);
            Xtrain = Xc(~cv,:);
            Ytrain = y(~cv,:);
            Xtest = Xc(cv,:);
            Ytest = [Ytest y(cv,:)];

            %lasso glm
            [B, FitInfo] = lassoglm(Xtrain,Ytrain,'normal','CV',3,'Alpha',0.5);
            beta = [FitInfo.Intercept(FitInfo.IndexMinDeviance); B(:,FitInfo.IndexMinDeviance)];
            yfit = [yfit glmval(beta,Xtest, 'identity')];
        end
        
        b = b +1;
        subplot(5,6,b), 
        hold on, plot(Ytest,yfit,'k.')
        hold on, plot(0:250)
        xlabel('true'), ylabel('prediction')
        %xlim([0 300]), ylim([0 300])
        title([mice_name{i} ' - ' num2str(paths(j))])
    end
    
end

%hours of record
path_clockrange = zeros(length(paths), 3);
for i=1:length(paths)
    clocks = newMatREM(newMatREM(:,76)==paths(i),2);
    path_clockrange(i,:) = [paths(i) min(clocks) max(clocks)];
end
%paths we keep









