% LightEffect_chr2_gfp_ctrl_accelero_nicefig.m
% 25.10.2017
% plots data produced by Light_effect_on_Matlab_behav_mar2_jul_oct17.m

sav=1;
StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
stepN=2;

cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/Acc_Mice_below50_removed/
res=pwd;
% load([StepName{stepN} '_fullperiod_close2sound'])
load([StepName{stepN} '_fullperiod_close2sound_acc'])

period='fullperiod'; optionfullper='close2sound';

StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
figure ('Position',[ 507         517       1571         312])
n=5; 
k=1;
col2plot=[3 4 5]; 
coltest=find(col2plot==3);%
colCSplu=4; colCSpluLas=5;

Gpcolor={[0.5 0 0],[0 0 0.5]};
X1=[0.8:1:(size(Table{1,1},2)-0.2)];
X2=[1.2:1:(size(Table{1,2},2)+0.2)];
multiX1=[];
multiX2=[];
for i=1:size(Table{1,1}, 1)
    multiX1=[multiX1; X1];
end
for i=1:size(Table{1,2}, 1)
    multiX2=[multiX2; X2];
end
%% GFP
Table{1,1}=bilan{stepN}(gfpmice,col2plot);
Table{1,2}=bilan{stepN}(chr2mice,col2plot);

subplot(1,n,k), k=k+1;
bar(X1,median(Table{1,1}),'FaceColor',[0.7 0.7 0.7], 'BarWidth', 0.35);hold on; % important to flip the matrices to have them correctlmy plotted
plot(multiX1',Table{1,1}','-','Color',[0.5 0.5 0.5],'LineWidth', 0.5); % 'SizeData',15
scatter(multiX1(:),Table{1,1}(:),'Marker','o','MarkerEdgeColor','k', 'MarkerFaceColor',[0.5 0.5 0.5],'LineWidth', 1,'SizeData',12); % 'SizeData',15

[p4_gf, h, stats_gf]=signrank(bilan{stepN}(gfpmice,colCSplu), bilan{stepN}(gfpmice,colCSpluLas));
xlabel([ 'p ' sprintf('%0.3f',p4_gf) ])
ylim([0 1]), title('GFP')
set(gca,'XTick',[1 2 3],'XTickLabel',{'CS-','CS+', 'CS+ las'})
ylabel([StepName{stepN} ' ' optionfullper ])
text(-0.2,1.05,[period],'units','normalized')

%% ChR2
subplot(1,n,k), k=k+1;
bar(X2,nanmedian(Table{1,2})','FaceColor',[0.7 0.7 0.7], 'BarWidth', 0.35);hold on;
plot(multiX2',Table{1,2}','-','Color',[0.5 0.5 0.5],'LineWidth', 0.5); % 'SizeData',15
scatter(multiX2(:),Table{1,2}(:),'Marker','o','MarkerEdgeColor','k', 'MarkerFaceColor',[0.5 0.5 0.5], 'LineWidth', 1,'SizeData',12);
ylim([0 1]), title('ChR2')

[p4_ch, h, stats_ch]=signrank(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(chr2mice,colCSpluLas));
xlabel([ 'p ' sprintf('%0.3f',p4_ch) ])
set(gca,'XTick',[1 2 3],'XTickLabel',{'CS-','CS+', 'CS+ las'})


if sav
cd(res)
h=gcf;
saveas(gcf,['LightEffect_chr2_gfp_ctrl' StepName{stepN} '_MI_medianbar.fig']);
saveFigure(h.Number,['LightEffect_chr2_gfp_ctrl_' StepName{stepN} '_MI_medianbar'],res);
saveas(gcf,['LightEffect_chr2_gfp_ctrl' StepName{stepN} '_MI_nice2.fig']);
saveFigure(gcf,['LightEffect_chr2_gfp_ctrl_' StepName{stepN} '_MI_nice2'],res);
end











if 0


%% GFP
subplot(1,n,k), k=k+1;
PlotErrorBarN(bilan{stepN}(gfpmice,col2plot),0,1,'ranksum',coltest)
[p4_gf, h, stats]=signrank(bilan{stepN}(gfpmice,colCSplu), bilan{stepN}(gfpmice,colCSpluLas));
xlabel([ 'p ' sprintf('%0.3f',p4_gf) ])
ylim([0 1]), title('GFP')
set(gca,'XTick',[1 2 3],'XTickLabel',{'CS-','CS+', 'CS+ las'})

%% ChR2
subplot(1,n,k), k=k+1;
PlotErrorBarN(bilan{stepN}(chr2mice,col2plot),0,1,'ranksum',coltest) % newfig=0; paired=1,columntest=2
ylim([0 1]), title('ChR2')
text(-0.2,1.05,[period],'units','normalized')
ylabel([StepName{stepN} ' ' optionfullper ])
[p4_ch, h, stats]=signrank(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(chr2mice,colCSpluLas));
xlabel([ 'p ' sprintf('%0.3f',p4_ch) ])
set(gca,'XTick',[1 2 3],'XTickLabel',{'CS-','CS+', 'CS+ las'})



%% CTRL
% subplot(1,n,k), k=k+1;
% PlotErrorBarN(bilan_CTRL{stepN}(:,:),0,1,'ranksum',2)
% [p4_gf, h, stats]=signrank(bilan_CTRL{stepN}(:,colCSplu), bilan_CTRL{stepN}(:,colCSpluLas));
% xlabel([ 'p ' sprintf('%0.3f',p4_gf) ])
% ylim([0 1]), title('CTRL')
% 

%% GFP & ChR2 mean
subplot(1,n,k), k=k+1;
% errorbar(nanmean(bilan{stepN}(chr2mice,:),1), nanstd(bilan{stepN}(chr2mice,:),1)/(size(bilan{stepN}(chr2mice,:),1)^0.5),'Color',[0.7 0 0],'LineWidth',2);%/(size(bilan{stepN},1)^0.5) 
% hold on
% errorbar(nanmean(bilan{stepN}(gfpmice,:),1), nanstd(bilan{stepN}(gfpmice,:),1)/(size(bilan{stepN}(gfpmice,:),1)^0.5),'Color',[0 0 0.7],'LineWidth',2);%/(size(bilan{stepN},1)^0.5)
% errorbar(nanmean(bilan_CTRL{stepN}(:,:),1), nanstd(bilan_CTRL{stepN}(:,:),1)/(size(bilan_CTRL{stepN}(:,:),1)^0.5),'Color',[0.7 0.7 0.7],'LineWidth',2);%/(size(bilan{stepN},1)^0.5)
% legend('chr2','gfp','ctrl')
% xlim([0 size(bilan{stepN},2)+1])
% ylim([0 1]), legend(['chr2 -' num2str(length(chr2mice))],['gfp -' num2str(length(gfpmice))],['ctrl -'  num2str(size(bilan_CTRL{stepN},1))])
% 
% 
% % h=bar([nanmean(bilan{stepN}(chr2mice,:),1); nanmean(bilan{stepN}(gfpmice,:),1); nanmean(bilan_CTRL{stepN}([1 3:end],:),1)]');
% %  set(h(1),'FaceColor',[0.5 0 0]); set(h(2),'FaceColor',[0 0 0.5]);set(h(3),'FaceColor',[0 0.5 0.5]);
% 
% % [p3_gfp, h, stats]=signrank(bilan{stepN}(gfpmice,colCSplu), bilan{stepN}(gfpmice,colCSpluLas));
% % xlabel([ 'p ' sprintf('%0.3f',p3_gfp) ]);
% % title( StepName{stepN})
% % [p2, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(gfpmice,colCSplu));
% % [p3, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(gfpmice,colCSplu));
% % [p4, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSpluLas), bilan{stepN}(gfpmice,colCSpluLas));
% % xlabel([ 'p3 ' sprintf('%0.3f',p3)  '  p4 ' sprintf('%0.3f',p4) ])
% 
% % 
Table{1,1}=bilan{stepN}(gfpmice,col2plot);
Table{1,2}=bilan{stepN}(chr2mice,col2plot);

BarPlotBulbSham_gen(Table,StepName{stepN},{[0.5 0 0],[0 0 0.5]},'ranksum',1,n,k-1,'indivdots',1)

ylim([0 1])
legend(['chr2 -' num2str(length(chr2mice))],['gfp -' num2str(length(gfpmice))])

%% GFP & ChR2 median
subplot(1,n,k), k=k+1;
BarPlotBulbSham_gen(Table,StepName{stepN},{[0.5 0 0],[0 0 0.5],},'ranksum',1,n,k-1,'indivdots',1,'errorbar','median')
% for sp=1:3
%     subplot(1,n,sp), hold on
%     abscis=[2 ];
%     line([abscis-0.4;abscis+0.4],[0 0],'Color','g','LineWidth',2); 
%     abscis=[3];
%     line([abscis-0.4;abscis+0.4]',[0 0],'Color','b','LineWidth',2); 
%     abscis=[4 5 6 ];
%     line([abscis-0.4;abscis+0.4]',[0 0],'Color','c','LineWidth',2); 
% 
% end

%% Modulation index
subplot(1,n,k), k=k+1;
MI_chr2=(bilan{stepN}(chr2mice,colCSpluLas)-bilan{stepN}(chr2mice,colCSplu))./(bilan{stepN}(chr2mice,colCSpluLas) + bilan{stepN}(chr2mice,colCSplu));
MI_gfp=(bilan{stepN}(gfpmice,colCSpluLas)-bilan{stepN}(gfpmice,colCSplu))./(bilan{stepN}(gfpmice,colCSpluLas) + bilan{stepN}(gfpmice,colCSplu));
plot([0 3], [0 0],'Color',[0.7 0.7 0.7])
plotSpread({MI_chr2,MI_gfp},'showMM',1);

[p_ratio_gfp, h, stats]=ranksum(MI_chr2,MI_gfp);
title('Mod Index'),set(gca,'XtickLabel',{'chR2','gfp'});
ylim([-1 1])

% plotSpread({bilan{stepN}(chr2mice,colCSpluLas)./bilan{stepN}(chr2mice,colCSplu),  bilan{stepN}(gfpmice,colCSpluLas)./bilan{stepN}(gfpmice,colCSplu), bilan_CTRL{stepN}(:,colCSpluLas)./bilan_CTRL{stepN}(:,colCSplu) },'showMM',1);%...

%    % 'distributionColors',{[0.7 0 0],[0 0 0.7],[0.7 0.7 0.7]});
% [p_ratio_gfp, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSpluLas)./bilan{stepN}(chr2mice,colCSplu), bilan{stepN}(gfpmice,colCSpluLas)./bilan{stepN}(gfpmice,colCSplu));
% [p_ratio_ctrl, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSpluLas)./bilan{stepN}(chr2mice,colCSplu), bilan_CTRL{stepN}(:,colCSpluLas)./bilan_CTRL{stepN}(:,colCSplu));
% [p_ratio_both, h, stats]=ranksum(bilan{stepN}(chr2mice,colCSpluLas)./bilan{stepN}(chr2mice,colCSplu) , [bilan{stepN}(gfpmice,colCSpluLas)./bilan{stepN}(gfpmice,colCSplu);bilan_CTRL{stepN}(:,colCSpluLas)./bilan_CTRL{stepN}(:,colCSplu)]);
% title('ratio 4/3'),set(gca,'XtickLabel',{'chR2','gfp','ctrl'});
% 
xlabel([ 'p_g_f_p' sprintf('%0.3f',p_ratio_gfp) ]);


if sav
cd(res)
saveas(gcf,['LightEffect_chr2_gfp_ctrl' StepName{stepN} '_MI_nicefig1.fig']);
saveFigure(gcf,['LightEffect_chr2_gfp_ctrl_' StepName{stepN} '_MI_nice'],res);
saveas(gcf,['LightEffect_chr2_gfp_ctrl' StepName{stepN} '_MI_nice2.fig']);
saveFigure(gcf,['LightEffect_chr2_gfp_ctrl_' StepName{stepN} '_MI_nice2'],res);
end


end

