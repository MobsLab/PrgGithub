%FreezingSoundBySoundAllManip.m
% lines from AnalysisManipBulbectomySoundBySoundMediansCB

load /media/DataMOBsRAID/ProjetAversion/ManipDec14Bulbectomie/FreezingFullPeriod_median/shamAllMiceBilan_1.5_grille.mat
bilan_Dec14=bilan_indiv;
load /media/DataMOBsRAID/ProjetAversion/ManipFeb15Bulbectomie/FreezingFullPeriod_median/shamAllMiceBilan_1.5_grille.mat
bilan_Feb15=bilan_indiv;
load /media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/FreezingFullPeriod_median/shamAllMiceBilan_1.5_grille.mat
bilan_Nov15=bilan_indiv;
for k=3:4
    BilanAllMice{k}=[bilan_Dec14{k};bilan_Feb15{k};bilan_Nov15{k}];
end

groupFig=figure;
        set(groupFig,'color',[1 1 1],'Position',[81    77   906   806])

% EXT pleth
subplot(1,2,1)
plot(BilanAllMice{3},'Color',[0.7 0.7 0.7]),hold on;
plot(prctile(BilanAllMice{3},75)), hold on;
plot(prctile(BilanAllMice{3},50),'LineWidth',2), hold on;
plot(prctile(BilanAllMice{3},25)), hold on;
legend('3rd quartile','median','1st quartile')
%PlotErrorBarNJL((BilanAllMice{3}),'newfig',0,'paired',1,'optiontest','ranksum','ColumnTest', ColTest) % test : paired ranksum relative to column 1
title(StepName{3})
ylim([0 1])
ylabel(['col test = ' num2str(ColTest)])
set(gca,'XTick',[1 2 6],'XTickLabel',{'noS','CS-','CS+'})
%text(-1.5,1.05, groupname{g}, 'FontSize', 15);

% EXT envB
subplot(1,2,2)
plot(BilanAllMice{4},'Color',[0.7 0.7 0.7]),hold on;
plot(prctile(BilanAllMice{4},75)), hold on;
plot(prctile(BilanAllMice{4},50),'LineWidth',2), hold on;
plot(prctile(BilanAllMice{4},25)), hold on;
legend('3rd quartile','median','1st quartile')
%PlotErrorBarNJL((BilanAllMice{4}),'newfig',0,'paired',1,'optiontest','ranksum','ColumnTest', ColTest)
title(StepName{4})
ylim([0 1])
ylabel(['col test = ' num2str(ColTest)])
set(gca,'XTick',[1 2 6 10 14],'XTickLabel',{'noS','CS-','CS+'})
text(4.5,1.05, ['th ' num2str(freezeTh)], 'FontSize', 15);
set(groupFig, 'PaperPosition', [1 1 15 9])
%set(groupFig, 'PaperPosition', [1 1 7.5 4.5)