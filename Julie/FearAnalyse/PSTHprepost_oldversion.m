% first code to compare  Pre sound /post sound period in PSTH
% Julie Decembre 2014
% out of date now
% SEE  function FigBILANObsFreez(folder,varargin)
 

E2z=zscore(E2);
E3z=zscore(E3);
E1z=zscore(E1);

E2z=(E2);
E3z=(E3);
E1z=(E1);
P2z=(P2);
P3z=(P3);
P1z=(P1);
C2z=(C2);
C3z=(C3);
C1z=(C1);

ColorPSTH={ 'k','r',[1 0.5 0]}; 
%%%%%% definition of time periods
post=55:80;
pre=15:40;
%%%%%%%%%%%% CONDITIONING %%%%%%%%%%%%%%
% BULBECTOMIE (1:7)
id=1:5;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t2/1E3,nanmean(C2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('COND Bulb')
subplot(3,2,3), plot(t3/1E3,nanmean(C3z(:,id)'),'linewidth',2,'Color', ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t1/1E3,nanmean(C1z(:,id)'),'linewidth',2,'Color', ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(C2z(pre,id))',nanmean(C2z(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(C3z(pre,id))',nanmean(C3z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(C1z(pre,id))',nanmean(C1z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [20 40 300 900]) 
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_COND_Bulb.fig')
saveas(gcf, 'PrePost_COND_Bulb.png')
% SHAM (7:14)
id=6:10;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t2/1E3,nanmean(C2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('COND Sham')
subplot(3,2,3), plot(t3/1E3,nanmean(C3z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t1/1E3,nanmean(C1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(C2z(pre,id))',nanmean(C2z(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(C3z(pre,id))',nanmean(C3z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(C1z(pre,id))',nanmean(C1z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [320 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_COND_Sham.fig')
saveas(gcf, 'PrePost_COND_Sham.png')

%%%%%%% EXT plethysmo %%%%%%%%%%%%%
% BULBECTOMIE (1:7)
id=1:7;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t2/1E3,nanmean(P2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('EXT Pleth Bulb')
subplot(3,2,3), plot(t3/1E3,nanmean(P3z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t1/1E3,nanmean(P1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(P2z(pre,id))',nanmean(P2z(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(P3z(pre,id))',nanmean(P3z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(P1z(pre,id))',nanmean(P1z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [620 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTpleth_Bulb.fig')
saveas(gcf, 'PrePost_EXTpleth_Bulb.png')

% SHAM (7:14)
id=7:14;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t2/1E3,nanmean(P2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'), title('EXT Pleth Sham')
subplot(3,2,3), plot(t3/1E3,nanmean(P3z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t1/1E3,nanmean(P1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(P2z(pre,id))',nanmean(P2z(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(P3z(pre,id))',nanmean(P3z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(P1z(pre,id))',nanmean(P1z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [920 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTpleth_Sham.fig')
saveas(gcf, 'PrePost_EXTpleth_Sham.png')


%%%%%%% EXT environment B %%%%%%%%%%%%%
% BULBECTOMIE (1:7)
id=1:5;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t2/1E3,nanmean(E2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('EXT envB Bulb')
subplot(3,2,3), plot(t3/1E3,nanmean(E3z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t1/1E3,nanmean(E1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(E2z(pre,id))',nanmean(E2z(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(E3z(pre,id))',nanmean(E3z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(E1z(pre,id))',nanmean(E1z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [1220 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTenvB_Bulb.fig')
saveas(gcf, 'PrePost_EXTenvB_Bulb.png')

% SHAM (7:14)
id=6:10;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t2/1E3,nanmean(E2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('EXT envB Sham')
subplot(3,2,3), plot(t3/1E3,nanmean(E3z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t1/1E3,nanmean(E1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(E2z(pre,id))',nanmean(E2z(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(E3z(pre,id))',nanmean(E3z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(E1z(pre,id))',nanmean(E1z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [1520 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTenvB_Sham.fig')
saveas(gcf, 'PrePost_EXTenvB_Sham.png')
