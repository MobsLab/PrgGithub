

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_DZP.mat')


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

Xlab = {'Shock','Shock','Safe','Safe'};
% Cols = {[1,0.5,0.5],[0.8,0.2,0.2],[0.5,0.5,1],[0.2,0.2,0.8]};
Cols = {[1,0.5,0.5],[1,0.8,0.8],[0.5,0.5,1],[0.8,0.8,1]};



fig = figure;
subplot(121)
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot_BM(A,Cols,[1,1.7,3,3.7],Xlab,1,0)
ylabel('SVM score')
makepretty
line(xlim,[0 0],'color','k')
yl = max(abs(ylim));
ylim([-yl yl])
xtickangle(45)
[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});
sigstar_DB({[1,1.7],[3,3.7]},p)


subplot(122)
A = {nanmean(1-SVMChoice_Sk_Ctrl),nanmean(1-SVMChoice_Sk),nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf)};
PlotErrorBarN_KJ(A,'barcolors',Cols,'newfig',0,'showpoints',0,'x_data',[1,2,3.5,4.5],'ShowSigstar','none')
set(gca,'XTick',1:4,'XtickLabel',Xlab)
xtickangle(45)
ylabel('accuracy')
makepretty
ylim([0 1.1])
[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});
sigstar_DB({[1,2],[3.5,4.5]},p)

%% stats
[p,h,stat] = ranksum(nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk))
[p,h,stat] = ranksum(nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf))
[p,h,stat] = ranksum(nanmean(SVMChoice_Sk_Ctrl),nanmean(SVMChoice_Sk))
[p,h,stat] = ranksum(nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf))