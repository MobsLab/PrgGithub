%multivar_durepisode
%Analys for different episode duration 

%cd /home/karim/Dropbox/MOBS_workingON/AnalyseMultivarieMarie
clear
load BigMat
load BigMat2

%good variables - remove 25-26-36-37
goodvar = [2:6 10:13 17:24 27:35 38:75];
%path and mice
allpaths = newMatREM(:,76:77);
mice = unique(newMatREM(:,77));
micepath = unique(allpaths, 'rows');
paths = unique(allpaths(:,1));

X = newMatREM(:,goodvar);
Y = newMatREM(:,1);


%% duration of episodes
dur_ep = newMatREM(:,1) / 3600;
start_ep = newMatREM(:,2);
end_ep = start_ep + dur_ep;
interepisode = [(start_ep(2:end) - end_ep(1:end-1)) * 3600;0];
episodes_time = [start_ep end_ep newMatREM(:,1) interepisode newMatREM(:,76)];

interepisode(interepisode<0)=[]; %between 2 different nights


%% Classification of episode length
durBins = [0 25 50 75 100 150 200 300];
Ydis = discretize(Y,durBins);

%Datasets and CV
cv = crossvalind('HoldOut', size(X,1), 0.7);
Xtrain = X(~cv,:);
Ytrain = Ydis(~cv,:);
Xtest = X(cv,:);
Ytest = Ydis(cv,:);

%Treebagger
big_rf = TreeBagger(200,Xtrain,Ytrain, 'OOBVarImp','On');
figure
plot(oobError(big_rf))
xlabel 'Number of Grown Trees'
ylabel 'Out-of-Bag Mean Squared Error'
figure
bar(big_rf.OOBPermutedVarDeltaError)
xlabel 'Feature Index'
ylabel 'Out-of-Bag Feature Importance'

Yfit = predict(big_rf, Xtest);
Yfit = str2double(Yfit);

%confusion matrix
yc_test = zeros(length(Ytest),length(unique(Ytest)));
yc_fit = zeros(length(Ytest),length(unique(Ytest)));
for i=1:size(Yc,2)
    yc_test(:,i) = (Ytest == i);
    yc_fit(:,i) = (Yfit == i);
end
plotconfusion(yc_test, yc_fit)


%% Regression for two groups of episode duration,
duration_split = 100;  % split data by duration

Xshort = X(Y<duration_split,:);
Xlong = X(Y>=duration_split,:);
Yshort = Y(Y<duration_split);
Ylong = Y(Y>=duration_split);

ntrees = 5;
feat_importance = [];
figure, hold on
  
%Treebagger
tbg1 = TreeBagger(ntrees ,Xshort ,Yshort,'Method','R', 'OOBVarImp','On', 'MinLeafSize',3);
Yfit = predict(tbg1, Xshort);
feat_importance = [feat_importance tbg1.OOBPermutedVarDeltaError'];
[val, ind] = sort(tbg1.OOBPermutedVarDeltaError,'descend');
feat_order(1:length(val),1) = info(goodvar(ind));
subplot(2,2,1), hold on, bar(tbg1.OOBPermutedVarDeltaError)
title(['short < ' num2str(duration_split)])
hold on, subplot(2,2,3), plot(0:250), hold on, plot(Yshort,Yfit,'k.')


tbg2 = TreeBagger(ntrees ,Xlong ,Ylong,'Method','R', 'OOBVarImp','On', 'MinLeafSize',3);
Yfit = predict(tbg2, Xlong);
feat_importance = [feat_importance tbg2.OOBPermutedVarDeltaError'];
[val, ind] = sort(tbg2.OOBPermutedVarDeltaError,'descend');
feat_order(1:length(val),2) = info(goodvar(ind));
subplot(2,2,2), hold on, bar(tbg2.OOBPermutedVarDeltaError)
title(['long > ' num2str(duration_split)])
hold on, subplot(2,2,4), plot(0:250), hold on, plot(Ylong,Yfit,'k.')
    




