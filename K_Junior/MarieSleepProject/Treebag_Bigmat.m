%TreeBagger for AnalysMultiVar

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
%% All
%Load
X = newMatREM(:,goodvar);
y = newMatREM(:,1);

%Datasets and CV
cv = crossvalind('HoldOut', size(X,1), 0.7);
Xtrain = X(~cv,:);
Ytrain = y(~cv,:);
Xtest = X(cv,:);
Ytest = y(cv,:);

%Treebagger
big_rf = TreeBagger(100,X,y,'Method','R', 'OOBVarImp','On', 'MinLeafSize',5);
figure
plot(oobError(big_rf))
xlabel 'Number of Grown Trees'
ylabel 'Out-of-Bag Mean Squared Error'
figure
bar(big_rf.OOBPermutedVarDeltaError)
xlabel 'Feature Index'
ylabel 'Out-of-Bag Feature Importance'

%ntrees=20;
feat_importance = big_rf.OOBPermutedVarDeltaError;
[v_fi,ind_fi] = sort(abs(feat_importance), 'descend');

nfeat_list = [1 2 3 4 5 6 8 12 16 20 30 length(ind_fi)];
ntrees = 5;
figure,hold on
for i=1:length(nfeat_list)
    nfeat = nfeat_list(i);
    reduced_rf = TreeBagger(ntrees,Xtrain(:,ind_fi(1:nfeat)),Ytrain,'Method','Regression','OOBVarImp','On');
    Yfit = predict(reduced_rf,Xtest(:,ind_fi(1:nfeat)));

    hold on, subplot(3,4,i), plot(0:250)
    hold on, plot(Ytest,Yfit,'k.')
    title([num2str(nfeat) ' features'])
end
figure,hold on
nfeat_list = [1 2 3 4 5 6 8 12 16 20 30 length(ind_fi)-1];
for i=1:length(nfeat_list)
    nfeat = nfeat_list(i);

    reduced_rf = TreeBagger(ntrees,Xtrain(:,ind_fi(end-nfeat:end)),Ytrain,'Method','Regression','OOBVarImp','On');
    Yfit = predict(reduced_rf,Xtest(:,ind_fi(end-nfeat:end)));

    hold on, subplot(3,4,i), plot(0:250)
    hold on, plot(Ytest,Yfit,'k.')
    title([num2str(nfeat) ' features'])
end

% amount of trees 
ntree_list = [1 2 3 4 7 20 40 60 100];
nfeat = 20;
figure,hold on
for i=1:length(ntree_list)
ntrees = ntree_list(i);
reduced_rf = TreeBagger(ntrees,Xtrain(:,ind_fi(1:nfeat)),Ytrain,'Method','Regression','OOBVarImp','On');
Yfit = predict(reduced_rf,Xtest(:,ind_fi(1:nfeat)));

subplot(3,3,i), hold on, plot(0:250),
hold on, plot(Ytest,Yfit,'k.')
title([num2str(ntrees) ' tree(s)'])
end

view(reduced_rf.Trees{1}, 'Mode','graph')



%% find features
ntrees = 21;
reduced_rf = TreeBagger(ntrees,Xtrain(:,ind_fi(1:nfeat)),Ytrain,'Method','Regression');
Yfit = predict(reduced_rf,Xtest(:,ind_fi(1:nfeat)));

figure,
plot(0:250), hold on
plot(Ytest,Yfit,'k.')
title([num2str(nfeat) ' features'])





%% One night
Yfit=[]; Ytest = [];
for i=1:length(paths)
    X = newMatREM(allpaths(:,1)==paths(i), goodvar);
    y = newMatREM(allpaths(:,1)==paths(i), 1);

    %Datasets and CV
    cv = crossvalind('HoldOut', size(X,1), 0.7);
    Xtrain = X(~cv,:);
    Ytrain = y(~cv,:);
    Xtest = X(cv,:);
    Ytest = [Ytest;y(cv,:)];
    
    %Treebagger
    NumTrees = 100;
    B = TreeBagger(NumTrees,Xtrain,Ytrain,'Method','Regression');
    Yfit = [Yfit;predict(B,Xtest)];

end
subplot(2,2,2), hold on, plot(0:250)
hold on,plot(Ytest,Yfit,'k.')


%% One mice, two nights
Yfit=[]; Ytest = [];
for i=1:length(mice)
    allmousepaths = allpaths(allpaths(:,2)==mice(i), :);
    mousepath = unique(allmousepaths(:,1));
    X = newMatREM(allpaths(:,2)==mice(i), goodvar);
    y = newMatREM(allpaths(:,2)==mice(i), 1);

    if length(mousepath) > 1
        for j=1:length(mousepath)
            %Datasets and CV
            Xtrain = X(allmousepaths(:,1)==mousepath(j),:);
            Ytrain = y(allmousepaths(:,1)==mousepath(j),:);
            Xtest = X(~(allmousepaths(:,1)==mousepath(j)),:);
            Ytest = [Ytest;y(~(allmousepaths(:,1)==mousepath(j)),:)];

            %Treebagger
            NumTrees = 100;
            B = TreeBagger(NumTrees,Xtrain,Ytrain,'Method','Regression');
            Yfit = [Yfit;predict(B,Xtest)];

        end
    end
end
subplot(2,2,3), hold on, plot(0:250)
hold on,plot(Ytest,Yfit,'k.')


%% Two different nights
Yfit=[]; Ytest = [];
X = newMatREM(:,goodvar);
y = newMatREM(:,1);
for i=1:length(paths)
    %Datasets and CV
    Xtrain = X(allpaths(:,1)==paths(i),:);
    Ytrain = y(allpaths(:,1)==paths(i),:);
    Xtest = X(~(allpaths(:,1)==paths(i)),:);
    Ytest = [Ytest;y(~(allpaths(:,1)==paths(i)),:)];

    %Treebagger
    NumTrees = 100;
    B = TreeBagger(NumTrees,Xtrain,Ytrain,'Method','Regression');
    Yfit = [Yfit;predict(B,Xtest)];
end
subplot(2,2,4), hold on, plot(0:250)
hold on,plot(Ytest,Yfit,'k.')

