% DataFigSupp_FearEXT24_TotalDistPost
% 19.07.2017

% stats barplot freezing with removal of the 2 mice with high traveled dist
% in OF test the day after the fear test (272 and 274)
% BBXBehav.m
cd /media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/FreezingFullPeriod
load('shamAllMiceBilan_1.5_grille.mat','bilan')
Fr24_sham=bilan{1,3};
load('bulbAllMiceBilan_1.5_grille.mat','bilan')
Fr24_bulb=bilan{1,3};
% Fr24_bulb([4 6],:)=[];
% remiove first column
Fr24_sham(:,1)=[];
Fr24_bulb(:,1)=[];
data=[Fr24_sham;Fr24_bulb];
gen=[ones(size(Fr24_sham));zeros(size(Fr24_bulb))];
len=size(gen,1);
% ses=[ones(len,1) 2*ones(len,1) 3*ones(len,1) 3*ones(len,1) 4*ones(len,1)];
ses=[ones(len,1) 2*ones(len,1) 3*ones(len,1) 3*ones(len,1)];
[p,t,stats]=anovan(data(:),{gen(:),ses(:)},'interaction')


for k=1:4
[p_{k},h{k},zval{k}]=ranksum(Fr24_sham(:,k),Fr24_bulb(:,k));
end
save DataFigSupp_FearEXT24_TotalDistPost_stats_no272_no274 p_ h zval
 
save data_with_2_obx_mice_already_hyperactive

%% Correlation FearEXT24 TotalDistPost
% see also CorrFreezingActivity.m
sav=0;
type='Spearman';
Gpcolor={[0.7 0.7 0.7], 'k'};
cd /media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/FreezingFullPeriod
load DataFigSupp_FearEXT24_TotalDistPost
res=pwd; 

[r1,p1]=corr(H1,F1,'type',type);
[r2,p2]=corr(H2,F2,'type',type);
[r,p]=corr([H1;H2],[F1;F2],'type',type);

figSupp=figure ('Position',[          437         540        1181         322]);
subplot(132)
scatter(H1,F1,'MarkerFaceColor', Gpcolor{1},'MarkerEdgeColor', 'k'), hold on
title([ 'sham R ' sprintf('%.2f',(r1)) '  p ' sprintf('%.2f',(p1)) ])
XLsham=xlim;
YLsham=ylim;
xlabel('Travel distance in openfield')
ylabel('freezing')

subplot(133),
scatter(H2,F2,'MarkerFaceColor', Gpcolor{2},'MarkerEdgeColor', 'k')
title([ 'bulb R ' sprintf('%.2f',(r2)) '  p ' sprintf('%.2f',(p2)) ])
XLbulb=xlim;
YLbulb=ylim;
xlabel('Travel distance in openfield')
ylabel('freezing')

subplot(132)
xlim([0 max(XLsham(2),XLbulb(2))])
ylim([0 max(YLsham(2),YLbulb(2))])
subplot(133)
xlim([0 max(XLsham(2),XLbulb(2))])
ylim([0 max(YLsham(2),YLbulb(2))])


if sav
   saveas(gcf, 'DataFigSupp_FearEXT24_TotalDistPost.fig')
   saveFigure(gcf, 'DataFigSupp_FearEXT24_TotalDistPost',res)
end

%% Barplot TotalDistPost and +6j
cd /media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/Hyperactivity
load Hyperactivity_5
res=pwd;
% check normality
data=[TotalDistanceTable{1,1}(:,[2 3]);TotalDistanceTable{1,2}(:,[2 3])];
% [h,p,kstat] = lillietest(data(:));
% figure, hist(data,25);
% title(['normality lillietest p=' sprintf('%0.2f',p)])
figure(figSupp)
subplot(131)
plotSpread({TotalDistanceTable{1,1}(:,[2]); TotalDistanceTable{1,2}(:,[2]); TotalDistanceTable{1,1}(:,[3]); TotalDistanceTable{1,2}(:,[3])},'distributionColors',{[0.7 0.7 0.7],'k',[0.7 0.7 0.7],'k'},'distributionMarkers','o');
mk = findall(gca,'marker','o');
set(mk([ 2 4 ]),'MarkerFaceColor',[0.7 0.7 0.7])
set(mk([1 3]),'MarkerFaceColor','k')
set(mk,'MarkerEdgeColor','k')
% set(mk,'markersize',15);
% 'MarkerFaceColor', Gpcolor{2},'MarkerEdgeColor', 'k')

set(gca,'XTickLabel',{'ctrl','obx','ctrl','obx'})
R=[nanmedian(TotalDistanceTable{1,1}(:,[2])); nanmedian(TotalDistanceTable{1,2}(:,[2])); nanmedian(TotalDistanceTable{1,1}(:,[3])); nanmedian(TotalDistanceTable{1,2}(:,[3]))];
for i=1:4
    line(i+[-0.2 0.2],R(i)+[0 0],'Color','k','Linewidth',2);
end

[p1, h, stats1]=ranksum(TotalDistanceTable{1,1}(:,2),TotalDistanceTable{1,2}(:,2));

[p2, h, stats2]=ranksum(TotalDistanceTable{1,1}(:,3),TotalDistanceTable{1,2}(:,3));
title(['ranksum  p1 '  sprintf('%0.3f',p1) ' p2 '  sprintf('%0.3f',p2)])

ylim([0 7000])
if sav
    save Hyperactivity_5_for_paper p1 stats1 p2 stats2
    saveas(figSupp,'Hyperactivity_5_for_paper.fig')
    saveFigure(figSupp,'Hyperactivity_5_for_paper',res)
end
