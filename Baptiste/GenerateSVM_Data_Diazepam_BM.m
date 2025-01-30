


DoZscore = 0;
ParToKeep = {[1:8],[2:8],[1,4:8],[1,2,3,6:8],[1:5,7,8],[1:6],[1,4,5,7:8]};
ParNames = {'All','NoResp','NoHear','NoOB','NoRip','NoHpc','NoRipNoHeart'};
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';


%% Load data
% Controls
clear DATA_Ctrl
for n= 1:8
    DATA_Ctrl(n,:) = [OutPutData.(Drug_Group{Group(1)}).(Session_type{sess}).(Params{n}).mean(:,5)' OutPutData.(Drug_Group{Group(1)}).(Session_type{sess}).(Params{n}).mean(:,6)'];
end

% Drug mice
clear DATA_Drug
for n=1:8
    DATA_Drug(n,:) = [OutPutData.(Drug_Group{Group(2)}).(Session_type{sess}).(Params{n}).mean(:,5)' OutPutData.(Drug_Group{Group(2)}).(Session_type{sess}).(Params{n}).mean(:,6)'];
end


for parToUse = 1:length(ParNames)
    
    %% Contols train and test
    % Only keep subset of parameters
    DATA2 = DATA_Ctrl(ParToKeep{parToUse},:);
    
    % Only keep mice with no NaNs
    totnummice_train = size(DATA2,2)/2;
    BadGuys = sum(isnan(DATA2))>0;
    BadGuys = BadGuys(1:totnummice_train) + BadGuys(totnummice_train+1:end);
    GoodGuys = find(BadGuys==0);
    BadGuys = [BadGuys,BadGuys]>0;
    
    DATA2(:,BadGuys)=[];
    totnummice_train = size(DATA2,2)/2;
    if DoZscore
        Remstd = std(DATA2');
        RemMn = mean(DATA2');
        DATA2 = zscore(DATA2')';
    end
    
    classifier_controltrain = fitcsvm(DATA2',[zeros(1,size(DATA2,2)/2),ones(1,size(DATA2,2)/2)],'ClassNames',[0,1]);
    [prediction,scores2_train] = predict(classifier_controltrain,DATA2');
    
    for gg = 1:length(GoodGuys)
        SVMScores_Sk_Ctrl(parToUse,GoodGuys(gg)) = scores2_train(gg,1);
        SVMScores_Sf_Ctrl(parToUse,GoodGuys(gg)) = scores2_train(totnummice_train+gg,1);
        SVMChoice_Sk_Ctrl(parToUse,GoodGuys(gg)) = prediction(gg,1);
        SVMChoice_Sf_Ctrl(parToUse,GoodGuys(gg)) = prediction(totnummice_train+gg,1);
    end
    
    
    %% Drugged train and test
    % Only keep subset of parameters
    DATA2 = DATA_Drug(ParToKeep{parToUse},:);
    
    % Only keep mice with no NaNs
    totnummice_test = size(DATA2,2)/2;
    BadGuys = sum(isnan(DATA2))>0;
    BadGuys = BadGuys(1:totnummice_test) + BadGuys(totnummice_test+1:end);
    GoodGuys = find(BadGuys==0);
    BadGuys = [BadGuys,BadGuys]>0;
    
    DATA2(:,BadGuys)=[];
    totnummice_test = size(DATA2,2)/2;
    
    if DoZscore
        for pp = 1 : size(DATA2,1)
            DATA2(pp,:) = (DATA2(pp,:) - RemMn(pp))./Remstd(pp);
        end
    end
    [prediction,scores2_test] = predict(classifier_controltrain,DATA2');
    
    for gg = 1:length(GoodGuys)
        SVMScores_Sk(parToUse,GoodGuys(gg)) = scores2_test(gg,1);
        SVMScores_Sf(parToUse,GoodGuys(gg)) = scores2_test(totnummice_test+gg,1);
        SVMChoice_Sk(parToUse,GoodGuys(gg)) = prediction(gg,1);
        SVMChoice_Sf(parToUse,GoodGuys(gg)) = prediction(totnummice_test+gg,1);
        
    end
    
%     % Put the data together and make graph
%     A = {scores2_train(1:totnummice_train,1),scores2_test(1:totnummice_test,1),scores2_train(totnummice_train+1:end,1),scores2_test(totnummice_test+1:end,1)};
%     subplot(1,5,parToUse)
%     MakeSpreadAndBoxPlot2_SB(A,{[1,1,0.4],[0.8,0.2,0.2],[0.4,1,1],[0.2,0.2,0.8]},1:4,{'Ctrl_Shock','RipInhib_Shock','Ctrl_Safe','RipInhib_Sfra'},'paired',0)
%     ylabel('score pos=shock, neg=safe')
%     makepretty
%     title(ParNames{parToUse})
%     line(xlim,[0 0])
%     yl = max(abs(ylim));
%     ylim([-yl yl])
end

%% Figures

% Get rid of mice that were missint variables
SVMChoice_Sf(SVMScores_Sf==0) = NaN;
SVMScores_Sf(SVMScores_Sf==0) = NaN;
SVMChoice_Sk(SVMScores_Sk==0) = NaN;
SVMScores_Sk(SVMScores_Sk==0) = NaN;

SVMChoice_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMScores_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMChoice_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;
SVMScores_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;

%% Average over all parameters
Xlab = {'Sal Shock','FlxChr Shock','Sal Safe','FlxChr Safe'};
Cols = {[1,0.5,0.5],[0.7,0.3,0.3],[0.5,0.5,1],[0.3,0.3,0.7]};

figure
subplot(121)
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot3_SB(A,Cols,[1,1.7,3,3.7],Xlab,'showpoints',1,'paired',0)
ylabel('SVM score')

line(xlim,[0 0],'color','k')
yl = max(abs(ylim));
ylim([-yl yl])
xtickangle(45)
[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});
sigstar_DB({[1,1.7],[3,3.7]},p)


subplot(122)
A = {nanmean(1-SVMChoice_Sk_Ctrl),nanmean(1-SVMChoice_Sk),nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf)};
PlotErrorBarN_KJ(A,'barcolors',Cols,'newfig',0,'showpoints',0,'x_data',[1,2,3.5,4.5])
set(gca,'XTick',1:4,'XtickLabel',Xlab)
xtickangle(45)
ylabel('accuracy')
makepretty
ylim([0 1.1])
[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});
sigstar_DB({[1,2],[3.5,4.5]},p)


[p,h,stat] = ranksum(nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk))
[p,h,stat] = ranksum(nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf))
[p,h,stat] = ranksum(nanmean(SVMChoice_Sk_Ctrl),nanmean(SVMChoice_Sk))
[p,h,stat] = ranksum(nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf))






