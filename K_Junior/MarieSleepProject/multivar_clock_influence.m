%Analys for different clock 

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
X = X(newMatREM(:,1)>10,:);
Y = Y(newMatREM(:,1)>10);

clocks = [10 14 17 20];

for i=1:length(clocks)-1
    goodrows = X(:,1)>clocks(i) & X(:,1)<=clocks(i+1);
    dataREM.clocks{i} = [clocks(i) clocks(i+1)];
    dataREM.X{i} = X(goodrows,:);
    dataREM.Y{i} = Y(goodrows);
end


%% features evaluation
ntrees = 22;
feat_importance = [];
figure, hold on
for i=1:length(dataREM.clocks)
    
    %Treebagger
    tbg = TreeBagger(ntrees ,dataREM.X{i} ,dataREM.Y{i},'Method','R', 'OOBVarImp','On', 'MinLeafSize',5);
    Yfit = predict(tbg,X);
    feat_importance = [feat_importance tbg.OOBPermutedVarDeltaError'];
    [val, ind] = sort(tbg.OOBPermutedVarDeltaError,'descend');
    feat_order(1:length(val),i) = info(goodvar(ind));
    subplot(2,3,i), hold on, bar(tbg.OOBPermutedVarDeltaError)
    hold on, subplot(2,3,i+3), plot(0:250), hold on, plot(Y,Yfit,'k.')
    title(dataREM.clocks{i})
    
end


imagesc(center{1}, center{2}, feat_importance)
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Max delta amplitude')
xlim([0 3500]), ylim([0 700])
