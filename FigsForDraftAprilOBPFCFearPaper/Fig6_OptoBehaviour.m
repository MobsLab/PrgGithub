cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/Acc_Mice_below50_removed
load('EXT-24_fullperiod_close2sound_acc.mat')

col2plot=[3 4 5];
stepN=2;
%%%

figure
CHRMiceFz=bilan{stepN}(chr2mice,col2plot)*100;
for k= 1 :3
    a=iosr.statistics.boxPlot(k,CHRMiceFz(:,k),'boxColor',[0.8 0.8 1],'lineColor',[0.8 0.8 1],'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
    a.handles.medianLines.LineWidth = 5;
    hold on
end
xlim([0 4])
ylim([0 110])
handlesplot=plotSpread(CHRMiceFz,'distributionColors','k','xValues',1:3,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(CHRMiceFz,'distributionColors',[0.6,0.6,0.6]*0.5,'xValues',1:3,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',1:3,'XTickLabel',{'CS-','CS+','CS+laser'},'FontSize',15,'linewidth',1.5,'Ytick',[0:20:100])
ylabel('% time freezing')

figure
GFPMiceFz=bilan{stepN}(gfpmice,col2plot)*100;
for k= 1 :3
    a=iosr.statistics.boxPlot(k,GFPMiceFz (:,k),'boxColor',[0.5 0.9 0.5],'lineColor',[0.5 0.9 0.5],'medianColor','k','boxWidth',0.5,'showOutliers',false);
    a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
    a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
     a.handles.medianLines.LineWidth = 5;

    hold on
end
xlim([0 4])
ylim([0 110])
handlesplot=plotSpread(GFPMiceFz,'distributionColors','k','xValues',1:3,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',30)
handlesplot=plotSpread(GFPMiceFz,'distributionColors',[0.6,0.6,0.6],'xValues',1:3,'spreadWidth',0.2), hold on;
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',1:3,'XTickLabel',{'CS-','CS+','CS+laser'},'FontSize',15,'linewidth',1.5,'Ytick',[0:20:100])
ylabel('% time freezing')




%% Calculation of effect sizes
for sessnum = 1:3
s_cohen_num = (length(CHRMiceFz(:,sessnum))-1)*var(CHRMiceFz(:,sessnum))+(length(GFPMiceFz(:,sessnum))-1)*var(GFPMiceFz(:,sessnum));
s_cohen_denom = length(CHRMiceFz(:,sessnum)) + length(GFPMiceFz(:,sessnum))-2;
s_cohen = sqrt(s_cohen_num./s_cohen_denom);
Size_Effect = (nanmean(CHRMiceFz(:,sessnum))-nanmean(GFPMiceFz(:,sessnum)))./s_cohen
end

s_cohen_num = (length(GFPMiceFz(:,2))-1)*var(GFPMiceFz(:,2))+(length(GFPMiceFz(:,3))-1)*var(GFPMiceFz(:,3));
s_cohen_denom = length(GFPMiceFz(:,2)) + length(GFPMiceFz(:,3))-2;
s_cohen = sqrt(s_cohen_num./s_cohen_denom);
Size_Effect = (nanmean(GFPMiceFz(:,2))-nanmean(GFPMiceFz(:,3)))./s_cohen

s_cohen_num = (length(CHRMiceFz(:,2))-1)*var(CHRMiceFz(:,2))+(length(CHRMiceFz(:,3))-1)*var(CHRMiceFz(:,3));
s_cohen_denom = length(CHRMiceFz(:,2)) + length(CHRMiceFz(:,3))-2;
s_cohen = sqrt(s_cohen_num./s_cohen_denom);
Size_Effect = (nanmean(CHRMiceFz(:,2))-nanmean(CHRMiceFz(:,3)))./s_cohen

